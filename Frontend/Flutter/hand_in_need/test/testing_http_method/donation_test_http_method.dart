// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hand_in_need/views/mobile/constant/constant.dart';

Future<int> DonateTest({
  required String donerUsername,
  required String receiverUsername,
  required int donateAmount,
  required int postId,
  required String paymentMethod,
  required String jwtToken,
  required String donateDate,
  required http.Client client,
}) async {
  try {
    print('Preparing donation request for donor: $donerUsername, receiver: $receiverUsername');
    final Map<String, String> userData = {
      "DonerUsername": donerUsername,
      "ReceiverUsername": receiverUsername,
      "DonateAmount": donateAmount.toString(),
      "DonateDate": donateDate,
      "PostId": postId.toString(),
      "PaymentMethod": paymentMethod,
    };

    const String url = Backend_Server_Url + "api/Home/donate";
    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    print('Sending POST request to $url');
    print('Request headers: $headers');
    print('Request body: ${json.encode(userData)}');

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(userData),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print("Donation inserted successfully");
      return 1;
    } else if (response.statusCode == 5000) {
      print("Exception caught in backend");
      return 2;
    } else if (response.statusCode == 5001) {
      print("Model state invalid in backend");
      return 3;
    } else {
      print("Unexpected error: ${response.body}");
      print("Status code: ${response.statusCode}");
      return 4;
    }
  } catch (e) {
    print("Exception caught in DonateTest method.");
    print("Exception: $e");
    return 0;
  }
}