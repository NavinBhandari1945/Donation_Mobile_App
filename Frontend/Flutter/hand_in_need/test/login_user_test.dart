// test/login_user_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'constant/test_constant.dart';

// Generate mocks for http.Client
@GenerateMocks([http.Client])
import 'login_user_test.mocks.dart';
import 'testing_http_method/login _user_test_http_method.dart';


void main() {
  // Mock data
  const String mockUsername = 'hari123';
  const String mockPassword = 'hari123';
  const String mockUserType = 'user';
  const String apiUrl = Backend_Server_Url + 'api/Authentication/login';

  // Group tests for LoginUserTest
  group('LoginUserTest', () {
    // Test 1: Success case (200 OK)
    test('returns 1 on successful login', () async {
      print('Running test: Successful login (200 OK)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response(
          jsonEncode({
            'token': MockJwtToken,
            'user': mockUsername,
            'usertype': mockUserType,
          }),
          200,
        ),
      );

      final result = await LoginUserTest(
        username: mockUsername,
        password: mockPassword,
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

    // Test 2: Invalid password (503)
    test('returns 3 on invalid password', () async {
      print('Running test: Invalid password (503)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Invalid password"}', 503),
      );

      final result = await LoginUserTest(
        username: mockUsername,
        password: mockPassword,
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

    // Test 3: Username not found (501)
    test('returns 4 when username not found', () async {
      print('Running test: Username not found (501)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Username not found"}', 501),
      );

      final result = await LoginUserTest(
        username: mockUsername,
        password: mockPassword,
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

    // Test 4: Incorrect format (502)
    test('returns 5 on incorrect format of details', () async {
      print('Running test: Incorrect format (502)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Incorrect format"}', 502),
      );

      final result = await LoginUserTest(
        username: mockUsername,
        password: mockPassword,
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

    // Test 5: Incorrect details (400)
    test('returns 6 on incorrect provided details', () async {
      print('Running test: Incorrect details (400)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Invalid details"}', 400),
      );

      final result = await LoginUserTest(
        username: mockUsername,
        password: mockPassword,
        client: client,
      );

      print('Test result: $result');
      expect(result, 6);
      verify(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 6: Other status code (500)
    test('returns 2 on unexpected status code', () async {
      print('Running test: Unexpected status code (500)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async => http.Response('{"error": "Server error"}', 500),
      );

      final result = await LoginUserTest(
        username: mockUsername,
        password: mockPassword,
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

    // Test 7: Exception case
    test('returns 0 on HTTP exception', () async {
      print('Running test: HTTP exception');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenThrow(Exception('Network error'));

      final result = await LoginUserTest(
        username: mockUsername,
        password: mockPassword,
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