import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Home/HomePage/homepage.dart';
import 'package:project/Screens/wrapper.dart';
import 'package:project/services/auth.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user, initialData: null,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Wrapper(),
        )
      ); 
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              AuthService().SignOut();
            },
            icon: const Icon(Icons.output_outlined)
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            ElevatedButton(
              child: const Text("Go to the first page"),
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePageScreen()),
                );
              }, 
            ),               
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class InputForm extends StatelessWidget {
  InputForm({
    required this.labelTitle,
    this.spacebetween = 10.0,
    required this.placeholder,
    required this.controller,
    this.ispwd = false,
    super.key
  });
  final String labelTitle;
  final double spacebetween;
  final String placeholder;
  final bool ispwd;
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(spacebetween),
          child: Text(
            labelTitle,
          ),
        ),
        
        Expanded(
          child: TextField(
            obscureText: ispwd,
            decoration: InputDecoration(
              hintText: placeholder,
              border: const OutlineInputBorder(),
            ),
            controller: controller,
          )
        )
      ],
    );
  }
}