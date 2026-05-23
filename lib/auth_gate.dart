import 'package:flutter/material.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/features/auth/presentation/screens/register_screen.dart';
import 'package:ride_way_app/features/home/presentation/screen/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final token = CacheHelper.getData('token');

    if (token != null) {
      return HomeScreen();
    } else {
      return RegisterScreen();
    }
  }
}
