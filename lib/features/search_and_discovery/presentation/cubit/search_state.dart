import 'package:equatable/equatable.dart';

import '../../domain/entities/recent_search.dart';
import '../../domain/entities/saved_route.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/entities/station.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  final SearchStatus status;

  final String? userName;
  final int unreadNotificationsCount;

  final Station? fromStation;
  final Station? toStation;

  final DateTime? departureDate;
  final int passengerCount;
  final List<Station> availableStations;

  final List<RecentSearch> recentSearches;
  final List<SavedRoute> savedRoutes;

  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.userName,
    this.unreadNotificationsCount = 0,
    this.fromStation,
    this.toStation,
    this.departureDate,
    this.passengerCount = 1,
    this.recentSearches = const [],
    this.savedRoutes = const [],
    this.errorMessage,
    this.availableStations = const [],
  });

  SearchQuery? get searchQuery {
    if (fromStation == null || toStation == null || departureDate == null) {
      return null;
    }

    return SearchQuery(
      originStation: fromStation!,
      destinationStation: toStation!,
      departureDate: departureDate!,
      passengerCount: passengerCount,
    );
  }

  SearchState copyWith({
    SearchStatus? status,
    String? userName,
    int? unreadNotificationsCount,
    Station? fromStation,
    Station? toStation,
    DateTime? departureDate,
    int? passengerCount,
    List<RecentSearch>? recentSearches,
    List<SavedRoute>? savedRoutes,
    String? errorMessage,
    final List<Station>? availableStations,
  }) {
    return SearchState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      unreadNotificationsCount:
          unreadNotificationsCount ?? this.unreadNotificationsCount,
      fromStation: fromStation ?? this.fromStation,
      toStation: toStation ?? this.toStation,
      departureDate: departureDate ?? this.departureDate,
      passengerCount: passengerCount ?? this.passengerCount,
      recentSearches: recentSearches ?? this.recentSearches,
      savedRoutes: savedRoutes ?? this.savedRoutes,
      errorMessage: errorMessage ?? this.errorMessage,
      availableStations: availableStations ?? this.availableStations,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userName,
    unreadNotificationsCount,
    fromStation,
    toStation,
    departureDate,
    passengerCount,
    recentSearches,
    savedRoutes,
    errorMessage,
    availableStations,
  ];
}
