import 'package:equatable/equatable.dart';
import '../../../search_and_discovery/domain/entities/station.dart';

enum TrainSearchStatus { initial, loading, validationError, networkError, loaded }

class TrainSearchState extends Equatable {
  final TrainSearchStatus status;
  final Station originStation;
  final Station? destinationStation;
  final DateTime departureDate;
  final int passengerCount;
  final bool showValidationError;
  final String? errorMessage;

  const TrainSearchState({
    this.status = TrainSearchStatus.initial,
    required this.originStation,
    this.destinationStation,
    required this.departureDate,
    this.passengerCount = 1,
    this.showValidationError = false,
    this.errorMessage,
  });

  factory TrainSearchState.initial() {
    return TrainSearchState(
      originStation: const Station(
        stationCode: 'DMM',
        name: 'Dammam',
        city: 'Dammam',
      ),
      departureDate: DateTime.now(),
    );
  }

  bool get hasValidationError {
    if (destinationStation == null) return true;
    if (originStation.stationCode == destinationStation!.stationCode) return true;
    return false;
  }

  TrainSearchState copyWith({
    TrainSearchStatus? status,
    Station? originStation,
    Station? destinationStation,
    DateTime? departureDate,
    int? passengerCount,
    bool? showValidationError,
    String? errorMessage,
  }) {
    return TrainSearchState(
      status: status ?? this.status,
      originStation: originStation ?? this.originStation,
      destinationStation: destinationStation ?? this.destinationStation,
      departureDate: departureDate ?? this.departureDate,
      passengerCount: passengerCount ?? this.passengerCount,
      showValidationError: showValidationError ?? this.showValidationError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        originStation,
        destinationStation,
        departureDate,
        passengerCount,
        showValidationError,
        errorMessage,
      ];
}
