import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Toastget_Long_Period{
  Future Toastmsg(String message) async{
    await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 20,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 20.0
    );
  }
}