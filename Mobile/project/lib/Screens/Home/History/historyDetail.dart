import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/Models/Heartdata.dart';
import 'package:project/Screens/Home/HeartMonitor/heartresult.dart';
import 'package:project/Screens/loading.dart';
import 'package:project/WidgetS/Custom.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class historyDetail extends StatefulWidget {
  const historyDetail({super.key, this.id});
  final title = "Detail";
  final id;
  @override
  State<historyDetail> createState() => _historyDetailState();
}

class _historyDetailState extends State<historyDetail> {
  late List<ValueECG> list = List.empty(growable: true);
  late Map<String, String> data;
  late int bpm;
  late String time;
  late String date;
  late List<MapEntry<String, dynamic>> heart;
  late String? theMostCorrectResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidget.myAppBar(widget.title),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('History').doc(widget.id).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            getData(snapshot.data!.data());

            return _body();
          }
          return const Loading();
        },
      )
    );
  }
  void getData(value) {
    list = List.empty(growable: true);
    var values = value as Map<Object?, Object?>;

    var docs = values["data"] as Map<Object?, Object?>;
    data = docs.map((key, value) => MapEntry(key.toString(), value.toString()));
    var docss = docs.map((key, value) => MapEntry(
      double.parse(key.toString()), double.parse(value.toString()).round()
    ));
    var docsss = docss.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    docsss.forEach((element) { 
        list.add(ValueECG(time: element.key*1.0, value: element.value*1.0));
    });
    if (values.containsKey("bpm")) {
      bpm = int.parse(values["bpm"].toString());
    }
    if (values.containsKey("date_time")) {
      var datetime = (values["date_time"]! as Timestamp).toDate();
      time = "${datetime.hour} giờ ${datetime.minute} phút ${datetime.second} giây";
      date = "${datetime.day}/${datetime.month}/${datetime.year}";
    }
    if (values.containsKey("Mostclass")) {
      var temp = values["Mostclass"];
      theMostCorrectResult = temp.toString();
    }
    if (values.containsKey("heart")) {
      var temp = values["heart"] as List<dynamic>;
      heart = temp.map((e) {
        MapEntry me = e as MapEntry;
        return MapEntry(e.key.toString(), e.value);
      }).toList();
    }
  }
  Widget _body() {
    Heartdata heartdata = Heartdata(result: null, bpm: 0);
    heartdata.bpm = bpm;
    heartdata.Data = heart;
    heartdata.theMostCorrectResult = theMostCorrectResult;
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
        const Text("Điện tâm đồ"),
        const SizedBox(height: 20,),
        Expanded(
          flex: 1,
          child: Row(
            children: [ 
              const SizedBox(width: 30,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Đo vào lúc: $time"),
                  const SizedBox(height: 10,),
                  Text("Đo vào ngày: $date"),
                ]..addAll(heartdata.view()),
              ),
            ],
          )
        ),
        ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance.collection('History').doc(widget.id).delete();
            Navigator.pop(context);
          },
          child: const Text("Xoá")
        )
      ],
    );
  }
}