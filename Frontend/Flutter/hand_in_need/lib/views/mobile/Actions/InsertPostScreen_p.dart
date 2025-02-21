import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hand_in_need/views/mobile/commonwidget/common_button_loading.dart';
import 'package:hand_in_need/views/mobile/commonwidget/commontextfield_obs_false_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/getx_cont_pick_single_photo_int.dart';
import '../commonwidget/single_file_pick_getx_cont.dart';
import '../commonwidget/single_video_pick_getx.dart';
import 'package:http/http.dart' as http;
import '../home/home_p.dart';
import 'getx_cont_actions/getx_cont_isloading_add_post.dart';
import 'getx_cont_actions/getx_cont_isloading_select_file.dart';
import 'getx_cont_actions/getx_cont_isloading_select_image.dart';
import 'getx_cont_actions/getx_cont_isloading_select_video.dart';


class Insertpostscreen extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Insertpostscreen({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<Insertpostscreen> createState() => _InsertpostscreenState();
}

class _InsertpostscreenState extends State<Insertpostscreen> {
  final post_descriptiion_cont=TextEditingController();
  final isLoadingCont_image=Get.put(Isloading_selwct_image_actions_screen());
  final isLoadingCont_video=Get.put(Isloading_select_video_actions_screen());
  final isLoadingCont_add_post=Get.put(Isloading_add_post_actions_screen());
  final isLoadingCont_select_file=Get.put(Isloading_select_file_actions_screen());
  final select_post_photo_cont=Get.put(pick_single_photo_getx_int());
  final select_post_video_cont=Get.put(PickSingleVideoController());
  final select_post_file_cont=Get.put(FilePickerController());


  @override
  void initState(){
    super.initState();
    select_post_photo_cont.imageBytes.value=null;
    select_post_photo_cont.imagePath.value="";
    select_post_video_cont.videoBytes.value=null;
    select_post_video_cont.videoPath.value="";
    select_post_file_cont.filePath.value="";
    select_post_file_cont.fileBytes.value=null;
    select_post_file_cont.fileExtension.value="";
  }

  Future<int> AddPost({required String file_extension,required String username,required String jwttoken,required filebytes,required String description,required imagebytes,required videobytes}) async
  {
    try
    {
      final String base64Image =base64Encode(imagebytes as List<int>);
      final String base64Video =base64Encode(videobytes as List<int>);
      final String base64File =base64Encode(filebytes as List<int>);

      // API endpoint
      var url = "http://10.0.2.2:5074/api/Actions/insertpost";
      Map<String, dynamic> post_data =
      {
        "Username": username,
        "DateCreated":DateTime.now().toUtc().toString(),
        "Description":description,
        "Video":base64Video,
        "Photo":base64Image,
        "PostFile":base64File,
        "FileExtension":file_extension,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwttoken'
        },
        body: json.encode(post_data),
      );

      // Handling the response
      if (response.statusCode == 200) {
        print("User authenticated");
        //success
        return 0;
      }
      else if(response.statusCode==701)
      {
        return 5;  //user doesn't exist.
      }
      else if(response.statusCode==702)
      {
        return 3;  //exception caught in backend
      }
      else if(response.statusCode==700)
      {
        return 6;  // validation error in backend
      }
      else if(response.statusCode==400)
      {
        return 9;  //details validation error
      }
      else if(response.statusCode==401)
      {
        return 10;  // jwt error
      }
      else if(response.statusCode==403)
      {
        return 11;  // jwt error
      }
      else
      {
        print(response.body);
        print("Error.other status code.");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while inserting post in http method.");
      print(obj.toString());
      return 2;
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
          title: Text("Login Screen"),
          backgroundColor: Colors.green,
        ),
        body:
      OrientationBuilder(builder: (context, orientation) {
        if(orientation==Orientation.portrait)
        {
          return
            Container (
                width:widthval,
                height: heightval,
                color: Colors.white10,
                child:
                Center(
                  child: Container(
                    width: widthval,
                    height: heightval*0.35,
                    color: Colors.grey,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children:
                        [

                          CommonTextField_obs_false_p("Enter description of post.", "", false, post_descriptiion_cont, context),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            child: Row(
                              children: [

                                Obx(
                                ()=>CommonButton_loading(label: "Select image",
                                      onPressed: ()async
                                      {
                                        try{
                                                isLoadingCont_image.change_isloadingval(true);
                                                int result_select_image_post=await select_post_photo_cont.pickImage();
                                                if(result_select_image_post==1)
                                                  {
                                                    isLoadingCont_image.change_isloadingval(false);
                                                    Toastget().Toastmsg("Image select success.");
                                                    return;
                                                  }
                                                if(result_select_image_post==2)
                                                {
                                                  isLoadingCont_image.change_isloadingval(false);
                                                  Toastget().Toastmsg("Invalid image extension.JPG,JPEG,PNG only valid.Fail");
                                                  return;
                                                }
                                                if(result_select_image_post==3)
                                                {
                                                  isLoadingCont_image.change_isloadingval(false);
                                                  Toastget().Toastmsg("No Image select.Fail.");
                                                  return;
                                                }
                                                if(result_select_image_post==4)
                                                {
                                                  isLoadingCont_image.change_isloadingval(false);
                                                  Toastget().Toastmsg("Try again.Fail.");
                                                  return;
                                                }
                                      }catch(obj) {
                                          print("Exception caught while selecting image for post.");
                                          print(obj.toString());
                                          isLoadingCont_image.change_isloadingval(false);
                                          Toastget().Toastmsg("Select image fail.Try again.");
                                          return;
                                        }
                                      },
                                    color:select_post_photo_cont.imageBytes.value == null?Colors.red:Colors.green,
                                    textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
                                    padding: const EdgeInsets.all(12),
                                    borderRadius:25.0,
                                    width: shortestval*0.30,
                                    height: shortestval*0.15,
                                    isLoading: isLoadingCont_image.isloading.value,
                                  ),
                                ),

                                Obx(
                                  ()=>
                                      CommonButton_loading(label: "Select video",
                                    onPressed: ()async
                                    {
                                      try {
                                        isLoadingCont_video.change_isloadingval(true);
                                        int result_select_video_post = await select_post_video_cont
                                            .pickVideo();
                                        if (result_select_video_post == 1) {
                                          isLoadingCont_video.change_isloadingval(false);
                                          Toastget().Toastmsg(
                                              "Video select success.");
                                          return;
                                        }
                                        if (result_select_video_post == 2) {
                                          isLoadingCont_video.change_isloadingval(false);
                                          Toastget().Toastmsg(
                                              "Video size exceeds more tahn 2 GB.Fail.");
                                          return;
                                        }
                                        if (result_select_video_post == 3) {
                                          isLoadingCont_video.change_isloadingval(false);
                                          Toastget().Toastmsg(
                                              "Invalid video format.Only support .mp4, .mkv, .webm, .3gp, .avi, .mov, .wmv, .ogg");
                                          return;
                                        }
                                        if (result_select_video_post == 4) {
                                          isLoadingCont_video.change_isloadingval(false);
                                          Toastget().Toastmsg(
                                              "No video select.Fail.");
                                          return;
                                        }
                                        if (result_select_video_post == 5) {
                                          isLoadingCont_video.change_isloadingval(false);
                                          Toastget().Toastmsg("Try again.");
                                          return;
                                        }
                                      }catch(obj)
                                      {
                                        print("Exception caught while selecting video for post.");
                                        print(obj.toString());
                                        isLoadingCont_video.change_isloadingval(false);
                                        Toastget().Toastmsg("Select video fail.Try again.");
                                      }
                                    },
                                    color:select_post_video_cont.videoBytes.value == null?Colors.red:Colors.green,
                                    textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
                                    padding: const EdgeInsets.all(12),
                                    borderRadius:25.0,
                                    width: shortestval*0.30,
                                    height: shortestval*0.15,
                                    isLoading: isLoadingCont_video.isloading.value,
                                  ),
                                ),

                                Obx(
                                      ()=> CommonButton_loading(label: "Select file",
                                    onPressed: ()async
                                    {
                                      try {
                                        isLoadingCont_select_file.change_isloadingval(true);
                                        int result_select_file_post = await select_post_file_cont
                                            .pickFile();
                                        if (result_select_file_post == 1) {
                                          isLoadingCont_select_file.change_isloadingval(false);
                                          Toastget().Toastmsg(
                                              "File select success.");
                                          return;
                                        }
                                        if (result_select_file_post == 2) {
                                          isLoadingCont_select_file.change_isloadingval(false);
                                          Toastget().Toastmsg(
                                              "File size exceeds more tahn 2 GB.Fail.");
                                          return;
                                        }
                                        if (result_select_file_post == 3) {
                                          isLoadingCont_select_file.change_isloadingval(false);
                                          Toastget().Toastmsg(
                                              "No file selected.Only support .pdf,.docx,.txt");
                                          return;
                                        }
                                        if (result_select_file_post == 4)
                                        {
                                          isLoadingCont_select_file.change_isloadingval(false);
                                          Toastget().Toastmsg(
                                              "No file select.Fail.Try again.");
                                          return;
                                        }

                                      }catch(obj)
                                      {
                                        print("Exception caught while selecting file for post.");
                                        print(obj.toString());
                                        isLoadingCont_select_file.change_isloadingval(false);
                                        Toastget().Toastmsg("Select file fail.Try again.");
                                      }
                                    },
                                    color:select_post_file_cont.fileBytes.value == null?Colors.red:Colors.green,
                                    textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
                                    padding: const EdgeInsets.all(12),
                                    borderRadius:25.0,
                                    width: shortestval*0.30,
                                    height: shortestval*0.15,
                                    isLoading: isLoadingCont_select_file.isloading.value,
                                  ),
                                ),

                              ],
                            ),
                          ),
                          SizedBox(height: heightval*0.02,),

                          CommonButton_loading(label: "Add post.",
                              onPressed:()async
                              {
                                try{
                                  isLoadingCont_add_post.change_isloadingval(true);
                                  if(
                                  select_post_photo_cont.imageBytes.value==null || select_post_photo_cont.imagePath.value=="" ||
                                      select_post_video_cont.videoBytes.value == null || select_post_video_cont.videoPath.value==""||
                                  post_descriptiion_cont.text.isEmpty ||
                                  select_post_file_cont.filePath.value=="" || select_post_file_cont.fileBytes.value==null
                                  || select_post_file_cont.fileExtension.value==""
                                  )
                                    {
                                      isLoadingCont_add_post.change_isloadingval(false);
                                      Toastget().Toastmsg("Fill and select all above detals properly and try again.");
                                      return;
                                    }
                                  int post_insert_databse_result=await AddPost(file_extension:select_post_file_cont.fileExtension.value ,filebytes:select_post_file_cont.fileBytes.value,username: widget.username, jwttoken: widget.jwttoken, description: post_descriptiion_cont.text.toString(), imagebytes: select_post_photo_cont.imageBytes.value, videobytes: select_post_video_cont.videoBytes.value);
                                  print(post_insert_databse_result);
                                  if(post_insert_databse_result==0)
                                    {

                                      isLoadingCont_add_post.change_isloadingval(false);
                                      Toastget().Toastmsg("Insert post success.");
                                      return;
                                    }
                                  if(post_insert_databse_result==5)
                                  {
                                    //User doesn't exist.
                                    await clearUserData();
                                    await deleteTempDirectoryPostVideo();
                                    await deleteTempDirectoryCampaignVideo();
                                    isLoadingCont_add_post.change_isloadingval(false);
                                    Toastget().Toastmsg("Insert post fail.Relogin and try again.");
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) {
                                      return Home();
                                    },
                                    )
                                    );
                                    return;
                                  }
                                  if(post_insert_databse_result==3)
                                  {
                                    isLoadingCont_add_post.change_isloadingval(false);
                                    Toastget().Toastmsg("Insert post Fail.Try again");
                                    return;
                                  }
                                  if(post_insert_databse_result==6)
                                  {
                                    isLoadingCont_add_post.change_isloadingval(false);
                                    Toastget().Toastmsg("The provide details are not in correct format.Recheck and try again.");
                                    return;
                                  }
                                  if(post_insert_databse_result==9)
                                  {
                                    isLoadingCont_add_post.change_isloadingval(false);
                                    Toastget().Toastmsg("The provide details are not in correct format.Recheck and try again.");
                                    return;
                                  }
                                  if(post_insert_databse_result==10 || post_insert_databse_result==11)
                                  {
                                    await clearUserData();
                                    isLoadingCont_add_post.change_isloadingval(false);
                                    Toastget().Toastmsg("Insert post faiL.Relogin and try again.");
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) {
                                      return Home();
                                    },
                                    )
                                    );
                                    return;
                                  }
                                  if(post_insert_databse_result==4)
                                  {
                                    await clearUserData();
                                    isLoadingCont_add_post.change_isloadingval(false);
                                    Toastget().Toastmsg("Insert post faiL.Relogin and try again.");
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) {
                                      return Home();
                                    },
                                    )
                                    );
                                    return;
                                  }
                                  if(post_insert_databse_result==2)
                                  {
                                    isLoadingCont_add_post.change_isloadingval(false);
                                    Toastget().Toastmsg("Insert post fail.Try again.");
                                    return;
                                  }

                                }catch(obj)
                                {
                                  isLoadingCont_add_post.change_isloadingval(false);
                                  Toastget().Toastmsg("Add post fail.Try again.");
                                  return;
                                }
                              },
                            color:Colors.lightBlue,
                            textStyle: TextStyle(color: Colors.black,fontSize: shortestval*0.05),
                            padding: const EdgeInsets.all(12),
                            borderRadius:25.0,
                            width: shortestval*0.50,
                            height: shortestval*0.15,
                            isLoading:isLoadingCont_add_post.isloading.value,
                          ),
                        ],


                      ),
                    ),
                  ),
                )
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
}
