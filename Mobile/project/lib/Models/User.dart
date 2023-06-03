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
  bool? admin;

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
      if (data.containsKey("admin")) {
      admin = data["admin"];
      }
      else {
        admin = false;
      }
      gender = data['gender'];
      name = data['name'];
      birth = data['birth'];
      
    });
  }
  double getAge() {
    if (birth == null) {
      return 0;
    }
    else {
      // Convert string to DateTime
      var temp = DateTime(int.parse(birth!.split("/")[2]), int.parse(birth!.split("/")[1]), int.parse(birth!.split("/")[0]));
      return (DateTime.now().microsecondsSinceEpoch - temp.microsecondsSinceEpoch)/(1000000*365*24*60*60);
    }
  }
}