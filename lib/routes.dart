// routes.dart
import 'package:flutter/material.dart';
import 'data/models/parking_spot_model.dart';
import 'presentation/screens/shared/splash_screen.dart';
import 'presentation/screens/shared/onboarding_screen.dart';
import 'presentation/screens/shared/login_screen.dart';
import 'presentation/screens/shared/register_screen.dart';
import 'presentation/screens/client/home_screen.dart';
import 'presentation/screens/client/booking_screen.dart';
import 'presentation/screens/client/history_screen.dart';
import 'presentation/screens/client/profile_screen.dart';
import 'presentation/screens/admin/dashboard_screen.dart';
import 'presentation/screens/admin/parking_management_screen.dart';
late final ParkingSpotModel spot;
class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String clientHome = '/client/home';
  static const String booking = '/client/booking';
  static const String history = '/client/history';
  static const String profile = '/client/profile';
  static const String adminDashboard = '/admin/dashboard';
  static const String parkingManagement = '/admin/parking-management';
  
  static Map<String, WidgetBuilder> getRoutes() {
    
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      clientHome: (context) => const HomeScreen(),
      booking: (context) =>  BookingScreen(spot: spot),
      history: (context) => const HistoryScreen(),
      profile: (context) => const ProfileScreen(),
      adminDashboard: (context) => const DashboardScreen(),
      parkingManagement: (context) => const ParkingManagementScreen(),
    };
  }
}