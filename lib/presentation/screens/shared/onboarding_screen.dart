// presentation/screens/shared/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/assets_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes.dart';
import '../../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
        
  final List<Map<String, String>> _pages = [
    {
      'title': 'Find Parking Spots',
      'description': 'Easily find available parking spots near you with our interactive map.',
      'image': AssetsConstants.findparking,
    },
    {
      'title': 'Book in Seconds',
      'description': 'Reserve your parking spot with just a few taps.',
      'image': AssetsConstants.bookingscand,
    },
    {
      'title': 'Track Your Bookings',
      'description': 'Keep track of all your parking bookings in one place.',
      'image': AssetsConstants.trackbooking,
    },
  ];
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          _pages[index]['image']!,
                          height: 300,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          _pages[index]['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _pages[index]['description']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: AppTheme.primaryColor,
                      dotColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _finishOnboarding(),
                        child: const Text('Skip'),
                      ),
                      CustomButton(
                        text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                        onPressed: () {
                          if (_currentPage == _pages.length - 1) {
                            _finishOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}