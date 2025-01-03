import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

import 'VideoPlayer_controller.dart';

Future<void> saveJwtToken(String token) async {
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
Future<String?> getJwtToken() async {
  final box = await Hive.openBox('userData');
  // Retrieve JWT token from Hive
  String? token = await box.get('jwt_token');
  return token;
}

// Method to save username and password
Future<void> saveUserCredentials(String username, String usertype) async {
  final box = await Hive.openBox('userData');

  // Ensure that username and password are not null
  if (username != null && usertype != null) {
    // Save username and password to Hive
    await box.put('username', username);
    await box.put('usertype', usertype);
    print("Username and usertype saved.");
  } else {
    print("Error: Username or usertype is missing.");
  }
}

// Method to retrieve username and password
Future<Map<String, String?>> getUserCredentials() async {
  final box = await Hive.openBox('userData');
  // Retrieve username and password from Hive
  String? username =await box.get('username');
  String? usertype =await box.get('usertype');

  return {
    'username': username,
    'usertype': usertype,
  };
}

// Method to clear JWT token, username, and password
Future<void> clearUserData() async {
    final box = await Hive.openBox('userData');
    // Clear JWT token, username, and password
    await box.delete('jwt_token');
    await box.delete('username');
    await box.delete('usertype');
    print("User data cleared.");
}

// Method to handle API response and save data if status code is 200
Future<void> handleResponse(Map<String, dynamic> responseData) async {


    String token = responseData['token']!;
    String username = responseData['username']!;
    String password = responseData['usertype']!;

    await saveJwtToken(token);
    await saveUserCredentials(username, password);


}

Future<int> checkJwtToken_initistate_user (String username,String usertype,String jwttoken) async {

  print("jwt token");
  print(jwttoken);
  print("username");
  print(username);
  print("user type");
  print(usertype);

  if (jwttoken == null || jwttoken.isEmpty || usertype!="user" || usertype.isEmpty || usertype == null || username ==null || username.isEmpty)
  {
    print("User details miss match.");
    await clearUserData();
    return 0;
  }

  // final Map<String, dynamic> jwtData = {
  //   "JwtBlacklist": jwttoken,
  // };

    // verification1
  final response2 = await http.get(
      Uri.parse('http://10.0.2.2:5074/api/Authentication/jwtverify'),
      headers: {'Authorization': 'Bearer $jwttoken'},
    );
  if (response2.statusCode == 200)
    {
      if(usertype=="user")
      {
        return 1;
      }
      else
      {
        print("user type mismatch.jwt initistate user");
        await clearUserData();
        return 0;
      }
    }
  else
    {
      print("jwt not verify for jwt initstate user");
      await clearUserData();
      return 0;
    }

}



Future<void> downloadFilePost(String? base64String,String fileExtension) async {
  if (base64String == null || base64String.isEmpty) {
    Toastget().Toastmsg("File content is empty");
    return;
  }

  // Request permission to write to external storage
  var permissionStatus = await Permission.storage.request();
  if (!permissionStatus.isGranted) {
    Toastget().Toastmsg("Storage permission is required to download files.");
    return;
  }

  try {
    // Decode the base64 string into bytes
    final fileBytes = base64Decode(base64String);

    // Get the directory to save the file
    Directory? downloadsDirectory;

    if (Platform.isAndroid) {
      // Extract the major version number (the part before the first dot)
      var versionParts = Platform.version.split(" ")[0].split(".");
      var majorVersion = int.tryParse(versionParts[0]) ?? 0; // Safely parse the major version

      if (majorVersion >= 10) {
        // Scoped Storage - Use the Downloads directory for Android 10 and higher
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else {
        // For Android versions lower than 10, use the standard method (legacy storage)
        downloadsDirectory = await getExternalStorageDirectory();
      }
    } else {
      // For non-Android platforms, use the external storage directory
      downloadsDirectory = await getExternalStorageDirectory();
    }

    if (downloadsDirectory == null || !downloadsDirectory.existsSync()) {
      Toastget().Toastmsg("Downloads folder not found.");
      return;
    }

    // Generate file name and path
    final fileName = "hand_in_need_post_file_${DateTime.now().toIso8601String()}.${fileExtension}";
    final filePath = path.join(downloadsDirectory.path, fileName);

    // Write the bytes to the file
    final file = File(filePath);
    await file.writeAsBytes(fileBytes);

    // Notify the user of the saved file location
    print("File saved to: $filePath");
    Toastget().Toastmsg("File downloaded to: $filePath");
  } catch (e) {
    print("Exception caught while downloading file for post.");
    print(e.toString());
    Toastget().Toastmsg("Error: $e");
  }
}



Future<void> downloadFileCampaign(String? base64String,String fileExtension) async {
  if (base64String == null || base64String.isEmpty) {
    Toastget().Toastmsg("File content is empty");
    return;
  }

  // Request permission to write to external storage
  var permissionStatus = await Permission.storage.request();
  if (!permissionStatus.isGranted) {
    Toastget().Toastmsg("Storage permission is required to download files.");
    return;
  }

  try {
    // Decode the base64 string into bytes
    final fileBytes = base64Decode(base64String);

    // Get the directory to save the file
    Directory? downloadsDirectory;

    if (Platform.isAndroid) {
      // Extract the major version number (the part before the first dot)
      var versionParts = Platform.version.split(" ")[0].split(".");
      var majorVersion = int.tryParse(versionParts[0]) ?? 0; // Safely parse the major version

      if (majorVersion >= 10) {
        // Scoped Storage - Use the Downloads directory for Android 10 and higher
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      }
      else {
        // For Android versions lower than 10, use the standard method (legacy storage)
        downloadsDirectory = await getExternalStorageDirectory();
      }
    }
    else {
      // For non-Android platforms, use the external storage directory
      downloadsDirectory = await getExternalStorageDirectory();
    }

    if (downloadsDirectory == null || !downloadsDirectory.existsSync()) {
      Toastget().Toastmsg("Downloads folder not found.");
      return;
    }

    // Generate file name and path
    final fileName = "hand_in_need_campaign_file_${DateTime.now().toIso8601String()}.${fileExtension}";
    final filePath = path.join(downloadsDirectory.path, fileName);

    // Write the bytes to the file
    final file = File(filePath);
    await file.writeAsBytes(fileBytes);

    // Notify the user of the saved file location
    print("File saved to: $filePath");
    Toastget().Toastmsg("File downloaded to: $filePath");
  } catch (e) {
    print("Exception caught while downloading file for post.");
    print(e.toString());
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

    if (externalStorageDirectory == null || !externalStorageDirectory.existsSync()) {
      print("External storage directory not found.");
      return "";
    }

    // Create a sub-directory for the video (temp_post_video) in the external storage
    final videoDirectory = Directory(path.join(externalStorageDirectory.path, 'temp_post_video'));

    // Check if the directory exists, and create it if not
    if (!await videoDirectory.exists()) {
      await videoDirectory.create(recursive: true); // Ensure the directory exists
    }

    // Generate a unique file name using the current timestamp
    final fileName = "video_${DateTime.now().toIso8601String()}.mp4"; // You can change the extension if necessary
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

    if (externalStorageDirectory == null || !externalStorageDirectory.existsSync()) {
      print("External storage directory not found.");
      return "";
    }

    // Create a sub-directory for the video (temp_post_video) in the external storage
    final videoDirectory = Directory(path.join(externalStorageDirectory.path, 'temp_campaign_video'));

    // Check if the directory exists, and create it if not
    if (!await videoDirectory.exists()) {
      await videoDirectory.create(recursive: true); // Ensure the directory exists
    }

    // Generate a unique file name using the current timestamp
    final fileName = "video_${DateTime.now().toIso8601String()}.mp4"; // You can change the extension if necessary
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
    final videoDir = Directory(path.join(externalStorageDirectory!.path, 'temp_post_video'));

    // Check if the directory exists, and if so, delete it and its contents
    if (await videoDir.exists()) {
      await videoDir.delete(recursive: true); // Deletes the directory and its contents
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
    final videoDir = Directory(path.join(externalStorageDirectory!.path, 'temp_campaign_video'));

    // Check if the directory exists, and if so, delete it and its contents
    if (await videoDir.exists()) {
      await videoDir.delete(recursive: true); // Deletes the directory and its contents
      print("Temporary video directory deleted.");
    }
    else
    {
      print("Temporary video directory for campaign video not found.");
    }
  } catch (e) {
    print("Error deleting temporary directory: $e");
  }
}






