import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Auth/authenticate.dart';
import 'package:project/Screens/Home/controller.dart';
import 'package:project/services/auth.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    
    if (user == null) {
      return Authenticate();
    }
    else if (!user.emailVerified) {
      return Scaffold(
        body: Center(
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("You have not verified account."),
              const Text("Please check your email."),
              ElevatedButton(
                onPressed: () {
                  AuthService().SignOut();
                },
                child: const Text("Sign out")
              )
            ],
          ),
        ),
      );
    }
    else {
      // var localuser = AuthService.localuser;
      // if (localuser.admin != null) {
      //   if (localuser.admin!) {
      //     print("admin"); 
      //   }
      // }
      return HomeController(); 
    }
  }
}