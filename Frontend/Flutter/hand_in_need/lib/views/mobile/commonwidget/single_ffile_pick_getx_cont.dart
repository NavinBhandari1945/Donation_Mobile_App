import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class FilePickerController extends GetxController {
  RxString filePath = "".obs; // To store file path
  Rx<Uint8List?> fileBytes = Rx<Uint8List?>(null); // To store file bytes

  // Method to pick any file
  Future<int> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, // Choose specific types
        allowedExtensions: ['pdf', 'docx', 'txt'], // Allowed extensions
      );

      if (result != null)
      {
        // Get file path and bytes
        String path = result.files.single.path!;
        Uint8List bytes = await File(path).readAsBytes();

        // Check file size (e.g., 2GB limit)
        int fileSize = bytes.length;
        if (fileSize <= 2 * 1024 * 1024 * 1024) {
          filePath.value = path;
          fileBytes.value = bytes;

          print("File Path: $path");
          print("File Size: ${fileSize / (1024 * 1024)} MB");

          return 1; // File selected successfully
        } else {
          print("File exceeds size limit.");
          return 2; // File too large
        }
      }
      else
      {
        print("No file selected.");
        return 3; // No file selected
      }
    } catch (e) {
      print("Error picking file: $e");
      return 4; // Error occurred
    }
  }
}
