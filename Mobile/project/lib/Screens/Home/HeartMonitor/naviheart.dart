import 'package:flutter/material.dart';
import 'package:project/Screens/Home/HeartMonitor/heart.dart';

class NaviHeart extends StatelessWidget {
  const NaviHeart({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: 
        (context) {
          return HeartScreen();
        },);
      },
    );
  }
}