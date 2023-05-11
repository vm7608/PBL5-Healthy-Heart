import 'package:flutter/material.dart';
import 'package:project/WidgetS/Custom.dart';
import 'package:project/services/auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  int success = 0;
  final TextEditingController _emailctrler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  InputForm(labelTitle: "Email", placeholder: "Type email here", controller: _emailctrler, labelwidth: null),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              success = 1;
                            });
                            AuthService().ResetPassword(_emailctrler.text).then((value) {
                              setState(() {
                                success = 2;
                              });
                            });
                          },
                          child: const Text("Reset password"),
                        ),
                      )
                    ],
                  ),
                  if (success ==1)
                    const Text("Đang gửi liên kết qua email")
                  else if (success == 2)
                    const Text("Đã gửi liên kết")
                  else
                    const SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}