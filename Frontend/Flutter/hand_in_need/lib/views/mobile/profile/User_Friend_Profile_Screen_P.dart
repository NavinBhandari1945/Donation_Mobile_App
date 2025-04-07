import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
// import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

class User_Friend_Profile_Screen_P extends StatefulWidget
{
  final String FriendUsername;
  final String Current_User_Username;
  final String Current_User_Usertype;
  final String Current_User_Jwt_Token;
  const User_Friend_Profile_Screen_P({super.key,required this.Current_User_Jwt_Token,required this.Current_User_Username,
    required this.Current_User_Usertype,required this.FriendUsername});
  @override
  State<User_Friend_Profile_Screen_P> createState() => _User_Friend_Profile_Screen_PState();
}

class _User_Friend_Profile_Screen_PState extends State<User_Friend_Profile_Screen_P> {
  final IsLoading_QR_Friend_Profile=Get.put(Isloading_QR_friend_Profile());
  final IsLoading_Donate_Friend_Profile=Get.put(Isloading_Donate_friend_Profile());
  final Is_Friend_Or_Not_cont=Get.put(Is_Friend_Or_Not_getx_cont());


  Future<int> Add_Friend({required String Friend_Username,required String Current_User_Username, required String Curent_User_JwtToken}) async
  {
    try {
      // API endpoint
      // var url = "http://10.0.2.2:5074/api/Profile/getuserinfo";
      const String url = Backend_Server_Url+"api/Profile/addfriend";
      Map<String, dynamic> Check_Username_Map =
      {
        "FirendUsername": Friend_Username,
        "Username": Current_User_Username,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $Curent_User_JwtToken'
        },
        body: json.encode(Check_Username_Map),
      );

      // Handling the response
      if (response.statusCode == 200)
      {
        print("Add frend success.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(true);
        return 1;
      }
      else
      {
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

  Future<int> Remove_Friend({required String Friend_Username,required String Current_User_Username, required String Curent_User_JwtToken}) async
  {
    try {
      // API endpoint
      // var url = "http://10.0.2.2:5074/api/Profile/getuserinfo";
      const String url = Backend_Server_Url+"api/Profile/removefriend";
      Map<String, dynamic> Check_Username_Map =
      {
        "Friend_User_Username": Friend_Username,
        "Current_User_Username": Current_User_Username,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $Curent_User_JwtToken'
        },
        body: json.encode(Check_Username_Map),
      );

      // Handling the response
      if (response.statusCode == 200)
      {
        print("Friend remove.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(false);
        return 1;
      }
      else if (response.statusCode == 9000)
      {
        print("Frend remove exception caught in backend.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(true);
        return 2;
      }
      else if (response.statusCode == 9001)
      {
        print("Frend remove fail.No friend found in database.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(true);
        return 3;
      }
      else
      {
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

  Future<void> Check_Friend_Or_Not({required String Friend_Username,required String Current_User_Username, required String Curent_User_JwtToken}) async
  {
    try {
      // API endpoint
      // var url = "http://10.0.2.2:5074/api/Profile/getuserinfo";
      print("Check friend or not method start");
      const String url = Backend_Server_Url+"api/Profile/check_friend_or_not";
      Map<String, dynamic> Check_Username_Map =
      {
        "FriendUsername": Friend_Username,
        "CurrentUserusername": Current_User_Username,
      };

      print("Friend or not details.");
      print(Check_Username_Map);
      print("Stop");

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $Curent_User_JwtToken'
        },
        body: json.encode(Check_Username_Map),
      );

      print("Is_Friend_Or_Not_cont value after check method callled in http method after response.");
      print(Is_Friend_Or_Not_cont.Is_Friend_Or_Not.value);

      // Handling the response
      if (response.statusCode == 200)
      {
        print("Friend true.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(true);
        return;
      }
      else
      {
        print("Friend false.");
        Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(false);
        return;
      }
    } catch (obj) {
      print("Friend false.");
      Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(false);
      print("Exception caught while checking Friend or not in http method.");
      print(obj.toString());
      return;
    }
  }

  Future<void> checkJWTExpiration_Outside_Widget_Build_Method()async
  {
    try {
      int result = await checkJwtToken_initistate_user(
          widget.Current_User_Username, widget.Current_User_Usertype, widget.Current_User_Jwt_Token);
      print(widget.Current_User_Jwt_Token);
      if (result == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) {
          return AuthenticationHome();
        },)
        );
        Toastget().Toastmsg("Session End.Relogin please.");
      }
    }
    catch(obj)
    {
      print("Exception caught while verifying jwt for Profile screen.");
      print(obj.toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return AuthenticationHome();
      },)
      );
      Toastget().Toastmsg("Error.Relogin please.");
    }
  }

  List<UserInfoModel> Friend_Profile_userinfomodel_list=[];

  Future<void> getUserInfo({required String Friend_Username,required String CurrentUser_JwtToken}) async {
    try {
      // API endpoint
      // var url = "http://10.0.2.2:5074/api/Profile/getuserinfo";
      const String url =Backend_Server_Url+"api/Profile/getuserinfo";
      Map<String, dynamic> usernameDict =
      {
        "Username": Friend_Username,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $CurrentUser_JwtToken'
        },
        body: json.encode(usernameDict),
      );

      // Handling the response
      if (response.statusCode == 200)
      {
        print("profile post info");
        Map<dynamic, dynamic> responseData = await jsonDecode(response.body);
        Friend_Profile_userinfomodel_list.clear();
        Friend_Profile_userinfomodel_list.add(UserInfoModel.fromJson(responseData));
        return;
      }
      else
      {
        Friend_Profile_userinfomodel_list.clear();
        print("Data insert in userinfo tlist failed in friend profile http method .");
        return;
      }
    } catch (obj) {
      Friend_Profile_userinfomodel_list.clear();
      print("Exception caught while fetching user data for friend profile http method .");
      print(obj.toString());
      return;
    }
  }



  List<PostInfoModel> Friend_Profile_PostInfo_List = [];

  Future<void> GetProfilePostInfo() async {
    try {
      print("Profile post info method called");
      // var url = "http://10.0.2.2:5074/api/Profile/getprofilepostinfo";
      const String url = Backend_Server_Url+"api/Profile/getprofilepostinfo";
      final headers =
      {
        'Authorization': 'Bearer ${widget.Current_User_Jwt_Token}',
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> profilePostInfoBody =
      {
        "Username": "${widget.FriendUsername}"
      };


      final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(profilePostInfoBody)
      );

      if (response.statusCode == 200)
      {
        List<dynamic> responseData = await jsonDecode(response.body);
        Friend_Profile_PostInfo_List.clear();
        Friend_Profile_PostInfo_List.addAll
          (
          responseData.map((data) => PostInfoModel.fromJson(data)).toList(),
        );
        print("profile post list for friend profile count value");
        print(Friend_Profile_PostInfo_List.length);
        return;
      } else
      {
        Friend_Profile_PostInfo_List.clear();
        print("Data insert in frined profile  post info for profile in list failed.");
        return;
      }
    } catch (obj) {
      Friend_Profile_PostInfo_List.clear();
      print("Exception caught while fetching friend profile post data for friend profile screen in http method");
      print(obj.toString());
      return;
    }
  }
  
  Widget _build_Post_Card_Friend_Profile_PostInfo_(PostInfoModel post, BuildContext context)
  {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return
      Container(
        width: widthval,
        height: heightval*0.65,
        margin: EdgeInsets.only(bottom: shortestval*0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
        ),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children:
          [
            // Row 1: Username ,date and 3-dot button for downloading resources
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
              [

                Text("${post.username} posted post.", style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.06)),

                PopupMenuButton<String>(
                  onSelected: (value) async
                  {
                    if (value == 'download file')
                    {
                      await downloadFilePost(post.postFile!,post.fileExtension!);
                    }
                  },
                  itemBuilder: (context) =>
                  [
                    PopupMenuItem(value: 'download file', child: Text('Download Resources',style: TextStyle(fontFamily:semibold,color: Colors.black,fontSize: shortestval*0.06),)),
                  ],
                ),
              ],
            ),
            Text("Post id = ${post.postId}", style: TextStyle(fontSize: shortestval*0.06)),
            Text('${post.dateCreated.toString().split("T").first}', style: TextStyle(color: Colors.black,fontSize: shortestval*0.05)),
            // Row 3: Description for the post
            ExpansionTile(
              title:Text("Description for need"),
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              children:
              [
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(post.description!, style: TextStyle(color: Colors.black,fontSize: shortestval*0.05))),
              ],
            ),
            SizedBox(height: 8),

            // Row 4: Image (Decode base64 and display)
            Image.memory(base64Decode(post.photo!), width: widthval, height: heightval * 0.3, fit: BoxFit.cover),
            SizedBox(height: 8),

            // Row 5: Video (Placeholder for now, video player to be added later)
            // We'll add the video player functionality later
            Container(
              color: Colors.teal,
              height: heightval*0.06,
              child: Center(
                child: ElevatedButton(
                  onPressed: ()async
                  {
                    String video_file_path=await writeBase64VideoToTempFilePost(post.video!);
                    if(video_file_path != null && video_file_path.isNotEmpty)
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return VideoPlayerControllerScreen(video_file_path:video_file_path);
                      },
                      )
                      );
                    }
                    else
                    {
                      Toastget().Toastmsg("No video data available.");
                      return;
                    }

                  },
                  child: Text("Play Video"),
                ),
              ),
            ),


            SizedBox(height: 8),

            // Row 6: QR Code and Donate buttons
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
              [

                Obx(
                      ()=>Container(
                    width: widthval*0.50,
                    child: CommonButton_loading(
                      label:"Generate QR",
                      onPressed:
                          ()
                      {
                        IsLoading_QR_Friend_Profile.change_isloadingval(true);
                        IsLoading_QR_Friend_Profile.change_isloadingval(false);
                        Navigator.push(context, MaterialPageRoute(builder: (context)
                        {
                          return QrCodeScreenPost_p(post: post,);
                        },
                        )
                        );
                      },

                      color:Colors.red,
                      textStyle: TextStyle(fontFamily: bold,color: Colors.black,),
                      padding: const EdgeInsets.all(12),
                      borderRadius:25.0,
                      width: widthval*0.30,
                      height: heightval*0.05,
                      isLoading: IsLoading_QR_Friend_Profile.isloading.value,
                    ),
                  ),
                ),

                Obx(
                      ()=>Container(
                    width: widthval*0.50,
                    child: CommonButton_loading(
                      label:"Donate",
                      onPressed: ()
                      {
                        IsLoading_Donate_Friend_Profile.change_isloadingval(true);
                        DonateOption().donate(
                            context: context,
                            donerUsername: widget.Current_User_Username,
                            postId: post.postId!.toInt(),
                            receiver_useranme: post.username.toString(),
                            jwttoken: widget.Current_User_Jwt_Token,
                            userType: widget.Current_User_Usertype
                        );
                        IsLoading_Donate_Friend_Profile.change_isloadingval(false);
                      },
                      color:Colors.red,
                      textStyle: TextStyle(fontFamily: bold,color: Colors.black),
                      padding: const EdgeInsets.all(12),
                      borderRadius:25.0,
                      width: widthval*0.30,
                      height: heightval*0.05,
                      isLoading: IsLoading_Donate_Friend_Profile.isloading.value,
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    try {
      Is_Friend_Or_Not_cont.change_Is_Friend_Or_Not(false);
      checkJWTExpiration_Outside_Widget_Build_Method();
      Check_Friend_Or_Not(
        Friend_Username: widget.FriendUsername,
        Curent_User_JwtToken: widget.Current_User_Jwt_Token,
        Current_User_Username: widget.Current_User_Username,
      );
      _eventListener = JitsiMeetEventListener(
        conferenceJoined: (url) {
          debugPrint("Conference Joined: url: $url");
        },
        conferenceTerminated: (url, error) {
          debugPrint("Conference Terminated: url: $url, error: $error");
        },
        conferenceWillJoin: (url) {
          debugPrint("Conference Will Join: url: $url");
        },
        participantJoined: (email, name, role, participantId) {
          debugPrint(
            "Participant Joined: email: $email, name: $name, role: $role, participantId: $participantId",
          );
          setState(() {
            participants.add(participantId!);
          });
        },
        participantLeft: (participantId) {
          debugPrint("Participant Left: participantId: $participantId");
          setState(() {
            participants.remove(participantId);
          });
        },
      );
    }catch(Obj)
    {
      print("Exception caught in initstae method of User friend profile screen.");
      print(Obj.toString());
    }
  }

  final _jitsiMeetPlugin = JitsiMeet();
  Set<String> participants = {};
  late JitsiMeetEventListener _eventListener;

  Future<void> joinMeeting() async {
    try{
      // Create a shared room ID using sorted usernames
      List<String> usernames = [widget.Current_User_Username, widget.FriendUsername];
      usernames.sort(); // Sort the list alphabetically

      // Join the sorted usernames with an underscore to create the room ID
      String roomId = "${usernames.join('_')}_Room";

      var options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.ffmuc.net",
      // Public server, no moderator login
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
        "welcomePageEnabled": false, // Skip welcome page
        "preJoinPageEnabled": false, // Skip pre-join page
        "unsaferoomwarning.enabled": false, // Disable unsafe room warning
      },
      userInfo: JitsiMeetUserInfo(
        displayName: widget.Current_User_Username,
        email: "${widget.Current_User_Username}@example.com",
      ),
    );
    await _jitsiMeetPlugin.join(options, _eventListener);
    debugPrint("Meeting joined successfully");
  }catch (e) {
      debugPrint("Error joining meeting: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to join meeting: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    return Scaffold
      (
      appBar: AppBar(
        title: Text("Friend Profile Screen"),
        backgroundColor: Colors.green,
        actions:
        [

          IconButton(
            onPressed: () async
            {
              await joinMeeting();
            },
            icon:

            Stack(
              children: [
                // Chat Icon (Base layer)
                Icon(
                  Icons.chat,
                  color: Colors.blue.withOpacity(0.5), // Slight opacity for layering effect
                  size: 50,
                ),
                // Video Call Icon (On top of the chat icon)
                Icon(
                  Icons.video_call,
                  color: Colors.blue,
                  size: 50,
                ),
              ],
            ),

          ),

        ],
      ),
      body:
      OrientationBuilder(builder: (context, orientation) {
        if(orientation==Orientation.portrait)
        {
          return
            Container (
              width:widthval,
              height: heightval,
              color: Colors.brown,
              child:
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Column(
                  children:
                  [

                    (shortestval*0.01).heightBox,
                    FutureBuilder(
                      future: getUserInfo(CurrentUser_JwtToken: widget.Current_User_Jwt_Token,Friend_Username: widget.FriendUsername),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // While waiting for response
                        }
                        else if (snapshot.hasError)
                        {
                          return Text('Error: ${snapshot.error}'); // If there's an error
                        }
                        else if (snapshot.connectionState == ConnectionState.done)
                        {
                          if (Friend_Profile_userinfomodel_list.isNotEmpty || Friend_Profile_userinfomodel_list.length>=1)
                          {
                            return Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Friend_Profile_userinfomodel_list[0].photo == null ||
                                    Friend_Profile_userinfomodel_list[0].photo!.isEmpty
                                    ? Image.asset('assets/default_photo.jpg') // Default image if no photo
                                    : Image.memory(
                                  base64Decode(Friend_Profile_userinfomodel_list[0].photo!),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          }
                          else
                          {
                            return Text('No image data available'); // If no user data
                          }
                        }
                        else
                        {
                          return Text('Error.Relogin.'); // Default loading state
                        }
                      },

                    ),

                    (shortestval*0.01).heightBox,

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                              ()=>
                              Commonbutton(
                                  "${Is_Friend_Or_Not_cont.Is_Friend_Or_Not.value==true?"Friend":"Add friend."}",
                                      ()async
                                  {
                                    if(widget.Current_User_Username==widget.FriendUsername)
                                      {
                                        Toastget().Toastmsg("Same user cannot be friend.");
                                        return;
                                      }
                                    if(Is_Friend_Or_Not_cont.Is_Friend_Or_Not.value==true)
                                    {
                                      Toastget().Toastmsg("You are already friend.");
                                      return;
                                    }
                                    else
                                    {
                                      int result=await Add_Friend(Friend_Username: widget.FriendUsername, Current_User_Username: widget.Current_User_Username, Curent_User_JwtToken: widget.Current_User_Jwt_Token);
                                      if(result==1)
                                      {
                                        Toastget().Toastmsg("Add friend success");
                                        return;
                                      }
                                      else
                                      {
                                        Toastget().Toastmsg("Add friend fail.Try again.");
                                        return;
                                      }
                                    }
                                  },
                                  context,
                                  Is_Friend_Or_Not_cont.Is_Friend_Or_Not.value==false?Colors.red:Colors.green
                              ),
                        ),

                        IconButton(onPressed: ()async
                        {
                          if( Is_Friend_Or_Not_cont.Is_Friend_Or_Not.value==false)
                          {
                            Toastget().Toastmsg("You are not friend please add first.");
                          }
                          else
                          {
                            int result=await Remove_Friend(Friend_Username: widget.FriendUsername, Current_User_Username: widget.Current_User_Username, Curent_User_JwtToken: widget.Current_User_Jwt_Token);
                            if(result==1)
                            {
                              Toastget().Toastmsg("Remove friend success");
                            }
                            else
                            {
                              Toastget().Toastmsg("Remove friend fail.Try again.");
                            }
                          }
                        },
                            icon: Icon(Icons.delete_outline_outlined)
                        ),

                      ],
                    ),

                    (shortestval*0.01).heightBox,

                    FutureBuilder(
                      future: getUserInfo(Friend_Username: widget.FriendUsername,CurrentUser_JwtToken: widget.Current_User_Jwt_Token),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text('UserName:');
                        }
                        else if (snapshot.hasError)
                        {
                          return Text('UserName:');
                        }
                        else if (snapshot.connectionState == ConnectionState.done)
                        {
                          if (Friend_Profile_userinfomodel_list.isNotEmpty || Friend_Profile_userinfomodel_list.length>=1)
                          {
                            return Container (
                              child: Column(
                                children: [
                                  Text("UserName:${Friend_Profile_userinfomodel_list[0].username}",style: TextStyle(
                                      fontFamily: semibold,
                                      color: Colors.white,
                                      fontSize: shortestval*0.05
                                  ),
                                  ),
                                ],
                              ),
                            );
                          }
                          else
                          {
                            return Text('UserName:');
                          }
                        }
                        else
                        {
                          return Text('UserName:');
                        }
                      },
                    ),

                    (shortestval*0.03).heightBox,


                    FutureBuilder<void>(
                      future: GetProfilePostInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();  // Make sure this is the right indicator
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Error fetching posts. Please logout and reopen again.",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          );
                        } else if (snapshot.connectionState == ConnectionState.done) {
                          return Friend_Profile_PostInfo_List.isEmpty
                              ? const Center(child: Text("No post available."))
                              : Column(
                            children: Friend_Profile_PostInfo_List.map((post)
                            {
                              return _build_Post_Card_Friend_Profile_PostInfo_(post, context);
                            }).toList(),
                          );
                        } else {
                          return Center(
                            child: Text(
                              "Please logout and relogin app.",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          );
                        }
                      },
                    ),


                  ],
                ),
              ),
            );
        }
        else if(orientation==Orientation.landscape)
        {
          return
            Container(

            );
        }
        else{
          return Center(child: Circular_pro_indicator_Yellow(context));
        }
      },
      ),
    );
  }
}
