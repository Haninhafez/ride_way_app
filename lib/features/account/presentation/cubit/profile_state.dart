import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;
  final String selectedLanguage;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final bool showLogoutConfirm;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.selectedLanguage = 'English',
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.showLogoutConfirm = false,
  });

  factory ProfileState.initial() {
    return const ProfileState();
  }

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? errorMessage,
    String? selectedLanguage,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    bool? showLogoutConfirm,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      showLogoutConfirm: showLogoutConfirm ?? this.showLogoutConfirm,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        errorMessage,
        selectedLanguage,
        notificationsEnabled,
        darkModeEnabled,
        showLogoutConfirm,
      ];
}
