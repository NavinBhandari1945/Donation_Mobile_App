import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hand_in_need/views/mobile/profile/change_phone_number.dart';
import 'package:hand_in_need/views/mobile/profile/update_address.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../models/mobile/PostInfoModel.dart';
import '../../../models/mobile/UserInfoModel.dart';
import '../../constant/styles.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/VideoPlayer_controller.dart';
import '../commonwidget/circularprogressind.dart';
import '../commonwidget/common_button_loading.dart';
import '../commonwidget/getx_cont_pick_single_photo.dart';
import '../commonwidget/toast.dart';
import '../home/home_p.dart';
import 'package:http/http.dart' as http;
import 'UpdateEmail_p.dart';
import 'UpdatePassword_p.dart';
import 'getx_cont_profile/getx_cont_isloading_chnage_photo.dart';
import 'getx_cont_profile/getx_cont_isloading_donate_profile.dart';
import 'getx_cont_profile/getx_cont_isloading_logout_button.dart';
import 'getx_cont_profile/getx_cont_isloading_qr_profile.dart';

class Profilescreen extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Profilescreen({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen>
{

  final change_photo_cont_getx=Get.put(pick_single_photo_getx());
  final change_photo_cont_isloading=Get.put(Isloading_change_photo_profile_screen());
  final logout_button_cont_isloading=Get.put(Isloading_logout_button_profile_screen());

  final IsLoading_QR_Profile=Get.put(Isloading_QR_Profile());
  final IsLoading_Donate_Profile=Get.put(Isloading_Donate_Profile());


  @override
  void initState(){
    super.initState();
    checkJWTExpiation();
  }

  Future<void> checkJWTExpiation()async
  {
    try {
      int result = await checkJwtToken_initistate_user(
          widget.username, widget.usertype, widget.jwttoken);
      print(widget.jwttoken);
      if (result == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) {
          return Home();
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
        return Home();
      },)
      );
      Toastget().Toastmsg("Error.Relogin please.");
    }

  }

  List<UserInfoModel> userinfomodel_list=[];

  Future<void> getUserInfo(String username, String jwttoken) async {
    try {
      // API endpoint
      // var url = "http://10.0.2.2:5074/api/Profile/getuserinfo";
      var url = "http://192.168.1.65:5074/api/Profile/getuserinfo";
      Map<String, dynamic> usernameDict =
      {
        "Username": username,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwttoken'
        },
        body: json.encode(usernameDict),
      );

      // Handling the response
      if (response.statusCode == 200)
      {
        print("profile post info");
        Map<dynamic, dynamic> responseData = await jsonDecode(response.body);
        userinfomodel_list.clear();
        userinfomodel_list.add(UserInfoModel.fromJson(responseData));
        return;
      }
      else
      {
        userinfomodel_list.clear();
        print("Data insert in userinfo table failed.");
        return;
      }
    } catch (obj) {
      userinfomodel_list.clear();
      print("Exception caught while fetching user data for profile screen");
      print(obj.toString());
      return;
    }
  }

  Future<bool> UpdatePhoto({required String username,required String jwttoken,required photo_bytes}) async {

    try
    {
      final String base64Image = base64Encode(photo_bytes as List<int>);
      // API endpoint
      // var url = "http://10.0.2.2:5074/api/Profile/updatephoto";
      var url = "http://192.168.1.65:5074/api/Profile/updatephoto";
      Map<String, dynamic> new_photo =
      {
        "Username": username,
        "Photo":base64Image,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwttoken'
        },
        body: json.encode(new_photo),
      );

      // Handling the response
      if (response.statusCode == 200) {
        print("User authenticated");
        return true;
      }
      else
      {
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
      // var url = "http://10.0.2.2:5074/api/Profile/getprofilepostinfo";
      var url = "http://192.168.1.65:5074/api/Profile/getprofilepostinfo";
      final headers =
      {
        'Authorization': 'Bearer ${widget.jwttoken}',
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> profilePostInfoBody =
      {
        "Username": "${widget.username}"
      };


      final response = await http.post(
          Uri.parse(url),
          headers: headers,
        body: json.encode(profilePostInfoBody)
      );

      if (response.statusCode == 200)
      {
        List<dynamic> responseData = await jsonDecode(response.body);
        ProfilePostInfoList.clear();
        ProfilePostInfoList.addAll
          (
          responseData.map((data) => PostInfoModel.fromJson(data)).toList(),
        );
        print("profile post list for profile count value");
        print(ProfilePostInfoList.length);
        return;
      } else
      {
        ProfilePostInfoList.clear();
        print("Data insert in profile post info for profile in list failed.");
        return;
      }
    } catch (obj) {
      ProfilePostInfoList.clear();
      print("Exception caught while fetching post data for profile screen in http method");
      print(obj.toString());
      return;
    }
  }


  @override
  Widget build(BuildContext context) {
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    var shortestval=MediaQuery.of(context).size.shortestSide;
    return Scaffold (
      appBar: AppBar(
        title: Text("profilescreen"),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body:
      Container (
        width:widthval,
        height: heightval,
        color: Colors.grey,
        child:
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            children:
            [

              (shortestval*0.01).heightBox,
              FutureBuilder(
                future: getUserInfo(widget.username, widget.jwttoken),
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
                    if (userinfomodel_list.isNotEmpty || userinfomodel_list.length>=1)
                    {
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: userinfomodel_list[0].photo == null ||
                              userinfomodel_list[0].photo!.isEmpty
                              ? Image.asset('assets/default_photo.jpg') // Default image if no photo
                              : Image.memory(
                            base64Decode(userinfomodel_list[0].photo!),
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

          Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(shortestval*0.03), // Border radius here
                      ),
                    ),
                    onPressed: ()async
                    {
                      try {
                        change_photo_cont_isloading.change_isloadingval(true);
                        bool result1 = await change_photo_cont_getx.pickImage();
                        print(result1);
                        if (result1 == true) {
                          print(change_photo_cont_getx.imagePath.toString());
                          print(change_photo_cont_getx.imageBytes.value);
                          bool result2 = await UpdatePhoto(username: widget
                              .username,
                              jwttoken: widget.jwttoken,
                              photo_bytes: change_photo_cont_getx.imageBytes
                                  .value);
                          print(result2);
                          if (result2 == true)
                          {
                            Toastget().Toastmsg("Update success");
                            change_photo_cont_getx.imageBytes.value = null;
                            change_photo_cont_getx.imagePath.value = "";
                            change_photo_cont_isloading.change_isloadingval(false);
                            setState(() {

                            });
                            return;
                          }
                          else {
                            change_photo_cont_isloading.change_isloadingval(false);
                            Toastget().Toastmsg("Update failed");
                            return;
                          }
                        }
                        else {
                          change_photo_cont_isloading.change_isloadingval(false);
                          Toastget().Toastmsg("No image select.Try again.");
                          return;
                        }
                      }catch(obj){
                        change_photo_cont_isloading.change_isloadingval(false);
                        print("Exception caught in change photo method.");
                        Toastget().Toastmsg("Change photo fail.Try again.");
                        return;
                      }


                    },
                    child: change_photo_cont_isloading.isloading.value==true?Circularproindicator(context):Text("Change photo",style:
                    TextStyle(
                        fontFamily: semibold,
                        color: Colors.black,
                        fontSize: shortestval*0.05
                    ),
                    ),
                  ),
                ),
              (shortestval*0.03).heightBox,
              FutureBuilder(
                            future: getUserInfo(widget.username, widget.jwttoken),
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
                                if (userinfomodel_list.isNotEmpty || userinfomodel_list.length>=1)
                                {
                                 return Container (
                                   child: Column(
                                     children: [
                                       Text("UserName:${userinfomodel_list[0].username}",style: TextStyle(
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

              Container (
                color: Colors.green,
                child: Column(
                  children: [

                    Container (
                        width: widthval,
                        height: heightval*0.06,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          border: Border.all(
                            color: Colors.blue,
                            width: shortestval*0.0080,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(shortestval*0.03),
                        ),
                        child:
                        Row(
                          children: [

                            Expanded(
                              child: Text("Change password",style:
                              TextStyle(
                                  fontFamily: semibold,
                                  color: Colors.black,
                                  fontSize: shortestval*0.06
                              ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(right: shortestval*0.05),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.change_circle)),
                            ),

                          ],
                        )
                    ).onTap(()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return Updatepassword(jwttoken: widget.jwttoken,username: widget.username,
                            usertype: widget.usertype);
                      },
                      )
                      );

                    }),

                    Container (
                        width: widthval,
                        height: heightval*0.06,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          border: Border.all(
                            color: Colors.blue,
                            width: shortestval*0.0080,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(shortestval*0.03),
                        ),
                        child:
                        Row(
                          children: [

                            Expanded(
                              child: Text("Change Email",style:
                              TextStyle(
                                  fontFamily: semibold,
                                  color: Colors.black,
                                  fontSize: shortestval*0.06
                              ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(right: shortestval*0.05),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.change_circle)),
                            ),

                          ],
                        )
                    ).onTap(()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return Updateemail(jwttoken: widget.jwttoken,usertype: widget.usertype,username: widget.username,);
                      },
                      )
                      );

                    }),


                    Container (
                        width: widthval,
                        height: heightval*0.06,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          border: Border.all(
                            color: Colors.blue,
                            width: shortestval*0.0080,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(shortestval*0.03),
                        ),
                        child:
                        Row(
                          children: [

                            Expanded(
                              child: Text("Change Phone Number",style:
                              TextStyle(
                                  fontFamily: semibold,
                                  color: Colors.black,
                                  fontSize: shortestval*0.06
                              ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(right: shortestval*0.05),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.change_circle)),
                            ),

                          ],
                        )
                    ).onTap(()
                    {

                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return ChangePhoneNumber(jwttoken: widget.jwttoken,usertype: widget.usertype,username: widget.username,);
                      },
                      )
                      );
                    }),

                    Container (
                        width: widthval,
                        height: heightval*0.06,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          border: Border.all(
                            color: Colors.blue,
                            width: shortestval*0.0080,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(shortestval*0.03),
                        ),
                        child:
                        Row(
                          children: [

                            Expanded(
                              child: Text("Change Address",style:
                              TextStyle(
                                  fontFamily: semibold,
                                  color: Colors.black,
                                  fontSize: shortestval*0.06
                              ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(right: shortestval*0.05),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.change_circle)),
                            ),

                          ],
                        )
                    ).onTap(()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return UpdateAddress(jwttoken: widget.jwttoken,usertype: widget.usertype,username: widget.username,);
                      },
                      )
                      );
                    }),
                  ],
                ),
              ),

              (shortestval*0.03).heightBox,

              Align(
                alignment: Alignment.center,
                child: Container(
                  child:

                  ElevatedButton (
                    onPressed:
                        () async
                    {
                      try{
                        logout_button_cont_isloading.change_isloadingval(true);
                        await clearUserData();
                        logout_button_cont_isloading.change_isloadingval(false);
                        await deleteTempDirectoryPostVideo();
                        await deleteTempDirectoryCampaignVideo();
                        print("Deleteing temporary directory success.");
                        Toastget().Toastmsg("Logout Success");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                        {
                          return Home();
                        },
                        )
                        );
                      }catch(obj)
                      {
                        logout_button_cont_isloading.change_isloadingval(false);
                        print("Logout fail.Exception occur.");
                        print("${obj.toString()}");
                        Toastget().Toastmsg("Logout fail.Try again.");
                      }
                    }
                    ,
                    child:logout_button_cont_isloading.isloading.value==true?Circularproindicator(context):Text("Log Out",style:
                    TextStyle(
                        fontFamily: semibold,
                        color: Colors.blue,
                        fontSize: shortestval*0.05
                    ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(shortestval*0.03),
                        )
                    ),
                  ),
                ),
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
                        "Error fetching posts. Please try again.",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ProfilePostInfoList.isEmpty
                        ? const Center(child: Text("No post available."))
                        : Column(
                          children: ProfilePostInfoList.map((post)
                          {
                            return _buildPostCardProfilePostInfo(post, context);
                          }).toList(),
                        );
                  } else {
                    return Center(
                      child: Text(
                        "Please reopen app.",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }
                },
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCardProfilePostInfo(PostInfoModel post, BuildContext context)
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
                    child: Text(post.description??"no", style: TextStyle(color: Colors.black,fontSize: shortestval*0.05))),
              ],
            ),
            SizedBox(height: 8),

            // Row 4: Image (Decode base64 and display)
            Image.memory(base64Decode(post.photo??"iVBORw0KGgoAAAANSUhEUgAAALcAAAETCAMAAABDSmfhAAAAA1BMVEWZ/5lPT2g3AAAASElEQVR4nO3BgQAAAADDoPlT3+AEVQEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB8A8WoAAHxScUAAAAAAElFTkSuQmCC"), width: widthval, height: heightval * 0.3, fit: BoxFit.cover),
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
              children:
              [

                Expanded(
                  child: CommonButton_loading(
                    label:"QR",
                    onPressed: (){},
                    color:Colors.red,
                    textStyle: TextStyle(fontFamily: bold,color: Colors.black,fontSize: shortestval*0.30),
                    padding: const EdgeInsets.all(12),
                    borderRadius:25.0,
                    width: widthval*0.30,
                    height: heightval*0.05,
                    isLoading: IsLoading_QR_Profile.isloading.value,

                  ),
                ),
                SizedBox(width: shortestval*0.02,),
                Expanded(
                  child: CommonButton_loading(
                    label:"Donate",
                    onPressed: (){},
                    color:Colors.red,
                    textStyle: TextStyle(fontFamily: bold,color: Colors.black,fontSize: shortestval*0.30),
                    padding: const EdgeInsets.all(12),
                    borderRadius:25.0,
                    width: widthval*0.30,
                    height: heightval*0.05,
                    isLoading: IsLoading_Donate_Profile.isloading.value,

                  ),
                ),

              ],
            ),
          ],
        ),
      );
  }




}


