import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_data_source.dart';
import '../models/user_profile_dto.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<UserProfile> getUserProfile() async {
    final dto = await remoteDataSource.fetchUserProfile();
    return dto.toDomain();
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    final dto = UserProfileDTO.fromDomain(profile);
    final updatedDto = await remoteDataSource.updateUserProfile(dto);
    return updatedDto.toDomain();
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) {
    return remoteDataSource.changePassword(currentPassword, newPassword);
  }

  @override
  Future<String?> getLastPasswordChangeInfo() {
    return remoteDataSource.getLastPasswordChangeInfo();
  }
}
