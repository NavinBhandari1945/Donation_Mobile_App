// test/delete_user_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'constant/test_constant.dart';

// Generate mocks for http.Client
@GenerateMocks([http.Client])
import 'deleet_user_test.mocks.dart';
import 'testing_http_method/deleet_user_test_http_method.dart';

void main() {
  // Mock data
  const String mockUsername = 'user1';
  String mockJwtToken = MockJwtToken;
  const String apiUrl = Backend_Server_Url + 'api/Admin_Task_/delete_user';

  // Group tests for DeleteUserTest
  group('DeleteUserTest', () {
    // Test 1: Success case (200 OK)
    test('returns 1 on successful user deletion', () async {
      print('Running test: Successful user deletion (200 OK)');
      final client = MockClient();

      when(client.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client DELETE called');
          return http.Response('{"message": "User deleted"}', 200);
        },
      );

      final result = await DeleteUserTest(
        username: mockUsername,
        jwtToken: mockJwtToken,
        client: client,
      );

      print('Test result: $result');
      expect(result, 1);
      verify(client.delete(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 2: Non-200 status code (e.g., 400)
    test('returns 2 on failed user deletion (400)', () async {
      print('Running test: Failed user deletion (400)');
      final client = MockClient();

      when(client.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client DELETE called');
          return http.Response('{"error": "Bad request"}', 400);
        },
      );

      final result = await DeleteUserTest(
        username: mockUsername,
        jwtToken: mockJwtToken,
        client: client,
      );

      print('Test result: $result');
      expect(result, 2);
      verify(client.delete(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 3: Unauthorized (401)
    test('returns 2 on JWT authentication error (401)', () async {
      print('Running test: JWT authentication error (401)');
      final client = MockClient();

      when(client.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client DELETE called');
          return http.Response('{"error": "Unauthorized"}', 401);
        },
      );

      final result = await DeleteUserTest(
        username: mockUsername,
        jwtToken: mockJwtToken,
        client: client,
      );

      print('Test result: $result');
      expect(result, 2);
      verify(client.delete(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 4: Exception case
    test('returns 0 on HTTP exception', () async {
      print('Running test: HTTP exception');
      final client = MockClient();

      when(client.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: anyNamed('body'),
      )).thenThrow(Exception('Network error'));

      final result = await DeleteUserTest(
        username: mockUsername,
        jwtToken: mockJwtToken,
        client: client,
      );

      print('Test result: $result');
      expect(result, 0);
      verify(client.delete(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });
  });
}