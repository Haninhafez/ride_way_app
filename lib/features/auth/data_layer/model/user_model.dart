import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/features/auth/domin/entity/user_entity.dart';

class UserModel extends UserEntity {
  final String token;
  final String refreshToken;
  final String refreshTokenExpiryDate;
  final int expiresIn;

  UserModel( {
    required this.token,
    required this.refreshToken,
    required this.refreshTokenExpiryDate,
    required this.expiresIn,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json[ApiKeys.id],
        token: json[ApiKeys.token],
        refreshToken: json[ApiKeys.refreshToken],
        refreshTokenExpiryDate: json[ApiKeys.refreshTokenExpiration],
        expiresIn: json[ApiKeys.expiresIn],
        firstName: json[ApiKeys.firstName],
        lastName: json[ApiKeys.lastName],
        email: json[ApiKeys.email],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        ApiKeys.id: id,
        ApiKeys.email: email,
        ApiKeys.firstName: firstName,
        ApiKeys.lastName: lastName,
        ApiKeys.token: token,
        ApiKeys.refreshToken: refreshToken,
        ApiKeys.refreshTokenExpiration: refreshTokenExpiryDate,
        ApiKeys.expiresIn: expiresIn,
      };

      UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
}
