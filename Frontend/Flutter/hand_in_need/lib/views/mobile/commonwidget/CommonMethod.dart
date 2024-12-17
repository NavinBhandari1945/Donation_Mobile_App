import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

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
  if (jwttoken == null || jwttoken.isEmpty)
  {
    print("jwttoken null or empty in jwt initstate user");
    await clearUserData();
    return 0;
  }

  final Map<String, dynamic> jwtData = {
    "JwtBlacklist": jwttoken,
  };

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




