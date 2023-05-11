import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/loading.dart';
import 'package:project/WidgetS/Custom.dart';
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
  Widget body = Center( child: const Text("Waiting..."));
  late DatabaseReference ref;
  bool Issaved = false;
  late int heartrate;
  DateTime time = DateTime.now();
  dynamic listener;
  int run = -1;
  double processDuration = 1.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    body = Loading(); 
    heartrate = 0;
    ref = FirebaseDatabase.instance.ref();
    time = DateTime.now();
    _ValueListener();
    FirebaseDatabase.instance.ref().update({"run":1});
    
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose");
    listener.cancel();
    FirebaseDatabase.instance.ref().update({"run":0});
  }
  void _ValueListener() { 
    
    listener = ref.onValue.listen((event) {
      // try {
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
                run = int.parse(values['run'].toString());
                if (run == 1) {
                  list = List.empty(growable: true);
                  var docs = values["data"].toString();
                  var datas = docs.split(',');
                  for (var i =0; i< datas.length; i++) {
                    list.add(ValueECG(time: double.parse((i*1.0/processDuration).toStringAsFixed(3)), value: int.parse(datas[i].toString()) * 1.0));
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

                  if (values.containsKey("heart_rate")) {
                    heartrate = int.parse(values["heart_rate"].toString());
                  }
                  body = const Loading(text: "    Đang đo\nVui lòng đợi...");
                }
                else {
                  body = _body();
                }
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

  Future changeRun(int run) async {
    await Future.delayed(Duration(minutes: 1), () {
      FirebaseDatabase.instance.ref().update({"run":run});
    },);
  }

  Widget _body() {
    Widget savelabel = const Text("Lưu");
    if (Issaved) {
      savelabel = const Text("Đã lưu");
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
              child: Issaved? const Text("Đã lưu") : const Text("Lưu")),
              const Text("Another result"),
            ],
          )
        ),
      ],
    );
  }

  Map<String, Object> data_set() {
    var data = {
      "data" : { for (var e in list) e.time.toString() : e.value },
      "date_time" : DateTime.now(),
      "heart_rate" : heartrate
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
            FirebaseDatabase.instance.ref().update({"run":1});
          });
        },
        shape: const CircleBorder(
            side: BorderSide(
              color: Colors.blue,
              width: 3,
            ) 
          ),
        padding: const EdgeInsets.all(30),
        fillColor: Colors.blue[400],
        child: const Text("Đo lại"),
      ),
      body: body
    );
  }
}

class ValueECG {
  ValueECG({required this.time, required this.value});
  final double time;
  final double value;
}