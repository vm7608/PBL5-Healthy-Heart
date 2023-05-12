import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    body = const Loading(); 
    otherResult = [const Text("Another result")];
    heartrate = 0;
    ref = FirebaseDatabase.instance.ref();
    time = DateTime.now();
    _ValueListener();
    FirebaseDatabase.instance.ref().update({"run":1, "uid": AuthService.localuser.uid});
    changeRun(0);
    
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
              if (run == 0) {
                callApi();
                body = _body();
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
    // var url = Uri.http('127.0.0.1:8000', '/API');
    // print(url.toString());
    // var response = await http.get(url);
    // var result = json.decode(response.body) as Map<Object, Object>;
    var result = {"success": true, "result": {"A": 0.77, "B": 0.23, "C": 0.43}, "numberofbeats": 31, "bpm": 80};
    print(result.toString());
    if (result["success"] == true)
    {
      var resultclass = result["result"] as Map<String, double>;
      double value = 0.0;
      String classname = "";
      String allresult = "";
      final sorted = resultclass.entries.toList()..sort((a, b)=> b.value.compareTo(a.value));
      value = sorted[0].value;
      classname = sorted[0].key;
      sorted.forEach((element) {
        allresult += "${element.key}: ${element.value}\n";
      });
      print(sorted);
      otherResult = [
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 200, child: Text("Kết quả đo (chính xác nhất):")),
            SizedBox(width: 80, child: Text(classname)),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 200, child: Text("Kết quả đo (toàn bộ):")),
            SizedBox(width: 80, child: Text(allresult)),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 200, child: Text("Nhịp tim trên phút:")),
            SizedBox(width: 80, child: Text(result["bpm"].toString())),
          ],
        ),
      ];
    }
  }
  
  Future changeRun(int run) async {
    await Future.delayed(const Duration(seconds: 5), () {
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
                child: Issaved? const Text("Đã lưu") : const Text("Lưu")
              ),
              
            ]..addAll(otherResult),
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
            FirebaseDatabase.instance.ref().update({"run":1, "uid": AuthService.localuser.uid});
            otherResult = [const Text("Another result")];
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