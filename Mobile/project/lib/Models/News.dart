import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Home/HomePage/homepage.dart';
import 'package:project/services/database.dart';
import 'package:project/services/storage.dart';

class News {
  News({required this.title, required this.preview, this.imgpath = "", this.content}) {
    preview = preview.replaceAll("\\n", "\n");
    if (content == null) {
      content = "Nội dung chưa được cập nhật hoặc đã bị xoá.";
    }
    else {
      content = content!.replaceAll("\\n", "\n");
    }
  }
  String title;
  String imgpath;
  String preview;
  String? content;

  static Future Add(String title, String preview, String filename, String path) async{
    String imgpath = await StorageService.uploadImage(filename, path);
    Map<String, String> data = {
      "title" : title,
      "imgpath" : imgpath,
      "preview" : preview
    };
    await DatabaseService().AddData("Home", data);
  }

  Widget render(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(10),
      child: TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsContent(news: this),));
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imgpath,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$title\n", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),),
                  Text(preview, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}