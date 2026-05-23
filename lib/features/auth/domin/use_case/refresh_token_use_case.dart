import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';

class RefreshTokenUseCase {
  final AuthRepo authRepo;

  RefreshTokenUseCase(this.authRepo);

  Future<void> call(String accessToken, String refreshToken) async => await authRepo.refreshToken(accessToken, refreshToken);
}