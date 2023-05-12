import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Home/HeartMonitor/heartresult.dart';
import 'package:project/WidgetS/Custom.dart';

class HeartScreen extends StatefulWidget {
  const HeartScreen({super.key});
  final String title = "Heart";

  @override
  State<HeartScreen> createState() => _HeartScreenState();
}

class _HeartScreenState extends State<HeartScreen> {
  @override
  
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(96, 119, 213, 232),
      appBar: MyWidget.myAppBar(widget.title),
      body: Center(
        child: RawMaterialButton(
          onPressed: () {
            FirebaseDatabase.instance.ref().get().then((snapshot) {
              Map<Object?, Object?> data = snapshot.value as Map<Object?, Object?>;
              if (data["uid"] == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HeartResult();
                },)); 
              }
            });
          },
          
          fillColor: Colors.blue[100],
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 3,
            ) 
          ),
          padding: const EdgeInsets.all(40),
          child: const Text("Bắt đầu đo"),
        )
      )
      
    );
  }
}
