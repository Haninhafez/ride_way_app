import 'package:equatable/equatable.dart';

class PassengerSeat extends Equatable {
  final String passengerName;
  final String passengerType;
  final String seatNumber;

  const PassengerSeat({
    required this.passengerName,
    this.passengerType = 'Adult',
    required this.seatNumber,
  });

  @override
  List<Object?> get props => [passengerName, passengerType, seatNumber];
}
