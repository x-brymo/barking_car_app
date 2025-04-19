// data/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? avatar;
  final String role; // client or admin
  final DateTime createdAt;
  
  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatar,
    required this.role,
    required this.createdAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'] ?? '' ,
      email: json['email']?? '',
      fullName: json['full_name']?? '',
      avatar: json['avatar'],
      role: json['role'] ?? 'client',
      createdAt: DateTime.parse(json['created_at']?? ''),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'email': email,
      'full_name': fullName,
      'avatar': avatar,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }
}