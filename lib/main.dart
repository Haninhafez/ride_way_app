import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/core/themes/theme_notfire.dart';
import 'package:ride_way_app/features/auth/data_layer/data_source/auth_data_source.dart';
import 'package:ride_way_app/features/auth/data_layer/repo/auth_implentation_repo.dart';
import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:ride_way_app/features/auth/presentation/screens/register_screen.dart';
import 'package:ride_way_app/features/home/presentation/screen/home_screen.dart';
import 'package:ride_way_app/features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await CacheHelper.init();
  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const RideWayApp(),
    ),
  );
}

class RideWayApp extends StatelessWidget {
  const RideWayApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return BlocProvider(
          create: (context) => AuthBloc(AuthImplentationRepo(AuthDataSource(dio: Dio(BaseOptions(baseUrl: ApiEndPoints.baseUrl))))),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: darkTheme,
            theme: lightTheme,
            themeMode: themeNotifier.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
