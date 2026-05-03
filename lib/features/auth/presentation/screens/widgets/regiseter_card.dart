import 'package:flutter/material.dart';
import 'package:ride_way_app/features/auth/presentation/screens/login_screen.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/continue_button.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/social_media_auth.dart';

class RegisterCard extends StatelessWidget {
  const RegisterCard({super.key, required this.theme, required this.width});

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
          Text("FIRST NAME", style: TextStyle(fontSize: 15)),
          CustomTextField(theme: theme, hint: 'Enter your first name'),
          Text("LAST NAME", style: TextStyle(fontSize: 15)),
          CustomTextField(theme: theme, hint: 'Enter your last name'),
          Text("EMAIL ADDRESS", style: TextStyle(fontSize: 15)),
          CustomTextField(theme: theme, hint: 'name@example.com'),
          Text("PASSWORD", style: TextStyle(fontSize: 15)),
      
          CustomTextField(theme: theme, hint: '********'),
          Text("CONFIRM PASSWORD", style: TextStyle(fontSize: 15)),
      
          CustomTextField(theme: theme, hint: '********'),
          ContinueButton(width: width, theme: theme),
         
        ],
      ),
    );
  }
}


