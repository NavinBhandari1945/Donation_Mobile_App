import 'package:flutter/material.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';

import '../commonwidget/CommonMethod.dart';

import '../commonwidget/toast.dart';
import '../home/home_p.dart';

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

                        // CommonButton_loading(label: label, onPressed: onPressed,
                        //     color: color, textStyle: textStyle, padding: padding, borderRadius: borderRadius, width: width, height: height, isLoading: isLoading
                        // ),

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
