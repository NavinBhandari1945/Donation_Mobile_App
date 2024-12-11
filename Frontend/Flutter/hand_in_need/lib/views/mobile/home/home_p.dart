import 'package:flutter/material.dart';
import 'package:hand_in_need/views/mobile/authentication/Login_Screen_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';

import '../authentication/sign_up_user_p.dart';
import '../commonwidget/circularprogressind.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future SignInUser() async{


  }

  @override
  Widget build(BuildContext context) {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        backgroundColor: Colors.green,
        actions:
        [

          Commonbutton("Login",(){
            Navigator.push(context,MaterialPageRoute(builder: (context) {
              return LoginScreen();
            },
            )
            );


          }, context,Colors.red),

          SizedBox(width: shortestval*0.01,),

          Commonbutton("SignUp",(){
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
              return SignUpScreen();
            },
            )
            );


          }, context,Colors.red)

        ],
      ),
      body:
      OrientationBuilder(builder: (context, orientation) {
        if(orientation==Orientation.portrait)
        {
          return
            Container(
              width:widthval,
              height: heightval,
              color: Colors.white10,
              child:
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children:
                    [

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
        else{
          return Circularproindicator(context);
        }
      },
      ),
    );
  }
}
