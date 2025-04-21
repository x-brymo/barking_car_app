// Let's implement the repositories
// data/repositories/auth_repository.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/blocs/auth/auth_result.dart';
import '../services/supabase_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final SupabaseService _supabaseService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  AuthRepository(this._supabaseService);
  
  Future<UserModel?> getCurrentUser() async {
    final user = _supabaseService.client.auth.currentUser;
    if (user != null) {
      try {
        final userData = await _supabaseService.fetchUserProfile(user.id);
        return UserModel.fromJson(userData!);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  Future<bool> checkEmailConfirmation() async {
    final user = _supabaseService.client.auth.currentUser;
    return user?.emailConfirmedAt != null;
  }
  Future<void> resendConfirmationEmail() async {
    final user = _supabaseService.client.auth.currentUser;
    if (user != null) {
      await _supabaseService.client.auth.resend(email: user.email!, type: OtpType.email);
    }
  }
  Future<void> confirmEmail(String token) async {
    await _supabaseService.client.auth.verifyOTP(token: token, type: OtpType.email);
  }
  Future<void> resetPassword(String email) async {
    await _supabaseService.client.auth.resetPasswordForEmail(email);
  }
  Future<void> changePassword(String newPassword) async {
    final user = _supabaseService.client.auth.currentUser;
    if (user != null) {
      await _supabaseService.client.auth.updateUser(UserAttributes(password: newPassword));
    }
  }
  Future<String?> getRoleUser()async{
    final user = _supabaseService.client.auth.currentUser;
    if (user != null) {
      try {
        final userData = await _supabaseService.fetchUserProfile(user.id);
        return userData!['role'];
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  
Future<AuthResult> signIn(String email, String password) async {
  try {
    final response = await _supabaseService.signIn(
      email: email,
      password: password,
    );

    if (response.user != null) {
      final userData = await _supabaseService.fetchUserProfile(response.user!.id);
      if (userData != null) {
        final user = UserModel.fromJson(userData);
        await _secureStorage.write(key: 'user_id', value: user.userId);
        await _secureStorage.write(key: 'user_role', value: user.role);
        return AuthSuccess(user);
      } else {
        return AuthFailure("User profile not found.");
      }
    } else {
      return AuthFailure("User not found.");
    }

  } catch (e, stackTrace) {
  print("❌ SignIn Error: ${e.toString()}");
  print("🧵 StackTrace: $stackTrace");

  if (e.toString().contains("Email not confirmed")) {
    return AuthFailure("Please confirm your email.");
  }

  return AuthFailure("Something went wrong: ${e.toString()}");
}}

  
  Future<UserModel?> signUp(String email, String password, String fullName, String msg) async {
    try {
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      print(response.toString());
       return null;
    } catch (e) {
      var msg = e;
      print("Error When SignUP User:${msg.toString()}");
      return null;
    }
  }
  
  Future<void> signOut() async {
    await _supabaseService.signOut();
    await _secureStorage.deleteAll();
  }
  
  Future<bool> updateProfile(String userId, Map<String, dynamic> userData) async {
    try {
      await _supabaseService.updateUserProfile(userId, userData);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<String?> getUserRole() async {
    return await _secureStorage.read(key: 'user_role');
  }
}