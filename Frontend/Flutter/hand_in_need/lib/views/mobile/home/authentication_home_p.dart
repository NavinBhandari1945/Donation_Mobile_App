import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hand_in_need/views/mobile/authentication/Login_Screen_p.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import '../../../models/mobile/PostInfoModel.dart';
import '../../constant/styles.dart';
import '../authentication/sign_up_user_p.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/VideoPlayer_controller.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import 'package:http/http.dart' as http;
import '../commonwidget/toast.dart';

class AuthenticationHome extends StatefulWidget {
  const AuthenticationHome({super.key});

  @override
  State<AuthenticationHome> createState() => _AuthenticationHomeState();
}

class _AuthenticationHomeState extends State<AuthenticationHome> with SingleTickerProviderStateMixin {
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
    try {
      Check_Jwt_Token_Landing_Screen(context: context);
    } catch (obj) {
      print("Exception caught while checking for landing screen");
      print(obj.toString());
      clearUserData();
      deleteTempDirectoryPostVideo();
      deleteTempDirectoryCampaignVideo();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
    }
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<PostInfoModel> PostInfoListAuthentication = [];

  Future<void> GetPostInfoAuthentication() async {
    try {
      print("Post info at user authentication screen method called");
      const String url = Backend_Server_Url + "api/Authentication/authenticationpostinfo";
      final headers = {'Content-Type': 'application/json'};
      final response = await http.get(Uri.parse(url), headers: headers);
      print(response);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        PostInfoListAuthentication.clear();
        PostInfoListAuthentication.addAll(
          responseData.map((data) => PostInfoModel.fromJson(data)).toList(),
        );
        print("post authentication list count value for login home screen.");
        print(PostInfoListAuthentication.length);
        return;
      } else {
        PostInfoListAuthentication.clear();
        print("Data insert in post authentication info list failed for login home screen.");
        return;
      }
    } catch (obj) {
      PostInfoListAuthentication.clear();
      print("Exception caught while fetching post data for user authentication screen in login home screen in http method");
      print(obj.toString());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome",
          style: TextStyle(fontFamily: bold, fontSize: 24, color: Colors.white, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: shortestval * 0.02),
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(horizontal: shortestval * 0.04, vertical: shortestval * 0.02),
              ),
              child: Text(
                "Login",
                style: TextStyle(fontFamily: semibold, color: Colors.white, fontSize: shortestval * 0.04),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: shortestval * 0.04),
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(horizontal: shortestval * 0.04, vertical: shortestval * 0.02),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(fontFamily: semibold, color: Colors.white, fontSize: shortestval * 0.04),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: heightval,
        width: widthval,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: FutureBuilder<void>(
                  future: GetPostInfoAuthentication(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Circular_pro_indicator_Yellow(context));
                    } else if (snapshot.hasError) {
                      return _buildErrorText("Error fetching posts. Please reopen app.");
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return PostInfoListAuthentication.isEmpty
                          ? _buildEmptyText("No post data available.")
                          : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: PostInfoListAuthentication.length,
                        itemBuilder: (context, index) => _buildPostCardUserAuthentication(PostInfoListAuthentication[index], context),
                      );
                    }
                    return _buildErrorText("Please reopen app.");
                  },
                ),
              );
            } else if (orientation == Orientation.landscape) {
              return Container();
            }
            return _buildErrorText("Mobile orientation must be either portrait or landscape.");
          },
        ),
      ),
    );
  }

  Widget _buildPostCardUserAuthentication(PostInfoModel post, BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widthval,
      margin: EdgeInsets.symmetric(vertical: shortestval * 0.02, horizontal: shortestval * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 2, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(shortestval * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${post.username} posted",
                  style: TextStyle(fontFamily: semibold, fontSize: shortestval * 0.045, color: Colors.grey[800]),
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
                        style: TextStyle(fontFamily: semibold, fontSize: shortestval * 0.04, color: Colors.grey[800]),
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
                Text("Post ID: ${post.postId}", style: TextStyle(fontSize: shortestval * 0.04, color: Colors.grey[700])),
                Text(
                  post.dateCreated.toString().split("T").first,
                  style: TextStyle(color: Colors.grey[600], fontSize: shortestval * 0.035),
                ),
              ],
            ),
          ),
          ExpansionTile(
            title: Text(
              "Description",
              style: TextStyle(fontFamily: semibold, fontSize: shortestval * 0.045, color: Colors.grey[800]),
            ),
            tilePadding: EdgeInsets.symmetric(horizontal: shortestval * 0.03),
            childrenPadding: EdgeInsets.only(bottom: shortestval * 0.03),
            children: [
              Text(
                post.description!,
                style: TextStyle(color: Colors.grey[700], fontSize: shortestval * 0.04),
              ),
            ],
          ),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: shortestval * 0.03, vertical: shortestval * 0.01),
            child: ElevatedButton(
              onPressed: () async {
                String video_file_path = await writeBase64VideoToTempFilePost(post.video!);
                if (video_file_path.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VideoPlayerControllerScreen(video_file_path: video_file_path)),
                  );
                } else {
                  Toastget().Toastmsg("No video data available.");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: shortestval * 0.02),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_fill, size: shortestval * 0.06, color: Colors.white),
                  SizedBox(width: shortestval * 0.02),
                  Text(
                    "Play Video",
                    style: TextStyle(fontFamily: semibold, fontSize: shortestval * 0.04, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: shortestval * 0.02),
        ],
      ),
    );
  }

  Widget _buildErrorText(String message) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.red[700], fontSize: shortestval * 0.045, fontFamily: semibold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyText(String message) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    return Center(
      child: Text(
        message,
        style: TextStyle(fontSize: shortestval * 0.045, fontFamily: semibold, color: Colors.grey[600]),
      ),
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:hand_in_need/views/mobile/authentication/Login_Screen_p.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
// import 'package:hand_in_need/views/mobile/constant/constant.dart';
// import '../../../models/mobile/PostInfoModel.dart';
// import '../../constant/styles.dart';
// import '../authentication/sign_up_user_p.dart';
// import '../commonwidget/CommonMethod.dart';
// import '../commonwidget/VideoPlayer_controller.dart';
// import '../commonwidget/circular_progress_ind_yellow.dart';
// import 'package:http/http.dart' as http;
// import '../commonwidget/toast.dart';
//
// class AuthenticationHome extends StatefulWidget {
//   const AuthenticationHome({super.key});
//
//   @override
//   State<AuthenticationHome> createState() => _AuthenticationHomeState();
// }
//
// class _AuthenticationHomeState extends State<AuthenticationHome> {
//   @override
//   void initState()
//   {
//     super.initState();
//     try {
//       Check_Jwt_Token_Landing_Screen(context: context);
//     }catch(obj){
//       print("Exception caught while checking for landing screen");
//       print(obj.toString());
//       clearUserData();
//       deleteTempDirectoryPostVideo();
//       deleteTempDirectoryCampaignVideo();
//       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
//         return AuthenticationHome();
//       },
//       )
//       );
//     }
//   }
//
//   List<PostInfoModel> PostInfoListAuthentication = [];
//
//   Future<void> GetPostInfoAuthentication() async
//   {
//     try {
//       print("Post info at user authentication screen method called");
//       const String url = Backend_Server_Url+"api/Authentication/authenticationpostinfo";
//       final headers =
//       {
//         'Content-Type': 'application/json',
//       };
//       final response = await http.get(Uri.parse(url), headers: headers);
//       print(response);
//       if (response.statusCode == 200) {
//         List<dynamic> responseData = await jsonDecode(response.body);
//         PostInfoListAuthentication.clear();
//         PostInfoListAuthentication.addAll
//           (
//           responseData.map((data) => PostInfoModel.fromJson(data)).toList(),
//         );
//         print("post authentication list count value  for login home sacreen.");
//         print(PostInfoListAuthentication.length);
//         return;
//       } else
//       {
//         PostInfoListAuthentication.clear();
//         print("Data insert in post authentication info list failed  for login home saceen..");
//         return;
//       }
//     } catch (obj)
//     {
//       PostInfoListAuthentication.clear();
//       print("Exception caught while fetching post data for user authentication screen in login home saceen in http method");
//       print(obj.toString());
//       return;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     var shortestval=MediaQuery.of(context).size.shortestSide;
//     var widthval=MediaQuery.of(context).size.width;
//     var heightval=MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("User authentication Screen"),
//         backgroundColor: Colors.green,
//         automaticallyImplyLeading: false,
//         actions:
//         [
//
//           Commonbutton("Login",(){
//             Navigator.push(context,MaterialPageRoute(builder: (context) {
//               return LoginScreen();
//             },
//             )
//             );
//
//
//           }, context,Colors.red),
//
//           SizedBox(width: shortestval*0.01,),
//
//           Commonbutton("SignUp",(){
//             Navigator.push(context,MaterialPageRoute(builder: (context) {
//               return SignUpScreen();
//             },
//             )
//             );
//
//           }, context,Colors.red)
//         ],
//       ),
//     body:
//     Container(
//       height: heightval,
//       width: widthval,
//       color: Colors.brown,
//       child: OrientationBuilder(
//       builder: (context, orientation) {
//       if (orientation == Orientation.portrait) {
//       return
//
//       FutureBuilder<void>(
//       future:GetPostInfoAuthentication(),
//       builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting)
//       {
//       // Show a loading indicator while the future is executing
//       return Circular_pro_indicator_Yellow(context);
//       }
//       else if (snapshot.hasError)
//       {
//       // Handle any error from the future
//       return Center(
//       child: Text(
//       "Error fetching posts. Please reopen app.",
//       style: TextStyle(color: Colors.red, fontSize: 16),
//       ),
//       );
//       }
//       else if (snapshot.connectionState == ConnectionState.done)
//       {
//       return
//         PostInfoListAuthentication.isEmpty
//       ? const Center(child: Text("No post data available."))
//           : ListView.builder(
//       itemCount: PostInfoListAuthentication.length,
//       itemBuilder: (context, index)
//       {
//       return _buildPostCardUserAuthentication(PostInfoListAuthentication[index], context);
//       },
//       );
//       }
//       else
//       {
//       return
//         Center(
//         child: Text(
//           "Please reopen app.",
//           style: TextStyle(color: Colors.red, fontSize: 16),
//         ),
//       );
//       }
//       },
//       );
//       } else if (orientation == Orientation.landscape)
//       {
//       return Container(
//       // Add your landscape-specific layout here
//       );
//       }
//       else
//       {
//       return Center(
//         child: Text(
//           "Mobile orientation must be either protrait or landscape.",
//           style: TextStyle(color: Colors.red, fontSize: 16),
//         ),
//       );
//       }
//       },
//       ),
//     ),
//     );
//   }
// }
// Widget _buildPostCardUserAuthentication(PostInfoModel post, BuildContext context)
// {
//   var shortestval = MediaQuery.of(context).size.shortestSide;
//   var widthval = MediaQuery.of(context).size.width;
//   var heightval = MediaQuery.of(context).size.height;
//   return
//     Container(
//       width: widthval,
//       margin: EdgeInsets.only(bottom: shortestval*0.03),
//       decoration: BoxDecoration(
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
//               Text("${post.username} posted post.", style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.06)),
//
//               PopupMenuButton<String>(
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
//           Text("Post id = ${post.postId}", style: TextStyle(fontSize: shortestval*0.06)),
//           Text('${post.dateCreated.toString().split("T").first}', style: TextStyle(color: Colors.black,fontSize: shortestval*0.05)),
//           // Row 3: Description for the post
//           ExpansionTile(
//             title:Text("Description for need"),
//             tilePadding: EdgeInsets.zero,
//             childrenPadding: EdgeInsets.zero,
//             children:
//             [
//               Container(
//                   alignment: Alignment.centerLeft,
//                   child: Text(post.description!, style: TextStyle(color: Colors.black,fontSize: shortestval*0.05))),
//             ],
//           ),
//           SizedBox(height: 8),
//           Image.memory(base64Decode(post.photo!), width: widthval, height: heightval * 0.3, fit: BoxFit.cover),
//           SizedBox(height: 8),
//           Container(
//             color: Colors.teal,
//             height: heightval*0.06,
//             child: Center(
//               child: ElevatedButton(
//                 onPressed: ()async
//                 {
//                   String video_file_path=await writeBase64VideoToTempFilePost(post.video!);
//                   if(video_file_path != null && video_file_path.isNotEmpty)
//                   {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) {
//                       return VideoPlayerControllerScreen(video_file_path:video_file_path);
//                     },
//                     )
//                     );
//                   }
//                   else
//                   {
//                     Toastget().Toastmsg("No video data available.");
//                     return;
//                   }
//                 },
//                 child: Text("Play Video"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
// }
//
//
