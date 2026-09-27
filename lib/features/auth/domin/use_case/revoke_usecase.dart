import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';

class RevokeUseCase {
  final AuthRepo _authRepo;
  RevokeUseCase(this._authRepo);
  Future<void> call(String accessToken, String refreshToken) async => await _authRepo.revokeToken(accessToken, refreshToken);
}