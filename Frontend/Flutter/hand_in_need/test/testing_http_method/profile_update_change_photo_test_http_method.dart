// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hand_in_need/views/mobile/constant/constant.dart';

Future<bool> UpdatePhotoTest({
  required String username,
  required String jwtToken,
  required List<int> photoBytes,
  required http.Client client,
}) async {
  try {
    print('Preparing photo update request for username: $username');
    final String base64Image = base64Encode(photoBytes);
    const String url = Backend_Server_Url + "api/Profile/updatephoto";
    final Map<String, dynamic> newPhoto = {
      "Username": username,
      "Photo": base64Image,
    };

    print('Sending PUT request to $url');
    print('Request headers: {"Content-Type": "application/json", "Authorization": "Bearer $jwtToken"}');
    print('Request body: ${json.encode(newPhoto)}');

    final response = await client.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwtToken",
      },
      body: json.encode(newPhoto),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print("Photo updated successfully");
      return true;
    } else {
      print("Failed to update photo. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Exception caught in UpdatePhotoTest method.");
    print("Exception: $e");
    return false;
  }
}