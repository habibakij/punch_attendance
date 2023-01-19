
import 'dart:async';
import 'package:attendance/common/style_management.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../transition/enum.dart';
import '../transition/page_transition.dart';
import 'home_screen.dart';

class SplashScreenState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), ()=> Navigator.of(context, rootNavigator: true).pushReplacement(PageTransition(child: const HomeScreen(), type: PageTransitionType.rightToLeft)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DelayedDisplay(
        delay: const Duration(seconds: 1),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.blue,
          child: const Center(
            child: Text("Attendance", style: StyleManagement.bigWhiteTextStyle),
          ),
        ),
      ),

    );
  }

}
