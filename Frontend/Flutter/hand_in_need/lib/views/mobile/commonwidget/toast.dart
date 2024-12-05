import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Toastget{
  Future Toastmsg(String message) async{
   await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 20.0
    );
  }
}