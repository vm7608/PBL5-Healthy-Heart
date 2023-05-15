
import 'package:flutter/material.dart';
class Heartdata {
  Heartdata({required Map<String, dynamic>? result, required this.bpm}) {
    if (result == null) {
      Data = List.empty(growable: true);
      theMostCorrectResult = "";
      bpm = 0;
    }
    else {
      Data = result.entries.toList()..sort((a, b)=> b.value.compareTo(a.value));
      theMostCorrectResult = "${Data[0].key}: ${Data[0].value / Data.length}%\n";

    }
    
  }
  List<MapEntry<String, dynamic>> Data = List.empty(growable: true);
  String? theMostCorrectResult;
  int bpm;

  List<Widget> view() {
    String leftresult = "";
    String rightresult = "";
    for (int i=0; i<Data.length; i++) {
      var element = Data[i];
      if (i%2==0) {
        leftresult += "${element.key}: ${element.value}\n";
      }
      else {
        rightresult += "${element.key}: ${element.value}\n";
      }
    }
    return [
      const SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 200, child: Text("Kết quả đo (chính xác nhất):")),
          SizedBox(width: 80, child: Text(theMostCorrectResult.toString())),
        ],
      ),
      const SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:const [
          SizedBox(width: 280, child: Text("Kết quả đo (toàn bộ):")),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(width: 130, child: Text(leftresult)),
            ],
          ),
          Column(
            children: [
              SizedBox(width: 130, child: Text(rightresult)),
            ],
          ),
        ],
      ),
      const SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 200, child: Text("Nhịp tim trên phút:")),
          SizedBox(width: 80, child: Text(bpm.toString())),
        ],
      ),
    ];
  }
}