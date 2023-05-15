import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/Screens/Home/History/historyDetail.dart';
import 'package:project/WidgetS/Custom.dart';
import 'package:project/services/database.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  final String title = "History";

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  AppBar? myappbar;
  List<int> Screen = List.empty();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myappbar = MyWidget.myAppBar("History");
  }

  void download() async {
    
  }

  @override
  Widget build(BuildContext context) {
    final _Stream =
        FirebaseFirestore.instance.collection('History').snapshots();
    return Scaffold(
      appBar: myappbar, 
      backgroundColor: const Color.fromARGB(96, 119, 213, 232),
      body: StreamBuilder(
        stream: _Stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (var doc in snapshot.data!.docs) {
            }
            return ListView(
              children: [
                for (var doc in snapshot.data!.docs) ListTile(
                  shape: RoundedRectangleBorder( 
                    side: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ), 
                  tileColor: Colors.white,
                  leading: const SpinKitPumpingHeart(color: Colors.red,),
                  title: Text("Heart rate: ${doc['bpm']}"), 
                  subtitle: Text('Date: ${doc['date_time'].toDate()}'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return historyDetail(id: doc.id,);
                    }));
                  },
                )
              ],
            );
          }
          return Column(       
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Center(child: const Text("Chưa có dữ liệu")),
              
              ElevatedButton(onPressed: () {
                setState(() {
                  
                });
              }, child: Text("Bấm")),
              
            ]
          );
        },
      )
    );
  }
}

class History_element {
  History_element({data, required this.rate_heart, required this.date_time}) {
    data = data as Map<Object?, Object?>;
  }

  late List<int> data;
  final rate_heart;
  final date_time;
}