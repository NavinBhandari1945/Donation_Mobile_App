import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart'; // Added for .box syntax

Widget Commonbutton(String title, VoidCallback onpressFn, BuildContext context, Color buttonColor) {
  var shortestval = MediaQuery.of(context).size.shortestSide;

  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      padding: EdgeInsets.symmetric(
        vertical: shortestval * 0.03,
        horizontal: shortestval * 0.08,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(shortestval * 0.03),
      ),
      elevation: 5, // Added elevation for a 3D effect
    ),
    onPressed: onpressFn,
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white, // Changed to white for better contrast
        fontSize: shortestval * 0.04,
        fontWeight: FontWeight.bold, // Added bold for emphasis
      ),
    ),
  ).box.width(MediaQuery.of(context).size.width * 0.5).make(); // Set width to 50% of screen width
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// Widget Commonbutton(String tittle,onpress_fn,BuildContext context,buttoncolor){
//   var shortestval=MediaQuery.of(context).size.shortestSide;
//   return
//     ElevatedButton(
//       style:ElevatedButton.styleFrom(
//         backgroundColor: buttoncolor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(shortestval*0.03)
//         )
//       ),
//       onPressed:onpress_fn,
//       child:
//       Text("${tittle}",style: TextStyle(
//         color: Colors.black,
//         fontSize:shortestval*0.04,
//       ),
//       textAlign:TextAlign.center,
//       )
//   );
// }
