import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hand_in_need/views/mobile/Actions/action_screen_p.dart';
import 'package:hand_in_need/views/mobile/home/login_home_p.dart';
import 'package:hand_in_need/views/mobile/profile/Profil_p.dart';

import '../../constant/styles.dart';
import '../campaign/campaign_screen.dart';
import 'getx_cont/home_BNBI_getx.dart';

class HomeScreen_2 extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const HomeScreen_2({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<HomeScreen_2> createState() => _HomeScreen_2State();
}

class _HomeScreen_2State extends State<HomeScreen_2> {
  final BNBI_getx_cont=Get.put(Home_2_BNBI_getx());
  var navbaritem=[
    BottomNavigationBarItem(
      icon:Icon(Icons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon:Icon(Icons.campaign),
      label: "Campaign",
    ),
    BottomNavigationBarItem(
      icon:Icon(Icons.event_available_outlined),
      label: "Actions",
    ),
    BottomNavigationBarItem(
      icon:Icon(Icons.man),
      label: "Profile",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var navbody=[
      Login_HomeScreen(username:widget.username, usertype: widget.usertype, jwttoken: widget.jwttoken),
      CampaignScreen(),
      ActionScreen(username:widget.username,usertype:widget.usertype, jwttoken:widget.jwttoken),
      Profilescreen(username:widget.username,usertype:widget.usertype, jwttoken:widget.jwttoken),
    ];
    return Scaffold(
    body:
        Obx(
              ()=>Container(
            child: navbody.elementAt(BNBI_getx_cont.currentIndexVal.value),
          ),
        ),
        bottomNavigationBar:
        Obx(
              ()=>BottomNavigationBar(
            items:navbaritem,
            currentIndex:BNBI_getx_cont.currentIndexVal.value,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.red,
            selectedLabelStyle: TextStyle(fontFamily: semibold),
            onTap: (value){
              BNBI_getx_cont.changeindexval(value);
            },
          ),
        )
    );
  }
}
