import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/features/auth/data_layer/data_source/auth_data_source.dart';
import 'package:ride_way_app/features/auth/domin/entity/user_entity.dart';
import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';

class AuthImplentationRepo extends AuthRepo {
  final AuthDataSource _authDataSource;

  AuthImplentationRepo(this._authDataSource);

  @override
  Future<UserEntity> login(String email, dynamic password) async {
    final model = await _authDataSource.login(email, password);
    CacheHelper.saveData(key: ApiKeys.token, value: model.token);
    CacheHelper.saveData(key: ApiKeys.refreshToken, value: model.refreshToken);
    CacheHelper.saveData(key: ApiKeys.email, value: model.email);
    CacheHelper.saveData(key: ApiKeys.firstName, value: model.firstName);
    CacheHelper.saveData(key: ApiKeys.lastName, value: model.lastName);
    return model.toEntity();
  }

  @override
  Future<void> refreshToken(String accessToken, String refreshToken) async {
    try {
      await _authDataSource.refreshToken(refreshToken, accessToken);
    } catch (e) {
      await CacheHelper.clearData();
    }
  }

  @override
  Future<UserEntity> register(
    String firstName,
    String lastName,
    String email,
    dynamic password,
  ) async {
    final model = await _authDataSource.register(
      firstName,
      lastName,
      email,
      password,
    );
    CacheHelper.saveData(key: ApiKeys.token, value: model.token);
    CacheHelper.saveData(key: ApiKeys.refreshToken, value: model.refreshToken);
        CacheHelper.saveData(key: ApiKeys.email, value: model.email);
    CacheHelper.saveData(key: ApiKeys.firstName, value: model.firstName);
    CacheHelper.saveData(key: ApiKeys.lastName, value: model.lastName);
    return model.toEntity();
  }

  @override
  Future<void> revokeToken(String accessToken, String refreshToken) async {
    await _authDataSource.revokeToken(refreshToken, accessToken);
    await CacheHelper.clearData();
  }
}
