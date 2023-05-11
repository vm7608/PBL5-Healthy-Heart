import 'package:flutter/material.dart';
import 'package:project/Screens/Auth/authenticate.dart';
import 'package:project/Screens/Auth/resetPassword.dart';
import 'package:project/Screens/loading.dart';
import 'package:project/WidgetS/Custom.dart';
import 'package:project/services/auth.dart';

class LogInScreen extends StatefulWidget {
  final Function toggleView;
  const LogInScreen({required this.toggleView, super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailctrler = TextEditingController();
  final TextEditingController _pwdctrler = TextEditingController();
  final _keyform = GlobalKey<FormState>();
  final _auth = AuthService();
  String _error = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: loading? const Loading() : Center(
        child: SingleChildScrollView(
          
          child: Form( 
            key: _keyform,
            child: Column(
              children: [
                InputForm(labelTitle: "Email", placeholder: "Your Email", controller: _emailctrler),
                InputForm(labelTitle: "Password", placeholder: "Your Password", controller: _pwdctrler, ispwd: true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ],
                ),
                Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_keyform.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth.SignIn(_emailctrler.text, _pwdctrler.text);
                          
                          if (result == null) {
                            setState(() {
                              _error = "Email or password is wrong";
                              loading = false;
                            });
                          }
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                      child: const Text("Sign in", style: TextStyle(fontSize: 20.0)),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        widget.toggleView(AuthScreen.sign_up);
                      },
                      child: const Text("Sign up"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(),));
                      },
                      child: Text("Forget password", style: TextStyle(color: Colors.blue[300])),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}