import '../entities/user_profile.dart';
import '../repositories/account_repository.dart';

class GetUserProfileUseCase {
  final AccountRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfile> execute() {
    return repository.getUserProfile();
  }
}
