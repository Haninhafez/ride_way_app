import 'package:equatable/equatable.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/entities/train_search_result.dart';

enum TrainListStatus { initial, loading, success, empty, error }

class TrainListState extends Equatable {
  final TrainListStatus status;
  final SearchQuery? query;
  final List<TrainSearchResult> allTrains;
  final List<TrainSearchResult> filteredTrains;
  final DateTime selectedDate;
  final String sortBy;
  final double? maxPriceFilter;
  final String? errorMessage;

  TrainListState({
    this.status = TrainListStatus.initial,
    this.query,
    this.allTrains = const [],
    this.filteredTrains = const [],
    DateTime? selectedDate,
    this.sortBy = 'earliest',
    this.maxPriceFilter,
    this.errorMessage,
  }) : selectedDate = selectedDate ?? DateTime(2026, 8, 14);

  TrainListState copyWith({
    TrainListStatus? status,
    SearchQuery? query,
    List<TrainSearchResult>? allTrains,
    List<TrainSearchResult>? filteredTrains,
    DateTime? selectedDate,
    String? sortBy,
    double? maxPriceFilter,
    String? errorMessage,
  }) {
    return TrainListState(
      status: status ?? this.status,
      query: query ?? this.query,
      allTrains: allTrains ?? this.allTrains,
      filteredTrains: filteredTrains ?? this.filteredTrains,
      selectedDate: selectedDate ?? this.selectedDate,
      sortBy: sortBy ?? this.sortBy,
      maxPriceFilter: maxPriceFilter ?? this.maxPriceFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        query,
        allTrains,
        filteredTrains,
        selectedDate,
        sortBy,
        maxPriceFilter,
        errorMessage,
      ];
}
