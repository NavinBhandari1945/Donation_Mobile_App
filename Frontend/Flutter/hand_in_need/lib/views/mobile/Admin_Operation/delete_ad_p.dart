import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:http/http.dart' as http;

import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/commonbutton.dart';
import '../commonwidget/commontextfield_obs_false_p.dart';
import '../commonwidget/toast.dart';
import '../home/home_p.dart';

class Delete_Ad_P extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Delete_Ad_P({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<Delete_Ad_P> createState() => _Delete_Ad_PState();
}

class _Delete_Ad_PState extends State<Delete_Ad_P> {
  final Ad_Id_Cont=TextEditingController();

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
      print("Exception caught while verifying jwt for admin add ad screen.");
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

  Future<int> Delete_Ad({required String Ad_Id})async
  {
    try {
      // const String url = "http://10.0.2.2:5074/api/Home/getpostinfo";
      const String url = "http://192.168.1.65:5074/api/Admin_Task_/delete_ad";
      final headers =
      {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> Body_Dict =
      {
        "Id": Ad_Id,
      };
      final response = await http.delete(Uri.parse(url), headers: headers,body: json.encode(Body_Dict));
      if (response.statusCode == 200)
      {
        print("Delete ad success.");
        return 1;
      }
      else
      {
        print("Delete ad fail.");
        return 2;
      }
    } catch (obj)
    {
      print("Exception caught while deleting ad.");
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
        title: Text("Delete Ad Screen."),
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
                    height: heightval*0.25,
                    color: Colors.grey,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:
                        [
                          CommonTextField_obs_false_p("Enter the ad id to delete.","", false, Ad_Id_Cont, context),
                          Commonbutton("Delete", () async
                          {
                            try {
                              if (Ad_Id_Cont.text
                                  .toString()
                                  .isEmpty) {
                                Toastget().Toastmsg("Insert advertisement Id.");
                                return;
                              }
                              int result = await Delete_Ad(
                                  Ad_Id: Ad_Id_Cont.text.toString());
                              if (result == 1)
                              {
                                Toastget().Toastmsg("Delete ad success.");
                              }
                              else {
                                Toastget().Toastmsg("Delete ad fail.");
                              }
                            }catch(Obj)
                            {
                              print("Exception caught in deleting ad.");
                              print(Obj.toString());
                              Toastget().Toastmsg("Deleting ad fail.Try again.");
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
      ),
    );
  }
}
