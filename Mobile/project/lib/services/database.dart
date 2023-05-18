// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {

  DatabaseService();

  Future UpdateInfoUser(String uid, String name, String birth, String gender) async {
    CollectionReference  userCollection = FirebaseFirestore.instance.collection("profile");
    return await userCollection.doc(uid).set(
      {
        "name": name,
        "birth": birth,
        "gender": gender
      }.map((key, value) => MapEntry<String, dynamic>(key, value))
    );
  }

  Future AddData(String collection, Map<String, String> data) async {
    CollectionReference  homeCollection = FirebaseFirestore.instance.collection(collection);
    QuerySnapshot _myDoc = await homeCollection.get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    return await homeCollection.doc("news${_myDocCount.length}").set(
      data.map((key, value) => MapEntry<String, dynamic>(key, value))
    );
  }
  Future Add(String collection, dynamic data) async {
    print(data.runtimeType);
    CollectionReference  homeCollection = FirebaseFirestore.instance.collection(collection);
    // QuerySnapshot _myDoc = await homeCollection.get();
    // List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    return await homeCollection.doc("${DateTime.now()}").set(
      data
    );
  }
}

class RealtimeDatabase {

  RealtimeDatabase();

  Future SetData(Map<String, dynamic> data, String path) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    await ref.set(data);
  }
  Future UpdateData(Map<String, dynamic> data, String path) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    await ref.update(data);
  }

  Future<DataSnapshot> Readonce(String path) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(path).get();
    return snapshot;
  }

  Future Remove(String path) async {
    final ref = FirebaseDatabase.instance.ref();
    await ref.child(path).remove();
  }

//   DatabaseReference starCountRef =
//         FirebaseDatabase.instance.ref('posts/$postId/starCount');
// starCountRef.onValue.listen((DatabaseEvent event) {
//     final data = event.snapshot.value;
//     updateStarCount(data);
// });
}
