// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/Models/User.dart';
import 'package:project/services/database.dart';

class AuthService {
  late final FirebaseAuth _auth = FirebaseAuth.instance;
  static LocalUser localuser = LocalUser(collection: "profile");
  static String? id;
  static Future<bool> get isVertified async {
    var tuser = AuthService()._auth.currentUser;
    await tuser!.reload();
    if ( !tuser.emailVerified) {
      return false;
    }
    return true;
  }
  Stream<User?> get user {
    var rs = _auth.authStateChanges();
    localuser = LocalUser(collection: "profile");
    return rs;
  }

  Future Register(String email, String password,String name,String birth,String gender) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      result.user!.sendEmailVerification();
      await DatabaseService().UpdateInfoUser(result.user!.uid,name, birth, gender);
      id = result.user!.uid;
      SignOut();
      return result.user;
    } catch (e) {
      print(e.toString());
      id = null;
      return null;
    }
  }
  Future SignIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      id = result.user!.uid;
      return result.user;
    } catch (e) {
      print(e.toString());
      id = null;
      return null;
    }
  }

  Future SignOut() async {
    await _auth.signOut();
    id = null;
  }

  Future ResetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}