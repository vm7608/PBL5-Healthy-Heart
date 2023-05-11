import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final Reference ref = FirebaseStorage.instance.ref();
  static String pathImage = "files/imgs/";

  static Future<String> uploadImage(String filename, String path) async {
    ref.child(pathImage + filename);
    File file = File(path);

    ref.putFile(file);
    return await ref.getDownloadURL();
  }
}