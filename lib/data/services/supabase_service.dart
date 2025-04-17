// data/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';

class SupabaseService {
  late final SupabaseClient _client;

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
      data: {
        'full_name': fullName,
        'role': AppConstants.roleClient,
      },
    );
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
    return response;
  }

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
        .eq('id', id);
  }

  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    final response = await _client
        .from(AppConstants.usersTable)
        .select()
        .eq('id', userId)
        .single();
    return response;
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> userData) async {
    await _client
        .from(AppConstants.usersTable)
        .update(userData)
        .eq('id', userId);
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
        .eq('id', id);
  }

  Future<void> deleteParkingSpot(String id) async {
    await _client
        .from(AppConstants.parkingSpotsTable)
        .delete()
        .eq('id', id);
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