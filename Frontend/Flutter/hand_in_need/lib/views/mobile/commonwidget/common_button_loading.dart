import 'package:flutter/material.dart';
import 'package:hand_in_need/views/constant/styles.dart';

import 'circularprogressind.dart';

class CommonButton_loading extends StatelessWidget {
  final String label; // The text on the button
  final VoidCallback onPressed; // Callback for button press
  final Color? color; // Background color of the button
  final TextStyle? textStyle; // Style for the button text
  final EdgeInsetsGeometry? padding; // Padding inside the button
  final double? borderRadius; // Radius for rounded corners
  final double? width; // Button width
  final double? height; // Button height
  final bool isLoading; // Show a loading spinner instead of text

  const CommonButton_loading({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color,
    required this.textStyle,
    required this.padding,
    required this.borderRadius,
    required this.width,
    required this.height,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    var shortestval=MediaQuery.of(context).size.shortestSide;
    return
      SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          padding: padding ?? const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          ),
        ),
        onPressed:onPressed,
        child: isLoading
            ? Circularproindicator(context)
            : 
        FittedBox(
          child: 
          Text(
            label,
            style: textStyle ??
                TextStyle(
                  color: Colors.black,
                  fontSize:shortestval*0.06,
                  fontFamily: bold
                ),
          ),
        ),
      ),
    );
  }
}
