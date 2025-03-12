import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import '../home/home_p.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_saver/file_saver.dart';



/// Request all necessary permissions



Future<void> requestAllPermissions() async {
  try {
    print("Requesting all permissions in common method for main.dart.");
    if (Platform.isAndroid)
    {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var sdkInt = androidInfo.version.sdkInt;

      // Request Camera Permission
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          print("Camera permission denied.");
        } else {
          print("Camera permission granted.");
        }
      }

      // Request Storage Permissions based on Android version
      if (sdkInt >= 30) { // Android 11+
        var manageStorageStatus = await Permission.manageExternalStorage.status;
        if (!manageStorageStatus.isGranted) {
          manageStorageStatus = await Permission.manageExternalStorage.request();
          if (!manageStorageStatus.isGranted) {
            print("Manage External Storage permission denied (Android 11+).");
          } else {
            print("Manage External Storage permission granted (Android 11+).");
          }
        }
      } else if (sdkInt >= 29) { // Android 10
        // For Android 10, Permission.storage is still usable for legacy apps
        var storageStatus = await Permission.storage.status;
        if (!storageStatus.isGranted) {
          storageStatus = await Permission.storage.request();
          if (!storageStatus.isGranted) {
            print("Storage permission denied (Android 10).");
          } else {
            print("Storage permission granted (Android 10).");
          }
        }
      } else { // Android 9 and below
        var storageStatus = await Permission.storage.status;
        if (!storageStatus.isGranted) {
          storageStatus = await Permission.storage.request();
          if (!storageStatus.isGranted) {
            print("Storage permission denied (Android 9 and below).");
          } else {
            print("Storage permission granted (Android 9 and below).");
          }
        }
      }

      // Check if permissions are permanently denied and open settings
      if (await Permission.camera.isPermanentlyDenied ||
          await Permission.storage.isPermanentlyDenied ||
          await Permission.manageExternalStorage.isPermanentlyDenied) {
        print("Some permissions are permanently denied. Opening app settings...");
        await openAppSettings();
      }
    }//platform android
  }
  catch (e) {
    print("Exception caught in requesting all permissions: $e");
  }
}

Future<void> saveJwtToken(String token) async
{
  final box = await Hive.openBox('userData');
  // Ensure that token is not null
  if (token != null) {
    // Save JWT token to Hive
    await box.put('jwt_token', token);
    print("JWT token saved.");
  } else {
    print("Error: Token is missing.");
  }
}

// Method to retrieve JWT token
Future<String?> getJwtToken() async
{
  final box = await Hive.openBox('userData');
  // Retrieve JWT token from Hive
  String? token = await box.get('jwt_token');
  return token;
}

// Method to save username and password
Future<void> saveUserCredentials(String username, String usertype, String login_date) async
{

  final box = await Hive.openBox('userData');

  // Ensure that username and password are not null
  if (username != null && usertype != null && login_date != null) {
    // Save username and password to Hive
    await box.put('username', username);
    await box.put('usertype', usertype);
    await box.put("loginDate", login_date);
    print("Username,usertype and login date saved.");
  }
  else
  {
    print("Error: Username,user login date or usertype is missing.");
  }

}

// Method to retrieve username and password
Future<Map<String, String?>> getUserCredentials() async
{
  final box = await Hive.openBox('userData');
  // Retrieve username and password from Hive
  String? username = await box.get('username');
  String? usertype = await box.get('usertype');
  String? UserLoginDate = await box.get('loginDate');
  return {
    'username': username,
    'usertype': usertype,
    'UserLogindate': UserLoginDate
  };
}

// Method to clear JWT token, username, and password
Future<void> clearUserData() async
{
  final box = await Hive.openBox('userData');
  // Clear JWT token, username, and password
  await box.delete('jwt_token');
  await box.delete('username');
  await box.delete('usertype');
  await box.delete('loginDate');
  print("User data cleared.");
}

// Method to handle API response and save data if status code is 200
Future<void> handleResponse(Map<String, dynamic> responseData) async
{
  String token = responseData['token']!;
  String username = responseData['username']!;
  String User_Type = responseData['usertype']!;
  String login_date = DateTime.now().toUtc().toIso8601String();
  await saveJwtToken(token);
  await saveUserCredentials(username, User_Type, login_date);
  print("Login sucecss");
  print("User data");
  print("jwt token");
  print(token);
  print("username");
  print(username);
  print("user type");
  print(User_Type);
  print("Login date");
  print(login_date);
  return;
}

Future<int> checkJwtToken_initistate_user(String username, String usertype, String jwttoken) async
{
  print("jwt token");
  print(jwttoken);
  print("username");
  print(username);
  print("user type");
  print(usertype);
  if (jwttoken == null ||
      jwttoken.isEmpty ||
      usertype != "user" ||
      usertype.isEmpty ||
      usertype == null ||
      username == null ||
      username.isEmpty) {
    print("User details miss match.");
    await clearUserData();
    return 0;
  }

  const String url=Backend_Server_Url+'api/Authentication/jwtverify';

  final response2 = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $jwttoken'},
  );
  if (response2.statusCode == 200) {
    if (usertype == "user") {
      return 1;
    } else {
      print(
          "User type mismatch.jwt initistate user method present in common method .dart file.");
      await clearUserData();
      return 0;
    }
  } else {
    print("jwt not verify for jwt initstate user");
    await clearUserData();
    return 0;
  }
}

Future<int> checkJwtToken_initistate_admin(String username, String usertype, String jwttoken) async {
  print("jwt token");
  print(jwttoken);
  print("username");
  print(username);
  print("user type");
  print(usertype);

  if (jwttoken == null ||
      jwttoken.isEmpty ||
      usertype != "admin" ||
      usertype.isEmpty ||
      usertype == null ||
      username == null ||
      username.isEmpty) {
    print("User details miss match.");
    await clearUserData();
    return 0;
  }

  const String url=Backend_Server_Url+"api/Authentication/jwtverify";

  final response2 = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $jwttoken'},
  );
  if (response2.statusCode == 200) {
    if (usertype == "admin") {
      return 1;
    } else {
      print(
          "User type mismatch.jwt initistate user method present in common method .dart file.");
      await clearUserData();
      return 0;
    }
  } else {
    print("jwt not verify for jwt initstate admin");
    await clearUserData();
    return 0;
  }
}
//
//
// Future<void> Download_Donation_File_Post(String? base64String, String fileExtension) async {
//   try {
//     if (base64String == null || base64String.isEmpty) {
//       Toastget().Toastmsg("File content is empty");
//       return;
//     }
//
//     // Request permission to write to external storage
//     var permissionStatus = await Permission.storage.request();
//     if (!permissionStatus.isGranted) {
//       print(
//           "Storage permission is required to download files for post authentication.");
//       Toastget().Toastmsg("Storage permission is required to download files.");
//       return;
//     }
//
//     // Decode the base64 string into bytes
//     final fileBytes = base64Decode(base64String);
//
//     // Get the directory to save the file
//     Directory? downloadsDirectory;
//
//     if (Platform.isAndroid) {
//       // Extract the major version number (the part before the first dot)
//       var versionParts = Platform.version.split(" ")[0].split(".");
//       var majorVersion =
//           int.tryParse(versionParts[0]) ?? 0; // Safely parse the major version
//
//       if (majorVersion >= 10) {
//         // Scoped Storage - Use the Downloads directory for Android 10 and higher
//         print("Download file of post for android <10");
//         // downloadsDirectory = Directory('/storage/emulated/0/Download');
//         downloadsDirectory = await getExternalStorageDirectory();
//       } else {
//         // For Android versions lower than 10, use the standard method (legacy storage)
//         print("Download file of post for android >10");
//         downloadsDirectory = await getExternalStorageDirectory();
//       }
//     }
//     // For non-Android platforms, use the external storage directory
//     else {
//       print("Download file of post for ios.");
//       downloadsDirectory = await getExternalStorageDirectory();
//     }
//     if (downloadsDirectory == null || !downloadsDirectory.existsSync()) {
//       Toastget().Toastmsg("Downloads folder not found.");
//       return;
//     }
//     // Generate file name and path
//     final fileName =
//         "hand_in_need_Donation_profile_post_file_${DateTime.now().toIso8601String()}.${fileExtension}";
//     final filePath = path.join(downloadsDirectory.path, fileName);
//
//     // Write the bytes to the file
//     final file = File(filePath);
//     await file.writeAsBytes(fileBytes);
//
//     // Notify the user of the saved file location
//     print("File saved to: $filePath");
//     Toastget().Toastmsg("File downloaded to: $filePath");
//   } catch (e) {
//     print("Exception caught while downloading file for post.");
//     print(e.toString());
//     Toastget().Toastmsg("Error: $e");
//   }
// }

Future<void> Download_Donation_File_Post(String? base64String, String fileExtension) async {
  try {
    // Step 1: Check for empty content
    if (base64String == null || base64String.isEmpty) {
      Toastget().Toastmsg("File content is empty");
      return;
    }

    // Step 2: Allow only .xlsx extension
    if (fileExtension.toLowerCase() != 'xlsx') {
      Toastget().Toastmsg("Invalid file extension. Only XLSX (Excel) is allowed.");
      return;
    }

    // Step 3: Request storage permission
    var permissionStatus = await Permission.storage.status;
    if (!permissionStatus.isGranted) {
      permissionStatus = await Permission.storage.request();
      if (!permissionStatus.isGranted) {
        Toastget().Toastmsg("Storage permission is required to download Excel files.");
        return;
      }
    }

    // Step 4: Decode base64 string to bytes
    final bytes = base64Decode(base64String);

    // Step 5: Define a file name
    final fileName = "hand_in_need_donation_excel_${DateTime.now().toIso8601String()}.xlsx";

    // Step 6: Save the file using FileSaver
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      ext: "xlsx",
      mimeType: MimeType.other, // FileSaver doesn't have MimeType.xlsx
    );

    // Step 7: Success message
    Toastget().Toastmsg("Excel file downloaded successfully!");
  } catch (e) {
    print("Exception while downloading Excel file: $e");
    Toastget().Toastmsg("Error downloading file: $e");
  }
}


// //
// Future<void> downloadFilePost(
//     String? base64String, String fileExtension) async {
//   try {
//     if (base64String == null || base64String.isEmpty) {
//       Toastget().Toastmsg("File content is empty");
//       return;
//     }
//
//     // Request permission to write to external storage
//     var permissionStatus = await Permission.storage.request();
//     if (!permissionStatus.isGranted)
//     {
//       print(
//           "Storage permission is required to download files for post authentication.");
//       Toastget().Toastmsg("Storage permission is required to download files.");
//       return;
//     }
//
//     // Decode the base64 string into bytes
//     final fileBytes = base64Decode(base64String);
//
//     // Get the directory to save the file
//     Directory? downloadsDirectory;
//
//     if (Platform.isAndroid)
//     {
//       // Extract the major version number (the part before the first dot)
//       var versionParts = Platform.version.split(" ")[0].split(".");
//       var majorVersion =
//           int.tryParse(versionParts[0]) ?? 0; // Safely parse the major version
//
//       if (majorVersion >= 10) {
//         // Scoped Storage - Use the Downloads directory for Android 10 and higher
//         print("Download file of post for android <10");
//         // downloadsDirectory = Directory('/storage/emulated/0/Download');
//         downloadsDirectory = await getExternalStorageDirectory();
//       } else {
//         // For Android versions lower than 10, use the standard method (legacy storage)
//         print("Download file of post for android >10");
//         downloadsDirectory = await getExternalStorageDirectory();
//       }
//     }
//     // For non-Android platforms, use the external storage directory
//     else
//     {
//       print("Download file of post for ios.");
//       downloadsDirectory = await getExternalStorageDirectory();
//     }
//
//
//     if (downloadsDirectory == null || !downloadsDirectory.existsSync()) {
//       Toastget().Toastmsg("Downloads folder not found.");
//       return;
//     }
//     // Generate file name and path
//     final fileName =
//         "hand_in_need_post_file_${DateTime.now().toIso8601String()}.${fileExtension}";
//     final filePath = path.join(downloadsDirectory.path, fileName);
//
//     // Write the bytes to the file
//     final file = File(filePath);
//     await file.writeAsBytes(fileBytes);
//
//     // Notify the user of the saved file location
//     print("File saved to: $filePath");
//     Toastget().Toastmsg("File downloaded to: $filePath");
//   } catch (e) {
//     print("Exception caught while downloading file for post.");
//     print(e.toString());
//     Toastget().Toastmsg("Error: $e");
//   }
// }



// Future<void> downloadFilePost(String? base64String, String fileExtension) async {
//   try {
//     if (base64String == null || base64String.isEmpty) {
//       Toastget().Toastmsg("File content is empty");
//       return;
//     }
//
//     // Determine Android version or iOS
//     Directory? downloadsDirectory;
//     if (Platform.isAndroid) {
//       DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       var sdkInt = androidInfo.version.sdkInt;
//
//       if (sdkInt >= 29) { // Android 10+
//         downloadsDirectory = await getDownloadsDirectory();
//         if (downloadsDirectory == null) {
//           Toastget().Toastmsg("Unable to access Downloads directory on this device.");
//           print("getDownloadsDirectory() returned null on Android 10+.");
//           return;
//         }
//       } else { // Android 9 and below
//         var permissionStatus = await Permission.storage.status;
//         if (!permissionStatus.isGranted) {
//           permissionStatus = await Permission.storage.request();
//           if (!permissionStatus.isGranted) {
//             print("Storage permission denied for Android 9 and below.");
//             Toastget().Toastmsg("Storage permission is required to download files.");
//             return;
//           }
//         }
//         downloadsDirectory = await getExternalStorageDirectory();
//       }
//     } else { // iOS or other platforms
//       downloadsDirectory = await getApplicationDocumentsDirectory(); // Works for all iOS versions
//     }
//
//     if (downloadsDirectory == null || !downloadsDirectory.existsSync()) {
//       downloadsDirectory?.createSync(recursive: true);
//       if (!downloadsDirectory!.existsSync()) {
//         Toastget().Toastmsg("Downloads folder not found or cannot be created.");
//         return;
//       }
//     }
//
//     // Decode base64 string
//     final fileBytes = base64Decode(base64String);
//
//     // Generate file name and path
//     final fileName = "hand_in_need_post_file_${DateTime.now().toIso8601String()}.$fileExtension";
//     final filePath = path.join(downloadsDirectory.path, fileName);
//
//     // Write the file
//     final file = File(filePath);
//     await file.writeAsBytes(fileBytes);
//
//     print("File saved to: $filePath");
//     Toastget().Toastmsg("File downloaded${Platform.isIOS ? ' to Files app' : ' to: $filePath'}");
//   } catch (e) {
//     print("Exception caught while downloading file: $e");
//     Toastget().Toastmsg("Error: $e");
//   }
// }



Future<void> downloadFilePost(String? base64String, String fileExtension) async {
  try {
    if (base64String == null || base64String.isEmpty) {
      Toastget().Toastmsg("File content is empty");
      return;
    }

    // Check if the file extension is valid
    if (!['pdf', 'docx', 'txt'].contains(fileExtension.toLowerCase())) {
      Toastget().Toastmsg("Invalid file extension. Only PDF, DOCX, and TXT are allowed.");
      return;
    }

    // Proceed with downloading logic here...
    // For example, using FileSaver to save the file as shown in previous messages
    final bytes = base64Decode(base64String);
    MimeType mimeType;

    if (fileExtension == 'pdf') {
      mimeType = MimeType.pdf;
    } else if (fileExtension == 'txt') {
      mimeType = MimeType.text;
    } else {
      mimeType = MimeType.other;  // For DOCX, you can use MimeType.other
    }

    final fileName = "hand_in_need_post_file_${DateTime.now().toIso8601String()}.$fileExtension";

    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      ext: fileExtension,
      mimeType: mimeType,
    );
    Toastget().Toastmsg("File downloaded successfully!");
  } catch (e) {
    print("Exception caught while downloading file: $e");
    Toastget().Toastmsg("Error: $e");
  }
}




//
// Future<void> downloadFileCampaign(
//     String? base64String, String fileExtension) async {
//   if (base64String == null || base64String.isEmpty) {
//     Toastget().Toastmsg("File content is empty");
//     return;
//   }
//
//   // Request permission to write to external storage
//   var permissionStatus = await Permission.storage.request();
//   if (!permissionStatus.isGranted) {
//     Toastget().Toastmsg("Storage permission is required to download files.");
//     return;
//   }
//
//   try {
//     // Decode the base64 string into bytes
//     final fileBytes = base64Decode(base64String);
//
//     // Get the directory to save the file
//     Directory? downloadsDirectory;
//
//     if (Platform.isAndroid) {
//       // Extract the major version number (the part before the first dot)
//       var versionParts = Platform.version.split(" ")[0].split(".");
//       var majorVersion =
//           int.tryParse(versionParts[0]) ?? 0; // Safely parse the major version
//
//       if (majorVersion >= 10) {
//         // Scoped Storage - Use the Downloads directory for Android 10 and higher
//         print("Download file of campaign for android <10");
//         downloadsDirectory = Directory('/storage/emulated/0/Download');
//       } else {
//         // For Android versions lower than 10, use the standard method (legacy storage)
//         print("Download file of campaign for android >10");
//         downloadsDirectory = await getExternalStorageDirectory();
//       }
//     } else {
//       // For non-Android platforms, use the external storage directory
//       print("Download file of campaign for ios.");
//       downloadsDirectory = await getExternalStorageDirectory();
//     }
//
//     if (downloadsDirectory == null || !downloadsDirectory.existsSync()) {
//       Toastget().Toastmsg("Downloads folder not found.");
//       return;
//     }
//
//     // Generate file name and path
//     final fileName =
//         "hand_in_need_campaign_file_${DateTime.now().toIso8601String()}.${fileExtension}";
//     final filePath = path.join(downloadsDirectory.path, fileName);
//
//     // Write the bytes to the file
//     final file = File(filePath);
//     await file.writeAsBytes(fileBytes);
//
//     // Notify the user of the saved file location
//     print("File saved to: $filePath");
//     Toastget().Toastmsg("File downloaded to: $filePath");
//   } catch (e) {
//     print("Exception caught while downloading file for post.");
//     print(e.toString());
//     Toastget().Toastmsg("Error: $e");
//   }
// }

Future<void> downloadFileCampaign(String? base64String, String fileExtension) async {
  try {
    if (base64String == null || base64String.isEmpty) {
      Toastget().Toastmsg("File content is empty");
      return;
    }

    // Check if the file extension is valid
    if (!['pdf', 'docx', 'txt'].contains(fileExtension.toLowerCase())) {
      Toastget().Toastmsg("Invalid file extension. Only PDF, DOCX, and TXT are allowed.");
      return;
    }

    // Request permission to write to external storage
    var permissionStatus = await Permission.storage.status;

    if (!permissionStatus.isGranted) {
      // If permission is not granted, request for permission
      permissionStatus = await Permission.storage.request();

      if (!permissionStatus.isGranted) {
        // If permission is still not granted, stop and show a message
        Toastget().Toastmsg("Storage permission is required to download files.");
        return;
      }
    }

    // Decode the base64 string into bytes
    final fileBytes = base64Decode(base64String);

    // Determine the MIME type based on the file extension
    MimeType mimeType;

    if (fileExtension == 'pdf') {
      mimeType = MimeType.pdf;
    } else if (fileExtension == 'txt') {
      mimeType = MimeType.text;
    } else {
      mimeType = MimeType.other;  // For DOCX, use MimeType.other
    }

    // Generate the file name
    final fileName =
        "hand_in_need_campaign_file_${DateTime.now().toIso8601String()}.$fileExtension";

    // Save the file using FileSaver
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: fileBytes,
      ext: fileExtension,
      mimeType: mimeType,
    );

    // Notify the user of the download success
    Toastget().Toastmsg("File downloaded successfully!");
  } catch (e) {
    print("Exception caught while downloading file for campaign: $e");
    Toastget().Toastmsg("Error: $e");
  }
}


Future<String> writeBase64VideoToTempFilePost(String base64Data) async {
  try {
    // Decode the base64 video data
    final decodedBytes = base64Decode(base64Data);

    print("Post video bytes data");
    print(decodedBytes);

    // Get the external storage directory or temporary directory
    Directory? externalStorageDirectory;

    if (Platform.isAndroid) {
      // Scoped Storage - Use the Downloads directory for Android 10 and higher
      externalStorageDirectory = await getExternalStorageDirectory();
    } else {
      // For non-Android platforms, use the external storage directory
      externalStorageDirectory = await getExternalStorageDirectory();
    }

    if (externalStorageDirectory == null ||
        !externalStorageDirectory.existsSync()) {
      print("External storage directory not found.");
      return "";
    }

    // Create a sub-directory for the video (temp_post_video) in the external storage
    final videoDirectory =
        Directory(path.join(externalStorageDirectory.path, 'temp_post_video'));

    // Check if the directory exists, and create it if not
    if (!await videoDirectory.exists()) {
      await videoDirectory.create(
          recursive: true); // Ensure the directory exists
    }

    // Generate a unique file name using the current timestamp
    final fileName =
        "video_${DateTime.now().toIso8601String()}.mp4"; // You can change the extension if necessary
    final filePath = path.join(videoDirectory.path, fileName);

    // Write the decoded bytes to the file
    final file = File(filePath);
    await file.writeAsBytes(decodedBytes);

    print("Post video saved to temporary file successfully.");
    print(filePath);
    return filePath; // Return the unique file path for the video player
  } catch (e) {
    print("Exception caught while saving post video temporary files.");
    print('Error writing base64 to file: $e');
    return "";
  }
}

Future<String> writeBase64VideoToTempFileCampaign(String base64Data) async {
  try {
    // Decode the base64 video data
    final decodedBytes = base64Decode(base64Data);

    print("Post video bytes data");
    print(decodedBytes);

    // Get the external storage directory or temporary directory
    Directory? externalStorageDirectory;

    if (Platform.isAndroid) {
      // Scoped Storage - Use the Downloads directory for Android 10 and higher
      externalStorageDirectory = await getExternalStorageDirectory();
    } else {
      // For non-Android platforms, use the external storage directory
      externalStorageDirectory = await getExternalStorageDirectory();
    }

    if (externalStorageDirectory == null ||
        !externalStorageDirectory.existsSync()) {
      print("External storage directory not found.");
      return "";
    }

    // Create a sub-directory for the video (temp_post_video) in the external storage
    final videoDirectory = Directory(
        path.join(externalStorageDirectory.path, 'temp_campaign_video'));

    // Check if the directory exists, and create it if not
    if (!await videoDirectory.exists()) {
      await videoDirectory.create(
          recursive: true); // Ensure the directory exists
    }

    // Generate a unique file name using the current timestamp
    final fileName =
        "video_${DateTime.now().toIso8601String()}.mp4"; // You can change the extension if necessary
    final filePath = path.join(videoDirectory.path, fileName);

    // Write the decoded bytes to the file
    final file = File(filePath);
    await file.writeAsBytes(decodedBytes);

    print("Post video saved to temporary file successfully.");
    print(filePath);
    return filePath; // Return the unique file path for the video player
  } catch (e) {
    print("Exception caught while saving post video temporary files.");
    print('Error writing base64 to file: $e');
    return "";
  }
}

Future<void> deleteTempDirectoryPostVideo() async {
  try {
    // Get the external storage directory (Android specific path)
    final externalStorageDirectory = await getExternalStorageDirectory();

    // Create the path for the temp_post_video directory
    final videoDir =
        Directory(path.join(externalStorageDirectory!.path, 'temp_post_video'));

    // Check if the directory exists, and if so, delete it and its contents
    if (await videoDir.exists()) {
      await videoDir.delete(
          recursive: true); // Deletes the directory and its contents
      print("Temporary video directory deleted.");
    } else {
      print("Temporary video directory for post video not found.");
    }
  } catch (e) {
    print("Error deleting temporary directory: $e");
  }
}

Future<void> deleteTempDirectoryCampaignVideo() async {
  try {
    // Get the external storage directory (Android specific path)
    final externalStorageDirectory = await getExternalStorageDirectory();

    // Create the path for the temp_post_video directory
    final videoDir = Directory(
        path.join(externalStorageDirectory!.path, 'temp_campaign_video'));

    // Check if the directory exists, and if so, delete it and its contents
    if (await videoDir.exists()) {
      await videoDir.delete(
          recursive: true); // Deletes the directory and its contents
      print("Temporary video directory deleted.");
    } else {
      print("Temporary video directory for campaign video not found.");
    }
  } catch (e) {
    print("Error deleting temporary directory: $e");
  }
}

Future<int> RetryFailDataSaveInDatabse(
    {required String jwttoken,
    required String DonateAmount,
    required String DonerUsername,
    required String PaymentMethod,
    required String PostId,
    required String ReceiverUsername}) async {
  try {
    int result = await Donate(
        JwtToken: jwttoken,
        donate_amount: int.parse(DonateAmount),
        Donate_date: DateTime.now().toUtc().toString(),
        doner_username: DonerUsername,
        payment_method: PaymentMethod,
        post_id: int.parse(PostId),
        receiver_username: ReceiverUsername);
    print("");
    print(
        "Http method call result to save data in dontation table in adatabase after faile one time.Retey method is calling.");
    print(result);
    print("");
    if (result == 1) {
      return 1;
    } else {
      return 2;
    }
  } catch (Obj) {
    print("Exception caught in retry data save in database of payment");
    print(Obj.toString());
    return 0;
  }
}

Future<void> checkJWTExpiation(
    {required BuildContext context,
    required String username,
    required String usertype,
    required String jwttoken}) async {
  try {
    print("check jwt called");
    int result =
        await checkJwtToken_initistate_user(username, usertype, jwttoken);
    if (result == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Home();
        },
      ));
      Toastget().Toastmsg("Session End. Relogin please.");
    }
  } catch (obj) {
    print(
        "Exception caught while nverifying jwttoken from common method dart file.");
    print(obj.toString());
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return Home();
      },
    ));
    Toastget().Toastmsg("Error. Relogin please.");
  }
}

Future<int> Donate({
  required String doner_username,
  required String receiver_username,
  required int donate_amount,
  required int post_id,
  required String payment_method,
  required String JwtToken,
  required String Donate_date,
}) async {
  print("TEST1");
  print(JwtToken);

  try {
    // Prepare the data dictionary to send to the server
    final Map<String, String> userData = {
      "DonerUsername": doner_username,
      "ReceiverUsername": receiver_username,
      "DonateAmount": donate_amount.toString(),
      "DonateDate": Donate_date,
      "PostId": post_id.toString(),
      "PaymentMethod": payment_method,
    };

    // API endpoint
    // const String url = "http://10.0.2.2:5074/api/Home/donate";
    const String url = "http://192.168.1.65:5074/api/Home/donate";

    print("TEST2");
    final headers = {
      'Authorization': 'Bearer ${JwtToken}',
      'Content-Type': 'application/json',
    };
    // Send the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(userData),
    );
    print("TEST3");

    print(response.statusCode);

    // Handling the response
    if (response.statusCode == 200) {
      print("Data insert in DonateInfo  table successs.");
      return 1;
    } else if (response.statusCode == 5000) {
      //exception caught in backend
      return 2;
    } else if (response.statusCode == 5001) {
      //model state invalid in backend
      return 3;
    } else {
      print("Other errors.");
      return 4;
    }
  } catch (Obj) {
    print("Exception caught in htttp method of donation.");
    print(Obj.toString());
    return 0;
  }
}

Future<int> Add_Notifications_Message_CM({required String not_type,required String not_receiver_username,required String not_message,required String JwtToken }) async {
  try {
    print("Profile post info method called");
    //  const String url = "http://10.0.2.2:5074/api/Home/add_notifications";
    const String url ="http://192.168.1.65:5074/api/Home/add_notifications";
    final headers =
    {
      'Authorization': 'Bearer ${JwtToken}',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> Not_Dict =
    {
      "NotType": not_type,
      "NotReceiverUsername": not_receiver_username,
      "NotMessage": not_message,
    };

    final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(Not_Dict)
    );

    if (response.statusCode == 200)
    {
      print("Data insert in notification table in http method in Bill generation SDF success.");
      return 1;
    }
    else
    {
      print("Data insert in notification table in http method in Bill generation SDF failed.");
      return 2;
    }
  } catch (obj) {
    print("Exception caught while adding notification data in http method in Bill generation SDF");
    print(obj.toString());
    return 0;
  }
}
