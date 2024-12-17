import 'package:flutter/material.dart';

import '../commonwidget/CommonMethod.dart';
import '../commonwidget/toast.dart';
import 'home_p.dart';

class AdminHome extends StatefulWidget {
  final String jwttoken;
  const AdminHome({super.key,required this.jwttoken});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Home"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: ElevatedButton(onPressed: ()async
        {
          await clearUserData();
          Toastget().Toastmsg("Logout Success");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
          {
            return Home();
          },
          )
          );

        }, child: Text("logout")),
      ),
    );
  }
}
