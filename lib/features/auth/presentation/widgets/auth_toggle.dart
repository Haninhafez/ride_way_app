import 'package:flutter/material.dart';

class AuthToggle extends StatelessWidget {
  AuthToggle({
    super.key,

    required this.theme,
    required this.toggle,
    required this.ButtonText,
    required this.isLogin,
  });

  final bool isLogin;
  final String ButtonText;
  final ThemeData theme;
  final void Function() toggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => toggle(),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isLogin ? theme.colorScheme.secondary : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(ButtonText, style: TextStyle(fontSize: 25)),
      ),
    );
  }
}

