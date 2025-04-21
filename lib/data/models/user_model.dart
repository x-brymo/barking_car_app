// data/models/user_model.dart
class UserModel {
  final String userId;
  final String email;
  final String fullname;
  final String avatarUrl;
  final String role;
  final String createdAt;
  final String updatedAt;
  final String phone;
  final String password;
  final String bio;
  final bool isblocked;
  final bool isvip;

  UserModel({
    required this.userId,
    required this.email,
    required this.fullname,
    required this.avatarUrl,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.phone,
    required this.password,
    required this.isblocked,
    required this.isvip,
    required this.bio
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      fullname: json['fullName'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      isblocked: json['isblocked'] ?? false,
      isvip: json['isvip'] ?? false,
      bio: json['bio'] ?? '',
    );
  }

Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'fullName': fullname,
      'avatar_url': avatarUrl,
      'role': role,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'phone': phone,
      'password': password,
      'isblocked': isblocked,
      'isvip': isvip,
      'bio': bio,
    };
  }

  UserModel copyWith({
    String? userId,
    String? email,
    String? fullname,
    String? avatarUrl,
    String? role,
    String? createdAt,
    String? updatedAt,
    String? phone,
    String? password,
    bool? isblocked,
    bool? isvip,
    String? bio,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isblocked: isblocked ?? this.isblocked,
      isvip: isvip ?? this.isvip,
      bio: bio ?? this.bio,
    );
  }

}