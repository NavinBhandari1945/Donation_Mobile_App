import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hand_in_need/views/mobile/Admin_Operation/admin_home_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/CommonMethod.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../commonwidget/toast_long_period.dart';
import '../home/home_p.dart';


class admin_Update_password_P extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const admin_Update_password_P({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<admin_Update_password_P> createState() => _admin_Update_password_PState();
}

class _admin_Update_password_PState extends State<admin_Update_password_P> {
  final Username_Cont=TextEditingController();
  final new_password_cont=TextEditingController();
  final isloading_update_password_cont=Get.put(Isloading());

  @override
  void initState()
  {
    super.initState();
    checkJWTExpiation();
  }

  Future<void> checkJWTExpiation()async {
    try {
      print("check jwt called in admin home screen.");
      int result = await checkJwtToken_initistate_admin(
          widget.username, widget.usertype, widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        print("Deleteing temporary directory success.");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context)
        {
          return Home();
        },)
        );
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    }
    catch(obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleteing temporary directory success.");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return Home();
      },)
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  Future<int> Update_Password({required String username,required String jwttoken,required String new_password}) async
  {
    try
    {
      // API endpoint
      // const String url = "http://10.0.2.2:5074/api/Admin_Task_/update_user_password";
      const String url = "http://192.168.1.65:5074/api/Admin_Task_/update_user_password";
      Map<String, dynamic> update_data =
      {
        "Username": username,
        "Password":new_password,
      };

      // Send the POST request
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwttoken'
        },
        body: json.encode(update_data),
      );
      // Handling the response
      if (response.statusCode == 200) {
        print("Update success.");
        return 1;
      }
      else if(response.statusCode==702)
        {
          print("User doesn't exist.");
          return 2;
        }
      else if(response.statusCode==701)
      {
        print("Details is in incorrect format");
        return 5;  //user doesn't exist.
      }
      else if(response.statusCode==700)
      {
        print("Exception caught in backend.");
        print("Status code = ${response.statusCode}");
        print("Exception message = ${response.body.toString()}");
        return 3;  //exception caught in backend
      }
      else
      {
        print("Error.other status code.");
        print("Status code = ${response.statusCode}");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while upadting user password by admin in http method");
      print(obj.toString());
      return 0;
    }
  }


  @override
  Widget build(BuildContext context) {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    return Scaffold
      (
          appBar: AppBar(
          title: Text("Update Password"),
    ),
    body:

    Container(
    width:widthval,
    height: heightval,
    color: Colors.white10,
    child:
    Center(
    child: Container(
    width: widthval,
    height: heightval*0.41,
    decoration: BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.all(Radius.circular(shortestval*0.04)),
    ),
    child: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    physics: BouncingScrollPhysics(),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children:
    [
      CommonTextField_obs_false_p("Enter user username", "", false, Username_Cont, context),
      CommonTextField_obs_false_p("Enter new password", "", false, new_password_cont, context),
      Center(
        child: Commonbutton("Update",()async{

          if(Username_Cont.text.toString().isEmptyOrNull || new_password_cont.text.isEmptyOrNull)
            {
              Toastget().Toastmsg("Fill the above field and try again.");
              return;
            }
          int result=await Update_Password(username: Username_Cont.text.toString().trim(), jwttoken:widget.jwttoken, new_password: new_password_cont.text.toString().trim());
          if(result==1)
            {
              Toastget().Toastmsg("Update password success.");

               int result=await Add_Notifications_Message_CM(not_type: "Update password", not_receiver_username: Username_Cont.text.toString().trim(),
                   not_message:"Dear user ${Username_Cont.text.toString().trim()} your password update request is success.Your new password is =${new_password_cont.text.toString().trim()} ",
                   JwtToken:widget.jwttoken);
              if(result==1)
              {
                Toastget().Toastmsg("Update password process finish.");
                return;
              }
              else
              {
                print("Retry adding notifications 2nd time in database table after one time fail IN update password by admin.");
                int result_2=await Add_Notifications_Message_CM(not_type: "Update password", not_receiver_username: Username_Cont.text.toString().trim(),
                    not_message:"Dear user ${Username_Cont.text.toString().trim()} your password update request is success.Your new password is =${new_password_cont.text.toString().trim()} ",
                    JwtToken:widget.jwttoken);

                if(result_2==1)
                {
                  Toastget().Toastmsg("Update password process finish.");
                  return;
                }
                else
                {
                  print("Adding notifications for second time also fail to save notifications data in database in update password by admin. ");
                  Toastget_Long_Period().Toastmsg("Update password success but please conatct user support team with screenshoot of"+" Reminder message "+"as it was failed to send notifications to receiver.");
                  return;
                }
              }
              return;
            }//update password()
          else if(result==2)
          {
            Toastget().Toastmsg("User with provide username doesn't exist.Update fail.");
            return;
          }
          else if(result==2)
          {
            Toastget().Toastmsg("Provide details in correct format.");
            return;
          }
          else{
            Toastget().Toastmsg("Server error.Update fail.Try again.");
            return;
          }
        }, context, Colors.red)
      ),
    ]
    ),
    ),
    ),
    ),
    ),
    );
  }
}
