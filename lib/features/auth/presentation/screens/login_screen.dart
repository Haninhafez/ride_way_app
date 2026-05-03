import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/features/auth/presentation/screens/presenter/auth_mode_provider.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/auth_switcher.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/auth_toggle.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/login_appbar.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/login_card.dart';
import 'package:ride_way_app/features/auth/presentation/screens/widgets/regiseter_card.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    bool islogin=context.watch<AuthModeProvider>().isLogin;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    child: Column(
                      children: [
                        AuthSwitcher(),
                       islogin? LoginCard(theme: theme, width: width):RegisterCard(theme: theme, width: width),
                      ],
                    ),
                  ),
              
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("By continuing, you agree to the Kinetic Authority") 
                )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




