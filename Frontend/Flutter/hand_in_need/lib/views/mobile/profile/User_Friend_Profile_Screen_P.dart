import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
import 'package:http/http.dart' as http;
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../models/mobile/PostInfoModel.dart';
import '../../../models/mobile/UserInfoModel.dart';
import '../../constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/DonateOptionDialog.dart';
import '../home/Generate_QrCode_ScreenPost_p.dart';
import '../commonwidget/VideoPlayer_controller.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/common_button_loading.dart';
import '../commonwidget/toast.dart';
import '../constant/constant.dart';
import '../home/authentication_home_p.dart';
import 'getx_cont_profile/Is_Friend_Or_Not_getx_cont.dart';
import 'getx_cont_profile/isloading_donate_friend_profile.dart';
import 'getx_cont_profile/isloading_friend_qr_profile.dart';

class User_Friend_Profile_Screen_P extends StatefulWidget {
  final String FriendUsername;
  final String Current_User_Username;
  final String Current_User_Usertype;
  final String Current_User_Jwt_Token;
  const User_Friend_Profile_Screen_P({
    super.key,
    required this.Current_User_Jwt_Token,
    required this.Current_User_Username,
    required this.Current_User_Usertype,
    required this.FriendUsername,
  });

  @override
  State<User_Friend_Profile_Screen_P> createState() =>
      _User_Friend_Profile_Screen_PState();
}

class _User_Friend_Profile_Screen_PState
    extends State<User_Friend_Profile_Screen_P>
    with SingleTickerProviderStateMixin {
  final IsLoading_QR_Friend_Profile = Get.put(Isloading_QR_friend_Profile());
  final IsLoading_Donate_Friend_Profile =
      Get.put(Isloading_Donate_friend_Profile());
  final Is_Friend_Or_Not_cont = Get.put(Is_Friend_Or_Not_getx_cont());
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
    _animationController.forward();

    try {
      Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(false);
      checkJWTExpiration_Outside_Widget_Build_Method();
      Check_Friend_Or_Not(
        Friend_Username: widget.FriendUsername,
        Curent_User_JwtToken: widget.Current_User_Jwt_Token,
        Current_User_Username: widget.Current_User_Username,
      );
      _eventListener = JitsiMeetEventListener(
        conferenceJoined: (url) => debugPrint("Conference Joined: url: $url"),
        conferenceTerminated: (url, error) =>
            debugPrint("Conference Terminated: url: $url, error: $error"),
        conferenceWillJoin: (url) =>
            debugPrint("Conference Will Join: url: $url"),
        participantJoined: (email, name, role, participantId) {
          debugPrint(
              "Participant Joined: email: $email, name: $name, role: $role, participantId: $participantId");
          setState(() => participants.add(participantId!));
        },
        participantLeft: (participantId) {
          debugPrint("Participant Left: participantId: $participantId");
          setState(() => participants.remove(participantId));
        },
      );
    } catch (obj) {
      print(
          "Exception caught in initState method of User friend profile screen.");
      print(obj.toString());
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<int> Add_Friend(
      {required String Friend_Username,
      required String Current_User_Username,
      required String Curent_User_JwtToken}) async {
    try {
      const String url = Backend_Server_Url + "api/Profile/addfriend";
      Map<String, dynamic> Check_Username_Map = {
        "FirendUsername": Friend_Username,
        "Username": Current_User_Username,
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $Curent_User_JwtToken'
        },
        body: json.encode(Check_Username_Map),
      );
      if (response.statusCode == 200) {
        print("Add friend success.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(true);
        return 1;
      } else {
        print("Add friend fail.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(false);
        return 2;
      }
    } catch (obj) {
      Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(false);
      print("Exception caught while adding friend or not.");
      print(obj.toString());
      return 0;
    }
  }

  Future<int> Remove_Friend(
      {required String Friend_Username,
      required String Current_User_Username,
      required String Curent_User_JwtToken}) async {
    try {
      const String url = Backend_Server_Url + "api/Profile/removefriend";
      Map<String, dynamic> Check_Username_Map = {
        "Friend_User_Username": Friend_Username,
        "Current_User_Username": Current_User_Username,
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $Curent_User_JwtToken'
        },
        body: json.encode(Check_Username_Map),
      );
      if (response.statusCode == 200) {
        print("Friend remove.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(false);
        return 1;
      } else if (response.statusCode == 9000) {
        print("Friend remove exception caught in backend.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(true);
        return 2;
      } else if (response.statusCode == 9001) {
        print("Friend remove fail. No friend found in database.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(true);
        return 3;
      } else {
        print("Friend remove other status code.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(true);
        return 4;
      }
    } catch (obj) {
      Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(true);
      print("Exception caught while removing friend.");
      print(obj.toString());
      return 0;
    }
  }

  Future<void> Check_Friend_Or_Not(
      {required String Friend_Username,
      required String Current_User_Username,
      required String Curent_User_JwtToken}) async {
    try {
      print("Check friend or not method start");
      const String url = Backend_Server_Url + "api/Profile/check_friend_or_not";
      Map<String, dynamic> Check_Username_Map = {
        "FriendUsername": Friend_Username,
        "CurrentUserusername": Current_User_Username,
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $Curent_User_JwtToken'
        },
        body: json.encode(Check_Username_Map),
      );
      print(
          "Is_Friend_Or_Not_cont value after check method called in http method after response.");
      print(Is_Friend_Or_Not_cont.Is_Friend_Or_Not.value);
      if (response.statusCode == 200) {
        print("Friend true.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(true);
      } else {
        print("Friend false.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(false);
      }
    } catch (obj) {
      print("Friend false.");
      Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(false);
      print("Exception caught while checking Friend or not in http method.");
      print(obj.toString());
    }
  }

  Future<void> checkJWTExpiration_Outside_Widget_Build_Method() async {
    try {
      int result = await checkJwtToken_initistate_user(
          widget.Current_User_Username,
          widget.Current_User_Usertype,
          widget.Current_User_Jwt_Token);
      print(widget.Current_User_Jwt_Token);
      if (result == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AuthenticationHome()));
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for Profile screen.");
      print(obj.toString());
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AuthenticationHome()));
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  List<UserInfoModel> Friend_Profile_userinfomodel_list = [];
  Future<void> getUserInfo(
      {required String Friend_Username,
      required String CurrentUser_JwtToken}) async {
    try {
      const String url = Backend_Server_Url + "api/Profile/getuserinfo";
      Map<String, dynamic> usernameDict = {"Username": Friend_Username};
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $CurrentUser_JwtToken'
        },
        body: json.encode(usernameDict),
      );
      if (response.statusCode == 200) {
        print("profile post info");
        Map<dynamic, dynamic> responseData = await jsonDecode(response.body);
        Friend_Profile_userinfomodel_list.clear();
        Friend_Profile_userinfomodel_list.add(
            UserInfoModel.fromJson(responseData));
      } else {
        Friend_Profile_userinfomodel_list.clear();
        print(
            "Data insert in userinfo list failed in friend profile http method.");
      }
    } catch (obj) {
      Friend_Profile_userinfomodel_list.clear();
      print(
          "Exception caught while fetching user data for friend profile http method.");
      print(obj.toString());
    }
  }

  List<PostInfoModel> Friend_Profile_PostInfo_List = [];
  Future<void> GetProfilePostInfo() async {
    try {
      print("Profile post info method called");
      const String url = Backend_Server_Url + "api/Profile/getprofilepostinfo";
      final headers = {
        'Authorization': 'Bearer ${widget.Current_User_Jwt_Token}',
        'Content-Type': 'application/json'
      };
      Map<String, dynamic> profilePostInfoBody = {
        "Username": "${widget.FriendUsername}"
      };
      final response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(profilePostInfoBody));
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        Friend_Profile_PostInfo_List.clear();
        Friend_Profile_PostInfo_List.addAll(
            responseData.map((data) => PostInfoModel.fromJson(data)).toList());
        print("profile post list for friend profile count value");
        print(Friend_Profile_PostInfo_List.length);
      } else {
        Friend_Profile_PostInfo_List.clear();
        print(
            "Data insert in friend profile post info for profile in list failed.");
      }
    } catch (obj) {
      Friend_Profile_PostInfo_List.clear();
      print(
          "Exception caught while fetching friend profile post data for friend profile screen in http method");
      print(obj.toString());
    }
  }

  final _jitsiMeetPlugin = JitsiMeet();
  Set<String> participants = {};
  late JitsiMeetEventListener _eventListener;

  Future<void> joinMeeting() async {
    try {
      List<String> usernames = [
        widget.Current_User_Username,
        widget.FriendUsername
      ];
      usernames.sort();
      String roomId = "${usernames.join('_')}_Room";
      var options = JitsiMeetConferenceOptions(
        serverURL: "https://meet.ffmuc.net",
        room: roomId,
        configOverrides: {
          "startWithAudioMuted": false,
          "startWithVideoMuted": false,
          "subject": "Video Call with ${widget.FriendUsername}",
        },
        featureFlags: {
          "chatEnabled": true,
          "inviteEnabled": false,
          "meetingNameEnabled": false,
          "welcomePageEnabled": false,
          "preJoinPageEnabled": false,
          "unsaferoomwarning.enabled": false,
        },
        userInfo: JitsiMeetUserInfo(
            displayName: widget.Current_User_Username,
            email: "${widget.Current_User_Username}@example.com"),
      );
      await _jitsiMeetPlugin.join(options, _eventListener);
      debugPrint("Meeting joined successfully");
    } catch (e) {
      debugPrint("Error joining meeting: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to join meeting: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend Profile",
            style: TextStyle(
                fontFamily: bold,
                fontSize: 24,
                color: Colors.white,
                letterSpacing: 1.2)),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
        actions: [
          IconButton(
            onPressed: () async => await joinMeeting(),
            icon: Stack(
              children: [
                Icon(Icons.chat, color: Colors.blue.withOpacity(0.5), size: 30),
                Icon(Icons.video_call, color: Colors.blue, size: 30),
              ],
            ),
          ),
        ],
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

  Widget _buildPortraitLayout(
      double shortestval, double widthval, double heightval) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.03),
        child: Column(
          children: [
            SizedBox(height: shortestval * 0.03),
            _buildProfilePhoto(shortestval),
            SizedBox(height: shortestval * 0.03),
            _buildFriendActions(shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
            _buildUsername(shortestval),
            SizedBox(height: shortestval * 0.03),
            _buildPostsList(shortestval, widthval, heightval, isPortrait: true),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(
      double shortestval, double widthval, double heightval) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(height: shortestval * 0.03),
                  _buildProfilePhoto(shortestval),
                  SizedBox(height: shortestval * 0.03),
                  _buildFriendActions(shortestval, widthval),
                  SizedBox(height: shortestval * 0.03),
                  _buildUsername(shortestval),
                ],
              ),
            ),
            SizedBox(width: shortestval * 0.03),
            Expanded(
              flex: 2,
              child: _buildPostsList(shortestval, widthval, heightval,
                  isPortrait: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(double shortestval) {
    return FutureBuilder(
      future: getUserInfo(
          CurrentUser_JwtToken: widget.Current_User_Jwt_Token,
          Friend_Username: widget.FriendUsername),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: Colors.green[700]);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}',
              style: TextStyle(
                  color: Colors.red[700], fontSize: shortestval * 0.04));
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (Friend_Profile_userinfomodel_list.isNotEmpty) {
            return Container(
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
                child: Friend_Profile_userinfomodel_list[0].photo == null ||
                        Friend_Profile_userinfomodel_list[0].photo!.isEmpty
                    ? Image.asset('assets/default_photo.jpg', fit: BoxFit.cover)
                    : Image.memory(
                        base64Decode(
                            Friend_Profile_userinfomodel_list[0].photo!),
                        fit: BoxFit.cover),
              ),
            );
          } else {
            return Text('No image data available',
                style: TextStyle(
                    fontSize: shortestval * 0.04, color: Colors.grey[600]));
          }
        }
        return Text('Error. Relogin.',
            style: TextStyle(
                color: Colors.red[700], fontSize: shortestval * 0.04));
      },
    );
  }

  Widget _buildFriendActions(double shortestval, double widthval) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: widthval * 0.3), // Cap the width to avoid overflow
            child: Obx(
              () => Commonbutton(
                "${Is_Friend_Or_Not_cont.Is_Friend_Or_Not.value ? "Friend" : "Add friend"}",
                () async {
                  if (widget.Current_User_Username == widget.FriendUsername) {
                    Toastget().Toastmsg("Same user cannot be friend.");
                    return;
                  }
                  if (Is_Friend_Or_Not_cont.Is_Friend_Or_Not.value) {
                    Toastget().Toastmsg("You are already friend.");
                    return;
                  } else {
                    int result = await Add_Friend(
                      Friend_Username: widget.FriendUsername,
                      Current_User_Username: widget.Current_User_Username,
                      Curent_User_JwtToken: widget.Current_User_Jwt_Token,
                    );
                    if (result == 1) {
                      Toastget().Toastmsg("Add friend success");
                    } else {
                      Toastget().Toastmsg("Add friend fail. Try again.");
                    }
                  }
                },
                context,
                Is_Friend_Or_Not_cont.Is_Friend_Or_Not.value
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
        ),
        SizedBox(width: shortestval * 0.02),
        Container(
          width: shortestval * 0.1,
          height: shortestval * 0.1,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red[700],
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
            ],
          ),
          child: IconButton(
            onPressed: () async {
              if (!Is_Friend_Or_Not_cont.Is_Friend_Or_Not.value) {
                Toastget().Toastmsg("You are not friend please add first.");
              } else {
                int result = await Remove_Friend(
                  Friend_Username: widget.FriendUsername,
                  Current_User_Username: widget.Current_User_Username,
                  Curent_User_JwtToken: widget.Current_User_Jwt_Token,
                );
                if (result == 1) {
                  Toastget().Toastmsg("Remove friend success");
                } else {
                  Toastget().Toastmsg("Remove friend fail. Try again.");
                }
              }
            },
            icon: Icon(Icons.delete_outline_outlined,
                color: Colors.white, size: shortestval * 0.06),
          ),
        ),
      ],
    );
  }

  Widget _buildUsername(double shortestval) {
    return FutureBuilder(
      future: getUserInfo(
          Friend_Username: widget.FriendUsername,
          CurrentUser_JwtToken: widget.Current_User_Jwt_Token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('UserName:',
              style: TextStyle(
                  fontFamily: semibold,
                  fontSize: shortestval * 0.05,
                  color: Colors.grey[800]));
        } else if (snapshot.hasError) {
          return Text('UserName:',
              style: TextStyle(
                  fontFamily: semibold,
                  fontSize: shortestval * 0.05,
                  color: Colors.grey[800]));
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (Friend_Profile_userinfomodel_list.isNotEmpty) {
            return Text(
              "UserName: ${Friend_Profile_userinfomodel_list[0].username}",
              style: TextStyle(
                  fontFamily: semibold,
                  fontSize: shortestval * 0.05,
                  color: Colors.grey[800]),
            );
          } else {
            return Text('UserName:',
                style: TextStyle(
                    fontFamily: semibold,
                    fontSize: shortestval * 0.05,
                    color: Colors.grey[800]));
          }
        }
        return Text('UserName:',
            style: TextStyle(
                fontFamily: semibold,
                fontSize: shortestval * 0.05,
                color: Colors.grey[800]));
      },
    );
  }

  Widget _buildPostsList(double shortestval, double widthval, double heightval,
      {required bool isPortrait}) {
    return FutureBuilder<void>(
      future: GetProfilePostInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: Colors.green[700]);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error fetching posts. Please logout and reopen again.",
              style: TextStyle(
                  color: Colors.red[700],
                  fontSize: shortestval * 0.04,
                  fontFamily: semibold),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Friend_Profile_PostInfo_List.isEmpty
              ? Center(
                  child: Text(
                    "No post available.",
                    style: TextStyle(
                        fontSize: shortestval * 0.045,
                        fontFamily: semibold,
                        color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Friend_Profile_PostInfo_List.length,
                  itemBuilder: (context, index) {
                    return _buildPostCard(
                        Friend_Profile_PostInfo_List[index], context,
                        isPortrait: isPortrait,
                        shortestval: shortestval,
                        widthval: widthval,
                        heightval: heightval);
                  },
                );
        }
        return Center(
          child: Text(
            "Please logout and relogin app.",
            style: TextStyle(
                color: Colors.red[700],
                fontSize: shortestval * 0.04,
                fontFamily: semibold),
          ),
        );
      },
    );
  }

  Widget _buildPostCard(PostInfoModel post, BuildContext context,
      {required bool isPortrait,
      required double shortestval,
      required double widthval,
      required double heightval}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isPortrait ? widthval : widthval * 0.45,
      margin: EdgeInsets.symmetric(vertical: shortestval * 0.015),
      padding: EdgeInsets.all(shortestval * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(post, shortestval),
          Padding(
            padding: EdgeInsets.symmetric(vertical: shortestval * 0.01),
            child: Text("Post id = ${post.postId}",
                style: TextStyle(
                    fontSize: shortestval * 0.04, color: Colors.grey[700])),
          ),
          _buildPostDescription(post, shortestval),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              base64Decode(post.photo!),
              width: isPortrait ? widthval : widthval * 0.45,
              height: isPortrait ? heightval * 0.25 : heightval * 0.35,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: shortestval * 0.02),
          _buildPostVideoButton(
              post, context, shortestval, widthval, heightval),
          _buildPostActionButtons(
              post, context, shortestval, widthval, heightval,
              isPortrait: isPortrait),
        ],
      ),
    );
  }

  Widget _buildPostHeader(PostInfoModel post, double shortestval) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${post.username} posted post.",
          style: TextStyle(
              fontFamily: semibold,
              fontSize: shortestval * 0.045,
              color: Colors.grey[800]),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert,
              color: Colors.grey[600], size: shortestval * 0.06),
          onSelected: (value) async {
            if (value == 'download file') {
              await downloadFilePost(post.postFile!, post.fileExtension!);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'download file',
              child: Text(
                'Download Resources',
                style: TextStyle(
                    fontFamily: semibold,
                    color: Colors.grey[800],
                    fontSize: shortestval * 0.04),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPostDescription(PostInfoModel post, double shortestval) {
    return ExpansionTile(
      title: Text(
        "Description for need",
        style: TextStyle(
            fontFamily: semibold,
            fontSize: shortestval * 0.045,
            color: Colors.grey[800]),
      ),
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(post.description!,
              style: TextStyle(
                  color: Colors.grey[700], fontSize: shortestval * 0.04)),
        ),
      ],
    );
  }

  Widget _buildPostVideoButton(PostInfoModel post, BuildContext context,
      double shortestval, double widthval, double heightval) {
    return Container(
      height: heightval * 0.06,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          String video_file_path =
              await writeBase64VideoToTempFilePost(post.video!);
          if (video_file_path != null && video_file_path.isNotEmpty) {
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_fill,
                size: shortestval * 0.06, color: Colors.white),
            SizedBox(width: shortestval * 0.02),
            Text(
              "Play Video",
              style: TextStyle(
                  fontFamily: semibold,
                  fontSize: shortestval * 0.04,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostActionButtons(PostInfoModel post, BuildContext context,
      double shortestval, double widthval, double heightval,
      {required bool isPortrait}) {
    return Padding(
      padding: EdgeInsets.only(top: shortestval * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(
              () => CommonButton_loading(
                label: "Generate QR",
                onPressed: () {
                  IsLoading_QR_Friend_Profile.change_isloadingval(true);
                  IsLoading_QR_Friend_Profile.change_isloadingval(false);
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
                    fontSize:
                        isPortrait ? shortestval * 0.04 : shortestval * 0.03,
                    overflow: TextOverflow.ellipsis),
                padding: EdgeInsets.symmetric(
                    horizontal: shortestval * 0.01,
                    vertical: shortestval * 0.02),
                borderRadius: 12.0,
                width: isPortrait ? widthval * 0.45 : widthval * 0.18,
                height: heightval * 0.06,
                isLoading: IsLoading_QR_Friend_Profile.isloading.value,
              ),
            ),
          ),
          SizedBox(width: shortestval * 0.02),
          Expanded(
            child: Obx(
              () => CommonButton_loading(
                label: "Donate",
                onPressed: () {
                  IsLoading_Donate_Friend_Profile.change_isloadingval(true);
                  DonateOption().donate(
                    context: context,
                    donerUsername: widget.Current_User_Username,
                    postId: post.postId!.toInt(),
                    receiver_useranme: post.username.toString(),
                    jwttoken: widget.Current_User_Jwt_Token,
                    userType: widget.Current_User_Usertype,
                  );
                  IsLoading_Donate_Friend_Profile.change_isloadingval(false);
                },
                color: Colors.green[600]!,
                textStyle: TextStyle(
                    fontFamily: bold,
                    color: Colors.white,
                    fontSize:
                        isPortrait ? shortestval * 0.04 : shortestval * 0.03,
                    overflow: TextOverflow.ellipsis),
                padding: EdgeInsets.symmetric(
                    horizontal: shortestval * 0.01,
                    vertical: shortestval * 0.02),
                borderRadius: 12.0,
                width: isPortrait ? widthval * 0.45 : widthval * 0.18,
                height: heightval * 0.06,
                isLoading: IsLoading_Donate_Friend_Profile.isloading.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}