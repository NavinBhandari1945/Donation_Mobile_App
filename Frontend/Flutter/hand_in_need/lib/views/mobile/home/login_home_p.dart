import 'package:flutter/material.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/commonbutton.dart';
import '../commonwidget/toast.dart';
import 'home_p.dart';

class Login_HomeScreen extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Login_HomeScreen({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<Login_HomeScreen> createState() => _Login_HomeScreenState();
}

class _Login_HomeScreenState extends State<Login_HomeScreen> {

  Future<void> checkJWTExpiation()async
  {
    try {
      int result = await checkJwtToken_initistate_user(
          widget.username, widget.usertype, widget.jwttoken);
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
      print("Exception caught while naviagating home page of  from initstate of home_login page.");
      print(obj.toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return Home();
      },)
      );
      Toastget().Toastmsg("Error.Relogin please.2");
    }

  }

  @override
  void initState(){
    super.initState();
    checkJWTExpiation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
          appBar: AppBar(
          title: Text("Home Screen 1"),
          backgroundColor: Colors.green,
          ),
      body:
      Container(
        child:
        Commonbutton("logout", ()async
        {
                  try{
                                  await clearUserData();
                                  Toastget().Toastmsg("Logout Success");
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                                  {
                                    return Home();
                                  },
                                  )
                                  );
                  }catch(obj)
                {
                  print("Logout fail.Exception occur.");
                  print("${obj.toString()}");
                  Toastget().Toastmsg("Logout fail.Try again.");
                }
        },
        context, Colors.red),
      ),
    );
  }
}
