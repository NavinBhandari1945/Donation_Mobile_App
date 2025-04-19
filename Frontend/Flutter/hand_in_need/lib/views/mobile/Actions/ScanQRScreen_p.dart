import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_in_need/views/mobile/Actions/QR_Scan_Post_Screen_p.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:hand_in_need/views/mobile/home/login_home_p.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'action_screen_p.dart';
import 'getx_cont_actions/IsNavigating_Qr_Post_Screen_cont_getx.dart';
import 'getx_cont_actions/scanned_data_getx_qr_post.dart';

class QrScannerScreen_P extends StatefulWidget {
  final String username;
  final String usertype;
  final String jwttoken;
  const QrScannerScreen_P({super.key, required this.username, required this.usertype, required this.jwttoken});

  @override
  State<QrScannerScreen_P> createState() => _QrScannerScreen_PState();
}

class _QrScannerScreen_PState extends State<QrScannerScreen_P> with SingleTickerProviderStateMixin {
  final Is_Navigating_getx_cont = Get.put(Is_Navigating_getx()); // By default false
  final scannedData = Get.put(Qr_scanned_post_actions_screen()); // By default false
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
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onScan(String scannedData) {
    if (Is_Navigating_getx_cont.Is_Navigating.value) {
      return;
    }
    try {
      print("Navigating to qr scan post screen.");
      Map<String, dynamic> qrData = jsonDecode(scannedData);
      if (qrData["signature"] == "hand_in_need_post_qr" && qrData["secretKey"] == "1945") {
        int postId = int.parse(qrData["postId"]);
        if (!Is_Navigating_getx_cont.Is_Navigating.value) {
          Is_Navigating_getx_cont.change_Is_Navigating(true);
          print("Valid QR Code Detected.");
          print("Scanned Post ID: $postId");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QrScanPostScreen(
                postId: postId,
                JWT_Token: widget.jwttoken,
                username: widget.username,
                usertype: widget.usertype,
              ),
            ),
          ).then((_) {
            Is_Navigating_getx_cont.change_Is_Navigating(false);
          });
        }
      }
    } catch (e) {
      print("Error while scanning: $e");
      if (!Is_Navigating_getx_cont.Is_Navigating.value) {
        Is_Navigating_getx_cont.change_Is_Navigating(true);
        Toastget().Toastmsg("Invalid QR code");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ActionScreen_P(
              username: widget.username,
              jwttoken: widget.jwttoken,
              usertype: widget.usertype,
            ),
          ),
        ).then((_) {
          Is_Navigating_getx_cont.change_Is_Navigating(false);
        });
      }
    }
  }

  Future<void> pickAndScanImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/qr_temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await File(pickedFile.path).copy(tempFile.path);
        String? qrCodeValue = await QrCodeToolsPlugin.decodeFrom(tempFile.path);

        if (qrCodeValue != null && qrCodeValue.isNotEmpty) {
          scannedData.change_scanned_data(qrCodeValue);
          print("Scanned QR Code from image: $qrCodeValue");
          onScan(qrCodeValue);
        } else {
          scannedData.change_scanned_data("No QR code detected in the image.");
          Toastget().Toastmsg("No QR code detected in the image.");
        }

        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      } else {
        scannedData.change_scanned_data("No image selected.");
        Toastget().Toastmsg("No image selected");
      }
    } catch (e) {
      print("Error while picking image or scanning QR: $e");
      scannedData.change_scanned_data("Error scanning QR code.");
      Toastget().Toastmsg("Error scanning QR code.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    var shortestval = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: Container(
        width: widthval,
        height: heightval,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.grey[200]!],
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
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.all(shortestval * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildScanner(shortestval, widthval, heightval),
                SizedBox(height: shortestval * 0.05),
                _buildInstructionText(shortestval),
                SizedBox(height: shortestval * 0.05),
                _buildPickImageButton(shortestval),
                // SizedBox(height: shortestval * 0.05),
                // _buildScannedDataText(shortestval),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(double shortestval, double widthval, double heightval) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(shortestval * 0.04),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.all(shortestval * 0.04),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildScanner(shortestval, widthval, heightval),
                ),
                SizedBox(width: shortestval * 0.04),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInstructionText(shortestval),
                      SizedBox(height: shortestval * 0.05),
                      _buildPickImageButton(shortestval),
                      // SizedBox(height: shortestval * 0.05),
                      // _buildScannedDataText(shortestval),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanner(double shortestval, double widthval, double heightval) {
    return Container(
      width: shortestval * 0.8,
      height: shortestval * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green[700]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: MobileScanner(
          onDetect: (barcodeCapture) {
            if (Is_Navigating_getx_cont.Is_Navigating.value) {
              return;
            }
            print("scan scanning.");
            final String scannedData = barcodeCapture.barcodes[0].rawValue ?? "";
            if (scannedData.isNotEmpty)
            {
              print("scan sccess.");
              onScan(scannedData);
            }
          },
          onDetectError: (error, stackTrace) {
            if (Is_Navigating_getx_cont.Is_Navigating.value) {
              return;
            }
            print("Error during scanning: $error");
            Toastget().Toastmsg("Scanning error: $error");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Login_HomeScreen(
                    username: widget.username,
                    usertype: widget.usertype,
                    jwttoken: widget.jwttoken)
              ),
            ).then((_) {
              Is_Navigating_getx_cont.change_Is_Navigating(false);
            });
          },
        ),
      ),
    );
  }

  Widget _buildInstructionText(double shortestval) {
    return Text(
      "Scan a QR Code",
      style: TextStyle(
        fontSize: shortestval * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPickImageButton(double shortestval) {
    return ElevatedButton(
      onPressed: pickAndScanImage,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[600],
        padding: EdgeInsets.symmetric(horizontal: shortestval * 0.06, vertical: shortestval * 0.03),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      child: Text(
        "Pick Image and Scan QR",
        style: TextStyle(
          fontSize: shortestval * 0.045,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget _buildScannedDataText(double shortestval) {
  //   return Obx(
  //         () => Text(
  //       scannedData.scanned_data.value,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         fontSize: shortestval * 0.04,
  //         color: Colors.grey[700],
  //         fontStyle: scannedData.scanned_data.value.contains("Error") || scannedData.scanned_data.value.contains("No") ? FontStyle.italic : FontStyle.normal,
  //       ),
  //     ),
  //   );
  // }


}





// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hand_in_need/views/mobile/Actions/QR_Scan_Post_Screen_p.dart';
// import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:qr_code_tools/qr_code_tools.dart';
// import 'action_screen_p.dart';
// import 'getx_cont_actions/IsNavigating_Qr_Post_Screen_cont_getx.dart';
// import 'getx_cont_actions/scanned_data_getx_qr_post.dart';
//
//
//
// class QrScannerScreen_P extends StatefulWidget
// {
//   final String username;
//   final String usertype;
//   final String jwttoken;
//   const QrScannerScreen_P({super.key,required this.username,required this.usertype,
//     required this.jwttoken});
//   @override
//   State<QrScannerScreen_P> createState() => _QrScannerScreen_PState();
// }
//
// class _QrScannerScreen_PState extends State<QrScannerScreen_P>
// {
//   final Is_Navigating_getx_cont = Get.put(Is_Navigating_getx()); // By default false
//
//   final scannedData = Get.put(Qr_scanned_post_actions_screen()); // By default false
//
//   void onScan(String scannedData)
//   {
//     // If navigation is happening, return early to prevent further scanning
//     if (Is_Navigating_getx_cont.Is_Navigating.value) {
//       return;
//     }
//
//     try {
//       // Decode JSON string from QR
//       Map<String, dynamic> qrData = jsonDecode(scannedData);
//
//       // Validate signature and secret key
//       if (qrData["signature"] == "hand_in_need_post_qr" && qrData["secretKey"] == "1945")
//       {
//
//         int postId = int.parse(qrData["postId"]);
//
//         // Navigate if valid
//         if (!Is_Navigating_getx_cont.Is_Navigating.value) {
//           // Set the navigating flag to true
//           Is_Navigating_getx_cont.change_Is_Navigating(true);
//
//           print("Valid QR Code Detected.");
//           print("Scanned Post ID: $postId");
//
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => QrScanPostScreen(postId: postId,JWT_Token: widget.jwttoken, username:widget.username ,usertype:widget.usertype ,),
//             ),
//           ).then((_) {
//             // Reset the flag after navigation is complete
//             Is_Navigating_getx_cont.change_Is_Navigating(false);
//           });
//         }
//       }
//     } catch (e)
//     {
//       // Handle invalid QR code or any exception that occurs during the process
//       print("Error while scanning: $e");
//
//       // Prevent further scans during navigation
//       if (!Is_Navigating_getx_cont.Is_Navigating.value)
//       {
//         Is_Navigating_getx_cont.change_Is_Navigating(true);
//
//         // Show Toast message for invalid QR
//         Toastget().Toastmsg("Invalid QR code");
//
//         // Navigate to ActionScreen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ActionScreen_P(
//               username: widget.username,
//               jwttoken: widget.jwttoken,
//               usertype: widget.usertype,
//             ),
//           ),
//         ).then((_)
//         {
//           // Reset the flag after navigation is complete
//           Is_Navigating_getx_cont.change_Is_Navigating(false);
//         }
//         );
//
//       }
//     }
//   }
//
//   Future<void> pickAndScanImage() async {
//     try {
//       final pickedFile =
//       await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         final tempDir = await getTemporaryDirectory();
//         final tempFile = File(
//             '${tempDir.path}/qr_temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
//         await File(pickedFile.path).copy(tempFile.path);
//
//         // Decode QR code using qr_code_tools 0.1.0
//         String? qrCodeValue = await QrCodeToolsPlugin.decodeFrom(tempFile.path);
//
//         if (qrCodeValue != null && qrCodeValue.isNotEmpty) {
//
//           scannedData.change_scanned_data(qrCodeValue);
//           // setState(() {
//           //   scannedData = qrCodeValue;
//           // }
//           // );
//           print("Scanned QR Code from image: $qrCodeValue");
//           onScan(qrCodeValue);
//         } else {
//           scannedData.change_scanned_data("No QR code detected in the image.");
//           // setState(() {
//           //   scannedData = "No QR code detected in the image.";
//           // });
//           Toastget().Toastmsg("No QR code detected in the image.");
//         }
//
//         if (await tempFile.exists()) {
//           await tempFile.delete();
//         }
//       }
//       else
//       {
//         scannedData.change_scanned_data("No image selected.");
//         Toastget().Toastmsg("No image selected");
//         // setState(() {
//         //   scannedData = "No image selected.";
//         // });
//       }
//     } catch (e) {
//       print("Error while picking image or scanning QR: $e");
//       scannedData.change_scanned_data( "Error scanning QR code.");
//       // setState(() {
//       //   scannedData = "Error scanning QR code.";
//       // });
//       Toastget().Toastmsg("Error scanning QR code.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var widthval=MediaQuery.of(context).size.width;
//     var heightval=MediaQuery.of(context).size.height;
//     var shortestval=MediaQuery.of(context).size.shortestSide;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Scan QR Code"),
//         backgroundColor: Colors.green,
//       ),
//       body:
//       Container(
//         height:heightval ,
//         width: widthval,
//         color: Colors.grey,
//         child:
//         Center(
//           child:
//           Container(
//             height: heightval*0.60,
//             width: widthval,
//             color: Colors.brown,
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               scrollDirection: Axis.vertical,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   // QR code scanner
//                   Container(
//                     width: widthval*0.70,
//                     height: heightval*0.40,
//                     color: Colors.blueGrey,
//                     child:
//
//                     MobileScanner(
//                       onDetect: (barcodeCapture)
//                       {
//                         // Prevent further scans if navigation is in progress
//                         if (Is_Navigating_getx_cont.Is_Navigating.value)
//                         {
//                           return;
//                         }
//
//                         final String scannedData = barcodeCapture.barcodes[0].rawValue ?? "";
//                         if (scannedData.isNotEmpty)
//                         {
//                           onScan(scannedData);
//                         }
//                       },
//                       onDetectError: (error, stackTrace)
//                       {
//                         // Handle any errors detected by the scanner
//                         if (Is_Navigating_getx_cont.Is_Navigating.value)
//                         {
//                           return; // Skip handling if navigation is in progress
//                         }
//                         // Optionally, you can log the error for debugging
//                         print("Error during scanning: $error");
//                         // You can show a toast or message here to inform the user
//                         Toastget().Toastmsg("Scanning error: $error");
//                       },
//                     ),
//
//                   ),
//                   SizedBox(height: 20),
//                   // Display the scanned post ID (or use it to fetch details)
//                   Text("Scan a QR Code", style: TextStyle(fontSize: 18),
//                   ),
//
//                   SizedBox(height: 20),
//
//                   ElevatedButton(
//                     onPressed: pickAndScanImage,
//                     child: Text("Pick Image and Scan QR"),
//                   ),
//
//                   SizedBox(height: 20),
//
//                   Text(scannedData.scanned_data.value,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16),
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
