import 'package:ride_way_app/features/auth/domin/entity/user_entity.dart';
import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';

class RegisterUseCase {
  final AuthRepo _authRepo;
  RegisterUseCase(this._authRepo);

  Future<UserEntity> call(String firstName, String lastName, String email,
      String password) async {
    return await _authRepo.register(firstName, lastName, email, password);
  }
}