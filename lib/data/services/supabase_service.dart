// data/services/supabase_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class SupabaseService {
  late final SupabaseClient _client;
  late final SupabaseStorageClient _storage;
final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  Future<void> initialize() async {
    _client = Supabase.instance.client;
  }

  SupabaseClient get client => _client;

  // Auth methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      
    );
     final supabaseUser = _client.auth.currentUser!.id;
      await _client.from('profiles').insert(
        {
      'user_id': supabaseUser,
      'full_name': fullName,
      'role': AppConstants.roleClient,
      'created_at': DateTime.now().toIso8601String(),
      'avatar_url': 'https://avatars.githubusercontent.com/u/1200?v=4',
      'phone': '',                                       
    },
      );
        if (response.user == null) {
      print("State Massages : ${response.user}");
    }
    return response;
    
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final uidUser = _client.auth.currentUser!.id;
    print("State Massages : ${response.user}");
    if (response.user != null) {
      print("State Massages : ${response.user}");
      final res = await _client.from('profiles').select().match({'user_id': uidUser}).maybeSingle();
      
      if (res == null) {
          print("User profile not found");
          return response;
      }
      if (res.isEmpty) {
        print("User profile data is empty");
          return response;
      }
        final user = UserModel.fromJson(res);
        await _secureStorage.write(key: 'user_id', value: user.id);
       await _secureStorage.write(key: 'user_role', value: user.role);
        print("User Role: ${user.role}");
        print("User ID: ${user.id}");
    }
    return response;
  }
//   Future<String?> getUserRole() async {
//   final user = _client.auth.currentUser;

//   if (user == null) return null;

  

//   return res?['role'];
// }


  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Database methods
  Future<List<Map<String, dynamic>>> fetchParkingSpots() async {
    final response = await _client
        .from(AppConstants.parkingSpotsTable)
        .select()
        .eq('is_available', true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchUserBookings(String userId) async {
    final response = await _client
        .from(AppConstants.bookingsTable)
        .select('*, ${AppConstants.parkingSpotsTable}(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    final response = await _client
        .from(AppConstants.bookingsTable)
        .insert(bookingData)
        .select()
        .single();
    return response;
  }

  Future<void> updateParkingSpotAvailability(String id, bool isAvailable) async {
    await _client
        .from(AppConstants.parkingSpotsTable)
        .update({'is_available': isAvailable})
        .eq('user_id', id);
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    final response = await _client
        .from(AppConstants.usersTable)
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return response;
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> userData) async {
    await _client
        .from(AppConstants.usersTable)
        .update(userData)
        .eq('user_id', userId);
  }

  // Admin methods
  Future<List<Map<String, dynamic>>> fetchAllParkingSpots() async {
    final response = await _client
        .from(AppConstants.parkingSpotsTable)
        .select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createParkingSpot(Map<String, dynamic> parkingData) async {
    final response = await _client
        .from(AppConstants.parkingSpotsTable)
        .insert(parkingData)
        .select()
        .single();
    return response;
  }

  Future<void> updateParkingSpot(String id, Map<String, dynamic> parkingData) async {
    await _client
        .from(AppConstants.parkingSpotsTable)
        .update(parkingData)
        .eq('user_id', id);
  }

  Future<void> deleteParkingSpot(String id) async {
    await _client
        .from(AppConstants.parkingSpotsTable)
        .delete()
        .eq('user_id', id);
  }

  Future<Map<String, dynamic>> fetchDashboardStats() async {
    final activeBookings = await _client
        .from(AppConstants.bookingsTable)
        .select('count')
        .eq('status', 'active');
    
    final totalParkingSpots = await _client
        .from(AppConstants.parkingSpotsTable)
        .select('count');
    
    final availableParkingSpots = await _client
        .from(AppConstants.parkingSpotsTable)
        .select('count')
        .eq('is_available', true);
    
    final totalUsers = await _client
        .from(AppConstants.usersTable)
        .select('count')
        .eq('role', AppConstants.roleClient);
    
    return {
      'active_bookings': activeBookings[0]['count'],
      'total_parking_spots': totalParkingSpots[0]['count'],
      'available_parking_spots': availableParkingSpots[0]['count'],
      'total_users': totalUsers[0]['count'],
    };
  }
}