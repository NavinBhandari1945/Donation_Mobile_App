import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/views/constant/styles.dart';
import 'package:hand_in_need/views/mobile/authentication/forget_password_screen_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/CommonTextfield_obs_val_true_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:hand_in_need/views/mobile/Admin_Operation/admin_home_p.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'package:hand_in_need/views/mobile/home/index_home.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import 'package:http/http.dart' as http;
import '../home/authentication_home_p.dart';
import 'feedback_screen_p.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  var username_cont = TextEditingController();
  var passwoord_cont = TextEditingController();
  var isloading_getx_cont = Get.put(Isloading());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    isloading_getx_cont.isloading.value = false;
    try {
      Check_Jwt_Token_Landing_Screen(context: context);
    } catch (obj) {
      print("Exception caught while checking for landing screen");
      print(obj.toString());
      clearUserData();
      deleteTempDirectoryPostVideo();
      deleteTempDirectoryCampaignVideo();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    username_cont.dispose();
    passwoord_cont.dispose();
    super.dispose();
  }

  Future<int> login_user({required String username, required String password}) async {
    try {
      final Map<String, dynamic> userData = {"Username": username, "Password": password};
      const String url = Backend_Server_Url + "api/Authentication/login";
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        await handleResponse(responseData);
        return 1;
      } else if (response.statusCode == 503) {
        print("Invalid password.");
        return 3;
      } else if (response.statusCode == 501) {
        print("Username don't found.");
        return 4;
      } else if (response.statusCode == 502) {
        print("Incorrect format of provided details.");
        return 5;
      } else if (response.statusCode == 400) {
        print("Incorrect provided details.");
        return 6;
      } else {
        print("Other status code.Error.");
        print("Status code = ${response.statusCode}");
        return 2;
      }
    } catch (Obj) {
      print("Exception caight in login user method in http method.");
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
        title: const Text(
          "Login",
          style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
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
            if (orientation == Orientation.portrait) {
              return _buildPortraitLayout(shortestval, widthval, heightval);
            } else {
              return _buildLandscapeLayout(shortestval, widthval, heightval);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(double shortestval, double widthval, double heightval) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(shortestval * 0.05),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  width: widthval * 0.9,
                  padding: EdgeInsets.all(shortestval * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontFamily: bold,
                          fontSize: shortestval * 0.07,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      CommonTextField_obs_false_p(
                        "Enter Username",
                        "",
                        false,
                        username_cont,
                        context,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.green[700]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
                        ),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      CommonTextField_obs_val_true_p(
                        "Enter Password",
                        "",
                        passwoord_cont,
                        context,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.green[700]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
                        ),
                      ),
                      SizedBox(height: shortestval * 0.06),
                      Center(
                        child: CommonButton_loading(
                          label: "Log In",
                          onPressed: _login,
                          color: Colors.green[600]!,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: shortestval * 0.045,
                            fontFamily: bold,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: shortestval * 0.1,
                            vertical: shortestval * 0.04,
                          ),
                          borderRadius: 12.0,
                          width: widthval * 0.6,
                          height: shortestval * 0.14,
                          isLoading: isloading_getx_cont.isloading.value,
                        ),
                      ),
                      SizedBox(height: shortestval * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Forget_Password_Screen_P()),
                            ),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontFamily: semibold,
                                color: Colors.green[700],
                                fontSize: shortestval * 0.04,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FeedbackScreenP()),
                            ),
                            icon: Icon(Icons.feedback_rounded, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              padding: EdgeInsets.all(shortestval * 0.03),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(double shortestval, double widthval, double heightval) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widthval * 0.1, vertical: heightval * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: heightval * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_open_rounded,
                            size: heightval * 0.15,
                            color: Colors.green[700],
                          ),
                          SizedBox(height: heightval * 0.03),
                          Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontFamily: bold,
                              fontSize: heightval * 0.07,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(20))),
                      child: Container(
                        padding: EdgeInsets.all(heightval * 0.06),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextField_obs_false_p(
                              "Enter Username",
                              "",
                              false,
                              username_cont,
                              context,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person, color: Colors.green[700]),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
                              ),
                            ),
                            SizedBox(height: heightval * 0.04),
                            CommonTextField_obs_val_true_p(
                              "Enter Password",
                              "",
                              passwoord_cont,
                              context,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock, color: Colors.green[700]),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
                              ),
                            ),
                            SizedBox(height: heightval * 0.06),
                            Center(
                              child: CommonButton_loading(
                                label: "Log In",
                                onPressed: _login,
                                color: Colors.green[600]!,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: heightval * 0.045,
                                  fontFamily: bold,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: heightval * 0.1,
                                  vertical: heightval * 0.03,
                                ),
                                borderRadius: 12.0,
                                width: widthval * 0.3,
                                height: heightval * 0.12,
                                isLoading: isloading_getx_cont.isloading.value,
                              ),
                            ),
                            SizedBox(height: heightval * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Forget_Password_Screen_P()),
                                  ),
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontFamily: semibold,
                                      color: Colors.green[700],
                                      fontSize: heightval * 0.04,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => FeedbackScreenP()),
                                  ),
                                  icon: Icon(Icons.feedback_rounded, color: Colors.white),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.blue[600],
                                    padding: EdgeInsets.all(heightval * 0.03),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    try {
      isloading_getx_cont.change_isloadingval(true);
      if (username_cont.text.isEmptyOrNull || passwoord_cont.text.isEmptyOrNull) {
        Toastget().Toastmsg("All fields are mandatory. Fill first and try again.");
        isloading_getx_cont.change_isloadingval(false);
        return;
      }
      int login_rsult = await login_user(username: username_cont.text, password: passwoord_cont.text);
      print("Login result");
      print(login_rsult);
      if (login_rsult == 1) {
        final box = await Hive.openBox('userData');
        String? jwtToken = await box.get('jwt_token');
        Map<dynamic, dynamic> userData = await getUserCredentials();
        if (jwtToken == null && userData == null) {
          isloading_getx_cont.change_isloadingval(false);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
          Toastget().Toastmsg("Login Failed. Try again.");
        } else {
          if (userData["usertype"] == "user") {
            Toastget().Toastmsg("Login success");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Index_Home_Screen(
                  username: userData["username"]!,
                  usertype: userData["usertype"]!,
                  jwttoken: jwtToken!,
                ),
              ),
            );
          } else if (userData["usertype"] == "admin") {
            Toastget().Toastmsg("Login success");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHome(
                  jwttoken: jwtToken!,
                  usertype: userData["usertype"]!,
                  username: userData["username"]!,
                ),
              ),
            );
          }
        }
      } else if (login_rsult == 5) {
        Toastget().Toastmsg("Enter details in correct format.");
      } else if (login_rsult == 4) {
        Toastget().Toastmsg("Username not found. Enter valid username.");
      } else if (login_rsult == 3) {
        Toastget().Toastmsg("Invalid password. Login failed.");
      } else if (login_rsult == 6) {
        Toastget().Toastmsg("Invalid entered details. Login failed.");
      } else {
        Toastget().Toastmsg("Login failed. Try again.");
      }
    } catch (obj) {
      print("${obj.toString()}");
      Toastget().Toastmsg("Server error. Try again.");
    } finally {
      isloading_getx_cont.change_isloadingval(false);
    }
  }
}









// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hand_in_need/views/constant/styles.dart';
// import 'package:hand_in_need/views/mobile/authentication/forget_password_screen_p.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/CommonTextfield_obs_val_true_p.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
// import 'package:hand_in_need/views/mobile/Admin_Operation/admin_home_p.dart';
// import 'package:hand_in_need/views/mobile/constant/constant.dart';
// import 'package:hand_in_need/views/mobile/home/index_home.dart';
// import 'package:hive/hive.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../commonwidget/CommonMethod.dart';
// import '../commonwidget/circular_progress_ind_yellow.dart';
// import '../commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
// import 'package:http/http.dart' as http;
// import '../home/authentication_home_p.dart';
// import 'feedback_screen_p.dart';
//
// class LoginScreen extends StatefulWidget
// {
//   const LoginScreen({super.key});
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen>
// {
//
//   var username_cont=TextEditingController();
//   var passwoord_cont=TextEditingController();
//   var isloading_getx_cont=Get.put(Isloading());
//
//   @override
//   void initState()
//   {
//     isloading_getx_cont.isloading.value=false;
//     super.initState();
//     try {
//       Check_Jwt_Token_Landing_Screen(context: context);
//     }catch(obj){
//       print("Exception caught while checking for landing screen");
//       print(obj.toString());
//       clearUserData();
//       deleteTempDirectoryPostVideo();
//       deleteTempDirectoryCampaignVideo();
//       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
//         return LoginScreen();
//       },
//       )
//       );
//     }
//
//   }
//
//   @override
//   void dispose()
//   {
//     username_cont.dispose();
//     passwoord_cont.dispose();
//     super.dispose();
//   }
//
//
// //Method that requst api to check valid login credentials
//   Future<int> login_user({
//     required String username,
//     required String password
//   }) async {
//
//     try {
//       // Prepare the data dictionary to send to the server
//       final Map<String, dynamic> userData =
//       {
//         "Username": username,
//         "Password": password,
//       };
//
//       // API endpoint
//       const String url = Backend_Server_Url+"api/Authentication/login";
//
//       // Send the POST request
//       final response = await http.post
//         (
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(userData),
//       );
//
//       // Handling the response
//       if (response.statusCode == 200) {
//         Map<String, dynamic> responseData = jsonDecode(response.body);
//         await handleResponse(responseData);
//         return 1;
//       }
//       else if (response.statusCode == 503) {
//         print("Invalid password.");
//         return 3;
//       }
//       else if (response.statusCode == 501)
//       {
//         print("Username don't found.");
//         return 4;
//       }
//       else if (response.statusCode == 502)
//       {
//         print("Incorrect format of provided details.");
//         return 5;
//       }
//       else if (response.statusCode == 400)
//       {
//         print("Incorrect provided details.");
//         return 6;
//       }
//       else
//       {
//         print("Other status code.Error.");
//         print("Status code = ${response.statusCode}");
//         return 2;
//       }
//     }catch(Obj)
//     {
//       print("Exception caight in login user method in http method.");
//       print(Obj.toString());
//       return 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var shortestval=MediaQuery.of(context).size.shortestSide;
//     var widthval=MediaQuery.of(context).size.width;
//     var heightval=MediaQuery.of(context).size.height;
//     return Scaffold(
//         appBar: AppBar(
//         title: Text("Login Screen."),
//         backgroundColor: Colors.green,
//         ),
//       body:
//       OrientationBuilder(builder: (context, orientation) {
//         if(orientation==Orientation.portrait)
//         {
//           return
//             Container(
//                 width:widthval,
//                 height: heightval,
//                 color: Colors.white10,
//                 child:
//                 Center(
//                   child: Container(
//                     width: widthval,
//                     height: heightval*0.50,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.all(Radius.circular(shortestval*0.04)),
//                     ),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       physics: BouncingScrollPhysics(),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children:
//                         [
//
//                           Padding(
//                             padding: const EdgeInsets.only(top: 12.0),
//                             child: CommonTextField_obs_false_p("Enter Username", "", false, username_cont, context),
//                           ),
//                           CommonTextField_obs_val_true_p("Enter Password", "", passwoord_cont, context),
//                           SizedBox(height: shortestval*0.05),
//                           Center(
//                             child: CommonButton_loading(label: "LogIn",
//                               onPressed: () async
//                               {
//                                 try
//                                 {
//                                   isloading_getx_cont.change_isloadingval(true);
//                                   if(username_cont.text.isEmptyOrNull || passwoord_cont.text.isEmptyOrNull)
//                                   {
//                                     Toastget().Toastmsg("All the field are mandatory.Fill first and try again.");
//                                     return;
//                                   }
//                                   int login_rsult= await login_user(username: username_cont.text.toString(), password: passwoord_cont.text.toString());
//                                   print("Login result");
//                                   print(login_rsult);
//                                   if(login_rsult==1)
//                                   {
//                                     final box =await Hive.openBox('userData');
//                                     String? jwtToken =await box.get('jwt_token');
//                                     Map<dynamic, dynamic> userData=await getUserCredentials();
//                                     // If no token exists, navigate to Home screen
//                                     if (jwtToken == null && userData == null)
//                                     {
//                                       isloading_getx_cont.change_isloadingval(false);
//                                       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
//                                       {
//                                         return  AuthenticationHome();
//                                       },)
//                                       );
//                                       Toastget().Toastmsg("Login Fail.Try again.");
//                                     } else
//                                     {
//
//                                       if(userData["usertype"]=="user")
//                                       {
//                                         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
//                                         {
//                                           isloading_getx_cont.change_isloadingval(false);
//                                           return Index_Home_Screen(username: userData["username"]!, usertype: userData["usertype"]!, jwttoken: jwtToken!);
//                                         },)
//                                         );
//                                       }
//
//                                       if(userData["usertype"]=="admin")
//                                       {
//                                         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
//                                         {
//                                           isloading_getx_cont.change_isloadingval(false);
//                                           return AdminHome(jwttoken: jwtToken!,usertype:userData["usertype"]!,username:userData["username"]!,);
//                                         },)
//                                         );
//                                       }
//
//                                     }
//
//                                   }
//                                   else if(login_rsult==5)
//                                   {
//                                     isloading_getx_cont.change_isloadingval(false);
//                                     Toastget().Toastmsg("Enter details in correct format.");
//                                   }
//                                   else if(login_rsult==4)
//                                   {
//                                     isloading_getx_cont.change_isloadingval(false);
//                                     Toastget().Toastmsg("Username not found.Enter valid username..Fail.");
//                                   }
//                                   else if(login_rsult==3)
//                                   {
//                                     isloading_getx_cont.change_isloadingval(false);
//                                     Toastget().Toastmsg("Invalid password.Login fail..");
//                                   }
//                                   else if(login_rsult==6)
//                                   {
//                                     isloading_getx_cont.change_isloadingval(false);
//                                     Toastget().Toastmsg("Invalid enter details.Login fail..");
//                                   }
//                                   else
//                                     {
//                                       isloading_getx_cont.change_isloadingval(false);
//                                       Toastget().Toastmsg("Login fail.Try again.");
//                                     }
//                                 }catch(obj)
//                                 {
//                                   print("${obj.toString()}");
//                                   isloading_getx_cont.change_isloadingval(false);
//                                   Toastget().Toastmsg("Server error.Try again.");
//                                 }
//                               },
//                               color:Colors.red,
//                               textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
//                               padding: const EdgeInsets.all(12),
//                               borderRadius:25.0,
//                               width: shortestval*0.25,
//                               height: shortestval*0.15,
//                               isLoading: isloading_getx_cont.isloading.value,
//                             ),
//                           ),
//
//                           SizedBox(
//                             width: widthval,
//                             height: heightval*0.02,
//                           ),
//
//                           Container(
//                             width: widthval,
//                             // height: heightval*0.05,
//                             // color: Colors.brown,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children:
//                               [
//                                 TextButton(onPressed: (){
//                                   Navigator.push(context,MaterialPageRoute(builder: (context) {
//                                     return Forget_Password_Screen_P();
//                                   },));
//                                 }, child:Text("Forget Password.",style:TextStyle(fontFamily: semibold,color: Colors.black,fontSize: shortestval*0.06)),
//                                 ),
//
//                                 IconButton(onPressed: (){
//                                   Navigator.push(context,MaterialPageRoute(builder: (context) {
//                                     return FeedbackScreenP();
//                                   },));
//                                 }, style: ButtonStyle(
//                                   foregroundColor: MaterialStateProperty.all(Colors.blue), // Icon color
//                                   backgroundColor: MaterialStateProperty.all(Colors.grey[200]), // Background color
//                                   padding: MaterialStateProperty.all(EdgeInsets.all(12)), // Padding around icon
//                                   iconSize: MaterialStateProperty.all(30), // Icon size
//                                   shape: MaterialStateProperty.all(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10), // Rounded corners
//                                       side: BorderSide(color: Colors.blue, width: 2), // Border
//                                     ),
//                                   ),
//                                 ),icon:Icon(Icons.feedback_rounded)),
//                               ],
//                             ),
//                           )
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//             );
//         }
//         else if(orientation==Orientation.landscape)
//         {
//           return
//             Container (
//             );
//         }
//         else{
//           return Circular_pro_indicator_Yellow(context);
//         }
//       },
//       ),
//     );
//   }
// }
