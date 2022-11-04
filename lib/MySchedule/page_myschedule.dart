


import 'dart:convert';

import 'package:abzeno/Attendance/page_attendance.dart';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Profile/page_attendancehistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;


class MySchedule extends StatefulWidget{
  final String getKaryawanNo;
  const MySchedule(this.getKaryawanNo);
  @override
  _MySchedule createState() => _MySchedule();
}


class _MySchedule extends State<MySchedule> {
  late CalendarController _controller;
  late Map<DateTime, List<dynamic>> _events;
  late List<dynamic> _selectedEvents;
  late List<dynamic> _getEvents = [];
  late TextEditingController _eventController;
  late SharedPreferences prefs;
  List<dynamic> getSchedulemeaa = [];
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    prefsData();
  }
  List timeOffTypeList = [];
  String getType = "...";
  Future getScheduleNew() async {
    var response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getScheduleNew&karyawan_no=" +
            widget.getKaryawanNo));
    var jsonData = json.decode(response.body);
    setState(() {
      timeOffTypeList = jsonData;
      timeOffTypeList.map((item) {
        setState(() {
          DateTime dt = DateTime.parse(item['attend_date'].toString());
          if(item['attend_description'].toString() == '') {
            _events[dt] = [
                 "Daily Attendance \n"+
                 "Clock In : "+item['attend_checkin'].toString()+" | Clock Out : "+item['attend_checkout'].toString()+"\n\n"+""
                     "Attendance Location \n"+""
                     "Clock In : "+item['attend_clockin_location'].toString()+"\n"+""
                     "Clock Out : "+item['attend_clockout_location'].toString()
            ];
          } else {
            if(item['setttimeoff_name'].toString() == 'null') {
              if(item['reqattend_description'].toString() == 'null') {
                _events[dt] = [
                  "- \n",item['attend_description'].toString()
                ];
              } else {
                _events[dt] = [
                  item['reqattend_description'].toString()+ " \n"+item['attend_description'].toString()
                ];
              }

            } else {
              _events[dt] = [
                item['setttimeoff_name'].toString() + " \n"+item['attend_description'].toString(),
              ];
            }
          }
          //prefs.setString("events", json.encode(encodeMap(_events)));
        });
      }).toList();
    });

  }



  prefsData() async {
    //prefs = await SharedPreferences.getInstance();
    //prefs.setString("events", '');
    EasyLoading.show(status: "Loading...");
    await getScheduleNew();
    EasyLoading.dismiss();
   /* setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });*/
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }
  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }





  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#3a5664"),
        title: Text("My Attendance", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
        elevation: 0,
        leading: Builder(
          builder: (context) =>
              IconButton(
                  icon: new FaIcon(FontAwesomeIcons.arrowLeft, size: 17,),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: true,
                  todayColor: Colors.orange,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events,holidays) {
                setState(() {
                  _selectedEvents = events;
                });
              },
              builders: CalendarBuilders(
                singleMarkerBuilder: (context, date, event) {
                  return Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                    width: 7.0,
                    height: 13,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  );
                },
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              calendarController: _controller,
            ),
            Padding(padding: EdgeInsets.only(left: 25,right: 25,bottom: 15),child: Divider(height: 5,),),
            ..._selectedEvents.map((event) => Padding(
              padding: const EdgeInsets.only(left: 25,top: 5),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                       Align(alignment: Alignment.centerLeft,
                       child:      Text(event,
                           style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold,fontSize: 14))),


                  ],
                ),
              ),
            )),

          ],
        ),
      ),
    bottomSheet: Container(
    padding: EdgeInsets.only(left: 35, right: 35, bottom: 10),
      width: double.infinity,
      height: 55,
      child:
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            //primary: HexColor(AppHelper().main_color),
            elevation: 0,
            shape: RoundedRectangleBorder(side: BorderSide(
                color: Colors.white,
                width: 0.1,
                style: BorderStyle.solid
            ),
              borderRadius: BorderRadius.circular(5.0),
            )),
        child: Text("See Full List",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
            fontSize: 14)),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            Navigator.push(context, ExitPage(page: AttendanceHistory(widget.getKaryawanNo)));
          });

        },
      )),
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