import 'package:flutter/material.dart';

class AuthModeProvider extends ChangeNotifier {
  bool isLogin = true;
  void toggle() {
    isLogin = !isLogin;
    notifyListeners();
  }

  void setLogin() {
    isLogin = true;
    notifyListeners();
  }

  void setRegister() {
    isLogin = false;
    notifyListeners();
  }
}
