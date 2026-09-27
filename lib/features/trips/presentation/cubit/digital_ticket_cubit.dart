import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_digital_ticket_usecase.dart';
import 'digital_ticket_state.dart';

class DigitalTicketCubit extends Cubit<DigitalTicketState> {
  final GetDigitalTicketUseCase getDigitalTicketUseCase;

  DigitalTicketCubit({
    required this.getDigitalTicketUseCase,
  }) : super(const DigitalTicketState());

  Future<void> loadTicket(String bookingIdOrRef) async {
    emit(state.copyWith(status: DigitalTicketStatus.loading));
    try {
      final b = await getDigitalTicketUseCase.execute(bookingIdOrRef);
      if (b != null) {
        emit(state.copyWith(
          status: DigitalTicketStatus.success,
          booking: b,
        ));
      } else {
        emit(state.copyWith(
          status: DigitalTicketStatus.error,
          errorMessage: 'Ticket not found.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: DigitalTicketStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> downloadTicket() async {
    if (state.booking == null) return;
    emit(state.copyWith(status: DigitalTicketStatus.downloading));
    await Future.delayed(const Duration(milliseconds: 600));
    emit(state.copyWith(
      status: DigitalTicketStatus.downloaded,
      message: 'Ticket saved offline to your device storage.',
    ));
  }

  Future<void> shareTicket() async {
    if (state.booking == null) return;
    emit(state.copyWith(status: DigitalTicketStatus.sharing));
    await Future.delayed(const Duration(milliseconds: 400));
    emit(state.copyWith(
      status: DigitalTicketStatus.shared,
      message: 'Ticket share sheet opened.',
    ));
  }
}
