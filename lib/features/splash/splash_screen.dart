import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/auth_gate.dart';
import 'package:ride_way_app/features/auth/presentation/screens/login_screen.dart';
import 'package:ride_way_app/features/auth/presentation/screens/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
          LoginScreen()
          
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              "assets/animations/tarin_loder.json",
              height: 25,
            ),
          ),
          SizedBox(height: 20),
          AnimatedTextKit(
            stopPauseOnTap: true,
            repeatForever: true,

            animatedTexts: [
              ScaleAnimatedText(
                "RideWay",
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                duration: const Duration(seconds: 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
