import 'dart:io';
import 'dart:typed_data'; // For byte data
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PickSingleVideoController extends GetxController {
  RxString videoPath = "".obs; // To store the file path
  Rx<Uint8List?> videoBytes = Rx<Uint8List?>(null); // To store the video in bytes

  // Method to pick a video
  Future<int> pickVideo() async {
    try {
      final ImagePicker videoPicker = ImagePicker();
      final XFile? video = await videoPicker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        // Validate file extension
        String fileExtension = video.path.split('.').last.toLowerCase();
        if (fileExtension == 'mp4')
        {
          // Get video file
          File videoFile = File(video.path);
          // Check file size (2GB = 2 * 1024 * 1024 * 1024 bytes)
          int fileSize = await videoFile.length();
          if (fileSize <= 2 * 1024 * 1024 * 1024) {
            // Update the video path
            videoPath.value = video.path;
            // Convert the video file to bytes and store
            videoBytes.value = await videoFile.readAsBytes();
            print("Video selected successfully.");
            print("File size: ${fileSize / (1024 * 1024)} MB");
            //video selected
            return 1;
          }
          else
          {
            print("Video file size exceeds 2GB limit.");
            //video size exceeds 2gb.
            return 2;
          }
        }
        else
        {
          print("Invalid video format. Supported formats: MP4");
          //invalid video format
          return 3;
        }
      } else {
        print("No video selected.");
        //video not selected
        return 4;
      }
    } catch (e) {
      print("Exception caught while selecting video: ${e.toString()}");
      //exception caught
      return 5;
    }
  }
}
