// Now, let's implement some key screens for the app
// presentation/screens/shared/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/assets_constants.dart';
import '../../../presentation/blocs/auth/auth_bloc.dart';
import '../../../presentation/blocs/auth/auth_event.dart';
import '../../../presentation/blocs/auth/auth_state.dart';
import '../../../routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkFirstTime();
      }
    });
    
    // Check auth status
    context.read<AuthBloc>().add(CheckAuthStatus());
  }
  
  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    
    if (isFirstTime) {
      // First time user, show onboarding
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.onboarding);
      }
    } else {
      // Not first time, check auth status
      if (mounted) {
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          // User is authenticated, redirect based on role
          if (authState.isAdmin) {
            Navigator.pushReplacementNamed(context, Routes.adminDashboard);
          } else {
            Navigator.pushReplacementNamed(context, Routes.clientHome);
          }
        } else {
          // User is not authenticated, show login
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      }
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              AssetsConstants.splashAnimation,
              controller: _animationController,
              onLoaded: (composition) {
                _animationController
                  ..duration = composition.duration
                  ..forward();
              },
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            const Text(
              'Barking Car',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find the perfect parking spot',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}