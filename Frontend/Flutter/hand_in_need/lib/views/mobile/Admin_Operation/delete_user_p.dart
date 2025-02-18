import 'package:flutter/material.dart';

import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/commonbutton.dart';
import '../commonwidget/commontextfield_obs_false_p.dart';
import '../commonwidget/toast.dart';
import '../home/home_p.dart';

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

  final User_Id_Cont=TextEditingController();

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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return Home();
      },)
      );
      Toastget().Toastmsg("Error. Relogin please.");
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
                    height: heightval*0.23,
                    color: Colors.grey,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children:
                        [
                          CommonTextField_obs_false_p("Enter the user id to delete.","", false, User_Id_Cont, context),
                          Commonbutton("Delete", ()
                          {



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
