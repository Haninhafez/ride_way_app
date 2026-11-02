import 'package:equatable/equatable.dart';
import '../../domain/entities/booking.dart';

enum DigitalTicketStatus {
  initial,
  loading,
  success,
  downloading,
  downloaded,
  sharing,
  shared,
  cancelling,
  cancelled,
  error,
}

class DigitalTicketState extends Equatable {
  final DigitalTicketStatus status;
  final Booking? booking;
  final String? shareUrl;
  final String? message;
  final String? errorMessage;

  const DigitalTicketState({
    this.status = DigitalTicketStatus.initial,
    this.booking,
    this.shareUrl,
    this.message,
    this.errorMessage,
  });

  DigitalTicketState copyWith({
    DigitalTicketStatus? status,
    Booking? booking,
    String? shareUrl,
    String? message,
    String? errorMessage,
    bool clearMessage = false,
    bool clearError = false,
    bool clearShareUrl = false,
  }) {
    return DigitalTicketState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      shareUrl: clearShareUrl ? null : shareUrl ?? this.shareUrl,
      message: clearMessage ? null : message ?? this.message,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, booking, shareUrl, message, errorMessage];
}
