import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'package:http/http.dart' as http;
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/common_button_loading.dart';
import '../commonwidget/commontextfield_obs_false_p.dart';
import '../commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import '../commonwidget/toast.dart';
import '../home/authentication_home_p.dart';

class UpdateAddress extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;

  const UpdateAddress({super.key, required this.username, required this.usertype, required this.jwttoken});

  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> with SingleTickerProviderStateMixin {
  final password_cont = TextEditingController();
  final new_address_cont = TextEditingController();
  final isloading_cont = Get.put(Isloading());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
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
    password_cont.dispose();
    new_address_cont.dispose();
    super.dispose();
  }

  Future<int> UpdateAddress({
    required String username,
    required String jwttoken,
    required String password,
    required String new_address,
  }) async {
    try {
      const String url = Backend_Server_Url + "api/Profile/updateaddress";
      Map<String, dynamic> update_data = {
        "Username": username,
        "Password": password,
        "NewAddress": new_address,
      };

      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", 'Authorization': 'Bearer $jwttoken'},
        body: json.encode(update_data),
      );

      if (response.statusCode == 200) {
        print("User authenticated");
        return 0;
      } else if (response.statusCode == 502) {
        return 1; // old password mistake
      } else if (response.statusCode == 503) {
        return 5; // user doesn't exist
      } else if (response.statusCode == 501) {
        return 3; // exception caught in backend
      } else if (response.statusCode == 500) {
        return 6; // validation error in backend
      } else if (response.statusCode == 504) {
        return 7; // old address and new address same
      } else if (response.statusCode == 400) {
        return 9; // details validation error
      } else if (response.statusCode == 401) {
        return 10; // jwt error
      } else if (response.statusCode == 403) {
        return 11; // jwt error
      } else {
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
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Address", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
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
            SizedBox(height: shortestval * 0.05),
            _buildTextField("Enter your password", password_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
            _buildTextField("Enter new address", new_address_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.05),
            _buildUpdateButton(shortestval, widthval * 0.5),
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
                  _buildTextField("Enter your password", password_cont, shortestval, widthval * 0.65),
                  SizedBox(height: shortestval * 0.03),
                  _buildTextField("Enter new address", new_address_cont, shortestval, widthval * 0.65),
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
      child: CommonTextField_obs_false_p(hint, "xxxxx", false, controller, context),
    );
  }

  Widget _buildUpdateButton(double shortestval, double width) {
    return CommonButton_loading(
      label: "Update",
      onPressed: () async {
        try {
          isloading_cont.isloading.value = true;
          if (widget.usertype == "user") {
            var update_process_result = await UpdateAddress(
              username: widget.username,
              jwttoken: widget.jwttoken,
              password: password_cont.text.toString(),
              new_address: new_address_cont.text.toString(),
            );
            print("update result");
            print(update_process_result);
            if (update_process_result == 0) {
              isloading_cont.isloading.value = false;
              Toastget().Toastmsg("Update address success.");
              return;
            } else if (update_process_result == 1) {
              isloading_cont.isloading.value = false;
              Toastget().Toastmsg("Old password mistake.Update fail.");
              return;
            } else if (update_process_result == 2) {
              isloading_cont.isloading.value = false;
              Toastget().Toastmsg("Update address fail.Try again.Recheck details.");
              return;
            } else if (update_process_result == 3) {
              isloading_cont.isloading.value = false;
              Toastget().Toastmsg("Update address fail.Try again.Recheck details.");
              return;
            } else if (update_process_result == 4) {
              await clearUserData();
              isloading_cont.isloading.value = false;
              Toastget().Toastmsg("Update address faiL.Relogin and try again.");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
              return;
            } else if (update_process_result == 5) {
              await clearUserData();
              isloading_cont.isloading.value = false;
              Toastget().Toastmsg("Update address faiL.Relogin and try again.");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
              return;
            } else if (update_process_result == 6) {
              isloading_cont.isloading.value = false;
              Toastget().Toastmsg("Provide details format correct.Password must have 6 letter with 1 number and symbol.");
              return;
            } else if (update_process_result == 7) {
              isloading_cont.isloading.value = false;
              Toastget().Toastmsg("Provide different address then before and try again..");
              return;
            } else if (update_process_result == 9) {
              isloading_cont.isloading.value = false;
              Toastget().Toastmsg("Provide details format correct.Password must have 6 letter with 1 number and symbol.");
              return;
            } else if (update_process_result == 10 || update_process_result == 11) {
              await clearUserData();
              isloading_cont.isloading.value = false;
              Toastget().Toastmsg("Update address Fail.Relogin and try again");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
              return;
            } else {
              await clearUserData();
              isloading_cont.isloading.value = false;
              Toastget().Toastmsg("Update address fail.Relogin and try again");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
            }
          } else {
            await clearUserData();
            isloading_cont.isloading.value = false;
            print("mismatch user.usertype mistake.");
            Toastget().Toastmsg("Update address faiL.Relogin and try again.");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
          }
        } catch (obj) {
          isloading_cont.isloading.value = false;
          Toastget().Toastmsg("Update faiL.Try again.");
        }
      },
      color: Colors.red,
      textStyle: TextStyle(color: Colors.white, fontSize: shortestval * 0.04, fontWeight: FontWeight.bold),
      padding: EdgeInsets.all(shortestval * 0.03),
      borderRadius: 25.0,
      width: width,
      height: shortestval * 0.15,
      isLoading: isloading_cont.isloading.value,
    );
  }
}





// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hand_in_need/views/mobile/constant/constant.dart';
// import 'package:http/http.dart' as http;
// import '../commonwidget/CommonMethod.dart';
// import '../commonwidget/common_button_loading.dart';
// import '../commonwidget/commontextfield_obs_false_p.dart';
// import '../commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
// import '../commonwidget/toast.dart';
// import '../home/authentication_home_p.dart';
//
// class UpdateAddress extends StatefulWidget {
//   final String username;
//   final String usertype;
//   final String jwttoken;
//
//   const UpdateAddress({super.key,required this.username,required this.usertype,
//     required this.jwttoken});
//
//
//   @override
//   State<UpdateAddress> createState() => _UpdateAddressState();
// }
//
// class _UpdateAddressState extends State<UpdateAddress> {
//   final password_cont=TextEditingController();
//   final new_address_cont=TextEditingController();
//   final isloading_cont=Get.put(Isloading());
//
//   Future<int> UpdateAddress({required String username,required String jwttoken,required String password,required String new_address}) async
//   {
//     try
//     {
//       // API endpoint
//       // const String url = "http://10.0.2.2:5074/api/Profile/updateaddress";
//       const String url = Backend_Server_Url+"api/Profile/updateaddress";
//       Map<String, dynamic> update_data =
//       {
//         "Username": username,
//         "Password":password,
//         "NewAddress":new_address,
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
//         print("User authenticated");
//         //success
//         return 0;
//       }
//       else if(response.statusCode==502)
//       {
//         return 1;  //old password mistake
//       }
//       else if(response.statusCode==503)
//       {
//         return 5;  //user doesn't exist.
//       }
//       else if(response.statusCode==501)
//       {
//         return 3;  //exception caught in backend
//       }
//       else if(response.statusCode==500)
//       {
//         return 6;  // validation error in backend
//       }
//       else if(response.statusCode==504)
//       {
//         return 7;  // old address and new address same
//       }
//       else if(response.statusCode==400)
//       {
//         return 9;  //details validation error
//       }
//       else if(response.statusCode==401)
//       {
//         return 10;  // jwt error
//       }
//       else if(response.statusCode==403)
//       {
//         return 11;  // jwt error
//       }
//       else
//       {
//         print("Error.other status code.");
//         return 4;
//       }
//     } catch (obj) {
//       print("Exception caught while fetching user data for profile screen");
//       print(obj.toString());
//       return 2;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     var shortestval=MediaQuery.of(context).size.shortestSide;
//     var widthval=MediaQuery.of(context).size.width;
//     var heightval=MediaQuery.of(context).size.height;
//     return Scaffold
//       (
//       appBar: AppBar(
//         title: Text("Update Address"),
//       ),
//       body:
//       Container(
//         width:widthval,
//         height: heightval,
//         color: Colors.white10,
//         child:
//         Center(
//           child: Container(
//             width: widthval,
//             height: heightval*0.41,
//             decoration: BoxDecoration(
//               color: Colors.grey,
//               borderRadius: BorderRadius.all(Radius.circular(shortestval*0.04)),
//             ),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               physics: BouncingScrollPhysics(),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children:
//                   [
//                     CommonTextField_obs_false_p("Enter your password", "xxxxx", false, password_cont, context),
//                     CommonTextField_obs_false_p("Enter new address.", "xxxxx", false, new_address_cont, context),
//                     Center(
//                       child: CommonButton_loading(label: "Update", onPressed:()async
//                       {
//                         try {
//                           isloading_cont.isloading.value=true;
//                           if (widget.usertype == "user") {
//                             var update_process_result = await UpdateAddress(username:widget.username,
//                                 jwttoken: widget.jwttoken,password:password_cont.text.toString(),new_address: new_address_cont.text.toString() );
//                             print("update result");
//                             print(update_process_result);
//                             if (update_process_result == 0) {
//                               //succes update address
//                               isloading_cont.isloading.value=false;
//                               Toastget().Toastmsg("Update address success.");
//                               return;
//                             }
//                             else if (update_process_result == 1)
//                             {
//                               //old password mistake
//                               isloading_cont.isloading.value=false;
//                               Toastget().Toastmsg("Old password mistake.Update fail.");
//                               return;
//                             }
//                             else if (update_process_result == 2) {
//                               isloading_cont.isloading.value=false;
//                               // Toastget().Toastmsg("exception in http method.");
//                               Toastget().Toastmsg("Update address fail.Try again.Recheck details.");
//                               return;
//                             }
//                             else if (update_process_result == 3)
//                             {
//                               isloading_cont.isloading.value=false;
//                               // Toastget().Toastmsg("exception in backend.Update fail.");
//                               Toastget().Toastmsg("Update address fail.Try again.Recheck details.");
//                               return;
//                             }
//                             else if (update_process_result == 4)
//                             {
//                               //other http satus code
//                               await clearUserData();
//                               isloading_cont.isloading.value=false;
//                               Toastget().Toastmsg("Update address faiL.Relogin and try again.");
//                               Navigator.pushReplacement(
//                                   context, MaterialPageRoute(builder: (context) {
//                                 return AuthenticationHome();
//                               },
//                               )
//                               );
//                               return;
//                             }
//                             else if (update_process_result == 5)
//                             {
//                               //username don't match in backend.user doesn't exist.
//                               await clearUserData();
//                               isloading_cont.isloading.value=false;
//                               Toastget().Toastmsg("Update address faiL.Relogin and try again.");
//                               Navigator.pushReplacement(
//                                   context, MaterialPageRoute(builder: (context) {
//                                 return AuthenticationHome();
//                               },
//                               )
//                               );
//                               return;
//                             }
//                             else if (update_process_result == 6)
//                             {
//                               //validation error in abckend
//                               isloading_cont.isloading.value=false;
//                               Toastget().Toastmsg("Provide details format correct.Password must have 6 letter with 1 number and symbol.");
//                               return;
//                             }
//                             else if (update_process_result == 7)
//                             {
//                               //old address and new address same
//                               isloading_cont.isloading.value=false;
//                               Toastget().Toastmsg("Provide different address then before and try again..");
//                               return;
//                             }
//                             else if (update_process_result == 9)
//                             {
//                               //details validation error
//                               isloading_cont.isloading.value=false;
//                               Toastget().Toastmsg("Provide details format correct.Password must have 6 letter with 1 number and symbol.");
//                               return;
//                             }
//                             else if (update_process_result == 10 || update_process_result==11)
//                             {
//                               //jwt error
//                               await clearUserData();
//                               isloading_cont.isloading.value=false;
//                               Toastget().Toastmsg("Update address Fail.Relogin and try again");
//                               Navigator.pushReplacement(
//                                   context, MaterialPageRoute(builder: (context) {
//                                 return AuthenticationHome();
//                               },
//                               )
//                               );
//                               return;
//                             }
//                             else
//                             {
//                               //other http sattus code
//                               await clearUserData();
//                               isloading_cont.isloading.value=false;
//                               Toastget().Toastmsg("Update address fail.Relogin and try again");
//                               Navigator.pushReplacement(
//                                   context, MaterialPageRoute(builder: (context) {
//                                 return AuthenticationHome();
//                               },
//                               )
//                               );
//                             }
//                           } else {
//                             //wrong usertype
//                             await clearUserData();
//                             isloading_cont.isloading.value=false;
//                             print("mismatch user.usertype mistake.");
//                             Toastget().Toastmsg("Update address faiL.Relogin and try again.");
//                             Navigator.pushReplacement(
//                                 context, MaterialPageRoute(builder: (context) {
//                               return AuthenticationHome();
//                             },
//                             )
//                             );
//                           }
//                         }catch(obj)
//                         {
//                           isloading_cont.isloading.value=false;
//                           Toastget().Toastmsg("Update faiL.Try again.");
//                         }
//
//                       },
//                         color:Colors.red,
//                         textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
//                         padding: const EdgeInsets.all(12),
//                         borderRadius:25.0,
//                         width: shortestval*0.25,
//                         height: shortestval*0.15,
//                         isLoading: isloading_cont.isloading.value,
//                       ),
//                     ),
//                   ]
//               ),
//             ),
//           ),
//         ),
//       ),
//
//     );
//   }
// }
