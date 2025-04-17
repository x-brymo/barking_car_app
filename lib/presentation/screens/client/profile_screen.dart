import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/blocs/auth/auth_bloc.dart';
import '../../../presentation/blocs/auth/auth_event.dart';
import '../../../presentation/blocs/auth/auth_state.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  const SizedBox(height: 16),
                  Text(user.fullName,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(user.email,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: "Edit Profile",
                    onPressed: () {
                      // ممكن تفتح صفحة تعديل البيانات
                    },
                  ),
                  const Spacer(),
                  CustomButton(
                    text: "Logout",
                    onPressed: () => _logout(context),
                    textColor: Colors.red,
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("No user data found."));
        },
      ),
    );
  }
}
