import '../../domain/entities/passenger_seat.dart';

class PassengerSeatDTO extends PassengerSeat {
  const PassengerSeatDTO({
    required super.passengerName,
    super.passengerType,
    required super.seatNumber,
  });

  factory PassengerSeatDTO.fromJson(Map<String, dynamic> json) {
    return PassengerSeatDTO(
      passengerName: json['passengerName'] ?? '',
      passengerType: json['passengerType'] ?? 'Adult',
      seatNumber: json['seatNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passengerName': passengerName,
      'passengerType': passengerType,
      'seatNumber': seatNumber,
    };
  }
}
