import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/cubit/password_state.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/password_strength_bar.dart';

/// Cubit that handles live password strength evaluation and checklist flags.
///
/// Call [updatePassword] on every keystroke in the password field.
/// The emitted [PasswordState] drives [PasswordStrengthBar] and [ChecklistItem].
class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit() : super(const PasswordState());

  void updatePassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));

    final satisfiedCount = [hasMinLength, hasUppercase, hasNumber]
        .where((b) => b)
        .length;

    final strength = password.isEmpty
        ? PasswordStrength.none
        : satisfiedCount <= 1
            ? PasswordStrength.weak
            : satisfiedCount == 2
                ? PasswordStrength.medium
                : PasswordStrength.strong;

    emit(PasswordState(
      password: password,
      strength: strength,
      hasMinLength: hasMinLength,
      hasUppercase: hasUppercase,
      hasNumber: hasNumber,
    ));
  }

  void reset() => emit(const PasswordState());
}
