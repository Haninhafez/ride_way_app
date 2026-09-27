import 'package:equatable/equatable.dart';
import 'station.dart';

class SearchQuery extends Equatable {
  final Station originStation;
  final Station destinationStation;
  final DateTime departureDate;
  final int passengerCount;

  const SearchQuery({
    required this.originStation,
    required this.destinationStation,
    required this.departureDate,
    this.passengerCount = 2,
  });

  SearchQuery copyWith({
    Station? originStation,
    Station? destinationStation,
    DateTime? departureDate,
    int? passengerCount,
  }) {
    return SearchQuery(
      originStation: originStation ?? this.originStation,
      destinationStation: destinationStation ?? this.destinationStation,
      departureDate: departureDate ?? this.departureDate,
      passengerCount: passengerCount ?? this.passengerCount,
    );
  }

  @override
  List<Object?> get props => [
        originStation,
        destinationStation,
        departureDate,
        passengerCount,
      ];
}
