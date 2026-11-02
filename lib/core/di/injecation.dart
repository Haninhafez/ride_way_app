import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:ride_way_app/features/account/data/datasources/account_remote_data_source.dart';
import 'package:ride_way_app/features/account/data/repositories/account_repository_impl.dart';
import 'package:ride_way_app/features/account/domain/repositories/account_repository.dart';
import 'package:ride_way_app/features/account/domain/usecases/change_password_usecase.dart';
import 'package:ride_way_app/features/account/domain/usecases/get_user_profile_usecase.dart';
import 'package:ride_way_app/features/account/domain/usecases/update_user_profile_usecase.dart';
import 'package:ride_way_app/features/account/presentation/cubit/edit_profile_cubit.dart';
import 'package:ride_way_app/features/account/presentation/cubit/password_security_cubit.dart';
import 'package:ride_way_app/features/account/presentation/cubit/profile_cubit.dart';
import 'package:ride_way_app/features/auth/data_layer/data_source/auth_data_source.dart';
import 'package:ride_way_app/features/auth/data_layer/repo/auth_implentation_repo.dart';
import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:ride_way_app/features/booking/data/datasources/booking_firestore_data_source.dart';
import 'package:ride_way_app/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:ride_way_app/features/booking/domain/repositories/booking_repository.dart';
import 'package:ride_way_app/features/booking/domain/usecases/get_train_details_usecase.dart';
import 'package:ride_way_app/features/booking/domain/usecases/process_payment_usecase.dart';
import 'package:ride_way_app/features/booking/domain/usecases/save_tickets_usecase.dart';
import 'package:ride_way_app/features/booking/domain/usecases/select_seat_usecase.dart';
import 'package:ride_way_app/features/booking/domain/usecases/validate_passengers_usecase.dart';
import 'package:ride_way_app/features/booking/presentation/cubit/booking_cubit.dart';
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
import 'package:ride_way_app/features/trips/data/repositories/notifications_repository_impl.dart';
import 'package:ride_way_app/features/trips/domain/repositories/notifications_repository.dart';
import 'package:ride_way_app/features/trips/domain/usecases/get_notifications_usecase.dart';
import 'package:ride_way_app/features/trips/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/notifications_cubit.dart';
import 'package:ride_way_app/payment/data/datasources/payment_firestore_datasource.dart';
import 'package:ride_way_app/payment/data/datasources/paymob_remote_datasource.dart';
import 'package:ride_way_app/payment/data/repositories/payment_repository_impl.dart';
import 'package:ride_way_app/payment/domain/repositories/payment_repository.dart';
import 'package:ride_way_app/payment/domain/usecases/confirm_payment.dart';
import 'package:ride_way_app/payment/domain/usecases/start_payment.dart';
import 'package:ride_way_app/payment/domain/usecases/watch_payments.dart';
import 'package:ride_way_app/features/trips/data/datasources/ticket_share_firestore_datasource.dart';
import 'package:ride_way_app/features/trips/data/datasources/trips_remote_data_source.dart';
import 'package:ride_way_app/features/trips/data/datasources/trips_local_data_source.dart';
import 'package:ride_way_app/features/trips/data/repositories/trips_repository_impl.dart';
import 'package:ride_way_app/features/trips/domain/repositories/trips_repository.dart';
import 'package:ride_way_app/features/trips/domain/usecases/cancel_booking_usecase.dart';
import 'package:ride_way_app/features/trips/domain/usecases/create_share_link_usecase.dart';
import 'package:ride_way_app/features/trips/domain/usecases/get_booking_detail_usecase.dart';
import 'package:ride_way_app/features/trips/domain/usecases/get_digital_ticket_usecase.dart';
import 'package:ride_way_app/features/trips/domain/usecases/get_my_bookings_usecase.dart';
import 'package:ride_way_app/features/trips/domain/usecases/resolve_share_usecase.dart';
import 'package:ride_way_app/features/trips/domain/usecases/revoke_share_link_usecase.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/digital_ticket_cubit.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/booking_detail_cubit.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/my_bookings_cubit.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/shared_ticket_cubit.dart';
import 'package:ride_way_app/payment/presentation/cubit/payment_cubit.dart';

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

  sl.registerFactory<SearchCubit>(
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
    () => AccountRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<BookingFirestoreDataSource>(
    () => BookingFirestoreDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      firestoreDataSource: sl<BookingFirestoreDataSource>(),
    ),
  );
  sl.registerLazySingleton<GetTrainDetailsUseCase>(
    () => GetTrainDetailsUseCase(sl<BookingRepository>()),
  );
  sl.registerLazySingleton<SelectSeatUseCase>(
    () => SelectSeatUseCase(sl<BookingRepository>()),
  );
  sl.registerLazySingleton<ValidatePassengersUseCase>(
    () => ValidatePassengersUseCase(sl<BookingRepository>()),
  );
  sl.registerLazySingleton<ProcessPaymentUseCase>(
    () => ProcessPaymentUseCase(sl<BookingRepository>()),
  );
  sl.registerLazySingleton<SaveTicketsUsecase>(
    () => SaveTicketsUsecase(bookingRepository: sl<BookingRepository>()),
  );
  sl.registerFactory<BookingCubit>(
    () => BookingCubit(
      getTrainDetailsUseCase: sl<GetTrainDetailsUseCase>(),
      selectSeatUseCase: sl<SelectSeatUseCase>(),
      validatePassengersUseCase: sl<ValidatePassengersUseCase>(),
      processPaymentUseCase: sl<ProcessPaymentUseCase>(),
      saveTicketsUsecase: sl<SaveTicketsUsecase>(),
    ),
  );

  sl.registerLazySingleton<AccountRepository>(
    () =>
        AccountRepositoryImpl(remoteDataSource: sl<AccountRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(sl<AccountRepository>()),
  );

  sl.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(getUserProfileUseCase: sl<GetUserProfileUseCase>()),
  );
  sl.registerLazySingleton<UpdateUserProfileUseCase>(
    () => UpdateUserProfileUseCase(sl<AccountRepository>()),
  );
  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(sl<AccountRepository>()),
  );
  sl.registerFactory<PasswordSecurityCubit>(
    () => PasswordSecurityCubit(
      changePasswordUseCase: sl<ChangePasswordUseCase>(),
      accountRepository: sl<AccountRepository>(),
    ),
  );

  sl.registerFactory<EditProfileCubit>(
    () => EditProfileCubit(
      updateUserProfileUseCase: sl<UpdateUserProfileUseCase>(),
    ),
  );
  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<PaymobRemoteDataSource>(
    () => PaymobRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PaymentFirestoreDataSource>(
    () => PaymentFirestoreDataSource(sl()),
  );

  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<StartPayment>(() => StartPayment(sl()));
  sl.registerLazySingleton<ConfirmPayment>(() => ConfirmPayment(sl()));
  sl.registerLazySingleton<WatchPayments>(() => WatchPayments(sl()));

  sl.registerFactory<PaymentCubit>(
    () => PaymentCubit(startPayment: sl(), confirmPayment: sl()),
  );

  sl.registerLazySingleton<TripsRemoteDataSource>(
    () => TripsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<TripsLocalDataSource>(
    () => TripsLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<TicketShareFirestoreDataSource>(
    () => TicketShareFirestoreDataSource(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<TripsRepository>(
    () => TripsRepositoryImpl(
      remoteDataSource: sl<TripsRemoteDataSource>(),
      localDataSource: sl<TripsLocalDataSource>(),
      shareDataSource: sl<TicketShareFirestoreDataSource>(),
    ),
  );
  sl.registerLazySingleton<GetMyBookingsUseCase>(
    () => GetMyBookingsUseCase(sl<TripsRepository>()),
  );
  sl.registerLazySingleton<GetBookingDetailUseCase>(
    () => GetBookingDetailUseCase(sl<TripsRepository>()),
  );
  sl.registerLazySingleton<GetDigitalTicketUseCase>(
    () => GetDigitalTicketUseCase(sl<TripsRepository>()),
  );
  sl.registerLazySingleton<CancelBookingUseCase>(
    () => CancelBookingUseCase(sl<TripsRepository>()),
  );
  sl.registerLazySingleton<CreateShareLinkUseCase>(
    () => CreateShareLinkUseCase(sl<TripsRepository>()),
  );
  sl.registerLazySingleton<RevokeShareLinkUseCase>(
    () => RevokeShareLinkUseCase(sl<TripsRepository>()),
  );
  sl.registerLazySingleton<ResolveShareUseCase>(
    () => ResolveShareUseCase(sl<TripsRepository>()),
  );
  sl.registerFactory<MyBookingsCubit>(
    () => MyBookingsCubit(getMyBookingsUseCase: sl<GetMyBookingsUseCase>()),
  );
  sl.registerFactory<BookingDetailCubit>(
    () => BookingDetailCubit(
      getBookingDetailUseCase: sl<GetBookingDetailUseCase>(),
      cancelBookingUseCase: sl<CancelBookingUseCase>(),
    ),
  );
  sl.registerFactory<DigitalTicketCubit>(
    () => DigitalTicketCubit(
      getDigitalTicketUseCase: sl<GetDigitalTicketUseCase>(),
      cancelBookingUseCase: sl<CancelBookingUseCase>(),
      createShareLinkUseCase: sl<CreateShareLinkUseCase>(),
    ),
  );
  sl.registerFactory<SharedTicketCubit>(
    () => SharedTicketCubit(resolveShareUseCase: sl<ResolveShareUseCase>()),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      remoteDataSource: sl<TripsRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(sl<NotificationsRepository>()),
  );
  sl.registerLazySingleton<MarkNotificationAsReadUseCase>(
    () => MarkNotificationAsReadUseCase(sl<NotificationsRepository>()),
  );
  sl.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(
      getNotificationsUseCase: sl<GetNotificationsUseCase>(),
      markNotificationAsReadUseCase: sl<MarkNotificationAsReadUseCase>(),
    ),
  );
}
