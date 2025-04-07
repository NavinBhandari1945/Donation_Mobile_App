import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hand_in_need/models/mobile/PostInfoModel.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../../constant/styles.dart';

class QrCodeScreenPost_p extends StatefulWidget {
  final PostInfoModel post;
  const QrCodeScreenPost_p({super.key, required this.post});

  @override
  State<QrCodeScreenPost_p> createState() => _QrCodeScreenPost_pState();
}

class _QrCodeScreenPost_pState extends State<QrCodeScreenPost_p> with SingleTickerProviderStateMixin {
  late String Post_Info_Qr;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> qrData = {
      "postId": widget.post.postId.toString(),
      "signature": "hand_in_need_post_qr",
      "secretKey": "1945"
    };
    Post_Info_Qr = jsonEncode(qrData);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var shortestval = MediaQuery.of(context).size.shortestSide;
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QR Code for Post",
          style: TextStyle(
            fontFamily: bold,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        shadowColor: Colors.black45,
        automaticallyImplyLeading: true,
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
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: orientation == Orientation.portrait
                  ? _buildPortraitLayout(context, shortestval, widthval, heightval)
                  : _buildLandscapeLayout(context, shortestval, widthval, heightval),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, double shortestval, double widthval, double heightval) {
    return Center(
      child: _fadeAnimation != null
          ? FadeTransition(
        opacity: _fadeAnimation!,
        child: Container(
          width: widthval * 0.9,
          padding: EdgeInsets.all(shortestval * 0.05),
          margin: EdgeInsets.symmetric(vertical: shortestval * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PrettyQr(
                data: Post_Info_Qr,
                size: shortestval * 0.8,
                errorCorrectLevel: QrErrorCorrectLevel.H,
                roundEdges: true, // Added for smoother QR appearance
              ),
              SizedBox(height: heightval * 0.02),
              Text(
                "Note: Take screenshot of QR for scanning later on.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: semibold,
                  fontSize: shortestval * 0.06,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, double shortestval, double widthval, double heightval) {
    return Center(
      child: _fadeAnimation != null
          ? FadeTransition(
        opacity: _fadeAnimation!,
        child: Container(
          width: widthval * 0.7,
          height: heightval * 0.8,
          padding: EdgeInsets.all(shortestval * 0.05),
          margin: EdgeInsets.symmetric(horizontal: shortestval * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: PrettyQr(
                  data: Post_Info_Qr,
                  size: shortestval * 0.8,
                  errorCorrectLevel: QrErrorCorrectLevel.H,
                  roundEdges: true, // Added for smoother QR appearance
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: shortestval * 0.02),
                  child: Text(
                    "Note: Take screenshot of QR for scanning later on.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: semibold,
                      fontSize: shortestval * 0.05,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:hand_in_need/models/mobile/PostInfoModel.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';
//
// import '../../constant/styles.dart';
//
// class QrCodeScreenPost_p extends StatefulWidget {
//   final PostInfoModel post;
//   const QrCodeScreenPost_p({super.key,required this.post});
//
//   @override
//   State<QrCodeScreenPost_p> createState() => _QrCodeScreenPost_pState();
// }
//
// class _QrCodeScreenPost_pState extends State<QrCodeScreenPost_p>
// {
//   late String Post_Info_Qr;
//   @override
//   void initState() {
//     super.initState();
//     Map<String, dynamic> qrData = {
//       "postId": widget.post.postId.toString(),
//       "signature": "hand_in_need_post_qr",
//       "secretKey": "1945"
//     };
//     Post_Info_Qr =jsonEncode(qrData);
//   }
//   @override
//   Widget build(BuildContext context)
//   {
//     var shortestval = MediaQuery.of(context).size.shortestSide;
//     var widthval = MediaQuery.of(context).size.width;
//     var heightval = MediaQuery.of(context).size.height;
//     return Scaffold
//       (
//       appBar: AppBar(
//         title: Text("Qr screen of post."),
//         backgroundColor: Colors.green,
//         automaticallyImplyLeading: true,
//       ),
//
//       body: Center
//         (
//         child: Center(
//     child: Container(
//     padding: EdgeInsets.all(shortestval * 0.05), // Padding for better visual effect
//     child:
//     Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         PrettyQr(
//         data: Post_Info_Qr,  // Pass the JSON string as QR data
//         size: shortestval * 0.8,  // Size of the QR code
//         errorCorrectLevel: QrErrorCorrectLevel.H,  // Highest error correction level
//         ),
//
//         SizedBox(height:heightval*0.02,),
//
//         Text("Note:Take screenshot of qr for scanning later on.",style: TextStyle(fontFamily: semibold,fontSize: shortestval*0.06)),
//
//       ],
//     ),
//     ),
//     ),
//     )
//     );
//   }
//
//
// }
//
