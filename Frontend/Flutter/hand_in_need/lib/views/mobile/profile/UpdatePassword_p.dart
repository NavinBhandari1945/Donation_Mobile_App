import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:hand_in_need/views/mobile/home/home_p.dart';
import 'package:http/http.dart' as http;

import '../commonwidget/CommonMethod.dart';

class Updatepassword extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Updatepassword({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<Updatepassword> createState() => _UpdatepasswordState();
}

class _UpdatepasswordState extends State<Updatepassword> {
  final old_password_cont=TextEditingController();
  final new_password_cont=TextEditingController();
  final isloading_update_password_cont=Get.put(Isloading());

  Future<int> UpdatePhoto({required String username,required String jwttoken,required String old_password,required String new_password}) async
  {
    try
    {
      // API endpoint
      var url = "http://10.0.2.2:5074/api/Profile/updatepassword";
      Map<String, dynamic> update_data =
      {
        "Username": username,
        "OldPassword":old_password,
        "NewPassword":new_password,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwttoken'
        },
        body: json.encode(update_data),
      );
      // Handling the response
      if (response.statusCode == 200) {
        print("User authenticated");
        return 0;
      }
      else if(response.statusCode==502)
        {
          return 1;  //old password mistake
        }
      else if(response.statusCode==503)
      {
        return 5;  //user doesn't exist.
      }
      else if(response.statusCode==501)
      {
        return 3;  //exception caught in backend
      }
      else if(response.statusCode==500)
      {
        return 6;  // details validation fail
      }
      else if(response.statusCode==400)
      {
        return 9;  // details validation fail
      }
      else if(response.statusCode==401)
      {
        return 10;  // jwt error
      }
      else if(response.statusCode==403)
      {
        return 11;  // jwt error
      }
      else
      {
        print("Error.other status code.");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while fetching user data for profile screen");
      print(obj.toString());
      return 2;
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
      CommonTextField_obs_false_p("Enter old password", "xxxxx", false, old_password_cont, context),
      CommonTextField_obs_false_p("Enter new password", "xxxxx", false, new_password_cont, context),
      Center(
        child: CommonButton_loading(label: "Update", onPressed:()async
        {
          try {
            isloading_update_password_cont.isloading.value=true;
            if (widget.usertype == "user")
            {
              if (old_password_cont.text.toString() ==
                  new_password_cont.text.toString())
              {
                isloading_update_password_cont.isloading.value=false;
                Toastget().Toastmsg("Old password and New password same.");
                return;
              }
              var update_process_result = await UpdatePhoto(
                  username: widget.username,
                  jwttoken: widget.jwttoken,
                  new_password: new_password_cont.text.toString(),
                  old_password: old_password_cont.text.toString());
              print("update result");
              print(update_process_result);

              if (update_process_result == 0)
              {
                isloading_update_password_cont.isloading.value=false;
                Toastget().Toastmsg("Update password success.");
              }
              else if (update_process_result == 1)
              {
                isloading_update_password_cont.isloading.value=false;
                Toastget().Toastmsg("Old password mistake.Update fail.");
              }
              else if (update_process_result == 2)
              {
                isloading_update_password_cont.isloading.value=false;
                // Toastget().Toastmsg("exception in http method.");
                Toastget().Toastmsg("Update password Fail.Try again");
              }
              else if (update_process_result == 3)
              {
                isloading_update_password_cont.isloading.value=false;
                // Toastget().Toastmsg("exception in backend.Update fail.");
                Toastget().Toastmsg("Update password Fail.Try again");
              }
              else if (update_process_result == 4)
              {
                //other http satus code
                await clearUserData();
                isloading_update_password_cont.isloading.value=false;
                Toastget().Toastmsg("Update password faiL.Relogin and try again.");
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) {
                  return Home();
                },
                )
                );
                return;
              }
              else if (update_process_result == 5)
              {
                isloading_update_password_cont.isloading.value=false;
                // Toastget().Toastmsg("username fail");
                Toastget().Toastmsg("Update password Fail.Try again");
              }
              else if (update_process_result == 6)
              {
                isloading_update_password_cont.isloading.value=false;
                Toastget().Toastmsg("Provide details format correct.Password must have 6 letter with 1 number and symbol.");
              }
              else if (update_process_result == 9)
              {
                isloading_update_password_cont.isloading.value=false;
                Toastget().Toastmsg("Provide details format correct.Password must have 6 letter with 1 number and symbol.");
              }
              else if (update_process_result == 10 || update_process_result==11)
              {
                //jwt error
                await clearUserData();
                isloading_update_password_cont.isloading.value=false;
                Toastget().Toastmsg("Update password Fail.Relogin and try again");
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) {
                  return Home();
                },
                )
                );
              }
              else
              {
                await clearUserData();
                isloading_update_password_cont.isloading.value=false;
                Toastget().Toastmsg("Update password Fail.Relogin and try again");
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) {
                  return Home();
                },
                )
                );
              }
            }
            else
            {
              await clearUserData();
              isloading_update_password_cont.isloading.value=false;
              Toastget().Toastmsg("Update password Fail.Relogin and try again");
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) {
                return Home();
              },
              )
              );
            }
          }catch(obj)
          {
            isloading_update_password_cont.isloading.value=false;
            Toastget().Toastmsg("Update faiL.Try again.");
          }
        },
          color:Colors.red,
          textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
          padding: const EdgeInsets.all(12),
          borderRadius:25.0,
          width: shortestval*0.25,
          height: shortestval*0.15,
          isLoading: isloading_update_password_cont.isloading.value,
        ),
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
