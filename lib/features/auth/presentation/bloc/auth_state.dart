import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthFailureState extends AuthState {
  final String message;

  const AuthFailureState({required this.message});

  @override
  List<Object> get props => [message];
}

final class AuthForgotPasswordSuccess extends AuthState {
  final String email;

  const AuthForgotPasswordSuccess({required this.email});

  @override
  List<Object> get props => [email];
}
