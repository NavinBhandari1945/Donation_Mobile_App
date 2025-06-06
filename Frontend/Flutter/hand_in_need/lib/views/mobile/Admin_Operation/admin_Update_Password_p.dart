import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/views/mobile/Admin_Operation/admin_home_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/CommonMethod.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../commonwidget/toast_long_period.dart';
import '../constant/constant.dart';
import '../home/authentication_home_p.dart';

class admin_Update_password_P extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const admin_Update_password_P({super.key, required this.username, required this.usertype, required this.jwttoken});

  @override
  State<admin_Update_password_P> createState() => _admin_Update_password_PState();
}

class _admin_Update_password_PState extends State<admin_Update_password_P> with SingleTickerProviderStateMixin {
  final Username_Cont = TextEditingController();
  final new_password_cont = TextEditingController();
  final isloading_update_password_cont = Get.put(Isloading());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    checkJWTExpiation();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    Username_Cont.dispose();
    new_password_cont.dispose();
    super.dispose();
  }

  Future<void> checkJWTExpiation() async {
    try {
      print("check jwt called in admin home screen.");
      int result = await checkJwtToken_initistate_admin(widget.username, widget.usertype, widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        print("Deleteing temporary directory success.");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleteing temporary directory success.");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  Future<int> Update_Password({required String username, required String jwttoken, required String new_password}) async {
    try {
      const String url = Backend_Server_Url + "api/Admin_Task_/update_user_password";
      Map<String, dynamic> update_data = {
        "Username": username,
        "Password": new_password,
      };
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwttoken'
        },
        body: json.encode(update_data),
      );
      if (response.statusCode == 200) {
        print("Update success.");
        return 1;
      } else if (response.statusCode == 702) {
        print("User doesn't exist.");
        return 2;
      } else if (response.statusCode == 701) {
        print("Details is in incorrect format");
        return 5;
      } else if (response.statusCode == 700) {
        print("Exception caught in backend.");
        print("Status code = ${response.statusCode}");
        print("Exception message = ${response.body.toString()}");
        return 3;
      } else {
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
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Password", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: Container(
        width: widthval,
        height: heightval,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: Center(
          child: OrientationBuilder(
            builder: (context, orientation) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: orientation == Orientation.portrait
                    ? _buildPortraitLayout(shortestval, widthval, heightval)
                    : _buildLandscapeLayout(shortestval, widthval, heightval),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(double shortestval, double widthval, double heightval) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: shortestval * 0.05),
            _buildTextField("Enter user username", Username_Cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
            _buildTextField("Enter new password", new_password_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.05),
            _buildUpdateButton(shortestval, widthval),
            SizedBox(height: shortestval * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(double shortestval, double widthval, double heightval) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: shortestval * 0.05),
                  _buildTextField("Enter user username", Username_Cont, shortestval, widthval * 0.65),
                  SizedBox(height: shortestval * 0.03),
                  _buildTextField("Enter new password", new_password_cont, shortestval, widthval * 0.65),
                ],
              ),
            ),
            SizedBox(width: shortestval * 0.03),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUpdateButton(shortestval, widthval * 0.25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, double shortestval, double width) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      padding: EdgeInsets.all(shortestval * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: CommonTextField_obs_false_p(hint, "", false, controller, context),
    );
  }

  Widget _buildUpdateButton(double shortestval, double width) {
    return Commonbutton(
      "Update",
          () async {
        if (Username_Cont.text.toString().isEmptyOrNull || new_password_cont.text.isEmptyOrNull) {
          Toastget().Toastmsg("Fill the above field and try again.");
          return;
        }
        int result = await Update_Password(
          username: Username_Cont.text.toString().trim(),
          jwttoken: widget.jwttoken,
          new_password: new_password_cont.text.toString().trim(),
        );
        if (result == 1) {
          Toastget().Toastmsg("Update password success.");
          int result = await Add_Notifications_Message_CM(
            not_type: "Update password",
            not_receiver_username: Username_Cont.text.toString().trim(),
            not_message:
            "Dear user ${Username_Cont.text.toString().trim()} your password update request is success.Your new password is =${new_password_cont.text.toString().trim()} ",
            JwtToken: widget.jwttoken,
          );
          if (result == 1) {
            Toastget().Toastmsg("Update password process finish.");
            return;
          } else if (result == 3) {
            Toastget().Toastmsg("Provide correct username.Invitation send fail.");
            return;
          } else {
            print("Retry adding notifications 2nd time in database table after one time fail IN update password by admin.");
            int result_2 = await Add_Notifications_Message_CM(
              not_type: "Update password",
              not_receiver_username: Username_Cont.text.toString().trim(),
              not_message:
              "Dear user ${Username_Cont.text.toString().trim()} your password update request is success.Your new password is =${new_password_cont.text.toString().trim()} ",
              JwtToken: widget.jwttoken,
            );
            if (result_2 == 1) {
              Toastget().Toastmsg("Update password process finish.");
              return;
            } else if (result == 3) {
              Toastget().Toastmsg("Provide correct username.Invitation send fail.");
              return;
            } else {
              print("Adding notifications for second time also fail to save notifications data in database in update password by admin.");
              Toastget_Long_Period().Toastmsg(
                  "Update password success but please conatct user support team with screenshoot of" +
                      " Reminder message " +
                      "as it was failed to send notifications to receiver.");
              return;
            }
          }
          return;
        } else if (result == 2) {
          Toastget().Toastmsg("User with provide username doesn't exist.Update fail.");
          return;
        } else if (result == 5) { // Corrected from result == 2 to result == 5 for status 701
          Toastget().Toastmsg("Provide details in correct format.");
          return;
        } else {
          Toastget().Toastmsg("Server error.Update fail.Try again.");
          return;
        }
      },
      context,
      Colors.red,
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hand_in_need/views/mobile/Admin_Operation/admin_home_p.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/CommonMethod.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
// import 'package:http/http.dart' as http;
// import 'package:velocity_x/velocity_x.dart';
//
// import '../commonwidget/toast_long_period.dart';
// import '../constant/constant.dart';
// import '../home/authentication_home_p.dart';
//
//
// class admin_Update_password_P extends StatefulWidget {
//   final String username;
//   final String usertype;
//   final String jwttoken;
//   const admin_Update_password_P({super.key,required this.username,required this.usertype,
//     required this.jwttoken});
//   @override
//   State<admin_Update_password_P> createState() => _admin_Update_password_PState();
// }
//
// class _admin_Update_password_PState extends State<admin_Update_password_P> {
//   final Username_Cont=TextEditingController();
//   final new_password_cont=TextEditingController();
//   final isloading_update_password_cont=Get.put(Isloading());
//
//   @override
//   void initState()
//   {
//     super.initState();
//     checkJWTExpiation();
//   }
//
//   Future<void> checkJWTExpiation()async {
//     try {
//       print("check jwt called in admin home screen.");
//       int result = await checkJwtToken_initistate_admin(
//           widget.username, widget.usertype, widget.jwttoken);
//       if (result == 0) {
//         await clearUserData();
//         await deleteTempDirectoryPostVideo();
//         await deleteTempDirectoryCampaignVideo();
//         print("Deleteing temporary directory success.");
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context)
//         {
//           return AuthenticationHome();
//         },)
//         );
//         Toastget().Toastmsg("Session End. Relogin please.");
//       }
//     }
//     catch(obj) {
//       print("Exception caught while verifying jwt for admin home screen.");
//       print(obj.toString());
//       await clearUserData();
//       await deleteTempDirectoryPostVideo();
//       await deleteTempDirectoryCampaignVideo();
//       print("Deleteing temporary directory success.");
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) {
//         return AuthenticationHome();
//       },)
//       );
//       Toastget().Toastmsg("Error. Relogin please.");
//     }
//   }
//
//   Future<int> Update_Password({required String username,required String jwttoken,required String new_password}) async
//   {
//     try
//     {
//       // API endpoint
//       // const String url = "http://10.0.2.2:5074/api/Admin_Task_/update_user_password";
//       const String url = Backend_Server_Url+"api/Admin_Task_/update_user_password";
//       Map<String, dynamic> update_data =
//       {
//         "Username": username,
//         "Password":new_password,
//       };
//
//       // Send the POST request
//       final response = await http.put(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer $jwttoken'
//         },
//         body: json.encode(update_data),
//       );
//       // Handling the response
//       if (response.statusCode == 200) {
//         print("Update success.");
//         return 1;
//       }
//       else if(response.statusCode==702)
//         {
//           print("User doesn't exist.");
//           return 2;
//         }
//       else if(response.statusCode==701)
//       {
//         print("Details is in incorrect format");
//         return 5;  //user doesn't exist.
//       }
//       else if(response.statusCode==700)
//       {
//         print("Exception caught in backend.");
//         print("Status code = ${response.statusCode}");
//         print("Exception message = ${response.body.toString()}");
//         return 3;  //exception caught in backend
//       }
//       else
//       {
//         print("Error.other status code.");
//         print("Status code = ${response.statusCode}");
//         return 4;
//       }
//     } catch (obj) {
//       print("Exception caught while upadting user password by admin in http method");
//       print(obj.toString());
//       return 0;
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     var shortestval=MediaQuery.of(context).size.shortestSide;
//     var widthval=MediaQuery.of(context).size.width;
//     var heightval=MediaQuery.of(context).size.height;
//     return Scaffold
//       (
//           appBar: AppBar(
//           title: Text("Update Password"),
//     ),
//     body:
//
//     Container(
//     width:widthval,
//     height: heightval,
//     color: Colors.white10,
//     child:
//     Center(
//     child: Container(
//     width: widthval,
//     height: heightval*0.41,
//     decoration: BoxDecoration(
//     color: Colors.grey,
//     borderRadius: BorderRadius.all(Radius.circular(shortestval*0.04)),
//     ),
//     child: SingleChildScrollView(
//     scrollDirection: Axis.vertical,
//     physics: BouncingScrollPhysics(),
//     child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children:
//     [
//       CommonTextField_obs_false_p("Enter user username", "", false, Username_Cont, context),
//       CommonTextField_obs_false_p("Enter new password", "", false, new_password_cont, context),
//       Center(
//         child: Commonbutton("Update",()async{
//
//           if(Username_Cont.text.toString().isEmptyOrNull || new_password_cont.text.isEmptyOrNull)
//             {
//               Toastget().Toastmsg("Fill the above field and try again.");
//               return;
//             }
//           int result=await Update_Password(username: Username_Cont.text.toString().trim(), jwttoken:widget.jwttoken, new_password: new_password_cont.text.toString().trim());
//           if(result==1)
//             {
//               Toastget().Toastmsg("Update password success.");
//
//                int result=await Add_Notifications_Message_CM(not_type: "Update password", not_receiver_username: Username_Cont.text.toString().trim(),
//                    not_message:"Dear user ${Username_Cont.text.toString().trim()} your password update request is success.Your new password is =${new_password_cont.text.toString().trim()} ",
//                    JwtToken:widget.jwttoken);
//               if(result==1)
//               {
//                 Toastget().Toastmsg("Update password process finish.");
//                 return;
//               }
//               else if(result==3){
//                 Toastget().Toastmsg("Provide correct username.Invitation send fail.");
//                 return;
//               }
//               else
//               {
//                 print("Retry adding notifications 2nd time in database table after one time fail IN update password by admin.");
//                 int result_2=await Add_Notifications_Message_CM(not_type: "Update password", not_receiver_username: Username_Cont.text.toString().trim(),
//                     not_message:"Dear user ${Username_Cont.text.toString().trim()} your password update request is success.Your new password is =${new_password_cont.text.toString().trim()} ",
//                     JwtToken:widget.jwttoken);
//
//                 if(result_2==1)
//                 {
//                   Toastget().Toastmsg("Update password process finish.");
//                   return;
//                 }
//                 else if(result==3)
//                 {
//                   Toastget().Toastmsg("Provide correct username.Invitation send fail.");
//                   return;
//                 }
//                 else
//                 {
//                   print("Adding notifications for second time also fail to save notifications data in database in update password by admin. ");
//                   Toastget_Long_Period().Toastmsg("Update password success but please conatct user support team with screenshoot of"+" Reminder message "+"as it was failed to send notifications to receiver.");
//                   return;
//                 }
//               }
//               return;
//             }//update password()
//           else if(result==2)
//           {
//             Toastget().Toastmsg("User with provide username doesn't exist.Update fail.");
//             return;
//           }
//           else if(result==2)
//           {
//             Toastget().Toastmsg("Provide details in correct format.");
//             return;
//           }
//           else{
//             Toastget().Toastmsg("Server error.Update fail.Try again.");
//             return;
//           }
//         }, context, Colors.red)
//       ),
//     ]
//     ),
//     ),
//     ),
//     ),
//     ),
//     );
//   }
// }
