import 'package:equatable/equatable.dart';

enum PasswordSecurityStatus { initial, loading, updating, success, error }

enum PasswordStrength { none, weak, medium, strong }

class PasswordSecurityState extends Equatable {
  final PasswordSecurityStatus status;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool showCurrent;
  final bool showNew;
  final bool showConfirm;
  final PasswordStrength passwordStrength;
  final bool hasMinChars;
  final bool hasUppercase;
  final bool hasNumber;
  final String? lastChangedInfo;
  final String? errorMessage;

  const PasswordSecurityState({
    this.status = PasswordSecurityStatus.initial,
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.showCurrent = false,
    this.showNew = false,
    this.showConfirm = false,
    this.passwordStrength = PasswordStrength.none,
    this.hasMinChars = false,
    this.hasUppercase = false,
    this.hasNumber = false,
    this.lastChangedInfo,
    this.errorMessage,
  });

  factory PasswordSecurityState.initial() {
    return const PasswordSecurityState();
  }

  PasswordSecurityState copyWith({
    PasswordSecurityStatus? status,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? showCurrent,
    bool? showNew,
    bool? showConfirm,
    PasswordStrength? passwordStrength,
    bool? hasMinChars,
    bool? hasUppercase,
    bool? hasNumber,
    String? lastChangedInfo,
    String? errorMessage,
  }) {
    return PasswordSecurityState(
      status: status ?? this.status,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      showCurrent: showCurrent ?? this.showCurrent,
      showNew: showNew ?? this.showNew,
      showConfirm: showConfirm ?? this.showConfirm,
      passwordStrength: passwordStrength ?? this.passwordStrength,
      hasMinChars: hasMinChars ?? this.hasMinChars,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasNumber: hasNumber ?? this.hasNumber,
      lastChangedInfo: lastChangedInfo ?? this.lastChangedInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentPassword,
        newPassword,
        confirmPassword,
        showCurrent,
        showNew,
        showConfirm,
        passwordStrength,
        hasMinChars,
        hasUppercase,
        hasNumber,
        lastChangedInfo,
        errorMessage,
      ];
}
