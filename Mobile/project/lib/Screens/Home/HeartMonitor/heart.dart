import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Home/HeartMonitor/heartresult.dart';
import 'package:project/WidgetS/Custom.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  
  void callApi() async {
    print(1);
    var url = Uri.http('172.21.0.166', '/getdata');
    print(url);
    var response = await http.get(url);
    var otherResult = json.decode(response.body);
    print('Response body: ${otherResult["len"]}');
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(96, 119, 213, 232),
      appBar: MyWidget.myAppBar(widget.title),
      body: Center(
        child: RawMaterialButton(
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return HeartResult();
            // },)); 
            callApi();
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
