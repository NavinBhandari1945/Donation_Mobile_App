import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/models/mobile/DonationModel.dart';
import 'package:hand_in_need/models/mobile/NotificationsModel.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'package:hand_in_need/views/mobile/profile/update_phone_number.dart';
import 'package:hand_in_need/views/mobile/profile/getx_cont_profile/is_new_notification.dart';
import 'package:hand_in_need/views/mobile/profile/update_address.dart';
import '../../../models/mobile/FriendInfoModel.dart';
import '../../../models/mobile/PostInfoModel.dart';
import '../../../models/mobile/UserInfoModel.dart';
import '../../constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/DonateOptionDialog.dart';
import '../home/Generate_QrCode_ScreenPost_p.dart';
import '../commonwidget/VideoPlayer_controller.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/common_button_loading.dart';
import '../commonwidget/getx_cont_pick_single_photo.dart';
import '../commonwidget/toast.dart';
import '../home/authentication_home_p.dart';
import 'package:http/http.dart' as http;
import 'UpdateEmail_p.dart';
import 'UpdatePassword_p.dart';
import 'User_Friend_Profile_Screen_P.dart';
import 'chatbot_screen_p.dart';
import 'getx_cont_profile/getx_cont_isloading_chnage_photo.dart';
import 'getx_cont_profile/getx_cont_isloading_donate_profile.dart';
import 'getx_cont_profile/getx_cont_isloading_logout_button.dart';
import 'getx_cont_profile/getx_cont_isloading_qr_profile.dart';
import 'package:excel/excel.dart' as Excel;

class Profilescreen_P extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Profilescreen_P({
    super.key,
    required this.username,
    required this.usertype,
    required this.jwttoken,
  });

  @override
  State<Profilescreen_P> createState() => _Profilescreen_PState();
}

class _Profilescreen_PState extends State<Profilescreen_P>
    with SingleTickerProviderStateMixin {
  final change_photo_cont_getx = Get.put(pick_single_photo_getx());
  final change_photo_cont_isloading =
      Get.put(Isloading_change_photo_profile_screen());
  final logout_button_cont_isloading =
      Get.put(Isloading_logout_button_profile_screen());
  final IsLoading_QR_Profile = Get.put(Isloading_QR_Profile());
  final IsLoading_Donate_Profile = Get.put(Isloading_Donate_Profile());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    checkJWTExpiration_Outside_Widget_Build_Method();
    New_Notification_Cont.Change_Is_New_Notification(false);
    _animationController.forward();
  }

  Future<void> checkJWTExpiration_Outside_Widget_Build_Method() async {
    try {
      int result = await checkJwtToken_initistate_user(
          widget.username, widget.usertype, widget.jwttoken);
      print(widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        print("Deleteing temporary directory success.");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AuthenticationHome()));
        Toastget().Toastmsg("Session End.Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for Profile screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleteing temporary directory success.");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AuthenticationHome()));
      Toastget().Toastmsg("Error.Relogin please.");
    }
  }

  List<UserInfoModel> userinfomodel_list = [];

  Future<void> getUserInfo(String username, String jwttoken) async {
    try {
      print("profile user info method called");
      const String url = Backend_Server_Url + "api/Profile/getuserinfo";
      Map<String, dynamic> usernameDict = {"Username": username};
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwttoken'
        },
        body: json.encode(usernameDict),
      );
      print("status code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("profile user info");
        Map<dynamic, dynamic> responseData = await jsonDecode(response.body);
        userinfomodel_list.clear();
        userinfomodel_list.add(UserInfoModel.fromJson(responseData));
        return;
      } else {
        userinfomodel_list.clear();
        print("Data insert in userinfo list failed.");
        return;
      }
    } catch (obj) {
      userinfomodel_list.clear();
      print("Exception caught while fetching user data for profile screen");
      print(obj.toString());
      return;
    }
  }

  Future<bool> UpdatePhoto(
      {required String username,
      required String jwttoken,
      required photo_bytes}) async {
    try {
      final String base64Image = base64Encode(photo_bytes as List<int>);
      const String url = Backend_Server_Url + "api/Profile/updatephoto";
      Map<String, dynamic> new_photo = {
        "Username": username,
        "Photo": base64Image
      };
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwttoken'
        },
        body: json.encode(new_photo),
      );
      if (response.statusCode == 200) {
        print("User authenticated");
        return true;
      } else {
        print("error");
        return false;
      }
    } catch (obj) {
      print("Exception caught while fetching user data for profile screen");
      print(obj.toString());
      return false;
    }
  }

  List<PostInfoModel> ProfilePostInfoList = [];

  Future<void> GetProfilePostInfo() async {
    try {
      print("Profile post info method called");
      const String url = Backend_Server_Url + "api/Profile/getprofilepostinfo";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json'
      };
      Map<String, dynamic> profilePostInfoBody = {
        "Username": "${widget.username}"
      };
      final response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(profilePostInfoBody));
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        ProfilePostInfoList.clear();
        ProfilePostInfoList.addAll(
            responseData.map((data) => PostInfoModel.fromJson(data)).toList());
        print("profile post list for profile count value");
        print(ProfilePostInfoList.length);
        return;
      } else {
        ProfilePostInfoList.clear();
        print("Data insert in profile post info for profile in list failed.");
        return;
      }
    } catch (obj) {
      ProfilePostInfoList.clear();
      print(
          "Exception caught while fetching post data for profile screen in http method");
      print(obj.toString());
      return;
    }
  }

  List<DonationModel> Donation_Info_Profile_Post = [];

  Future<int> Get_Profile_Donation_Post_Info() async {
    try {
      print("Profile post info method called");
      const String url = Backend_Server_Url + "api/Profile/get_donation_info";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json'
      };
      Map<String, dynamic> Profile_Donation_PostInfoBody = {
        "Username": "${widget.username}"
      };
      final response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(Profile_Donation_PostInfoBody));
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        Donation_Info_Profile_Post.clear();
        Donation_Info_Profile_Post.addAll(
            responseData.map((data) => DonationModel.fromJson(data)).toList());
        print("profile post donation list for profile count value");
        print(Donation_Info_Profile_Post.length);
        return 1;
      } else {
        Donation_Info_Profile_Post.clear();
        print(
            "Data insert in profile donation post info for profile in list failed.");
        return 2;
      }
    } catch (obj) {
      Donation_Info_Profile_Post.clear();
      print(
          "Exception caught while fetching post donation data for profile screen in http method");
      print(obj.toString());
      return 0;
    }
  }

  List<FriendInfoModel> FriendInfoList = [];

  Future<void> GetFriendInfo() async {
    try {
      print("post info method called for user Home screen.");
      const String url = Backend_Server_Url + "api/Profile/getfriendinfo";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json'
      };
      Map<String, dynamic> usernameDict = {"Username": widget.username};
      final response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(usernameDict));
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        FriendInfoList.clear();
        FriendInfoList.addAll(responseData
            .map((data) => FriendInfoModel.fromJson(data))
            .toList());
        print("Friend info list count value for profile scareen.");
        print(FriendInfoList.length);
        return;
      } else {
        FriendInfoList.clear();
        print(
            "Data insert in Friend info list for profile scareen failed  in profile screen..");
        return;
      }
    } catch (obj) {
      FriendInfoList.clear();
      print(
          "Exception caught while fetching friend info data for profile screen in http method");
      print(obj.toString());
      return;
    }
  }

  List<NotificationsModel> Notification_Info_List = [];
  List<NotificationsModel> Filter_New_Notifications = [];
  final New_Notification_Cont = Get.put(Is_New_Notification());

  Future<void> Get_Notification_Info() async {
    try {
      print("Get_Notification_Info method called for profile screen.");
      const String url = Backend_Server_Url + "api/Profile/get_not";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json'
      };
      Map<String, dynamic> usernameDict = {"Username": widget.username};
      final response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(usernameDict));
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        Notification_Info_List.clear();
        Notification_Info_List.addAll(responseData
            .map((data) => NotificationsModel.fromJson(data))
            .toList());
        print("Notification info list count: ${Notification_Info_List.length}");
        Map<dynamic, dynamic> userCredentials = await getUserCredentials();
        String? userLoginDateStr = userCredentials['UserLogindate'];
        if (userLoginDateStr != null &&
            userLoginDateStr.isNotEmpty &&
            Notification_Info_List.isNotEmpty) {
          DateTime userLoginDate = DateTime.parse(userLoginDateStr).toUtc();
          print("User Login Date (UTC): $userLoginDate");
          Filter_New_Notifications.clear();
          Filter_New_Notifications.addAll(
            Notification_Info_List.where((notification) {
              DateTime notificationDate =
                  DateTime.parse(notification.notDate!).toUtc();
              print("Notification Date (UTC): $notificationDate");
              return notificationDate.isAfter(userLoginDate);
            }).toList(),
          );
          print(
              "Filtered Notifications Count: ${Filter_New_Notifications.length}");
          New_Notification_Cont.Change_Is_New_Notification(
              Filter_New_Notifications.isNotEmpty);
        } else {
          Notification_Info_List.clear();
          Filter_New_Notifications.clear();
          New_Notification_Cont.Change_Is_New_Notification(false);
          print("No new notifications or invalid login date.");
        }
      } else {
        Notification_Info_List.clear();
        New_Notification_Cont.Change_Is_New_Notification(false);
        print("Failed to fetch notifications from API.");
      }
    } catch (e) {
      Notification_Info_List.clear();
      Filter_New_Notifications.clear();
      New_Notification_Cont.Change_Is_New_Notification(false);
      print("Exception while fetching notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    var shortestval = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Profile",
            style: TextStyle(
                fontFamily: bold,
                fontSize: 24,
                color: Colors.white,
                letterSpacing: 1.2)),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
        automaticallyImplyLeading: false,
        actions: [
          //friends drawer
          IconButton(
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            icon: Icon(Icons.people_alt_outlined, color: Colors.white),
          ),
          SizedBox(width: shortestval * 0.01),
          //Chatbot screen
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatbotScreen_P())),
            icon: Icon(Icons.book_outlined, color: Colors.white),
          ),
          SizedBox(width: shortestval * 0.01),
          //notification screen
          _buildNotificationIcon(),
          SizedBox(width: shortestval * 0.01),
        ],
      ),
      drawer: _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(shortestval * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: shortestval * 0.02),
                  _buildProfileHeader(),
                  SizedBox(height: shortestval * 0.02),
                  _buildSettingsSection(),
                  SizedBox(height: shortestval * 0.03),
                  _buildLogoutButton(),
                  SizedBox(height: shortestval * 0.03),
                  _buildNoteSection(),
                  SizedBox(height: shortestval * 0.03),
                  _buildPostsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return FutureBuilder<void>(
      future: Get_Notification_Info(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Circular_pro_indicator_Yellow(context);
        } else if (snapshot.hasError) {
          return Icon(Icons.notifications_none, color: Colors.white);
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Notification_Info_List.isEmpty
              ? Icon(Icons.notifications_none, color: Colors.white)
              : IconButton(
                  onPressed: () {
                    New_Notification_Cont.Change_Is_New_Notification(false);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildNotificationDialog(),
                    );
                  },
                  icon: Obx(
                    () => New_Notification_Cont.Is_New_Notification_Value.value
                        ? Icon(Icons.notifications_active,
                            color: Colors.yellow[700])
                        : Icon(Icons.notifications, color: Colors.white),
                  ),
                );
        }
        return _buildErrorText("Please reopen app.");
      },
    );
  }

  Widget _buildNotificationDialog() {
    var heightval = MediaQuery.of(context).size.height;
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return AlertDialog(
      title: Text("Notifications",
          style: TextStyle(fontFamily: bold, fontSize: shortestval * 0.08)),
      content: SizedBox(
        width: double.maxFinite,
        height: heightval * 0.4,
        child: ListView.builder(
          itemCount: Notification_Info_List.length,
          itemBuilder: (context, index) {
            final notification = Notification_Info_List[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: shortestval * 0.01),
              child: Padding(
                padding: EdgeInsets.all(shortestval * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title: ${notification.notType}",
                        style: TextStyle(
                            fontFamily: semibold,
                            fontSize: shortestval * 0.07)),
                    SizedBox(height: shortestval * 0.01),
                    Text("Message: ${notification.notMessage}",
                        style: TextStyle(
                            fontFamily: semibold,
                            fontSize: shortestval * 0.06)),
                    SizedBox(height: shortestval * 0.02),
                    Text("Date:${notification.notDate.toString()}",
                        style: TextStyle(
                            fontFamily: semibold,
                            color: Colors.black,
                            fontSize: shortestval * 0.05)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close",
                style: TextStyle(
                    fontFamily: semibold,
                    color: Colors.green[700],
                    fontSize: shortestval * 0.04)),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    var heightval = MediaQuery.of(context).size.height;
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return Drawer(
      child: FutureBuilder(
        future: GetFriendInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Circular_pro_indicator_Yellow(context);
          } else if (snapshot.hasError) {
            return _buildErrorText('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (FriendInfoList.isNotEmpty) {
              return ListView.builder(
                itemCount: FriendInfoList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[100],
                        child: Text(
                          FriendInfoList[index]
                              .firendUsername![0]
                              .toUpperCase(),
                          style: TextStyle(
                              color: Colors.green[700], fontFamily: bold),
                        ),
                      ),
                      title: Text(
                        "Friend: ${FriendInfoList[index].firendUsername}",
                        style: TextStyle(
                            fontFamily: semibold, fontSize: shortestval * 0.04),
                      ),
                      trailing:
                          Icon(Icons.people_rounded, color: Colors.green[700]),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => User_Friend_Profile_Screen_P(
                            FriendUsername:
                                FriendInfoList[index].firendUsername!,
                            Current_User_Usertype: widget.usertype,
                            Current_User_Username: widget.username,
                            Current_User_Jwt_Token: widget.jwttoken,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: Text(
                'No friends yet. Add some friends!',
                style: TextStyle(
                    fontFamily: semibold,
                    fontSize: shortestval * 0.045,
                    color: Colors.grey[600]),
              ),
            );
          }
          return _buildErrorText('Error. Relogin.');
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return Column(
      children: [
        FutureBuilder(
          future: getUserInfo(widget.username, widget.jwttoken),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(color: Colors.green[700]);
            } else if (snapshot.hasError) {
              return _buildErrorText('Error: ${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (userinfomodel_list.isNotEmpty) {
                return Column(
                  children: [
                    Container(
                      width: shortestval * 0.4,
                      height: shortestval * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: ClipOval(
                        child: userinfomodel_list[0].photo == null ||
                                userinfomodel_list[0].photo!.isEmpty
                            ? Image.asset('assets/default_photo.jpg',
                                fit: BoxFit.cover)
                            : Image.memory(
                                base64Decode(userinfomodel_list[0].photo!),
                                fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(height: shortestval * 0.02),
                    Text(
                      "Username: ${userinfomodel_list[0].username}",
                      style: TextStyle(
                          fontFamily: bold,
                          fontSize: shortestval * 0.05,
                          color: Colors.grey[800]),
                    ),
                  ],
                );
              }
              return _buildEmptyText('No image data available');
            }
            return _buildErrorText('Error. Relogin.');
          },
        ),
        SizedBox(height: shortestval * 0.02),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(
                horizontal: shortestval * 0.05, vertical: shortestval * 0.03),
          ),
          onPressed: _changeProfilePhoto,
          child: change_photo_cont_isloading.isloading.value
              ? Circular_pro_indicator_Yellow(context)
              : Text(
                  "Change Photo",
                  style: TextStyle(
                      fontFamily: semibold,
                      color: Colors.white,
                      fontSize: shortestval * 0.04),
                ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.03),
        child: Column(
          children: [
            _buildSettingItem(
                "Change Password",
                Updatepassword(
                    jwttoken: widget.jwttoken,
                    username: widget.username,
                    usertype: widget.usertype)),
            _buildSettingItem(
                "Change Email",
                Updateemail(
                    jwttoken: widget.jwttoken,
                    usertype: widget.usertype,
                    username: widget.username)),
            _buildSettingItem(
                "Change Phone Number",
                ChangePhoneNumber(
                    jwttoken: widget.jwttoken,
                    usertype: widget.usertype,
                    username: widget.username)),
            _buildSettingItem(
                "Change Address",
                UpdateAddress(
                    jwttoken: widget.jwttoken,
                    usertype: widget.usertype,
                    username: widget.username)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, Widget destination) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return ListTile(
      title: Text(title,
          style: TextStyle(
              fontFamily: semibold,
              fontSize: shortestval * 0.045,
              color: Colors.grey[800])),
      trailing: Icon(Icons.change_circle, color: Colors.green[700]),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => destination)),
    );
  }

  Widget _buildLogoutButton() {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return ElevatedButton(
      onPressed: _logout,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[600],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(
            horizontal: shortestval * 0.1, vertical: shortestval * 0.03),
      ),
      child: logout_button_cont_isloading.isloading.value
          ? Circular_pro_indicator_Yellow(context)
          : Text("Log Out",
              style: TextStyle(
                  fontFamily: bold,
                  color: Colors.white,
                  fontSize: shortestval * 0.045)),
    );
  }

  Widget _buildNoteSection() {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text("Note",
            style: TextStyle(
                fontFamily: bold,
                fontSize: shortestval * 0.05,
                color: Colors.grey[800])),
        children: [
          Padding(
            padding: EdgeInsets.all(shortestval * 0.03),
            child: Text(
              "Keep the screenshot of profile screen which is needed in future for confirmation of user while recovering password.",
              style: TextStyle(
                  fontFamily: semibold,
                  fontSize: shortestval * 0.04,
                  color: Colors.grey[700]),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsSection() {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return FutureBuilder<void>(
      future: GetProfilePostInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: Colors.green[700]);
        } else if (snapshot.hasError) {
          return _buildErrorText("Error fetching posts. Please try again.");
        } else if (snapshot.connectionState == ConnectionState.done) {
          return ProfilePostInfoList.isEmpty
              ? _buildEmptyText("No posts available.")
              : Column(
                  children: ProfilePostInfoList.map((post) =>
                      _buildPostCardProfilePostInfo(post, context)).toList(),
                );
        }
        return _buildErrorText("Please reopen app.");
      },
    );
  }

  Widget _buildPostCardProfilePostInfo(
      PostInfoModel post, BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widthval,
      margin: EdgeInsets.symmetric(
          vertical: shortestval * 0.02, horizontal: shortestval * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(shortestval * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${post.username} posted",
                    style: TextStyle(
                        fontFamily: semibold,
                        fontSize: shortestval * 0.045,
                        color: Colors.grey[800])),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  onSelected: (value) async {
                    if (value == 'download file') {
                      await downloadFilePost(
                          post.postFile!, post.fileExtension!);
                    } else if (value == 'download donation info') {
                      _downloadDonationInfo(post.postId! as int?);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'download file',
                      child: Text('Download Resources',
                          style: TextStyle(
                              fontFamily: semibold,
                              fontSize: shortestval * 0.04)),
                    ),
                    PopupMenuItem(
                      value: 'download donation info',
                      child: FutureBuilder(
                        future: Get_Profile_Donation_Post_Info(),
                        builder: (context, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? CircularProgressIndicator()
                                : snapshot.hasError
                                    ? Text('Error')
                                    : Text('Download Donation Info',
                                        style: TextStyle(
                                            fontFamily: semibold,
                                            fontSize: shortestval * 0.04)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: shortestval * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Post ID: ${post.postId}",
                    style: TextStyle(
                        fontSize: shortestval * 0.04, color: Colors.grey[700])),
                Text(post.dateCreated.toString().split("T").first,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: shortestval * 0.035)),
              ],
            ),
          ),
          ExpansionTile(
            title: Text("Description",
                style: TextStyle(
                    fontFamily: semibold,
                    fontSize: shortestval * 0.045,
                    color: Colors.grey[800])),
            tilePadding: EdgeInsets.symmetric(horizontal: shortestval * 0.03),
            children: [
              Padding(
                padding: EdgeInsets.all(shortestval * 0.03),
                child: Text(post.description!,
                    style: TextStyle(
                        color: Colors.grey[700], fontSize: shortestval * 0.04)),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(base64Decode(post.photo!),
                width: widthval, height: heightval * 0.25, fit: BoxFit.cover),
          ),
          SizedBox(height: shortestval * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: shortestval * 0.03),
            child: ElevatedButton(
              onPressed: () async {
                String video_file_path =
                    await writeBase64VideoToTempFilePost(post.video!);
                if (video_file_path.isNotEmpty) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoPlayerControllerScreen(
                              video_file_path: video_file_path)));
                } else {
                  Toastget().Toastmsg("No video data available.");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: shortestval * 0.02),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_fill,
                      size: shortestval * 0.06, color: Colors.white),
                  SizedBox(width: shortestval * 0.02),
                  Text("Play Video",
                      style: TextStyle(
                          fontFamily: semibold,
                          fontSize: shortestval * 0.04,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
          SizedBox(height: shortestval * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: shortestval * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(
                    () => SizedBox(
                      width: widthval * 0.45,
                      child: CommonButton_loading(
                        label: "Generate QR",
                        onPressed: () {
                          IsLoading_QR_Profile.change_isloadingval(true);
                          IsLoading_QR_Profile.change_isloadingval(false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QrCodeScreenPost_p(post: post)));
                        },
                        color: Colors.blue[600]!,
                        textStyle: TextStyle(
                            fontFamily: bold,
                            color: Colors.white,
                            fontSize: shortestval * 0.04),
                        padding: EdgeInsets.all(shortestval * 0.03),
                        borderRadius: 12.0,
                        width: widthval * 0.45,
                        height: heightval * 0.06,
                        isLoading: IsLoading_QR_Profile.isloading.value,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => SizedBox(
                    width: widthval * 0.45,
                    child: CommonButton_loading(
                      label: "Donate",
                      onPressed: () {
                        IsLoading_Donate_Profile.change_isloadingval(true);
                        DonateOption().donate(
                          context: context,
                          donerUsername: widget.username,
                          postId: post.postId!.toInt(),
                          receiver_useranme: post.username.toString(),
                          jwttoken: widget.jwttoken,
                          userType: widget.usertype,
                        );
                        IsLoading_Donate_Profile.change_isloadingval(false);
                      },
                      color: Colors.green[600]!,
                      textStyle: TextStyle(
                          fontFamily: bold,
                          color: Colors.white,
                          fontSize: shortestval * 0.04),
                      padding: EdgeInsets.all(shortestval * 0.03),
                      borderRadius: 12.0,
                      width: widthval * 0.45,
                      height: heightval * 0.06,
                      isLoading: IsLoading_Donate_Profile.isloading.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: shortestval * 0.02),
        ],
      ),
    );
  }

  void _changeProfilePhoto() async {
    try {
      change_photo_cont_isloading.change_isloadingval(true);
      bool result1 = await change_photo_cont_getx.pickImage();
      if (result1) {
        bool result2 = await UpdatePhoto(
          username: widget.username,
          jwttoken: widget.jwttoken,
          photo_bytes: change_photo_cont_getx.imageBytes.value,
        );
        if (result2) {
          Toastget().Toastmsg("Update success");
          change_photo_cont_getx.imageBytes.value = null;
          change_photo_cont_getx.imagePath.value = "";
          setState(() {});
        } else {
          Toastget().Toastmsg("Update failed");
        }
      } else {
        Toastget().Toastmsg("No image selected. Try again.");
      }
    } catch (obj) {
      print("Exception caught in change photo method.");
      Toastget().Toastmsg("Change photo failed. Try again.");
    } finally {
      change_photo_cont_isloading.change_isloadingval(false);
    }
  }

  void _logout() async {
    try {
      logout_button_cont_isloading.change_isloadingval(true);
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleting temporary directory success.");
      Toastget().Toastmsg("Logout Success");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AuthenticationHome()));
    } catch (obj) {
      print("Logout fail. Exception occur.");
      print("${obj.toString()}");
      Toastget().Toastmsg("Logout fail. Try again.");
    } finally {
      logout_button_cont_isloading.change_isloadingval(false);
    }
  }

  void _downloadDonationInfo(int? postId) async {
    var excel = Excel.Excel.createExcel();
    var sheet = excel['Donations'];
    sheet.appendRow([
      Excel.TextCellValue("Donate ID"),
      Excel.TextCellValue("Donor Username"),
      Excel.TextCellValue("Receiver Username"),
      Excel.TextCellValue("Amount"),
      Excel.TextCellValue("Date"),
      Excel.TextCellValue("Post ID"),
      Excel.TextCellValue("Payment Method"),
    ]);
    var filteredDonations = Donation_Info_Profile_Post.where(
        (donation) => donation.postId == postId).toList();
    for (var donation in filteredDonations) {
      sheet.appendRow([
        donation.donateId != null
            ? Excel.IntCellValue(donation.donateId!.toInt())
            : null,
        Excel.TextCellValue(donation.donerUsername ?? ""),
        Excel.TextCellValue(donation.receiverUsername ?? ""),
        donation.donateAmount != null
            ? Excel.DoubleCellValue(donation.donateAmount!.toDouble())
            : null,
        Excel.TextCellValue(donation.donateDate ?? ""),
        donation.postId != null
            ? Excel.IntCellValue(donation.postId!.toInt())
            : null,
        Excel.TextCellValue(donation.paymentMethod ?? ""),
      ]);
    }
    var fileBytes = excel.save();
    if (fileBytes != null) {
      String base64String = base64Encode(fileBytes);
      String fileExtension = "xlsx";
      await Download_Donation_File_Post(base64String, fileExtension);
    }
  }

  Widget _buildErrorText(String message) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return Center(
      child: Text(
        message,
        style: TextStyle(
            color: Colors.red[700],
            fontSize: shortestval * 0.045,
            fontFamily: semibold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyText(String message) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return Center(
      child: Text(
        message,
        style: TextStyle(
            fontSize: shortestval * 0.045,
            fontFamily: semibold,
            color: Colors.grey[600]),
      ),
    );
  }
}
