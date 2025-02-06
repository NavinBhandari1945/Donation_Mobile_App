import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'VideoPlayerUi_p.dart';

class VideoPlayerControllerScreen extends StatefulWidget {
  final String video_file_path;
  const VideoPlayerControllerScreen({super.key,required this.video_file_path });

  @override
  State<VideoPlayerControllerScreen> createState() => _VideoPlayerControllerScreenState();
}

class _VideoPlayerControllerScreenState extends State<VideoPlayerControllerScreen> {
  VideoPlayerController? _video_player;
  @override
  void initState() {
    super.initState();
    print("initstate of video player controller for post start");
    print(_video_player==null);
    // Initialize the video player controller asynchronously
    _video_player = VideoPlayerController.file(File(widget.video_file_path))
      ..addListener(() => setState(() {})) // Update UI when the video state changes
      ..setLooping(true) // Set the video to loop
      ..initialize().then((_) {
        // After initialization is complete, check if it is initialized
        print("initstate of video player controller for post end");
        print(_video_player==null);
        print("controller is initialized or not");
        print(_video_player!.value.isInitialized); // This will now return true
        _video_player!.play(); // Start the video playback
      }).catchError((error) {
        // Handle any errors during initialization
        print("Error initializing video player: $error");
      });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _video_player!.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    final IsMuted=_video_player!.value.volume==0;
    return Scaffold
      (
      // appBar: AppBar(
      //   title: Text("Video palyer controller screen"),
      // ),
      body:
      Container(
        height: heightval,
        width: widthval,
        color: Colors.grey,
        child:
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [

              Container(
                  height: heightval*0.70,
                  width: widthval,
                  color: Colors.red,
                  child: VideoPlayerUi_p(controller: _video_player!,)
              ),

              SizedBox(height: shortestval*0.03,),

              CircleAvatar(
                radius: shortestval*0.10,
                backgroundColor: Colors.indigo,
                child: IconButton(
                      icon: Icon(
                          IsMuted?Icons.volume_mute:Icons.volume_up
                      ),
                  onPressed: ()
                  {
                       _video_player!.setVolume(IsMuted?1:0);
                  },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
