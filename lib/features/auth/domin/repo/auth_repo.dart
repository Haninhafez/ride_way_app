
import 'package:dartz/dartz.dart';
import 'package:ride_way_app/core/error/failures.dart';
import 'package:ride_way_app/features/auth/domin/entity/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> login(String email, dynamic password);
  Future<Either<Failure, UserEntity>> register(
    String firstName,
    String lastName,
    String email,
    dynamic password,
  );
  Future<Either<Failure, void>> refreshToken(String accessToken, String refreshToken);
  Future<Either<Failure, void>> revokeToken(String accessToken, String refreshToken);
  }
