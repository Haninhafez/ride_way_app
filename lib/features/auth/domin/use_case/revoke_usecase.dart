import 'package:dartz/dartz.dart';
import 'package:ride_way_app/core/error/failures.dart';
import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';

class RevokeUseCase {
  final AuthRepo _authRepo;
  RevokeUseCase(this._authRepo);
  Future<Either<Failure,void>> call(String accessToken, String refreshToken) async => await _authRepo.revokeToken(accessToken, refreshToken);
}