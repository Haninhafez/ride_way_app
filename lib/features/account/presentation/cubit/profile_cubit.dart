import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;

  ProfileCubit({
    required this.getUserProfileUseCase,
  }) : super(ProfileState.initial());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profile = await getUserProfileUseCase.execute();
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void toggleNotifications(bool value) {
    emit(state.copyWith(notificationsEnabled: value));
  }

  void toggleDarkMode(bool value) {
    emit(state.copyWith(darkModeEnabled: value));
  }

  void setLanguage(String language) {
    emit(state.copyWith(selectedLanguage: language));
  }

  void toggleLogoutConfirm() {
    emit(state.copyWith(showLogoutConfirm: !state.showLogoutConfirm));
  }

  Future<void> logout() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      emit(ProfileState.initial());
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
