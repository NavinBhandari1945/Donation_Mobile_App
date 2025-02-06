import 'package:flutter/material.dart';
import 'package:hand_in_need/views/constant/styles.dart';

import '../commonwidget/toast.dart';
import 'index_login_home.dart';
import 'login_home_p.dart';

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
                    child: ElevatedButton(onPressed: ()
                    {

                      Toastget().Toastmsg("Donation process finish.");
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return HomeScreen_2(username:widget.doner_username,jwttoken:widget.JwtToken ,usertype:widget.UserType);
                      },
                      )
                      );
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
