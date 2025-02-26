import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
import '../home/home_p.dart';
import '../home/getx_cont/isloading_logout_button_admin.dart';
import 'feedback_screen_p.dart';

class AdminHome extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const AdminHome({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final LogoutButton_Loading_Cont=Get.put(Isloading_logout_button_admin_screen());

  @override
  void initState()
  {
    super.initState();
    checkJWTExpiation();
  }

  Future<void> checkJWTExpiation()async {
    try {
      print("check jwt called in admin home screen.");
      int result = await checkJwtToken_initistate_admin(
          widget.username, widget.usertype, widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        print("Deleteing temporary directory success.");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context)
        {
          return Home();
        },)
        );
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    }
    catch(obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleteing temporary directory success.");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return Home();
      },)
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }
  @override
  Widget build(BuildContext context) {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Home"),
        backgroundColor: Colors.green,
      ),
      body:
      OrientationBuilder(builder: (context, orientation) {
        if(orientation==Orientation.portrait)
        {
          return
            Container(
              color: Colors.teal,
              height: heightval,
              width: widthval,
              child:
              Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                            children:
                            [

                              Expanded(
                                child: Text("Delete user.",style:
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
                                    child: Icon(Icons.delete)),
                              ),

                            ],
                          )
                      ).onTap(()
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context)
                        {
                          return Delete_User_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
                        },
                        )
                        );
                      }
                      ),
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
                                child: Text("Delete post.",style:
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
                                    child: Icon(Icons.delete)),
                              ),

                            ],
                          )
                      ).onTap (()
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context)
                        {
                          return Delete_Post_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
                        },
                        )
                        );
                      }
                      ),

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
                                child: Text("Delete campaign.",style:
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
                                    child: Icon(Icons.delete)),
                              ),

                            ],
                          )
                      ).onTap (()
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context)
                        {
                          return Delete_Campaign_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
                        },
                        )
                        );
                      }
                      ),

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
                                child: Text("Add advertisement.",style:
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
                                    child: Icon(Icons.add)),
                              ),

                            ],
                          )
                      ).onTap (()
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context)
                        {
                          return Add_Advertisement_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
                        },
                        )
                        );
                      }
                      ),

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
                                child: Text("Delete advertisement.",style:
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
                                    child: Icon(Icons.delete)),
                              ),

                            ],
                          )
                      ).onTap (()
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context)
                        {
                          return Delete_Ad_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
                        },
                        )
                        );
                      }
                      ),

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
                                child: Text("See feedback.",style:
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
                                    child: Icon(Icons.delete)),
                              ),

                            ],
                          )
                      ).onTap (()
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context)
                        {
                          return Feedback_Screen_Ui(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
                        },
                        )
                        );
                      }
                      ),

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
                                child: Text("Update user password.",style:
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
                                    child: Icon(Icons.delete)),
                              ),

                            ],
                          )
                      ).onTap (()
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context)
                        {
                          return admin_Update_password_P(usertype: widget.usertype,username: widget.username,jwttoken: widget.jwttoken,);
                        },
                        )
                        );
                      }
                      ),

                      Center(
                        child: Container(
                          child:
                          ElevatedButton (
                            onPressed:
                                () async
                            {
                              try{
                                LogoutButton_Loading_Cont.change_isloadingval(true);
                                await clearUserData();
                                await deleteTempDirectoryPostVideo();
                                await deleteTempDirectoryCampaignVideo();
                                print("Deleteing temporary directory success.");
                                LogoutButton_Loading_Cont.change_isloadingval(false);
                                Toastget().Toastmsg("Logout Success");
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                                {
                                  return Home();
                                },
                                )
                                );
                              }catch(obj)
                              {
                                LogoutButton_Loading_Cont.change_isloadingval(false);
                                print("Logout fail.Exception occur.");
                                print("${obj.toString()}");
                                Toastget().Toastmsg("Logout fail.Try again.");
                              }
                            }
                            ,
                            child:LogoutButton_Loading_Cont.isloading.value==true?Circular_pro_indicator_Yellow(context):Text("Log Out",style:
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
        else if(orientation==Orientation.landscape)
        {
          return
            Container(

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
