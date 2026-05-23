import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/core/utils/form_validators.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/auth_switcher.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/login_appbar.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/login_card.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/login_viwe.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/regiseter_card.dart';

class RegisterViwe extends StatelessWidget {
  RegisterViwe({super.key});

  String? name;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              children: [
                LoginAppBar(),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: RegisterCard(
                    theme: theme,
                    width: width,
                 
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Text("You  have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginViwe(),
                            ),
                          );
                        },
                        child: Text("Login"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
