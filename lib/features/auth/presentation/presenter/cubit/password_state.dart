import 'package:equatable/equatable.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/password_strength_bar.dart';

/// State emitted by [PasswordCubit] on every password change.
class PasswordState extends Equatable {
  const PasswordState({
    this.password = '',
    this.strength = PasswordStrength.none,
    this.hasMinLength = false,
    this.hasUppercase = false,
    this.hasNumber = false,
  });

  final String password;
  final PasswordStrength strength;
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasNumber;

  @override
  List<Object> get props =>
      [password, strength, hasMinLength, hasUppercase, hasNumber];
}
