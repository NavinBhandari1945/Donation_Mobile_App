// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hand_in_need/views/mobile/constant/constant.dart';

Future<int> DeleteUserTest({
  required String username,
  required String jwtToken,
  required http.Client client,
}) async {
  try {
    print('Preparing delete user request for username: $username');
    const String url = Backend_Server_Url + "api/Admin_Task_/delete_user";
    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> usernameDict = {
      "Username": username,
    };

    print('Sending DELETE request to $url');
    print('Request headers: $headers');
    print('Request body: ${json.encode(usernameDict)}');

    final response = await client.delete(
      Uri.parse(url),
      headers: headers,
      body: json.encode(usernameDict),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print("User deleted successfully");
      return 1;
    } else {
      print("Failed to delete user. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      return 2;
    }
  } catch (e) {
    print("Exception caught in DeleteUserTest method.");
    print("Exception: $e");
    return 0;
  }
}