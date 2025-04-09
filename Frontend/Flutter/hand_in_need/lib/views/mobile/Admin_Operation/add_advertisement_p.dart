import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/views/mobile/campaign/campaign_screen_p.dart';
import 'package:http/http.dart' as http;
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/commonbutton.dart';
import '../commonwidget/commontextfield_obs_false_p.dart';
import '../commonwidget/getx_cont_pick_single_photo_int.dart';
import '../commonwidget/toast.dart';
import '../constant/constant.dart';
import '../home/authentication_home_p.dart';
import 'getx_cont/select_photo_ad.dart';

class Add_Advertisement_P extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Add_Advertisement_P({super.key, required this.username, required this.usertype, required this.jwttoken});

  @override
  State<Add_Advertisement_P> createState() => _Add_Advertisement_PState();
}

class _Add_Advertisement_PState extends State<Add_Advertisement_P> with SingleTickerProviderStateMixin {
  final Ad_Url_Cont = TextEditingController();
  final Select_Ad_Image_Cont = Get.put(Isloading_select_image_admin_add_ad_screen());
  final Pick_Ad_Photo = Get.put(pick_single_photo_getx_int());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    Select_Ad_Image_Cont.change_isloadingval(false);
    Pick_Ad_Photo.imageBytes.value = null;
    Pick_Ad_Photo.imagePath.value = "";
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
    Ad_Url_Cont.dispose();
    super.dispose();
  }

  Future<void> checkJWTExpiation() async {
    try {
      print("check jwt called");
      int result = await checkJwtToken_initistate_admin(widget.username, widget.usertype, widget.jwttoken);
      if (result == 0) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for admin delete campaign screen.");
      print(obj.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  Future<int> Add_Advertisement({required List<int> Ad_Photo_Bytes, required String Ad_Resources}) async {
    try {
      final String base64Image = base64Encode(Ad_Photo_Bytes);
      const String url = Backend_Server_Url + "api/Admin_Task_/add_ad";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> Body_Dict = {
        "AdPhoto": base64Image,
        "AdUrl": Ad_Resources,
      };
      final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(Body_Dict));
      if (response.statusCode == 200) {
        print("Add advertisement success.");
        return 1;
      } else {
        print("Add advertisement fail.");
        return 2;
      }
    } catch (obj) {
      print("Exception caught while Adding advertisement.");
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
        title: const Text("Add Advertisement", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
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
            _buildTextField("Enter the advertisement resources", Ad_Url_Cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
            _buildSelectImageButton(shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
            _buildAddButton(shortestval, widthval),
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
                  _buildTextField("Enter the advertisement resources", Ad_Url_Cont, shortestval, widthval * 0.65),
                ],
              ),
            ),
            SizedBox(width: shortestval * 0.03),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSelectImageButton(shortestval, widthval * 0.25),
                  SizedBox(height: shortestval * 0.03),
                  _buildAddButton(shortestval, widthval * 0.25),
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

  Widget _buildSelectImageButton(double shortestval, double width) {
    return Obx(
          () => Commonbutton(
        "Select image",
            () async {
          try {
            int result = await Pick_Ad_Photo.pickImage();
            if (result == 1) {
              Select_Ad_Image_Cont.change_isloadingval(true);
              Toastget().Toastmsg("Image select success.");
            } else if (result == 2) {
              Select_Ad_Image_Cont.change_isloadingval(false);
              Toastget().Toastmsg("Image select fail.Only JPEG,PNG,JPG type file can be insert.");
            } else if (result == 3) {
              Select_Ad_Image_Cont.change_isloadingval(false);
              Toastget().Toastmsg("Image select fail.Try again.");
            } else {
              Select_Ad_Image_Cont.change_isloadingval(false);
              Toastget().Toastmsg("Image select fail.Try again.");
            }
          } catch (Obj) {
            Select_Ad_Image_Cont.change_isloadingval(false);
            print("Exception caught in selecting image while adding ad.");
            print(Obj.toString());
            Toastget().Toastmsg("Select image fail.Try again.");
          }
        },
        context,
        Select_Ad_Image_Cont.isloading.value == true ? Colors.green : Colors.red,
      ),
    );
  }

  Widget _buildAddButton(double shortestval, double width) {
    return Commonbutton(
      "Add",
          () async {
        try {
          if (Ad_Url_Cont.text.toString() == null || Ad_Url_Cont.text.toString() == "") {
            Toastget().Toastmsg("Add resources first.Fail.");
            return;
          }
          if (Select_Ad_Image_Cont.isloading.value == false) {
            Toastget().Toastmsg("Image not select.Fail.");
            return;
          }
          int result = await Add_Advertisement(
            Ad_Resources: Ad_Url_Cont.text.toString(),
            Ad_Photo_Bytes: Pick_Ad_Photo.imageBytes.value as List<int>,
          );
          if (result == 1) {
            Toastget().Toastmsg("Add advertisement success.");
          } else {
            Toastget().Toastmsg("Add advertisement fail.");
          }
        } catch (Obj) {
          print("Exception caught in adding ad.");
          print(Obj.toString());
          Toastget().Toastmsg("Adding ad fail.Try again.");
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
// import 'package:hand_in_need/views/mobile/campaign/campaign_screen_p.dart';
// import 'package:http/http.dart' as http;
// import '../commonwidget/CommonMethod.dart';
// import '../commonwidget/circular_progress_ind_yellow.dart';
// import '../commonwidget/commonbutton.dart';
// import '../commonwidget/commontextfield_obs_false_p.dart';
// import '../commonwidget/getx_cont_pick_single_photo_int.dart';
// import '../commonwidget/toast.dart';
// import '../constant/constant.dart';
// import '../home/authentication_home_p.dart';
// import 'getx_cont/select_photo_ad.dart';
//
// class Add_Advertisement_P extends StatefulWidget {
//   final String username;
//   final String usertype;
//   final String jwttoken;
//   const Add_Advertisement_P({super.key,required this.username,required this.usertype,
//     required this.jwttoken});
//   @override
//   State<Add_Advertisement_P> createState() => _Add_Advertisement_PState();
// }
//
// class _Add_Advertisement_PState extends State<Add_Advertisement_P>
// {
//   final Ad_Url_Cont=TextEditingController();
//   final Select_Ad_Image_Cont=Get.put(Isloading_select_image_admin_add_ad_screen());
//   final Pick_Ad_Photo=Get.put(pick_single_photo_getx_int());
//
//   @override
//   void initState() {
//     super.initState();
//     Select_Ad_Image_Cont.change_isloadingval(false);
//     Pick_Ad_Photo.imageBytes.value=null;
//     Pick_Ad_Photo.imagePath.value="";
//     checkJWTExpiation();
//   }
//
//   @override
//   void dispose(){
//     super.dispose();
//     Ad_Url_Cont.dispose();
//   }
//
//   Future<void> checkJWTExpiation()async {
//     try {
//       print("check jwt called");
//       int result = await checkJwtToken_initistate_admin(
//           widget.username, widget.usertype, widget.jwttoken);
//       if (result == 0)
//       {
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
//       print("Exception caught while verifying jwt for admin delete campaign screen.");
//       print(obj.toString());
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) {
//         return AuthenticationHome();
//       },)
//       );
//       Toastget().Toastmsg("Error. Relogin please.");
//     }
//   }
//
//   Future<int> Add_Advertisement({required List<int> Ad_Photo_Bytes,required String Ad_Resources})async
//   {
//     try {
//       final String base64Image =base64Encode(Ad_Photo_Bytes);
//       // const String url = "http://10.0.2.2:5074/api/Home/getpostinfo";
//       const String url = Backend_Server_Url+"api/Admin_Task_/add_ad";
//       final headers =
//       {
//         'Authorization': 'Bearer ${widget.jwttoken}',
//         'Content-Type': 'application/json',
//       };
//       Map<String, dynamic> Body_Dict =
//       {
//         "AdPhoto": base64Image,
//         "AdUrl":Ad_Resources,
//       };
//       final response = await http.post(Uri.parse(url), headers: headers,body: json.encode(Body_Dict));
//       if (response.statusCode == 200)
//       {
//         print("Add advertisement success.");
//         return 1;
//       }
//       else
//       {
//         print("Add advertisement fail.");
//         return 2;
//       }
//     } catch (obj)
//     {
//       print("Exception caught while Adding advertisement.");
//       print(obj.toString());
//       return 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var widthval=MediaQuery.of(context).size.width;
//     var heightval=MediaQuery.of(context).size.height;
//     return Scaffold
//       (
//       appBar: AppBar(
//         title: Text("Add advertisement."),
//         backgroundColor: Colors.green,
//       ),
//       body:
//       OrientationBuilder(builder: (context, orientation) {
//         if(orientation==Orientation.portrait)
//         {
//           return
//             Container(
//                 width:widthval,
//                 height: heightval,
//                 color: Colors.blueGrey,
//                 child:
//                 Center(
//                   child: Container(
//                     width: widthval,
//                     height: heightval*0.3,
//                     color: Colors.grey,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       physics: BouncingScrollPhysics(),
//                       child: Column(
//                         children:
//                         [
//                           CommonTextField_obs_false_p("Enter the advertisement resources.","", false, Ad_Url_Cont, context),
//                           Obx(
//                               ()=>Commonbutton("Select image", () async
//                             {
//                               try {
//                                 int result = await Pick_Ad_Photo.pickImage();
//                                 if (result == 1)
//                                 {
//                                   Select_Ad_Image_Cont.change_isloadingval(true);
//                                   Toastget().Toastmsg("Image select success.");
//                                 }
//                                 else if (result == 2)
//                                 {
//                                   //invalid photo format
//                                   Select_Ad_Image_Cont.change_isloadingval(false);
//                                   Toastget().Toastmsg("Image select fail.Only JPEG,PNG,JPG type file can be insert.");
//                                 }
//                                 else if (result == 3)
//                                 {
//                                   //image not select
//                                   Select_Ad_Image_Cont.change_isloadingval(false);
//                                   Toastget().Toastmsg("Image select fail.Try again.");
//                                 }
//                                 else
//                                 {
//                                   Select_Ad_Image_Cont.change_isloadingval(false);
//                                   Toastget().Toastmsg("Image select fail.Try again.");
//                                 }
//                               }
//                               catch(Obj)
//                               {
//                                 Select_Ad_Image_Cont.change_isloadingval(false);
//                                 print("Exception caught in selecting image while adding ad.");
//                                 print(Obj.toString());
//                                 Toastget().Toastmsg("Select image fail.Try again.");
//                               }
//                             },
//                                 context, Select_Ad_Image_Cont.isloading.value==true?Colors.green:Colors.red
//                             ),
//                           ),
//
//                           Commonbutton("Add", () async
//                           {
//                             try {
//                               if(Ad_Url_Cont.text.toString()==null || Ad_Url_Cont.text.toString()=="" )
//                                 {
//                                   Toastget().Toastmsg("Add resources first.Fail.");
//                                   return;
//                                 }
//                               if(Select_Ad_Image_Cont.isloading.value==false)
//                               {
//                                 Toastget().Toastmsg("Image not select.Fail.");
//                                 return;
//                               }
//                               int result = await Add_Advertisement(
//                                   Ad_Resources: Ad_Url_Cont.text.toString(),
//                                   Ad_Photo_Bytes:Pick_Ad_Photo.imageBytes.value as List<int>);
//                               if (result == 1)
//                               {
//                                 Toastget().Toastmsg(
//                                     "Add advertisement success.");
//                               }
//                               else {
//                                 Toastget().Toastmsg("Add advertisement fail.");
//                               }
//                             }catch(Obj)
//                             {
//                               print("Exception caught in adding ad.");
//                               print(Obj.toString());
//                               Toastget().Toastmsg("Adding ad fail.Try again.");
//                             }
//                           },
//                               context, Colors.red
//                           ),
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
//             Container(
//
//             );
//
//         }
//         else{
//           return Circular_pro_indicator_Yellow(context);
//         }
//       },
//       ),
//     );
//   }
// }
