import 'package:equatable/equatable.dart';
import 'seat.dart';

class Passenger extends Equatable {
  final String passengerId;
  final int index;
  final String fullName;
  final String nationalIdOrPassport;
  final Seat? assignedSeat;

  const Passenger({
    required this.passengerId,
    required this.index,
    required this.fullName,
    required this.nationalIdOrPassport,
    this.assignedSeat,
  });

  Passenger copyWith({
    String? passengerId,
    int? index,
    String? fullName,
    String? nationalIdOrPassport,
    Seat? assignedSeat,
  }) {
    return Passenger(
      passengerId: passengerId ?? this.passengerId,
      index: index ?? this.index,
      fullName: fullName ?? this.fullName,
      nationalIdOrPassport: nationalIdOrPassport ?? this.nationalIdOrPassport,
      assignedSeat: assignedSeat ?? this.assignedSeat,
    );
  }

  @override
  List<Object?> get props => [
        passengerId,
        index,
        fullName,
        nationalIdOrPassport,
        assignedSeat,
      ];
}
