import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/core/error/api_error_handler.dart';
import 'package:ride_way_app/core/error/exceptions.dart';
import 'package:ride_way_app/features/auth/data_layer/model/user_model.dart';

class AuthDataSource {
  final Dio dio;
  final FirebaseFirestore firestore;

  AuthDataSource({required this.dio, required this.firestore});

  Future isUserExists(UserModel user) async {
    final result = await firestore
        .collection('users')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();
    if (!result.docs.isNotEmpty) {
      firestore.collection('users').doc(user.id).set({
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
      });
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        ApiEndPoints.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        isUserExists(user);
        CacheHelper.saveData(key: ApiKeys.firstName, value: user.firstName);
        CacheHelper.saveData(key: ApiKeys.lastName, value: user.lastName);
        return UserModel.fromJson(user.toJson());
      }
      throw ServerException();
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
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
        final user = UserModel.fromJson(response.data);
        await firestore.collection('users').doc(user.id).set(user.toJson());
        return UserModel.fromJson(user.toJson());
      }
      throw ServerException();
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> refreshToken(String refreshToken, String accessToken) async {
    try {
      await dio.post(ApiEndPoints.refreshToken);
      throw ServerException();
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
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
