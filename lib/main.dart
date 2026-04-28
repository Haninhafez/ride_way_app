import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/core/themes/theme_notfire.dart';
import 'package:ride_way_app/features/splash/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const RideWayApp(),
    ),
  );
}

class RideWayApp extends StatelessWidget {
  const RideWayApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, ThemeNotifier themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: darkTheme,
          theme: lightTheme,
          themeMode: themeNotifier.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          home: SplashScreen(),
        );
      },
    );
  }
}
