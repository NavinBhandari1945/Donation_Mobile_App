import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constant/styles.dart';

Widget CommonTextField_obs_false_p(
    String? title,
    String hintText,
    bool obscureVal,
    TextEditingController controllerVal,
    BuildContext context, {
      InputDecoration? decoration,
    }) {
  var shortestVal = MediaQuery.of(context).size.shortestSide;
  var widthVal = MediaQuery.of(context).size.width;
  bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

  // Default decoration
  final defaultDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      vertical: shortestVal * 0.03,
      horizontal: shortestVal * 0.03,
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.black,
      fontSize: shortestVal * 0.05, // Reduced font size for better fit
      fontFamily: semibold,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: CupertinoColors.black,
        width: shortestVal * 0.006,
      ),
      borderRadius: BorderRadius.circular(shortestVal * 0.04),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(shortestVal * 0.04),
      borderSide: BorderSide(
        color: CupertinoColors.black,
        width: shortestVal * 0.006,
      ),
    ),
  );

  final finalDecoration = decoration != null
      ? defaultDecoration.copyWith(
    prefixIcon: decoration.prefixIcon,
    filled: decoration.filled,
    fillColor: decoration.fillColor,
    border: decoration.border,
    hintStyle: decoration.hintStyle ?? defaultDecoration.hintStyle,
  )
      : defaultDecoration;

  return Container(
    width: isLandscape ? widthVal * 0.5 : widthVal * 0.9, // Adjusted width for landscape
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title!.text
            .color(CupertinoColors.black)
            .fontFamily(bold)
            .size(isLandscape ? 20 : 25) // Adjusted size for landscape
            .make(),
        SizedBox(height: shortestVal * 0.02),
        TextFormField(
          controller: controllerVal,
          obscureText: obscureVal,
          keyboardType: TextInputType.number, // Changed to number for amount input
          style: TextStyle(fontSize: shortestVal * 0.05),
          decoration: finalDecoration,
        ),
      ],
    ),
  );
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../constant/styles.dart';
//
// Widget CommonTextField_obs_false_p(String? title, String hintText, bool obscureVal, TextEditingController controllerVal, BuildContext context) {
//   var heightVal = MediaQuery.of(context).size.height;
//   var shortestVal = MediaQuery.of(context).size.shortestSide;
//   return Container(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         title!.text.color(CupertinoColors.black).fontFamily(bold).size(25).make(),
//         SizedBox(height:shortestVal*0.02,),
//         Container(
//           height: heightVal * 0.10, // Adjust as needed for larger input area
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical, // Enables vertical scrolling
//             child: TextFormField(
//               maxLines: null, // Allows unlimited lines
//               keyboardType: TextInputType.multiline,
//               controller: controllerVal,
//               obscureText: obscureVal,
//               style: TextStyle(fontSize: shortestVal * 0.07),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: shortestVal * 0.03,
//                   horizontal: shortestVal * 0.03,
//                 ),
//                 hintText: hintText,
//                 hintStyle: TextStyle(
//                   color: Colors.black,
//                   fontSize: shortestVal * 0.07,
//                   fontFamily: semibold,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: CupertinoColors.black,
//                     width: shortestVal * 0.006,
//                   ),
//                   borderRadius: BorderRadius.circular(shortestVal * 0.04),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(shortestVal * 0.04),
//                   borderSide: BorderSide(
//                     color: CupertinoColors.black,
//                     width: shortestVal * 0.006,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }
