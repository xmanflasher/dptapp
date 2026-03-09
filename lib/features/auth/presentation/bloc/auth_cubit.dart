import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dptapp/features/auth/domain/user_profile.dart';
import 'package:dptapp/features/auth/domain/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, authenticating }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserProfile? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.error,
  });

  @override
  List<Object?> get props => [status, user, error];

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthState()) {
    _authRepository.user.listen((user) {
      if (user != null) {
        emit(AuthState(status: AuthStatus.authenticated, user: user));
      } else {
        emit(const AuthState(status: AuthStatus.unauthenticated));
      }
    });
  }

  Future<void> loginMock(String name) async {
    emit(state.copyWith(status: AuthStatus.authenticating));
    try {
      await _authRepository.loginWithMock(name);
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.unauthenticated, error: e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.authenticating));
    try {
      await _authRepository.loginWithGoogle();
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.unauthenticated, error: e.toString()));
    }
  }

  Future<void> loginWithLine() async {
    emit(state.copyWith(status: AuthStatus.authenticating));
    try {
      await _authRepository.loginWithLine();
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.unauthenticated, error: e.toString()));
    }
  }

  Future<void> loginWithFacebook() async {
    emit(state.copyWith(status: AuthStatus.authenticating));
    try {
      await _authRepository.loginWithFacebook();
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.unauthenticated, error: e.toString()));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }

  Future<void> updateProfile(UserProfile profile) async {
    try {
      await _authRepository.updateProfile(profile);
      // Stream subscription will automatically emit new AuthState
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
