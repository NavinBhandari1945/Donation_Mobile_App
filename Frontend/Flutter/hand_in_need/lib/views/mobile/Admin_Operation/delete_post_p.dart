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
  const Delete_Post_P({super.key,required this.username,required this.usertype,
    required this.jwttoken});


  @override
  State<Delete_Post_P> createState() => _Delete_Post_PState();
}

class _Delete_Post_PState extends State<Delete_Post_P> {
  final Post_Id_Cont=TextEditingController();

  @override
  void initState() {
    super.initState();
    checkJWTExpiation();
  }

  Future<void> checkJWTExpiation()async {
    try {
      print("check jwt called");
      int result = await checkJwtToken_initistate_admin(
          widget.username, widget.usertype, widget.jwttoken);
      if (result == 0)
      {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        print("Deleteing temporary directory success.");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context)
        {
          return AuthenticationHome();
        },)
        );
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    }
    catch(obj) {
      print("Exception caught while verifying jwt for admin delete screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleteing temporary directory success.");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return AuthenticationHome();
      },)
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  Future<int> Delete_Post({required String Post_Id})async
  {
    try {
      // const String url = "http://10.0.2.2:5074/api/Home/getpostinfo";
      const String url = Backend_Server_Url+"api/Admin_Task_/delete_post";
      final headers =
      {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> Body_Dict =
      {
        "Id": Post_Id,
      };
      final response = await http.delete(Uri.parse(url), headers: headers,body: json.encode(Body_Dict));
      if (response.statusCode == 200)
      {
        print("Delete post success.");
        return 1;
      }
      else
      {
        print("Delete post fail.");
        return 2;
      }
    } catch (obj)
    {
      print("Exception caught while deleting post.");
      print(obj.toString());
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    return Scaffold(

        appBar: AppBar(
          title: Text("Delete post screen."),
          backgroundColor: Colors.green,
        ),
        body:
        OrientationBuilder(builder: (context, orientation) {
          if(orientation==Orientation.portrait)
          {
            return
              Container(
                  width:widthval,
                  height: heightval,
                  color: Colors.blueGrey,
                  child:
                  Center(
                    child: Container(
                      width: widthval,
                      height: heightval*0.26,
                      color: Colors.grey,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children:
                          [
                            CommonTextField_obs_false_p("Enter the post id to delete.","", false, Post_Id_Cont, context),
                            Commonbutton("Delete", () async
                            {
                              int result=await Delete_Post(Post_Id: Post_Id_Cont.text.toString());
                              if(result==1)
                              {
                                Toastget().Toastmsg("Delete post success.");
                              }
                              else
                              {
                                Toastget().Toastmsg("Delete post fail.");
                              }
                            },
                                context, Colors.red
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

              );

          }
          else{
            return Circular_pro_indicator_Yellow(context);
          }
        },
        )

    );
  }
}
