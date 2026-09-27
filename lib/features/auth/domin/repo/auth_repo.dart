
import 'package:ride_way_app/features/auth/domin/entity/user_entity.dart';

abstract class AuthRepo {
  Future<UserEntity> login(String email, dynamic password);
  Future<UserEntity> register(
    String firstName,
    String lastName,
    String email,
    dynamic password,
  );
  Future<void> refreshToken(String accessToken, String refreshToken);
  Future<void> revokeToken(String accessToken, String refreshToken);
  }
