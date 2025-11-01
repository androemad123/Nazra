// auth_state.dart
import 'package:equatable/equatable.dart';
import '../../models/app_user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final AppUser? user;
  final String? error;

  const AuthState._({
    required this.status,
    this.user,
    this.error,
  });

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated(AppUser user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  const AuthState.loading() : this._(status: AuthStatus.loading);

  const AuthState.failure(String error)
      : this._(status: AuthStatus.failure, error: error);

  @override
  List<Object?> get props => [status, user, error];
}
