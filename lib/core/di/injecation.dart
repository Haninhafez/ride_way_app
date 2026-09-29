import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/features/account/data/datasources/account_remote_data_source.dart';
import 'package:ride_way_app/features/account/data/repositories/account_repository_impl.dart';
import 'package:ride_way_app/features/account/domain/repositories/account_repository.dart';
import 'package:ride_way_app/features/account/domain/usecases/get_user_profile_usecase.dart';
import 'package:ride_way_app/features/account/presentation/cubit/profile_cubit.dart';
import 'package:ride_way_app/features/auth/data_layer/data_source/auth_data_source.dart';
import 'package:ride_way_app/features/auth/data_layer/repo/auth_implentation_repo.dart';
import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:ride_way_app/features/search_and_discovery/data/datasources/search_remote_data_source.dart';
import 'package:ride_way_app/features/search_and_discovery/data/repositories/search_repository_impl.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/repositories/search_repository.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/filter_and_sort_trains_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/get_recent_searches_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/get_saved_routes_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/get_station_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/search_trains_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/search_cubit.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/train_list_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ),
  );
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSource(dio: sl<Dio>(), firestore: sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<AuthRepo>(
    () => AuthImplentationRepo(sl<AuthDataSource>()),
  );
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepo>()));

  sl.registerLazySingleton<Dio>(() => dio);

  sl.registerLazySingleton<SearchRemoteDataSourceImpl>(
    () => SearchRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      remoteDataSource: sl<SearchRemoteDataSourceImpl>(),
    ),
  );

  sl.registerLazySingleton<FilterAndSortTrainsUseCase>(
    () => FilterAndSortTrainsUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton<GetRecentSearchesUseCase>(
    () => GetRecentSearchesUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton<GetSavedRoutesUseCase>(
    () => GetSavedRoutesUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton<SearchTrainsUseCase>(
    () => SearchTrainsUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton<GetStationUseCase>(
    () => GetStationUseCase(repository: sl<SearchRepository>()),
  );

  sl.registerLazySingleton<SearchCubit>(
    () => SearchCubit(
      getStationUseCase: sl<GetStationUseCase>(),
      getRecentSearchesUseCase: sl<GetRecentSearchesUseCase>(),
      getSavedRoutesUseCase: sl<GetSavedRoutesUseCase>(),
    ),
  );

  sl.registerFactory<TrainListCubit>(
    () => TrainListCubit(
      searchTrainsUseCase: sl<SearchTrainsUseCase>(),
      filterAndSortTrainsUseCase: sl<FilterAndSortTrainsUseCase>(),
    ),
  );

  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<AccountRepository>(
    () =>
        AccountRepositoryImpl(remoteDataSource: sl<AccountRemoteDataSource>()),
  );

  // Use Case
  sl.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(sl<AccountRepository>()),
  );

  // Cubit
  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(getUserProfileUseCase: sl<GetUserProfileUseCase>()),
  );
}
