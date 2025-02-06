import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hand_in_need/models/mobile/PostInfoModel.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../constant/styles.dart';

class QrCodeScreenPost_p extends StatefulWidget {
  final PostInfoModel post;
  const QrCodeScreenPost_p({super.key,required this.post});

  @override
  State<QrCodeScreenPost_p> createState() => _QrCodeScreenPost_pState();
}

class _QrCodeScreenPost_pState extends State<QrCodeScreenPost_p>
{
  late String Post_Info_Qr;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> qrData = {
      "postId": widget.post.postId.toString(),
      "signature": "hand_in_need_post_qr",
      "secretKey": "1945"
    };
    Post_Info_Qr =jsonEncode(qrData);
  }
  @override
  Widget build(BuildContext context)
  {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;
    return Scaffold
      (
      appBar: AppBar(
        title: Text("Qr screen of post."),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),

      body: Center
        (
        child: Center(
    child: Container(
    padding: EdgeInsets.all(shortestval * 0.05), // Padding for better visual effect
    child:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PrettyQr(
        data: Post_Info_Qr,  // Pass the JSON string as QR data
        size: shortestval * 0.8,  // Size of the QR code
        errorCorrectLevel: QrErrorCorrectLevel.H,  // Highest error correction level
        ),

        SizedBox(height:heightval*0.02,),

        Text("Note:Take screenshot of qr for scanning later on.",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.06)),

      ],
    ),
    ),
    ),
    )
    );
  }


}
