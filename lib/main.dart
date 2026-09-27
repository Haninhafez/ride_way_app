import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide NavigationBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/core/di/injecation.dart';
import 'package:ride_way_app/core/router/app_router.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/core/themes/theme_notfire.dart';
import 'package:ride_way_app/features/auth/data_layer/data_source/auth_data_source.dart';
import 'package:ride_way_app/features/auth/data_layer/repo/auth_implentation_repo.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  await setupDependencies();

  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const RideWayApp(),
      ),
    ),
  );
}

class RideWayApp extends StatelessWidget {
  const RideWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        // Dynamic font family: Arabic uses ReadexPro, English uses Outfit
        final fontFamily = context.locale.languageCode == 'ar'
            ? 'ReadexPro'
            : 'Outfit';

        final customLight = lightTheme.copyWith(
          textTheme: lightTheme.textTheme.apply(fontFamily: fontFamily),
        );
        final customDark = darkTheme.copyWith(
          textTheme: darkTheme.textTheme.apply(fontFamily: fontFamily),
          
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
