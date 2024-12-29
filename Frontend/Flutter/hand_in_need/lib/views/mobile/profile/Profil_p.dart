
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hand_in_need/views/mobile/profile/change_phone_number.dart';
import 'package:hand_in_need/views/mobile/profile/update_address.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/mobile/UserInfoModel.dart';

import '../../constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circularprogressind.dart';
import '../commonwidget/getx_cont_pick_single_photo.dart';
import '../commonwidget/toast.dart';
import '../home/home_p.dart';
import 'package:http/http.dart' as http;

import 'UpdateEmail_p.dart';
import 'UpdatePassword_p.dart';
import 'getx_cont_profile/getx_cont_isloading_chnage_photo.dart';
import 'getx_cont_profile/getx_cont_isloading_logout_button.dart';

class Profilescreen extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Profilescreen({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {

  final change_photo_cont_getx=Get.put(pick_single_photo_getx());
  final change_photo_cont_isloading=Get.put(Isloading_change_photo_profile_screen());
  final logout_button_cont_isloading=Get.put(Isloading_logout_button_profile_screen());


  @override
  void initState(){
    super.initState();
    checkJWTExpiation();
  }

  Future<void> checkJWTExpiation()async
  {
    try {
      int result = await checkJwtToken_initistate_user(
          widget.username, widget.usertype, widget.jwttoken);
      print(widget.jwttoken);
      if (result == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) {
          return Home();
        },)
        );
        Toastget().Toastmsg("Session End.Relogin please.");
      }
    }
    catch(obj)
    {
      print("Exception caught while naviagating home page of  from initstate of home_login page.");
      print(obj.toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return Home();
      },)
      );
      Toastget().Toastmsg("Error.Relogin please.");
    }

  }

  List<UserInfoModel> userinfomodel_list=[];

  Future<void> getUserInfo(String username, String jwttoken) async {
    try {
      // API endpoint
      var url = "http://10.0.2.2:5074/api/Profile/getuserinfo";
      Map<String, dynamic> usernameDict =
      {
        "Username": username,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwttoken'
        },
        body: json.encode(usernameDict),
      );

      // Handling the response
      if (response.statusCode == 200)
      {
        print("User authenticated");
        // Decode the response as a single user object (Map<String, dynamic>)
        Map<dynamic, dynamic> responseData = await jsonDecode(response.body);
        userinfomodel_list.clear();
        userinfomodel_list.add(UserInfoModel.fromJson(responseData));
        print("insert in model list success");
        return;
      }
      else
      {
        userinfomodel_list.clear();
        print("Data insert in userinfo table failed.");
        return;
      }
    } catch (obj) {
      userinfomodel_list.clear();
      print("Exception caught while fetching user data for profile screen");
      print(obj.toString());
      return;
    }
  }

  Future<bool> UpdatePhoto({required String username,required String jwttoken,required photo_bytes}) async {

    try
    {
      final String base64Image = base64Encode(photo_bytes as List<int>);
      // API endpoint
      var url = "http://10.0.2.2:5074/api/Profile/updatephoto";
      Map<String, dynamic> new_photo =
      {
        "Username": username,
        "Photo":base64Image,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwttoken'
        },
        body: json.encode(new_photo),
      );

      // Handling the response
      if (response.statusCode == 200) {
        print("User authenticated");
        return true;
      }
      else
      {
        print("error");
        return false;
      }
    } catch (obj) {
      print("Exception caught while fetching user data for profile screen");
      print(obj.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    var shortestval=MediaQuery.of(context).size.shortestSide;
    return Scaffold (
      appBar: AppBar(
        title: Text("profilescreen"),
      ),
      body:
      Container (
        width:widthval,
        height: heightval,
        color: Colors.green,
        child:
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [

              (shortestval*0.01).heightBox,

              FutureBuilder(
                future: getUserInfo(widget.username, widget.jwttoken),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // While waiting for response
                  }
                  else if (snapshot.hasError)
                  {
                    return Text('Error: ${snapshot.error}'); // If there's an error
                  }
                  else if (snapshot.connectionState == ConnectionState.done)
                  {
                    if (userinfomodel_list.isNotEmpty || userinfomodel_list.length>=1)
                    {
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: userinfomodel_list[0].photo == null ||
                              userinfomodel_list[0].photo!.isEmpty
                              ? Image.asset('assets/default_photo.jpg') // Default image if no photo
                              : Image.memory(
                            base64Decode(userinfomodel_list[0].photo!),
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    }
                    else
                    {
                      return Text('No image data available'); // If no user data
                    }
                  }
                  else
                  {
                    return Text('Error.Relogin.'); // Default loading state
                  }
                },

              ),

              (shortestval*0.01).heightBox,

          Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(shortestval*0.03), // Border radius here
                      ),
                    ),
                    onPressed: ()async
                    {
                      try {
                        change_photo_cont_isloading.change_isloadingval(true);
                        bool result1 = await change_photo_cont_getx.pickImage();
                        print(result1);
                        if (result1 == true) {
                          print(change_photo_cont_getx.imagePath.toString());
                          print(change_photo_cont_getx.imageBytes.value);
                          bool result2 = await UpdatePhoto(username: widget
                              .username,
                              jwttoken: widget.jwttoken,
                              photo_bytes: change_photo_cont_getx.imageBytes
                                  .value);
                          print(result2);
                          if (result2 == true)
                          {
                            Toastget().Toastmsg("Update success");
                            change_photo_cont_getx.imageBytes.value = null;
                            change_photo_cont_getx.imagePath.value = "";
                            change_photo_cont_isloading.change_isloadingval(false);
                            setState(() {

                            });
                            return;
                          }
                          else {
                            change_photo_cont_isloading.change_isloadingval(false);
                            Toastget().Toastmsg("Update failed");
                            return;
                          }
                        }
                        else {
                          change_photo_cont_isloading.change_isloadingval(false);
                          Toastget().Toastmsg("No image select.Try again.");
                          return;
                        }
                      }catch(obj){
                        change_photo_cont_isloading.change_isloadingval(false);
                        print("Exception caught in change photo method.");
                        Toastget().Toastmsg("Change photo fail.Try again.");
                        return;
                      }


                    },
                    child: change_photo_cont_isloading.isloading.value==true?Circularproindicator(context):Text("Change photo",style:
                    TextStyle(
                        fontFamily: semibold,
                        color: Colors.black,
                        fontSize: shortestval*0.05
                    ),
                    ),
                  ),
                ),
              (shortestval*0.03).heightBox,
              FutureBuilder(
                            future: getUserInfo(widget.username, widget.jwttoken),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text('UserName:');
                              }
                              else if (snapshot.hasError)
                              {
                                return Text('UserName:');
                              }
                              else if (snapshot.connectionState == ConnectionState.done)
                              {
                                if (userinfomodel_list.isNotEmpty || userinfomodel_list.length>=1)
                                {
                                 return Container (
                                   child: Column(
                                     children: [
                                       Text("UserName:${userinfomodel_list[0].username}",style: TextStyle(
                                           fontFamily: semibold,
                                           color: Colors.white,
                                           fontSize: shortestval*0.05
                                       ),
                                       ),
                                     ],
                                   ),
                                 );
                                }
                                else
                                {
                                  return Text('UserName:');
                                }
                              }
                              else
                              {
                                return Text('UserName:');
                              }
                            },
                        ),



              (shortestval*0.03).heightBox,

              Container (
                color: Colors.green,
                child: Column(
                  children: [

                    Container (
                        width: widthval,
                        height: heightval*0.06,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          border: Border.all(
                            color: Colors.blue,
                            width: shortestval*0.0080,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(shortestval*0.03),
                        ),
                        child:
                        Row(
                          children: [

                            Expanded(
                              child: Text("Change password",style:
                              TextStyle(
                                  fontFamily: semibold,
                                  color: Colors.black,
                                  fontSize: shortestval*0.06
                              ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(right: shortestval*0.05),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.change_circle)),
                            ),

                          ],
                        )
                    ).onTap(()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return Updatepassword(jwttoken: widget.jwttoken,username: widget.username,
                            usertype: widget.usertype);
                      },
                      )
                      );

                    }),

                    Container (
                        width: widthval,
                        height: heightval*0.06,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          border: Border.all(
                            color: Colors.blue,
                            width: shortestval*0.0080,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(shortestval*0.03),
                        ),
                        child:
                        Row(
                          children: [

                            Expanded(
                              child: Text("Change Email",style:
                              TextStyle(
                                  fontFamily: semibold,
                                  color: Colors.black,
                                  fontSize: shortestval*0.06
                              ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(right: shortestval*0.05),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.change_circle)),
                            ),

                          ],
                        )
                    ).onTap(()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return Updateemail(jwttoken: widget.jwttoken,usertype: widget.usertype,username: widget.username,);
                      },
                      )
                      );

                    }),


                    Container (
                        width: widthval,
                        height: heightval*0.06,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          border: Border.all(
                            color: Colors.blue,
                            width: shortestval*0.0080,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(shortestval*0.03),
                        ),
                        child:
                        Row(
                          children: [

                            Expanded(
                              child: Text("Change Phone Number",style:
                              TextStyle(
                                  fontFamily: semibold,
                                  color: Colors.black,
                                  fontSize: shortestval*0.06
                              ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(right: shortestval*0.05),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.change_circle)),
                            ),

                          ],
                        )
                    ).onTap(()
                    {

                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return ChangePhoneNumber(jwttoken: widget.jwttoken,usertype: widget.usertype,username: widget.username,);
                      },
                      )
                      );
                    }),

                    Container (
                        width: widthval,
                        height: heightval*0.06,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          border: Border.all(
                            color: Colors.blue,
                            width: shortestval*0.0080,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(shortestval*0.03),
                        ),
                        child:
                        Row(
                          children: [

                            Expanded(
                              child: Text("Change Address",style:
                              TextStyle(
                                  fontFamily: semibold,
                                  color: Colors.black,
                                  fontSize: shortestval*0.06
                              ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(right: shortestval*0.05),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.change_circle)),
                            ),

                          ],
                        )
                    ).onTap(()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return UpdateAddress(jwttoken: widget.jwttoken,usertype: widget.usertype,username: widget.username,);
                      },
                      )
                      );
                    }),
                  ],
                ),
              ),

              (shortestval*0.03).heightBox,

              Align(
                alignment: Alignment.center,
                child: Container(
                  child: ElevatedButton(
                    onPressed:
                        () async
                    {
                      try{
                        logout_button_cont_isloading.change_isloadingval(true);
                        await clearUserData();
                        logout_button_cont_isloading.change_isloadingval(false);
                        Toastget().Toastmsg("Logout Success");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                        {
                          return Home();
                        },
                        )
                        );
                      }catch(obj)
                      {
                        logout_button_cont_isloading.change_isloadingval(false);
                        print("Logout fail.Exception occur.");
                        print("${obj.toString()}");
                        Toastget().Toastmsg("Logout fail.Try again.");
                      }
                    }
                    ,
                    child:logout_button_cont_isloading.isloading.value==true?Circularproindicator(context):Text("Log Out",style:
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
              ),


            ],
          ),
        ),
      ),
    );
  }
}