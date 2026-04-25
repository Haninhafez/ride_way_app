import 'package:flutter/material.dart';
import 'package:ride_way_app/features/auth/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
     
      home: SplashScreen()
    );
  }
}
