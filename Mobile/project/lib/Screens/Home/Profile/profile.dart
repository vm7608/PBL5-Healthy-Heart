import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/Home/Profile/setting.dart';
import 'package:project/Screens/loading.dart';
import 'package:project/services/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  final String title = "Profile";
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double formWeight = 320;

  var localuser = AuthService.localuser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localuser.getData().then((value) => setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    final _profileStream =
        FirebaseFirestore.instance.collection('profile').doc(localuser.uid).snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: _profileStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.hasData) {

          return Scaffold(
            backgroundColor: const Color.fromARGB(96, 119, 213, 232),
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                IconButton(
                  onPressed: () {
                    AuthService().SignOut();
                  },
                  icon: const Icon(Icons.output_outlined)
                ),
                IconButton( 
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const SettingScreen();
                    },));
                  },
                  icon: const Icon(Icons.settings) 
                )
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          //color: Colors.blue[100],
                          gradient: LinearGradient(colors: [Colors.blue, Colors.black], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {

                            },
                            child: Container(
                              height: 100.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50), 
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/Sample_User_Icon.png"),//NetworkImage('https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'),
                                  fit: BoxFit.cover, //change image fill type
                                ),
                              ),
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Divider(
                        height: 0,
                        color: Colors.black,
                        thickness: 1.0,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InfoForm("Email", localuser.email ?? "None"),
                      InfoForm("Name", localuser.name ?? "None"),
                      InfoForm("Gender", localuser.gender ?? "None"),
                      InfoForm("Birth", localuser.birth ?? "None"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, 
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        ),
                        onPressed: () {
                          AuthService().SignOut();
                        },
                        child: Container(alignment: Alignment.center, width: formWeight, child: const Text("Sign Out"),),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return const Center(child: Loading(),);
      },
    ) ;
  }

  Widget InfoForm(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: formWeight,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          border: Border.all(),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.1,
              blurRadius: 1,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]
        ),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0), width: 120, child: Text("$label:")),
            Text(value, style: const TextStyle(overflow: TextOverflow.ellipsis),),
          ],
        ),
      ),
    ],
  );

}