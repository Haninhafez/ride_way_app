import 'package:flutter_test/flutter_test.dart';
import 'package:ride_way_app/features/search_and_discovery/data/datasources/search_local_data_source.dart';
import 'package:ride_way_app/features/search_and_discovery/data/datasources/search_remote_data_source.dart';
import 'package:ride_way_app/features/search_and_discovery/data/repositories/search_repository_impl.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/get_recent_searches_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/get_saved_routes_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/search_cubit.dart';

void main() {
  late SearchCubit cubit;

  setUp(() {
    final remote = SearchRemoteDataSourceImpl();
    final local = SearchLocalDataSourceImpl();
    final repo = SearchRepositoryImpl(remoteDataSource: remote, localDataSource: local);

    cubit = SearchCubit(
      getRecentSearchesUseCase: GetRecentSearchesUseCase(repo),
      getSavedRoutesUseCase: GetSavedRoutesUseCase(repo),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('swapStations swaps origin and destination stations', () {
    final initialOrigin = cubit.state.originStation;
    final initialDest = cubit.state.destinationStation;

    cubit.swapStations();

    expect(cubit.state.originStation, equals(initialDest));
    expect(cubit.state.destinationStation, equals(initialOrigin));
  });

  test('passenger count increment and decrement bound limits', () {
    expect(cubit.state.passengerCount, equals(2));

    cubit.incrementPassengers();
    expect(cubit.state.passengerCount, equals(3));

    cubit.decrementPassengers();
    cubit.decrementPassengers();
    expect(cubit.state.passengerCount, equals(1)); // Does not go below 1

    cubit.decrementPassengers();
    expect(cubit.state.passengerCount, equals(1));
  });
}
