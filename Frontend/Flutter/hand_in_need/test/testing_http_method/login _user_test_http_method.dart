// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hand_in_need/views/mobile/constant/constant.dart';

// Mock saveJwtToken and saveUserCredentials
Future<void> saveJwtTokenTest(String token) async {
  print('Mock saveJwtToken called with token: $token');
}

Future<void> saveUserCredentialsTest(String username, String userType, String loginDate) async {
  print('Mock saveUserCredentials called with username: $username, userType: $userType, loginDate: $loginDate');
}

Future<void> handleResponse(Map<String, dynamic> responseData) async {
  try {
    String token = responseData['token'] ?? '';
    String username = responseData['user'] ?? responseData['username'] ?? '';
    String userType = responseData['usertype'] ?? 'default'; // Fallback if usertype is missing
    String loginDate = DateTime.now().toUtc().toIso8601String();

    if (token.isEmpty || username.isEmpty) {
      throw Exception('Invalid response data: token or username missing');
    }

    await saveJwtTokenTest(token);
    await saveUserCredentialsTest(username, userType, loginDate);

    print('Login success');
    print('User data:');
    print('JWT token: $token');
    print('Username: $username');
    print('User type: $userType');
    print('Login date: $loginDate');
  } catch (e) {
    print('Error in handleResponse: $e');
    rethrow; // Rethrow to allow LoginUserTest to catch the exception
  }
}

Future<int> LoginUserTest({
  required String username,
  required String password,
  required http.Client client,
}) async {
  try {
    print('Preparing login request for username: $username');
    final Map<String, dynamic> userData = {"Username": username, "Password": password};
    const String url = Backend_Server_Url + "api/Authentication/login";

    print('Sending POST request to $url');
    print('Request headers: {"Content-Type": "application/json"}');
    print('Request body: ${json.encode(userData)}');

    final response = await client.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(userData),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Login successful.');
      Map<String, dynamic> responseData = jsonDecode(response.body);
      await handleResponse(responseData);
      return 1;
    } else if (response.statusCode == 503) {
      print("Invalid password.");
      return 3;
    } else if (response.statusCode == 501) {
      print("Username not found.");
      return 4;
    } else if (response.statusCode == 502) {
      print("Incorrect format of provided details.");
      return 5;
    } else if (response.statusCode == 400) {
      print("Incorrect provided details.");
      return 6;
    } else {
      print("Unexpected status code: ${response.statusCode}");
      print("Error response body: ${response.body}");
      return 2;
    }
  } catch (e) {
    print("Exception caught in LoginUserTest method.");
    print("Exception: $e");
    return 0;
  }
}