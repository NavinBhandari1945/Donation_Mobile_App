import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circularprogressind.dart';
import '../commonwidget/toast.dart';
import 'home_p.dart';
import 'getx_cont/isloading_logout_button_admin.dart';

class AdminHome extends StatefulWidget {
  final String jwttoken;
  const AdminHome({super.key,required this.jwttoken});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final LogoutButton_Loading_Cont=Get.put(Isloading_logout_button_admin_screen());
  @override
  Widget build(BuildContext context) {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Home"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child:
        ElevatedButton (
          onPressed:
              () async
          {
            try{
              LogoutButton_Loading_Cont.change_isloadingval(true);
              await clearUserData();
              LogoutButton_Loading_Cont.change_isloadingval(false);
              await deleteTempDirectoryPostVideo();
              await deleteTempDirectoryCampaignVideo();
              print("Deleteing temporary directory success.");
              Toastget().Toastmsg("Logout Success");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
              {
                return Home();
              },
              )
              );
            }catch(obj)
            {
              LogoutButton_Loading_Cont.change_isloadingval(false);
              print("Logout fail.Exception occur.");
              print("${obj.toString()}");
              Toastget().Toastmsg("Logout fail.Try again.");
            }
          }
          ,
          child:LogoutButton_Loading_Cont.isloading.value==true?Circularproindicator(context):Text("Log Out",style:
          TextStyle(
              fontFamily: semibold,
              color: Colors.blue,
              fontSize: shortestval*0.05
          ),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(shortestval*0.03),
              )
          ),
        ),

      ),
    );
  }
}
