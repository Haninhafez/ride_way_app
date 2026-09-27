import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/features/auth/data_layer/model/user_model.dart';

class AuthDataSource {
  final Dio dio;

  AuthDataSource({required this.dio});

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        ApiEndPoints.login,
        data: {'email': email, 'password': password},
        
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['errors']['description'] ?? "Login failed",
      );
    }
  }

  Future<UserModel> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final response = await dio.post(
        ApiEndPoints.register,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Registration failed');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['errors']['code'] ?? "Registration failed",
      );
    }
  }

  Future<void> refreshToken(String refreshToken, String accessToken) async {
    try {
      await dio.post(ApiEndPoints.refreshToken);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }

  Future<void> revokeToken(String refreshToken, String accessToken) async {
    try {
      await dio.post(ApiEndPoints.revokeToken);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }
}
