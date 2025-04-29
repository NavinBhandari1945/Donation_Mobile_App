// lib/services/api_service.dart
import 'dart:convert';
import 'package:hand_in_need/models/mobile/CampaignInfoModel.dart';
import 'package:http/http.dart' as http;
import 'package:hand_in_need/views/mobile/constant/constant.dart';

Future<void> GetCampaignInfoTest({
  required String jwttoken,
  required List<CampaignInfoModel> campaignInfoList,
  required http.Client client,
}) async {
  try {
    print("GetCampaignInfoTest method called");
    const String url = Backend_Server_Url + "api/Campaigns/getcampaigninfo";
    final headers = {
      'Authorization': 'Bearer $jwttoken',
      'Content-Type': 'application/json',
    };

    print('Sending GET request to $url');
    print('Request headers: $headers');

    final response = await client.get(Uri.parse(url), headers: headers);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body);
      campaignInfoList.clear();
      campaignInfoList.addAll(responseData.map((data) => CampaignInfoModel.fromJson(data)).toList());
      print("Campaign list count: ${campaignInfoList.length}");
      return;
    } else {
      campaignInfoList.clear();
      print("Failed to fetch campaign info. Status code: ${response.statusCode}");
      return;
    }
  } catch (e) {
    campaignInfoList.clear();
    print("Exception caught in GetCampaignInfoTest method.");
    print("Exception: $e");
    return;
  }
}