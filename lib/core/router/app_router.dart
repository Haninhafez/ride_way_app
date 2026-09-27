import 'package:flutter/material.dart' hide NavigationBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/features/account/presentation/screens/edit_profile_screen.dart';
import 'package:ride_way_app/features/account/presentation/screens/password_security_screen.dart';
import 'package:ride_way_app/features/account/presentation/screens/profile_screen.dart';
import 'package:ride_way_app/features/auth/presentation/screens/login_screen.dart';
import 'package:ride_way_app/features/auth/presentation/screens/register_screen.dart';
import 'package:ride_way_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:ride_way_app/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:ride_way_app/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:ride_way_app/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:ride_way_app/features/booking/domain/usecases/get_train_details_usecase.dart';
import 'package:ride_way_app/features/booking/domain/usecases/process_payment_usecase.dart';
import 'package:ride_way_app/features/booking/domain/usecases/select_seat_usecase.dart';
import 'package:ride_way_app/features/booking/domain/usecases/validate_passengers_usecase.dart';
import 'package:ride_way_app/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:ride_way_app/features/booking/presentation/screens/booking_success_screen.dart';
import 'package:ride_way_app/features/booking/presentation/screens/passenger_details_screen.dart';
import 'package:ride_way_app/features/booking/presentation/screens/payment_screen.dart';
import 'package:ride_way_app/features/booking/presentation/screens/seat_selection_screen.dart';
import 'package:ride_way_app/features/booking/presentation/screens/train_details_screen.dart';
import 'package:ride_way_app/features/home/presentation/screen/navigation_bar.dart';
import 'package:ride_way_app/features/onboarding/onboarding_screen.dart';
import 'package:ride_way_app/features/search/presentation/screens/home_search_invalid.dart';
import 'package:ride_way_app/features/search/presentation/screens/stations_unavailable_screen.dart';
import 'package:ride_way_app/features/search_and_discovery/data/datasources/search_local_data_source.dart';
import 'package:ride_way_app/features/search_and_discovery/data/datasources/search_remote_data_source.dart';
import 'package:ride_way_app/features/search_and_discovery/data/repositories/search_repository_impl.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/entities/search_query.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/filter_and_sort_trains_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/get_recent_searches_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/get_saved_routes_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/search_trains_usecase.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/search_cubit.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/train_list_cubit.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/screens/train_list_screen.dart';
import 'package:ride_way_app/features/splash/splash_screen.dart';
import 'package:ride_way_app/features/support/presentation/screens/help_support_screen.dart';

// Clean Architecture DI Setup for Booking
final _bookingRemoteDataSource = BookingRemoteDataSourceImpl();
final _bookingLocalDataSource = BookingLocalDataSourceImpl();
final _bookingRepository = BookingRepositoryImpl(
  remoteDataSource: _bookingRemoteDataSource,
  localDataSource: _bookingLocalDataSource,
);

final bookingCubit = BookingCubit(
  getTrainDetailsUseCase: GetTrainDetailsUseCase(_bookingRepository),
  selectSeatUseCase: SelectSeatUseCase(_bookingRepository),
  validatePassengersUseCase: ValidatePassengersUseCase(_bookingRepository),
  processPaymentUseCase: ProcessPaymentUseCase(_bookingRepository),
);

// Clean Architecture DI Setup for Search & Discovery
final _searchRemoteDataSource = SearchRemoteDataSourceImpl();
final _searchLocalDataSource = SearchLocalDataSourceImpl();
final _searchRepository = SearchRepositoryImpl(
  remoteDataSource: _searchRemoteDataSource,
  localDataSource: _searchLocalDataSource,
);

final searchCubit = SearchCubit(
  getRecentSearchesUseCase: GetRecentSearchesUseCase(_searchRepository),
  getSavedRoutesUseCase: GetSavedRoutesUseCase(_searchRepository),
);

final trainListCubit = TrainListCubit(
  searchTrainsUseCase: SearchTrainsUseCase(_searchRepository),
  filterAndSortTrainsUseCase: FilterAndSortTrainsUseCase(_searchRepository),
);

/// Central GoRouter configuration for RideWay.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
   final token = CacheHelper.getData('token');
  final isOnboardingSeen = CacheHelper.getData('isOnboardingSeen') ?? false;

  final isSplash = state.matchedLocation == '/';
  final isOnboarding = state.matchedLocation == '/onboarding';

  final isAuth = state.matchedLocation == '/login' ||
      state.matchedLocation == '/register' ||
      state.matchedLocation == '/reset-password';

  final isBookingOrSearchRoute =
      state.matchedLocation.startsWith('/train-details') ||
      state.matchedLocation.startsWith('/seat-selection') ||
      state.matchedLocation.startsWith('/passenger-details') ||
      state.matchedLocation.startsWith('/payment') ||
      state.matchedLocation.startsWith('/booking-success') ||
      state.matchedLocation.startsWith('/train-list');

  // 1. ترك الـ Splash تُعرض حتى تنتهي المهلة الزمنية (Timer)
  if (isSplash) {
    return null;
  }

  // 2. إذا كان مسجلاً بالفعلاً وحاول فتح Onboarding أو Auth -> توجيه للـ Home
  if (token != null && (isAuth || isOnboarding)) {
    return '/home';
  }

  // 3. إذا لم يمر بالـ Onboarding من قبل -> توجيه للـ Onboarding
  if (!isOnboardingSeen && !isOnboarding) {
    return '/onboarding';
  }

  // 4. إذا لم يكن مسجلاً وبحاجة للتسجيل عند محاولة فتح شاشات محمية
  if (token == null && !isAuth && !isBookingOrSearchRoute && !isOnboarding) {
    return '/login';
  }

  return null;
},
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child:  OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/reset-password',
      name: 'reset-password',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return ResetPasswordScreen(email: email);
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => MultiBlocProvider(
        providers: [BlocProvider<SearchCubit>.value(value: searchCubit)],
        child: NavigationBar(),
      ),
    ),
    GoRoute(
      path: '/train-list',
      name: 'train-list',
      builder: (context, state) {
        final query = state.extra as SearchQuery?;
        return BlocProvider<TrainListCubit>.value(
          value: trainListCubit,
          child: TrainListScreen(searchQuery: query),
        );
      },
    ),

    // Booking Flow ShellRoute to share BookingCubit across screens
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider<BookingCubit>.value(
          value: bookingCubit..loadTrainDetails('SE-200'),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/train-details',
          name: 'train-details',
          builder: (context, state) {
            final trainId = state.uri.queryParameters['trainId'] ?? 'SE-200';
            return TrainDetailsScreen(trainId: trainId);
          },
        ),
        GoRoute(
          path: '/seat-selection',
          name: 'seat-selection',
          builder: (context, state) => const SeatSelectionScreen(),
        ),
        GoRoute(
          path: '/passenger-details',
          name: 'passenger-details',
          builder: (context, state) => const PassengerDetailsScreen(),
        ),
        GoRoute(
          path: '/payment',
          name: 'payment',
          builder: (context, state) => const PaymentScreen(),
        ),
        GoRoute(
          path: '/booking-success',
          name: 'booking-success',
          builder: (context, state) => const BookingSuccessScreen(),
        ),
      ],
    ),
  ],
);
