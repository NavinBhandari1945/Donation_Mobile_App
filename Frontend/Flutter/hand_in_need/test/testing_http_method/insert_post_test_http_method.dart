
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hand_in_need/views/mobile/constant/constant.dart';

Future<int> AddPostTest({
  required String fileExtension,
  required String username,
  required String jwttoken,
  required List<int> filebytes,
  required String description,
  //required String imagebytes,
  required List<int> imagebytes,
  required List<int> videobytes,
  required http.Client client, // Add client parameter
}) async {
  try {
    print('Encoding image, video, and file to base64...');

    // final String base64Image = base64Encode(imagebytes as List<int>);

    final String base64Image = base64Encode(imagebytes);
    final String base64Video = base64Encode(videobytes);
    final String base64File = base64Encode(filebytes);
    print('Base64 encoding completed.');

    const String url = Backend_Server_Url + "api/Actions/insertpost";
    Map<String, dynamic> postData = {
      "Username": username,
      "DateCreated": DateTime.now().toUtc().toString(),
      "Description": description,
      "Video": base64Video,
      "Photo": base64Image,
      "PostFile": base64File,
      "FileExtension": fileExtension,
    };

    print('Sending POST request to $url');
    print('Request headers: {"Content-Type": "application/json", "Authorization": "Bearer $jwttoken"}');
    print('Request body: ${json.encode(postData)}');

    final response = await client.post( // Use client instead of http.post
      Uri.parse(url),
      headers: {"Content-Type": "application/json", 'Authorization': 'Bearer $jwttoken'},
      body: json.encode(postData),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print("User authenticated. Post inserted successfully.");
      return 0;
    } else if (response.statusCode == 701) {
      print("User doesn't exist.");
      return 5;
    } else if (response.statusCode == 702) {
      print("Exception caught in backend.");
      return 3;
    } else if (response.statusCode == 700) {
      print("Validation error in backend.");
      return 6;
    } else if (response.statusCode == 400) {
      print("Details validation error.");
      return 9;
    } else if (response.statusCode == 401) {
      print("JWT error (unauthorized).");
      return 10;
    } else if (response.statusCode == 403) {
      print("JWT error (forbidden).");
      return 11;
    } else {
      print("Unexpected status code: ${response.statusCode}");
      print("Error response body: ${response.body}");
      return 4;
    }
  } catch (e) {
    print("Exception caught while inserting post in HTTP method.");
    print("Exception: $e");
    return 2;
  }
}



