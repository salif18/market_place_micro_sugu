import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugu/routes.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const MyRoots())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        return AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          duration: const Duration(seconds: 5),
          child: Container(
            padding: EdgeInsets.only(top: 12.r),
            height: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // key: UniqueKey(),
              children: [
              Image.asset(
                "assets/logos/logo.png",
                width:200.w,
                height: 200.h
              ),
              ],
            ),
          ),
        );
      }),
    );
  }
}