import 'package:dartz/dartz.dart';
import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/core/error/failures.dart';
import 'package:ride_way_app/features/auth/data_layer/data_source/auth_data_source.dart';
import 'package:ride_way_app/features/auth/domin/entity/user_entity.dart';
import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';

class AuthImplentationRepo extends AuthRepo {
  final AuthDataSource _authDataSource;

  AuthImplentationRepo(this._authDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    dynamic password,
  ) async {
    try {
      final model = await _authDataSource.login(email, password);
      CacheHelper.saveData(key: ApiKeys.token, value: model.token);
      CacheHelper.saveData(
        key: ApiKeys.refreshToken,
        value: model.refreshToken,
      );
      CacheHelper.saveData(key: ApiKeys.id, value: model.id);
   
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken(
    String accessToken,
    String refreshToken,
  ) async {
    try {
      await _authDataSource.refreshToken(refreshToken, accessToken);
      await CacheHelper.clearData();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String firstName,
    String lastName,
    String email,
    dynamic password,
  ) async {
    try {
      final model = await _authDataSource.register(
        firstName,
        lastName,
        email,
        password,
      );
      CacheHelper.saveData(key: ApiKeys.token, value: model.token);
      CacheHelper.saveData(
        key: ApiKeys.refreshToken,
        value: model.refreshToken,
      );
       CacheHelper.saveData(key: ApiKeys.id, value: model.id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> revokeToken(
    String accessToken,
    String refreshToken,
  ) async {
    try {
      await _authDataSource.revokeToken(refreshToken, accessToken);
      await CacheHelper.clearData();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
