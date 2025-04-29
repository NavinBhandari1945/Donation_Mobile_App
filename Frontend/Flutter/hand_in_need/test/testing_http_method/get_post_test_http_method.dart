import 'dart:convert';
import 'package:hand_in_need/models/mobile/PostInfoModel.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'package:http/http.dart' as http;


List<PostInfoModel> PostInfoListTest = [];

Future<void> GetPostInfoTest({required http.Client client, required String jwttoken}) async {
  try {
    const String url = Backend_Server_Url + "api/Home/getpostinfo";
    final headers = {
      'Authorization': 'Bearer $jwttoken',
      'Content-Type': 'application/json',
    };

    final response = await client.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> responseData = await jsonDecode(response.body);
      PostInfoListTest.clear();
      PostInfoListTest.addAll(
        responseData.map((data) => PostInfoModel.fromJson(data)).toList(),
      );
      print("post list count value for home screen.");
      print(PostInfoListTest.length);
      return;
    } else {
      PostInfoListTest.clear();
      print("Data insert in post info list for home screen failed in home screen.");
      return;
    }
  } catch (obj) {
    PostInfoListTest.clear();
    print("Exception caught while fetching post info data for home screen in http method");
    print(obj.toString());
    return;
  }
}