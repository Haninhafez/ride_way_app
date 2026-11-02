import 'dart:developer';

import 'package:flutter/material.dart' hide NavigationBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/core/di/injecation.dart';
import 'package:ride_way_app/features/account/presentation/cubit/profile_cubit.dart';
import 'package:ride_way_app/features/account/presentation/screens/edit_profile_screen.dart';
import 'package:ride_way_app/features/auth/presentation/screens/login_screen.dart';
import 'package:ride_way_app/features/auth/presentation/screens/register_screen.dart';
import 'package:ride_way_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:ride_way_app/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:ride_way_app/features/booking/presentation/screens/booking_success_screen.dart';
import 'package:ride_way_app/features/booking/presentation/screens/passenger_details_screen.dart';
import 'package:ride_way_app/features/booking/presentation/screens/payment_screen.dart';
import 'package:ride_way_app/features/booking/presentation/screens/seat_selection_screen.dart';
import 'package:ride_way_app/features/booking/presentation/screens/train_details_screen.dart';
import 'package:ride_way_app/features/home/presentation/screen/navigation_bar.dart';
import 'package:ride_way_app/features/onboarding/onboarding_screen.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/entities/search_query.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/search_cubit.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/train_list_cubit.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/screens/train_list_screen.dart';
import 'package:ride_way_app/features/splash/splash_screen.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/booking_detail_cubit.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/digital_ticket_cubit.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/my_bookings_cubit.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/notifications_cubit.dart';
import 'package:ride_way_app/features/trips/presentation/screens/booking_detail_screen.dart';
import 'package:ride_way_app/features/trips/presentation/screens/digital_ticket_screen.dart';
import 'package:ride_way_app/features/trips/presentation/screens/my_bookings_screen.dart';
import 'package:ride_way_app/features/trips/presentation/screens/shared_ticket_screen.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/shared_ticket_cubit.dart';
import 'package:ride_way_app/payment/presentation/cubit/payment_cubit.dart';
import 'package:ride_way_app/payment/presentation/pages/payment_webview_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final token = CacheHelper.getData('token');
    final isOnboardingSeen = CacheHelper.getData('isOnboardingSeen') ?? false;

    final isSplash = state.matchedLocation == '/';
    final isOnboarding = state.matchedLocation == '/onboarding';

    final isAuth =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/reset-password';

    final isBookingOrSearchRoute =
        state.matchedLocation.startsWith('/train-details') ||
        state.matchedLocation.startsWith('/seat-selection') ||
        state.matchedLocation.startsWith('/passenger-details') ||
        state.matchedLocation.startsWith('/payment') ||
        state.matchedLocation.startsWith('/webview') ||
        state.matchedLocation.startsWith('/booking-success') ||
        state.matchedLocation.startsWith('/train-list') ||
        state.matchedLocation.startsWith('/booking-detail') ||
        state.matchedLocation.startsWith('/digital-ticket') ||
        state.matchedLocation.startsWith('/my-bookings');

    final isPublicTicketShare = state.matchedLocation.startsWith('/ticket');

    if (isSplash) {
      return null;
    }

    if (token != null && (isAuth || isOnboarding)) {
      return '/home';
    }

    if (!isOnboardingSeen && !isOnboarding) {
      return '/onboarding';
    }

    if (token == null &&
        !isAuth &&
        !isBookingOrSearchRoute &&
        !isOnboarding &&
        !isPublicTicketShare) {
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
          child: OnboardingScreen(),
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
      builder: (context, state) {
        final query = state.extra as SearchQuery?;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<SearchCubit>()..loadStations(),
            ),
            BlocProvider(
              create: (context) => sl<TrainListCubit>()..executeSearch(query!),
            ),
            BlocProvider(
              create: (context) => sl<MyBookingsCubit>()..loadBookings(),
            ),
            BlocProvider(
              create: (context) =>
                  sl<NotificationsCubit>()..loadNotifications(),
            ),
            
           
          ],

          child: NavigationBar(),
        );
      },
    ),
    GoRoute(
      path: '/edit/profile',
      name: 'EditProfile',
      builder: (context, state) => EditProfileScreen(),
    ),
    GoRoute(
      path: '/train-list',
      name: 'train-list',
      builder: (context, state) {
        final query = state.extra as SearchQuery?;
        return BlocProvider(
          create: (context) => sl<TrainListCubit>(),
          child: TrainListScreen(searchQuery: query!),
        );
      },
    ),

    GoRoute(
      path: '/my-bookings',
      name: 'my-bookings',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<MyBookingsCubit>()..loadBookings(),
        child: const MyBookingsScreen(),
      ),
    ),

    GoRoute(
      path: '/booking-detail/:bookingId',
      name: 'booking-detail',
      builder: (context, state) {
        final bookingId = state.pathParameters['bookingId'] ?? '';
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<BookingDetailCubit>()..loadDetail(bookingId),
            ),
          ],
          child: BookingDetailScreen(bookingId: bookingId),
        );
      },
    ),

    GoRoute(
      path: '/digital-ticket/:bookingId',
      name: 'digital-ticket',
      builder: (context, state) {
        final bookingId = state.pathParameters['bookingId'] ?? '';
        return BlocProvider(
          create: (_) => sl<DigitalTicketCubit>(),
          child: DigitalTicketScreen(bookingId: bookingId),
        );
      },
    ),

    GoRoute(
      path: '/ticket/:token',
      name: 'shared-ticket',
      builder: (context, state) {
        final token = state.pathParameters['token'] ?? '';
        return BlocProvider(
          create: (_) => sl<SharedTicketCubit>(),
          child: SharedTicketScreen(token: token),
        );
      },
    ),

    ShellRoute(
      builder: (context, state, child) {
        final trainId = state.uri.queryParameters['trainId'] ?? '';
        return MultiBlocProvider(
          providers: [
            BlocProvider<BookingCubit>(
              create: (_) => sl<BookingCubit>()
                ..loadTrainDetails(trainId)
                ..loadUserData(),
            ),
            BlocProvider(create: (context) => sl<PaymentCubit>()),
          ],
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/train-details',
          name: 'train-details',
          builder: (context, state) {
            final trainId = state.uri.queryParameters['trainId'];
            log('trainId=$trainId');
            return TrainDetailsScreen(trainId: trainId!);
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
          builder: (context, state) => PassengerDetailsScreen(),
        ),
        GoRoute(
          path: '/payment',
          name: 'payment',
          builder: (context, state) => const PaymentScreen(),
        ),
        GoRoute(
          path: '/payment-webview',
          name: 'payment-webview',
          builder: (context, state) {
            final url = state.extra as String?;
            if (url == null || url.isEmpty) {
              return Scaffold(
                appBar: AppBar(title: const Text('خطأ')),
                body: const Center(child: Text('رابط الدفع غير صالح')),
              );
            }
            return PaymentWebViewPage(url: url);
          },
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
