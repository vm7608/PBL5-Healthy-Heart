import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  const Note({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Các loại bệnh", overflow: TextOverflow.fade,),
      ),
      body: SingleChildScrollView(
        child: Center(
          child:  
            Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(child: Text("CÁC LOẠI BỆNH", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ), 
                const SizedBox(height: 20),
                NoteElement("-NOR : <t>Normal Sinus Rhythm"),
                NoteElement("Nhịp xoang bình thường"),
                const SizedBox(height: 10),
                NoteElement("-LBB : <t>Left Bundle Branch Block"),
                NoteElement("Rối loạn dẫn truyền do khối nhánh trái bị ngăn cản"),
                const SizedBox(height: 10),
                NoteElement("-PVC : <t>Premature Ventricular Contraction"),
                NoteElement("Nhịp tâm thất bất thường xuất phát từ tâm thất"),
                const SizedBox(height: 10),
                NoteElement("-RBB : <t>Right Bundle Branch Block"),
                NoteElement("Rối loạn dẫn truyền do khối nhánh phải bị ngăn cản"),
                const SizedBox(height: 10),
                NoteElement("-PAB : <t>Paced Beat"),
                NoteElement("Nhịp tim được tạo bởi máy phát nhịp điện cắm trong cơ thể"),
                const SizedBox(height: 10),
                NoteElement("-APB : <t>Atrial Premature Beat"),
                NoteElement("Nhịp xoang bất thường xuất phát từ tâm nhĩ"),
                const SizedBox(height: 10),
              ],
            ),
        ),
      ),
    );
  }

  Widget NoteElement(String text) {
    List<Widget> list = List.empty(growable: true);
    text.split("<t>").forEach((element) {
      list.add(
        Expanded(
          flex: 2 == text.split("<t>").length ? 0 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(element, softWrap: true,)],
          ),
        ),
      );
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Row(
        children: list
      ),
    );
  }
}