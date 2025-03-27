import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hand_in_need/views/constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/toast.dart';
import '../commonwidget/toast_long_period.dart';
import '../constant/constant.dart';
import 'home_p.dart';
import 'index_login_home.dart';
import 'package:http/http.dart' as http;

class Bill_generation_SP_FD_P extends StatefulWidget {
  // Constructor with required parameters
  const Bill_generation_SP_FD_P({
    super.key,
    required this.doner_username,
    required this.receiver_username,
    required this.donate_amount,
    required this.post_id,
    required this.payment_method,
    required this.donate_date,
    required this.JwtToken,
    required this.UserType
  });

  // Variables to hold the data passed to the widget
  final String doner_username;
  final String receiver_username;
  final int donate_amount;
  final int post_id;
  final String payment_method;
  final String donate_date;
  final String JwtToken;
  final String UserType;

  @override
  State<Bill_generation_SP_FD_P> createState() => _Bill_generation_SP_FD_PState();
}

class _Bill_generation_SP_FD_PState extends State<Bill_generation_SP_FD_P> {

  @override
  void initState(){
    super.initState();
    checkJWTExpiration_Outside_Widget_Build_Method();
  }

  Future<void> checkJWTExpiration_Outside_Widget_Build_Method()async
  {
    try {
      int result = await checkJwtToken_initistate_user(
          widget.doner_username, widget.UserType, widget.JwtToken);
      print(widget.JwtToken);
      if (result == 0)
      {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context)
        {
          return Home();
        },)
        );
        Toastget().Toastmsg("Session End.Relogin please.");
      }
    }
    catch(obj)
    {
      print("Exception caught while verifying jwt for bill generation SP_FD screen.");
      print(obj.toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return Home();
      },)
      );
      Toastget().Toastmsg("Error.Relogin please.");
    }
  }

  Future<int> Add_Notifications_Message({required String not_type,required String not_receiver_username,required String not_message }) async {
    try {
      print("Profile post info method called");
      //  const String url = "http://10.0.2.2:5074/api/Home/add_notifications";
      const String url =Backend_Server_Url+"api/Home/add_notifications";
      final headers =
      {
        'Authorization': 'Bearer ${widget.JwtToken}',
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> Not_Dict =
      {
        "NotType": not_type,
        "NotReceiverUsername": not_receiver_username,
        "NotMessage": not_message,
      };

      final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(Not_Dict)
      );

      if (response.statusCode == 200)
      {
        print("Data insert in notification table in http method in Bill generation SP_FD bill generation success.");
        return 1;
      }
      else
      {
        print("Data insert in notification table in http method in SP_FD bill generation failed.");
        return 2;
      }
    } catch (obj) {
      print("Exception caught while adding notification data in http method in SP_FD bill generation");
      print(obj.toString());
      return 0;
    }
  }
  @override
  Widget build(BuildContext context) {
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    var shortestval = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Info Screen',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Container(
        width: widthval,
        height: heightval,
        color: Colors.grey,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Container(
              width: widthval * 0.90,
              height: heightval * 0.50,
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Displaying the details using Text widgets
                  Center(
                    child: Text(
                     "Payment information",
                      style: TextStyle(fontSize: shortestval*0.07, fontFamily: bold),
                    ),
                  ),
                  Text(
                    "Note:Plesae send this screenshot of payment to app official Email and contact to customer support.This payment process was succeess by wallet but not save in storage for future history so contact as soon as possible."
                    ,style: TextStyle(fontSize: shortestval*0.07, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Doner Username: ${widget.doner_username}',
                    style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Receiver Username: ${widget.receiver_username}',
                    style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Donate Amount: ${widget.donate_amount}',
                    style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Post ID: ${widget.post_id}',
                    style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Payment Method: ${widget.payment_method}',
                    style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Donate Date: ${widget.donate_date}',
                    style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    'Note take screenshot for future use.',
                    style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
                  ),



                  Center(
                    child: ElevatedButton(onPressed: ()async
                    {
                      int result=await Add_Notifications_Message(
                          not_type:"Donation",
                          not_receiver_username:widget.receiver_username,
                          not_message:"${widget.doner_username} user donate ${widget.donate_amount} in post that have id = ${widget.post_id} through ${widget.payment_method}."
                      );
                      if(result==1)
                      {
                        Toastget().Toastmsg("Donation process finish.");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return HomeScreen_2(username:widget.doner_username,jwttoken:widget.JwtToken ,usertype:widget.UserType);
                        },
                        )
                        );
                      }
                      else
                      {
                        print("Retry adding notifications 2nd time in database table after one time fail IN  SP_FD BILL GENERATION..");
                        int result=await Add_Notifications_Message(
                            not_type:"Donation",
                            not_receiver_username:widget.receiver_username,
                            not_message:"${widget.doner_username} user donate ${widget.donate_amount} in post that have id = ${widget.post_id} through ${widget.payment_method}."
                        );
                        if(result==1)
                        {
                          Toastget().Toastmsg("Donation process finish.");
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            return HomeScreen_2(username:widget.doner_username,jwttoken:widget.JwtToken ,usertype:widget.UserType);
                          },
                          )
                          );
                        }
                        else
                        {
                          print("Adding notifications for second time also fail to save notifications data in database table SP_FD BILL GENERATION.");
                          Toastget_Long_Period().Toastmsg("Donation process finish but please share donation info to app community as it was failed to send notifications to receiver as soon as possible.");
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                          {
                            return HomeScreen_2(username:widget.doner_username,jwttoken:widget.JwtToken ,usertype:widget.UserType);
                          },
                          )
                          );
                        }
                      }
                    }, child:Text("Finish")
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
