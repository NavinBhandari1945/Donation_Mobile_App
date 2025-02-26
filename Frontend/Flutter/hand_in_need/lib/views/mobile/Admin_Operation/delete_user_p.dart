import 'dart:convert';
import 'package:flutter/material.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/commonbutton.dart';
import '../commonwidget/commontextfield_obs_false_p.dart';
import '../commonwidget/toast.dart';
import '../home/home_p.dart';
import 'package:http/http.dart' as http;

class Delete_User_P extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Delete_User_P({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<Delete_User_P> createState() => _Delete_User_PState();
}

class _Delete_User_PState extends State<Delete_User_P>
{

  final Username_Cont=TextEditingController();

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
          return Home();
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
        return Home();
      },)
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  Future<int> Delete_User({required String Username})async
  {
    try {
      // const String url = "http://10.0.2.2:5074/api/Home/getpostinfo";
      const String url = "http://192.168.1.65:5074/api/Admin_Task_/delete_user";
      final headers =
      {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> usernameDict =
      {
        "Username": Username,
      };
      final response = await http.delete(Uri.parse(url), headers: headers,body: json.encode(usernameDict));
      if (response.statusCode == 200)
      {
        print("Delete user success.");
        return 1;
      }
      else
      {
        print("Delete user fail.");
        return 2;
      }
    } catch (obj)
    {
      print("Exception caught while deleting user.");
      print(obj.toString());
      return 0;
    }
  }

  @override
  Widget build(BuildContext context)
  {
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    return Scaffold
      (
      appBar: AppBar(
        title: Text("Delete user screen."),
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
                          CommonTextField_obs_false_p("Enter the user username to delete.","", false, Username_Cont, context),
                          Commonbutton("Delete", () async
                          {
                            int result=await Delete_User(Username:Username_Cont.text.toString());
                            if(result==1)
                              {
                                Toastget().Toastmsg("Delete user success.");
                              }
                            else
                              {
                                Toastget().Toastmsg("Delete user fail.");
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
