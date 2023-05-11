import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocalUser {

  String collection = 'profile';
  String? document;
  String? uid;
  String? gender;
  String? email;
  String? name;
  String? birth;

  LocalUser({required this.collection}) {
    User? user= FirebaseAuth.instance.currentUser;
    if (user != null) {
      document = user.uid;

      getData();

      uid = document;
      email = user.email;
    }
    else {
      document = null;
      uid = null;
      gender = null;
      name = null;
      birth = null;
      email = null;
    }
  }

  Future getData() async {
    Map<String, dynamic> data = {};
      var docref = FirebaseFirestore.instance.collection(collection).doc(document).get();
      await docref.then((DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
      });
    
    gender = data['gender'];
    name = data['name'];
    birth = data['birth'];
  }
    
}