import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hand_in_need/views/mobile/Actions/action_screen_p.dart';
import 'package:hand_in_need/views/mobile/home/login_home_p.dart';
import 'package:hand_in_need/views/mobile/profile/Profil_p.dart';
import '../../constant/styles.dart';
import '../campaign/campaign_screen_p.dart';
import 'getx_cont/home_BNBI_getx.dart';

class Index_Home_Screen extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Index_Home_Screen({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<Index_Home_Screen> createState() => _Index_Home_ScreenState();
}

class _Index_Home_ScreenState extends State<Index_Home_Screen> {
  final BNBI_getx_cont=Get.put(Home_2_BNBI_getx());
  //items at bottom of home screen
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
    var navbody=
    [
      //routing screen after clicking on navbar items
      Login_HomeScreen(username:widget.username, usertype: widget.usertype, jwttoken: widget.jwttoken),
      CampaignScreen(username:widget.username,usertype:widget.usertype, jwttoken:widget.jwttoken),
      ActionScreen_P(username:widget.username,usertype:widget.usertype, jwttoken:widget.jwttoken),
      Profilescreen_P(username:widget.username,usertype:widget.usertype, jwttoken:widget.jwttoken),
    ];
    return Scaffold(
    body:
        Obx(
              ()=>Container(
                //routing to respected selected navbar item screen
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
            onTap: (value)
            {
              BNBI_getx_cont.changeindexval(value);
            },
          ),
        )
    );
  }
}
