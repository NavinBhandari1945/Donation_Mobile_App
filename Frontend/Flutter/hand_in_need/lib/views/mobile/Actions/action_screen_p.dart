import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hand_in_need/views/mobile/Actions/InsertPostScreen_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';

import '../commonwidget/CommonMethod.dart';

import '../commonwidget/toast.dart';
import '../home/home_p.dart';
import 'InsertCampaignScreen_p.dart';

class ActionScreen extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const ActionScreen({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {

  final isLoadingCont=Get.put(Isloading());
  @override
  void initState(){
    super.initState();
    checkJWTExpiation();
  }

  Future<void> checkJWTExpiation()async
  {
    try {
      int result = await checkJwtToken_initistate_user(
          widget.username, widget.usertype, widget.jwttoken);
      print(widget.jwttoken);
      if (result == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) {
          return Home();
        },)
        );
        Toastget().Toastmsg("Session End.Relogin please.");
      }
    }
    catch(obj)
    {
      print("Exception caught while naviagting index login home to actions page.");
      print(obj.toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return Home();
      },)
      );
      Toastget().Toastmsg("Error.Relogin please.");
    }

  }

  @override
  Widget build(BuildContext context) {
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    var shortestval=MediaQuery.of(context).size.shortestSide;
    return Scaffold
      (
        appBar: AppBar(
          title: Text("Action Screen"),
          backgroundColor: Colors.green,
        ),
        body:OrientationBuilder(builder: (context, orientation)
        {
          if(orientation==Orientation.portrait)
          {
            return
              Container(
                  width:widthval,
                  height: heightval,
                  color: Colors.grey,
                  child:
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children:
                      [


                        Row(
                          children: [

                            CommonButton_loading(label: "Insert Post",
                                onPressed: ()
                                {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return Insertpostscreen(username: widget.username, usertype: widget.usertype, jwttoken:widget.jwttoken);
                                    },
                                    )
                                    );
                                },

                              color:Colors.red,
                              textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
                              padding: const EdgeInsets.all(12),
                              borderRadius:25.0,
                              width: shortestval*0.35,
                              height: shortestval*0.15,
                              isLoading: isLoadingCont.isloading.value,
                            ),

                            CommonButton_loading(label: "Insert Campaign",
                              onPressed: ()
                              {
                                
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return InsertcampaignscreenP(username: widget.username, usertype: widget.usertype, jwttoken:widget.jwttoken);
                                },
                                )
                                );
                              },

                              color:Colors.red,
                              textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
                              padding: const EdgeInsets.all(12),
                              borderRadius:25.0,
                              width: shortestval*0.35,
                              height: shortestval*0.15,
                              isLoading: isLoadingCont.isloading.value,
                            ),


                          ],
                        ),

                      ],
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
          else
          {
            return CircularProgressIndicator();
          }
        },
        ),
    );
  }
}
