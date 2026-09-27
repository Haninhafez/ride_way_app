import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../search_and_discovery/domain/entities/search_query.dart';
import '../../../search_and_discovery/domain/entities/station.dart';
import '../../../search_and_discovery/domain/usecases/search_trains_usecase.dart';
import 'train_search_state.dart';

class TrainSearchCubit extends Cubit<TrainSearchState> {
  final SearchTrainsUseCase searchTrainsUseCase;

  TrainSearchCubit({
    required this.searchTrainsUseCase,
  }) : super(TrainSearchState.initial());

  void updateOrigin(Station station) {
    emit(state.copyWith(originStation: station));
  }

  void updateDestination(Station? station) {
    emit(state.copyWith(destinationStation: station));
  }

  void updateDate(DateTime date) {
    emit(state.copyWith(departureDate: date));
  }

  void incrementPassengers() {
    if (state.passengerCount < 9) {
      emit(state.copyWith(passengerCount: state.passengerCount + 1));
    }
  }

  void decrementPassengers() {
    if (state.passengerCount > 1) {
      emit(state.copyWith(passengerCount: state.passengerCount - 1));
    }
  }

  void swapStations() {
    final temp = state.originStation;
    emit(state.copyWith(
      originStation: state.destinationStation,
      destinationStation: temp,
    ));
  }

  void retryLoading() {
    emit(state.copyWith(status: TrainSearchStatus.networkError));
  }

  Future<bool> validateAndSearch() async {
    if (state.hasValidationError) {
      emit(state.copyWith(
        status: TrainSearchStatus.validationError,
        showValidationError: true,
      ));
      return false;
    }

    emit(state.copyWith(
      status: TrainSearchStatus.loading,
      showValidationError: false,
    ));

    try {
      final query = SearchQuery(
        originStation: state.originStation,
        destinationStation: state.destinationStation!,
        departureDate: state.departureDate,
        passengerCount: state.passengerCount,
      );

      await searchTrainsUseCase.execute(query);

      emit(state.copyWith(status: TrainSearchStatus.loaded));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: TrainSearchStatus.networkError,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  void clearValidationError() {
    emit(state.copyWith(
      status: TrainSearchStatus.initial,
      showValidationError: false,
    ));
  }
}
