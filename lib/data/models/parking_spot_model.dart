// data/models/parking_spot_model.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingSpotModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final double pricePerHour;
  final bool isAvailable;
  final String? imageUrl;
  final DateTime createdAt;
  
  ParkingSpotModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.pricePerHour,
    required this.isAvailable,
    this.imageUrl,
    required this.createdAt,
  });
  
  LatLng get position => LatLng(latitude, longitude);
  
  factory ParkingSpotModel.fromJson(Map<String, dynamic> json) {
    return ParkingSpotModel(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      address: json['address'],
      pricePerHour: json['price_per_hour'].toDouble(),
      isAvailable: json['is_available'] ?? true,
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'price_per_hour': pricePerHour,
      'is_available': isAvailable,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
