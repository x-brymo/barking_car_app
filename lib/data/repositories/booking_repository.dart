// data/repositories/booking_repository.dart
import '../services/supabase_service.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final SupabaseService _supabaseService;
  
  BookingRepository(this._supabaseService);
  
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final bookingsData = await _supabaseService.fetchUserBookings(userId);
      return bookingsData
          .map((data) => BookingModel.fromJson(data))
          .toList();
    } catch (e) {
      return [];
    }
  }
  
  Future<BookingModel?> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final data = await _supabaseService.createBooking(bookingData);
      
      // Update parking spot availability
      await _supabaseService.updateParkingSpotAvailability(
        bookingData['parking_spot_id'],
        false,
      );
      
      return BookingModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }
  
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      return await _supabaseService.fetchDashboardStats();
    } catch (e) {
      return {
        'active_bookings': 0,
        'total_parking_spots': 0,
        'available_parking_spots': 0,
        'total_users': 0,
      };
    }
  }
}