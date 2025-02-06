import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/common_button_loading.dart';
import '../commonwidget/commontextfield_obs_false_p.dart';
import '../commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import '../commonwidget/toast.dart';
import '../home/home_p.dart';

class UpdateAddress extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;

  const UpdateAddress({super.key,required this.username,required this.usertype,
    required this.jwttoken});


  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  final password_cont=TextEditingController();
  final new_address_cont=TextEditingController();
  final isloading_cont=Get.put(Isloading());

  Future<int> UpdateAddress({required String username,required String jwttoken,required String password,required String new_address}) async
  {
    try
    {
      // API endpoint
      // const String url = "http://10.0.2.2:5074/api/Profile/updateaddress";
      const String url = "http://192.168.1.65:5074/api/Profile/updateaddress";
      Map<String, dynamic> update_data =
      {
        "Username": username,
        "Password":password,
        "NewAddress":new_address,
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
        //success
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
        return 6;  // validation error in backend
      }
      else if(response.statusCode==504)
      {
        return 7;  // old address and new address same
      }
      else if(response.statusCode==400)
      {
        return 9;  //details validation error
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
        title: Text("Update Address"),
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
                    CommonTextField_obs_false_p("Enter your password", "xxxxx", false, password_cont, context),
                    CommonTextField_obs_false_p("Enter new address.", "xxxxx", false, new_address_cont, context),
                    Center(
                      child: CommonButton_loading(label: "Update", onPressed:()async
                      {
                        try {
                          isloading_cont.isloading.value=true;
                          if (widget.usertype == "user") {
                            var update_process_result = await UpdateAddress(username:widget.username,
                                jwttoken: widget.jwttoken,password:password_cont.text.toString(),new_address: new_address_cont.text.toString() );
                            print("update result");
                            print(update_process_result);
                            if (update_process_result == 0) {
                              //succes update address
                              isloading_cont.isloading.value=false;
                              Toastget().Toastmsg("Update address success.");
                              return;
                            }
                            else if (update_process_result == 1)
                            {
                              //old password mistake
                              isloading_cont.isloading.value=false;
                              Toastget().Toastmsg("Old password mistake.Update fail.");
                              return;
                            }
                            else if (update_process_result == 2) {
                              isloading_cont.isloading.value=false;
                              // Toastget().Toastmsg("exception in http method.");
                              Toastget().Toastmsg("Update address fail.Try again.Recheck details.");
                              return;
                            }
                            else if (update_process_result == 3)
                            {
                              isloading_cont.isloading.value=false;
                              // Toastget().Toastmsg("exception in backend.Update fail.");
                              Toastget().Toastmsg("Update address fail.Try again.Recheck details.");
                              return;
                            }
                            else if (update_process_result == 4)
                            {
                              //other http satus code
                              await clearUserData();
                              isloading_cont.isloading.value=false;
                              Toastget().Toastmsg("Update address faiL.Relogin and try again.");
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
                              //username don't match in backend.user doesn't exist.
                              await clearUserData();
                              isloading_cont.isloading.value=false;
                              Toastget().Toastmsg("Update address faiL.Relogin and try again.");
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) {
                                return Home();
                              },
                              )
                              );
                              return;
                            }
                            else if (update_process_result == 6)
                            {
                              //validation error in abckend
                              isloading_cont.isloading.value=false;
                              Toastget().Toastmsg("Provide details format correct.Password must have 6 letter with 1 number and symbol.");
                              return;
                            }
                            else if (update_process_result == 7)
                            {
                              //old address and new address same
                              isloading_cont.isloading.value=false;
                              Toastget().Toastmsg("Provide different address then before and try again..");
                              return;
                            }
                            else if (update_process_result == 9)
                            {
                              //details validation error
                              isloading_cont.isloading.value=false;
                              Toastget().Toastmsg("Provide details format correct.Password must have 6 letter with 1 number and symbol.");
                              return;
                            }
                            else if (update_process_result == 10 || update_process_result==11)
                            {
                              //jwt error
                              await clearUserData();
                              isloading_cont.isloading.value=false;
                              Toastget().Toastmsg("Update address Fail.Relogin and try again");
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) {
                                return Home();
                              },
                              )
                              );
                              return;
                            }
                            else
                            {
                              //other http sattus code
                              await clearUserData();
                              isloading_cont.isloading.value=false;
                              Toastget().Toastmsg("Update address fail.Relogin and try again");
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) {
                                return Home();
                              },
                              )
                              );
                            }
                          } else {
                            //wrong usertype
                            await clearUserData();
                            isloading_cont.isloading.value=false;
                            print("mismatch user.usertype mistake.");
                            Toastget().Toastmsg("Update address faiL.Relogin and try again.");
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) {
                              return Home();
                            },
                            )
                            );
                          }
                        }catch(obj)
                        {
                          isloading_cont.isloading.value=false;
                          Toastget().Toastmsg("Update faiL.Try again.");
                        }

                      },
                        color:Colors.red,
                        textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
                        padding: const EdgeInsets.all(12),
                        borderRadius:25.0,
                        width: shortestval*0.25,
                        height: shortestval*0.15,
                        isLoading: isloading_cont.isloading.value,
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
