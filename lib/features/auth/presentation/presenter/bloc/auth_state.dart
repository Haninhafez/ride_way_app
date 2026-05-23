part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}
class AuthUnauthenticated extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserEntity userModel;
  AuthSuccess(this.userModel);
}

final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
