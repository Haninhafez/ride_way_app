import '../../domain/entities/user_profile.dart';

class UserProfileDTO {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? nationalId;
  final String? avatarUrl;
  final String? tier;
  final int? points;
  final int? totalTrips;
  final String? memberSince;
  final bool? isVerifiedWithNafath;

  const UserProfileDTO({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.nationalId,
    this.avatarUrl,
    this.tier,
    this.points,
    this.totalTrips,
    this.memberSince,
    this.isVerifiedWithNafath,
  });

  factory UserProfileDTO.fromJson(Map<String, dynamic> json) {
    return UserProfileDTO(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      nationalId: json['nationalId'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      tier: json['tier'] as String?,
      points: json['points'] as int?,
      totalTrips: json['totalTrips'] as int?,
      memberSince: json['memberSince'] as String?,
      isVerifiedWithNafath: json['isVerifiedWithNafath'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'nationalId': nationalId,
      'avatarUrl': avatarUrl,
      'tier': tier,
      'points': points,
      'totalTrips': totalTrips,
      'memberSince': memberSince,
      'isVerifiedWithNafath': isVerifiedWithNafath,
    };
  }

  UserProfile toDomain() {
    return UserProfile(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      phoneNumber: phoneNumber ?? '',
      dateOfBirth: dateOfBirth != null ? DateTime.tryParse(dateOfBirth!) : null,
      nationalId: nationalId ?? '',
      avatarUrl: avatarUrl ?? '',
      tier: tier ?? '',
      points: points ?? 0,
      totalTrips: totalTrips ?? 0,
      memberSince: memberSince ?? '',
      isVerifiedWithNafath: isVerifiedWithNafath ?? false,
    );
  }

  factory UserProfileDTO.fromDomain(UserProfile profile) {
    return UserProfileDTO(
      id: profile.id,
      firstName: profile.firstName,
      lastName: profile.lastName,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      dateOfBirth: profile.dateOfBirth?.toIso8601String(),
      nationalId: profile.nationalId,
      avatarUrl: profile.avatarUrl,
      tier: profile.tier,
      points: profile.points,
      totalTrips: profile.totalTrips,
      memberSince: profile.memberSince,
      isVerifiedWithNafath: profile.isVerifiedWithNafath,
    );
  }
}
