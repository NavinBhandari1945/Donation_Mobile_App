import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'VideoPlayerUi_p.dart';

class VideoPlayerControllerScreen extends StatefulWidget {
  final String video_file_path;
  const VideoPlayerControllerScreen({super.key, required this.video_file_path});

  @override
  State<VideoPlayerControllerScreen> createState() => _VideoPlayerControllerScreenState();
}

class _VideoPlayerControllerScreenState extends State<VideoPlayerControllerScreen> with SingleTickerProviderStateMixin {
  VideoPlayerController? _video_player;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    print("initstate of video player controller for post start");
    print(_video_player == null);

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Initialize the video player controller asynchronously
    _video_player = VideoPlayerController.file(File(widget.video_file_path))
      ..addListener(() => setState(() {})) // Update UI when the video state changes
      ..setLooping(true) // Set the video to loop
      ..initialize().then((_) {
        print("initstate of video player controller for post end");
        print(_video_player == null);
        print("controller is initialized or not");
        print(_video_player!.value.isInitialized); // This will now return true
        _video_player!.play(); // Start the video playback
      }).catchError((error) {
        print("Error initializing video player: $error");
      });
  }

  @override
  void dispose() {
    _video_player!.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    final IsMuted = _video_player!.value.volume == 0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[300]!, Colors.grey[100]!],
          ),
        ),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: orientation == Orientation.portrait
                  ? _buildPortraitLayout(shortestval, widthval, heightval, IsMuted)
                  : _buildLandscapeLayout(shortestval, widthval, heightval, IsMuted),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(double shortestval, double widthval, double heightval, bool IsMuted) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.03),
        child: Column(
          children: [
            SizedBox(height: shortestval * 0.05),
            _buildVideoPlayerContainer(shortestval, widthval, heightval * 0.70),
            SizedBox(height: shortestval * 0.03),
            _buildMuteButton(shortestval, IsMuted),
            SizedBox(height: shortestval * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(double shortestval, double widthval, double heightval, bool IsMuted) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: _buildVideoPlayerContainer(shortestval, widthval * 0.65, heightval * 0.85),
            ),
            SizedBox(width: shortestval * 0.03),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMuteButton(shortestval, IsMuted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayerContainer(double shortestval, double width, double height) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: VideoPlayerUi_p(controller: _video_player!),
      ),
    );
  }

  Widget _buildMuteButton(double shortestval, bool IsMuted) {
    return CircleAvatar(
      radius: shortestval * 0.10,
      backgroundColor: Colors.indigo,
      child: IconButton(
        icon: Icon(
          IsMuted ? Icons.volume_mute : Icons.volume_up,
          color: Colors.white,
          size: shortestval * 0.08,
        ),
        onPressed: () {
          _video_player!.setVolume(IsMuted ? 1 : 0);
        },
      ),
    );
  }
}




// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// import 'VideoPlayerUi_p.dart';
//
// class VideoPlayerControllerScreen extends StatefulWidget {
//   final String video_file_path;
//   const VideoPlayerControllerScreen({super.key,required this.video_file_path });
//
//   @override
//   State<VideoPlayerControllerScreen> createState() => _VideoPlayerControllerScreenState();
// }
//
// class _VideoPlayerControllerScreenState extends State<VideoPlayerControllerScreen> {
//   VideoPlayerController? _video_player;
//   @override
//   void initState() {
//     super.initState();
//     print("initstate of video player controller for post start");
//     print(_video_player==null);
//     // Initialize the video player controller asynchronously
//     _video_player = VideoPlayerController.file(File(widget.video_file_path))
//       ..addListener(() => setState(() {})) // Update UI when the video state changes
//       ..setLooping(true) // Set the video to loop
//       ..initialize().then((_) {
//         // After initialization is complete, check if it is initialized
//         print("initstate of video player controller for post end");
//         print(_video_player==null);
//         print("controller is initialized or not");
//         print(_video_player!.value.isInitialized); // This will now return true
//         _video_player!.play(); // Start the video playback
//       }).catchError((error) {
//         // Handle any errors during initialization
//         print("Error initializing video player: $error");
//       });
//   }
//
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _video_player!.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     var shortestval = MediaQuery.of(context).size.shortestSide;
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//     final IsMuted=_video_player!.value.volume==0;
//     return Scaffold
//       (
//       // appBar: AppBar(
//       //   title: Text("Video palyer controller screen"),
//       // ),
//       body:
//       Container(
//         height: heightval,
//         width: widthval,
//         color: Colors.grey,
//         child:
//         SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             children: [
//
//               Container(
//                   height: heightval*0.70,
//                   width: widthval,
//                   color: Colors.red,
//                   child: VideoPlayerUi_p(controller: _video_player!,)
//               ),
//
//               SizedBox(height: shortestval*0.03,),
//
//               CircleAvatar(
//                 radius: shortestval*0.10,
//                 backgroundColor: Colors.indigo,
//                 child: IconButton(
//                       icon: Icon(
//                           IsMuted?Icons.volume_mute:Icons.volume_up
//                       ),
//                   onPressed: ()
//                   {
//                        _video_player!.setVolume(IsMuted?1:0);
//                   },
//                     ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
