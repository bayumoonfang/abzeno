



import 'dart:async';
import 'dart:convert';
import 'dart:ui';


import 'package:abzeno/ApprovalList/page_approvallist.dart';
import 'package:abzeno/Notification/page_notification.dart';
import 'package:abzeno/Profile/page_profile.dart';
import 'package:abzeno/attendance/page_doattendance.dart';
import 'package:abzeno/page_changecabang.dart';
import 'package:abzeno/page_home2.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Time Off/page_timeoffhome.dart';
import 'helper/app_helper.dart';
import 'helper/app_link.dart';
import 'helper/page_route.dart';
import 'attendance/page_attendance.dart';
import 'page_login.dart';





class Home extends StatefulWidget{

  @override
  _Home createState() => _Home();
}


class _Home extends State<Home> with SingleTickerProviderStateMixin {
  int _selectedPage = 0;
  String getNotifCountme = "0";
  late List data;


  String getKaryawanNama = "...";
  String getKaryawanJabatan = "...";
  String getKaryawanNo = "...";
  String getScheduleName = "...";
  String getStartTime = "...";
  String getEndTime = "...";
  String getPIN = "...";
  String getEmail = "...";
  String getScheduleID = "...";
  String getScheduleBtn = "...";


  String getJamMasukSebelum = "...";
  String getJamKeluarSebelum = "...";

  getNotif() async {
    await AppHelper().getNotifCount().then((value){
      setState(() {
        getNotifCountme = value[0];
      });});
  }


  _startingVariable() async {
    EasyLoading.show(status: "Loading...");
    await AppHelper().getSession().then((value){
      setState(() {
        getKaryawanNama = value[3];
        getKaryawanJabatan = value[5];
        getKaryawanNo = value[4];
        getEmail = value[0];
        getScheduleName = value[6];
        getStartTime = value[7];
        getEndTime = value[8];
        getScheduleID = value[15];
        getJamMasukSebelum = value[16];
        getJamKeluarSebelum = value[17];
        getPIN = value[18];
        getScheduleBtn = value[19];
      });});

    await getNotif();
  }



  loadData2() async {
    await _startingVariable();
    EasyLoading.dismiss();
  }

  Timer? timer;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    setState(() {
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) => (){
        setState(() {
          getNotif();
        });
      });
    });
    loadData2();
  }

  late TabController _tabController;
  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            //kemudian panggil halaman sesuai tab yang sudah dibuat
            Home2(getKaryawanNama, getKaryawanJabatan, getKaryawanNo,
                getScheduleName,
              getStartTime,
              getEndTime,
              getScheduleID,
              getJamMasukSebelum,
              getJamKeluarSebelum,getPIN,getScheduleBtn),
            PageApprovalList(getKaryawanNo, getKaryawanNama),
            PageNotification(getEmail),
            Profile(getKaryawanNama, getKaryawanJabatan, getKaryawanNo)
            //PageMyApproval(widget.getKaryawanNo, widget.getKaryawanNama),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type : BottomNavigationBarType.fixed,
          selectedItemColor: HexColor(AppHelper().main_color),
          selectedLabelStyle: TextStyle(color:  HexColor(AppHelper().main_color)),

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.fileSignature),
              label: 'Approval',
            ),
            BottomNavigationBarItem(
              icon:
    getNotifCountme != "0" ?
              Badge(
                showBadge: true,
                //badgeContent: Text(getNotifCountme.toString(), style: const TextStyle(color: Colors.white)),
                animationType:  BadgeAnimationType.scale,
                shape: BadgeShape.circle,
                position: BadgePosition.topEnd(top: 0,end: -1),
                child: const FaIcon(FontAwesomeIcons.calendar),
              ) :
              FaIcon(FontAwesomeIcons.calendar),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              label: 'Profile',
            ),
          ],
            currentIndex: _currentIndex,
            onTap: (currentIndex){
              setState(() {
                _currentIndex = currentIndex;
              });
              _tabController.animateTo(_currentIndex);

            },)
      );
  }

  Future<bool> onWillPop() async {
    try {
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

