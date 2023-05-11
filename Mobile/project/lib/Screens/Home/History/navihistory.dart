import 'package:flutter/material.dart';
import 'package:project/Screens/Home/History/history.dart';

class NaviHistory extends StatelessWidget {
  const NaviHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: 
        (context) {
          return HistoryScreen();
        },);
      },
    );
  }
}