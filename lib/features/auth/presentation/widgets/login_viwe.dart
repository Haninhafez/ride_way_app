import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/core/utils/form_validators.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/auth_switcher.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/login_appbar.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/login_card.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/regiseter_card.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/register_viwe.dart';

class LoginViwe extends StatelessWidget {
  LoginViwe({super.key});

  GlobalKey<FormState> LoginformKey = GlobalKey<FormState>();
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
                  child: LoginCard(
                    formKey: LoginformKey,
                    theme: theme,
                    width: width,
                  ),
                ),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Text("You don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterViwe(),
                            ),
                          );
                        },
                        child: Text("Register"),
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
