
import 'package:flutter/material.dart';
class Heartdata {
  Heartdata({required Map<String, dynamic>? result, required this.bpm}) {
    if (result == null) {
      Data = {};
      theMostCorrectResult = "";
      bpm = 0;
    }
    else {
      Data = result;
      var temp = Data.entries.toList()..sort((a, b)=> b.value.compareTo(a.value));
      theMostCorrectResult = "${temp[0].key}: ${temp[0].value}%\n";
    }
    
  }
  Map<String, dynamic> Data = {};
  String? theMostCorrectResult;
  int bpm;

  List<Widget> view() {
    String leftresult = "";
    String rightresult = "";
    var temp = Data.entries.toList()..sort((a, b)=> b.value.compareTo(a.value));
    
    for (int i=0; i<temp.length; i++) {
      var element = temp[i];
      if (i%2==0) {
        leftresult += "${element.key}: ${element.value}%\n";
      }
      else {
        rightresult += "${element.key}: ${element.value}%\n";
      }
    }

    String checkbpm = "Bình thường";
    if (int.parse(bpm.toString()) < 60 && int.parse(bpm.toString()) > 90) {
      checkbpm = "Bất thường";
    }
    Map<String, String> names = {"NOR": "Normal heart beat",
                  "LBB": "Left Bundle Branch Block",
                  "PVC": "Premature Ventricular Contraction",
                  "RBB": "Right Bundle Branch Block ",
                  "PAB": "Paced Beat",
                  "APB": "Atrial Premature Beat",
                  "AFW": "Ventricular flutter wave",
                  "VEB": "Ventricular"};
    return [
      const SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 280, child: Text("Kết quả đo (chính xác nhất):")),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(width: 210, child: Text(names[theMostCorrectResult.toString().split(":")[0]]!)),
        SizedBox(width: 70, child: Text(theMostCorrectResult.toString().split(":")[1])),
      ],),
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
          const SizedBox(width: 150, child: Text("Nhịp tim trên phút:")),
          SizedBox(width: 130),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 150, child: Text("$bpm ($checkbpm)")),
          SizedBox(width: 130),
        ],
      ),
      const SizedBox(height: 60,),

    ];
  }
}