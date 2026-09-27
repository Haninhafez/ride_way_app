import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/usecases/change_password_usecase.dart';
import 'password_security_state.dart';

class PasswordSecurityCubit extends Cubit<PasswordSecurityState> {
  final ChangePasswordUseCase changePasswordUseCase;
  final AccountRepository accountRepository;

  PasswordSecurityCubit({
    required this.changePasswordUseCase,
    required this.accountRepository,
  }) : super(PasswordSecurityState.initial());

  Future<void> loadLastChangedInfo() async {
    emit(state.copyWith(status: PasswordSecurityStatus.loading));
    try {
      final info = await accountRepository.getLastPasswordChangeInfo();
      emit(state.copyWith(
        status: PasswordSecurityStatus.initial,
        lastChangedInfo: info,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PasswordSecurityStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void updateCurrent(String v) {
    emit(state.copyWith(currentPassword: v));
  }

  void updateNew(String v) {
    emit(state.copyWith(newPassword: v));
    _evalPasswordStrength(v);
  }

  void updateConfirm(String v) {
    emit(state.copyWith(confirmPassword: v));
  }

  void toggleCurrentVis() {
    emit(state.copyWith(showCurrent: !state.showCurrent));
  }

  void toggleNewVis() {
    emit(state.copyWith(showNew: !state.showNew));
  }

  void toggleConfirmVis() {
    emit(state.copyWith(showConfirm: !state.showConfirm));
  }

  void _evalPasswordStrength(String pwd) {
    final hasMinChars = pwd.length >= 8;
    final hasUppercase = pwd.contains(RegExp(r'[A-Z]'));
    final hasNumber = pwd.contains(RegExp(r'[0-9]'));

    PasswordStrength strength;
    int score = 0;
    if (hasMinChars) score++;
    if (hasUppercase) score++;
    if (hasNumber) score++;
    if (pwd.length >= 12) score++;

    if (pwd.isEmpty) {
      strength = PasswordStrength.none;
    } else if (score <= 1) {
      strength = PasswordStrength.weak;
    } else if (score == 2) {
      strength = PasswordStrength.medium;
    } else {
      strength = PasswordStrength.strong;
    }

    emit(state.copyWith(
      hasMinChars: hasMinChars,
      hasUppercase: hasUppercase,
      hasNumber: hasNumber,
      passwordStrength: strength,
    ));
  }

  bool validateForm() {
    final currentOk = state.currentPassword.trim().isNotEmpty;
    final newOk = state.newPassword.trim().isNotEmpty;
    final confirmOk = state.confirmPassword.trim().isNotEmpty;
    final matchOk = state.newPassword == state.confirmPassword;
    final strengthOk = state.passwordStrength.index >=
        PasswordStrength.medium.index;
    return currentOk && newOk && confirmOk && matchOk && strengthOk;
  }

  Future<void> updatePassword() async {
    if (!validateForm()) return;
    emit(state.copyWith(status: PasswordSecurityStatus.updating));
    try {
      await changePasswordUseCase.execute(
        state.currentPassword.trim(),
        state.newPassword.trim(),
      );
      emit(state.copyWith(
        status: PasswordSecurityStatus.success,
        currentPassword: '',
        newPassword: '',
        confirmPassword: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PasswordSecurityStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
