import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../model/videos_data_model.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key,required this.videos}) : super(key: key);

  final Videos videos;

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  List<VideoPlayerController> controller = [];
  List<ChewieController> chewieController = [];
  List<VideoPlayerController> networkController = [];
  List<ChewieController> networkChewieController = [];

  List networkVideos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      networkVideos = widget.videos.networkVideos;

      for (var e in networkVideos) {
        controller.add(VideoPlayerController.network(e)
          ..initialize().then(
                (_) {
              setState(() {});
            },
          ));
      }

      for (var e in controller) {
        chewieController.add(ChewieController(
          videoPlayerController: e,
          autoPlay: false,
          looping: false,
        ));
        setState(() {});

      }
      Timer.periodic(const Duration(microseconds: 200), (timer) {
        setState(() {});
      });

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videos.category),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ...networkVideos
                .map(
                  (e) => Container(
                    margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
                    height: 230,
                    width: double.infinity,
                    color:Theme.of(context).primaryColor,
                    child: AspectRatio(
                      aspectRatio: controller[networkVideos.indexOf(e)]
                          .value
                          .aspectRatio,
                      child: Chewie(
                        controller:
                            chewieController[networkVideos.indexOf(e)],
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var e in controller) {
      chewieController[controller.indexOf(e)].dispose();
      e.dispose();
    }
    for (var e in networkController) {
      networkChewieController[networkController.indexOf(e)].dispose();
      e.dispose();
    }

    super.dispose();
  }
}
