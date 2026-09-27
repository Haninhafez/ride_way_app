import 'package:equatable/equatable.dart';
import '../../domain/entities/booking.dart';

enum DigitalTicketStatus { initial, loading, success, downloading, downloaded, sharing, shared, error }

class DigitalTicketState extends Equatable {
  final DigitalTicketStatus status;
  final Booking? booking;
  final String? message;
  final String? errorMessage;

  const DigitalTicketState({
    this.status = DigitalTicketStatus.initial,
    this.booking,
    this.message,
    this.errorMessage,
  });

  DigitalTicketState copyWith({
    DigitalTicketStatus? status,
    Booking? booking,
    String? message,
    String? errorMessage,
  }) {
    return DigitalTicketState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, booking, message, errorMessage];
}
