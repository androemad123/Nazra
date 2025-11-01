// auth_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../repositories/auth_repository.dart';
import '../../models/app_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<AppUser?>? _userSub;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unknown()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);

    // Start listening immediately
    add(AuthAppStarted());
  }

  Future<void> _onAppStarted(AuthAppStarted event, Emitter<AuthState> emit) async {
    await _userSub?.cancel();
    _userSub = _authRepository.authStateChanges().listen((appUser) {
      add(AuthUserChanged(user: appUser));
    });
  }

  Future<void> _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) async {
    final user = event.user;
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final user = await _authRepository.signInWithEmail(email: event.email.trim(), password: event.password);
      emit(AuthState.authenticated(user));
    } on AuthFailure catch (e) {
      emit(AuthState.failure(e.message));
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(const AuthState.failure('Unknown login error'));
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSignUpRequested(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final user = await _authRepository.signUpWithEmail(
          email: event.email.trim(), password: event.password, displayName: event.displayName);
      emit(AuthState.authenticated(user));
    } on AuthFailure catch (e) {
      emit(AuthState.failure(e.message));
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(const AuthState.failure('Unknown sign up error'));
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.signOut();
      emit(const AuthState.unauthenticated());
    } on AuthFailure catch (e) {
      emit(AuthState.failure(e.message));
    } catch (e) {
      emit(const AuthState.failure('Unknown logout error'));
    }
  }

  Future<void> _onPasswordResetRequested(AuthPasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.sendPasswordResetEmail(email: event.email.trim());
      emit(const AuthState.unauthenticated());
    } on AuthFailure catch (e) {
      emit(AuthState.failure(e.message));
    } catch (e) {
      emit(const AuthState.failure('Unknown password reset error'));
    }
  }

  @override
  Future<void> close() {
    _userSub?.cancel();
    return super.close();
  }
}
