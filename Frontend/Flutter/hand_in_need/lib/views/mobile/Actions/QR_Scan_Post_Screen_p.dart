import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hand_in_need/models/mobile/PostInfoModel.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/DonateOptionDialog.dart';
import '../home/Generate_QrCode_ScreenPost_p.dart';
import '../commonwidget/VideoPlayer_controller.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/common_button_loading.dart';
import '../commonwidget/toast.dart';
import '../constant/constant.dart';
import 'package:http/http.dart' as http;
import '../profile/User_Friend_Profile_Screen_P.dart';
import 'getx_cont_actions/getx_cont_isloading_donate_qr_screen.dart';
import 'getx_cont_actions/getx_cont_isloading_qr_generate_post_qr_screen.dart';

class QrScanPostScreen extends StatefulWidget {
  final int postId;
  final String JWT_Token;
  final String username;
  final String usertype;
  const QrScanPostScreen({super.key,required this.postId,required this.JWT_Token,required this.username,required this.usertype});
  @override
  State<QrScanPostScreen> createState() => _QrScanPostScreenState();
}

class _QrScanPostScreenState extends State<QrScanPostScreen> {

  final IsLoading_QR=Get.put(Isloading_QR_Post_Screen());
  final IsLoading_Donate=Get.put(Isloading_Donate_QR_Screen());

  List<PostInfoModel> PostInfoList_QR_Screen_List = [];

  Future<void> GetPostInfoQrScreen() async {
    try {
      print("Qr screen for post info method called");
      const String url = Backend_Server_Url+"api/Actions/get_post_info_qr";
      final headers =
      {
        'Authorization': 'Bearer ${widget.JWT_Token}',
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> PostInfoBody =
      {
        "PostId": "${widget.postId}"
      };

      final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(PostInfoBody)
      );

      if (response.statusCode == 200)
      {
        final responseData = await jsonDecode(response.body);
        PostInfoList_QR_Screen_List.clear();
        PostInfoList_QR_Screen_List.add
          (
           PostInfoModel.fromJson(responseData)
        );
        print("QR scan post list count value");
        print(PostInfoList_QR_Screen_List.length);
        return;
      } else
      {
        PostInfoList_QR_Screen_List.clear();
        print("Data insert in QR scan post info  in list failed.");
        return;
      }
    } catch (obj) {
      PostInfoList_QR_Screen_List.clear();
      print("Exception caught while fetching post data for QR scan screen in http method");
      print(obj.toString());
      return;
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
        title: Text("QR scan post screen."),
        backgroundColor: Colors.green,
      ),
      body:
      OrientationBuilder(builder: (context, orientation) {
        if(orientation==Orientation.portrait)
        {
          return
            FutureBuilder<void> (
            future: GetPostInfoQrScreen(),
            builder: (context, snapshot)
            {
              if (snapshot.connectionState == ConnectionState.waiting)
              {
                return Circular_pro_indicator_Yellow(context);
              }
              else if (snapshot.hasError)
              {
                // Handle any error from the future
                return Center(
                  child: Text(
                    "Error fetching posts. Please try again.",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              }
              else if (snapshot.connectionState == ConnectionState.done)
              {
                return PostInfoList_QR_Screen_List.isEmpty
                    ? const Center(child: Text("No post available."))
                    :
                _buildPostCard_User_Action_Screen(PostInfoList_QR_Screen_List[0], context);
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

        }
        else if(orientation==Orientation.landscape)
        {
          return
            Container(

            );

        }
        else{
          return Circular_pro_indicator_Yellow(context);
        }
      },
      ),
    );
  }


  Widget _buildPostCard_User_Action_Screen(PostInfoModel post, BuildContext context)
  {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return

      Container(
        width: widthval,
        height: heightval,
        color: Colors.grey,
        child: Center(
          child: Container (
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
                    Text("${post.username} posted post.", style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.06)).onTap(()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return User_Friend_Profile_Screen_P(Current_User_Jwt_Token: widget.JWT_Token,Current_User_Username: widget.username,Current_User_Usertype: widget.usertype,FriendUsername: post.username.toString(),);
                      },
                      )
                      );
                    }),

                    PopupMenuButton<String>
                      (
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
                            IsLoading_QR.change_isloadingval(true);
                            IsLoading_QR.change_isloadingval(false);
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
                          isLoading: IsLoading_QR.isloading.value,
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
                            IsLoading_Donate.change_isloadingval(true);
                            DonateOption().donate(
                                context: context,
                                donerUsername: widget.username,
                                postId: post.postId!.toInt(),
                                receiver_useranme: post.username.toString(),
                                jwttoken: widget.JWT_Token,
                                userType: widget.usertype
                            );
                            IsLoading_Donate.change_isloadingval(false);
                          },
                          color:Colors.red,
                          textStyle: TextStyle(fontFamily: bold,color: Colors.black),
                          padding: const EdgeInsets.all(12),
                          borderRadius:25.0,
                          width: widthval*0.30,
                          height: heightval*0.05,
                          isLoading: IsLoading_Donate.isloading.value,
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      );


  }

}
