import '../repositories/account_repository.dart';

class ChangePasswordUseCase {
  final AccountRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> execute(String currentPassword, String newPassword) {
    return repository.changePassword(currentPassword, newPassword);
  }
}
