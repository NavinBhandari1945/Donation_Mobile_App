import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:hand_in_need/views/mobile/constant/constant.dart';
import 'package:velocity_x/velocity_x.dart';
import '../commonwidget/circular_progress_ind_yellow.dart';
import '../commonwidget/getx_cont_pick_single_photo.dart';
import 'package:http/http.dart' as http;

class FeedbackScreenP extends StatefulWidget {
  const FeedbackScreenP({super.key});

  @override
  State<FeedbackScreenP> createState() => _FeedbackScreenPState();
}

class _FeedbackScreenPState extends State<FeedbackScreenP> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late AnimationController _animationController;
  Animation<double>? _fadeAnimation;
  Animation<double>? _scaleAnimation;
  final Select_Image_Cont = Get.put(pick_single_photo_getx());

  @override
  void initState() {
    super.initState();
    Select_Image_Cont.imageBytes.value = null;
    Select_Image_Cont.imagePath.value = "";
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<int> Add_Feedback({
    required String Feedback_Username,
    required Image_Bytes,
    required String Feedback_Description,
  }) async {
    try {
      final String base64Image = base64Encode(Image_Bytes as List<int>);
      const String url = Backend_Server_Url + "api/Authentication/add_feedback";
      Map<String, dynamic> Feedback_Data = {
        "FdUsername": Feedback_Username,
        "FdDescription": Feedback_Description,
        "FdImage": base64Image,
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(Feedback_Data),
      );
      if (response.statusCode == 200) {
        print("Feedback data saved.");
        return 1;
      } else if (response.statusCode == 700) {
        print("Feedback data not found.");
        return 2;
      } else if (response.statusCode == 702) {
        print("Exception caught in backend");
        return 3;
      } else {
        print(response.body);
        print("Error.other status code.");
        return 4;
      }
    } catch (obj) {
      print("Exception caught while inserting post in http method.");
      print(obj.toString());
      return 0;
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
          "Feedback",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            width: widthval,
            height: heightval,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[50]!, Colors.grey.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: _fadeAnimation != null && _scaleAnimation != null
                ? FadeTransition(
              opacity: _fadeAnimation!,
              child: orientation == Orientation.portrait
                  ? _buildPortraitLayout(shortestval, widthval, heightval)
                  : _buildLandscapeLayout(shortestval, widthval, heightval),
            )
                : Center(child: Circular_pro_indicator_Yellow(context)),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout(double shortestval, double widthval, double heightval) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(shortestval * 0.05),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: widthval * 0.9,
              padding: EdgeInsets.all(shortestval * 0.06),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(vertical: shortestval * 0.02),
                    child: Text(
                      "We’d Love Your Feedback!",
                      style: TextStyle(
                        fontSize: shortestval * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: shortestval * 0.04),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Enter your name",
                      labelStyle: TextStyle(color: Colors.green[700]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.green[700]),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                      ),
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                    style: TextStyle(fontSize: shortestval * 0.045),
                  ),
                  SizedBox(height: shortestval * 0.04),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: Colors.green[700]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      alignLabelWithHint: true,
                      hintText: "Tell us what you think...",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                      ),
                    ),
                    style: TextStyle(fontSize: shortestval * 0.045),
                  ),
                  SizedBox(height: shortestval * 0.04),
                  ScaleTransition(
                    scale: _scaleAnimation!,
                    child: Obx(
                          () => ElevatedButton.icon(
                        onPressed: () async {
                          bool result = await Select_Image_Cont.pickImage();
                          if (result == true) {
                            Toastget().Toastmsg("Feedback image select success");
                            return;
                          } else {
                            Toastget().Toastmsg("Feedback image select fail.");
                            return;
                          }
                        },
                        icon: Icon(Icons.image, color: Colors.white, size: shortestval * 0.06),
                        label: Text(
                          "Select Image",
                          style: TextStyle(color: Colors.white, fontSize: shortestval * 0.045),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Select_Image_Cont.imageBytes.value != null &&
                              Select_Image_Cont.imagePath.value.isNotEmpty
                              ? Colors.green[700]
                              : Colors.red[600],
                          padding: EdgeInsets.symmetric(
                              horizontal: shortestval * 0.05, vertical: shortestval * 0.04),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: shortestval * 0.04),
                  Center(
                    child: ScaleTransition(
                      scale: _scaleAnimation!,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_usernameController.text.toString().isEmptyOrNull ||
                              _descriptionController.text.toString().isEmptyOrNull) {
                            Toastget().Toastmsg("Fill the above field and try again.");
                            return;
                          }
                          if (Select_Image_Cont.imageBytes.value == null ||
                              Select_Image_Cont.imageBytes.value!.isEmpty ||
                              Select_Image_Cont.imagePath.value.isEmptyOrNull) {
                            Toastget().Toastmsg("Select image and try again.");
                            return;
                          }
                          int result = await Add_Feedback(
                            Feedback_Username: _usernameController.text.toString(),
                            Image_Bytes: Select_Image_Cont.imageBytes.value,
                            Feedback_Description: _descriptionController.text.toString(),
                          );
                          if (result == 1) {
                            Toastget().Toastmsg("Feedback send success. Thank you.");
                            return;
                          } else {
                            Toastget().Toastmsg("Feedback send fail. Try again.");
                            return;
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: shortestval * 0.08, vertical: shortestval * 0.04),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: shortestval * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 10,
                          shadowColor: Colors.black45,
                          textStyle: TextStyle(letterSpacing: 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(double shortestval, double widthval, double heightval) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(shortestval * 0.03),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: widthval * 0.95,
              padding: EdgeInsets.all(shortestval * 0.04),
              constraints: BoxConstraints(maxHeight: heightval * 0.85),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(vertical: shortestval * 0.02),
                          child: Text(
                            "We’d Love Your Feedback!",
                            style: TextStyle(
                              fontSize: shortestval * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: shortestval * 0.02),
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Enter your name",
                            labelStyle: TextStyle(color: Colors.green[700]),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.green[700], size: shortestval * 0.05),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                            ),
                            hintStyle: TextStyle(color: Colors.grey[500], fontSize: shortestval * 0.04),
                            contentPadding: EdgeInsets.symmetric(vertical: shortestval * 0.03, horizontal: 10),
                          ),
                          style: TextStyle(fontSize: shortestval * 0.04),
                        ),
                        SizedBox(height: shortestval * 0.02),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: "Description",
                            labelStyle: TextStyle(color: Colors.green[700]),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            alignLabelWithHint: true,
                            hintText: "Tell us what you think...",
                            hintStyle: TextStyle(color: Colors.grey[500], fontSize: shortestval * 0.04),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: shortestval * 0.03, horizontal: 10),
                          ),
                          style: TextStyle(fontSize: shortestval * 0.04),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: shortestval * 0.03),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation!,
                          child: Obx(
                                () => ElevatedButton.icon(
                              onPressed: () async {
                                bool result = await Select_Image_Cont.pickImage();
                                if (result == true) {
                                  Toastget().Toastmsg("Feedback image select success");
                                  return;
                                } else {
                                  Toastget().Toastmsg("Feedback image select fail.");
                                  return;
                                }
                              },
                              icon: Icon(Icons.image, color: Colors.white, size: shortestval * 0.05),
                              label: Text(
                                "Select Image",
                                style: TextStyle(color: Colors.white, fontSize: shortestval * 0.035),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Select_Image_Cont.imageBytes.value != null &&
                                    Select_Image_Cont.imagePath.value.isNotEmpty
                                    ? Colors.green[700]
                                    : Colors.red[600],
                                padding: EdgeInsets.symmetric(
                                    horizontal: shortestval * 0.04, vertical: shortestval * 0.03),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black45,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: shortestval * 0.02),
                        ScaleTransition(
                          scale: _scaleAnimation!,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_usernameController.text.toString().isEmptyOrNull ||
                                  _descriptionController.text.toString().isEmptyOrNull) {
                                Toastget().Toastmsg("Fill the above field and try again.");
                                return;
                              }
                              if (Select_Image_Cont.imageBytes.value == null ||
                                  Select_Image_Cont.imageBytes.value!.isEmpty ||
                                  Select_Image_Cont.imagePath.value.isEmptyOrNull) {
                                Toastget().Toastmsg("Select image and try again.");
                                return;
                              }
                              int result = await Add_Feedback(
                                Feedback_Username: _usernameController.text.toString(),
                                Image_Bytes: Select_Image_Cont.imageBytes.value,
                                Feedback_Description: _descriptionController.text.toString(),
                              );
                              if (result == 1) {
                                Toastget().Toastmsg("Feedback send success. Thank you.");
                                return;
                              } else {
                                Toastget().Toastmsg("Feedback send fail. Try again.");
                                return;
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: shortestval * 0.06, vertical: shortestval * 0.03),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: shortestval * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 10,
                              shadowColor: Colors.black45,
                              textStyle: TextStyle(letterSpacing: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}







//01
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
// import 'package:hand_in_need/views/mobile/constant/constant.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../commonwidget/circular_progress_ind_yellow.dart';
// import '../commonwidget/getx_cont_pick_single_photo.dart';
// import 'package:http/http.dart' as http;
//
// class FeedbackScreenP extends StatefulWidget {
//   const FeedbackScreenP({super.key});
//
//   @override
//   State<FeedbackScreenP> createState() => _FeedbackScreenPState();
// }
//
// class _FeedbackScreenPState extends State<FeedbackScreenP>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   late AnimationController _animationController;
//   Animation<double>? _fadeAnimation; // Changed to nullable
//   Animation<double>? _scaleAnimation; // Changed to nullable
//   final Select_Image_Cont=Get.put(pick_single_photo_getx());
//
//   @override
//   void initState() {
//     super.initState();
//     Select_Image_Cont.imageBytes.value=null;
//     Select_Image_Cont.imagePath.value=="";
//     // Initialize animation controller
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//
//     // Fade animation for form entrance
//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//
//     // Scale animation for buttons
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInBack),
//     );
//
//     // Start the animation after setup
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _usernameController.dispose();
//     _descriptionController.dispose();
//     _animationController.dispose();
//
//   }
//
//
//   Future<int> Add_Feedback({required String Feedback_Username,required Image_Bytes,required String Feedback_Description}) async
//   {
//     try
//     {
//       final String base64Image =base64Encode(Image_Bytes as List<int>);
//
//       // API endpoint
//       // const String url = "http://10.0.2.2:5074/api/Authentication/add_feedback";
//       const String url = Backend_Server_Url+"api/Authentication/add_feedback";
//       Map<String, dynamic> Feedback_Data =
//       {
//         "FdUsername":Feedback_Username,
//         "FdDescription": Feedback_Description,
//         "FdImage": base64Image
//       };
//
//       // Send the POST request
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: json.encode(Feedback_Data),
//       );
//
//       // Handling the response
//       if (response.statusCode == 200) {
//         print("Feedback data saved.");
//         return 1;
//       }
//       else if(response.statusCode==700)
//       {
//         print("Feedback data not found.");
//         return 2;
//       }
//       else if(response.statusCode==702)
//       {
//         print("Exception caught in backend");
//         return 3;  //exception caught in backend
//       }
//       else
//       {
//         print(response.body);
//         print("Error.other status code.");
//         return 4;
//       }
//     } catch (obj) {
//       print("Exception caught while inserting post in http method.");
//       print(obj.toString());
//       return 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var shortestval = MediaQuery.of(context).size.shortestSide;
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Feedback Screen"),
//         backgroundColor: Colors.green,
//       ),
//       body: OrientationBuilder(
//         builder: (context, orientation) {
//           if (orientation == Orientation.portrait) {
//             return Container(
//               width: widthval,
//               height: heightval,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.white10, Colors.grey.shade200],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Center(
//                 child: _fadeAnimation != null && _scaleAnimation != null
//                     ? FadeTransition(
//                   opacity: _fadeAnimation!,
//                   child: Container(
//                     width: widthval * 0.9,
//                     height: heightval * 0.6,
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 20,
//                           offset: Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       physics: BouncingScrollPhysics(),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AnimatedContainer(
//                             duration: Duration(milliseconds: 500),
//                             curve: Curves.easeInOut,
//                             padding: EdgeInsets.symmetric(vertical: 10),
//                             child: Text(
//                               "We’d Love Your Feedback!",
//                               style: TextStyle(
//                                 fontSize: shortestval * 0.06,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.green,
//                                 shadows: [
//                                   Shadow(
//                                     color: Colors.black26,
//                                     offset: Offset(2, 2),
//                                     blurRadius: 5,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: shortestval * 0.04),
//                           TextField(
//                             controller: _usernameController,
//                             decoration: InputDecoration(
//                               labelText: "Enter your name.",
//                               labelStyle: TextStyle(color: Colors.green),
//                               filled: true,
//                               fillColor: Colors.grey.shade100,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide.none,
//                               ),
//                               prefixIcon: Icon(Icons.person, color: Colors.green),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.green, width: 2),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: shortestval * 0.04),
//                           TextField(
//                             controller: _descriptionController,
//                             maxLines: 5,
//                             decoration: InputDecoration(
//                               labelText: "Description",
//                               labelStyle: TextStyle(color: Colors.green),
//                               filled: true,
//                               fillColor: Colors.grey.shade100,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide.none,
//                               ),
//                               alignLabelWithHint: true,
//                               hintText: "Tell us what you think...",
//                               hintStyle: TextStyle(color: Colors.grey),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.green, width: 2),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: shortestval * 0.04),
//                           ScaleTransition(
//                             scale: _scaleAnimation!,
//                             child:
//                             Obx(
//                                 ()=>ElevatedButton.icon (
//                                 onPressed: ()async
//                                 {
//                                   bool result=await Select_Image_Cont.pickImage();
//                                   if(result==true){
//                                     Toastget().Toastmsg("Feedback image select success");
//                                     return;
//                                   }
//                                   else
//                                     {
//                                       Toastget().Toastmsg("Feedback image select fail.");
//                                       return;
//                                     }
//                                 },
//                                 icon: Icon(Icons.image,
//                                   color: Colors.white,
//                                 ),
//                                 label: Text("Select Image",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 style:
//                                  ElevatedButton.styleFrom(
//                                   backgroundColor:Select_Image_Cont.imageBytes.value!=null && Select_Image_Cont.imagePath.value.isNotEmpty?Colors.green:Colors.red,
//                                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   elevation: 5,
//                                   shadowColor: Colors.black45,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: shortestval * 0.04),
//                           Center(
//                             child: ScaleTransition(
//                               scale: _scaleAnimation!,
//                               child: ElevatedButton(
//                                 onPressed:()async
//                                 {
//                                   if(_usernameController.text.toString().isEmptyOrNull || _descriptionController.text.toString().isEmptyOrNull)
//                                     {
//                                       Toastget().Toastmsg("Fill the above field and try again.");
//                                       return;
//                                     }
//                                   if(
//                                   Select_Image_Cont.imageBytes.value!.isEmpty || Select_Image_Cont.imageBytes.value==null ||
//                                   Select_Image_Cont.imagePath.value.isEmptyOrNull
//                                   )
//                                   {
//                                     Toastget().Toastmsg("Select image and try again.");
//                                     return;
//                                   }
//
//                                   int result=await Add_Feedback(Feedback_Username: _usernameController.text.toString(), Image_Bytes: Select_Image_Cont.imageBytes.value, Feedback_Description: _descriptionController.text.toString());
//                                   if(result==1)
//                                     {
//                                       Toastget().Toastmsg("Feedback send success.Thank you.");
//                                       return;
//                                     }
//                                   else
//                                     {
//                                       Toastget().Toastmsg("Feedback send fail.Try again.");
//                                       return;
//                                     }
//                                 },
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                                   child: Text(
//                                     "Submit",
//                                     style: TextStyle(
//                                       fontSize: shortestval * 0.05,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blueGrey,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   elevation: 10,
//                                   shadowColor: Colors.black45,
//                                   textStyle: TextStyle(letterSpacing: 1.5),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//                     : Center(child: CircularProgressIndicator()), // Fallback if animations aren't ready
//               ),
//             );
//           } else if (orientation == Orientation.landscape) {
//             return Container(
//               width: widthval,
//               height: heightval,
//               child: Center(child: Text("Landscape mode coming soon!")),
//             );
//           } else {
//             return Circular_pro_indicator_Yellow(context);
//           }
//         },
//       ),
//     );
//   }
// }
