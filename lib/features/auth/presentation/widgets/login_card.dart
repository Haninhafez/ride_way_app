import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/core/utils/form_validators.dart';
import 'package:ride_way_app/features/auth/domin/entity/user_entity.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:ride_way_app/features/auth/presentation/screens/register_screen.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/continue_button.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/social_media_auth.dart';
import 'package:ride_way_app/features/home/presentation/screen/home_screen.dart';

class LoginCard extends StatefulWidget {
  LoginCard({
    super.key,
    required this.theme,
    required this.width,
    required this.formKey,
  });

  final ThemeData theme;
  final double width;
  final GlobalKey<FormState> formKey;

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  String? email;

  String? password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          color: widget.theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("EMAIL ADDRESS", style: TextStyle(fontSize: 15)),
            CustomTextField(
              theme: widget.theme,
              hint: 'name@example.com',
              onChanged: (value) => email = value!,
              validator: (value) => FormValidators.email(value),
            ),
            Row(
              children: [
                Text("PASSWORD", style: TextStyle(fontSize: 15)),
                Spacer(),
                Text(
                  "FORGOT?",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: widget.theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            CustomTextField(
              theme: widget.theme,
              hint: '*********',
              onChanged: (value) => password = value!,
              validator: (value) => FormValidators.password(value),
              obscureText: true,
            ),
            ContinueButton(
              width: widget.width,
              theme: widget.theme,
              onTap: () async {
                if (widget.formKey.currentState!.validate()) {
                   context.read<AuthBloc>().add(
                    AuthLoginEvent(email!, password!),
                  );
                  
                }
              },
            ),
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
            SocialMediaAuth(theme: widget.theme),
          ],
        ),
      ),
    );
  }
}
