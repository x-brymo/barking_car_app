// data/repositories/parking_repository.dart
import '../services/supabase_service.dart';
import '../models/parking_spot_model.dart';

class ParkingRepository {
  final SupabaseService _supabaseService;
  
  ParkingRepository(this._supabaseService);
  
  Future<List<ParkingSpotModel>> getParkingSpots() async {
    try {
      final parkingSpotsData = await _supabaseService.fetchParkingSpots();
      return parkingSpotsData
          .map((data) => ParkingSpotModel.fromJson(data))
          .toList();
    } catch (e) {
      return [];
    }
  }
  
  Future<bool> updateParkingSpotAvailability(String id, bool isAvailable) async {
    try {
      await _supabaseService.updateParkingSpotAvailability(id, isAvailable);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Admin methods
  Future<List<ParkingSpotModel>> getAllParkingSpots() async {
    try {
      final parkingSpotsData = await _supabaseService.fetchAllParkingSpots();
      return parkingSpotsData
          .map((data) => ParkingSpotModel.fromJson(data))
          .toList();
    } catch (e) {
      return [];
    }
  }
  
  Future<ParkingSpotModel?> createParkingSpot(Map<String, dynamic> parkingData) async {
    try {
      final data = await _supabaseService.createParkingSpot(parkingData);
      return ParkingSpotModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> updateParkingSpot(String id, Map<String, dynamic> parkingData) async {
    try {
      await _supabaseService.updateParkingSpot(id, parkingData);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> deleteParkingSpot(String id) async {
    try {
      await _supabaseService.deleteParkingSpot(id);
      return true;
    } catch (e) {
      return false;
    }
  }
  
}