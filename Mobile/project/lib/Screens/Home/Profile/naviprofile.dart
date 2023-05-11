import 'package:flutter/material.dart';
import 'package:project/Screens/Home/Profile/profile.dart';

class NaviProfile extends StatelessWidget {
  const NaviProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: 
        (context) {
          return ProfileScreen();
        },);
      },
    );
  }
}