import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hand_in_need/views/mobile/Actions/QR_Scan_Post_Screen.dart';
import 'package:hand_in_need/views/mobile/commonwidget/toast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'action_screen_p.dart';
import 'getx_cont_actions/IsNavigating_Qr_Post_Screen_cont_getx.dart';

class QrScannerScreen extends StatefulWidget
{
  final String username;
  final String usertype;
  final String jwttoken;
  const QrScannerScreen({super.key,required this.username,required this.usertype,
    required this.jwttoken});
  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
{
  final Is_Navigating_getx_cont = Get.put(Is_Navigating_getx()); // By default false

  void onScan(String scannedData) {
    // If navigation is happening, return early to prevent further scanning
    if (Is_Navigating_getx_cont.Is_Navigating.value) {
      return;
    }

    try {
      // Decode JSON string from QR
      Map<String, dynamic> qrData = jsonDecode(scannedData);

      // Validate signature and secret key
      if (qrData["signature"] == "hand_in_need_post_qr" && qrData["secretKey"] == "1945")
      {

        int postId = int.parse(qrData["postId"]);

        // Navigate if valid
        if (!Is_Navigating_getx_cont.Is_Navigating.value) {
          // Set the navigating flag to true
          Is_Navigating_getx_cont.change_Is_Navigating(true);

          print("Valid QR Code Detected.");
          print("Scanned Post ID: $postId");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QrScanPostScreen(postId: postId,JWT_Token: widget.jwttoken, username:widget.username ,usertype:widget.usertype ,),
            ),
          ).then((_) {
            // Reset the flag after navigation is complete
            Is_Navigating_getx_cont.change_Is_Navigating(false);
          });
        }
      }
    } catch (e)
    {
      // Handle invalid QR code or any exception that occurs during the process
      print("Error while scanning: $e");

      // Prevent further scans during navigation
      if (!Is_Navigating_getx_cont.Is_Navigating.value)
      {
        Is_Navigating_getx_cont.change_Is_Navigating(true);

        // Show Toast message for invalid QR
        Toastget().Toastmsg("Invalid QR code");

        // Navigate to ActionScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ActionScreen(
              username: widget.username,
              jwttoken: widget.jwttoken,
              usertype: widget.usertype,
            ),
          ),
        ).then((_)
        {
          // Reset the flag after navigation is complete
          Is_Navigating_getx_cont.change_Is_Navigating(false);
        }
        );

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthval=MediaQuery.of(context).size.width;
    var heightval=MediaQuery.of(context).size.height;
    var shortestval=MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR Code"),
        backgroundColor: Colors.green,
      ),
      body:
      Container(
        height:heightval ,
        width: widthval,
        color: Colors.grey,
        child:
        Center(
          child:
          Container(
            height: heightval*0.60,
            width: widthval,
            color: Colors.brown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // QR code scanner
                Container(
                  width: widthval*0.70,
                  height: heightval*0.40,
                  color: Colors.blueGrey,
                  child:
                  MobileScanner(
                    onDetect: (barcodeCapture)
                    {
                      // Prevent further scans if navigation is in progress
                      if (Is_Navigating_getx_cont.Is_Navigating.value)
                      {
                        return;
                      }

                      final String scannedData = barcodeCapture.barcodes[0].rawValue ?? "";
                      if (scannedData.isNotEmpty)
                      {
                        onScan(scannedData);
                      }
                    },
                    onDetectError: (error, stackTrace)
                    {
                      // Handle any errors detected by the scanner
                      if (Is_Navigating_getx_cont.Is_Navigating.value)
                      {
                        return; // Skip handling if navigation is in progress
                      }
                      // Optionally, you can log the error for debugging
                      print("Error during scanning: $error");
                      // You can show a toast or message here to inform the user
                      Toastget().Toastmsg("Scanning error: $error");
                    },
                  ),

                ),
                SizedBox(height: 20),
                // Display the scanned post ID (or use it to fetch details)
                Text("Scan a QR Code", style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
