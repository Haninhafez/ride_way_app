import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';
import 'my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final GetMyBookingsUseCase getMyBookingsUseCase;

  MyBookingsCubit({
    required this.getMyBookingsUseCase,
  }) : super(const MyBookingsState());

  Future<void> loadBookings() async {
    emit(state.copyWith(status: MyBookingsStatus.loading));
    try {
      final bookings = await getMyBookingsUseCase.execute();
      emit(state.copyWith(
        status: MyBookingsStatus.success,
        allBookings: bookings,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MyBookingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void changeTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }
}
