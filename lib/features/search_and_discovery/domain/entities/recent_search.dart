import 'package:equatable/equatable.dart';

class RecentSearch extends Equatable {
  final String id;
  final String originCode;
  final String destinationCode;
  final String originName;
  final String destinationName;
  final DateTime departureDate;
  final int passengerCount;

  const RecentSearch({
    required this.id,
    required this.originCode,
    required this.destinationCode,
    required this.originName,
    required this.destinationName,
    required this.departureDate,
    required this.passengerCount,
  });

  @override
  List<Object?> get props => [
        id,
        originCode,
        destinationCode,
        originName,
        destinationName,
        departureDate,
        passengerCount,
      ];
}
