import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/core/utils/form_validators.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:ride_way_app/features/auth/presentation/screens/register_screen.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/continue_button.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/social_media_auth.dart';

class RegisterCard extends StatefulWidget {
  RegisterCard({
    super.key,
    required this.theme,
    required this.width,

  });

  final ThemeData theme;
  final double width;


  @override
  State<RegisterCard> createState() => _RegisterCardState();
}

class _RegisterCardState extends State<RegisterCard> {
  String? firstName;

  String? lastName;

  String? email;

  String? password;

  String? confirmPassword;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key:formKey,
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
            Text("FIRST NAME", style: TextStyle(fontSize: 15)),
            CustomTextField(
              theme: widget.theme,
              hint: 'Enter your first name',
              onChanged: (value) {
                firstName = value;
              },
              validator: (value) => FormValidators.name(value),
            ),
            Text("LAST NAME", style: TextStyle(fontSize: 15)),
            CustomTextField(
              theme: widget.theme,
              hint: 'Enter your last name',
              onChanged: (value) {
                lastName = value;
              },
              validator: (value) => FormValidators.name(value),
            ),
            Text("EMAIL ADDRESS", style: TextStyle(fontSize: 15)),
            CustomTextField(
              theme: widget.theme,
              hint: 'name@example.com',
              onChanged: (value) {
                email = value;
              },
              validator: (value) => FormValidators.email(value),
            ),
            Text("PASSWORD", style: TextStyle(fontSize: 15)),
      
            CustomTextField(
              theme: widget.theme,
              hint: '********',
              validator: (value) => FormValidators.password(value),
              onChanged: (value) {
                password = value;
              },
              // obscureText: true,
            ),
            Text("CONFIRM PASSWORD", style: TextStyle(fontSize: 15)),
      
            CustomTextField(
              theme: widget.theme,
              hint: '********',
              validator: (value) => FormValidators.confirmPasswordValidator(
                password: password,
                confirmPassword: value,
              ),
              // obscureText: true,
              onChanged: (value) {
                confirmPassword = value;
              },
            ),
            ContinueButton(
              width: widget.width,
              theme: widget.theme,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                    AuthRegisterEvent(firstName!, lastName!, email!, password!),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
