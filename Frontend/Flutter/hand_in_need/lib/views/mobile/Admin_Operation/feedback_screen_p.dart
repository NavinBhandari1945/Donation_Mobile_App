import 'dart:convert';
import 'dart:typed_data'; // Explicitly import for Uint8List
import 'package:flutter/material.dart';
import 'package:hand_in_need/views/constant/styles.dart';
import 'package:http/http.dart' as http;

import '../../../models/mobile/FeedbackModel.dart';
import '../commonwidget/CommonMethod.dart';
import '../commonwidget/toast.dart';
import '../constant/constant.dart';
import '../home/home_p.dart';

class Feedback_Screen_Ui extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const Feedback_Screen_Ui({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<Feedback_Screen_Ui> createState() => _Feedback_Screen_UiState();
}

class _Feedback_Screen_UiState extends State<Feedback_Screen_Ui> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  @override
  void initState()
  {
    super.initState();
    checkJWTExpiation();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> checkJWTExpiation()async {
    try {
      print("check jwt called in admin home screen.");
      int result = await checkJwtToken_initistate_admin(
          widget.username, widget.usertype, widget.jwttoken);
      if (result == 0) {
        await clearUserData();
        await deleteTempDirectoryPostVideo();
        await deleteTempDirectoryCampaignVideo();
        print("Deleteing temporary directory success.");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context)
        {
          return Home();
        },)
        );
        Toastget().Toastmsg("Session End. Relogin please.");
      }
    }
    catch(obj) {
      print("Exception caught while verifying jwt for admin home screen.");
      print(obj.toString());
      await clearUserData();
      await deleteTempDirectoryPostVideo();
      await deleteTempDirectoryCampaignVideo();
      print("Deleteing temporary directory success.");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
        return Home();
      },)
      );
      Toastget().Toastmsg("Error. Relogin please.");
    }
  }

  List<FeedbackModel> Feedback_Info_List = [];

  Future<void> Get_Feedback_Info() async
  {
    try {
      print("Post info at user authentication screen method called");
      const String url =Backend_Server_Url+"api/Admin_Task_/get_feedback_info";
      // const String url = "http://10.0.2.2:5074/api/Authentication/authenticationpostinfo";
      final headers =
      {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.jwttoken}',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      print(response);
      if (response.statusCode == 200) {
        List<dynamic> responseData = await jsonDecode(response.body);
        Feedback_Info_List.clear();
        Feedback_Info_List.addAll
          (
          responseData.map((data) => FeedbackModel.fromJson(data)).toList(),
        );
        print("Feedback_Info_List count value for admin screen.");
        print(Feedback_Info_List.length);
        return;
      } else
      {
        Feedback_Info_List.clear();
        print("Data insert in Feedback_Info_List count value for admin screen failed.");
        return;
      }
    } catch (obj)
    {
      Feedback_Info_List.clear();
      print("Exception caught while fetching feedback data in http method");
      print(obj.toString());
      return;
    }
  }


  @override
  Widget build(BuildContext context)  {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback Screen"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: widthval,
        height: heightval,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white10, Colors.grey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return FutureBuilder<void>(
              future: Get_Feedback_Info(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.green));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error loading feedback", style: TextStyle(color: Colors.red)));
                } else {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: orientation == Orientation.portrait
                        ? _buildPortraitLayout(widthval, heightval, shortestval)
                        : _buildLandscapeLayout(widthval, heightval, shortestval),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }


  Widget _buildPortraitLayout(double widthval, double heightval, double shortestval) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Feedback List", shortestval),
            SizedBox(height: shortestval * 0.04),
            Feedback_Info_List.isEmpty
                ? _buildEmptyState(shortestval)
                : Column(
              children: Feedback_Info_List.map((feedback) => _buildFeedbackCard(feedback, widthval, shortestval, true)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(double widthval, double heightval, double shortestval) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Feedback List", shortestval),
            SizedBox(height: shortestval * 0.04),
            Feedback_Info_List.isEmpty
                ? _buildEmptyState(shortestval)
                : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: shortestval * 0.04,
                mainAxisSpacing: shortestval * 0.04,
                childAspectRatio: 0.8,
              ),
              itemCount: Feedback_Info_List.length,
              itemBuilder: (context, index) {
                return _buildFeedbackCard(Feedback_Info_List[index], widthval, shortestval, false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, double shortestval) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: shortestval * 0.06,
          fontWeight: FontWeight.bold,
          color: Colors.green,
          shadows: [
            Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(double shortestval) {
    return Center(
      child: Text(
        "No feedback available",
        style: TextStyle(
          fontSize: shortestval * 0.05,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(FeedbackModel feedback, double widthval, double shortestval, bool isPortrait) {
    Uint8List? imageBytes;
    if (feedback.fdImage != null && feedback.fdImage!.isNotEmpty) {
      try {
        imageBytes = base64Decode(feedback.fdImage!) as Uint8List?;
      } catch (e) {
        print("Error decoding base64 image: $e");
      }
    }

    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.0).animate(_animationController),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: isPortrait ? widthval * 0.9 : widthval * 0.42,
          padding: EdgeInsets.all(shortestval * 0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Username:${feedback.fdUsername}",
                style: TextStyle(
                  fontSize: shortestval * 0.06,
                  fontWeight: FontWeight.bold,
                  fontFamily:bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: shortestval * 0.02),
              Text(
                "Description:${feedback.fdDescription}",
                style: TextStyle(fontFamily: semibold,fontSize: shortestval * 0.05, color: Colors.black87),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: shortestval * 0.02),
              Text(
                "Date:${feedback.fdDate}",
                style: TextStyle(fontSize: shortestval * 0.04, color: Colors.black),
              ),
              SizedBox(height: shortestval * 0.02),
              imageBytes != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  imageBytes,
                  height: isPortrait ? shortestval * 0.3 : shortestval * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                height: isPortrait ? shortestval * 0.3 : shortestval * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text("No Image", style: TextStyle(color: Colors.grey))),
              ),
            ],
          ),
        ),
      ),
    );
  }


}//widget build method
