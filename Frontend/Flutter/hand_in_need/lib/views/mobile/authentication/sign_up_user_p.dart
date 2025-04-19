import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/views/constant/styles.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_l.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'package:velocity_x/velocity_x.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/getx_cont/getx_accept_tems_cond_checkbox.dart';
import '../commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import '../commonwidget/getx_cont_pick_single_photo.dart';
import 'package:http/http.dart' as http;
import '../home/authentication_home_p.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  var first_name_cont = TextEditingController();
  var last_name_cont = TextEditingController();
  var email_cont = TextEditingController();
  var phone_number_cont = TextEditingController();
  var address_cont = TextEditingController();
  var username_cont = TextEditingController();
  var password_cont = TextEditingController();
  var isloading_cont = Get.put(Isloading());
  var pick_single_photo_cont = Get.put(pick_single_photo_getx());
  var checkbox_a_t_c_cont = Get.put(CheckBox_A_T_C());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    checkbox_a_t_c_cont.ValueChange(false);
    pick_single_photo_cont.imagePath.value = "";
    pick_single_photo_cont.imageBytes.value = null;
    isloading_cont.change_isloadingval(false);
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
    first_name_cont.dispose();
    last_name_cont.dispose();
    email_cont.dispose();
    phone_number_cont.dispose();
    address_cont.dispose();
    username_cont.dispose();
    password_cont.dispose();
    super.dispose();
  }

  Future<int> SignInUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String username,
    required String password,
    required String address,
    required imageBytes,
    required String type,
  }) async {
    try {
      final String base64Image = base64Encode(imageBytes as List<int>);
      final Map<String, dynamic> userData = {
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "Username": username,
        "Password": password,
        "Address": address,
        "Photo": base64Image,
        "Type": type,
      };
      const String url = Backend_Server_Url + "api/Authentication/signin";
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        print("Data insert in userinfo table successs.");
        return 1;
      } else if (response.statusCode == 502) {
        print("Username already exists.");
        return 3;
      } else if (response.statusCode == 501) {
        print("Provided data are not in correct format.");
        return 4;
      } else if (response.statusCode == 500) {
        print("Exception caught in backend.");
        return 5;
      } else {
        print("Data insert in userinfo table fail.");
        return 2;
      }
    } catch (Obj) {
      print("Exception caught in sign in user http method.");
      print(Obj.toString());
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
        title: const Text("Sign Up", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
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
            SizedBox(height: shortestval * 0.03),
            _buildTextField("Enter First Name", first_name_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter Last Name", last_name_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter Email", email_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter Phone Number", phone_number_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter Address", address_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter Username", username_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter Password", password_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
            _buildImageButton(shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
            _buildCheckboxRow(shortestval),
            SizedBox(height: shortestval * 0.03),
            _buildSignInButton(shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildLoginLink(shortestval),
            SizedBox(height: shortestval * 0.03),
            _buildExpansionTile(shortestval),
            SizedBox(height: shortestval * 0.03),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  SizedBox(height: shortestval * 0.03),
                  _buildTextField("Enter First Name", first_name_cont, shortestval, widthval * 0.65),
                  SizedBox(height: shortestval * 0.02),
                  _buildTextField("Enter Last Name", last_name_cont, shortestval, widthval * 0.65),
                  SizedBox(height: shortestval * 0.02),
                  _buildTextField("Enter Email", email_cont, shortestval, widthval * 0.65),
                  SizedBox(height: shortestval * 0.02),
                  _buildTextField("Enter Phone Number", phone_number_cont, shortestval, widthval * 0.65),
                  SizedBox(height: shortestval * 0.02),
                  _buildTextField("Enter Address", address_cont, shortestval, widthval * 0.65),
                  SizedBox(height: shortestval * 0.02),
                  _buildTextField("Enter Username", username_cont, shortestval, widthval * 0.65),
                  SizedBox(height: shortestval * 0.02),
                  _buildTextField("Enter Password", password_cont, shortestval, widthval * 0.65),
                ],
              ),
            ),
            SizedBox(width: shortestval * 0.03),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: shortestval * 0.03),
                  _buildImageButton(shortestval, widthval * 0.25),
                  SizedBox(height: shortestval * 0.03),
                  _buildCheckboxRow(shortestval),
                  SizedBox(height: shortestval * 0.03),
                  _buildSignInButton(shortestval, widthval * 0.25),
                  SizedBox(height: shortestval * 0.02),
                  _buildLoginLink(shortestval),
                  SizedBox(height: shortestval * 0.03),
                  _buildExpansionTile(shortestval),
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
      child: CommonTextField_obs_false_p(hint, hint == "Enter Password" ? "xxxxx" : "", false, controller, context),
    );
  }

  Widget _buildImageButton(double shortestval, double width) {
    return Obx(
          () => Commonbutton(
        "Select profile image",
            () {
          pick_single_photo_cont.pickImage();
        },
        context,
        pick_single_photo_cont.imageBytes.value == null ? Colors.red : Colors.green,
      ),
    );
  }

  Widget _buildCheckboxRow(double shortestval) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
              () => Checkbox(
            value: checkbox_a_t_c_cont.termns_cond.value,
            onChanged: (value) {
              checkbox_a_t_c_cont.ValueChange(value);
            },
          ),
        ),
        Flexible(
          child: Text(
            "I accept all terms and conditions.",
            style: TextStyle(fontSize: shortestval * 0.04, fontFamily: semibold, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(double shortestval, double width) {
    return Obx(
          () => isloading_cont.isloading.value
          ? CircularProgressIndicator(color: Colors.red)
          : Commonbutton(
        "Sign In",
            () async {
          try {
            if (first_name_cont.text.isEmptyOrNull ||
                last_name_cont.text.isEmptyOrNull ||
                email_cont.text.isEmptyOrNull ||
                phone_number_cont.text.isEmptyOrNull ||
                email_cont.text.isEmptyOrNull ||
                username_cont.text.isEmptyOrNull ||
                password_cont.text.isEmptyOrNull) {
              Toastget().Toastmsg("All the field are mandatory.Try again.");
              return;
            }
            if (!RegExp(r"^\+?[0-9]+$").hasMatch(phone_number_cont.text)) {
              Toastget().Toastmsg("Invalid number format.");
              return;
            }

            if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email_cont.text)) {
              Toastget().Toastmsg("Invalid email format.");
              return;
            }

            if (!RegExp(r"^[a-zA-Z]+$").hasMatch(first_name_cont.text) ||
                !RegExp(r"^[a-zA-Z]+$").hasMatch(last_name_cont.text)) {
              Toastget().Toastmsg("Only valid Aa-Zz letter for first and last name.");
              return;
            }
            if (pick_single_photo_cont.imageBytes.value == null || pick_single_photo_cont.imagePath.value.isEmptyOrNull) {
              Toastget().Toastmsg("Pick image and try again.");
              return;
            }
            if (checkbox_a_t_c_cont.termns_cond.value == false) {
              Toastget().Toastmsg("Accept terms and condition first and try again.");
              return;
            }
            if (checkbox_a_t_c_cont.termns_cond.value == true &&
                pick_single_photo_cont.imageBytes.value != null &&
                pick_single_photo_cont.imagePath.value.isNotEmptyAndNotNull) {
              isloading_cont.change_isloadingval(true);
              int signinuser = await SignInUser(
                firstName: first_name_cont.text.toString(),
                lastName: last_name_cont.text.toString(),
                email: email_cont.text.toString(),
                phoneNumber: phone_number_cont.text.toString(),
                username: username_cont.text.toString(),
                password: password_cont.text.toString(),
                address: address_cont.text.toString(),
                imageBytes: pick_single_photo_cont.imageBytes.value,
                type: "user",
              );
              if (signinuser == 1) {
                print("User signin success");
                isloading_cont.change_isloadingval(false);
                Toastget().Toastmsg("User signin success");
                return;
              } else if (signinuser == 3) {
                print("User signin fail.");
                isloading_cont.change_isloadingval(false);
                Toastget().Toastmsg("User signin fail.Username already used.Try different.");
                return;
              } else if (signinuser == 4) {
                print("User signin fail.");
                isloading_cont.change_isloadingval(false);
                Toastget().Toastmsg("User signin fail.Enter details not according to format.");
                return;
              } else {
                print("User signin fail");
                isloading_cont.change_isloadingval(false);
                Toastget().Toastmsg("User signin fail.Try again.");
                return;
              }
            } else {
              print("Accept terms and conditions and pick image first and try again.Fail.");
              Toastget().Toastmsg("Accept terms and conditions and pick image first and try again.Fail.");
              return;
            }
          } catch (obj) {
            print("Exception caught while using post request for sign in.");
            print("Exception = ${obj.toString()}");
            isloading_cont.change_isloadingval(false);
            Toastget().Toastmsg("Sign in fail.Refill form and try again.");
            return;
          }
        },
        context,
        Colors.red,
      ),
    );
  }

  Widget _buildLoginLink(double shortestval) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
      },
      child: Text(
        "Go to login screen. Click me.",
        style: TextStyle(fontSize: shortestval * 0.04, fontFamily: bold, color: Colors.black),
      ),
    );
  }

  Widget _buildExpansionTile(double shortestval) {
    return ExpansionTile(
      title: Text(
        "Note",
        style: TextStyle(fontFamily: bold, fontSize: shortestval * 0.05, color: Colors.black),
      ),
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      children: [
        Padding(
          padding: EdgeInsets.all(shortestval * 0.02),
          child: Text(
            "Keep the screenshot of provided information which is needed in the future for confirmation of user while recovering password.",
            style: TextStyle(fontFamily: semibold, fontSize: shortestval * 0.04, color: Colors.black),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}






// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hand_in_need/views/constant/styles.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_l.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
// import 'package:hand_in_need/views/mobile/constant/constant.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../commonwidget/circular_progress_ind_yellow.dart';
// import '../commonwidget/getx_cont/getx_accept_tems_cond_checkbox.dart';
// import '../commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
// import '../commonwidget/getx_cont_pick_single_photo.dart';
// import 'package:http/http.dart' as http;
//
// import '../home/authentication_home_p.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   var first_name_cont = TextEditingController();
//   var last_name_cont = TextEditingController();
//   var email_cont = TextEditingController();
//   var phone_number_cont = TextEditingController();
//   var address_cont = TextEditingController();
//   var username_cont = TextEditingController();
//   var password_cont = TextEditingController();
//   var isloading_cont = Get.put(Isloading());
//   var pick_single_photo_cont = Get.put(pick_single_photo_getx());
//   var checkbox_a_t_c_cont = Get.put(CheckBox_A_T_C());
//
//   @override
//   void dispose() {
//     // Dispose of the controllers when the widget is removed from the widget tree
//     first_name_cont.dispose();
//     last_name_cont.dispose();
//     email_cont.dispose();
//     address_cont.dispose();
//     username_cont.dispose();
//     phone_number_cont.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     checkbox_a_t_c_cont.ValueChange(false);
//     pick_single_photo_cont.imagePath.value = "";
//     pick_single_photo_cont.imageBytes.value = null;
//     isloading_cont.change_isloadingval(false);
//   }
//
//   Future<int> SignInUser({
//     required String firstName,
//     required String lastName,
//     required String email,
//     required String phoneNumber,
//     required String username,
//     required String password,
//     required String address,
//     required imageBytes,
//     required String type,
//   }) async {
//
//     try {
//       // Base64 Encoding
//       final String base64Image = base64Encode(imageBytes as List<int>);
//
//       // Prepare the data dictionary to send to the server
//       final Map<String, dynamic> userData = {
//         "FirstName": firstName,
//         "LastName": lastName,
//         "Email": email,
//         "PhoneNumber": phoneNumber,
//         "Username": username,
//         "Password": password,
//         "Address": address,
//         "Photo": base64Image, // Encoded image as a base64 string
//         "Type": type,
//       };
//
//       // API endpoint
//       // const String url = "http://10.0.2.2:5074/api/Authentication/signin";
//       const String url = Backend_Server_Url+"api/Authentication/signin";
//       // Send the POST request
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(userData),
//       );
//
//       // Handling the response
//       if (response.statusCode == 200) {
//         print("Data insert in userinfo table successs.");
//         return 1;
//       }
//       else if(response.statusCode==502)
//         {
//           print("Username already exists.");
//           return 3;
//         }
//       else if(response.statusCode==501)
//       {
//         print("Provided data are not in correct format.");
//         return 4;
//       }
//       else if(response.statusCode==500)
//       {
//         print("Exception caught in backend.");
//         return 5;
//       }
//       else {
//         print("Data insert in userinfo table fail.");
//         return 2;
//       }
//     }catch(Obj)
//     {
//       print("Exception caught in sign in user http method.");
//       print(Obj.toString());
//       return 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var shortestval = MediaQuery.of(context).size.shortestSide;
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("SignUp Screen"),
//         backgroundColor: Colors.green[700],
//         elevation: 4,
//         shadowColor: Colors.black45,
//         automaticallyImplyLeading: true,
//       ),
//       body: OrientationBuilder(
//         builder: (context, orientation) {
//           if (orientation == Orientation.portrait) {
//             return Container(
//                 width: widthval,
//                 height: heightval,
//                 color: Colors.white10,
//                 child: Center(
//                   child: Container(
//                     width: widthval,
//                     height: heightval * 0.80,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius:
//                           BorderRadius.all(Radius.circular(shortestval * 0.04)),
//                     ),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       physics: BouncingScrollPhysics(),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 12.0),
//                             child: CommonTextField_obs_false_p(
//                                 'Enter First Name',
//                                 'Ram',
//                                 false,
//                                 first_name_cont,
//                                 context),
//                           ),
//                           CommonTextField_obs_false_p("Enter Last Name",
//                               "Gurung", false, last_name_cont, context),
//                           CommonTextField_obs_false_p("Enter Email",
//                               "xxxx@gmail.com", false, email_cont, context),
//                           CommonTextField_obs_false_p("Enter Phone Number",
//                               "9812345678", false, phone_number_cont, context),
//                           CommonTextField_obs_false_p("Enter Address",
//                               "Letang-9,Morang", false, address_cont, context),
//                           CommonTextField_obs_false_p("Enter Username",
//                               "Xyyy@123", false, username_cont, context),
//                           CommonTextField_obs_false_p("Enter Password", "xxxxx",
//                               false, password_cont, context),
//                           Obx(
//                             () => Padding(
//                               padding: const EdgeInsets.only(bottom: 15.0),
//                               child: Center(
//                                   child: Commonbutton("Select profile image",
//                                       () {
//                                 pick_single_photo_cont.pickImage();
//                               },
//                                       context,
//                                       pick_single_photo_cont.imageBytes.value ==
//                                               null
//                                           ? Colors.red
//                                           : Colors.green)),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Obx(
//                                 () => Checkbox(
//                                   value: checkbox_a_t_c_cont.termns_cond.value,
//                                   onChanged: (value) {
//                                     checkbox_a_t_c_cont.ValueChange(value);
//                                   },
//                                 ),
//                               ),
//                               Text(
//                                 "I accept all terms and conditions.",
//                                 style: TextStyle(
//                                     fontSize: shortestval * 0.05,
//                                     fontFamily: semibold,
//                                     color: Colors.black),
//                               ),
//                             ],
//                           ),
//                           Obx(
//                             () => Padding(
//                               padding: const EdgeInsets.only(bottom: 15.0),
//                               child: Center(
//                                 child: FittedBox(
//                                   child: CommonButton_loading(
//                                     label: "Sign In",
//                                     onPressed: () async {
//                                       try {
//                                         if(
//                                         first_name_cont.text.isEmptyOrNull ||
//                                         last_name_cont.text.isEmptyOrNull ||
//                                         email_cont.text.isEmptyOrNull ||
//                                         phone_number_cont.text.isEmptyOrNull ||
//                                         email_cont.text.isEmptyOrNull ||
//                                         username_cont.text.isEmptyOrNull ||
//                                         password_cont.text.isEmptyOrNull
//                                         )
//                                         {
//                                             Toastget().Toastmsg("All the field are mandatory.Try again.");
//                                             return;
//                                         }
//                                         if(
//                                         !RegExp(r"^\+?[0-9]+$").hasMatch(phone_number_cont.text))
//                                         {
//                                           Toastget().Toastmsg("Invalid number format.");
//                                           return;
//                                         }
//                                         if(!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email_cont.text))
//                                         {
//                                           Toastget().Toastmsg("Invalid email format.");
//                                           return;
//                                         }
//                                         if(   !RegExp(r"^[a-zA-Z]+$").hasMatch(first_name_cont.text) ||
//                                             !RegExp(r"^[a-zA-Z]+$").hasMatch(last_name_cont.text) )
//                                         {
//                                           Toastget().Toastmsg("Only valid Aa-Zz letter for first and last name.");
//                                           return;
//                                         }
//                                         if(pick_single_photo_cont.imageBytes.value==null || pick_single_photo_cont.imagePath.value.isEmptyOrNull)
//                                         {
//                                           Toastget().Toastmsg("Pick image and try again.");
//                                           return;
//                                         }
//                                         if(checkbox_a_t_c_cont
//                                             .termns_cond.value ==false)
//                                         {
//                                           Toastget().Toastmsg("Accept terms and condition first and try again.");
//                                           return;
//                                         }
//                                         if(
//                                         checkbox_a_t_c_cont.termns_cond.value == true &&
//                                         pick_single_photo_cont.imageBytes.value!=null &&
//                                         pick_single_photo_cont.imagePath.value.isNotEmptyAndNotNull
//                                         )
//                                         {
//
//                                           isloading_cont.change_isloadingval(true);
//                                           int signinuser = await SignInUser(
//                                               firstName: first_name_cont.text
//                                                   .toString(),
//                                               lastName: last_name_cont.text
//                                                   .toString(),
//                                               email: email_cont.text.toString(),
//                                               phoneNumber: phone_number_cont
//                                                   .text
//                                                   .toString(),
//                                               username:
//                                                   username_cont.text.toString(),
//                                               password:
//                                                   password_cont.text.toString(),
//                                               address:
//                                                   address_cont.text.toString(),
//                                               imageBytes: pick_single_photo_cont
//                                                   .imageBytes.value,
//                                               type: "user");
//                                           if (signinuser == 1) {
//                                             print("User signin success");
//                                             isloading_cont
//                                                 .change_isloadingval(false);
//                                             Toastget().Toastmsg(
//                                                 "User signin success");
//                                             return;
//                                           }
//                                           else if(signinuser==3)
//                                             {
//                                               print("User signin fail.");
//                                               isloading_cont
//                                                   .change_isloadingval(false);
//                                               Toastget().Toastmsg(
//                                                   "User signin fail.Username already used.Try different.");
//                                               return;
//                                             }
//                                           else if(signinuser==4)
//                                           {
//                                             print("User signin fail.");
//                                             isloading_cont
//                                                 .change_isloadingval(false);
//                                             Toastget().Toastmsg(
//                                                 "User signin fail.Enter details not according to format.");
//                                             return;
//                                           }
//                                           else {
//                                             print("User signin fail");
//                                             isloading_cont
//                                                 .change_isloadingval(false);
//                                             Toastget()
//                                                 .Toastmsg("User signin fail.Try again.");
//                                             return;
//                                           }
//                                         }
//                                         else
//                                         {
//                                           print(
//                                               "Accept terms and conditions and pick image first and try again.Fail.");
//                                           Toastget().Toastmsg(
//                                               "Accept terms and conditions and pick image first and try again.Fail.");
//                                           return;
//                                         }
//
//                                       } catch (obj) {
//                                         print(
//                                             "Exception caught while using post request for sign in.");
//                                         print("Exception = ${obj.toString()}");
//                                         isloading_cont
//                                             .change_isloadingval(false);
//                                         Toastget().Toastmsg(
//                                             "Sign in fail.Refill form and try again.");
//                                         return;
//                                       }
//
//                                     },
//                                     color: Colors.red,
//                                     textStyle: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: shortestval * 0.05),
//                                     padding: const EdgeInsets.all(12),
//                                     borderRadius: 25.0,
//                                     width: shortestval * 0.25,
//                                     height: shortestval * 0.15,
//                                     isLoading: isloading_cont.isloading.value,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           TextButton(
//                               onPressed: () {
//                                 Navigator.pushReplacement(context,
//                                     MaterialPageRoute(
//                                   builder: (context) {
//                                     return AuthenticationHome();
//                                   },
//                                 ));
//                               },
//                               child: FittedBox(
//                                 child: Text(
//                                   "Go to login screen.Click me.",
//                                   style: TextStyle(
//                                       fontSize: shortestval * 0.05,
//                                       fontFamily: bold,
//                                       color: Colors.black),
//                                 ),
//                               )),
//                           SizedBox(
//                             height: heightval * 0.01,
//                           ),
//                           ExpansionTile(
//                             title: Text(
//                               "Note.",
//                               style: TextStyle(
//                                   fontFamily: bold,
//                                   fontSize: shortestval * 0.07,
//                                   color: Colors.black),
//                             ),
//                             tilePadding: EdgeInsets.zero,
//                             childrenPadding: EdgeInsets.zero,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "Keep the screenshot of provided information which is need in future for confirmation of user while recoverring password.",
//                                   style: TextStyle(
//                                       fontFamily: semibold,
//                                       fontSize: shortestval * 0.06,
//                                       color: Colors.black),
//                                   textAlign: TextAlign.justify,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ));
//           } else if (orientation == Orientation.landscape) {
//             return Container
//               (
//
//             );
//           } else {
//             return Circular_pro_indicator_Yellow(context);
//           }
//         },
//       ),
//     );
//   }
// }
