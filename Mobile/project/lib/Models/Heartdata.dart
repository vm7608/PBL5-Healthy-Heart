import 'package:flutter/material.dart';
import 'package:project/services/auth.dart';

List<List<double>> NormalBpm = [[0, 1, 100, 160],
                                [1, 3, 90, 150],
                                [3, 5, 80, 140],
                                [6, 12, 70, 120],
                                [12, 18, 60, 100],
                                [18, 100, 60, 100]];
// https://www.webmd.com/heart/ss/slideshow-heart-rate
// https://www.webmd.com/children/children-vital-signs
// https://www.chestercountyhospital.org/news/health-eliving-blog/2023/january/whats-a-good-heart-rate-for-my-age
// https://www.healthline.com/health/heart-rate-chart#normal-heart-rate
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
    if (checkBpm()) {
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
        children: const [
          SizedBox(width: 280, child: Text("Kết quả chuẩn đoán:")),
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
          SizedBox(width: 280, child: Text("Kết quả phân lớp:")),
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
      const SizedBox(height: 30,),

    ];
  }

  bool checkBpm() {
    var user = AuthService.localuser;
    for (int i=0; i<NormalBpm.length; i++) {
      if (user.getAge() >= NormalBpm[i][0] && user.getAge() < NormalBpm[i][1]) {
        if (bpm < NormalBpm[i][2] || bpm > NormalBpm[i][3]) {
          return true;
        }
      }
    }
    return false;
  }
}