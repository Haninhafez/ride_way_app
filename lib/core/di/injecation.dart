import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/features/auth/data_layer/data_source/auth_data_source.dart';
import 'package:ride_way_app/features/auth/data_layer/repo/auth_implentation_repo.dart';
import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';

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
    () => AuthDataSource(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<AuthRepo>(
    () => AuthImplentationRepo(sl<AuthDataSource>()),
  );
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepo>()));

  sl.registerLazySingleton<Dio>(() => dio);



}
