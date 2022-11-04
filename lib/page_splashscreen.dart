





import 'dart:async';

import 'package:abzeno/page_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'Helper/page_route.dart';

class PageSplashScreen extends StatefulWidget {

  @override
  _PageSplashScreen createState() => _PageSplashScreen();
}



class _PageSplashScreen extends State<PageSplashScreen> {


  Future<bool> onWillPop() async {
    try {
      Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  String versionVal = '...';
  String codeVal = '...';
  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      String version = packageInfo.version;
      String code = packageInfo.buildNumber;
      versionVal = version;
      codeVal = code;
    });
  }

  void initState() {
    super.initState();
    getVersion();
    Timer(Duration(seconds: 4), () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                PageCheck()
            )
        )
    );

  }

  @override
  Widget build(BuildContext context) {
      return WillPopScope(child: Scaffold(
        body: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/LOGO2.png",width: 350,
                ),
              ],
            )
        ),
        bottomSheet: Container(
          height: 40,
          color: Colors.white,
          width: double.infinity,
          child: Text("Version "+versionVal+ " build "+codeVal,textAlign: TextAlign.center, style: GoogleFonts.workSans(fontSize: 13)),
        )
      ), onWillPop: onWillPop);
  }
}