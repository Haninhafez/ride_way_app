import '../models/recent_search_dto.dart';
import '../models/saved_route_dto.dart';

abstract class SearchLocalDataSource {
  Future<List<RecentSearchDTO>> getRecentSearches();
  Future<void> clearRecentSearches();
  Future<List<SavedRouteDTO>> getSavedRoutes();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final List<RecentSearchDTO> _recentSearches = [
    RecentSearchDTO(
      id: 'rs1',
      originCode: 'DMM',
      destinationCode: 'RUH',
      originName: 'Dammam',
      destinationName: 'Riyadh',
      departureDate: DateTime.now().add(const Duration(days: 1)),
      passengerCount: 2,
    ),
    RecentSearchDTO(
      id: 'rs2',
      originCode: 'JED',
      destinationCode: 'DMM',
      originName: 'Jeddah',
      destinationName: 'Dammam',
      departureDate: DateTime.now().add(const Duration(days: 4)),
      passengerCount: 1,
    ),
  ];

  final List<SavedRouteDTO> _savedRoutes = [
    const SavedRouteDTO(
      id: 'sr1',
      originCode: 'DMM',
      destinationCode: 'RUH',
      originName: 'Dammam',
      destinationName: 'Riyadh',
      note: 'Weekday commute',
      dailyTrainsCount: 14,
    ),
    const SavedRouteDTO(
      id: 'sr2',
      originCode: 'JED',
      destinationCode: 'KAEC',
      originName: 'Jeddah',
      destinationName: 'KAEC',
      note: 'Weekend escape',
      dailyTrainsCount: 8,
    ),
  ];

  @override
  Future<List<RecentSearchDTO>> getRecentSearches() async {
    return List.from(_recentSearches);
  }

  @override
  Future<void> clearRecentSearches() async {
    _recentSearches.clear();
  }

  @override
  Future<List<SavedRouteDTO>> getSavedRoutes() async {
    return List.from(_savedRoutes);
  }
}
