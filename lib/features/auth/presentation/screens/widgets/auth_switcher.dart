import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/features/auth/presentation/screens/presenter/auth_mode_provider.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/auth_toggle.dart';

class AuthSwitcher extends StatefulWidget {
  const AuthSwitcher({super.key, });
 

  @override
  State<AuthSwitcher> createState() => _AuthSwitcherState();
}

class _AuthSwitcherState extends State<AuthSwitcher> {
  @override
  Widget build(BuildContext context) {
    final isLogin = context.watch<AuthModeProvider>().isLogin;
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.21),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AuthToggle(
            isLogin: isLogin,
            ButtonText: "Login",
            toggle: () {
              context.read<AuthModeProvider>().setLogin();
            },
            theme: theme,
          ),
          AuthToggle(
            isLogin: !isLogin,
            ButtonText: "Register",
            toggle: () {
              context.read<AuthModeProvider>().setRegister();
            },
            theme: theme,
          ),
        ],
      ),
    );
  }
}
