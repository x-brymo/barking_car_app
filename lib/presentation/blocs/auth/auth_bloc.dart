// Now, let's implement the BLoC classes
// presentation/blocs/auth/auth_bloc.dart
import 'package:barking_car_app/presentation/blocs/auth/auth_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart' hide AuthSuccess;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }
  
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        final role = await _authRepository.getUserRole();
        emit(Authenticated(user: user, isAdmin: role == 'admin'));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
  
  Future<void> _onLoginRequested(
  LoginRequested event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());
  final result = await _authRepository.signIn(event.email, event.password);

      if (result is AuthSuccess) {
        emit(Authenticated(user: result.user, isAdmin: result.user.role == 'admin'));

      } else if (result is AuthFailure) {
        emit(AuthError(message: result.message));
      }
}

  // presentation/blocs/auth/auth_bloc.dart (continued)
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(
        event.email,
        event.password,
        event.fullName,
      );
      if (user != null) {
        emit(Authenticated(user: user, isAdmin: false));
      } else {
        print(state.toString());
        emit(AuthError(message: 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
  
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
  
  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is Authenticated) {
      emit(AuthLoading());
      try {
        final success = await _authRepository.updateProfile(
          currentState.user.id,
          event.userData,
        );
        if (success) {
          final updatedUser = await _authRepository.getCurrentUser();
          if (updatedUser != null) {
            emit(Authenticated(user: updatedUser, isAdmin: currentState.isAdmin));
          } else {
            emit(currentState);
          }
        } else {
          emit(AuthError(message: 'Failed to update profile'));
          emit(currentState);
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
        emit(currentState);
      }
    }
  }
}