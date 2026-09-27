import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  EditProfileCubit({
    required this.updateUserProfileUseCase,
  }) : super(EditProfileState.initial());

  void initFromProfile(UserProfile p) {
    emit(state.copyWith(
      profile: p,
      firstName: p.firstName,
      lastName: p.lastName,
      email: p.email,
      phoneNumber: p.phoneNumber,
      dateOfBirth: p.dateOfBirth,
    ));
    _validateForm();
  }

  void updateFirstName(String v) {
    emit(state.copyWith(firstName: v));
    _validateForm();
  }

  void updateLastName(String v) {
    emit(state.copyWith(lastName: v));
    _validateForm();
  }

  void updateEmail(String v) {
    emit(state.copyWith(email: v));
    _validateForm();
  }

  void updatePhone(String v) {
    emit(state.copyWith(phoneNumber: v));
    _validateForm();
  }

  void updateDob(DateTime v) {
    emit(state.copyWith(dateOfBirth: v));
    _validateForm();
  }

  void _validateForm() {
    final isValid = state.firstName.trim().isNotEmpty &&
        state.lastName.trim().isNotEmpty &&
        state.email.trim().isNotEmpty &&
        state.phoneNumber.trim().isNotEmpty;
    emit(state.copyWith(isFormValid: isValid));
  }

  Future<void> saveChanges() async {
    if (!state.isFormValid) return;
    emit(state.copyWith(status: EditProfileStatus.loading));
    try {
      final currentProfile = state.profile;
      if (currentProfile == null) {
        throw Exception('No profile loaded');
      }
      final updatedProfile = UserProfile(
        id: currentProfile.id,
        firstName: state.firstName.trim(),
        lastName: state.lastName.trim(),
        email: state.email.trim(),
        phoneNumber: state.phoneNumber.trim(),
        dateOfBirth: state.dateOfBirth,
        nationalId: currentProfile.nationalId,
        avatarUrl: currentProfile.avatarUrl,
        tier: currentProfile.tier,
        points: currentProfile.points,
        totalTrips: currentProfile.totalTrips,
        memberSince: currentProfile.memberSince,
        isVerifiedWithNafath: currentProfile.isVerifiedWithNafath,
      );
      final result = await updateUserProfileUseCase.execute(updatedProfile);
      emit(state.copyWith(
        status: EditProfileStatus.saved,
        profile: result,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EditProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
