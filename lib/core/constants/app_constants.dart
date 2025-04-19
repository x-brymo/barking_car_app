// core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'Barking Car';
  static const double defaultPadding = 16.0;
  static const double mapDefaultZoom = 15.0;
  
  // Roles
  static const String roleClient = 'client';
  static const String roleAdmin = 'admin';
  static const String roleManager = 'manager';
  
  // Supabase tables
  static const String usersTable = 'profiles';
  static const String parkingSpotsTable = 'parking_spots';
  static const String bookingsTable = 'bookings';
  // supabaseRedirectUrl
  static const String supabaseRedirectUrl = 'io.supabase.barkingcar://login-callback';
}
