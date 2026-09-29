import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/get_station_usecase.dart';
import '../../domain/entities/recent_search.dart';
import '../../domain/entities/saved_route.dart';
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
    emit(state.copyWith(status: SearchStatus.loading));

    final stations = await getStationUseCase.execute();
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
    return state.availableStations!
        .where((station) => station.code != state.fromStation?.code)
        .toList();
  }

  Future<void> loadDiscoveryData() async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      // final recents = await getRecentSearchesUseCase.execute();
      // final saved = await getSavedRoutesUseCase.execute();

      emit(
        state.copyWith(
          status: SearchStatus.loaded,
          // recentSearches: recents,
          // savedRoutes: saved,
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

  emit(
    state.copyWith(
      fromStation: state.toStation,
      toStation: temp,
    ),
  );
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

  // Future<void> clearRecentSearches() async {
  //   await getRecentSearchesUseCase.clearAll();
  //   emit(state.copyWith(recentSearches: const []));
  // }

  // void applyRecentSearch(RecentSearch recent) {
  //   emit(state.copyWith(
  //     originStation: Station(
  //         stationCode: recent.originCode,
  //         name: recent.originName,
  //         city: recent.originName),
  //     destinationStation: Station(
  //         stationCode: recent.destinationCode,
  //         name: recent.destinationName,
  //         city: recent.destinationName),
  //     departureDate: recent.departureDate,
  //     passengerCount: recent.passengerCount,
  //   ));
  // }

  // void applySavedRoute(SavedRoute route) {
  //   emit(state.copyWith(
  //     originStation: Station(
  //         stationCode: route.originCode,
  //         name: route.originName,
  //         city: route.originName),
  //     destinationStation: Station(
  //         stationCode: route.destinationCode,
  //         name: route.destinationName,
  //         city: route.destinationName),
  //   ));
  // }
}
