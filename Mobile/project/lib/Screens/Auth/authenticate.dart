import 'package:flutter/material.dart';
import 'package:project/Screens/Auth/log_in.dart';
import 'package:project/Screens/Auth/resetPassword.dart';
import 'package:project/Screens/Auth/sign_up.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class AuthScreen {
  static const String log_in = "log_in";

  static const String log_out = "log_out";
  
  static const String sign_up = "sign_up";

  static const String reset = "reset";
}

class _AuthenticateState extends State<Authenticate> {
  String screen = AuthScreen.log_in; 
  
  String toggleView(screen) {
    setState(() {
      this.screen = screen;
    });
    return this.screen;
  }

  @override
  Widget build(BuildContext context) {
    if (screen == AuthScreen.sign_up) {
      return SignUpScreen(toggleView: toggleView);
    }
    else if (screen == AuthScreen.reset) {
      return ResetPasswordScreen();
    }
    return LogInScreen(toggleView: toggleView);
  }
}