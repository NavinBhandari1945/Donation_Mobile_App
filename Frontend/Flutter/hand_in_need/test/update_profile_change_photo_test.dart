// test/update_photo_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'constant/test_constant.dart';
// Generate mocks for http.Client
import 'testing_http_method/profile_update_change_photo_test_http_method.dart';
@GenerateMocks([http.Client])
import 'update_profile_change_photo_test.mocks.dart';

void main() {
  // Mock data
  const String mockUsername = 'user1';
  String mockJwtToken = MockJwtToken;
final List<int> mockPhotoBytes = [1, 2, 3];
  const String apiUrl = Backend_Server_Url + 'api/Profile/updatephoto';

  // Group tests for UpdatePhotoTest
  group('UpdatePhotoTest', () {
    // Test 1: Success case (200 OK)
    test('returns true on successful photo update', () async {
      print('Running test: Successful photo update (200 OK)');
      final client = MockClient();

      when(client.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client PUT called');
          return http.Response('{"message": "Photo updated"}', 200);
        },
      );

      final result = await UpdatePhotoTest(
        username: mockUsername,
        jwtToken: mockJwtToken,
        photoBytes: mockPhotoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, true);
      verify(client.put(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 2: Non-200 status code (e.g., 400)
    test('returns false on failed photo update (400)', () async {
      print('Running test: Failed photo update (400)');
      final client = MockClient();

      when(client.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client PUT called');
          return http.Response('{"error": "Bad request"}', 400);
        },
      );

      final result = await UpdatePhotoTest(
        username: mockUsername,
        jwtToken: mockJwtToken,
        photoBytes: mockPhotoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, false);
      verify(client.put(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 3: Unauthorized (401)
    test('returns false on JWT authentication error (401)', () async {
      print('Running test: JWT authentication error (401)');
      final client = MockClient();

      when(client.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client PUT called');
          return http.Response('{"error": "Unauthorized"}', 401);
        },
      );

      final result = await UpdatePhotoTest(
        username: mockUsername,
        jwtToken: mockJwtToken,
        photoBytes: mockPhotoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, false);
      verify(client.put(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 4: Exception case
    test('returns false on HTTP exception', () async {
      print('Running test: HTTP exception');
      final client = MockClient();

      when(client.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenThrow(Exception('Network error'));

      final result = await UpdatePhotoTest(
        username: mockUsername,
        jwtToken: mockJwtToken,
        photoBytes: mockPhotoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, false);
      verify(client.put(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });
  });
}