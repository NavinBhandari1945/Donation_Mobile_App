import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hand_in_need/views/mobile/authentication/Login_Screen_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commonbutton.dart';
import '../../../models/mobile/PostInfoModel.dart';
import '../../constant/styles.dart';
import '../authentication/sign_up_user_p.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/VideoPlayer_controller.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import 'package:http/http.dart' as http;
import '../commonwidget/download_post_file.dart';
import '../commonwidget/toast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  List<PostInfoModel> PostInfoListAuthentication = [];

  Future<void> GetPostInfoAuthentication() async
  {
    try {
      print("Post info at user authentication screen method called");
      const String url = "http://192.168.1.65:5074/api/Authentication/authenticationpostinfo";
      // const String url = "http://10.0.2.2:5074/api/Authentication/authenticationpostinfo";
      final headers =
      {
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      print(response);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        PostInfoListAuthentication.clear();
        PostInfoListAuthentication.addAll
          (
          responseData.map((data) => PostInfoModel.fromJson(data)).toList(),
        );
        print("post authentication list count value  for login home sacreen.");
        print(PostInfoListAuthentication.length);
        return;
      } else
      {
        PostInfoListAuthentication.clear();
        print("Data insert in post authentication info list failed  for login home saceen..");
        return;
      }
    } catch (obj)
    {
      PostInfoListAuthentication.clear();
      print("Exception caught while fetching post data for user authentication screen in login home saceen in http method");
      print(obj.toString());
      return;
    }
  }
  @override
  Widget build(BuildContext context) {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("User authentication Screen"),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        actions:
        [

          Commonbutton("Login",(){
            Navigator.push(context,MaterialPageRoute(builder: (context) {
              return LoginScreen();
            },
            )
            );


          }, context,Colors.red),

          SizedBox(width: shortestval*0.01,),

          Commonbutton("SignUp",(){
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
              return SignUpScreen();
            },
            )
            );

          }, context,Colors.red)
        ],
      ),
    body:
    Container(
      height: heightval,
      width: widthval,
      color: Colors.brown,
      child: OrientationBuilder(
      builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
      return

      FutureBuilder<void>(
      future:GetPostInfoAuthentication(),
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
      {
      // Show a loading indicator while the future is executing
      return Circular_pro_indicator_Yellow(context);
      }
      else if (snapshot.hasError)
      {
      // Handle any error from the future
      return Center(
      child: Text(
      "Error fetching posts. Please reopen app.",
      style: TextStyle(color: Colors.red, fontSize: 16),
      ),
      );
      }
      else if (snapshot.connectionState == ConnectionState.done)
      {
      return
        PostInfoListAuthentication.isEmpty
      ? const Center(child: Text("No post data available."))
          : ListView.builder(
      itemCount: PostInfoListAuthentication.length,
      itemBuilder: (context, index)
      {
      return _buildPostCardUserAuthentication(PostInfoListAuthentication[index], context);
      },
      );
      }
      else
      {
      return
        Center(
        child: Text(
          "Please reopen app.",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
      }
      },
      );
      } else if (orientation == Orientation.landscape)
      {
      return Container(
      // Add your landscape-specific layout here
      );
      }
      else
      {
      return Center(
        child: Text(
          "Mobile orientation must be either protrait or landscape.",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
      }
      },
      ),
    ),
    );
  }
}
Widget _buildPostCardUserAuthentication(PostInfoModel post, BuildContext context)
{
  var shortestval = MediaQuery.of(context).size.shortestSide;
  var widthval = MediaQuery.of(context).size.width;
  var heightval = MediaQuery.of(context).size.height;
  return
    Container(
      width: widthval,
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
          Image.memory(base64Decode(post.photo!), width: widthval, height: heightval * 0.3, fit: BoxFit.cover),
          SizedBox(height: 8),
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
        ],
      ),
    );
}


