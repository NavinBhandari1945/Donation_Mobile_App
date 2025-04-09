import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/commonbutton.dart';
import '../commonwidget/commontextfield_obs_false_p.dart';
import '../commonwidget/toast.dart';
import '../constant/constant.dart';
import '../home/authentication_home_p.dart';

class Delete_Post_P extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Delete_Post_P({super.key, required this.username, required this.usertype, required this.jwttoken});

  @override
  State<Delete_Post_P> createState() => _Delete_Post_PState();
}

class _Delete_Post_PState extends State<Delete_Post_P> with SingleTickerProviderStateMixin {
  final Post_Id_Cont = TextEditingController();
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
    Post_Id_Cont.dispose();
    super.dispose();
  }

  Future<void> checkJWTExpiation() async {
    try {
      print("check jwt called");
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
      print("Exception caught while verifying jwt for admin delete screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleteing temporary directory success.");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  Future<int> Delete_Post({required String Post_Id}) async {
    try {
      const String url = Backend_Server_Url + "api/Admin_Task_/delete_post";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> Body_Dict = {
        "Id": Post_Id,
      };
      final response = await http.delete(Uri.parse(url), headers: headers, body: json.encode(Body_Dict));
      if (response.statusCode == 200) {
        print("Delete post success.");
        return 1;
      } else {
        print("Delete post fail.");
        return 2;
      }
    } catch (obj) {
      print("Exception caught while deleting post.");
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
        title: const Text("Delete Post", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
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
            _buildTextField("Enter the post id to delete", Post_Id_Cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.05),
            _buildDeleteButton(shortestval, widthval),
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
                  _buildTextField("Enter the post id to delete", Post_Id_Cont, shortestval, widthval * 0.65),
                ],
              ),
            ),
            SizedBox(width: shortestval * 0.03),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDeleteButton(shortestval, widthval * 0.25),
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

  Widget _buildDeleteButton(double shortestval, double width) {
    return Commonbutton(
      "Delete",
          () async {
        int result = await Delete_Post(Post_Id: Post_Id_Cont.text.toString());
        if (result == 1) {
          Toastget().Toastmsg("Delete post success.");
        } else {
          Toastget().Toastmsg("Delete post fail.");
        }
      },
      context,
      Colors.red,
    );
  }
}






// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import '../commonwidget/CommonMethod.dart';
// import '../commonwidget/circular_progress_ind_yellow.dart';
// import '../commonwidget/commonbutton.dart';
// import '../commonwidget/commontextfield_obs_false_p.dart';
// import '../commonwidget/toast.dart';
// import '../constant/constant.dart';
// import '../home/authentication_home_p.dart';
//
// class Delete_Post_P extends StatefulWidget {
//   final String username;
//   final String usertype;
//   final String jwttoken;
//   const Delete_Post_P({super.key,required this.username,required this.usertype,
//     required this.jwttoken});
//
//
//   @override
//   State<Delete_Post_P> createState() => _Delete_Post_PState();
// }
//
// class _Delete_Post_PState extends State<Delete_Post_P> {
//   final Post_Id_Cont=TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     checkJWTExpiation();
//   }
//
//   Future<void> checkJWTExpiation()async {
//     try {
//       print("check jwt called");
//       int result = await checkJwtToken_initistate_admin(
//           widget.username, widget.usertype, widget.jwttoken);
//       if (result == 0)
//       {
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
//       print("Exception caught while verifying jwt for admin delete screen.");
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
//   Future<int> Delete_Post({required String Post_Id})async
//   {
//     try {
//       // const String url = "http://10.0.2.2:5074/api/Home/getpostinfo";
//       const String url = Backend_Server_Url+"api/Admin_Task_/delete_post";
//       final headers =
//       {
//         'Authorization': 'Bearer ${widget.jwttoken}',
//         'Content-Type': 'application/json',
//       };
//       Map<String, dynamic> Body_Dict =
//       {
//         "Id": Post_Id,
//       };
//       final response = await http.delete(Uri.parse(url), headers: headers,body: json.encode(Body_Dict));
//       if (response.statusCode == 200)
//       {
//         print("Delete post success.");
//         return 1;
//       }
//       else
//       {
//         print("Delete post fail.");
//         return 2;
//       }
//     } catch (obj)
//     {
//       print("Exception caught while deleting post.");
//       print(obj.toString());
//       return 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var widthval=MediaQuery.of(context).size.width;
//     var heightval=MediaQuery.of(context).size.height;
//     return Scaffold(
//
//         appBar: AppBar(
//           title: Text("Delete post screen."),
//           backgroundColor: Colors.green,
//         ),
//         body:
//         OrientationBuilder(builder: (context, orientation) {
//           if(orientation==Orientation.portrait)
//           {
//             return
//               Container(
//                   width:widthval,
//                   height: heightval,
//                   color: Colors.blueGrey,
//                   child:
//                   Center(
//                     child: Container(
//                       width: widthval,
//                       height: heightval*0.26,
//                       color: Colors.grey,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         physics: BouncingScrollPhysics(),
//                         child: Column(
//                           children:
//                           [
//                             CommonTextField_obs_false_p("Enter the post id to delete.","", false, Post_Id_Cont, context),
//                             Commonbutton("Delete", () async
//                             {
//                               int result=await Delete_Post(Post_Id: Post_Id_Cont.text.toString());
//                               if(result==1)
//                               {
//                                 Toastget().Toastmsg("Delete post success.");
//                               }
//                               else
//                               {
//                                 Toastget().Toastmsg("Delete post fail.");
//                               }
//                             },
//                                 context, Colors.red
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//               );
//           }
//           else if(orientation==Orientation.landscape)
//           {
//             return
//               Container(
//
//               );
//
//           }
//           else{
//             return Circular_pro_indicator_Yellow(context);
//           }
//         },
//         )
//
//     );
//   }
// }
