import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils{

  static String PUNCHIN= "punch_in";
  static String PUNCHOUT= "punch_out";
  static String TOTALHOUR= "total_hour";
  static String NOTE= "note";
  static String INLOCATION= "in_location";
  static String INIP= "in_ip";
  static String OUTLOCATION= "out_location";
  static String OUTIP= "out_ip";

  static showToast(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 12,
    );
  }

}