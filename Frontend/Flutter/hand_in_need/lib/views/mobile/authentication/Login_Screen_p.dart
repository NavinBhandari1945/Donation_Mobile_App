import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hand_in_need/views/mobile/commonwidget/CommonTextfield_obs_val_true_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';

import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_true_l.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:hand_in_need/views/mobile/home/admin_home_p.dart';
import 'package:hand_in_need/views/mobile/home/index_login_home.dart';
import 'package:hive/hive.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/commontextfield_obs_false_l.dart';
import '../commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import 'package:http/http.dart' as http;
import '../home/home_p.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var username_cont=TextEditingController();
  var passwoord_cont=TextEditingController();
  var isloading_getx_cont=Get.put(Isloading());

  Future<bool> login_user({
    required String username,
    required String password,
  }
      ) async {

    // Prepare the data dictionary to send to the server
    final Map<String, dynamic> userData = {
      "Username": username,
      "Password": password,
    };


    // API endpoint
    // const String url = "http://10.0.2.2:5074/api/Authentication/login";
    const String url = "http://192.168.1.65:5074/api/Authentication/login";

    // Send the POST request
    final response =await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(userData),
    );

    // Handling the response
    if (response.statusCode == 200)
    {
      print("User authenticated");
      final Map<String,dynamic> responseData = jsonDecode(response.body);
      print('user data while logging');
      print(responseData);
      await handleResponse(responseData);
      return true;
    }
    else
    {
      return false;
    }

  }

  @override
  void dispose() {
    username_cont.dispose();
    passwoord_cont.dispose();
    super.dispose();
  }

  @override
  void initState() {
    isloading_getx_cont.isloading.value=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
        title: Text("Login Screen"),
        backgroundColor: Colors.green,
        ),
      body:OrientationBuilder(builder: (context, orientation) {
        if(orientation==Orientation.portrait)
        {
          return

            Container(
                width:widthval,
                height: heightval,
                color: Colors.white10,
                child:
                Center(
                  child: Container(
                    width: widthval,
                    height: heightval*0.45,
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

                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: CommonTextField_obs_false_p("Enter Username", "Xxx12@", false, username_cont, context),
                          ),
                          CommonTextField_obs_val_true_p("Enter Password", "Xdghf@132", passwoord_cont, context),
                          SizedBox(height: shortestval*0.05),
                          Center(
                            child: CommonButton_loading(label: "LogIn",
                              onPressed: () async
                              {
                                try
                                {
                                  isloading_getx_cont.change_isloadingval(true);
                                  var login_rsult=await login_user(username: username_cont.text.toString(), password: passwoord_cont.text.toString());
                                  if(login_rsult==true)
                                  {
                                    final box =await Hive.openBox('userData');
                                    String? jwtToken =await box.get('jwt_token');
                                    Map<String, String?> userData=await getUserCredentials();
                                    // If no token exists, navigate to Home screen
                                    if (jwtToken == null && userData == null)
                                    {
                                      isloading_getx_cont.change_isloadingval(false);
                                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
                                      {
                                        return  Home();
                                      },)
                                      );
                                      Toastget().Toastmsg("Login Fail.Try again.");
                                    }
                                    else
                                    {

                                      if(userData["usertype"]=="user")
                                      {
                                        isloading_getx_cont.change_isloadingval(false);
                                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
                                        {
                                          isloading_getx_cont.change_isloadingval(false);
                                          return HomeScreen_2(username: userData["username"]!, usertype: userData["usertype"]!, jwttoken: jwtToken!);
                                        },)
                                        );
                                      }

                                      if(userData["usertype"]=="admin")
                                      {
                                        isloading_getx_cont.change_isloadingval(false);
                                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
                                        {
                                          isloading_getx_cont.change_isloadingval(false);
                                          print("Navigating to admin after login");
                                          print("test1");
                                          return AdminHome(jwttoken: jwtToken!,usertype:userData["usertype"]!,username:userData["username"]!,);
                                        },)
                                        );
                                      }

                                    }

                                  }
                                  else
                                    {
                                      isloading_getx_cont.change_isloadingval(false);
                                      Toastget().Toastmsg("Provide correct detaiils.");
                                    }
                                }catch(obj)
                                {
                                  print("${obj.toString()}");
                                  isloading_getx_cont.change_isloadingval(false);
                                  Toastget().Toastmsg("Error.Try again.1");
                                }

                              },
                              color:Colors.red,
                              textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
                              padding: const EdgeInsets.all(12),
                              borderRadius:25.0,
                              width: shortestval*0.25,
                              height: shortestval*0.15,
                              isLoading: isloading_getx_cont.isloading.value,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                )
            );
        }
        else if(orientation==Orientation.landscape)
        {
          return
            Container(
                width:widthval,
                height: heightval,
                color: Colors.white10,
                child:
                Center(
                  child: Container(
                    width: widthval,
                    height: heightval*0.60,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(shortestval*0.04)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child:
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [

                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child:
                              CommonTextField_obs_false_l("Enter Username", "Xxx12@", false, username_cont, context),
                            ),
                            CommonTextField_obs_val_true_l("Enter Password", "Xdghf@132", passwoord_cont, context),
                            SizedBox(height: shortestval*0.05),

                            Obx(
                              ()=>Center(
                                child: CommonButton_loading(label: "LogIn",
                                  onPressed: () async
                                  {
                                    try
                                    {
                                      isloading_getx_cont.change_isloadingval(true);
                                      var login_rsult=await login_user(username: username_cont.text.toString(), password: passwoord_cont.text.toString());
                                      if(login_rsult==true)
                                      {
                                        final box =await Hive.openBox('userData');
                                        String? jwtToken =await box.get('jwt_token');
                                        Map<String, String?> userData=await getUserCredentials();
                                        // If no token exists, navigate to Home screen
                                        if (jwtToken == null && userData.isNull)
                                        {
                                          isloading_getx_cont.change_isloadingval(false);
                                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
                                          {
                                            return  Home();
                                          },)
                                          );
                                          Toastget().Toastmsg("Login Fail.Try again.");
                                        }
                                        else
                                        {

                                          if(userData["usertype"]=="user")
                                          {
                                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
                                            {
                                              isloading_getx_cont.change_isloadingval(false);
                                              return HomeScreen_2(username: userData["username"]!, usertype: userData["usertype"]!, jwttoken: jwtToken!);
                                            },)
                                            );
                                          }

                                          if(userData["usertype"]=="admin")
                                          {
                                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
                                            {
                                              isloading_getx_cont.change_isloadingval(false);
                                              return AdminHome(jwttoken: jwtToken!,username: userData["username"]!, usertype: userData["usertype"]!);
                                            },)
                                            );
                                          }

                                        }

                                      }
                                      else
                                      {
                                        isloading_getx_cont.change_isloadingval(false);
                                        Toastget().Toastmsg("Provide correct detaiils.");
                                      }
                                    }catch(obj)
                                    {
                                      print("${obj.toString()}");
                                      isloading_getx_cont.change_isloadingval(false);
                                      Toastget().Toastmsg("Error.Try again.1");
                                    }

                                  },
                                  color:Colors.red,
                                  textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
                                  padding: const EdgeInsets.all(12),
                                  borderRadius:25.0,
                                  width: shortestval*0.25,
                                  height: shortestval*0.15,
                                  isLoading: isloading_getx_cont.isloading.value,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                )
            );
        }
        else{
          return Circular_pro_indicator_Yellow(context);
        }
      },
      ),
    );
  }
}
