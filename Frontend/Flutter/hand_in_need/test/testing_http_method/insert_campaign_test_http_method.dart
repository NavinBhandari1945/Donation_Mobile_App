// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hand_in_need/views/mobile/constant/constant.dart';

Future<int> AddCampaignTest({
  required String fileExtension,
  required String username,
  required String postId,
  required String tittle,
  required String jwttoken,
  required List<int> fileBytes,
  required String description,
  required List<int> imageBytes,
  required List<int> videoBytes,
  required http.Client client,
}) async {
  try {
    print('Preparing add campaign request for username: $username');
    final String base64Image = base64Encode(imageBytes);
    final String base64Video = base64Encode(videoBytes);
    final String base64File = base64Encode(fileBytes);

    const String url = Backend_Server_Url + "api/Actions/insertcampaign";
    final Map<String, dynamic> postData = {
      "Username": username,
      "CampaignDate": DateTime.now().toUtc().toString(),
      "Description": description,
      "Video": base64Video,
      "Photo": base64Image,
      "CampaignFile": base64File,
      "Tittle": tittle,
      "PostId": postId,
      "FileExtension": fileExtension,
    };

    print('Sending POST request to $url');
    print('Request headers: {"Content-Type": "application/json", "Authorization": "Bearer $jwttoken"}');
    print('Request body: ${json.encode(postData)}');

    final response = await client.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $jwttoken"},
      body: json.encode(postData),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print("Campaign inserted successfully");
      return 0;
    } else if (response.statusCode == 701) {
      print("User doesn't exist");
      return 5;
    } else if (response.statusCode == 702) {
      print("Exception caught in backend");
      return 3;
    } else if (response.statusCode == 700) {
      print("Validation error in backend");
      return 6;
    } else if (response.statusCode == 703) {
      print("Validation error in backend");
      return 1;
    } else if (response.statusCode == 400) {
      print("Details validation error");
      return 9;
    } else if (response.statusCode == 401) {
      print("JWT authentication error");
      return 10;
    } else if (response.statusCode == 403) {
      print("JWT authorization error");
      return 11;
    } else {
      print("Unexpected error: ${response.body}");
      print("Status code: ${response.statusCode}");
      return 4;
    }
  } catch (e) {
    print("Exception caught in AddCampaignTest method.");
    print("Exception: $e");
    return 2;
  }
}