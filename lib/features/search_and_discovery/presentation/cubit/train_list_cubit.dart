import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/search_query.dart';
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
    emit(state.copyWith(
      status: TrainListStatus.loading,
      query: query,
      selectedDate: query.departureDate,
    ));

    try {
      final results = await searchTrainsUseCase.execute(query);

      if (results.isEmpty) {
        emit(state.copyWith(
          status: TrainListStatus.empty,
          allTrains: const [],
          filteredTrains: const [],
        ));
      } else {
        final sorted = await filterAndSortTrainsUseCase.execute(
          trains: results,
          sortBy: state.sortBy,
          maxPrice: state.maxPriceFilter,
        );

        emit(state.copyWith(
          status: TrainListStatus.success,
          allTrains: results,
          filteredTrains: sorted,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TrainListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> changeDate(DateTime newDate) async {
    if (state.query == null) return;
    final updatedQuery = state.query!.copyWith(departureDate: newDate);
    await executeSearch(updatedQuery);
  }

  Future<void> changeSortBy(String sortBy) async {
    emit(state.copyWith(sortBy: sortBy));
    final sorted = await filterAndSortTrainsUseCase.execute(
      trains: state.allTrains,
      sortBy: sortBy,
      maxPrice: state.maxPriceFilter,
    );
    emit(state.copyWith(filteredTrains: sorted));
  }

  Future<void> applyPriceFilter(double? maxPrice) async {
    emit(state.copyWith(maxPriceFilter: maxPrice));
    final filtered = await filterAndSortTrainsUseCase.execute(
      trains: state.allTrains,
      sortBy: state.sortBy,
      maxPrice: maxPrice,
    );
    emit(state.copyWith(
      filteredTrains: filtered,
      status: filtered.isEmpty ? TrainListStatus.empty : TrainListStatus.success,
    ));
  }
}
