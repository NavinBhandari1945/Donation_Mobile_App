// test/get_post_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hand_in_need/models/mobile/PostInfoModel.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart'; // For Backend_Server_Url
// Generate mocks for http.Client
import 'constant/test_constant.dart';
@GenerateMocks([http.Client])
import 'get_post_test.mocks.dart';
import 'testing_http_method/get_post_test_http_method.dart';

void main() {
  // Mock JWT token
  String mockJwtToken =MockJwtToken;
  // The API URL
  const String apiUrl = Backend_Server_Url + 'api/Home/getpostinfo';

  // Group tests for GetPostInfoTest
  group('GetPostInfoTest', () {
    // Test 1: Success case (200 OK)
    test('successfully fetches and populates PostInfoList', () async {
      // Create a mock HTTP client
      final client = MockClient();

      // Mock the HTTP GET request
      when(client.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
      )).thenAnswer(
            (_) async => http.Response(
          jsonEncode([
            {
              'postId': 25,
              'username': 'qqq',
              'dateCreated': '2022-02-03T00:00:00',
              'description': 'qqqq',
              'photo': 'qqq',
              'video': 'qqqq',
              'postFile': 'qqqq',
              'fileExtension': 'docx',
            },
            {
              'postId': 26,
              'username': 'abc',
              'dateCreated': '2022-02-04T00:00:00',
              'description': 'abcd',
              'photo': 'abc',
              'video': 'abcd',
              'postFile': 'abcd',
              'fileExtension': 'pdf',
            },
          ]),
          200,
        ),
      );

      // Call GetPostInfoTest with the mocked client
      await GetPostInfoTest(client: client, jwttoken: mockJwtToken);

      // Verify the results
      expect(PostInfoListTest.length, 2); // Should have 2 items
      expect(PostInfoListTest[0].postId, 25);
      expect(PostInfoListTest[0].username, 'qqq');
      expect(PostInfoListTest[1].postId, 26);
      expect(PostInfoListTest[1].username, 'abc');
    });

    // Test 2: Failure case (404 Not Found)
    test('clears PostInfoList on non-200 status code', () async {
      // Create a mock HTTP client
      final client = MockClient();

      // Mock the HTTP GET request to return 404
      when(client.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
      )).thenAnswer(
            (_) async => http.Response('Not Found', 404),
      );

      // Populate PostInfoList with dummy data to test clearing
      PostInfoListTest.add(PostInfoModel(postId: 1, username: 'test'));

      // Call GetPostInfoTest
      await GetPostInfoTest(client: client, jwttoken: mockJwtToken);

      // Verify the results
      expect(PostInfoListTest.isEmpty, true); // Should be cleared
    });

    // Test 3: Failure case (network exception)
    test('clears PostInfoList on exception', () async {
      // Create a mock HTTP client
      final client = MockClient();

      // Mock the HTTP GET request to throw an exception
      when(client.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
      )).thenThrow(Exception('Network error'));

      // Populate PostInfoList with dummy data to test clearing
      PostInfoListTest.add(PostInfoModel(postId: 1, username: 'test'));

      // Call GetPostInfoTest
      await GetPostInfoTest(client: client, jwttoken: mockJwtToken);

      // Verify the results
      expect(PostInfoListTest.isEmpty, true); // Should be cleared
    });
  });
}