// auth_event.dart
import 'package:equatable/equatable.dart';
import '../../models/app_user.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// App started (listen to auth changes)
class AuthAppStarted extends AuthEvent {}

/// Trigger login
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email];
}

/// Trigger signup
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;

  AuthSignUpRequested({required this.email, required this.password, this.displayName});

  @override
  List<Object?> get props => [email];
}

/// Logout
class AuthLogoutRequested extends AuthEvent {}

/// Password reset
class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Local state update when user changes
class AuthUserChanged extends AuthEvent {
  final AppUser? user;
  AuthUserChanged({required this.user});

  @override
  List<Object?> get props => [user];
}
