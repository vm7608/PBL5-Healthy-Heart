// ignore_for_file: avoid_print

import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Models/API.dart';
import 'package:project/Models/Heartdata.dart';
import 'package:project/Screens/loading.dart';
import 'package:project/WidgetS/Custom.dart';
import 'package:project/services/auth.dart';
import 'package:project/services/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HeartResult extends StatefulWidget {
  const HeartResult({super.key});
  final String title = "Electrocardiogram Result";

  @override
  State<HeartResult> createState() => _HeartResultState();
}

class _HeartResultState extends State<HeartResult> {

  late List<ValueECG> list = List.empty(growable: true);
  late Map<String, String> data; 
  Widget body = const Center( child: Text("Waiting..."));
  late List<Widget> otherResult = List.empty(growable: true);
  late DatabaseReference ref;
  bool Issaved = false;
  late int heartrate;
  DateTime time = DateTime.now();
  dynamic listener;
  int run = -1;
  double processDuration = 1.0;
  DateTime timeCounter = DateTime.now();
  int CheckTime = 90;
  late Heartdata heart;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    heart = Heartdata(result: null, bpm: 0);
    body = const Loading(); 
    otherResult = [const Text("Waiting another result...")];
    heartrate = 0;
    ref = FirebaseDatabase.instance.ref();
    time = DateTime.now();
    _ValueListener();
    FirebaseDatabase.instance.ref().update({"run":1, "uid": AuthService.localuser.uid, "data": ""});
    checkDevice(CheckTime);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose");
    listener.cancel();
    FirebaseDatabase.instance.ref().update({"run":0, "uid": 0});
  }
  void _ValueListener() { 
    
    listener = ref.onValue.listen((event) {
      // try {
        timeCounter = DateTime.now();
        if (mounted) 
        {
          setState(() {  
              
            if (event.snapshot.value != null) {
              // if (time.add(Duration(minutes: 1)).compareTo(DateTime.now()) < 0) {
              //   FirebaseDatabase.instance.ref().update({"run":0});
              //   print("stop");
              // }
              var values = event.snapshot.value as Map<Object?, Object?>;
              
              if (values.containsKey("time")) {
                processDuration = double.parse(values["time"].toString()) / 1000;
              }

              if (values.containsKey("run")) {
                if (values.containsKey("ip")) {
                  API.host = values["ip"].toString();
                }
                run = int.parse(values['run'].toString());
                if (run == 1) {
                  list = List.empty(growable: true);
                  var docs = values["data"].toString();
                  if (docs!="") {
                    var datas = docs.split(',');
                    for (var i =0; i< datas.length; i++) {
                      list.add(ValueECG(time: double.parse((i*processDuration/datas.length).toStringAsFixed(3)), value: int.parse(datas[i].toString()) * 1.0));
                    }
                    // if (docs.runtimeType != List<Object?>) {
                    //   docs = docs as Map<Object?, Object?>;
                    //   data = docs.map((key, value) => MapEntry(key.toString(), value.toString()));
                    //   var docss = docs.map((key, value) => MapEntry(
                    //     int.parse(key.toString()), int.parse(value.toString())
                    //   ));
                    //   var docsss = docss.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
                    //   docsss.forEach((element) { 
                    //     list.add(ValueECG(time: element.key*1.0, value: element.value*1.0));
                    //   });
                    // }
                    // else {
                    //   docs = docs as List<Object?>;
                    //   for (var i =0; i< docs.length; i++) {
                    //     list.add(ValueECG(time: i*1.0, value: int.parse(docs[i].toString()) * 1.0));
                    //   }
                    // }
                  }
                  

                  if (values.containsKey("heart_rate")) {
                    heartrate = int.parse(values["heart_rate"].toString());
                  }
                  body = const Loading(text: "    Measuring\nPlease waiting...");
                }
                else if (list.isNotEmpty) {
                  body = _body();
                }
              }
              if (run == 0 && list.isNotEmpty) {
                callApi();
              }
            }
          });
        }
    //   }
    //   catch (e) {
    //   print(e);
    // }
    } );
  }

  
  void callApi() async {
    var url = Uri.http(API.host, API.address);
    print(url.toString());
    try {
      var response = await http.get(url);
      var result = json.decode(response.body) as Map<String, dynamic>;
      if (result["success"] == true)
      {
        var resultclass = result["result"] as Map<String, dynamic>;
        heart = Heartdata(result:resultclass, bpm: result["bpm"]);
        
        otherResult = heart.view();
        if (mounted) {
          setState(() {
            body = _body();
          });
        }
      }
      else {
        otherResult = [
          const Text("Something is wrong. Check your device and API.")
        ];
        setState(() {
          body = _body();
        });
      }
    } catch (e) {
      throw e;
      otherResult = [
        const Text("API does not work")
      ];
      if (mounted) { 
        setState(() {
          
          body = _body();
        });
      }
    }
    
  }
  
  Future changeRun(int run) async {
    await Future.delayed(const Duration(seconds: 5), () {
      FirebaseDatabase.instance.ref().update({"run":run});
    },);
  }

  Future checkDevice(int time) async {
    timeCounter = DateTime.now();
    await Future.delayed(Duration(seconds: time-1), () {
      
      if (timeCounter.add(Duration(seconds: time)).compareTo(DateTime.now()) >= 0) {
        print(11);
        if (list.isEmpty && mounted && run == 1) {
          setState(() {
            body = Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Text("The device doesn't work.")],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Text("Please check it and try later")],
                  )
                  
                ],
              ),
            );
            // FirebaseDatabase.instance.ref().update({"run":0, "uid": 0});
          });
        }
      }

    },);

  }

  Widget _body() {
    Widget savelabel = const Text("Save");
    if (Issaved) {
      savelabel = const Text("Saved");
    }
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SafeArea(
            child: SfCartesianChart(
              zoomPanBehavior: ZoomPanBehavior( enablePanning: true, enablePinching: true, zoomMode: ZoomMode.x),
              primaryXAxis: NumericAxis(visibleMaximum: list.last.time, visibleMinimum: list[list.length-51].time),
              series: <ChartSeries>[
                LineSeries<ValueECG, double>(
                  dataSource: list, 
                  xValueMapper: (ValueECG data, index) => data.time, 
                  yValueMapper: (ValueECG data, index) => data.value,
                ),
              ],
            ),
          )
        ),
        const Text("Electrocardiogram"),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(onPressed: () {
                    if (!Issaved && run == 0 && list.isNotEmpty) {
                      DatabaseService().Add("History", data_set());
                      if (mounted) {
                        setState(() {
                          Issaved = true;
                          body = _body();
                        });
                      }
                    }
                    
                  },
                  child: Issaved? const Text("Saved") : const Text("Save")
                ),
                
              ]..addAll(otherResult),
            ),
          )
        ),
      ],
    );
  }

  Map<String, Object?> data_set() {
    var data = {
      "data" : { for (var e in list) e.time.toString() : e.value },
      "date_time" : DateTime.now(),
      "bpm" : heart.bpm,
      "heart" : heart.Data,
      "Mostclass" : heart.theMostCorrectResult,
    };
    var a = data["data"] as Map<String, double>;
    print(a.length);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidget.myAppBar(widget.title),
      floatingActionButton: RawMaterialButton(
        onPressed: () {
          setState(() {
            Issaved = false;
            FirebaseDatabase.instance.ref().update({"run":1, "uid": AuthService.localuser.uid});
            otherResult = [const Text("Waiting another result...")];
            checkDevice(CheckTime);
          });
        },
        shape: const CircleBorder(
            side: BorderSide(
              color: Colors.blue,
              width: 3,
            ) 
          ),
        padding: const EdgeInsets.all(15),
        fillColor: Colors.yellow[400],
        child: const Text("  Try\nagain"),
      ),
      body:  body
    );
  }
}

class ValueECG {
  ValueECG({required this.time, required this.value});
  final double time;
  final double value;
}