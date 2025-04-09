import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/views/constant/styles.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../models/mobile/PostInfoModel.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/DonateOptionDialog.dart';
import 'Generate_QrCode_ScreenPost_p.dart';
import '../commonwidget/VideoPlayer_controller.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/toast.dart';
import '../profile/User_Friend_Profile_Screen_P.dart';
import 'getx_cont/getx_cont_isloading_donate.dart';
import 'getx_cont/getx_cont_isloading_qr.dart';
import 'authentication_home_p.dart';
import 'package:http/http.dart' as http;

class Login_HomeScreen extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Login_HomeScreen({
    super.key,
    required this.username,
    required this.usertype,
    required this.jwttoken,
  });

  @override
  State<Login_HomeScreen> createState() => _Login_HomeScreenState();
}

class _Login_HomeScreenState extends State<Login_HomeScreen> with SingleTickerProviderStateMixin {
  final IsLoading_QR = Get.put(Isloading_QR());
  final IsLoading_Donate = Get.put(Isloading_Donate());
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
    checkJWTExpiation();
    _animationController?.forward();
  }

  Future<void> checkJWTExpiation() async {
    try {
      print("check jwt called");
      int result = await checkJwtToken_initistate_user(widget.username, widget.usertype, widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        print("Deleting temporary directory success.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthenticationHome()),
        );
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    } catch (obj) {
      print("Exception caught while verifying jwt for User home screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleting temporary directory success.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthenticationHome()),
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  List<PostInfoModel> PostInfoList = [];

  Future<void> GetPostInfo() async {
    try {
      const String url = Backend_Server_Url + "api/Home/getpostinfo";
      final headers = {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        PostInfoList.clear();
        PostInfoList.addAll(
          responseData.map((data) => PostInfoModel.fromJson(data)).toList(),
        );
        print("post list count value for home screen.");
        print(PostInfoList.length);
        return;
      } else {
        PostInfoList.clear();
        print("Data insert in post info list for home screen failed in home screen.");
        return;
      }
    } catch (obj) {
      PostInfoList.clear();
      print("Exception caught while fetching post info data for home screen in http method");
      print(obj.toString());
      return;
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Home Screen",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
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
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: orientation == Orientation.portrait
                  ? _buildPortraitLayout(context, shortestval, widthval, heightval)
                  : _buildLandscapeLayout(context, shortestval, widthval, heightval),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, double shortestval, double widthval, double heightval) {
    return _fadeAnimation != null
        ? FadeTransition(
      opacity: _fadeAnimation!,
      child: FutureBuilder<void>(
        future: GetPostInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Circular_pro_indicator_Yellow(context);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error fetching posts. Please try again.",
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 16,
                  fontFamily: semibold,
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return PostInfoList.isEmpty
                ? Center(
              child: Text(
                "No posts available",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: semibold,
                  color: Colors.grey[600],
                ),
              ),
            )
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: PostInfoList.length,
              itemBuilder: (context, index) {
                return _buildPostCard_User_Home_Screen(
                  PostInfoList[index],
                  context,
                  isPortrait: true,
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "Please reopen app.",
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 16,
                  fontFamily: semibold,
                ),
              ),
            );
          }
        },
      ),
    )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildLandscapeLayout(BuildContext context, double shortestval, double widthval, double heightval) {
    return _fadeAnimation != null
        ? FadeTransition(
      opacity: _fadeAnimation!,
      child: FutureBuilder<void>(
        future: GetPostInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Circular_pro_indicator_Yellow(context);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error fetching posts. Please try again.",
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 16,
                  fontFamily: semibold,
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return PostInfoList.isEmpty
                ? Center(
              child: Text(
                "No posts available",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: semibold,
                  color: Colors.grey[600],
                ),
              ),
            )
                : GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: shortestval * 0.03,
                mainAxisSpacing: shortestval * 0.03,
                childAspectRatio: 0.75,
              ),
              itemCount: PostInfoList.length,
              itemBuilder: (context, index) {
                return _buildPostCard_User_Home_Screen(
                  PostInfoList[index],
                  context,
                  isPortrait: false,
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "Please reopen app.",
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 16,
                  fontFamily: semibold,
                ),
              ),
            );
          }
        },
      ),
    )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildPostCard_User_Home_Screen(PostInfoModel post, BuildContext context, {required bool isPortrait}) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isPortrait ? widthval : widthval * 0.45,
      height: isPortrait ? heightval * 0.65 : heightval * 0.9,
      margin: EdgeInsets.symmetric(
        horizontal: shortestval * 0.03,
        vertical: shortestval * 0.015,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isPortrait
          ? _buildPortraitPostContent(post, context, shortestval, widthval, heightval)
          : _buildLandscapePostContent(post, context, shortestval, widthval, heightval),
    );
  }

  Widget _buildPortraitPostContent(
      PostInfoModel post, BuildContext context, double shortestval, double widthval, double heightval) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(post, context, shortestval),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: shortestval * 0.03),
          child: Text(
            "Post id = ${post.postId}",
            style: TextStyle(fontSize: shortestval * 0.04, color: Colors.grey[700]),
          ),
        ),
        _buildDescription(post, shortestval),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            base64Decode(post.photo!),
            width: widthval,
            height: heightval * 0.25,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: shortestval * 0.02),
        _buildVideoButton(post, context, shortestval, widthval, heightval),
        _buildActionButtons(post, context, shortestval, widthval, heightval, isPortrait: true),
      ],
    );
  }

  Widget _buildLandscapePostContent(
      PostInfoModel post, BuildContext context, double shortestval, double widthval, double heightval) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(post, context, shortestval),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: shortestval * 0.03),
          child: Text(
            "Post id = ${post.postId}",
            style: TextStyle(fontSize: shortestval * 0.04, color: Colors.grey[700]),
          ),
        ),
        _buildDescription(post, shortestval),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            base64Decode(post.photo!),
            width: widthval * 0.45,
            height: heightval * 0.35,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: shortestval * 0.02),
        _buildVideoButton(post, context, shortestval, widthval, heightval),
        _buildActionButtons(post, context, shortestval, widthval, heightval, isPortrait: false),
      ],
    );
  }

  Widget _buildHeader(PostInfoModel post, BuildContext context, double shortestval) {
    return Padding(
      padding: EdgeInsets.all(shortestval * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => User_Friend_Profile_Screen_P(
                    Current_User_Jwt_Token: widget.jwttoken,
                    Current_User_Username: widget.username,
                    Current_User_Usertype: widget.usertype,
                    FriendUsername: post.username.toString(),
                  ),
                ),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: shortestval * 0.05,
                  backgroundColor: Colors.green[100],
                  child: Text(
                    post.username![0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: shortestval * 0.06,
                      fontFamily: bold,
                    ),
                  ),
                ),
                SizedBox(width: shortestval * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${post.username}",
                      style: TextStyle(
                        fontFamily: semibold,
                        fontSize: shortestval * 0.045,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '${post.dateCreated.toString().split("T").first}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: shortestval * 0.035,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey[600]),
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
                    fontSize: shortestval * 0.04,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(PostInfoModel post, double shortestval) {
    return ExpansionTile(
      title: Text(
        "Description",
        style: TextStyle(
          fontFamily: semibold,
          fontSize: shortestval * 0.045,
          color: Colors.grey[800],
        ),
      ),
      tilePadding: EdgeInsets.symmetric(horizontal: shortestval * 0.03),
      childrenPadding: EdgeInsets.symmetric(horizontal: shortestval * 0.03),
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(bottom: shortestval * 0.02),
          child: Text(
            post.description!,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: shortestval * 0.04,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoButton(
      PostInfoModel post, BuildContext context, double shortestval, double widthval, double heightval) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: shortestval * 0.03),
      child: Container(
        height: heightval * 0.06,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            String video_file_path = await writeBase64VideoToTempFilePost(post.video!);
            if (video_file_path.isNotEmptyAndNotNull) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerControllerScreen(video_file_path: video_file_path),
                ),
              );
            } else {
              Toastget().Toastmsg("No video data available.");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_circle_fill, size: shortestval * 0.06),
              SizedBox(width: shortestval * 0.02),
              Text(
                "Play Video",
                style: TextStyle(
                  fontFamily: semibold,
                  fontSize: shortestval * 0.04,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      PostInfoModel post, BuildContext context, double shortestval, double widthval, double heightval,
      {required bool isPortrait}) {
    return Padding(
      padding: EdgeInsets.all(shortestval * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(
                  () => Container(
                width: isPortrait ? widthval * 0.45 : widthval * 0.18, // Further reduced width for landscape
                child: CommonButton_loading(
                  label: "Generate QR",
                  onPressed: () {
                    IsLoading_QR.change_isloadingval(true);
                    IsLoading_QR.change_isloadingval(false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrCodeScreenPost_p(post: post),
                      ),
                    );
                  },
                  color: Colors.blue[600]!,
                  textStyle: TextStyle(
                    fontFamily: bold,
                    color: Colors.white,
                    fontSize: isPortrait ? shortestval * 0.04 : shortestval * 0.03, // Even smaller font in landscape
                    overflow: TextOverflow.ellipsis, // Handle text overflow
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: shortestval * 0.01, // Minimal padding in landscape
                    vertical: shortestval * 0.02,
                  ),
                  borderRadius: 12.0,
                  width: isPortrait ? widthval * 0.45 : widthval * 0.18,
                  height: heightval * 0.06,
                  isLoading: IsLoading_QR.isloading.value,
                ),
              ),
            ),
          ),
          SizedBox(width: shortestval * 0.02),
          Expanded(
            child: Obx(
                  () => Container(
                width: isPortrait ? widthval * 0.45 : widthval * 0.18, // Further reduced width for landscape
                child: CommonButton_loading(
                  label: "Donate",
                  onPressed: () {
                    IsLoading_Donate.change_isloadingval(true);
                    DonateOption().donate(
                      context: context,
                      donerUsername: widget.username,
                      postId: post.postId!.toInt(),
                      receiver_useranme: post.username.toString(),
                      jwttoken: widget.jwttoken,
                      userType: widget.usertype,
                    );
                    IsLoading_Donate.change_isloadingval(false);
                  },
                  color: Colors.green[600]!,
                  textStyle: TextStyle(
                    fontFamily: bold,
                    color: Colors.white,
                    fontSize: isPortrait ? shortestval * 0.04 : shortestval * 0.03, // Even smaller font in landscape
                    overflow: TextOverflow.ellipsis, // Handle text overflow
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: shortestval * 0.01, // Minimal padding in landscape
                    vertical: shortestval * 0.02,
                  ),
                  borderRadius: 12.0,
                  width: isPortrait ? widthval * 0.45 : widthval * 0.18,
                  height: heightval * 0.06,
                  isLoading: IsLoading_Donate.isloading.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hand_in_need/views/constant/styles.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
// import 'package:hand_in_need/views/mobile/constant/constant.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../../../models/mobile/PostInfoModel.dart';
// import '../commonwidget/CommonMethod.dart';
// import '../commonwidget/DonateOptionDialog.dart';
// import 'Generate_QrCode_ScreenPost_p.dart';
// import '../commonwidget/VideoPlayer_controller.dart';
// import '../commonwidget/circular_progress_ind_yellow.dart';
// import '../commonwidget/toast.dart';
// import '../profile/User_Friend_Profile_Screen_P.dart';
// import 'getx_cont/getx_cont_isloading_donate.dart';
// import 'getx_cont/getx_cont_isloading_qr.dart';
// import 'authentication_home_p.dart';
// import 'package:http/http.dart' as http;
//
// class Login_HomeScreen extends StatefulWidget {
//   final String username;
//   final String usertype;
//   final String jwttoken;
//   const Login_HomeScreen({super.key,required this.username,required this.usertype,
//     required this.jwttoken});
//   @override
//   State<Login_HomeScreen> createState() => _Login_HomeScreenState();
// }
//
// class _Login_HomeScreenState extends State<Login_HomeScreen>
// {
//   final IsLoading_QR=Get.put(Isloading_QR());
//   final IsLoading_Donate=Get.put(Isloading_Donate());
//
//   @override
//   void initState() {
//     super.initState();
//     checkJWTExpiation();
//   }
//
//   Future<void> checkJWTExpiation()async {
//     try {
//       print("check jwt called");
//       int result = await checkJwtToken_initistate_user(widget.username, widget.usertype, widget.jwttoken);
//       if (result == 0) {
//         await clearUserData();
//         await deleteTempDirectoryPostVideo();
//         await deleteTempDirectoryCampaignVideo();
//         print("Deleteing temporary directory success.");
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context)
//         {
//           return AuthenticationHome();
//         },)
//         );
//         Toastget().Toastmsg("Session End. Relogin please.");
//       }
//     }
//     catch(obj)
//     {
//       print("Exception caught while verifying jwt for User home screen.");
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
//       Toastget().Toastmsg("Error. Relogin please.");
//     }
//   }
//
//   List<PostInfoModel> PostInfoList = [];
//
//   Future<void> GetPostInfo() async
//   {
//     try{
//       const String url = Backend_Server_Url+"api/Home/getpostinfo";
//       final headers =
//       {
//         'Authorization': 'Bearer ${widget.jwttoken}',
//         'Content-Type': 'application/json',
//       };
//
//       final response = await http.get(Uri.parse(url), headers: headers);
//
//       if (response.statusCode == 200)
//       {
//         List<dynamic> responseData = await jsonDecode(response.body);
//         PostInfoList.clear();
//         PostInfoList.addAll
//             (
//             responseData.map((data) => PostInfoModel.fromJson(data)).toList(),
//           );
//         print("post list count value for home scareen.");
//         print(PostInfoList.length);
//         return;
//       } else
//       {
//         PostInfoList.clear();
//         print("Data insert in post info list for home screen failed  in home scareen..");
//         return;
//       }
//     } catch (obj) {
//       PostInfoList.clear();
//       print("Exception caught while fetching post info data for home screen in http method");
//       print(obj.toString());
//       return;
//     }
//   }
//
//   @override
//   void dispose()
//   {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context)
//   {
//     var shortestval = MediaQuery.of(context).size.shortestSide;
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//     return Scaffold(
//
//       appBar: AppBar(
//         title: Text("User Home Screen"),
//         backgroundColor: Colors.green,
//         automaticallyImplyLeading: false,
//       ),
//       body:
//       OrientationBuilder(
//         builder: (context, orientation) {
//           if (orientation == Orientation.portrait)
//           {
//             return
//
//               FutureBuilder<void> (
//               future: GetPostInfo(),
//               builder: (context, snapshot)
//               {
//                 if (snapshot.connectionState == ConnectionState.waiting)
//                 {
//                   return Circular_pro_indicator_Yellow(context);
//                 }
//                 else if (snapshot.hasError)
//                 {
//                   // Handle any error from the future
//                   return Center(
//                     child: Text(
//                       "Error fetching posts. Please try again.",
//                       style: TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                   );
//                 }
//                 else if (snapshot.connectionState == ConnectionState.done)
//                 {
//                     return PostInfoList.isEmpty
//                         ? const Center(child: Text("No post available."))
//                         : ListView.builder(
//                       itemCount: PostInfoList.length,
//                       itemBuilder: (context, index) {
//                         return _buildPostCard_User_Home_Screen(PostInfoList[index], context);
//                       },
//                     );
//                 }
//                 else
//                 {
//                   return
//                     Center(
//                     child: Text(
//                       "Please reopen app.",
//                       style: TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                   );
//                 }
//
//               },
//             );
//
//           }
//           else if (orientation == Orientation.landscape)
//           {
//             return Container(
//               // Add your landscape-specific layout here
//             );
//           }
//           else
//           {
//             return
//               Center(
//               child: Text(
//                 "Mobile orientation must be either protrait or landscape.",
//                 style: TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//
//   Widget _buildPostCard_User_Home_Screen(PostInfoModel post, BuildContext context)
//   {
//     var shortestval = MediaQuery.of(context).size.shortestSide;
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//     return
//       Container (
//         width: widthval,
//         height: heightval*0.65,
//         margin: EdgeInsets.only(bottom: shortestval*0.03),
//         decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.grey,
//         boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
//       ),
//       child:
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children:
//         [
//           // Row 1: Username ,date and 3-dot button for downloading resources
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children:
//             [
//               Text("${post.username} posted post.", style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.06)).onTap(()
//               {
//                 Navigator.push(context, MaterialPageRoute(builder: (context)
//                 {
//                   return User_Friend_Profile_Screen_P(Current_User_Jwt_Token: widget.jwttoken,Current_User_Username: widget.username,Current_User_Usertype: widget.usertype,FriendUsername: post.username.toString(),);
//                 },
//                 )
//                 );
//               }),
//
//               PopupMenuButton<String>
//                 (
//                 onSelected: (value) async
//                 {
//                   if (value == 'download file')
//                   {
//                     await downloadFilePost(post.postFile!,post.fileExtension!);
//                   }
//                 },
//                 itemBuilder: (context) =>
//                 [
//                   PopupMenuItem(value: 'download file', child: Text('Download Resources',style: TextStyle(fontFamily:semibold,color: Colors.black,fontSize: shortestval*0.06),)),
//                 ],
//               ),
//             ],
//           ),
//               Text("Post id = ${post.postId}", style: TextStyle(fontSize: shortestval*0.06)),
//               Text('${post.dateCreated.toString().split("T").first}', style: TextStyle(color: Colors.black,fontSize: shortestval*0.05)),
//           // Row 3: Description for the post
//           ExpansionTile(
//             title:Text("Description for need"),
//               tilePadding: EdgeInsets.zero,
//               childrenPadding: EdgeInsets.zero,
//           children:
//           [
//             Container(
//                 alignment: Alignment.centerLeft,
//                 child: Text(post.description!, style: TextStyle(color: Colors.black,fontSize: shortestval*0.05))),
//           ],
//           ),
//           SizedBox(height: 8),
//
//           // Row 4: Image (Decode base64 and display)
//           Image.memory(base64Decode(post.photo!), width: widthval, height: heightval * 0.3, fit: BoxFit.cover),
//           SizedBox(height: 8),
//
//           // Row 5: Video (Placeholder for now, video player to be added later)
//           // We'll add the video player functionality later
//           Container(
//             color: Colors.teal,
//             height: heightval*0.06,
//             child: Center(
//               child: ElevatedButton(
//                 onPressed: ()async
//                 {
//                   String video_file_path=await writeBase64VideoToTempFilePost(post.video!);
//                   if(video_file_path != null && video_file_path.isNotEmpty)
//                     {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) {
//                         return VideoPlayerControllerScreen(video_file_path:video_file_path);
//                       },
//                       )
//                       );
//                     }
//                   else
//                     {
//                       Toastget().Toastmsg("No video data available.");
//                       return;
//                     }
//
//                 },
//                 child: Text("Play Video"),
//               ),
//             ),
//           ),
//
//
//           SizedBox(height: 8),
//
//           // Row 6: QR Code and Donate buttons
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children:
//             [
//
//              Obx(
//               ()=>Container(
//                  width: widthval*0.50,
//                  child: CommonButton_loading(
//                    label:"Generate QR",
//                    onPressed:
//                        ()
//                    {
//                      IsLoading_QR.change_isloadingval(true);
//                      IsLoading_QR.change_isloadingval(false);
//                      Navigator.push(context, MaterialPageRoute(builder: (context)
//                       {
//                         return QrCodeScreenPost_p(post: post,);
//                       },
//                       )
//                       );
//                    },
//
//                    color:Colors.red,
//                    textStyle: TextStyle(fontFamily: bold,color: Colors.black,),
//                    padding: const EdgeInsets.all(12),
//                    borderRadius:25.0,
//                    width: widthval*0.30,
//                    height: heightval*0.05,
//                    isLoading: IsLoading_QR.isloading.value,
//                  ),
//                ),
//              ),
//
//               Obx(
//                     ()=>Container(
//                   width: widthval*0.50,
//                   child: CommonButton_loading(
//                     label:"Donate",
//                     onPressed: ()
//                     {
//                       IsLoading_Donate.change_isloadingval(true);
//                       DonateOption().donate(
//                           context: context,
//                           donerUsername: widget.username,
//                           postId: post.postId!.toInt(),
//                           receiver_useranme: post.username.toString(),
//                         jwttoken: widget.jwttoken,
//                         userType: widget.usertype
//                       );
//                       IsLoading_Donate.change_isloadingval(false);
//                     },
//                     color:Colors.red,
//                     textStyle: TextStyle(fontFamily: bold,color: Colors.black),
//                     padding: const EdgeInsets.all(12),
//                     borderRadius:25.0,
//                     width: widthval*0.30,
//                     height: heightval*0.05,
//                     isLoading: IsLoading_Donate.isloading.value,
//                   ),
//                 ),
//               ),
//
//             ],
//           ),
//         ],
//       ),
//     );
//
//
//   }
//
// }
//
//
//
//
//
