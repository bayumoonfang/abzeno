
import 'dart:convert';

import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/page_home.dart';
import 'package:abzeno/page_intoduction.dart';
import 'package:abzeno/page_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Helper/app_helper.dart';
import 'Helper/page_route.dart';

class PageCheck extends StatefulWidget{
  @override
  _PageCheck createState() => _PageCheck();
}

class _PageCheck extends State<PageCheck> {



  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      AppHelper().showFlushBarsuccess(context, "Koneksi Putus");
      return false;
    }});

    await AppHelper().getSession().then((value){
      setState(() {
        if(value[0] == '' || value[0] == null) {
          Navigator.pushReplacement(context, ExitPage(page: Introduction()));
          _gotoHome();
        } else {
          _gotoHome();
        }
      });});
    await AppHelper().reloadSession();
  }


  _gotoHome() async{
    await AppHelper().reloadSession();
    Navigator.pushReplacement(context, ExitPage(page: Home()));
  }


  loadData() async {
    await _startingVariable();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child : Visibility(
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: CircularProgressIndicator(),
                    height: 60.0,
                    width: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text("Menyiapkan Data..."),
                  )

                ],
              )
          )
      ),
    ), onWillPop: onWillPop);
  }

  bool shouldPop = true;
  Future<bool> onWillPop() async {
    //Navigator.pop(context);
    return shouldPop;
  }
}