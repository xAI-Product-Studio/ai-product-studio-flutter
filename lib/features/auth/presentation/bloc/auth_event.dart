import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

final class AuthRegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [fullName, email, password];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

final class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

final class AuthUserRefreshRequested extends AuthEvent {
  const AuthUserRefreshRequested();
}
