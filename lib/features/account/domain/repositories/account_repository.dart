import '../entities/user_profile.dart';

abstract class AccountRepository {
  Future<UserProfile> getUserProfile();
  Future<UserProfile> updateUserProfile(UserProfile profile);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<String?> getLastPasswordChangeInfo();
}
