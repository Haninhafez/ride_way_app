import '../../domain/entities/passenger.dart';
import 'seat_model.dart';

class PassengerModel extends Passenger {
  const PassengerModel({
    required super.passengerId,
    required super.index,
    required super.fullName,
    required super.nationalIdOrPassport,
    super.assignedSeat,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      passengerId: json['passengerId'] ?? '',
      index: json['index'] ?? 1,
      fullName: json['fullName'] ?? '',
      nationalIdOrPassport: json['nationalIdOrPassport'] ?? '',
      assignedSeat: json['assignedSeat'] != null
          ? SeatModel.fromJson(json['assignedSeat'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passengerId': passengerId,
      'index': index,
      'fullName': fullName,
      'nationalIdOrPassport': nationalIdOrPassport,
      'assignedSeat': assignedSeat != null
          ? (assignedSeat as SeatModel).toJson()
          : null,
    };
  }
}
