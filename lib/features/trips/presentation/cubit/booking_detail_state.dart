import 'package:equatable/equatable.dart';
import '../../domain/entities/booking.dart';

enum BookingDetailStatus { initial, loading, success, cancelling, cancelled, error }

class BookingDetailState extends Equatable {
  final BookingDetailStatus status;
  final Booking? booking;
  final String? errorMessage;

  const BookingDetailState({
    this.status = BookingDetailStatus.initial,
    this.booking,
    this.errorMessage,
  });

  BookingDetailState copyWith({
    BookingDetailStatus? status,
    Booking? booking,
    String? errorMessage,
  }) {
    return BookingDetailState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, booking, errorMessage];
}
