import 'package:ride_way_app/features/auth/domin/entity/user_entity.dart';
import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';

class LoginUseCase {
  final AuthRepo _authRepo;
  LoginUseCase(this._authRepo);
  
  Future<UserEntity> call(String email, String password) async {
    return await _authRepo.login(email, password);
  }

  
}