import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget Circular_pro_indicator_Yellow(BuildContext context){
  var sizeval=MediaQuery.of(context).size.shortestSide;
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(sizeval*0.05),
    ),
    child:Center(
      child:CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Colors.yellowAccent,
        ),
      )
    ),

  );
}