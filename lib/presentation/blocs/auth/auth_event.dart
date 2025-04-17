// presentation/blocs/auth/auth_event.dart
abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  
  LoginRequested({
    required this.email,
    required this.password,
  });
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  
  RegisterRequested({
    required this.email,
    required this.password,
    required this.fullName,
  });
}

class LogoutRequested extends AuthEvent {}

class UpdateProfileRequested extends AuthEvent {
  final Map<String, dynamic> userData;
  
  UpdateProfileRequested({
    required this.userData,
  });
}