import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/auth_toggle.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/login_card.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/regiseter_card.dart';

class AuthSwitcher extends StatefulWidget {
  const AuthSwitcher({
    super.key, required this.formKeyRegister, required this.LoginformKey,
    
  });
  final GlobalKey<FormState> formKeyRegister;
 final  GlobalKey<FormState> LoginformKey;

  @override
  State<AuthSwitcher> createState() => _AuthSwitcherState();
}

class _AuthSwitcherState extends State<AuthSwitcher> {
  @override
  bool isLogin = true;
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.15),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withAlpha(50),
            borderRadius: BorderRadius.circular(10),
          ),
        
          child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthToggle(
                    isLogin: isLogin,
                    ButtonText: "Login",
                    toggle: () {
                      isLogin = true;
                      setState(() {});
                    },
                    theme: theme,
                  ),
                  AuthToggle(
                    isLogin: !isLogin,
                    ButtonText: "Register",
                    toggle: () {
                      isLogin = false;
                      setState(() {});
                    },
                    theme: theme,
                  ),
                ],
              ),
        ),
        
              // isLogin
              //     ? LoginCard(theme: theme, width: width, formKey: widget.LoginformKey)
              //     : 
                  // RegisterCard(
                  //     theme: theme,
                  //     width: width,
                  //     formkey: widget.formKeyRegister,
                  //   ),
            
        
      ],
    );
  }
}
