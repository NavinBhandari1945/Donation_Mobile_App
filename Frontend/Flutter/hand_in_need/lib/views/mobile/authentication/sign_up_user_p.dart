import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/views/constant/styles.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_l.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';

import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/getx_cont/getx_accept_tems_cond_checkbox.dart';
import '../commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import '../commonwidget/getx_cont_pick_single_photo.dart';
import 'package:http/http.dart' as http;

import '../home/home_p.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var first_name_cont=TextEditingController();
  var last_name_cont=TextEditingController();
  var email_cont=TextEditingController();
  var phone_number_cont=TextEditingController();
  var address_cont=TextEditingController();
  var username_cont=TextEditingController();
  var password_cont=TextEditingController();
  var isloading_cont=Get.put(Isloading());
  var pick_single_photo_cont=Get.put(pick_single_photo_getx());
  var checkbox_a_t_c_cont=Get.put(CheckBox_A_T_C());

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    first_name_cont.dispose();
    last_name_cont.dispose();
    email_cont.dispose();
    address_cont.dispose();
    username_cont.dispose();
    phone_number_cont.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkbox_a_t_c_cont.ValueChange(false);
    pick_single_photo_cont.imagePath.value="";
    pick_single_photo_cont.imageBytes.value=null;
    isloading_cont.change_isloadingval(false);
  }

  Future<bool> SignInUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String username,
    required String password,
    required String address,
    required imageBytes,
    required String type,
  }
      ) async {


    // Base64 Encoding
    final String base64Image = base64Encode(imageBytes as List<int>);


    // Prepare the data dictionary to send to the server
    final Map<String, dynamic> userData = {
      "FirstName": firstName,
      "LastName": lastName,
      "Email": email,
      "PhoneNumber": phoneNumber,
      "Username": username,
      "Password": password,
      "Address": address,
      "Photo": base64Image, // Encoded image as a base64 string
      "Type": type,
    };


    // API endpoint
    // const String url = "http://10.0.2.2:5074/api/Authentication/signin";
    const String url = "http://192.168.1.65:5074/api/Authentication/signin";
      // Send the POST request
    final response =await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );

    // Handling the response
    if (response.statusCode == 200) {
      print("Data insert in userinfo table successs.");
      return true;
    } else {
      print("Data insert in userinfo table fail.");
      return false;
    }

  }

  @override
  Widget build(BuildContext context)  {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    return
      Scaffold(
        appBar: AppBar(
          title: Text("SignUp Screen"),
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
                      height: heightval*0.80,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(shortestval*0.04)),
                      ),
                      child: 
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [

                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: CommonTextField_obs_false_p('Enter First Name', 'Ram', false, first_name_cont, context),
                            ),
                            CommonTextField_obs_false_p("Enter Last Name", "Gurung", false, last_name_cont, context),
                            CommonTextField_obs_false_p("Enter Email", "xxxx@gmail.com", false, email_cont, context),
                            CommonTextField_obs_false_p("Enter Phone Number", "9812345678", false, phone_number_cont, context),
                            CommonTextField_obs_false_p("Enter Address", "Letang-9,Morang", false, address_cont, context),
                            CommonTextField_obs_false_p("Enter Username", "Xyyy@123", false, username_cont, context),
                            CommonTextField_obs_false_p("Enter Password", "xxxxx", false, password_cont, context),
                            Obx(
                                  ()=> Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Center(child: Commonbutton("Select profile image",(){pick_single_photo_cont.pickImage();}, context,
                                    pick_single_photo_cont.imageBytes.value==null?
                                    Colors.red:Colors.green)),
                              ),
                            ),

                            Row(
                              children: [

                                Obx(
                                  ()=>Checkbox(value: checkbox_a_t_c_cont.termns_cond.value,
                                    onChanged:(value) {
                                    checkbox_a_t_c_cont.ValueChange(value);
                                  },),
                                ),
                                Text("I accept all terms and conditions.",
                                  style: TextStyle(
                                  fontSize: shortestval*0.05,
                                  fontFamily: semibold,
                                  color: Colors.black
                                ),
                                ),
                              ],
                            ),


                            Obx(
                              ()=>
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15.0),
                                    child: Center(
                                      child: 
                                      FittedBox(
                                        child: CommonButton_loading(
                                        label:"Sign In",
                                        onPressed:() async {
                                          try {
                                            if(checkbox_a_t_c_cont.termns_cond.value==true)
                                            {
                                              print("test1");
                                              isloading_cont.change_isloadingval(true);
                                              print("test2");
                                              bool signinuser =await SignInUser(
                                                  firstName: first_name_cont.text
                                                      .toString(),
                                                  lastName: last_name_cont.text
                                                      .toString(),
                                                  email: email_cont.text.toString(),
                                                  phoneNumber: phone_number_cont
                                                      .text.toString(),
                                                  username: username_cont.text
                                                      .toString(),
                                                  password: password_cont.text
                                                      .toString(),
                                                  address: address_cont.text
                                                      .toString(),
                                                  imageBytes: pick_single_photo_cont
                                                      .imageBytes.value,
                                                  type: "user"
                                              );
                                              print("post request result");
                                              print(signinuser);
                                              print("finish");
                                              if (signinuser == true)
                                              {
                                                print("User signin success");
                                                isloading_cont.change_isloadingval(false);
                                                Toastget().Toastmsg("User signin success");
                                              }
                                              else
                                              {
                                                print("User signin fail");
                                                isloading_cont.change_isloadingval(false);
                                                Toastget().Toastmsg(
                                                    "User signin fail");
                                              }
                                            }
                                            else{
                                              print("Terms and condition not accepted.");
                                              Toastget().Toastmsg("First accept terms and condition and then sign in.");
                                            }
                                          }catch(obj)
                                          {
                                            print("Exception caught while using post request for sign in.");
                                            print("Exception = ${obj.toString()}");
                                            isloading_cont.change_isloadingval(false);
                                            Toastget().Toastmsg("Sign in fail.Refill form and try again.");
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
                                    ),
                                  ),
                            ),

                            TextButton(onPressed:(){
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
                                return Home();
                              },
                              )
                              );
                            } , child:  
                            FittedBox(
                              child: Text("Go to login screen.Click me.",
                                style: TextStyle(
                                    fontSize: shortestval*0.05,
                                    fontFamily: bold,
                                    color: Colors.black
                                ),
                              ),
                            )
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
                      height: heightval*0.80,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(shortestval*0.04)),
                      ),
                      child:
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        child:
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                            [

                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: CommonTextField_obs_false_l('Enter First Name', 'Ram', false, first_name_cont, context),
                              ),
                              CommonTextField_obs_false_l("Enter Last Name", "Gurung", false, last_name_cont, context),
                              CommonTextField_obs_false_l("Enter Email", "xxxx@gmail.com", false, email_cont, context),
                              CommonTextField_obs_false_l("Enter Phone Number", "9812345678", false, phone_number_cont, context),
                              CommonTextField_obs_false_l("Enter Address", "Letang-9,Morang", false, address_cont, context),
                              CommonTextField_obs_false_l("Enter Username", "Xyyy@123", false, username_cont, context),
                              CommonTextField_obs_false_l("Enter Password", "xxxxx", false, password_cont, context),
                              Obx(
                                    ()=> Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Center(child: Commonbutton("Select profile image",(){pick_single_photo_cont.pickImage();}, context,
                                      pick_single_photo_cont.imageBytes.value==null?
                                      Colors.red:Colors.green)),
                                ),
                              ),

                              Row(
                                children: [

                                  Obx(
                                        ()=>Checkbox(value: checkbox_a_t_c_cont.termns_cond.value,
                                      onChanged:(value) {
                                        checkbox_a_t_c_cont.ValueChange(value);
                                      },),
                                  ),
                                  Text("I accept all terms and conditions.",
                                    style: TextStyle(
                                        fontSize: shortestval*0.05,
                                        fontFamily: semibold,
                                        color: Colors.black
                                    ),
                                  ),
                                ],
                              ),


                              Obx(
                                    ()=>
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 15.0),
                                      child: Center(
                                        child:
                                        FittedBox(
                                          child: CommonButton_loading(
                                            label:"Sign In",
                                            onPressed:() async {
                                              try {
                                                isloading_cont.change_isloadingval(true);
                                                if(checkbox_a_t_c_cont.termns_cond.value==true)
                                                {
                                                  print("test1");
                                                  print("test2");
                                                  bool signinuser =await SignInUser(
                                                      firstName: first_name_cont.text
                                                          .toString(),
                                                      lastName: last_name_cont.text
                                                          .toString(),
                                                      email: email_cont.text.toString(),
                                                      phoneNumber: phone_number_cont
                                                          .text.toString(),
                                                      username: username_cont.text
                                                          .toString(),
                                                      password: password_cont.text
                                                          .toString(),
                                                      address: address_cont.text
                                                          .toString(),
                                                      imageBytes: pick_single_photo_cont
                                                          .imageBytes.value,
                                                      type: "user"
                                                  );
                                                  print("post request result");
                                                  print(signinuser);
                                                  print("finish");
                                                  if (signinuser == true)
                                                  {
                                                    print("User signin success");
                                                    isloading_cont.change_isloadingval(false);
                                                    Toastget().Toastmsg("User signin success");
                                                  }
                                                  else
                                                  {
                                                    print("User signin fail");
                                                    isloading_cont.change_isloadingval(false);
                                                    Toastget().Toastmsg(
                                                        "User signin fail");
                                                  }

                                                }
                                                else{
                                                  isloading_cont.change_isloadingval(false);
                                                  print("Terms and condition not accepted.");
                                                  Toastget().Toastmsg("First accept terms and condition and then sign in.");
                                                }
                                              }catch(obj)
                                              {
                                                print("Exception caught while using post request for sign in.");
                                                print("Exception = ${obj.toString()}");
                                                isloading_cont.change_isloadingval(false);
                                                Toastget().Toastmsg("Sign in fail.Refill form and try again.");
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
                                      ),
                                    ),
                              ),

                              TextButton(onPressed:(){
                                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
                                  return Home();
                                },
                                )
                                );
                              } , child:
                              FittedBox(
                                child: Text("Go to login screen.Click me.",
                                  style: TextStyle(
                                      fontSize: shortestval*0.05,
                                      fontFamily: bold,
                                      color: Colors.black
                                  ),
                                ),
                              )
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

