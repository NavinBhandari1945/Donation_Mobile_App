import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/models/mobile/AdvertisementModel.dart';
import 'package:hand_in_need/models/mobile/DonationModel.dart';
import 'package:hand_in_need/views/mobile/Actions/InsertPostScreen_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast_long_period.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../models/mobile/UserInfoModel.dart';
import '../../constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/toast.dart';
import '../home/authentication_home_p.dart';
import '../profile/User_Friend_Profile_Screen_P.dart';
import 'InsertCampaignScreen_p.dart';
import 'ScanQRScreen_p.dart';
import 'package:http/http.dart' as http;

class ActionScreen_P extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const ActionScreen_P({
    super.key,
    required this.username,
    required this.usertype,
    required this.jwttoken,
  });

  @override
  State<ActionScreen_P> createState() => _ActionScreen_PState();
}

class _ActionScreen_PState extends State<ActionScreen_P> with SingleTickerProviderStateMixin {
  final isLoadingCont = Get.put(Isloading());
  final Search_User_Action_cont = TextEditingController();
  final Invite_User_Username_Cont = TextEditingController();
  final Time_Meeting_Cont = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    checkJWTExpiation();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    Search_User_Action_cont.dispose();
    Invite_User_Username_Cont.dispose();
    Time_Meeting_Cont.dispose();
    super.dispose();
  }

  Future<void> checkJWTExpiation() async {
    try {
      int result = await checkJwtToken_initistate_user(widget.username, widget.usertype, widget.jwttoken);
      print(widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        print("Deleteing temporary directory success.");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
        Toastget().Toastmsg("Session End.Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for Action screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleteing temporary directory success.");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
      Toastget().Toastmsg("Error.Relogin please.");
    }
  }

  List<UserInfoModel> Filter_User_Info_List = [];
  List<UserInfoModel> User_Info_List = [];

  Future<void> GetUserInfo() async {
    try {
      print("Profile post info method called");
      const String url = Backend_Server_Url + "api/Actions/getuserinfo";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        User_Info_List.clear();
        User_Info_List.addAll(responseData.map((data) => UserInfoModel.fromJson(data)).toList());
        print("User_Info_List for actions screen count value");
        print(User_Info_List.length);
        return;
      } else {
        User_Info_List.clear();
        print("Data insert in User_Info_List for actions screen failed.");
        return;
      }
    } catch (obj) {
      User_Info_List.clear();
      print("Exception caught while fetching User_Info for actions screen in http method");
      print(obj.toString());
      return;
    }
  }

  List<AdvertisementModel> Ad_Info_List = [];

  Future<void> Get_Advertisement_Info() async {
    try {
      print("Profile post info method called");
      const String url = Backend_Server_Url + "api/Actions/get_ad_info";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        Ad_Info_List.clear();
        Ad_Info_List.addAll(responseData.map((data) => AdvertisementModel.fromJson(data)).toList());
        print("Ad info list for actions screen count value");
        print(Ad_Info_List.length);
        return;
      } else {
        Ad_Info_List.clear();
        print("Data insert in ad info list for actions screen failed.");
        return;
      }
    } catch (obj) {
      Ad_Info_List.clear();
      print("Exception caught while fetching ad info for actions screen in http method");
      print(obj.toString());
      return;
    }
  }

  List<DonationModel> Donation_Info_List = [];

  Future<void> Get_Donation_Info() async {
    try {
      print("Profile post info method called");
      const String url = Backend_Server_Url + "api/Actions/get_donation_info";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        Donation_Info_List.clear();
        Donation_Info_List.addAll(responseData.map((data) => DonationModel.fromJson(data)).toList());
        print("Donation info list for actions screen count value");
        print(Donation_Info_List.length);
        return;
      } else {
        Donation_Info_List.clear();
        print("Data insert in Donation info list for actions screen failed.");
        return;
      }
    } catch (obj) {
      Donation_Info_List.clear();
      print("Exception caught while fetching Donation info for actions screen in http method");
      print(obj.toString());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    var shortestval = MediaQuery.of(context).size.shortestSide;
    Filter_User_Info_List.clear();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Actions",
          style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: orientation == Orientation.portrait
                  ? _buildPortraitLayout(shortestval, widthval, heightval)
                  : _buildLandscapeLayout(shortestval, widthval, heightval),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(double shortestval, double widthval, double heightval) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(shortestval),
            SizedBox(height: heightval * 0.02),
            FutureBuilder<void>(
              future: GetUserInfo(),
              builder: (context, snapshot) => _buildUserSection(snapshot, shortestval, widthval, heightval),
            ),
            SizedBox(height: heightval * 0.02),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _buildActionButton("Insert Post", Colors.blue[600]!, () => Navigator.push(context, MaterialPageRoute(builder: (context) => Insertpostscreen(username: widget.username, usertype: widget.usertype, jwttoken: widget.jwttoken)))),
              _buildActionButton("Insert Campaign", Colors.green[600]!, () => Navigator.push(context, MaterialPageRoute(builder: (context) => InsertcampaignscreenP(username: widget.username, usertype: widget.usertype, jwttoken: widget.jwttoken)))),
            ]),
            SizedBox(height: heightval * 0.02),
            _buildSectionTitle("Advertisements"),
            FutureBuilder<void>(future: Get_Advertisement_Info(), builder: (context, snapshot) => _buildAdSection(snapshot, shortestval, widthval, heightval)),
            SizedBox(height: heightval * 0.02),
            _buildSectionTitle("Recent Donations"),
            FutureBuilder<void>(future: Get_Donation_Info(), builder: (context, snapshot) => _buildDonationSection(snapshot, shortestval, widthval, heightval)),
            SizedBox(height: heightval * 0.02),
            _buildMeetingInvitationSection(shortestval),
            SizedBox(height: heightval * 0.02),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _buildIconButton(Icons.qr_code_scanner_outlined, Colors.blue[600]!, () => Navigator.push(context, MaterialPageRoute(builder: (context) => QrScannerScreen_P(usertype: widget.usertype, jwttoken: widget.jwttoken, username: widget.username)))),
              _buildIconButton(Icons.insert_invitation_rounded, Colors.green[600]!, _sendMeetingInvitation),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(double shortestval, double widthval, double heightval) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: widthval * 0.3,
          padding: EdgeInsets.all(shortestval * 0.03),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(shortestval, isLandscape: true),
                SizedBox(height: heightval * 0.02),
                _buildSectionTitle("Actions"),
                _buildActionButton("Insert Post", Colors.blue[600]!, () => Navigator.push(context, MaterialPageRoute(builder: (context) => Insertpostscreen(username: widget.username, usertype: widget.usertype, jwttoken: widget.jwttoken)))),
                SizedBox(height: heightval * 0.01),
                _buildActionButton("Insert Campaign", Colors.green[600]!, () => Navigator.push(context, MaterialPageRoute(builder: (context) => InsertcampaignscreenP(username: widget.username, usertype: widget.usertype, jwttoken: widget.jwttoken)))),
                SizedBox(height: heightval * 0.02),
                _buildMeetingInvitationSection(shortestval),
                SizedBox(height: heightval * 0.02),
                _buildIconButton(Icons.qr_code_scanner_outlined, Colors.blue[600]!, () => Navigator.push(context, MaterialPageRoute(builder: (context) => QrScannerScreen_P(usertype: widget.usertype, jwttoken: widget.jwttoken, username: widget.username)))),
                SizedBox(height: heightval * 0.01),
                _buildIconButton(Icons.insert_invitation_rounded, Colors.green[600]!, _sendMeetingInvitation),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(shortestval * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<void>(
                    future: GetUserInfo(),
                    builder: (context, snapshot) => _buildUserSection(snapshot, shortestval, widthval, heightval),
                  ),
                  SizedBox(height: heightval * 0.02),
                  _buildSectionTitle("Advertisements"),
                  FutureBuilder<void>(future: Get_Advertisement_Info(), builder: (context, snapshot) => _buildAdSection(snapshot, shortestval, widthval, heightval)),
                  SizedBox(height: heightval * 0.02),
                  _buildSectionTitle("Recent Donations"),
                  FutureBuilder<void>(future: Get_Donation_Info(), builder: (context, snapshot) => _buildDonationSection(snapshot, shortestval, widthval, heightval)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(double shortestval, {bool isLandscape = false}) {
    return TextFormField(
      onChanged: (value) => setState(() {}),
      controller: Search_User_Action_cont,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!, width: 2), borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green[700]!, width: 2), borderRadius: BorderRadius.circular(12)),
        hintText: isLandscape ? "Search" : "Search Users",
        hintStyle: TextStyle(color: Colors.grey[500], fontFamily: regular),
        prefixIcon: Icon(Icons.search, color: Colors.green[700]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: shortestval * 0.04),
      ),
      style: TextStyle(fontSize: shortestval * 0.04, color: Colors.grey[800]),
    );
  }

  Widget _buildUserSection(AsyncSnapshot<void> snapshot, double shortestval, double widthval, double heightval) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator(color: Colors.green[700]));
    } else if (snapshot.hasError) {
      return _buildErrorText("Error fetching user data. Please reopen app.", shortestval);
    } else if (snapshot.connectionState == ConnectionState.done) {
      if (Search_User_Action_cont.text.isNotEmptyAndNotNull && User_Info_List.isNotEmpty) {
        _filterUserList();
      }
      return User_Info_List.isEmpty ? _buildEmptyText("No user data available.", shortestval) : _buildUserList(shortestval, widthval);
    }
    return _buildErrorText("Please reopen app.", shortestval);
  }

  void _filterUserList() {
    try {
      print("Filtere user list add item condition called.");
      for (var user_info in User_Info_List) {
        if (user_info.username.toString().toLowerCase().trim() == Search_User_Action_cont.text.toLowerCase().trim()) {
          print("Search username of cuser match and add in filter user info list.");
          print("Username= ${user_info.username}");
          Filter_User_Info_List.clear();
          Filter_User_Info_List.add(user_info);
        }
      }
      if (Filter_User_Info_List.isEmpty) {
        Filter_User_Info_List.clear();
        Toastget().Toastmsg("Enter username didn't match with available user username.");
        print("Enter username didn't match with available user username.");
      }
    } catch (Obj) {
      Filter_User_Info_List.clear();
      Toastget().Toastmsg("Enter username didn't match with available user username.");
      print("Exception caught while filtering user info list");
      print(Obj.toString());
    }
  }

  Widget _buildUserList(double shortestval, double widthval) {
    final displayList = Filter_User_Info_List.isNotEmpty ? Filter_User_Info_List : User_Info_List;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayList.length,
      itemBuilder: (context, index) => _buildUserCard(displayList[index], shortestval, widthval),
    );
  }

  Widget _buildUserCard(UserInfoModel user, double shortestval, double widthval) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => User_Friend_Profile_Screen_P(FriendUsername: user.username!, Current_User_Usertype: widget.usertype, Current_User_Username: widget.username, Current_User_Jwt_Token: widget.jwttoken))),
        child: Padding(
          padding: EdgeInsets.all(shortestval * 0.03),
          child: Row(
            children: [
              CircleAvatar(radius: shortestval * 0.05, backgroundColor: Colors.green[100], child: Text(user.username![0].toUpperCase(), style: TextStyle(color: Colors.green[700], fontSize: shortestval * 0.06, fontFamily: bold))),
              SizedBox(width: shortestval * 0.03),
              Expanded(child: Text("Friend: ${user.username}", style: TextStyle(fontFamily: semibold, fontSize: shortestval * 0.045, color: Colors.grey[800]))),
              Icon(Icons.people_rounded, color: Colors.green[700], size: shortestval * 0.06),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return CommonButton_loading(
      label: label,
      onPressed: onPressed,
      color: color,
      textStyle: TextStyle(color: Colors.white, fontSize: shortestval * 0.04, fontFamily: bold),
      padding: EdgeInsets.all(shortestval * 0.03),
      borderRadius: 12.0,
      width: shortestval * 0.4,
      height: shortestval * 0.12,
      isLoading: isLoadingCont.isloading.value,
    );
  }

  Widget _buildSectionTitle(String title) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: shortestval * 0.02),
      child: Text(title, style: TextStyle(fontFamily: bold, fontSize: shortestval * 0.05, color: Colors.grey[800])),
    );
  }

  Widget _buildAdSection(AsyncSnapshot<void> snapshot, double shortestval, double widthval, double heightval) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Circular_pro_indicator_Yellow(context);
    } else if (snapshot.hasError) {
      return _buildErrorText("Error fetching advertisements. Please try again.", shortestval);
    } else if (snapshot.connectionState == ConnectionState.done) {
      return Ad_Info_List.isEmpty
          ? _buildEmptyText("No advertisement data available.", shortestval)
          : SizedBox(
        height: heightval * 0.28,
        child: VxSwiper.builder(
          itemCount: Ad_Info_List.length,
          autoPlay: true,
          enlargeCenterPage: false,
          viewportFraction: 1.0,
          aspectRatio: 16 / 9,
          itemBuilder: (context, index) {
            final ad = Ad_Info_List[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(shortestval * 0.02), child: Text(ad.adUrl!, style: TextStyle(fontSize: shortestval * 0.045, fontFamily: bold, color: Colors.grey[800]), textAlign: TextAlign.center)),
                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.memory(base64Decode(ad.adPhoto!), width: widthval, fit: BoxFit.cover))),
                ],
              ),
            );
          },
        ),
      );
    }
    return _buildErrorText("Please close and reopen app.", shortestval);
  }

  Widget _buildDonationSection(AsyncSnapshot<void> snapshot, double shortestval, double widthval, double heightval) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Circular_pro_indicator_Yellow(context);
    } else if (snapshot.hasError) {
      return _buildErrorText("Error fetching donation info. Please try again.", shortestval);
    } else if (snapshot.connectionState == ConnectionState.done) {
      return Donation_Info_List.isEmpty
          ? _buildEmptyText("No donation data available.", shortestval)
          : SizedBox(
        height: heightval * 0.18,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: Donation_Info_List.length,
          itemBuilder: (context, index) {
            final donation = Donation_Info_List[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(shortestval * 0.03),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: shortestval * 0.06, backgroundColor: Colors.green[100], child: Text(donation.postId.toString(), style: TextStyle(color: Colors.green[700], fontFamily: bold, fontSize: shortestval * 0.045))),
                      SizedBox(height: shortestval * 0.02),
                      Text(donation.donerUsername.toString(), style: TextStyle(fontSize: shortestval * 0.04, fontFamily: semibold)),
                      SizedBox(height: shortestval * 0.01),
                      Text("${donation.donateAmount}", style: TextStyle(fontSize: shortestval * 0.045, fontFamily: bold, color: Colors.green[700])),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    return _buildErrorText("Please close and reopen app.", shortestval);
  }

  Widget _buildMeetingInvitationSection(double shortestval) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text("Send Meeting Invitation", style: TextStyle(fontFamily: bold, fontSize: shortestval * 0.045, color: Colors.grey[800])),
        tilePadding: EdgeInsets.symmetric(horizontal: shortestval * 0.03),
        childrenPadding: EdgeInsets.all(shortestval * 0.03),
        children: [
          CommonTextField_obs_false_p("Enter username", "", false, Invite_User_Username_Cont, context, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[100])),
          SizedBox(height: shortestval * 0.02),
          CommonTextField_obs_false_p("Enter date (e.g., 2025-01-01 01:01 PM)", "2025-01-01 01:01 PM", false, Time_Meeting_Cont, context, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[100])),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: shortestval * 0.1, color: Colors.white),
        style: IconButton.styleFrom(backgroundColor: color, padding: EdgeInsets.all(shortestval * 0.04), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      ),
    );
  }

  Widget _buildErrorText(String message, double shortestval) {
    return Center(child: Text(message, style: TextStyle(color: Colors.red[700], fontSize: shortestval * 0.045, fontFamily: semibold), textAlign: TextAlign.center));
  }

  Widget _buildEmptyText(String message, double shortestval) {
    return Center(child: Text(message, style: TextStyle(fontSize: shortestval * 0.045, fontFamily: semibold, color: Colors.grey[600])));
  }

  void _sendMeetingInvitation() async {
    if (Invite_User_Username_Cont.text.isEmptyOrNull || Time_Meeting_Cont.text.isEmptyOrNull) {
      Toastget().Toastmsg("Provide details to send invitation from above expansion tile.");
      return;
    }
    final dateTimeRegex = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2} (AM|PM)$', caseSensitive: false);
    if (!dateTimeRegex.hasMatch(Time_Meeting_Cont.text)) {
      Toastget().Toastmsg("Invalid DateTime format. Use: yyyy-MM-dd HH:mm AM/PM (e.g., 2025-02-03 06:07 AM)");
      return;
    }
    int result = await Add_Notifications_Message_CM(
      not_type: "Meeting invitation for user confirmation",
      not_receiver_username: Invite_User_Username_Cont.text.trim(),
      not_message: "Dear user ${Invite_User_Username_Cont.text.trim()} I want you to join meeting through chat and video option at date:${Time_Meeting_Cont.text} for verification of user to support.",
      JwtToken: widget.jwttoken,
    );
    if (result == 1) {
      Toastget_Long_Period().Toastmsg("Invitation for meeting sent successfully. Your friend will respond via notifications.");
    } else if (result == 3) {
      Toastget().Toastmsg("Provide correct username. Invitation send failed.");
    } else {
      print("Retry adding notifications 2nd time in database table after one time fail.");
      int result_2 = await Add_Notifications_Message_CM(
        not_type: "Meeting invitation for user confirmation",
        not_receiver_username: Invite_User_Username_Cont.text.trim(),
        not_message: "Dear user ${Invite_User_Username_Cont.text.trim()} I want you to join meeting through chat and video option at date:${Time_Meeting_Cont.text} for verification of user to support.",
        JwtToken: widget.jwttoken,
      );
      if (result_2 == 1) {
        Toastget().Toastmsg("Invitation for meeting sent successfully.");
      } else if (result_2 == 3) {
        Toastget().Toastmsg("Provide correct username. Invitation send failed.");
      } else {
        print("Server error. Logout from app and retry");
        Toastget_Long_Period().Toastmsg("Server error. Logout from app and retry");
      }
    }
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hand_in_need/models/mobile/AdvertisementModel.dart';
// import 'package:hand_in_need/models/mobile/DonationModel.dart';
// import 'package:hand_in_need/views/mobile/Actions/InsertPostScreen_p.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/getx_cont/getx_cont_cmn_btn_loading.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/toast_long_period.dart';
// import 'package:hand_in_need/views/mobile/constant/constant.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../../../models/mobile/UserInfoModel.dart';
// import '../../constant/styles.dart';
// import '../commonwidget/CommonMethod.dart';
// import '../commonwidget/circular_progress_ind_yellow.dart';
// import '../commonwidget/toast.dart';
// import '../home/authentication_home_p.dart';
// import '../profile/User_Friend_Profile_Screen_P.dart';
// import 'InsertCampaignScreen_p.dart';
// import 'ScanQRScreen_p.dart';
// import 'package:http/http.dart' as http;
//
//
// class ActionScreen_P extends StatefulWidget {
//   final String username;
//   final String usertype;
//   final String jwttoken;
//   const ActionScreen_P({super.key,required this.username,required this.usertype,
//     required this.jwttoken});
//   @override
//   State<ActionScreen_P> createState() => _ActionScreen_PState();
// }
//
// class _ActionScreen_PState extends State<ActionScreen_P> {
//
//   final isLoadingCont=Get.put(Isloading());
//
//   final  Search_User_Action_cont=TextEditingController();
//
//   final  Invite_User_Username_Cont=TextEditingController();
//
//   final  Time_Meeting_Cont=TextEditingController();
//
//   @override
//   void initState(){
//     super.initState();
//     checkJWTExpiation();
//   }
//
//   @override
//   void dispose(){
//     super.dispose();
//     Search_User_Action_cont.dispose();
//     Invite_User_Username_Cont.clear();
//     Time_Meeting_Cont.clear();
//   }
//
//   Future<void> checkJWTExpiation()async
//   {
//     try {
//       int result = await checkJwtToken_initistate_user(
//           widget.username, widget.usertype, widget.jwttoken);
//       print(widget.jwttoken);
//       if (result == 0) {
//         await clearUserData();
//         await deleteTempDirectoryPostVideo();
//         await deleteTempDirectoryCampaignVideo();
//         print("Deleteing temporary directory success.");
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) {
//           return AuthenticationHome();
//         },)
//         );
//         Toastget().Toastmsg("Session End.Relogin please.");
//       }
//     }
//     catch(obj)
//     {
//       print("Exception caught while verifying jwt for Action screen.");
//       print(obj.toString());
//       await clearUserData();
//       await deleteTempDirectoryPostVideo();
//       await deleteTempDirectoryCampaignVideo();
//       print("Deleteing temporary directory success.");
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) {
//         return AuthenticationHome();
//       },)
//       );
//       Toastget().Toastmsg("Error.Relogin please.");
//     }
//
//   }
//
//   List<UserInfoModel> Filter_User_Info_List = [];
//
//   List<UserInfoModel> User_Info_List = [];
//
//   Future<void> GetUserInfo() async
//   {
//     try {
//       print("Profile post info method called");
//       // const String url = "http://10.0.2.2:5074/api/Profile/getprofilepostinfo";
//       const String url = Backend_Server_Url+"api/Actions/getuserinfo";
//       final headers =
//       {
//         'Authorization': 'Bearer ${widget.jwttoken}',
//         'Content-Type': 'application/json',
//       };
//
//       final response = await http.get(
//           Uri.parse(url),
//           headers: headers,
//       );
//
//       if (response.statusCode == 200)
//       {
//         List<dynamic> responseData = await jsonDecode(response.body);
//         User_Info_List.clear();
//         User_Info_List.addAll
//           (
//           responseData.map((data) => UserInfoModel.fromJson(data)).toList(),
//         );
//         print("User_Info_List for actions screen count value");
//         print(User_Info_List.length);
//         return;
//       } else
//       {
//         User_Info_List.clear();
//         print("Data insert in User_Info_List for actions screen failed.");
//         return;
//       }
//     } catch (obj) {
//       User_Info_List.clear();
//       print("Exception caught while fetching User_Info  for actions screen screen in http method");
//       print(obj.toString());
//       return;
//     }
//   }
//
//   List<AdvertisementModel> Ad_Info_List = [];
//
//   Future<void> Get_Advertisement_Info() async
//   {
//     try {
//       print("Profile post info method called");
//       // const String url = "http://10.0.2.2:5074/api/Profile/getprofilepostinfo";
//       const String url = Backend_Server_Url+"api/Actions/get_ad_info";
//       final headers =
//       {
//         'Authorization': 'Bearer ${widget.jwttoken}',
//         'Content-Type': 'application/json',
//       };
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: headers,
//       );
//
//       if (response.statusCode == 200)
//       {
//         List<dynamic> responseData = await jsonDecode(response.body);
//         Ad_Info_List.clear();
//         Ad_Info_List.addAll
//           (
//           responseData.map((data) => AdvertisementModel.fromJson(data)).toList(),
//         );
//         print("Ad info list for actions screen count value");
//         print(Ad_Info_List.length);
//         return;
//       } else
//       {
//         Ad_Info_List.clear();
//         print("Data insert in ad info list for actions screen failed.");
//         return;
//       }
//     } catch (obj) {
//       Ad_Info_List.clear();
//       print("Exception caught while fetching ad info for actions screen screen in http method");
//       print(obj.toString());
//       return;
//     }
//   }
//
//   List<DonationModel> Donation_Info_List = [];
//
//   Future<void> Get_Donation_Info() async
//   {
//     try {
//       print("Profile post info method called");
//       // const String url = "http://10.0.2.2:5074/api/Profile/getprofilepostinfo";
//       const String url = Backend_Server_Url+"api/Actions/get_donation_info";
//       final headers =
//       {
//         'Authorization': 'Bearer ${widget.jwttoken}',
//         'Content-Type': 'application/json',
//       };
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: headers,
//       );
//
//       if (response.statusCode == 200)
//       {
//         List<dynamic> responseData = await jsonDecode(response.body);
//         Donation_Info_List.clear();
//         Donation_Info_List.addAll
//           (
//           responseData.map((data) => DonationModel.fromJson(data)).toList(),
//         );
//         print("Donation info list for actions screen count value");
//         print(Donation_Info_List.length);
//         return;
//       } else
//       {
//         Donation_Info_List.clear();
//         print("Data insert in Donation info list for actions screen failed.");
//         return;
//       }
//     } catch (obj) {
//       Donation_Info_List.clear();
//       print("Exception caught while fetching Donation info for actions screen in http method");
//       print(obj.toString());
//       return;
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     var widthval=MediaQuery.of(context).size.width;
//     var heightval=MediaQuery.of(context).size.height;
//     var shortestval=MediaQuery.of(context).size.shortestSide;
//     Filter_User_Info_List.clear();
//     return Scaffold
//       (
//         appBar: AppBar(
//           title: Text("Action Screen"),
//           backgroundColor: Colors.green,
//           automaticallyImplyLeading: false,
//         ),
//         body:OrientationBuilder(builder: (context, orientation)
//         {
//           if(orientation==Orientation.portrait)
//           {
//             return
//               Container(
//                   width:widthval,
//                   height: heightval,
//                   color: Colors.grey,
//                   child:
//                   SingleChildScrollView(
//                     physics: BouncingScrollPhysics(),
//                     scrollDirection: Axis.vertical,
//                     child: Column(
//                       children:
//                       [
//                         TextFormField
//                           (
//                             onChanged: (value)
//                             {
//                               setState(()
//                               {
//                               });
//                             },
//                             controller: Search_User_Action_cont,
//                             obscureText: false,
//                             decoration:InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: shortestval*0.01
//                                 ),
//                                 borderRadius: BorderRadius.circular(shortestval*0.04),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: shortestval*0.01
//                                 ),
//                                 borderRadius: BorderRadius.circular(shortestval*0.04),
//                               ),
//                               hintText: "Search",
//                               prefixIcon: Icon(Icons.search),
//                             )
//                         ),
//
//                         SizedBox(
//                           height: heightval*0.01,
//                         ),
//
//                         FutureBuilder<void>(
//                             future: GetUserInfo(),
//                             builder: (context, snapshot)
//                             {
//                               if (snapshot.connectionState == ConnectionState.waiting) {
//                                 // Show a loading indicator while the future is executing
//                                 return Center(child: CircularProgressIndicator());
//                               }
//                               else if (snapshot.hasError) {
//                                 // Handle any error from the future
//                                 return Center(
//                                   child: Text(
//                                     "Error fetching user data. Please reopen app.",
//                                     style: TextStyle(color: Colors.red, fontSize: 16),
//                                   ),
//                                 );
//                               }
//                               else if (snapshot.connectionState == ConnectionState.done)
//                               {
//                                 if(Search_User_Action_cont.text.toString().isNotEmptyAndNotNull && User_Info_List.length>=1)
//                                 {
//                                   try {
//                                     print("Filtere user list add item condition called.");
//                                     // Iterate through your CampaignInfoList and check if postId matches the text input.
//                                     for (var user_info in User_Info_List)
//                                     {
//                                       if (user_info.username.toString().toLowerCase().trim()==Search_User_Action_cont.text.toString().toLowerCase().trim())
//                                       {
//                                         // If the postId matches, add it to the FilteredCampaigns list.
//                                         print("Search username of cuser match and add in filter user info list.");
//                                         print("Username= ${user_info.username}");
//                                         Filter_User_Info_List.clear();
//                                         Filter_User_Info_List.add(user_info);
//                                       }
//                                     }
//                                     if(Filter_User_Info_List.length<=0)
//                                     {
//                                       Filter_User_Info_List.clear();
//                                       Toastget().Toastmsg("Enter username didn't match with available user username.");
//                                       print("Enter username didn't match with available user username.");
//                                     }
//                                   }catch(Obj)
//                                   {
//                                     Filter_User_Info_List.clear();
//                                     Toastget().Toastmsg("Enter username didn't match with available user username.");
//                                     print("Exception caught while filtering user info list");
//                                     print(Obj.toString());
//                                   }
//                                 }
//                                 return User_Info_List.isEmpty
//                                     ? const Center(child: Text("No user data available."))
//                                     :
//                                 Builder(builder: (context)
//                                 {
//                                   if(Filter_User_Info_List.length>=1)
//                                   {
//                                     return
//                                       ListView.builder(
//                                         shrinkWrap: true,
//                                           itemBuilder: (context, index)
//                                           {
//                                             final user = Filter_User_Info_List[index];
//                                             return
//                                               Card(
//                                               child:Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                                 children:
//                                                 [
//                                                   Text("Friend Username:${user.username}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05),),
//                                                   Icon(Icons.people_rounded),
//                                                 ],
//                                               ).onTap((){
//                                                 Navigator.push(context,MaterialPageRoute(builder: (context)
//                                                 {
//                                                   return User_Friend_Profile_Screen_P(
//                                                     FriendUsername:user.username!,
//                                                     Current_User_Usertype:widget.usertype ,
//                                                     Current_User_Username: widget.username,
//                                                     Current_User_Jwt_Token: widget.jwttoken,);
//                                                 },));
//                                               }) ,
//                                             )
//                                                 .onTap (()
//                                             {
//                                               Navigator.push(context,MaterialPageRoute(builder: (context) {
//                                                 return User_Friend_Profile_Screen_P(Current_User_Jwt_Token: widget.jwttoken,
//                                                 Current_User_Username: widget.username,
//                                                   FriendUsername: user.username!,
//                                                   Current_User_Usertype: widget.usertype,
//                                                 );
//                                               },
//                                               )
//                                               );
//
//                                             }
//                                             );
//                                           },
//                                           itemCount: Filter_User_Info_List.length
//                                       );
//                                   }
//                                   else{
//                                     return
//                                       ListView.builder(
//                                           shrinkWrap: true,
//                                           itemBuilder: (context, index)
//                                           {
//                                             final user = User_Info_List[index];
//                                             return Card(
//                                               child: Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                                 children:
//                                                 [
//                                                   Text("Friend Username:${user.username}",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.05),),
//                                                   Icon(Icons.people_rounded),
//                                                 ],
//                                               )
//                                                   .onTap((){
//                                                 Navigator.push(context,MaterialPageRoute(builder: (context)
//                                                 {
//                                                   return User_Friend_Profile_Screen_P(
//                                                     FriendUsername:user.username!,
//                                                     Current_User_Usertype:widget.usertype ,
//                                                     Current_User_Username: widget.username,
//                                                     Current_User_Jwt_Token: widget.jwttoken,);
//                                                 },));
//                                               }) ,
//                                             )
//                                                 .onTap (()
//                                             {
//                                               Navigator.push(context,MaterialPageRoute(builder: (context) {
//                                                 return User_Friend_Profile_Screen_P(Current_User_Jwt_Token: widget.jwttoken,
//                                                   Current_User_Username: widget.username,
//                                                   FriendUsername: user.username!,
//                                                   Current_User_Usertype: widget.usertype,
//                                                 );
//                                               },
//                                               )
//                                               );
//                                             }
//                                             );
//                                           },
//                                           itemCount: User_Info_List.length
//                                       );
//                                   }
//                                 },
//                                 );
//                               }
//                               else
//                               {
//                                 return
//                                   Center(
//                                     child: Text(
//                                       "Please reopen app.",
//                                       style: TextStyle(color: Colors.red, fontSize: 16),
//                                     ),
//                                   );
//                               }
//                             }
//                         ),
//
//                         SizedBox(
//                           height: heightval*0.01,
//                         ),
//
//                         Row (
//                           children: [
//
//                             CommonButton_loading(label: "Insert Post",
//                                 onPressed: ()
//                                 {
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) {
//                                       return Insertpostscreen(username: widget.username, usertype: widget.usertype, jwttoken:widget.jwttoken);
//                                     },
//                                     )
//                                     );
//                                 },
//
//                               color:Colors.red,
//                               textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
//                               padding: const EdgeInsets.all(12),
//                               borderRadius:25.0,
//                               width: shortestval*0.35,
//                               height: shortestval*0.15,
//                               isLoading: isLoadingCont.isloading.value,
//                             ),
//
//                             CommonButton_loading(label: "Insert Campaign",
//                               onPressed: ()
//                               {
//
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                                   return InsertcampaignscreenP(username: widget.username, usertype: widget.usertype, jwttoken:widget.jwttoken);
//                                 },
//                                 )
//                                 );
//                               },
//
//                               color:Colors.red,
//                               textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
//                               padding: const EdgeInsets.all(12),
//                               borderRadius:25.0,
//                               width: shortestval*0.35,
//                               height: shortestval*0.15,
//                               isLoading: isLoadingCont.isloading.value,
//                             ),
//
//
//                           ],
//                         ),
//
//                         SizedBox(
//                           height: heightval*0.01,
//                         ),
//
//                         FutureBuilder<void>(
//                           future: Get_Advertisement_Info(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return Circular_pro_indicator_Yellow(context);
//                             }
//                             else if (snapshot.hasError) {
//                               // Handle any error from the future
//                               return Center(
//                                 child: Text(
//                                   "Error fetching advertisements. Please try again.",
//                                   style: TextStyle(color: Colors.red, fontSize: 16),
//                                 ),
//                               );
//                             }
//                             else if (snapshot.connectionState == ConnectionState.done) {
//                               return Ad_Info_List.isEmpty
//                                   ? const Center(
//                                 child: Text("No advertisement data available."),
//                               )
//                                   : Container(
//                                 // color: Colors.green,
//                                 height: heightval * 0.28,
//                                 width: widthval,
//                                 child: VxSwiper.builder(
//                                   itemCount: Ad_Info_List.length,
//                                   autoPlay: true,
//                                   enlargeCenterPage: false,  // Disable enlargement effect
//                                   viewportFraction: 1.0,    // Each item occupies full width
//                                   aspectRatio: 16 / 9,
//                                   scrollDirection: Axis.horizontal,
//                                   itemBuilder: (context, index) {
//                                     final ad = Ad_Info_List[index];
//                                     return Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         // Description Text
//                                         Text(
//                                           ad.adUrl!,
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         SizedBox(height: heightval * 0.01),
//                                         // Image converted from Base64 String
//                                         Expanded(
//                                           child: Container(
//                                             height: heightval * 0.5,
//                                             width: widthval,
//                                             decoration: BoxDecoration(
//                                               color: Colors.green,
//                                               borderRadius: BorderRadius.circular(16),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.black26,
//                                                   blurRadius: 8,
//                                                   offset: Offset(0, 4),
//                                                 ),
//                                               ],
//                                             ),
//                                             child:
//                                             ClipRRect(
//                                               borderRadius: BorderRadius.circular(16),
//                                               child: Image.memory(
//                                                 base64Decode(ad.adPhoto!),
//                                                 height:heightval*0.05 ,
//                                                 width: widthval,
//                                                 fit: BoxFit.cover
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               );
//                             }
//                             else {
//                               return Center(
//                                 child: Text(
//                                   "Please close and reopen app.",
//                                   style: TextStyle(color: Colors.red, fontSize: 16),
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//
//                         SizedBox(
//                           height: heightval*0.01,
//                         ),
//
//                         FutureBuilder<void>(
//                           future: Get_Donation_Info(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return Circular_pro_indicator_Yellow(context);
//                             }
//                             else if (snapshot.hasError) {
//                               // Handle any error from the future
//                               return Center(
//                                 child: Text(
//                                   "Error fetching donation info. Please try again.",
//                                   style: TextStyle(color: Colors.red, fontSize: 16),
//                                 ),
//                               );
//                             }
//                             else if (snapshot.connectionState == ConnectionState.done) {
//                               return Donation_Info_List.isEmpty
//                                   ? const Center(
//                                 child: Text("No donation data available."),
//                               )
//                                   :
//                               Container(
//                                 width: widthval,
//                                 height: heightval*0.18,
//                                 color: Colors.blueGrey,
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   physics: BouncingScrollPhysics(),
//                                   itemCount: Donation_Info_List.length,
//                                   itemBuilder: (context, index) {
//                                     final donation = Donation_Info_List[index];
//                                     return Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           // CircleAvatar to show postId
//                                           CircleAvatar(
//                                             radius: 30,
//                                             backgroundColor: Colors.lightGreen,
//                                             child: Text(
//                                               donation.postId.toString(),
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height:heightval*0.01),
//                                           // Column containing donor username and donate amount
//                                           Text(donation.donerUsername.toString(),
//                                             style: TextStyle(
//                                               fontSize: shortestval*0.05,
//                                              fontFamily: semibold
//                                             ),
//                                           ),
//                                           SizedBox(height:heightval*0.01),
//                                           // Donate Amount
//                                           Text(donation.donateAmount.toString(),
//                                             style: TextStyle(
//                                               fontSize: shortestval*0.05,
//                                              fontFamily: semibold
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               );
//                             }
//                             else {
//                               return Center(
//                                 child: Text(
//                                   "Please close and reopen app.",
//                                   style: TextStyle(color: Colors.red, fontSize: 16),
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//
//
//                         SizedBox(
//                           height: heightval*0.01,
//                         ),
//
//                         ExpansionTile(
//                           title:Text("Enter details to send invitation for meeting.", style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.06,color: Colors.black),),
//                           tilePadding: EdgeInsets.zero,
//                           childrenPadding: EdgeInsets.zero,
//                           children:
//                           [
//
//                             CommonTextField_obs_false_p("Enter the username of user.","", false, Invite_User_Username_Cont, context),
//                             CommonTextField_obs_false_p("Enter the date of meeting in AD(English date).","2025-01-01 01:01 pm", false, Time_Meeting_Cont, context),
//
//                           ],
//                         ),
//
//                         SizedBox(
//                           height: heightval*0.01,
//                         ),
//
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//
//
//                             IconButton(onPressed: ()
//                             {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => QrScannerScreen_P
//                                   (
//                                   usertype: widget.usertype,
//                                   jwttoken: widget.jwttoken,
//                                   username: widget.username,
//                                 )
//                                 ),
//                               );
//                             },
//                                 icon:Icon(Icons.qr_code_scanner_outlined,size: shortestval*0.25,
//                                 )
//                             ),
//
//                             IconButton(onPressed: ()async
//                             {
//
//                               if(Invite_User_Username_Cont.text.isEmptyOrNull || Time_Meeting_Cont.text.isEmptyOrNull)
//                                 {
//                                   Toastget().Toastmsg("Provide details to send invitation from above expansion tile.Click to expand it.");
//                                   return;
//                                 }
//
//                               final dateTimeRegex = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2} (AM|PM)$', caseSensitive: false);
//
//
//                               if (!dateTimeRegex.hasMatch(Time_Meeting_Cont.text)) {
//                                 Toastget().Toastmsg("Invalid DateTime format. Use: yyyy-MM-dd HH:mm am/pm (e.g. 2025-02-03 06:07 am)");
//                                 return;
//                               }
//
//                               int result=await Add_Notifications_Message_CM(not_type: "Meeting invitation for user confirmation", not_receiver_username: Invite_User_Username_Cont.text.toString().trim(),
//                                   not_message:"Dear user ${Invite_User_Username_Cont.text.toString().trim()} I want you to join meeting through chat and video option at date:${Time_Meeting_Cont.text.toString()} for verification of user to support.",
//                                   JwtToken:widget.jwttoken);
//                               if(result==1)
//                               {
//                                 Toastget_Long_Period().Toastmsg("Invitation for meeting send success.Your friend user will send back meeting confirmation status.Check in notifications.");
//                                 return;
//                               }
//                               else if(result==3){
//                                 Toastget().Toastmsg("Provide correct username.Invitation send fail.");
//                                 return;
//                               }
//                               else
//                               {
//                                 print("Retry adding notifications 2nd time in database table after one time fail in meeting invitation in actions screen.");
//                                 int result_2=await Add_Notifications_Message_CM(not_type: "Meeting invitation for user confirmation", not_receiver_username: Invite_User_Username_Cont.text.toString().trim(),
//                                     not_message:"Dear user ${Invite_User_Username_Cont.text.toString().trim()} I want you to join meeting through chat and video option at date:${Time_Meeting_Cont.text.toString()} for verification of user to support.",
//                                     JwtToken:widget.jwttoken);
//
//                                 if(result_2==1)
//                                 {
//                                   Toastget().Toastmsg("Invitation for meeting send success.");
//                                   return;
//                                 }
//                                 else if(result==3){
//                                   Toastget().Toastmsg("Provide correct username.Invitation send fail.");
//                                   return;
//                                 }
//                                 else
//                                 {
//                                   print("Serverv error.logout from app and retry");
//                                   Toastget_Long_Period().Toastmsg("Serverv error.logout from app and retry");
//                                   return;
//                                 }
//                               }
//
//                             },
//                                 icon: Icon(Icons.insert_invitation_rounded,size: shortestval*0.25,)
//                             )
//                           ],
//                         ),
//
//                       ],
//                     ),
//                   )
//               );
//           }
//           else if(orientation==Orientation.landscape)
//           {
//             return
//               Container(
//
//               );
//
//           }
//           else
//           {
//             return CircularProgressIndicator();
//           }
//         },
//         ),
//     );
//   }
// }
