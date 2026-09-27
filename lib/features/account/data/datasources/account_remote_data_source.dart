import '../models/user_profile_dto.dart';

abstract class AccountRemoteDataSource {
  Future<UserProfileDTO> fetchUserProfile();
  Future<UserProfileDTO> updateUserProfile(UserProfileDTO dto);
  Future<void> changePassword(String current, String newPwd);
  Future<String?> getLastPasswordChangeInfo();
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  @override
  Future<UserProfileDTO> fetchUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const UserProfileDTO(
      id: 'usr_1094552831',
      firstName: 'Nasser',
      lastName: 'Al-Harbi',
      email: 'nasser.alharbi@mail.com',
      phoneNumber: '+966 50 123 4567',
      dateOfBirth: '1990-05-15T00:00:00.000Z',
      nationalId: '1094552831',
      avatarUrl: 'assets/profile.png',
      tier: 'Gold',
      points: 12480,
      totalTrips: 34,
      memberSince: '2023',
      isVerifiedWithNafath: true,
    );
  }

  @override
  Future<UserProfileDTO> updateUserProfile(UserProfileDTO dto) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return dto;
  }

  @override
  Future<void> changePassword(String current, String newPwd) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<String?> getLastPasswordChangeInfo() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 'Password was last changed on 2026-05-10';
  }
}
