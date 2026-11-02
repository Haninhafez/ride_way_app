import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/entities/train_search_result.dart';
import '../../domain/usecases/filter_and_sort_trains_usecase.dart';
import '../../domain/usecases/search_trains_usecase.dart';
import 'train_list_state.dart';

class TrainListCubit extends Cubit<TrainListState> {
  final SearchTrainsUseCase searchTrainsUseCase;
  final FilterAndSortTrainsUseCase filterAndSortTrainsUseCase;

  TrainListCubit({
    required this.searchTrainsUseCase,
    required this.filterAndSortTrainsUseCase,
  }) : super(TrainListState());

  Future<void> executeSearch(SearchQuery query) async {
    emit(
      state.copyWith(
        status: TrainListStatus.loading,
        query: query,
        selectedDate: query.departureDate,
      ),
    );

    final results = await searchTrainsUseCase.execute(query);
    if (isClosed) return;

    results.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TrainListStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (trains) {
        final sorted = List<TrainSearchResult>.from(trains)
          ..sort((a, b) => a.departureTime.compareTo(b.departureTime));

        emit(
          state.copyWith(
            status: sorted.isEmpty
                ? TrainListStatus.empty
                : TrainListStatus.success,
            query: query,
            selectedDate: query.departureDate,
            allTrains: sorted,
            filteredTrains: sorted,
            maxPriceFilter: null,
            sortBy: 'earliest',
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> changeDate(DateTime newDate) async {
    if (state.query == null || isClosed) return;

    final updatedQuery = state.query!.copyWith(departureDate: newDate);

    await executeSearch(updatedQuery);
  }

  Future<void> changeSortBy(String sortBy) async {
    final result = await filterAndSortTrainsUseCase.call(
      trains: state.allTrains,
      sortBy: sortBy,
      maxPrice: state.maxPriceFilter,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TrainListStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (sortedTrains) {
        emit(
          state.copyWith(
            sortBy: sortBy,
            filteredTrains: sortedTrains,
            status: sortedTrains.isEmpty
                ? TrainListStatus.empty
                : TrainListStatus.success,
          ),
        );
      },
    );
  }

  Future<void> applyPriceFilter(double? maxPrice) async {
    final result = await filterAndSortTrainsUseCase.call(
      trains: state.allTrains,
      sortBy: state.sortBy,
      maxPrice: maxPrice,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TrainListStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (filteredTrains) {
        emit(
          state.copyWith(
            maxPriceFilter: maxPrice,
            filteredTrains: filteredTrains,
            status: filteredTrains.isEmpty
                ? TrainListStatus.empty
                : TrainListStatus.success,
          ),
        );
      },
    );
  }
}
