// test/insert_post_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'constant/test_constant.dart'; // For MockJwtToken

// Generate mocks for http.Client
@GenerateMocks([http.Client])
import 'insert_post_test.mocks.dart';
import 'testing_http_method/insert_post_test_http_method.dart';

void main() {
  // Mock data
  String mockJwtToken = MockJwtToken; // Ensure this is defined in test_constant.dart
  const String mockUsername = 'hari123';
  const String mockDescription = 'Test post description';
  const String mockFileExtension = 'pdf';
  final List<int> mockImageBytes = [1, 2, 3];
  final List<int> mockVideoBytes = [4, 5, 6];
  final List<int> mockFileBytes = [7, 8, 9];

  // The API URL
  const String apiUrl = Backend_Server_Url + 'api/Actions/insertpost';

  // Group tests for AddPostTest
  group('AddPostTest', () {
    // Test 1: Success case (200 OK)
    test('returns 0 on successful post insertion', () async {
      print('Running test: Successful post insertion (200 OK)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"message": "Post inserted"}', 200),
      );

      final result = await AddPostTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        jwttoken: mockJwtToken,
        filebytes: mockFileBytes,
        description: mockDescription,
        imagebytes: mockImageBytes,
        videobytes: mockVideoBytes,
        client: client, // Pass mock client
      );

      print('Test result: $result');
      expect(result, 0);
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    // Test 2: User doesn't exist (701)
    test('returns 5 when user does not exist', () async {
      print('Running test: User does not exist (701)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "User not found"}', 701),
      );

      final result = await AddPostTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        jwttoken: mockJwtToken,
        filebytes: mockFileBytes,
        description: mockDescription,
        imagebytes: mockImageBytes,
        videobytes: mockVideoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, 5);
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    // Test 3: Backend exception (702)
    test('returns 3 on backend exception', () async {
      print('Running test: Backend exception (702)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Backend exception"}', 702),
      );

      final result = await AddPostTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        jwttoken: mockJwtToken,
        filebytes: mockFileBytes,
        description: mockDescription,
        imagebytes: mockImageBytes,
        videobytes: mockVideoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, 3);
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    // Test 4: Validation error (700)
    test('returns 6 on backend validation error', () async {
      print('Running test: Validation error (700)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Validation failed"}', 700),
      );

      final result = await AddPostTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        jwttoken: mockJwtToken,
        filebytes: mockFileBytes,
        description: mockDescription,
        imagebytes: mockImageBytes,
        videobytes: mockVideoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, 6);
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    // Test 5: Details validation error (400)
    test('returns 9 on details validation error', () async {
      print('Running test: Details validation error (400)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Invalid details"}', 400),
      );

      final result = await AddPostTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        jwttoken: mockJwtToken,
        filebytes: mockFileBytes,
        description: mockDescription,
        imagebytes: mockImageBytes,
        videobytes: mockVideoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, 9);
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    // Test 6: JWT unauthorized error (401)
    test('returns 10 on JWT unauthorized error', () async {
      print('Running test: JWT unauthorized error (401)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Unauthorized"}', 401),
      );

      final result = await AddPostTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        jwttoken: mockJwtToken,
        filebytes: mockFileBytes,
        description: mockDescription,
        imagebytes: mockImageBytes,
        videobytes: mockVideoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, 10);
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    // Test 7: JWT forbidden error (403)
    test('returns 11 on JWT forbidden error', () async {
      print('Running test: JWT forbidden error (403)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Forbidden"}', 403),
      );

      final result = await AddPostTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        jwttoken: mockJwtToken,
        filebytes: mockFileBytes,
        description: mockDescription,
        imagebytes: mockImageBytes,
        videobytes: mockVideoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, 11);
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    // Test 8: Other status code (e.g., 500)
    test('returns 4 on unexpected status code', () async {
      print('Running test: Unexpected status code (500)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Server error"}', 500),
      );

      final result = await AddPostTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        jwttoken: mockJwtToken,
        filebytes: mockFileBytes,
        description: mockDescription,
        imagebytes: mockImageBytes,
        videobytes: mockVideoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, 4);
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    // Test 9: Exception case
    test('returns 2 on HTTP exception', () async {
      print('Running test: HTTP exception');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenThrow(Exception('Network error'));

      final result = await AddPostTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        jwttoken: mockJwtToken,
        filebytes: mockFileBytes,
        description: mockDescription,
        imagebytes: mockImageBytes,
        videobytes: mockVideoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, 2);
      verify(client.post(Uri.parse(apiUrl), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });
  });
}



