import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';

import '../models/user_profile_dto.dart';

abstract class AccountRemoteDataSource {
  Future<UserProfileDTO> fetchUserProfile();
  Future<UserProfileDTO> updateUserProfile(UserProfileDTO dto);
  Future<void> changePassword(String current, String newPwd);
  Future<String?> getLastPasswordChangeInfo();
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final FirebaseFirestore firestore;

  AccountRemoteDataSourceImpl({required this.firestore});
  @override
  Future<UserProfileDTO> fetchUserProfile() async {
    final userId = CacheHelper.getData(ApiKeys.id);
    final userData = await firestore.collection('users').doc(userId).get();
    return UserProfileDTO.fromJson(userData.data()!);
  }

  @override
  Future<UserProfileDTO> updateUserProfile(UserProfileDTO dto) async {
    final userId = CacheHelper.getData(ApiKeys.id);

    await firestore.collection('users').doc(userId).update(dto.toJson());

    return dto;
  }

  @override
  Future<void> changePassword(String current, String newPwd) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<String?> getLastPasswordChangeInfo() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 'Password was last changed on 2026-05-10';
  }
}
