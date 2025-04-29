// test/get_campaign_info_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:hand_in_need/models/mobile/CampaignInfoModel.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'constant/test_constant.dart';

// Generate mocks for http.Client
@GenerateMocks([http.Client])
import 'get_campaign_info_test.mocks.dart';
import 'testing_http_method/get_campaign_info_test_http_method.dart';

void main() {
  // Mock data
  String mockJwtToken = MockJwtToken;
  final List<CampaignInfoModel> campaignInfoList = [];
  const String apiUrl = Backend_Server_Url + 'api/Campaigns/getcampaigninfo';

  // Sample campaign data matching CampaignInfoModel
  final mockCampaigns = [
    {
      'campaignId': 7,
      'photo': 'photo1.jpg',
      'description': 'Campaign description 1',
      'tittle': 'Campaign 1',
      'username': 'user1',
      'campaignDate': '2024-02-12T00:00:00',
      'postId': 25,
      'video': 'video1.mp4',
      'campaignFile': 'file1.docx',
      'fileExtension': 'docx',
    },
    {
      'campaignId': 8,
      'photo': 'photo2.jpg',
      'description': 'Campaign description 2',
      'tittle': 'Campaign 2',
      'username': 'user2',
      'campaignDate': '2024-03-15T00:00:00',
      'postId': 26,
      'video': 'video2.mp4',
      'campaignFile': 'file2.pdf',
      'fileExtension': 'pdf',
    },
  ];

  // Group tests for GetCampaignInfoTest
  group('GetCampaignInfoTest', () {
    // Test 1: Success case (200 OK)
    test('populates campaignInfoList on successful fetch (200 OK)', () async {
      print('Running test: Successful fetch (200 OK)');
      final client = MockClient();

      when(client.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
      )).thenAnswer(
            (_) async {
          print('Mock client GET called');
          return http.Response(jsonEncode(mockCampaigns), 200);
        },
      );

      await GetCampaignInfoTest(
        jwttoken: mockJwtToken,
        campaignInfoList: campaignInfoList,
        client: client,
      );

      print('Campaign list count: ${campaignInfoList.length}');
      expect(campaignInfoList.length, 2);
      expect(campaignInfoList[0].campaignId, 7);
      expect(campaignInfoList[0].tittle, 'Campaign 1');
      expect(campaignInfoList[1].campaignId, 8);
      expect(campaignInfoList[1].tittle, 'Campaign 2');
      verify(client.get(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
      )).called(1);
    });

    // Test 2: Failure case (non-200, e.g., 400)
    test('clears campaignInfoList on failed fetch (400)', () async {
      print('Running test: Failed fetch (400)');
      final client = MockClient();

      // Pre-populate list to test clearing
      campaignInfoList.add(CampaignInfoModel(
        campaignId: 1,
        tittle: 'Test',
        description: 'Test',
        username: 'test',
        campaignDate: '2024-01-01T00:00:00',
        postId: 1,
        photo: 'test.jpg',
        video: 'test.mp4',
        campaignFile: 'test.docx',
        fileExtension: 'docx',
      ));

      when(client.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
      )).thenAnswer(
            (_) async {
          print('Mock client GET called');
          return http.Response('{"error": "Bad request"}', 400);
        },
      );

      await GetCampaignInfoTest(
        jwttoken: mockJwtToken,
        campaignInfoList: campaignInfoList,
        client: client,
      );

      print('Campaign list count: ${campaignInfoList.length}');
      expect(campaignInfoList.isEmpty, true);
      verify(client.get(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
      )).called(1);
    });

    // Test 3: Exception case
    test('clears campaignInfoList on HTTP exception', () async {
      print('Running test: HTTP exception');
      final client = MockClient();

      // Pre-populate list to test clearing
      campaignInfoList.add(CampaignInfoModel(
        campaignId: 1,
        tittle: 'Test',
        description: 'Test',
        username: 'test',
        campaignDate: '2024-01-01T00:00:00',
        postId: 1,
        photo: 'test.jpg',
        video: 'test.mp4',
        campaignFile: 'test.docx',
        fileExtension: 'docx',
      ));

      when(client.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
      )).thenThrow(Exception('Network error'));

      await GetCampaignInfoTest(
        jwttoken: mockJwtToken,
        campaignInfoList: campaignInfoList,
        client: client,
      );

      print('Campaign list count: ${campaignInfoList.length}');
      expect(campaignInfoList.isEmpty, true);
      verify(client.get(
        Uri.parse(apiUrl),
        headers: anyNamed('headers'),
      )).called(1);
    });
  });
}