// test/add_campaign_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'constant/test_constant.dart';

// Generate mocks for http.Client
@GenerateMocks([http.Client])
import 'insert_campaign_test.mocks.dart';
import 'testing_http_method/insert_campaign_test_http_method.dart';

void main() {
  // Mock data
  const String mockFileExtension = 'docx';
  const String mockUsername = 'user1';
  const String mockPostId = 'post123';
  const String mockTittle = 'Test Campaign';
  String mockJwtToken = MockJwtToken;
  final List<int> mockFileBytes = [1, 2, 3];
  const String mockDescription = 'This is a test campaign';
  final List<int> mockImageBytes = [4, 5, 6];
  final List<int> mockVideoBytes = [7, 8, 9];
  const String apiUrl = Backend_Server_Url + 'api/Actions/insertcampaign';

  // Group tests for AddCampaignTest
  group('AddCampaignTest', () {
    // Test 1: Success case (200 OK)
    test('returns 0 on successful campaign insertion', () async {
      print('Running test: Successful campaign insertion (200 OK)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"message": "Campaign inserted"}', 200);
        },
      );

      final result = await AddCampaignTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        postId: mockPostId,
        tittle: mockTittle,
        jwttoken: mockJwtToken,
        fileBytes: mockFileBytes,
        description: mockDescription,
        imageBytes: mockImageBytes,
        videoBytes: mockVideoBytes,
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
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "User does not exist"}', 701);
        },
      );

      final result = await AddCampaignTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        postId: mockPostId,
        tittle: mockTittle,
        jwttoken: mockJwtToken,
        fileBytes: mockFileBytes,
        description: mockDescription,
        imageBytes: mockImageBytes,
        videoBytes: mockVideoBytes,
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
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Backend exception"}', 702);
        },
      );

      final result = await AddCampaignTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        postId: mockPostId,
        tittle: mockTittle,
        jwttoken: mockJwtToken,
        fileBytes: mockFileBytes,
        description: mockDescription,
        imageBytes: mockImageBytes,
        videoBytes: mockVideoBytes,
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

    // Test 4: Validation error (700)
    test('returns 6 on backend validation error (700)', () async {
      print('Running test: Backend validation error (700)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Validation error"}', 700);
        },
      );

      final result = await AddCampaignTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        postId: mockPostId,
        tittle: mockTittle,
        jwttoken: mockJwtToken,
        fileBytes: mockFileBytes,
        description: mockDescription,
        imageBytes: mockImageBytes,
        videoBytes: mockVideoBytes,
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

    // Test 5: Validation error (703)
    test('returns 1 on backend validation error (703)', () async {
      print('Running test: Backend validation error (703)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Validation error"}', 703);
        },
      );

      final result = await AddCampaignTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        postId: mockPostId,
        tittle: mockTittle,
        jwttoken: mockJwtToken,
        fileBytes: mockFileBytes,
        description: mockDescription,
        imageBytes: mockImageBytes,
        videoBytes: mockVideoBytes,
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

    // Test 6: Details validation error (400)
    test('returns 9 on details validation error (400)', () async {
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
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Invalid details"}', 400);
        },
      );

      final result = await AddCampaignTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        postId: mockPostId,
        tittle: mockTittle,
        jwttoken: mockJwtToken,
        fileBytes: mockFileBytes,
        description: mockDescription,
        imageBytes: mockImageBytes,
        videoBytes: mockVideoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, 9);
      verify(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 7: JWT authentication error (401)
    test('returns 10 on JWT authentication error (401)', () async {
      print('Running test: JWT authentication error (401)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Unauthorized"}', 401);
        },
      );

      final result = await AddCampaignTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        postId: mockPostId,
        tittle: mockTittle,
        jwttoken: mockJwtToken,
        fileBytes: mockFileBytes,
        description: mockDescription,
        imageBytes: mockImageBytes,
        videoBytes: mockVideoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, 10);
      verify(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 8: JWT authorization error (403)
    test('returns 11 on JWT authorization error (403)', () async {
      print('Running test: JWT authorization error (403)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $mockJwtToken',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Forbidden"}', 403);
        },
      );

      final result = await AddCampaignTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        postId: mockPostId,
        tittle: mockTittle,
        jwttoken: mockJwtToken,
        fileBytes: mockFileBytes,
        description: mockDescription,
        imageBytes: mockImageBytes,
        videoBytes: mockVideoBytes,
        client: client,
      );

      print('Test result: $result');
      expect(result, 11);
      verify(client.post(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    // Test 9: Other status code (e.g., 500)
    test('returns 4 on unexpected status code (500)', () async {
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
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Server error"}', 500);
        },
      );

      final result = await AddCampaignTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        postId: mockPostId,
        tittle: mockTittle,
        jwttoken: mockJwtToken,
        fileBytes: mockFileBytes,
        description: mockDescription,
        imageBytes: mockImageBytes,
        videoBytes: mockVideoBytes,
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

    // Test 10: Exception case
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

      final result = await AddCampaignTest(
        fileExtension: mockFileExtension,
        username: mockUsername,
        postId: mockPostId,
        tittle: mockTittle,
        jwttoken: mockJwtToken,
        fileBytes: mockFileBytes,
        description: mockDescription,
        imageBytes: mockImageBytes,
        videoBytes: mockVideoBytes,
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
  });
}