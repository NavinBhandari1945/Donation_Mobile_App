// import 'dart:io';
// import 'dart:typed_data';
// import 'package:get/get.dart';
// import 'package:hand_in_need/views/mobile/campaign/campaign_screen_p.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
//
// class PickSinglePhotoGetXController extends GetxController
// {
//
//   RxString imagePath = "".obs; // To store the file path
//   Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null); // To store the image in bytes
//   RxString scannedPostId = "".obs; // To store scanned Post ID
//
//   // Method to pick an image
//   Future<int> pickImage() async {
//     try {
//       final ImagePicker imagePicker = ImagePicker();
//       final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         // Validate file extension
//         String fileExtension = image.path.split('.').last.toLowerCase();
//         if (fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png') {
//           // Update the image path
//           imagePath.value = image.path;
//           // Convert the image file to bytes and store
//           File imageFile = File(image.path);
//           imageBytes.value = await imageFile.readAsBytes();
//           print("Image selected successfully.");
//           // Scan QR code from the image
//           int result=await scanQRCodeFromImage(imageFile);
//           print("Extract post id from qr.");
//           print(result);
//           scannedPostId.value=result.toString();
//           return 1;
//         } else {
//           print("Invalid photo format.");
//           return 2;
//         }
//       } else {
//         print("Image not selected.");
//         return 3;
//       }
//     } catch (obj) {
//       print("Exception caught while selecting image: ${obj.toString()}");
//       return 4;
//     }
//   }
//
//   // Method to scan the QR code from the selected image
//   Future<int> scanQRCodeFromImage(File imageFile) async {
//     try
//     {
//       return 1;
//
//     } catch (e) {
//       print("exception caught whil scanning qr image of post.");
//       print("Error scanning QR code: $e");
//       return 0;
//     }
//   }
//
//
// }




