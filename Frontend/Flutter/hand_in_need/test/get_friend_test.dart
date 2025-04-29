// test/friend_api_service_get_user_info_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'constant/test_constant.dart';

// Mock classes
@GenerateMocks([http.Client])
import "get_friend_test.mocks.dart";

// Define UserInfoModelTest
class UserInfoModelTest {
  UserInfoModelTest({
    String? username,
    String? email,
    String? bio,
  }) {
    _username = username;
    _email = email;
    _bio = bio;
  }

  UserInfoModelTest.fromJson(dynamic json) {
    _username = json['username'];
    _email = json['email'];
    _bio = json['bio'];
  }

  String? _username;
  String? _email;
  String? _bio;

  String? get username => _username;
  String? get email => _email;
  String? get bio => _bio;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['email'] = _email;
    map['bio'] = _bio;
    return map;
  }
}

// Global list
List<UserInfoModelTest> Friend_Profile_userinfomodel_list = [];

// Embedded method logic
Future<void> GetUserInfoTest({
  required String Friend_Username,
  required String CurrentUser_JwtToken,
  required http.Client client,
}) async {
  try {
    const String url = Backend_Server_Url + "api/Profile/getuserinfo";
    Map<String, dynamic> usernameDict = {"Username": Friend_Username};
    final response = await client.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $CurrentUser_JwtToken'
      },
      body: json.encode(usernameDict),
    );
    if (response.statusCode == 200) {
      print("profile post info");
      Map<dynamic, dynamic> responseData = await jsonDecode(response.body);
      Friend_Profile_userinfomodel_list.clear();
      Friend_Profile_userinfomodel_list.add(UserInfoModelTest.fromJson(responseData));
    } else {
      Friend_Profile_userinfomodel_list.clear();
      print("Data insert in userinfo list failed in friend profile http method.");
    }
  } catch (obj) {
    Friend_Profile_userinfomodel_list.clear();
    print("Exception caught while fetching user data for friend profile http method.");
    print(obj.toString());
  }
}

void main() {
  // Mock data
  String mockJwtToken = MockJwtToken;
  const String friendUsername = 'friend_user';
  const String apiUrl = Backend_Server_Url + 'api/Profile/getuserinfo';

  // Group tests for GetUserInfoTest
  group('GetUserInfoTest', () {
    // Test 1: Success case (200 OK)
    test('successfully fetches and populates Friend_Profile_userinfomodel_list', () async {
      print('Running test: Successful user info fetch (200 OK)');
      final client = MockClient();

      // Mock the HTTP POST request
      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: json.encode({'Username': friendUsername}),
      )).thenAnswer(
            (_) async => http.Response(
          jsonEncode({
            'username': 'friend_user',
            'email': 'friend@example.com',
            'bio': 'Friend bio',
          }),
          200,
        ),
      );

      // Call GetUserInfoTest
      await GetUserInfoTest(
        Friend_Username: friendUsername,
        CurrentUser_JwtToken: mockJwtToken,
        client: client,
      );

      // Verify the results
      print('Test result: List length = ${Friend_Profile_userinfomodel_list.length}');
      expect(Friend_Profile_userinfomodel_list.length, 1);
      expect(Friend_Profile_userinfomodel_list[0].username, 'friend_user');
      expect(Friend_Profile_userinfomodel_list[0].email, 'friend@example.com');
      expect(Friend_Profile_userinfomodel_list[0].bio, 'Friend bio');
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    // Test 2: Failure case (404 Not Found)
    test('clears Friend_Profile_userinfomodel_list on non-200 status code', () async {
      print('Running test: Failed user info fetch (404)');
      final client = MockClient();

      // Mock the HTTP POST request to return 404
      when(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Not Found"}', 404),
      );

      // Populate list with dummy data to test clearing
      Friend_Profile_userinfomodel_list.add(
        UserInfoModelTest(username: 'test', email: 'test@example.com', bio: 'Test bio'),
      );

      // Call GetUserInfoTest
      await GetUserInfoTest(
        Friend_Username: friendUsername,
        CurrentUser_JwtToken: mockJwtToken,
        client: client,
      );

      // Verify the results
      print('Test result: List is empty = ${Friend_Profile_userinfomodel_list.isEmpty}');
      expect(Friend_Profile_userinfomodel_list.isEmpty, true);
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    // Test 3: Exception case
    test('clears Friend_Profile_userinfomodel_list on exception', () async {
      print('Running test: HTTP exception for user info fetch');
      final client = MockClient();

      // Mock the HTTP POST request to throw an exception
      when(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenThrow(Exception('Network error'));

      // Populate list with dummy data to test clearing
      Friend_Profile_userinfomodel_list.add(
        UserInfoModelTest(username: 'test', email: 'test@example.com', bio: 'Test bio'),
      );

      // Call GetUserInfoTest
      await GetUserInfoTest(
        Friend_Username: friendUsername,
        CurrentUser_JwtToken: mockJwtToken,
        client: client,
      );

      // Verify the results
      print('Test result: List is empty = ${Friend_Profile_userinfomodel_list.isEmpty}');
      expect(Friend_Profile_userinfomodel_list.isEmpty, true);
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });
  });
}