import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime? dateOfBirth;
  final String nationalId;
  final String avatarUrl;
  final String tier;
  final int points;
  final int totalTrips;
  final String memberSince;
  final bool isVerifiedWithNafath;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.nationalId,
    required this.avatarUrl,
    required this.tier,
    required this.points,
    required this.totalTrips,
    required this.memberSince,
    required this.isVerifiedWithNafath,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phoneNumber,
        dateOfBirth,
        nationalId,
        avatarUrl,
        tier,
        points,
        totalTrips,
        memberSince,
        isVerifiedWithNafath,
      ];
}
