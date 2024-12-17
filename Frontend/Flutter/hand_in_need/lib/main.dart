import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hand_in_need/views/mobile/commonwidget/CommonMethod.dart';
import 'package:hand_in_need/views/mobile/home/admin_home_p.dart';
import 'package:hand_in_need/views/mobile/home/home_p.dart';
import 'package:hand_in_need/views/mobile/home/index_login_home.dart';
import 'package:hand_in_need/views/mobile/home/login_home_p.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Widget initialScreen;
  try
  {
    initialScreen = await checkJwtToken();
  }catch(obj)
  {
    print("exception caught in main.dart while checking jwttoken");
    print(obj.toString());
    await clearUserData();
    initialScreen =Home();
  }
  runApp(MyApp(initialScreen:initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key,required this.initialScreen});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:initialScreen,
    );
  }
}



Future<Widget> checkJwtToken() async
{

    final box = await Hive.openBox('userData');
    String? jwtToken = await box.get('jwt_token');
    if (jwtToken == null || jwtToken.isEmpty)
    {
      print("jwt token empty or null in check jwt for main.dart.");
      await clearUserData();
      return const Home();
    }

    Map<String, String?> userData = await getUserCredentials();

    final Map<String, dynamic> jwtData =
    {
      "JwtBlacklist": jwtToken,
    };

      // verification
    final response2 = await http.get(
        Uri.parse('http://10.0.2.2:5074/api/Authentication/jwtverify'),
        headers: {'Authorization': 'Bearer $jwtToken'},
      );

    if (response2.statusCode == 200)
      {

        if (userData["usertype"] == "admin")
        {

          return AdminHome(jwttoken: jwtData["JwtBlacklist"],);
        }

        if (userData["usertype"] == "user")
        {

          return HomeScreen_2(username: userData["username"]!, usertype: userData["usertype"]!, jwttoken: jwtData["JwtBlacklist"]);
        }

      }
    else
      {
        print("jwt toke unverified.");
        await clearUserData();
        return Home();
      }

    await clearUserData();
    return const Home();

}


