




import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/page_home.dart';
import 'package:abzeno/page_home2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class RequestGantiShiftDetailAttend extends StatefulWidget{
  final String getKaryawanNo;
  final String getDate;
  const RequestGantiShiftDetailAttend(this.getKaryawanNo,this.getDate);
  @override
  _RequestGantiShiftDetailAttend createState() => _RequestGantiShiftDetailAttend();
}


class _RequestGantiShiftDetailAttend extends State<RequestGantiShiftDetailAttend> {
  String getNameShift = "...";
  String getClockIn = "...";
  String getClockOut = "...";
  String getClockIn2 = "...";
  String getClockOut2 = "...";
  _getScheduleDetail() async {
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getAttendanceDetail&karyawanNo=" +
            widget.getKaryawanNo+"&getDate="+widget.getDate)).timeout(
        Duration(seconds: 10), onTimeout: () {
      AppHelper().showFlushBarsuccess(context, "Koneksi terputus..");
      http.Client().close();
      return http.Response('Error', 500);
    }
    );
    Map data = jsonDecode(response.body);
    setState(() {
      EasyLoading.dismiss();
      getNameShift = data["schedule_name"].toString();
      getClockIn = data["schedule_clockin"].toString();
      getClockOut = data["schedule_clockout"].toString();
      getClockIn2 = data["clockin"].toString();
      getClockOut2 = data["clockout"].toString();
    });
  }




  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: "Waiting for Attendance Check...");
    _getScheduleDetail();

  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#3a5664"),
        title: Text("Attendance Detail", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
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
      body:
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(left: 25,right: 25),
              child:
                 Column(
                   children: [

                     Container(
                         padding: EdgeInsets.only(top:20),
                         width: double.infinity,
                         child: Column(
                           children: [

                             Text("Current Schedule",style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,
                                 color: Colors.black)),
                             Wrap(
                               // alignment: WrapAlignment.start,
                               spacing: 15,
                               children: [
                                 Container(
                                   width: 100,
                                   child:   ListTile(
                                     title: Text("Schedule",style: GoogleFonts.nunitoSans(fontSize: 12),),
                                     subtitle: Text(getNameShift.toString() == 'null' ? "OFF" :
                                     getNameShift.toString(),style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold,
                                         color: Colors.black),),
                                   ),
                                 ),
                                 Container(
                                   width: 100,
                                   child:   ListTile(
                                     title: Text("Clock In",style: GoogleFonts.nunitoSans(fontSize: 12),),
                                     subtitle: Text(getClockIn.toString() == '' ||
                                         getClockIn.toString() == '0' ? "..." : getClockIn.toString(),style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold,
                                         color: Colors.black),),
                                   ),
                                 ),

                                 Container(
                                   width: 100,
                                   child:   ListTile(
                                     title: Text("Clock Out",style: GoogleFonts.nunitoSans(fontSize: 12),),
                                     subtitle: Text(getClockOut.toString() == "" || getClockOut.toString() == "0"
                                         ? "..." : getClockOut.toString(),style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold,
                                         color: Colors.black),),
                                   ),
                                 ),
                               ],
                             ),
                           ],
                         )
                     ),


                     Padding(
                       padding: EdgeInsets.only(top: 5),
                       child: Divider(height: 2,),
                     ),

                     Container(
                         padding: EdgeInsets.only(top:15),
                         width: double.infinity,
                         child: Column(
                           children: [
                             Text("Current Attendance",style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,
                                 color: Colors.black)),
                             Wrap(
                               // alignment: WrapAlignment.start,
                               spacing: 15,
                               children: [

                                 Container(
                                   width: 100,
                                   child:   ListTile(
                                     title: Text("Clock In",style: GoogleFonts.nunitoSans(fontSize: 12),),
                                     subtitle: Text(getClockIn2.toString() == '' ||
                                         getClockIn2.toString() == '0' ? "..." : getClockIn2.toString(),style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold,
                                         color: Colors.black),),
                                   ),
                                 ),

                                 Container(
                                   width: 100,
                                   child:   ListTile(
                                     title: Text("Clock Out",style: GoogleFonts.nunitoSans(fontSize: 12),),
                                     subtitle: Text(getClockOut2.toString() == "" || getClockOut2.toString() == "0"
                                         ? "..." : getClockOut2.toString(),style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold,
                                         color: Colors.black),),
                                   ),
                                 ),
                               ],
                             ),
                           ],
                         )
                     ),

                     Padding(
                       padding: EdgeInsets.only(top: 5),
                       child: Divider(height: 2,),
                     ),



                   ],
                 )
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