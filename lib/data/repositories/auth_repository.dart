// Let's implement the repositories
// data/repositories/auth_repository.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
        return UserModel.fromJson(userData);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        final userData = await _supabaseService.fetchUserProfile(response.user!.id);
        final user = UserModel.fromJson(userData);
        
        // Store user data in secure storage
        await _secureStorage.write(key: 'user_id', value: user.id);
        await _secureStorage.write(key: 'user_role', value: user.role);
        
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  Future<UserModel?> signUp(String email, String password, String fullName) async {
    try {
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      
      if (response.user != null) {
        // User data will be created through a Supabase trigger
        // We'll wait for a moment and then fetch the user data
        await Future.delayed(const Duration(seconds: 2));
        
        final userData = await _supabaseService.fetchUserProfile(response.user!.id);
        final user = UserModel.fromJson(userData);
        
        // Store user data in secure storage
        await _secureStorage.write(key: 'user_id', value: user.id);
        await _secureStorage.write(key: 'user_role', value: user.role);
        
        return user;
      }
      return null;
    } catch (e) {
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