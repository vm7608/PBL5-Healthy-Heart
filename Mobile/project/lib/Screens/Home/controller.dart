import 'package:flutter/material.dart';
import 'package:project/Screens/Home/HeartMonitor/heart.dart';
import 'package:project/Screens/Home/HeartMonitor/naviheart.dart';
import 'package:project/Screens/Home/History/history.dart';
import 'package:project/Screens/Home/History/navihistory.dart';
import 'package:project/Screens/Home/HomePage/navihome.dart';
import 'package:project/Screens/Home/Profile/naviprofile.dart';
import 'package:project/Screens/Home/Profile/profile.dart';
import 'package:project/Screens/Home/HomePage/homepage.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  List<Widget> Screens = [NaviHome(), NaviHeart(), NaviHistory(), NaviProfile()];
  String title = HomePageScreen().title;
  int selectedBottomIndex = 1;

  void toggleView(int num) {
    selectedBottomIndex = num;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedBottomIndex - 1,
        children: Screens,
      ),
      bottomNavigationBar: SizedBox(
        height: 50.0,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        color: selectedBottomIndex == 1? Colors.blue[400]: Colors.black,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            toggleView(1);
                            title = HomePageScreen().title;
                          });
                        },
                        icon: const Icon(Icons.home)
                      ),
                      Text("Home", style: TextStyle(color: selectedBottomIndex == 1? Colors.blue[400]: Colors.black),)
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        color: selectedBottomIndex == 2? Colors.blue[400]: Colors.black,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            toggleView(2);
                            title = HeartScreen().title;
                          });
                        },
                        icon: const Icon(Icons.monitor_heart)
                      ),
                      Text("Heart", style: TextStyle(color: selectedBottomIndex == 2? Colors.blue[400]: Colors.black),)
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        color: selectedBottomIndex == 3? Colors.blue[400]: Colors.black,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            toggleView(3);
                            title = HistoryScreen().title;
                          });
                        },
                        icon: const Icon(Icons.history)
                      ),
                      Text("History", style: TextStyle(color: selectedBottomIndex == 3? Colors.blue[400]: Colors.black),)
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        color: selectedBottomIndex == 4? Colors.blue[400]: Colors.black,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            toggleView(4);
                            title = ProfileScreen().title;
                          });
                        },
                        icon: const Icon(Icons.person)
                      ),
                      Text("Profile", style: TextStyle(color: selectedBottomIndex == 4? Colors.blue[400]: Colors.black),)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
