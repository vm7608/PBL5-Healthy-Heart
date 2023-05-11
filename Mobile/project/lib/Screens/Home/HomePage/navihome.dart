import 'package:flutter/material.dart';
import 'package:project/Screens/Home/History/history.dart';
import 'package:project/Screens/Home/HomePage/homepage.dart';

class NaviHome extends StatelessWidget {
  const NaviHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: 
        (context) {
          return HomePageScreen();
        },);
      },
    );
  }
}