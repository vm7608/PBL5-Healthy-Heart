import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/Models/News.dart';
import 'package:project/Screens/loading.dart';
import 'package:project/services/auth.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});
  final String title = "Home";

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {


  @override
  Widget build(BuildContext context) {
    var futuredata = FirebaseFirestore.instance.collection('home').get();
    

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              AuthService().SignOut();
            },
            icon: const Icon(Icons.output_outlined)
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(96, 119, 213, 232),
      body: SingleChildScrollView(
        child: FutureBuilder<QuerySnapshot>(
          future: futuredata,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            
          if (snapshot.hasData) {
            List<Widget> listnews = List.empty(growable: true);
            var docs = snapshot.data!.docs;
            for (var doc in docs) {
              var data = doc.data() as Map<String, dynamic>;
              listnews.add(
                News(
                  title: data['title'], preview: data['preview'], imgpath: data['imgpath'] ?? "", content: data['content']
                ).render(context)
              );
            }

            return Column(
              children: listnews,
            );
          }
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(height: 450,child: Loading());
          }
          return const Text("None");
        }),
      )
    );
  }
}

class NewsContent extends StatelessWidget {
  NewsContent({required this.news, super.key});
  News news;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title, overflow: TextOverflow.fade,),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: 
            Column(
              children: [
                CachedNetworkImage(
                  imageUrl: news.imgpath,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(news.content!,)),
                    ],
                  ),
                ), 
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.arrow_back_ios),
                      Text("Back", style: TextStyle(fontSize: 25),),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}