import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  late int heartrate;
  late String time;
  late String date;
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
    if (values.containsKey("heart_rate")) {
      heartrate = int.parse(values["heart_rate"].toString());
    }
    if (values.containsKey("date_time")) {
      var datetime = (values["date_time"]! as Timestamp).toDate();
      time = "${datetime.hour} giờ ${datetime.minute} phút ${datetime.second} giây";
      date = "${datetime.day}/${datetime.month}/${datetime.year}";
    }
  }
  Widget _body() {
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
                  Text("Nhịp tim: $heartrate"),
                  const SizedBox(height: 10,),
                  Text("Đo vào lúc: $time"),
                  const SizedBox(height: 10,),
                  Text("Đo vào ngày: $date"),
                ],
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