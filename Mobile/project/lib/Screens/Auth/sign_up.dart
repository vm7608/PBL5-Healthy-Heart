import 'package:flutter/material.dart';
import 'package:project/Screens/Auth/authenticate.dart';
import 'package:project/Screens/loading.dart';
import 'package:project/WidgetS/Custom.dart';
import 'package:project/WidgetS/DatePicker.dart';
import 'package:project/services/auth.dart';

class SignUpScreen extends StatefulWidget {
  final Function toggleView;
  const SignUpScreen({required this.toggleView, super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailctrler = TextEditingController();
  final TextEditingController _pwdctrler = TextEditingController();
  final TextEditingController _namectrler = TextEditingController();
  final TextEditingController _birthtrler = TextEditingController();
  final TextEditingController _gendertrler = TextEditingController();
  final _keyform = GlobalKey<FormState>();
  bool loading = false;
  String _error = "";
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loading();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Form(
        key: _keyform,
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputForm(labelTitle: "Email", placeholder: "Your Email", controller: _emailctrler),
              InputForm(labelTitle: "Password", placeholder: "Your Password", controller: _pwdctrler, ispwd: true),
              InputForm(labelTitle: "Name", placeholder: "Your Name", controller: _namectrler),
              InputDateTimeForm(labelTitle: "Birth", placeholder: "Your Date of birth", controller: _birthtrler),
              InputListChooserForm(labelTitle: "Gender", list: const ["Male", "Female"], controller: _gendertrler),
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
                        dynamic result = await _auth.Register(_emailctrler.text, _pwdctrler.text, _namectrler.text, _birthtrler.text, _gendertrler.text);
                        if (result == null) {
                          setState(() {
                            _error = "This email cannot be used";
                            loading = false;
                          });
                        }
                      }
                    },
                    child: const Text("Sign up"),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      widget.toggleView(AuthScreen.log_in);
                    },
                    child: const Text("Sign in"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}