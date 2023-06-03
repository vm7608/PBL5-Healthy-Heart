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
        height: 80.0,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            toggleView(1);
                            title = HomePageScreen().title;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.home,size:30, color: selectedBottomIndex == 1? Colors.blue[400]: Colors.black
                            ),
                            Text("Home", style: TextStyle(color: selectedBottomIndex == 1? Colors.blue[400]: Colors.black),)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            toggleView(2);
                            title = HeartScreen().title;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.monitor_heart,size:30, color: selectedBottomIndex == 2? Colors.blue[400]: Colors.black),
                            Text("Heart", style: TextStyle(color: selectedBottomIndex == 2? Colors.blue[400]: Colors.black),)
                          ],
                        ),
                      ),
                    ),
                    
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            toggleView(3);
                            title = HistoryScreen().title;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.history,size:30, color: selectedBottomIndex == 3? Colors.blue[400]: Colors.black),
                            Text("History", style: TextStyle(color: selectedBottomIndex == 3? Colors.blue[400]: Colors.black),)
                          ],
                        ),
                      ),
                    ),
                    
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            toggleView(4);
                            title = ProfileScreen().title;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.person,size:30, color: selectedBottomIndex == 4? Colors.blue[400]: Colors.black),
                            Text("Profile", style: TextStyle(color: selectedBottomIndex == 4? Colors.blue[400]: Colors.black),)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
