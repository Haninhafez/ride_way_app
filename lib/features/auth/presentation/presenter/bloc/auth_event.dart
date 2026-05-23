part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;
  AuthLoginEvent(this.email, this.password);
}

class AuthRegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  AuthRegisterEvent(this.firstName, this.lastName, this.email, this.password);
}

class AuthRefreshTokenEvent extends AuthEvent {
  final String accessToken;
  final String refreshToken;
  AuthRefreshTokenEvent(this.accessToken, this.refreshToken);
}

class AuthRevokeTokenEvent extends AuthEvent {
  final String accessToken;
  final String refreshToken;
  AuthRevokeTokenEvent(this.accessToken, this.refreshToken);
}
