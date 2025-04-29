// test/signin_user_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';


// Generate mocks for http.Client
@GenerateMocks([http.Client])
import 'signin_user_test.mocks.dart';
import 'testing_http_method/signin_user_test_http_method.dart';

void main() {
  // Mock data
  const String mockFirstName = 'Hari';
  const String mockLastName = 'Doe';
  const String mockEmail = 'hari.doe@example.com';
  const String mockPhoneNumber = '1234567890';
  const String mockUsername = 'hari123';
  const String mockPassword = 'hari123';
  const String mockAddress = '123 Main St';
  final List<int> mockImageBytes = [1, 2, 3];
  const String mockType = 'user';
  const String apiUrl = Backend_Server_Url + 'api/Authentication/signin';

  // Group tests for SignInUserTest
  group('SignInUserTest', () {
    // Test 1: Success case (200 OK)
    test('returns 1 on successful sign-in', () async {
      print('Running test: Successful sign-in (200 OK)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"message": "User signed in"}', 200);
        },
      );

      final result = await SignInUserTest(
        firstName: mockFirstName,
        lastName: mockLastName,
        email: mockEmail,
        phoneNumber: mockPhoneNumber,
        username: mockUsername,
        password: mockPassword,
        address: mockAddress,
        imageBytes: mockImageBytes,
        type: mockType,
        client: client,
      );

      print('Test result: $result');
      expect(result, 1);
      verify(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 2: Username already exists (502)
    test('returns 3 when username already exists', () async {
      print('Running test: Username already exists (502)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Username already exists"}', 502);
        },
      );

      final result = await SignInUserTest(
        firstName: mockFirstName,
        lastName: mockLastName,
        email: mockEmail,
        phoneNumber: mockPhoneNumber,
        username: mockUsername,
        password: mockPassword,
        address: mockAddress,
        imageBytes: mockImageBytes,
        type: mockType,
        client: client,
      );

      print('Test result: $result');
      expect(result, 3);
      verify(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 3: Incorrect data format (501)
    test('returns 4 when provided data are not in correct format', () async {
      print('Running test: Incorrect data format (501)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Incorrect data format"}', 501);
        },
      );

      final result = await SignInUserTest(
        firstName: mockFirstName,
        lastName: mockLastName,
        email: mockEmail,
        phoneNumber: mockPhoneNumber,
        username: mockUsername,
        password: mockPassword,
        address: mockAddress,
        imageBytes: mockImageBytes,
        type: mockType,
        client: client,
      );

      print('Test result: $result');
      expect(result, 4);
      verify(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 4: Backend exception (500)
    test('returns 5 on backend exception', () async {
      print('Running test: Backend exception (500)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Backend exception"}', 500);
        },
      );

      final result = await SignInUserTest(
        firstName: mockFirstName,
        lastName: mockLastName,
        email: mockEmail,
        phoneNumber: mockPhoneNumber,
        username: mockUsername,
        password: mockPassword,
        address: mockAddress,
        imageBytes: mockImageBytes,
        type: mockType,
        client: client,
      );

      print('Test result: $result');
      expect(result, 5);
      verify(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 5: Other status code (e.g., 400)
    test('returns 2 on unexpected status code', () async {
      print('Running test: Unexpected status code (400)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Bad request"}', 400);
        },
      );

      final result = await SignInUserTest(
        firstName: mockFirstName,
        lastName: mockLastName,
        email: mockEmail,
        phoneNumber: mockPhoneNumber,
        username: mockUsername,
        password: mockPassword,
        address: mockAddress,
        imageBytes: mockImageBytes,
        type: mockType,
        client: client,
      );

      print('Test result: $result');
      expect(result, 2);
      verify(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 6: Exception case
    test('returns 0 on HTTP exception', () async {
      print('Running test: HTTP exception');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenThrow(Exception('Network error'));

      final result = await SignInUserTest(
        firstName: mockFirstName,
        lastName: mockLastName,
        email: mockEmail,
        phoneNumber: mockPhoneNumber,
        username: mockUsername,
        password: mockPassword,
        address: mockAddress,
        imageBytes: mockImageBytes,
        type: mockType,
        client: client,
      );

      print('Test result: $result');
      expect(result, 0);
      verify(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });
  });
}