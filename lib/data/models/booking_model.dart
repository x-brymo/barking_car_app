// data/models/booking_model.dart
class BookingModel {
  final String id;
  final String userId;
  final String parkingSpotId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final String status; // pending, active, completed, cancelled
  final DateTime createdAt;
  
  BookingModel({
    required this.id,
    required this.userId,
    required this.parkingSpotId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });
  
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      userId: json['user_id'],
      parkingSpotId: json['parking_spot_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      totalPrice: json['total_price'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'parking_spot_id': parkingSpotId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}