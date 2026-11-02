import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/get_station_usecase.dart';
import '../../domain/entities/station.dart';
import '../../domain/usecases/get_recent_searches_usecase.dart';
import '../../domain/usecases/get_saved_routes_usecase.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GetRecentSearchesUseCase getRecentSearchesUseCase;
  final GetSavedRoutesUseCase getSavedRoutesUseCase;
  final GetStationUseCase getStationUseCase;

  SearchCubit({
    required this.getRecentSearchesUseCase,
    required this.getSavedRoutesUseCase,
    required this.getStationUseCase,
  }) : super(SearchState());

  Future<void> loadStations() async {
    if (isClosed) return;

    emit(state.copyWith(status: SearchStatus.loading));

    final stations = await getStationUseCase.execute();
    if (isClosed) return;
    stations.fold(
      (failure) {
        emit(
          state.copyWith(
            status: SearchStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (stations) {
        emit(
          state.copyWith(
            status: SearchStatus.loaded,
            availableStations: stations,
          ),
        );
      },
    );
  }

  void selectFromStation(Station station) {
    emit(state.copyWith(fromStation: station));
  }

  List<Station> getAvailableStations() {
    return state.availableStations
        .where((station) => station.code != state.fromStation?.code)
        .toList();
  }

  Future<void> loadDiscoveryData() async {
    if (isClosed) return;
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      if(isClosed) return;

      emit(
        state.copyWith(
          status: SearchStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: SearchStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void swapStations() {
    final temp = state.fromStation;

    emit(state.copyWith(fromStation: state.toStation, toStation: temp));
  }

  void updateOrigin(Station station) {
    emit(state.copyWith(fromStation: station));
  }

  void updateDestination(Station station) {
    emit(state.copyWith(toStation: station));
  }

  void updateDepartureDate(DateTime date) {
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

  int get passengerCount {
    return state.passengerCount;
  }



}
