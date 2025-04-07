import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hand_in_need/views/constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/toast.dart';
import '../commonwidget/toast_long_period.dart';
import '../constant/constant.dart';
import 'authentication_home_p.dart';
import 'index_home.dart';
import 'package:http/http.dart' as http;

class Bill_generation extends StatefulWidget {
  const Bill_generation({
    super.key,
    required this.doner_username,
    required this.receiver_username,
    required this.donate_amount,
    required this.post_id,
    required this.payment_method,
    required this.donate_date,
    required this.JwtToken,
    required this.UserType,
  });

  final String doner_username;
  final String receiver_username;
  final int donate_amount;
  final int post_id;
  final String payment_method;
  final String donate_date;
  final String JwtToken;
  final String UserType;

  @override
  State<Bill_generation> createState() => _Bill_generationState();
}

class _Bill_generationState extends State<Bill_generation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    checkJWTExpiration_Outside_Widget_Build_Method();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> checkJWTExpiration_Outside_Widget_Build_Method() async {
    try {
      int result = await checkJwtToken_initistate_user(
          widget.doner_username, widget.UserType, widget.JwtToken);
      print(widget.JwtToken);
      if (result == 0) {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return AuthenticationHome();
        }));
        Toastget().Toastmsg("Session End.Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for bill generation SDP screen.");
      print(obj.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return AuthenticationHome();
      }));
      Toastget().Toastmsg("Error.Relogin please.");
    }
  }

  Future<int> Add_Notifications_Message({
    required String not_type,
    required String not_receiver_username,
    required String not_message,
  }) async {
    try {
      print("Profile post info method called");
      const String url = Backend_Server_Url + "api/Home/add_notifications";
      final headers = {
        'Authorization': 'Bearer ${widget.JwtToken}',
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> Not_Dict = {
        "NotType": not_type,
        "NotReceiverUsername": not_receiver_username,
        "NotMessage": not_message,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(Not_Dict),
      );

      if (response.statusCode == 200) {
        print("Data insert in notification table in http method in Bill generation SDF success.");
        return 1;
      } else {
        print("status code test 1 = ${response.statusCode}");
        print("Data insert in notification table in http method in Bill generation SDF failed.");
        return 2;
      }
    } catch (obj) {
      print("Exception caught while adding notification data in http method in Bill generation SDF");
      print(obj.toString());
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Info Screen',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.brown.shade700,
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: orientation == Orientation.portrait
                ? _buildPortraitLayout(context)
                : _buildLandscapeLayout(context),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    var shortestval = MediaQuery.of(context).size.shortestSide;

    return Container(
      width: widthval,
      height: heightval,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade200, Colors.grey.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: widthval * 0.9,
                padding: EdgeInsets.all(shortestval * 0.04),
                margin: EdgeInsets.symmetric(vertical: heightval * 0.02),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Payment Information",
                        style: TextStyle(
                          fontSize: shortestval * 0.07,
                          fontFamily: bold,
                          color: Colors.brown.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: shortestval * 0.03),
                    _buildInfoText("Doner Username", widget.doner_username, shortestval),
                    _buildInfoText("Receiver Username", widget.receiver_username, shortestval),
                    _buildInfoText("Donate Amount", widget.donate_amount.toString(), shortestval),
                    _buildInfoText("Post ID", widget.post_id.toString(), shortestval),
                    _buildInfoText("Payment Method", widget.payment_method, shortestval),
                    _buildInfoText("Donate Date", widget.donate_date, shortestval),
                    SizedBox(height: shortestval * 0.03),
                    Text(
                      "Note: Take a screenshot for future use.",
                      style: TextStyle(
                        fontSize: shortestval * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade700,
                      ),
                    ),
                    SizedBox(height: shortestval * 0.04),
                    Center(
                      child: _buildFinishButton(context, shortestval),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    var shortestval = MediaQuery.of(context).size.shortestSide;

    return Container(
      width: widthval,
      height: heightval,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade200, Colors.grey.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: widthval * 0.7,
                padding: EdgeInsets.all(shortestval * 0.04),
                margin: EdgeInsets.symmetric(vertical: heightval * 0.02),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Payment Information",
                              style: TextStyle(
                                fontSize: shortestval * 0.07,
                                fontFamily: bold,
                                color: Colors.brown.shade700,
                              ),
                            ),
                          ),
                          SizedBox(height: shortestval * 0.03),
                          _buildInfoText("Doner Username", widget.doner_username, shortestval),
                          _buildInfoText("Receiver Username", widget.receiver_username, shortestval),
                          _buildInfoText("Donate Amount", widget.donate_amount.toString(), shortestval),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: shortestval * 0.03),
                          _buildInfoText("Post ID", widget.post_id.toString(), shortestval),
                          _buildInfoText("Payment Method", widget.payment_method, shortestval),
                          _buildInfoText("Donate Date", widget.donate_date, shortestval),
                          SizedBox(height: shortestval * 0.03),
                          Text(
                            "Note: Take a screenshot for future use.",
                            style: TextStyle(
                              fontSize: shortestval * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown.shade700,
                            ),
                          ),
                          SizedBox(height: shortestval * 0.04),
                          Center(
                            child: _buildFinishButton(context, shortestval),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoText(String label, String value, double shortestval) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: shortestval * 0.015),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: shortestval * 0.045,
          fontWeight: FontWeight.bold,
          color: Colors.brown.shade900,
        ),
      ),
    );
  }

  Widget _buildFinishButton(BuildContext context, double shortestval) {
    return ElevatedButton(
      onPressed: () async {
        int result = await Add_Notifications_Message(
          not_type: "Donation",
          not_receiver_username: widget.receiver_username,
          not_message: "${widget.doner_username} user donate ${widget.donate_amount} in post that have id = ${widget.post_id} through ${widget.payment_method}.",
        );
        if (result == 1) {
          Toastget().Toastmsg("Donation process finish.");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return Index_Home_Screen(
              username: widget.doner_username,
              jwttoken: widget.JwtToken,
              usertype: widget.UserType,
            );
          }));
        } else {
          print("Retry adding notifications 2nd time in database table after one time fail IN SDP BILL GENERATION..");
          int result = await Add_Notifications_Message(
            not_type: "Donation",
            not_receiver_username: widget.receiver_username,
            not_message: "${widget.doner_username} user donate ${widget.donate_amount} in post that have id = ${widget.post_id} through ${widget.payment_method}.",
          );
          if (result == 1) {
            Toastget().Toastmsg("Donation process finish.");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return Index_Home_Screen(
                username: widget.doner_username,
                jwttoken: widget.JwtToken,
                usertype: widget.UserType,
              );
            }));
          } else {
            print("Adding notifications for second time also fail to save notifications data in database table SDP BILL GENERATION.");
            Toastget_Long_Period().Toastmsg(
                "Donation process finish but please share donation info to app community as it was failed to send notifications to receiver as soon as possible.");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return Index_Home_Screen(
                username: widget.doner_username,
                jwttoken: widget.JwtToken,
                usertype: widget.UserType,
              );
            }));
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: shortestval * 0.08,
          vertical: shortestval * 0.03,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        "Finish",
        style: TextStyle(fontSize: shortestval * 0.05, fontWeight: FontWeight.bold),
      ),
    );
  }
}






// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:hand_in_need/views/constant/styles.dart';
// import '../commonwidget/CommonMethod.dart';
// import '../commonwidget/toast.dart';
// import '../commonwidget/toast_long_period.dart';
// import '../constant/constant.dart';
// import 'authentication_home_p.dart';
// import 'index_home.dart';
// import 'package:http/http.dart' as http;
//
// class Bill_generation extends StatefulWidget {
//   // Constructor with required parameters
//   const Bill_generation({
//     super.key,
//     required this.doner_username,
//     required this.receiver_username,
//     required this.donate_amount,
//     required this.post_id,
//     required this.payment_method,
//     required this.donate_date,
//     required this.JwtToken,
//     required this.UserType
//   });
//
//   // Variables to hold the data passed to the widget
//   final String doner_username;
//   final String receiver_username;
//   final int donate_amount;
//   final int post_id;
//   final String payment_method;
//   final String donate_date;
//   final String JwtToken;
//   final String UserType;
//
//   @override
//   State<Bill_generation> createState() => _Bill_generationState();
// }
//
//
// class _Bill_generationState extends State<Bill_generation> {
//
//   @override
//   void initState(){
//     super.initState();
//     checkJWTExpiration_Outside_Widget_Build_Method();
//   }
//
//   Future<void> checkJWTExpiration_Outside_Widget_Build_Method()async
//   {
//     try {
//       int result = await checkJwtToken_initistate_user(
//           widget.doner_username, widget.UserType, widget.JwtToken);
//       print(widget.JwtToken);
//       if (result == 0)
//       {
//         await clearUserData();
//         await deleteTempDirectoryPostVideo();
//         await deleteTempDirectoryCampaignVideo();
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context)
//         {
//           return AuthenticationHome();
//         },)
//         );
//         Toastget().Toastmsg("Session End.Relogin please.");
//       }
//     }
//     catch(obj)
//     {
//       print("Exception caught while verifying jwt for bill generation SDP screen.");
//       print(obj.toString());
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) {
//         return AuthenticationHome();
//       },)
//       );
//       Toastget().Toastmsg("Error.Relogin please.");
//     }
//   }
//
//   Future<int> Add_Notifications_Message({required String not_type,required String not_receiver_username,required String not_message }) async {
//     try {
//       print("Profile post info method called");
//       const String url =Backend_Server_Url+"api/Home/add_notifications";
//       final headers =
//       {
//         'Authorization': 'Bearer ${widget.JwtToken}',
//         'Content-Type': 'application/json',
//       };
//
//       Map<String, dynamic> Not_Dict =
//       {
//         "NotType": not_type,
//         "NotReceiverUsername": not_receiver_username,
//         "NotMessage": not_message,
//       };
//
//       final response = await http.post(
//           Uri.parse(url),
//           headers: headers,
//           body: json.encode(Not_Dict)
//       );
//
//       if (response.statusCode == 200)
//       {
//         print("Data insert in notification table in http method in Bill generation SDF success.");
//         return 1;
//       }
//       else
//       {
//         print("status code test 1 = ${response.statusCode}");
//         print("Data insert in notification table in http method in Bill generation SDF failed.");
//         return 2;
//       }
//     } catch (obj) {
//       print("Exception caught while adding notification data in http method in Bill generation SDF");
//       print(obj.toString());
//       return 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//     var shortestval = MediaQuery.of(context).size.shortestSide;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Payment Info Screen',
//           style: TextStyle(color: Colors.white, fontSize: 25),
//         ),
//       ),
//       body: Container(
//         width: widthval,
//         height: heightval,
//         color: Colors.grey,
//         child: Center(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             physics: BouncingScrollPhysics(),
//             child: Container(
//               width: widthval * 0.90,
//               height: heightval * 0.50,
//               decoration: BoxDecoration(
//                 color: Colors.brown,
//                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
//               ),
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Displaying the details using Text widgets
//                   Center(
//                     child: Text(
//                      "Payment information",
//                       style: TextStyle(fontSize: shortestval*0.07, fontFamily: bold),
//                     ),
//                   ),
//                   Text(
//                     'Doner Username: ${widget.doner_username}',
//                     style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Receiver Username: ${widget.receiver_username}',
//                     style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Donate Amount: ${widget.donate_amount}',
//                     style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Post ID: ${widget.post_id}',
//                     style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Payment Method: ${widget.payment_method}',
//                     style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Donate Date: ${widget.donate_date}',
//                     style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
//                   ),
//
//                   Text(
//                     'Note take screenshot for future use.',
//                     style: TextStyle(fontSize: shortestval*0.05, fontWeight: FontWeight.bold),
//                   ),
//
//                   Center (
//                     child: ElevatedButton(onPressed: ()async
//                     {
//                       int result=await Add_Notifications_Message(
//                           not_type:"Donation",
//                           not_receiver_username:widget.receiver_username,
//                           not_message:"${widget.doner_username} user donate ${widget.donate_amount} in post that have id = ${widget.post_id} through ${widget.payment_method}."
//                       );
//                       if(result==1)
//                         {
//                           Toastget().Toastmsg("Donation process finish.");
//                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
//                             return Index_Home_Screen(username:widget.doner_username,jwttoken:widget.JwtToken ,usertype:widget.UserType);
//                           },
//                           )
//                           );
//                         }
//                       else
//                         {
//                           print("Retry adding notifications 2nd time in database table after one time fail IN  SDP BILL GENERATION..");
//                           int result=await Add_Notifications_Message(
//                               not_type:"Donation",
//                               not_receiver_username:widget.receiver_username,
//                               not_message:"${widget.doner_username} user donate ${widget.donate_amount} in post that have id = ${widget.post_id} through ${widget.payment_method}."
//                           );
//
//                           if(result==1)
//                           {
//                             Toastget().Toastmsg("Donation process finish.");
//                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
//                               return Index_Home_Screen(username:widget.doner_username,jwttoken:widget.JwtToken ,usertype:widget.UserType);
//                             },
//                             )
//                             );
//                           }
//                           else
//                           {
//                             print("Adding notifications for second time also fail to save notifications data in database table SDP BILL GENERATION.");
//                             Toastget_Long_Period().Toastmsg("Donation process finish but please share donation info to app community as it was failed to send notifications to receiver as soon as possible.");
//                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
//                             {
//                               return Index_Home_Screen(username:widget.doner_username,jwttoken:widget.JwtToken ,usertype:widget.UserType);
//                             },
//                             )
//                             );
//                           }
//                         }
//
//                     }, child:Text("Finish")
//                     ),
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
