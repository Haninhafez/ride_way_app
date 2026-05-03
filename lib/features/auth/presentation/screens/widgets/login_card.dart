import 'package:flutter/material.dart';
import 'package:ride_way_app/features/auth/presentation/screens/login_screen.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/continue_button.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/social_media_auth.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key, required this.theme, required this.width});

  final ThemeData theme;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("EMAIL ADDRESS", style: TextStyle(fontSize: 15)),
          CustomTextField(theme: theme, hint: 'name@example.com'),
          Row(
            children: [
              Text("PASSWORD", style: TextStyle(fontSize: 15)),
              Spacer(),
              Text(
                "FORGOT?",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          CustomTextField(theme: theme, hint: 'Password'),
          ContinueButton(width: width, theme: theme),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.grey.shade400,
                  endIndent: 10,
                ),
              ),
              Text(
                "OR CONTINUE WITH",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade400,
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.grey.shade400,
                  indent: 10,
                ),
              ),
            ],
          ),
          SocialMediaAuth(theme: theme),
        ],
      ),
    );
  }
}
