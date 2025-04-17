// presentation/blocs/auth/auth_state.dart
import '../../../data/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;
  final bool isAdmin;
  
  Authenticated({
    required this.user,
    required this.isAdmin,
  });
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  AuthError({
    required this.message,
  });
}
class AuthSuccess extends AuthState {
  final UserModel user;
  
  AuthSuccess({
    required this.user,
  });
}