import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'package:hand_in_need/views/mobile/home/authentication_home_p.dart';
import 'package:http/http.dart' as http;
import '../commonwidget/CommonMethod.dart';

class Updatepassword extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Updatepassword({super.key, required this.username, required this.usertype, required this.jwttoken});

  @override
  State<Updatepassword> createState() => _UpdatepasswordState();
}

class _UpdatepasswordState extends State<Updatepassword> with SingleTickerProviderStateMixin {
  final old_password_cont = TextEditingController();
  final new_password_cont = TextEditingController();
  final isloading_update_password_cont = Get.put(Isloading());
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
    old_password_cont.dispose();
    new_password_cont.dispose();
    super.dispose();
  }

  Future<int> UpdatePhoto({
    required String username,
    required String jwttoken,
    required String old_password,
    required String new_password,
  }) async {
    try {
      const String url = Backend_Server_Url + "api/Profile/updatepassword";
      Map<String, dynamic> update_data = {
        "Username": username,
        "OldPassword": old_password,
        "NewPassword": new_password,
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
        return 6; // details validation fail
      } else if (response.statusCode == 400) {
        return 9; // details validation fail
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
        title: const Text("Update Password", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
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
            _buildTextField("Enter old password", old_password_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
            _buildTextField("Enter new password", new_password_cont, shortestval, widthval),
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
                  _buildTextField("Enter old password", old_password_cont, shortestval, widthval * 0.65),
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
      child: CommonTextField_obs_false_p(hint, "xxxxx", false, controller, context),
    );
  }

  Widget _buildUpdateButton(double shortestval, double width) {
    return CommonButton_loading(
      label: "Update",
      onPressed: () async {
        try {
          isloading_update_password_cont.isloading.value = true;
          if (widget.usertype == "user") {
            if (old_password_cont.text.toString() == new_password_cont.text.toString()) {
              isloading_update_password_cont.isloading.value = false;
              Toastget().Toastmsg("Old password and New password same.");
              return;
            }
            var update_process_result = await UpdatePhoto(
              username: widget.username,
              jwttoken: widget.jwttoken,
              new_password: new_password_cont.text.toString(),
              old_password: old_password_cont.text.toString(),
            );
            print("update result");
            print(update_process_result);

            if (update_process_result == 0) {
              isloading_update_password_cont.isloading.value = false;
              Toastget().Toastmsg("Update password success.");
            } else if (update_process_result == 1) {
              isloading_update_password_cont.isloading.value = false;
              Toastget().Toastmsg("Old password mistake.Update fail.");
            } else if (update_process_result == 2) {
              isloading_update_password_cont.isloading.value = false;
              Toastget().Toastmsg("Update password Fail.Try again");
            } else if (update_process_result == 3) {
              isloading_update_password_cont.isloading.value = false;
              Toastget().Toastmsg("Update password Fail.Try again");
            } else if (update_process_result == 4) {
              await clearUserData();
              isloading_update_password_cont.isloading.value = false;
              Toastget().Toastmsg("Update password faiL.Relogin and try again.");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
              return;
            } else if (update_process_result == 5) {
              isloading_update_password_cont.isloading.value = false;
              Toastget().Toastmsg("Update password Fail.Try again");
            } else if (update_process_result == 6) {
              isloading_update_password_cont.isloading.value = false;
              Toastget().Toastmsg("Provide details format correct.Password must have 6 letter with 1 number and symbol.");
            } else if (update_process_result == 9) {
              isloading_update_password_cont.isloading.value = false;
              Toastget().Toastmsg("Provide details format correct.Password must have 6 letter with 1 number and symbol.");
            } else if (update_process_result == 10 || update_process_result == 11) {
              await clearUserData();
              isloading_update_password_cont.isloading.value = false;
              Toastget().Toastmsg("Update password Fail.Relogin and try again");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
            } else {
              await clearUserData();
              isloading_update_password_cont.isloading.value = false;
              Toastget().Toastmsg("Update password Fail.Relogin and try again");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
            }
          } else {
            await clearUserData();
            isloading_update_password_cont.isloading.value = false;
            Toastget().Toastmsg("Update password Fail.Relogin and try again");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
          }
        } catch (obj) {
          isloading_update_password_cont.isloading.value = false;
          Toastget().Toastmsg("Update faiL.Try again.");
        }
      },
      color: Colors.red,
      textStyle: TextStyle(color: Colors.white, fontSize: shortestval * 0.04, fontWeight: FontWeight.bold),
      padding: EdgeInsets.all(shortestval * 0.03),
      borderRadius: 25.0,
      width: width,
      height: shortestval * 0.15,
      isLoading: isloading_update_password_cont.isloading.value,
    );
  }
}




