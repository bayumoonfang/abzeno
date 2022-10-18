



import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Request%20Attendance/page_reqattendance.dart';
import 'package:abzeno/Time%20Off/page_myapproval.dart';
import 'package:abzeno/page_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';



class PageReqAttendanceHome extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  const PageReqAttendanceHome(this.getKaryawanNo, this.getKaryawanNama);
  @override
  _PageReqAttendanceHome createState() => _PageReqAttendanceHome();
}

class _PageReqAttendanceHome extends State<PageReqAttendanceHome> with SingleTickerProviderStateMixin {
  late TabController controller;

  loadData() async {
    EasyLoading.dismiss();
    //await _startingVariable();
  }

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 4);
    loadData();
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var onWillPop;
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        //shape: Border(bottom: BorderSide(color: Colors.red)),
        backgroundColor: HexColor(AppHelper().main_color),
        title: Text("Request Attendance", style: GoogleFonts.nunito(fontSize: 17),),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 17,),
              color: Colors.white,
              onPressed: ()  {
                Navigator.pop(context);

              }),
        ),
        bottom: new TabBar(
          indicatorColor: Colors.white,
          controller: controller,
          labelStyle: GoogleFonts.varelaRound(fontWeight: FontWeight.bold,fontSize: 15),
            unselectedLabelStyle: GoogleFonts.varelaRound(fontSize: 13),
            //unselectedLabelColor: Colors.white,
          tabs: <Widget>[
            new Tab(text: "My Request"),
            new Tab(text: "Need My Approval"),
          ],
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          RequestAttendance(widget.getKaryawanNo, "listq"),
          RequestAttendance(widget.getKaryawanNo, "approveq"),
          //kemudian panggil halaman sesuai tab yang sudah dibuat
          //PageMyRequest(widget.getKaryawanNo, widget.getKaryawanNama),
          //PageMyApproval(widget.getKaryawanNo, widget.getKaryawanNama),
        ],
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