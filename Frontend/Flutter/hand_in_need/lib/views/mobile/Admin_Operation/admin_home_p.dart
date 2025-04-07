import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constant/styles.dart';
import 'add_advertisement_p.dart';
import 'admin_Update_Password_p.dart';
import 'delete_ad_p.dart';
import 'delete_campaign_p.dart';
import 'delete_post_p.dart';
import 'delete_user_p.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/toast.dart';
import '../home/authentication_home_p.dart';
import '../home/getx_cont/isloading_logout_button_admin.dart';
import 'feedback_screen_p.dart';

class AdminHome extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const AdminHome({super.key, required this.username, required this.usertype, required this.jwttoken});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> with SingleTickerProviderStateMixin {
  final LogoutButton_Loading_Cont = Get.put(Isloading_logout_button_admin_screen());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    checkJWTExpiation();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> checkJWTExpiation() async {
    try {
      print("check jwt called in admin home screen.");
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
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleteing temporary directory success.");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
      Toastget().Toastmsg("Error. Relogin please.");
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
          "Admin Dashboard",
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
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(shortestval * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAdminOption(
                          title: "Delete User",
                          icon: Icons.person_remove,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Delete_User_P(
                                usertype: widget.usertype,
                                username: widget.username,
                                jwttoken: widget.jwttoken,
                              ),
                            ),
                          ),
                        ),
                        _buildAdminOption(
                          title: "Delete Post",
                          icon: Icons.post_add_outlined,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Delete_Post_P(
                                usertype: widget.usertype,
                                username: widget.username,
                                jwttoken: widget.jwttoken,
                              ),
                            ),
                          ),
                        ),
                        _buildAdminOption(
                          title: "Delete Campaign",
                          icon: Icons.campaign_outlined,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Delete_Campaign_P(
                                usertype: widget.usertype,
                                username: widget.username,
                                jwttoken: widget.jwttoken,
                              ),
                            ),
                          ),
                        ),
                        _buildAdminOption(
                          title: "Add Advertisement",
                          icon: Icons.add_circle_outline,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Add_Advertisement_P(
                                usertype: widget.usertype,
                                username: widget.username,
                                jwttoken: widget.jwttoken,
                              ),
                            ),
                          ),
                        ),
                        _buildAdminOption(
                          title: "Delete Advertisement",
                          icon: Icons.delete_sweep_outlined,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Delete_Ad_P(
                                usertype: widget.usertype,
                                username: widget.username,
                                jwttoken: widget.jwttoken,
                              ),
                            ),
                          ),
                        ),
                        _buildAdminOption(
                          title: "See Feedback",
                          icon: Icons.feedback_outlined,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Feedback_Screen_Ui(
                                usertype: widget.usertype,
                                username: widget.username,
                                jwttoken: widget.jwttoken,
                              ),
                            ),
                          ),
                        ),
                        _buildAdminOption(
                          title: "Update User Password",
                          icon: Icons.lock_reset,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => admin_Update_password_P(
                                usertype: widget.usertype,
                                username: widget.username,
                                jwttoken: widget.jwttoken,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: shortestval * 0.04),
                        _buildLogoutButton(),
                      ],
                    ),
                  ),
                ),
              );
            } else if (orientation == Orientation.landscape) {
              return Container();
            }
            return Center(child: Circular_pro_indicator_Yellow(context));
          },
        ),
      ),
    );
  }

  Widget _buildAdminOption({required String title, required IconData icon, required VoidCallback onTap}) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widthval,
      margin: EdgeInsets.symmetric(vertical: shortestval * 0.02),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(shortestval * 0.03),
            child: Row(
              children: [
                Icon(icon, color: Colors.green[700], size: shortestval * 0.07),
                SizedBox(width: shortestval * 0.04),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: semibold,
                      color: Colors.grey[800],
                      fontSize: shortestval * 0.045,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: shortestval * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;

    return Center(
      child: ElevatedButton(
        onPressed: _logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[600],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(horizontal: shortestval * 0.1, vertical: shortestval * 0.04),
        ),
        child: Obx(
              () => LogoutButton_Loading_Cont.isloading.value
              ? Circular_pro_indicator_Yellow(context)
              : Text(
            "Log Out",
            style: TextStyle(
              fontFamily: bold,
              color: Colors.white,
              fontSize: shortestval * 0.045,
            ),
          ),
        ),
      ),
    );
  }

  void _logout() async {
    try {
      LogoutButton_Loading_Cont.change_isloadingval(true);
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleting temporary directory success.");
      Toastget().Toastmsg("Logout Success");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
    } catch (obj) {
      print("Logout fail. Exception occur.");
      print("${obj.toString()}");
      Toastget().Toastmsg("Logout fail. Try again.");
    } finally {
      LogoutButton_Loading_Cont.change_isloadingval(false);
    }
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../../constant/styles.dart';
// import 'add_advertisement_p.dart';
// import 'admin_Update_Password_p.dart';
// import 'delete_ad_p.dart';
// import 'delete_campaign_p.dart';
// import 'delete_post_p.dart';
// import 'delete_user_p.dart';
// import '../commonwidget/CommonMethod.dart';
// import '../commonwidget/circular_progress_ind_yellow.dart';
// import '../commonwidget/toast.dart';
// import '../home/authentication_home_p.dart';
// import '../home/getx_cont/isloading_logout_button_admin.dart';
// import 'feedback_screen_p.dart';
//
// class AdminHome extends StatefulWidget {
//   final String username;
//   final String usertype;
//   final String jwttoken;
//   const AdminHome({super.key,required this.username,required this.usertype,
//     required this.jwttoken});
//   @override
//   State<AdminHome> createState() => _AdminHomeState();
// }
//
// class _AdminHomeState extends State<AdminHome> {
//   final LogoutButton_Loading_Cont=Get.put(Isloading_logout_button_admin_screen());
//
//   @override
//   void initState()
//   {
//     super.initState();
//     checkJWTExpiation();
//   }
//
//   Future<void> checkJWTExpiation()async {
//     try {
//       print("check jwt called in admin home screen.");
//       int result = await checkJwtToken_initistate_admin(
//           widget.username, widget.usertype, widget.jwttoken);
//       if (result == 0) {
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
//       print("Exception caught while verifying jwt for admin home screen.");
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
//   @override
//   Widget build(BuildContext context) {
//     var shortestval=MediaQuery.of(context).size.shortestSide;
//     var widthval=MediaQuery.of(context).size.width;
//     var heightval=MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Admin Home"),
//         backgroundColor: Colors.green,
//       ),
//       body:
//       OrientationBuilder(builder: (context, orientation) {
//         if(orientation==Orientation.portrait)
//         {
//           return
//             Container(
//               color: Colors.teal,
//               height: heightval,
//               width: widthval,
//               child:
//               Center(
//                 child: SingleChildScrollView(
//                   physics: BouncingScrollPhysics(),
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Container (
//                           width: widthval,
//                           height: heightval*0.06,
//                           decoration: BoxDecoration(
//                             color: Colors.blueGrey,
//                             border: Border.all(
//                               color: Colors.blue,
//                               width: shortestval*0.0080,
//                               style: BorderStyle.solid,
//                             ),
//                             borderRadius: BorderRadius.circular(shortestval*0.03),
//                           ),
//                           child:
//                           Row(
//                             children:
//                             [
//
//                               Expanded(
//                                 child: Text("Delete user.",style:
//                                 TextStyle(
//                                     fontFamily: semibold,
//                                     color: Colors.black,
//                                     fontSize: shortestval*0.06
//                                 ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(right: shortestval*0.05),
//                                 child: Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Icon(Icons.delete)),
//                               ),
//
//                             ],
//                           )
//                       ).onTap(()
//                       {
//                         Navigator.push(context,MaterialPageRoute(builder: (context)
//                         {
//                           return Delete_User_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
//                         },
//                         )
//                         );
//                       }
//                       ),
//                       Container (
//                           width: widthval,
//                           height: heightval*0.06,
//                           decoration: BoxDecoration(
//                             color: Colors.blueGrey,
//                             border: Border.all(
//                               color: Colors.blue,
//                               width: shortestval*0.0080,
//                               style: BorderStyle.solid,
//                             ),
//                             borderRadius: BorderRadius.circular(shortestval*0.03),
//                           ),
//                           child:
//                           Row(
//                             children: [
//
//                               Expanded(
//                                 child: Text("Delete post.",style:
//                                 TextStyle(
//                                     fontFamily: semibold,
//                                     color: Colors.black,
//                                     fontSize: shortestval*0.06
//                                 ),
//                                 ),
//                               ),
//
//                               Padding(
//                                 padding: EdgeInsets.only(right: shortestval*0.05),
//                                 child: Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Icon(Icons.delete)),
//                               ),
//
//                             ],
//                           )
//                       ).onTap (()
//                       {
//                         Navigator.push(context,MaterialPageRoute(builder: (context)
//                         {
//                           return Delete_Post_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
//                         },
//                         )
//                         );
//                       }
//                       ),
//
//                       Container (
//                           width: widthval,
//                           height: heightval*0.06,
//                           decoration: BoxDecoration(
//                             color: Colors.blueGrey,
//                             border: Border.all(
//                               color: Colors.blue,
//                               width: shortestval*0.0080,
//                               style: BorderStyle.solid,
//                             ),
//                             borderRadius: BorderRadius.circular(shortestval*0.03),
//                           ),
//                           child:
//                           Row(
//                             children: [
//
//                               Expanded(
//                                 child: Text("Delete campaign.",style:
//                                 TextStyle(
//                                     fontFamily: semibold,
//                                     color: Colors.black,
//                                     fontSize: shortestval*0.06
//                                 ),
//                                 ),
//                               ),
//
//                               Padding(
//                                 padding: EdgeInsets.only(right: shortestval*0.05),
//                                 child: Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Icon(Icons.delete)),
//                               ),
//
//                             ],
//                           )
//                       ).onTap (()
//                       {
//                         Navigator.push(context,MaterialPageRoute(builder: (context)
//                         {
//                           return Delete_Campaign_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
//                         },
//                         )
//                         );
//                       }
//                       ),
//
//                       Container (
//                           width: widthval,
//                           height: heightval*0.06,
//                           decoration: BoxDecoration(
//                             color: Colors.blueGrey,
//                             border: Border.all(
//                               color: Colors.blue,
//                               width: shortestval*0.0080,
//                               style: BorderStyle.solid,
//                             ),
//                             borderRadius: BorderRadius.circular(shortestval*0.03),
//                           ),
//                           child:
//                           Row(
//                             children: [
//
//                               Expanded(
//                                 child: Text("Add advertisement.",style:
//                                 TextStyle(
//                                     fontFamily: semibold,
//                                     color: Colors.black,
//                                     fontSize: shortestval*0.06
//                                 ),
//                                 ),
//                               ),
//
//                               Padding(
//                                 padding: EdgeInsets.only(right: shortestval*0.05),
//                                 child: Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Icon(Icons.add)),
//                               ),
//
//                             ],
//                           )
//                       ).onTap (()
//                       {
//                         Navigator.push(context,MaterialPageRoute(builder: (context)
//                         {
//                           return Add_Advertisement_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
//                         },
//                         )
//                         );
//                       }
//                       ),
//
//                       Container (
//                           width: widthval,
//                           height: heightval*0.06,
//                           decoration: BoxDecoration(
//                             color: Colors.blueGrey,
//                             border: Border.all(
//                               color: Colors.blue,
//                               width: shortestval*0.0080,
//                               style: BorderStyle.solid,
//                             ),
//                             borderRadius: BorderRadius.circular(shortestval*0.03),
//                           ),
//                           child:
//                           Row(
//                             children: [
//
//                               Expanded(
//                                 child: Text("Delete advertisement.",style:
//                                 TextStyle(
//                                     fontFamily: semibold,
//                                     color: Colors.black,
//                                     fontSize: shortestval*0.06
//                                 ),
//                                 ),
//                               ),
//
//                               Padding(
//                                 padding: EdgeInsets.only(right: shortestval*0.05),
//                                 child: Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Icon(Icons.delete)),
//                               ),
//
//                             ],
//                           )
//                       ).onTap (()
//                       {
//                         Navigator.push(context,MaterialPageRoute(builder: (context)
//                         {
//                           return Delete_Ad_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
//                         },
//                         )
//                         );
//                       }
//                       ),
//
//                       Container (
//                           width: widthval,
//                           height: heightval*0.06,
//                           decoration: BoxDecoration(
//                             color: Colors.blueGrey,
//                             border: Border.all(
//                               color: Colors.blue,
//                               width: shortestval*0.0080,
//                               style: BorderStyle.solid,
//                             ),
//                             borderRadius: BorderRadius.circular(shortestval*0.03),
//                           ),
//                           child:
//                           Row(
//                             children: [
//
//                               Expanded(
//                                 child: Text("See feedback.",style:
//                                 TextStyle(
//                                     fontFamily: semibold,
//                                     color: Colors.black,
//                                     fontSize: shortestval*0.06
//                                 ),
//                                 ),
//                               ),
//
//                               Padding(
//                                 padding: EdgeInsets.only(right: shortestval*0.05),
//                                 child: Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Icon(Icons.delete)),
//                               ),
//
//                             ],
//                           )
//                       ).onTap (()
//                       {
//                         Navigator.push(context,MaterialPageRoute(builder: (context)
//                         {
//                           return Feedback_Screen_Ui(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
//                         },
//                         )
//                         );
//                       }
//                       ),
//
//                       Container (
//                           width: widthval,
//                           height: heightval*0.06,
//                           decoration: BoxDecoration(
//                             color: Colors.blueGrey,
//                             border: Border.all(
//                               color: Colors.blue,
//                               width: shortestval*0.0080,
//                               style: BorderStyle.solid,
//                             ),
//                             borderRadius: BorderRadius.circular(shortestval*0.03),
//                           ),
//                           child:
//                           Row(
//                             children: [
//
//                               Expanded(
//                                 child: Text("Update user password.",style:
//                                 TextStyle(
//                                     fontFamily: semibold,
//                                     color: Colors.black,
//                                     fontSize: shortestval*0.06
//                                 ),
//                                 ),
//                               ),
//
//                               Padding(
//                                 padding: EdgeInsets.only(right: shortestval*0.05),
//                                 child: Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Icon(Icons.delete)),
//                               ),
//
//                             ],
//                           )
//                       ).onTap (()
//                       {
//                         Navigator.push(context,MaterialPageRoute(builder: (context)
//                         {
//                           return admin_Update_password_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
//                         },
//                         )
//                         );
//                       }
//                       ),
//
//                       Center(
//                         child: Container(
//                           child:
//                           ElevatedButton (
//                             onPressed:
//                                 () async
//                             {
//                               try{
//                                 LogoutButton_Loading_Cont.change_isloadingval(true);
//                                 await clearUserData();
//                                 await deleteTempDirectoryPostVideo();
//                                 await deleteTempDirectoryCampaignVideo();
//                                 print("Deleteing temporary directory success.");
//                                 LogoutButton_Loading_Cont.change_isloadingval(false);
//                                 Toastget().Toastmsg("Logout Success");
//                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
//                                 {
//                                   return AuthenticationHome();
//                                 },
//                                 )
//                                 );
//                               }catch(obj)
//                               {
//                                 LogoutButton_Loading_Cont.change_isloadingval(false);
//                                 print("Logout fail.Exception occur.");
//                                 print("${obj.toString()}");
//                                 Toastget().Toastmsg("Logout fail.Try again.");
//                               }
//                             }
//                             ,
//                             child:LogoutButton_Loading_Cont.isloading.value==true?Circular_pro_indicator_Yellow(context):Text("Log Out",style:
//                             TextStyle(
//                                 fontFamily: semibold,
//                                 color: Colors.blue,
//                                 fontSize: shortestval*0.05
//                             ),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.lightGreenAccent,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(shortestval*0.03),
//                                 )
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
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
