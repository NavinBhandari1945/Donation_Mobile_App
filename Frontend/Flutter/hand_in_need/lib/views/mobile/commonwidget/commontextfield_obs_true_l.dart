import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constant/styles.dart';

Widget CommonTextField_obs_val_true_l(String? title, String hintText, TextEditingController controllerVal, BuildContext context) {
  var heightVal = MediaQuery.of(context).size.height;
  var shortestVal = MediaQuery.of(context).size.shortestSide;
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title!.text.color(CupertinoColors.black).fontFamily(bold).size(25).make(),
        SizedBox(height:shortestVal*0.02,),
        Container(
          height:heightVal * 0.20, // Adjust as needed for larger input area
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, // Enables vertical scrolling
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: controllerVal,
              obscureText: true,
              style: TextStyle(fontSize: shortestVal * 0.07),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: shortestVal * 0.03,
                  horizontal: shortestVal * 0.03,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: shortestVal * 0.07,
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
              ),
            ),
          ),
        )
      ],
    ),
  );
}
