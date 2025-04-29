
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hand_in_need/views/mobile/constant/constant.dart';

Future<int> SignInUserTest({
  required String firstName,
  required String lastName,
  required String email,
  required String phoneNumber,
  required String username,
  required String password,
  required String address,
  required List<int> imageBytes,
  required String type,
  required http.Client client,
}) async {
  try {
    print('Preparing sign-in request for username: $username');
    final String base64Image = base64Encode(imageBytes);
    final Map<String, dynamic> userData = {
      "FirstName": firstName,
      "LastName": lastName,
      "Email": email,
      "PhoneNumber": phoneNumber,
      "Username": username,
      "Password": password,
      "Address": address,
      "Photo": base64Image,
      "Type": type,
    };
    const String url = Backend_Server_Url + "api/Authentication/signin";

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
      print("Data inserted in userinfo table successfully.");
      return 1;
    } else if (response.statusCode == 502) {
      print("Username already exists.");
      return 3;
    } else if (response.statusCode == 501) {
      print("Provided data are not in correct format.");
      return 4;
    } else if (response.statusCode == 500) {
      print("Exception caught in backend.");
      return 5;
    } else {
      print("Data insertion in userinfo table failed.");
      print("Unexpected status code: ${response.statusCode}");
      return 2;
    }
  } catch (e) {
    print("Exception caught in SignInUserTest method.");
    print("Exception: $e");
    return 0;
  }
}