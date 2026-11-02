import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/features/account/domain/entities/user_profile.dart';
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

Future<void> setLanguage(String language,BuildContext context) async {
  final locale = language == 'Arabic'
      ? const Locale('ar')
      : const Locale('en');

  await context.setLocale(locale);

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
  void updateProfile(UserProfile profile) {
emit(state.copyWith(
    status: ProfileStatus.loaded,
    profile: profile,
  ));
}
}
