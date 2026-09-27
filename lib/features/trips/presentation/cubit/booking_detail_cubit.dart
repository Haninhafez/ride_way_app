import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/get_booking_detail_usecase.dart';
import 'booking_detail_state.dart';

class BookingDetailCubit extends Cubit<BookingDetailState> {
  final GetBookingDetailUseCase getBookingDetailUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  BookingDetailCubit({
    required this.getBookingDetailUseCase,
    required this.cancelBookingUseCase,
  }) : super(const BookingDetailState());

  Future<void> loadDetail(String bookingIdOrRef) async {
    emit(state.copyWith(status: BookingDetailStatus.loading));
    try {
      final b = await getBookingDetailUseCase.execute(bookingIdOrRef);
      if (b != null) {
        emit(state.copyWith(
          status: BookingDetailStatus.success,
          booking: b,
        ));
      } else {
        emit(state.copyWith(
          status: BookingDetailStatus.error,
          errorMessage: 'Booking not found.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: BookingDetailStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<bool> cancelCurrentBooking() async {
    if (state.booking == null) return false;
    emit(state.copyWith(status: BookingDetailStatus.cancelling));
    try {
      final success = await cancelBookingUseCase.execute(state.booking!.id);
      if (success) {
        final updated = state.booking!.copyWith(status: BookingStatusType.cancelled);
        emit(state.copyWith(
          status: BookingDetailStatus.cancelled,
          booking: updated,
        ));
        return true;
      } else {
        emit(state.copyWith(
          status: BookingDetailStatus.error,
          errorMessage: 'Failed to cancel booking.',
        ));
        return false;
      }
    } catch (e) {
      emit(state.copyWith(
        status: BookingDetailStatus.error,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }
}
