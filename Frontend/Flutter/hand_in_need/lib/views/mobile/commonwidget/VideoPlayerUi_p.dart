import 'package:flutter/material.dart';
import 'package:hand_in_need/views/mobile/commonwidget/video_palyer_status_bar.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerUi_p extends StatelessWidget {
  final VideoPlayerController controller;
  const VideoPlayerUi_p({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: controller != null && controller.value.isInitialized
          ? Stack(
        children: [
          buildVideoPlayer(),
          Positioned.fill(
            child: BasicOverlayWidget(controller: controller),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(
          color: Colors.indigo,
          strokeWidth: shortestval * 0.01,
        ),
      ),
    );
  }

  Widget buildVideoPlayer() {
    print("controller value in build video player ()");
    print(controller == null);
    print(controller);
    return VideoPlayer(controller);
  }
}





// import 'package:flutter/material.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/video_palyer_status_bar.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoPlayerUi_p extends StatelessWidget
// {
//   final VideoPlayerController controller;
//   const VideoPlayerUi_p({super.key,required this.controller});
//   @override
//   Widget build(BuildContext context)
//   {
//     return Scaffold
//       (
//       appBar: AppBar(
//         title: Text("Video player ui."),
//       ),
//       body:
//         controller!=null && controller.value.isInitialized
//             ?
//              Container(alignment: Alignment.topCenter,child:buildVideo())
//             :Center(child: CircularProgressIndicator(),
//         ),
//     );
//   }
//
//   Widget buildVideo()=>Stack
//     (
//     children:
//     <Widget>[
//
//       buildVideoPlayer(),
//
//      Positioned.fill(child:BasicOverlayWidget(controller: controller)),
//
//     ]
//   );
//
//
//   Widget buildVideoPlayer()
//   {
//     print("controller value in build video player ()");
//     print(controller==null);
//     print(controller);
//     return
//       VideoPlayer(controller);
//   }
//
// }
