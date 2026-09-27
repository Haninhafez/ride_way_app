import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

enum EditProfileStatus { initial, loading, saved, error }

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final UserProfile? profile;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime? dateOfBirth;
  final String? errorMessage;
  final bool isFormValid;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.profile,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phoneNumber = '',
    this.dateOfBirth,
    this.errorMessage,
    this.isFormValid = false,
  });

  factory EditProfileState.initial() {
    return const EditProfileState();
  }

  EditProfileState copyWith({
    EditProfileStatus? status,
    UserProfile? profile,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? errorMessage,
    bool? isFormValid,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        firstName,
        lastName,
        email,
        phoneNumber,
        dateOfBirth,
        errorMessage,
        isFormValid,
      ];
}
