import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/common_button_loading.dart';
import '../commonwidget/commontextfield_obs_false_p.dart';
import '../commonwidget/getx_cont_pick_single_photo_int.dart';
import '../commonwidget/single_file_pick_getx_cont.dart';
import '../commonwidget/single_video_pick_getx.dart';
import '../commonwidget/toast.dart';
import '../constant/constant.dart';
import '../home/authentication_home_p.dart';
import 'getx_cont_actions/getx_cont_isloading_add_campaign.dart';
import 'getx_cont_actions/getx_cont_isloading_select_file.dart';
import 'getx_cont_actions/getx_cont_isloading_select_image.dart';
import 'getx_cont_actions/getx_cont_isloading_select_video.dart';
import 'package:http/http.dart' as http;

class InsertcampaignscreenP extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const InsertcampaignscreenP({super.key, required this.username, required this.usertype, required this.jwttoken});

  @override
  State<InsertcampaignscreenP> createState() => _InsertcampaignscreenPState();
}

class _InsertcampaignscreenPState extends State<InsertcampaignscreenP> with SingleTickerProviderStateMixin {
  final campaign_descriptiion_cont = TextEditingController();
  final campaign_tittle_cont = TextEditingController();
  final campaign_postId_cont = TextEditingController();

  final isLoadingCont_image = Get.put(Isloading_selwct_image_actions_screen());
  final isLoadingCont_video = Get.put(Isloading_select_video_actions_screen());
  final isLoadingCont_add_campaign = Get.put(Isloading_add_campaign_actions_screen());
  final isLoadingCont_select_file = Get.put(Isloading_select_file_actions_screen());

  final select_campaign_photo_cont = Get.put(pick_single_photo_getx_int());
  final select_campaign_video_cont = Get.put(PickSingleVideoController());
  final select_campaign_file_cont = Get.put(FilePickerController());

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    select_campaign_photo_cont.imageBytes.value = null;
    select_campaign_photo_cont.imagePath.value = "";
    select_campaign_video_cont.videoBytes.value = null;
    select_campaign_video_cont.videoPath.value = "";
    select_campaign_file_cont.fileBytes.value = null;
    select_campaign_file_cont.filePath.value = "";
    select_campaign_file_cont.fileExtension.value = "";

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    campaign_descriptiion_cont.dispose();
    campaign_tittle_cont.dispose();
    campaign_postId_cont.dispose();
    super.dispose();
  }

  Future<int> AddCampaign({
    required String file_extension,
    required String username,
    required String postid,
    required String tittle,
    required String jwttoken,
    required filebytes,
    required String description,
    required imagebytes,
    required videobytes,
  }) async {
    try {
      final String base64Image = base64Encode(imagebytes as List<int>);
      final String base64Video = base64Encode(videobytes as List<int>);
      final String base64File = base64Encode(filebytes as List<int>);

      const String url = Backend_Server_Url + "api/Actions/insertcampaign";
      Map<String, dynamic> post_data = {
        "Username": username,
        "CampaignDate": DateTime.now().toUtc().toString(),
        "Description": description,
        "Video": base64Video,
        "Photo": base64Image,
        "CampaignFile": base64File,
        "Tittle": tittle,
        "PostId": postid,
        "FileExtension": file_extension,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", 'Authorization': 'Bearer $jwttoken'},
        body: json.encode(post_data),
      );

      if (response.statusCode == 200) {
        print("User authenticated");
        return 0;
      } else if (response.statusCode == 701) {
        return 5; // user doesn't exist
      } else if (response.statusCode == 702) {
        return 3; // exception caught in backend
      } else if (response.statusCode == 700) {
        return 6; // validation error in backend
      } else if (response.statusCode == 703) {
        return 1; // validation error in backend
      } else if (response.statusCode == 400) {
        return 9; // details validation error
      } else if (response.statusCode == 401) {
        return 10; // jwt error
      } else if (response.statusCode == 403) {
        return 11; // jwt error
      } else {
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
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Campaign", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
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
        padding: EdgeInsets.all(shortestval * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: shortestval * 0.03),
            _buildTextField("Enter the post Id.", campaign_postId_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter tittle of campaign.", campaign_tittle_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.02),
            _buildTextField("Enter description of campaign.", campaign_descriptiion_cont, shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
            _buildSelectionButtons(shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
            _buildAddCampaignButton(shortestval, widthval),
            SizedBox(height: shortestval * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(double shortestval, double widthval, double heightval) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(height: shortestval * 0.03),
                  _buildTextField("Enter the post Id.", campaign_postId_cont, shortestval, widthval * 0.45),
                  SizedBox(height: shortestval * 0.02),
                  _buildTextField("Enter tittle of campaign.", campaign_tittle_cont, shortestval, widthval * 0.45),
                  SizedBox(height: shortestval * 0.02),
                  _buildTextField("Enter description of campaign.", campaign_descriptiion_cont, shortestval, widthval * 0.45),
                  SizedBox(height: shortestval * 0.03),
                  _buildAddCampaignButton(shortestval, widthval * 0.45),
                ],
              ),
            ),
            SizedBox(width: shortestval * 0.03),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  SizedBox(height: shortestval * 0.03),
                  _buildSelectionButtons(shortestval, widthval * 0.65),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, double shortestval, double width) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      padding: EdgeInsets.all(shortestval * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: CommonTextField_obs_false_p(hint, "", false, controller, context),
    );
  }

  Widget _buildSelectionButtons(double shortestval, double width) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
                () => CommonButton_loading(
              label: "Select image",
              onPressed: () async {
                try {
                  isLoadingCont_image.change_isloadingval(true);
                  int result_select_image_post = await select_campaign_photo_cont.pickImage();
                  if (result_select_image_post == 1) {
                    isLoadingCont_image.change_isloadingval(false);
                    Toastget().Toastmsg("Image select success.");
                    return;
                  }
                  if (result_select_image_post == 2) {
                    isLoadingCont_image.change_isloadingval(false);
                    Toastget().Toastmsg("Invalid image extension.JPG,JPEG,PNG only valid.Fail");
                    return;
                  }
                  if (result_select_image_post == 3) {
                    isLoadingCont_image.change_isloadingval(false);
                    Toastget().Toastmsg("No Image select.Fail.");
                    return;
                  }
                  if (result_select_image_post == 4) {
                    isLoadingCont_image.change_isloadingval(false);
                    Toastget().Toastmsg("Try again.Fail.");
                    return;
                  }
                } catch (obj) {
                  print("Exception caught while selecting image for post.");
                  print(obj.toString());
                  isLoadingCont_image.change_isloadingval(false);
                  Toastget().Toastmsg("Select image fail.Try again.");
                  return;
                }
              },
              color: select_campaign_photo_cont.imageBytes.value == null ? Colors.red : Colors.green,
              textStyle: TextStyle(color: Colors.white, fontSize: shortestval * 0.04, fontWeight: FontWeight.bold),
              padding: EdgeInsets.all(shortestval * 0.03),
              borderRadius: 25.0,
              width: shortestval * 0.30,
              height: shortestval * 0.15,
              isLoading: isLoadingCont_image.isloading.value,
            ),
          ),
          SizedBox(width: shortestval * 0.02),
          Obx(
                () => CommonButton_loading(
              label: "Select video",
              onPressed: () async {
                try {
                  isLoadingCont_video.change_isloadingval(true);
                  int result_select_video_post = await select_campaign_video_cont.pickVideo();
                  if (result_select_video_post == 1) {
                    isLoadingCont_video.change_isloadingval(false);
                    Toastget().Toastmsg("Video select success.");
                    return;
                  }
                  if (result_select_video_post == 2) {
                    isLoadingCont_video.change_isloadingval(false);
                    Toastget().Toastmsg("Video size exceeds more than 2 GB.Fail.");
                    return;
                  }
                  if (result_select_video_post == 3) {
                    isLoadingCont_video.change_isloadingval(false);
                    Toastget().Toastmsg("Invalid video format.Only support .mp4.");
                    return;
                  }
                  if (result_select_video_post == 4) {
                    isLoadingCont_video.change_isloadingval(false);
                    Toastget().Toastmsg("No video select.Fail.");
                    return;
                  }
                  if (result_select_video_post == 5) {
                    isLoadingCont_video.change_isloadingval(false);
                    Toastget().Toastmsg("Try again.");
                    return;
                  }
                } catch (obj) {
                  print("Exception caught while selecting video for post.");
                  print(obj.toString());
                  isLoadingCont_video.change_isloadingval(false);
                  Toastget().Toastmsg("Select video fail.Try again.");
                }
              },
              color: select_campaign_video_cont.videoBytes.value == null ? Colors.red : Colors.green,
              textStyle: TextStyle(color: Colors.white, fontSize: shortestval * 0.04, fontWeight: FontWeight.bold),
              padding: EdgeInsets.all(shortestval * 0.03),
              borderRadius: 25.0,
              width: shortestval * 0.30,
              height: shortestval * 0.15,
              isLoading: isLoadingCont_video.isloading.value,
            ),
          ),
          SizedBox(width: shortestval * 0.02),
          Obx(
                () => CommonButton_loading(
              label: "Select file",
              onPressed: () async {
                try {
                  isLoadingCont_select_file.change_isloadingval(true);
                  int result_select_file_post = await select_campaign_file_cont.pickFile();
                  if (result_select_file_post == 1) {
                    isLoadingCont_select_file.change_isloadingval(false);
                    Toastget().Toastmsg("File select success.");
                    return;
                  }
                  if (result_select_file_post == 2) {
                    isLoadingCont_select_file.change_isloadingval(false);
                    Toastget().Toastmsg("File size exceeds more tahn 2 GB.Fail.");
                    return;
                  }
                  if (result_select_file_post == 3) {
                    isLoadingCont_select_file.change_isloadingval(false);
                    Toastget().Toastmsg("No file selected.Only support .pdf,.docx,.txt");
                    return;
                  }
                  if (result_select_file_post == 4) {
                    isLoadingCont_select_file.change_isloadingval(false);
                    Toastget().Toastmsg("No file select.Fail.Try again.");
                    return;
                  }
                } catch (obj) {
                  print("Exception caught while selecting file for post.");
                  print(obj.toString());
                  isLoadingCont_select_file.change_isloadingval(false);
                  Toastget().Toastmsg("Select file fail.Try again.");
                }
              },
              color: select_campaign_file_cont.fileBytes.value == null ? Colors.red : Colors.green,
              textStyle: TextStyle(color: Colors.white, fontSize: shortestval * 0.04, fontWeight: FontWeight.bold),
              padding: EdgeInsets.all(shortestval * 0.03),
              borderRadius: 25.0,
              width: shortestval * 0.30,
              height: shortestval * 0.15,
              isLoading: isLoadingCont_select_file.isloading.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCampaignButton(double shortestval, double width) {
    return CommonButton_loading(
      label: "Add campaign",
      onPressed: () async {
        try {
          isLoadingCont_add_campaign.change_isloadingval(true);
          if (select_campaign_photo_cont.imageBytes.value == null ||
              select_campaign_photo_cont.imagePath.value == "" ||
              select_campaign_video_cont.videoBytes.value == null ||
              select_campaign_video_cont.videoPath.value == "" ||
              campaign_descriptiion_cont.text.isEmpty ||
              campaign_tittle_cont.text.isEmpty ||
              campaign_postId_cont.text.isEmpty ||
              select_campaign_file_cont.filePath.value == "" ||
              select_campaign_file_cont.fileBytes.value == null ||
              select_campaign_file_cont.fileExtension.value == "") {
            isLoadingCont_add_campaign.change_isloadingval(false);
            Toastget().Toastmsg("Fill and select all above details properly and try again.");
            return;
          }
          int campaign_insert_databse_result = await AddCampaign(
            file_extension: select_campaign_file_cont.fileExtension.value,
            tittle: campaign_tittle_cont.text.toString(),
            postid: campaign_postId_cont.text.toString(),
            filebytes: select_campaign_file_cont.fileBytes.value,
            username: widget.username,
            jwttoken: widget.jwttoken,
            description: campaign_descriptiion_cont.text.toString(),
            imagebytes: select_campaign_photo_cont.imageBytes.value,
            videobytes: select_campaign_video_cont.videoBytes.value,
          );
          print(campaign_insert_databse_result);
          if (campaign_insert_databse_result == 0) {
            isLoadingCont_add_campaign.change_isloadingval(false);
            Toastget().Toastmsg("Insert campaign success.");
            return;
          }
          if (campaign_insert_databse_result == 1) {
            isLoadingCont_add_campaign.change_isloadingval(false);
            Toastget().Toastmsg("Incorrect post id.No post with that id is present.");
            return;
          }
          if (campaign_insert_databse_result == 5) {
            await clearUserData();
            isLoadingCont_add_campaign.change_isloadingval(false);
            Toastget().Toastmsg("Fail.Relogin and try again.");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
            return;
          }
          if (campaign_insert_databse_result == 3) {
            isLoadingCont_add_campaign.change_isloadingval(false);
            Toastget().Toastmsg("Insert campaign Fail.Try again");
            return;
          }
          if (campaign_insert_databse_result == 6) {
            isLoadingCont_add_campaign.change_isloadingval(false);
            Toastget().Toastmsg("The provide details are not in correct format.Recheck and try again.");
            return;
          }
          if (campaign_insert_databse_result == 9) {
            isLoadingCont_add_campaign.change_isloadingval(false);
            Toastget().Toastmsg("The provide details are not in correct format.Recheck and try again.");
            return;
          }
          if (campaign_insert_databse_result == 10 || campaign_insert_databse_result == 11) {
            await clearUserData();
            isLoadingCont_add_campaign.change_isloadingval(false);
            Toastget().Toastmsg("Insert campaign faiL.Relogin and try again.");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
            return;
          }
          if (campaign_insert_databse_result == 4) {
            await clearUserData();
            isLoadingCont_add_campaign.change_isloadingval(false);
            Toastget().Toastmsg("Insert campaign faiL.Relogin and try again.");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationHome()));
            return;
          }
          if (campaign_insert_databse_result == 2) {
            isLoadingCont_add_campaign.change_isloadingval(false);
            Toastget().Toastmsg("Add campaign fail.Try again.");
            return;
          }
        } catch (obj) {
          isLoadingCont_add_campaign.change_isloadingval(false);
          Toastget().Toastmsg("Add campaign fail.Try again.");
          return;
        }
      },
      color: Colors.lightBlue,
      textStyle: TextStyle(color: Colors.white, fontSize: shortestval * 0.04, fontWeight: FontWeight.bold),
      padding: EdgeInsets.all(shortestval * 0.03),
      borderRadius: 25.0,
      width: width,
      height: shortestval * 0.15,
      isLoading: isLoadingCont_add_campaign.isloading.value,
    );
  }
}


