import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hand_in_need/views/mobile/commonwidget/CommonMethod.dart';
import 'package:hand_in_need/views/mobile/home/authentication_home_p.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';


void main() async
{
  //welcome widget
  Widget initialScreen;
  try
  {
    WidgetsFlutterBinding.ensureInitialized();
    //for storing user info authentication and authorization
    await Hive.initFlutter();
    //requesting all permissions
    await requestAllPermissions();
    initialScreen = await Check_Jwt_Token_Start_Screen();
  }catch(obj)
  {
    print("Exception caught in main.dart while checking jwttoken");
    print(obj.toString());
    //deleting temporary directory and user info
    await clearUserData();
    await deleteTempDirectoryPostVideo();
    await deleteTempDirectoryCampaignVideo();
    print("Deleteing temporary directory success.");
    initialScreen =AuthenticationHome();
  }
  runApp(MyApp(initialScreen:initialScreen));
}

class MyApp extends StatelessWidget
{
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




