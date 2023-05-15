import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project/Models/API.dart';
import 'package:http/http.dart' as http;

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String issuccess = "";
  TextEditingController Host_textctr = TextEditingController();
  TextEditingController Address_textctr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text("Host"),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextField(controller: Host_textctr)
                  ) 
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text("Address"),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextField(controller: Address_textctr)
                  ) 
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text("Host"),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(API.host,)
                      ) 
                    ],
                  ),
                  Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text("Address"),
                    ),
                    Expanded(
                      flex: 2,
                        child: Text(API.address,)
                    ) 
                  ],
                ),
                SizedBox(
                  child: ElevatedButton(
                    child: const Text("Xác nhận API"),
                    onPressed: () {
                      ValidateAPI();
                    },
                  ),
                ),
                SizedBox(
                  child: Text(issuccess),
                )
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  void ValidateAPI() async {
    print(2);
    if (mounted) {
      setState(() {
        issuccess = "";
      });
      API.address = Address_textctr.text; 
      API.host = Host_textctr.text;
      print(Host_textctr.text);
      print(Address_textctr.text);
      try {
        var url = Uri.http(API.host, API.address);
        print(url.toString());
        var respone = await http.get(url);
        if (respone.statusCode == 200) {
          print(respone.body);
          if (mounted) {
            setState(() {
              issuccess = "API có tồn tại";
            });
          }
        }
        else {
          if (mounted) {
            setState(() {
              issuccess = "API không tồn tại";
            });
          }
        }
      } catch (e) {
        print(e);
        if (mounted) {
          setState(() {
            issuccess = "API không tồn tại";
          });
        }
      } on TimeoutException catch (_) {
        // A timeout occurred.
      } on SocketException catch (_) {
        // Other exception
      }
    }
  }
}