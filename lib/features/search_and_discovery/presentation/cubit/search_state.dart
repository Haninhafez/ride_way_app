import 'package:equatable/equatable.dart';
import '../../domain/entities/recent_search.dart';
import '../../domain/entities/saved_route.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/entities/station.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  final SearchStatus status;
  final String userName;
  final int unreadNotificationsCount;
  final Station originStation;
  final Station destinationStation;
  final DateTime departureDate;
  final int passengerCount;
  final List<RecentSearch> recentSearches;
  final List<SavedRoute> savedRoutes;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.userName = 'Nasser',
    this.unreadNotificationsCount = 3,
    required this.originStation,
    required this.destinationStation,
    required this.departureDate,
    this.passengerCount = 2,
    this.recentSearches = const [],
    this.savedRoutes = const [],
    this.errorMessage,
  });

  factory SearchState.initial() {
    return SearchState(
      originStation: const Station(stationCode: 'DMM', name: 'Dammam', city: 'Dammam'),
      destinationStation: const Station(stationCode: 'JED', name: 'Jeddah', city: 'Jeddah'),
      departureDate: DateTime(2026, 8, 14),
    );
  }

  SearchQuery get searchQuery => SearchQuery(
        originStation: originStation,
        destinationStation: destinationStation,
        departureDate: departureDate,
        passengerCount: passengerCount,
      );

  SearchState copyWith({
    SearchStatus? status,
    String? userName,
    int? unreadNotificationsCount,
    Station? originStation,
    Station? destinationStation,
    DateTime? departureDate,
    int? passengerCount,
    List<RecentSearch>? recentSearches,
    List<SavedRoute>? savedRoutes,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      unreadNotificationsCount:
          unreadNotificationsCount ?? this.unreadNotificationsCount,
      originStation: originStation ?? this.originStation,
      destinationStation: destinationStation ?? this.destinationStation,
      departureDate: departureDate ?? this.departureDate,
      passengerCount: passengerCount ?? this.passengerCount,
      recentSearches: recentSearches ?? this.recentSearches,
      savedRoutes: savedRoutes ?? this.savedRoutes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userName,
        unreadNotificationsCount,
        originStation,
        destinationStation,
        departureDate,
        passengerCount,
        recentSearches,
        savedRoutes,
        errorMessage,
      ];
}
