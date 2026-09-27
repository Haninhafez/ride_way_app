import '../entities/user_profile.dart';
import '../repositories/account_repository.dart';

class UpdateUserProfileUseCase {
  final AccountRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<UserProfile> execute(UserProfile profile) {
    return repository.updateUserProfile(profile);
  }
}
