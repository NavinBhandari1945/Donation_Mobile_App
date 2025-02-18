import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget Commonbutton(String tittle,onpress_fn,BuildContext context,buttoncolor){
  var shortestval=MediaQuery.of(context).size.shortestSide;
  return
    ElevatedButton(
      style:ElevatedButton.styleFrom(
        backgroundColor: buttoncolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shortestval*0.03)
        )
      ),
      onPressed:onpress_fn,
      child:
      Text("${tittle}",style: TextStyle(
        color: Colors.black,
        fontSize:shortestval*0.04,
      ),
      textAlign:TextAlign.center,
      )
  );
}
