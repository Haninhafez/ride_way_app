import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide NavigationBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/core/di/injecation.dart';
import 'package:ride_way_app/core/notifications/notification_service.dart';
import 'package:ride_way_app/core/router/app_router.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/core/themes/theme_notfire.dart';
import 'package:ride_way_app/features/account/presentation/cubit/profile_cubit.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.setLoggingEnabled(true);
  await CacheHelper.init();
  await setupDependencies();

  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme();
  final pushService = NotificationService();
  await pushService.initialize();
  final token = await pushService.getToken();
  log("Token : \n $token");

  final appLinks = AppLinks();
  final initialUri = await appLinks.getInitialLink();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeNotifier()..loadTheme()),
          Provider<NotificationService>.value(value: pushService),
          BlocProvider(
            create: ((context) => sl<ProfileCubit>()..loadProfile()),
          ),
        ],
        child: RideWayApp(initialUri: initialUri),
      ),
    ),
  );
}

class RideWayApp extends StatefulWidget {
  final Uri? initialUri;
  const RideWayApp({super.key, this.initialUri});

  @override
  State<RideWayApp> createState() => _RideWayAppState();
}

class _RideWayAppState extends State<RideWayApp> {
  StreamSubscription<Uri>? _linkSub;
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();

    if (widget.initialUri != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleUri(widget.initialUri!);
      });
    }

    _linkSub = _appLinks.uriLinkStream.listen(_handleUri, onError: (_) {});
  }

  void _handleUri(Uri uri) {
    final path = uri.path;
    if (path.startsWith('/ticket/')) {
      appRouter.go(path);
    }
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        final fontFamily = context.locale.languageCode == 'ar'
            ? 'ReadexPro'
            : 'Outfit';

        final customLight = lightTheme.copyWith(
          textTheme: lightTheme.textTheme.apply(fontFamily: fontFamily),
          scaffoldBackgroundColor: lightTheme.scaffoldBackgroundColor,
        );
        final customDark = darkTheme.copyWith(
          textTheme: darkTheme.textTheme.apply(fontFamily: fontFamily),
          scaffoldBackgroundColor: darkTheme.scaffoldBackgroundColor,
        );

        return BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: customLight,
            darkTheme: customDark,
            themeMode: themeNotifier.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
          ),
        );
      },
    );
  }
}
