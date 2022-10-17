import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_Player/screens/videos_screen.dart';
import '../model/videos_data_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Videos> videosList = [];


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String jsonData =
      await rootBundle.loadString("assets/json/videos.json");

      List res = jsonDecode(jsonData);

      setState(() {
        videosList = res.map((e) => Videos.fromJSON(e)).toList();
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: videosList.length,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(top: 15),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => VideosScreen(videos: videosList[index]),)
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      color: Colors.teal.withOpacity(0.25),
                      image: DecorationImage(
                        image: NetworkImage(videosList[index].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                      ),
                    ),
                    alignment: Alignment.centerRight,
                    child: Text(
                      videosList[index].category,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
