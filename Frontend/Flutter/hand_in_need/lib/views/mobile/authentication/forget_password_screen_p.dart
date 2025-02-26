import 'package:flutter/material.dart';
import 'package:hand_in_need/views/constant/styles.dart';

import '../commonwidget/circular_progress_ind_yellow.dart';

class Forget_Password_Screen_P extends StatefulWidget {
  const Forget_Password_Screen_P({super.key});

  @override
  State<Forget_Password_Screen_P> createState() =>
      _Forget_Password_Screen_PState();
}

class _Forget_Password_Screen_PState extends State<Forget_Password_Screen_P> {
  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget password screen"),
        backgroundColor: Colors.green,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Container(
                width: widthval,
                height: heightval,
                color: Colors.white10,
                child: Center(
                  child: Container(
                    width: widthval,
                    height: heightval * 0.54,
                    color: Colors.grey,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child:
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                          [
                            Text("User support team email:xxxxx@gmail.com",style: TextStyle(fontFamily: bold,fontSize: shortestval*0.07,color: Colors.black),),
                            SizedBox(height: heightval*0.02,),
                            Text("User support team whatsapp no :123456789",style: TextStyle(fontFamily: bold,fontSize: shortestval*0.07,color: Colors.black),),
                            SizedBox(height: heightval*0.02,),
                            Text("Contact to user support team to recover password through email or whatsapp.Due to monetary app and protect privacy of user we can not allow you to recover password directly without confirmation.",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.06,color: Colors.black),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          } else if (orientation == Orientation.landscape) {
            return Container();
          } else {
            return Circular_pro_indicator_Yellow(context);
          }
        },
      ),
    );
  }
}
