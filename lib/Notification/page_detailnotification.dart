

import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
class PageDetailNotification extends StatefulWidget{
  final String getTittle;
  final String getMessage;
  final String getDate;
  final String getMessageID;
  const PageDetailNotification(this.getTittle, this.getMessage, this.getDate, this.getMessageID);
  @override
  _PageDetailNotification createState() => _PageDetailNotification();
}


class _PageDetailNotification extends State<PageDetailNotification> {


  _read_notif() async {
    EasyLoading.show(status: "Loading...");
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=read_notif"),
        body: {
          "message_id": widget.getMessageID,
        }).timeout(Duration(seconds: 20), onTimeout: () {
      http.Client().close();
      AppHelper().showFlushBarerror(
          context, "Koneksi Terputus, silahkan ulangi sekali lagi");
      EasyLoading.dismiss();
      return http.Response('Error', 500);
    });
  }

  loadData2() async {
    await _read_notif();
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    loadData2();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#3a5664"),
        title: Text("Detail Activity", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 25,right: 25,top: 20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(widget.getTittle, style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold),),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(widget.getDate, style: GoogleFonts.workSans(fontSize: 13,color: Colors.black),),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Divider(height: 5,),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 25),
                child: Text(widget.getMessage, style: GoogleFonts.workSans(fontSize: 14,color: Colors.black),),
              ),
            )
          ],
        ),
      ),

    ), onWillPop: onWillPop);
  }

  Future<bool> onWillPop() async {
    try {
      Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

}