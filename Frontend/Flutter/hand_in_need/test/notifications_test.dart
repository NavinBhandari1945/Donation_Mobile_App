// test/notification_api_service_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'constant/test_constant.dart';

// Mock classes
@GenerateMocks([http.Client])
import "notifications_test.mocks.dart";

// Mock getUserCredentials
class MockCommonMethod {
  Future<Map<dynamic, dynamic>> getUserCredentials() async {
    return {'UserLogindate': '2025-04-25T12:00:00Z'};
  }
}

// Define NotificationsModel
class NotificationsModel {
  NotificationsModel({
    num? notId,
    String? notType,
    String? notReceiverUsername,
    String? notMessage,
    String? notDate,
  }) {
    _notId = notId;
    _notType = notType;
    _notReceiverUsername = notReceiverUsername;
    _notMessage = notMessage;
    _notDate = notDate;
  }

  NotificationsModel.fromJson(dynamic json) {
    _notId = json['notId'];
    _notType = json['notType'];
    _notReceiverUsername = json['notReceiverUsername'];
    _notMessage = json['notMessage'];
    _notDate = json['notDate'];
  }

  num? _notId;
  String? _notType;
  String? _notReceiverUsername;
  String? _notMessage;
  String? _notDate;

  num? get notId => _notId;
  String? get notType => _notType;
  String? get notReceiverUsername => _notReceiverUsername;
  String? get notMessage => _notMessage;
  String? get notDate => _notDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notId'] = _notId;
    map['notType'] = _notType;
    map['notReceiverUsername'] = _notReceiverUsername;
    map['notMessage'] = _notMessage;
    map['notDate'] = _notDate;
    return map;
  }
}

// Define Is_New_Notification
class Is_New_Notification {
  void Change_Is_New_Notification(bool value) {}
}

List<NotificationsModel> Notification_Info_List = [];
List<NotificationsModel> Filter_New_Notifications = [];

Future<void> Get_Notification_Info({
  required http.Client client,
  required String jwttoken,
  required String username,
}) async {
  try {
    print("Get_Notification_Info method called for profile screen.");
    const String url = Backend_Server_Url + "api/Profile/get_not";
    final headers = {
      'Authorization': 'Bearer $jwttoken',
      'Content-Type': 'application/json'
    };
    Map<String, dynamic> usernameDict = {"Username": username};
    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(usernameDict),
    );
    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body);
      Notification_Info_List.clear();
      Notification_Info_List.addAll(
        responseData.map((data) => NotificationsModel.fromJson(data)).toList(),
      );
      print("Notification info list count: ${Notification_Info_List.length}");
      Map<dynamic, dynamic> userCredentials = await MockCommonMethod().getUserCredentials();
      String? userLoginDateStr = userCredentials['UserLogindate'];
      if (userLoginDateStr != null &&
          userLoginDateStr.isNotEmpty &&
          Notification_Info_List.isNotEmpty) {
        DateTime userLoginDate = DateTime.parse(userLoginDateStr).toUtc();
        print("User Login Date (UTC): $userLoginDate");
        Filter_New_Notifications.clear();
        Filter_New_Notifications.addAll(
          Notification_Info_List.where((notification) {
            DateTime notificationDate =
            DateTime.parse(notification.notDate!).toUtc();
            print("Notification Date (UTC): $notificationDate");
            return notificationDate.isAfter(userLoginDate);
          }).toList(),
        );
        print(
            "Filtered Notifications Count: ${Filter_New_Notifications.length}");
        Is_New_Notification().Change_Is_New_Notification(
            Filter_New_Notifications.isNotEmpty);
      } else {
        Notification_Info_List.clear();
        Filter_New_Notifications.clear();
        Is_New_Notification().Change_Is_New_Notification(false);
        print("No new notifications or invalid login date.");
      }
    } else {
      Notification_Info_List.clear();
      Filter_New_Notifications.clear();
      Is_New_Notification().Change_Is_New_Notification(false);
      print("Failed to fetch notifications from API.");
    }
  } catch (e) {
    Notification_Info_List.clear();
    Filter_New_Notifications.clear();
    Is_New_Notification().Change_Is_New_Notification(false);
    print("Exception while fetching notifications: $e");
  }
}

void main() {
  // Mock JWT token
  String mockJwtToken = MockJwtToken;
  const String username = 'test_user';
  const String apiUrl = Backend_Server_Url + 'api/Profile/get_not';

  // Group tests for GetNotificationInfoTest
  group('GetNotificationInfoTest', () {
    // Test 1: Success case (200 OK)
    test('successfully fetches and populates Notification_Info_List', () async {
      // Create a mock HTTP client
      final client = MockClient();

      // Mock the HTTP POST request
      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'Username': username}),
      )).thenAnswer(
            (_) async => http.Response(
          jsonEncode([
            {
              'notId': 1,
              'notType': 'info',
              'notReceiverUsername': 'test_user',
              'notMessage': 'Test message',
              'notDate': '2025-04-26T12:00:00Z'
            },
            {
              'notId': 2,
              'notType': 'alert',
              'notReceiverUsername': 'test_user',
              'notMessage': 'Old message',
              'notDate': '2025-04-24T12:00:00Z'
            },
          ]),
          200,
        ),
      );

      // Call Get_Notification_Info with the mocked client
      await Get_Notification_Info(
        client: client,
        jwttoken: mockJwtToken,
        username: username,
      );

      // Verify the results
      expect(Notification_Info_List.length, 2);
      expect(Notification_Info_List[0].notId, 1);
      expect(Notification_Info_List[0].notDate, '2025-04-26T12:00:00Z');
      expect(Notification_Info_List[1].notId, 2);
      expect(Notification_Info_List[1].notDate, '2025-04-24T12:00:00Z');
      expect(Filter_New_Notifications.length, 1);
      expect(Filter_New_Notifications[0].notId, 1);
      expect(Filter_New_Notifications[0].notDate, '2025-04-26T12:00:00Z');
    });

    // Test 2: Failure case (404 Not Found)
    test('clears Notification_Info_List on non-200 status code', () async {
      // Create a mock HTTP client
      final client = MockClient();

      // Mock the HTTP POST request to return 404
      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'Username': username}),
      )).thenAnswer(
            (_) async => http.Response('Not Found', 404),
      );

      // Populate lists with dummy data to test clearing
      Notification_Info_List.add(NotificationsModel(notId: 1));
      Filter_New_Notifications.add(NotificationsModel(notId: 2));

      // Call Get_Notification_Info
      await Get_Notification_Info(
        client: client,
        jwttoken: mockJwtToken,
        username: username,
      );

      // Verify the results
      expect(Notification_Info_List.isEmpty, true);
      expect(Filter_New_Notifications.isEmpty, true);
    });

    // Test 3: Failure case (network exception)
    test('clears Notification_Info_List on exception', () async {
      // Create a mock HTTP client
      final client = MockClient();

      // Mock the HTTP POST request to throw an exception
      when(client.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $mockJwtToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'Username': username}),
      )).thenThrow(Exception('Network error'));

      // Populate lists with dummy data to test clearing
      Notification_Info_List.add(NotificationsModel(notId: 1));
      Filter_New_Notifications.add(NotificationsModel(notId: 2));

      // Call Get_Notification_Info
      await Get_Notification_Info(
        client: client,
        jwttoken: mockJwtToken,
        username: username,
      );

      // Verify the results
      expect(Notification_Info_List.isEmpty, true);
      expect(Filter_New_Notifications.isEmpty, true);
    });
  });
}