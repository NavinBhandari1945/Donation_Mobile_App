// test/donate_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'constant/test_constant.dart';

// Generate mocks for http.Client
@GenerateMocks([http.Client])
import 'donation_test.mocks.dart';
import 'testing_http_method/donation_test_http_method.dart';

void main() {
  // Mock data
  const String mockDonerUsername = 'donor1';
  const String mockReceiverUsername = 'receiver1';
  const int mockDonateAmount = 100;
  const int mockPostId = 123;
  const String mockPaymentMethod = 'PayPal';
  String mockJwtToken = MockJwtToken;
  const String mockDonateDate = '2025-04-26T00:00:00';
  const String apiUrl = Backend_Server_Url + 'api/Home/donate';

  // Group tests for DonateTest
  group('DonateTest', () {
    // Test 1: Success case (200 OK)
    test('returns 1 on successful donation insertion', () async {
      print('Running test: Successful donation insertion (200 OK)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"message": "Donation inserted"}', 200);
        },
      );

      final result = await DonateTest(
        donerUsername: mockDonerUsername,
        receiverUsername: mockReceiverUsername,
        donateAmount: mockDonateAmount,
        postId: mockPostId,
        paymentMethod: mockPaymentMethod,
        jwtToken: mockJwtToken,
        donateDate: mockDonateDate,
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

    // Test 2: Backend exception (5000)
    test('returns 2 on backend exception', () async {
      print('Running test: Backend exception (5000)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Backend exception"}', 5000);
        },
      );

      final result = await DonateTest(
        donerUsername: mockDonerUsername,
        receiverUsername: mockReceiverUsername,
        donateAmount: mockDonateAmount,
        postId: mockPostId,
        paymentMethod: mockPaymentMethod,
        jwtToken: mockJwtToken,
        donateDate: mockDonateDate,
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

    // Test 3: Model state invalid (5001)
    test('returns 3 on invalid model state', () async {
      print('Running test: Invalid model state (5001)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Model state invalid"}', 5001);
        },
      );

      final result = await DonateTest(
        donerUsername: mockDonerUsername,
        receiverUsername: mockReceiverUsername,
        donateAmount: mockDonateAmount,
        postId: mockPostId,
        paymentMethod: mockPaymentMethod,
        jwtToken: mockJwtToken,
        donateDate: mockDonateDate,
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

    // Test 4: Other status code (e.g., 400)
    test('returns 4 on unexpected status code', () async {
      print('Running test: Unexpected status code (400)');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: anyNamed('body'),
      )).thenAnswer(
            (_) async {
          print('Mock client POST called');
          return http.Response('{"error": "Bad request"}', 400);
        },
      );

      final result = await DonateTest(
        donerUsername: mockDonerUsername,
        receiverUsername: mockReceiverUsername,
        donateAmount: mockDonateAmount,
        postId: mockPostId,
        paymentMethod: mockPaymentMethod,
        jwtToken: mockJwtToken,
        donateDate: mockDonateDate,
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

    // Test 5: Exception case
    test('returns 0 on HTTP exception', () async {
      print('Running test: HTTP exception');
      final client = MockClient();

      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: anyNamed('body'),
      )).thenThrow(Exception('Network error'));

      final result = await DonateTest(
        donerUsername: mockDonerUsername,
        receiverUsername: mockReceiverUsername,
        donateAmount: mockDonateAmount,
        postId: mockPostId,
        paymentMethod: mockPaymentMethod,
        jwtToken: mockJwtToken,
        donateDate: mockDonateDate,
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