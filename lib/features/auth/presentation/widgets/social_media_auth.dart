import 'package:flutter/material.dart';
import 'package:ride_way_app/features/auth/presentation/screens/register_screen.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/social_button.dart';

class SocialMediaAuth extends StatelessWidget {
  const SocialMediaAuth({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 5,
        children: [
          SocialButton(
            theme: theme,
            svgPicture: 'assets/images/app_images/google.svg',
            ButtonText: 'Google',
          ),

          SocialButton(
            theme: theme,
            svgPicture: 'assets/images/app_images/apple.svg',
            ButtonText: 'Apple',
          ),
        ],
      ),
    );
  }
}
