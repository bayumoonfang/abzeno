




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


class CorrectionAttendance extends StatefulWidget{
  final String getKaryawanNo;
  final String getType;
  final String getDate;
  final String getDescription;
  final String getDate2;
  const CorrectionAttendance(this.getKaryawanNo, this.getType, this.getDate, this.getDescription, this.getDate2);
  @override
  _CorrectionAttendance createState() => _CorrectionAttendance();
}


class _CorrectionAttendance extends State<CorrectionAttendance> {
  TextEditingController _TimeStart = TextEditingController();
  TextEditingController _TimeEnd = TextEditingController();
  var selectedTimeStart;
  var selectedTimeEnd;
  bool _isPressed = false;
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

  String getAttenceMessage = "...";
  getAttendanceDetail() async {
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getAttendanceCheck&karyawanNo=" +
            widget.getKaryawanNo+"&getDate="+widget.getDate)).timeout(
        Duration(seconds: 10), onTimeout: () {
      AppHelper().showFlushBarsuccess(context, "Koneksi terputus..");
      http.Client().close();
      return http.Response('Error', 500);
    }
    );
    Map data = jsonDecode(response.body);
    print(
        applink + "mobile/api_mobile.php?act=getAttendanceCheck&karyawanNo=" +
            widget.getKaryawanNo+"&getDate="+widget.getDate);
    setState(() {
      getAttenceMessage = data["message"].toString();
      if(data["message"].toString() == "1") {
        _getScheduleDetail();
      }
      EasyLoading.dismiss();
    });
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: "Waiting for Attendance Check...");
    getAttendanceDetail();
  }



  _addreq_attend() async {
    EasyLoading.show(status: "Loading...");
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=add_reqattend"),
        body: {
          "reqattend_karyawan": widget.getKaryawanNo,
          "reqattend_date": widget.getDate,
          "reqattend_type" : widget.getType,
          "reqattend_description" : widget.getDescription,
          "reqattend_clockin" : _TimeStart.text,
          "reqattend_clockout" : _TimeEnd.text,
          "reqattend_scheduleclockin" : getClockIn.toString(),
          "reqattend_scheduleclockout" : getClockOut.toString()
        }).timeout(Duration(seconds: 20), onTimeout: () {
      http.Client().close();
      AppHelper().showFlushBarerror(
          context, "Koneksi Terputus, silahkan ulangi sekali lagi");
      EasyLoading.dismiss();
      return http.Response('Error', 500);
    });

    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"] != '') {
        EasyLoading.dismiss();
        if (data["message"] == '2') {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            AppHelper().showFlushBarconfirmed(context,
                "Attendance Correction has been posted");
          });
          return;
        }  else if (data["message"] == '0') {
          AppHelper().showFlushBarsuccess(context,
              "Maaf data approval anda belum lengkap,silahkan hubungi HRD terkait hal ini");
          return;
        } else if (data["message"] == '1') {
          AppHelper().showFlushBarsuccess(context,
              "Maaf anda sudah ada request di tanggal tersebut yang belum ditindaklanjuti, silahkan batalkan "
              "request atau tunggu approval diproses");
          return;
        }

      }
    });

  }



  showDialogme(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if(_TimeStart.text == "") {
      AppHelper().showFlushBarsuccess(context, "Jam tidak boleh kosong");
      setState(() {
        _isPressed = false;
      });
      return false;
    } else  if(_TimeEnd.text == "") {
      AppHelper().showFlushBarsuccess(context, "Jam tidak boleh kosong");
      setState(() {
        _isPressed = false;
      });
      return false;
    }


    Widget cancelButton = TextButton(
      child: Text("Cancel", style: GoogleFonts.nunito(color: Colors.black)),
      onPressed:  () {Navigator.pop(context);
      setState(() {
        _isPressed = false;
      });
        },
    );
    Widget continueButton = TextButton(
      child: Text("Yes", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: HexColor("#1a76d2"))),
      onPressed:  () {
        _addreq_attend();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Add Attendance Correction", style: GoogleFonts.nunito(fontSize: 18,fontWeight: FontWeight.bold)),
      content: Text("Would you like to continue add attendance correction ?", style: GoogleFonts.nunitoSans(),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(AppHelper().main_color),
        title: Text("Add Attendance "+widget.getType, style: GoogleFonts.nunito(fontSize: 17),),
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
              child: getAttenceMessage == "0" ?
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Oh Sorry", style: GoogleFonts.nunito(fontSize: 45,fontWeight: FontWeight.bold)),
                    Text("We Dont Find Attendance in your date request", style: GoogleFonts.nunito(fontSize: 15)),
                    Text("Try to use Attendace Request", style: GoogleFonts.nunito(fontSize: 15))
                  ],
                ),
              ) :
                 Column(
                   children: [
                     Container(
                       padding: EdgeInsets.only(top:20),
                       width: double.infinity,
                       child: Column(
                         children: [

                           Text("Schedule",style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold,
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
                             Text("Attendance",style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold,
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

                   Align(
                     alignment: Alignment.centerLeft,
                     child:   Padding(
                       padding: EdgeInsets.only(top:25),
                       child: Text(widget.getType+ " at ("+widget.getDate2+")",style: GoogleFonts.nunitoSans(fontSize: 16,fontWeight: FontWeight.bold,
                           color: Colors.black)),
                     ),
                   ),


                     Padding(
                       padding: EdgeInsets.only(top: 25),
                       child:  TextFormField(
                         style: GoogleFonts.nunito(fontSize: 16),
                         textCapitalization: TextCapitalization.sentences,
                         controller: _TimeStart,
                         decoration: InputDecoration(
                           contentPadding: const EdgeInsets.only(top: 2),
                           hintText: 'Pick Correction Clock In',
                           labelText: 'Clock In',
                           labelStyle: TextStyle(
                               fontFamily: "VarelaRound",
                               fontSize: 16.5, color: Colors.black87
                           ),
                           floatingLabelBehavior: FloatingLabelBehavior
                               .always,
                           hintStyle: GoogleFonts.nunito(
                               color: HexColor("#c4c4c4"), fontSize: 15),
                           enabledBorder: UnderlineInputBorder(
                             borderSide: BorderSide(
                                 color: HexColor("#DDDDDD")),
                           ),
                           focusedBorder: UnderlineInputBorder(
                             borderSide: BorderSide(
                                 color: HexColor("#8c8989")),
                           ),
                           border: UnderlineInputBorder(
                             borderSide: BorderSide(
                                 color: HexColor("#DDDDDD")),
                           ),
                         ),
                         enableInteractiveSelection: false,
                         onTap: () async {
                           FocusScope.of(context).requestFocus(
                               new FocusNode());
                           DatePicker.showTimePicker(context,
                             //showTitleActions: true,,
                             showSecondsColumn: false,
                             onChanged: (date) {
                               selectedTimeStart =
                                   DateFormat("HH:mm").format(date);
                               _TimeStart.text = selectedTimeStart;
                             }, onConfirm: (date) {
                               selectedTimeStart =
                                   DateFormat("HH:mm").format(date);
                               _TimeStart.text = selectedTimeStart;
                             },
                             currentTime: DateTime.now(),);
                         },
                       ),
                     ),


                     Padding(
                       padding: EdgeInsets.only(top: 25),
                       child:  TextFormField(
                         style: GoogleFonts.nunito(fontSize: 16),
                         textCapitalization: TextCapitalization.sentences,
                         controller: _TimeEnd,
                         decoration: InputDecoration(
                           contentPadding: const EdgeInsets.only(top: 2),
                           hintText: 'Pick Correction Clock Out',
                           labelText: 'Clock Out',
                           labelStyle: TextStyle(
                               fontFamily: "VarelaRound",
                               fontSize: 16.5, color: Colors.black87
                           ),
                           floatingLabelBehavior: FloatingLabelBehavior
                               .always,
                           hintStyle: GoogleFonts.nunito(
                               color: HexColor("#c4c4c4"), fontSize: 15),
                           enabledBorder: UnderlineInputBorder(
                             borderSide: BorderSide(
                                 color: HexColor("#DDDDDD")),
                           ),
                           focusedBorder: UnderlineInputBorder(
                             borderSide: BorderSide(
                                 color: HexColor("#8c8989")),
                           ),
                           border: UnderlineInputBorder(
                             borderSide: BorderSide(
                                 color: HexColor("#DDDDDD")),
                           ),
                         ),
                         enableInteractiveSelection: false,
                         onTap: () async {
                           FocusScope.of(context).requestFocus(
                               new FocusNode());
                           DatePicker.showTimePicker(context,
                             //showTitleActions: true,
                             showSecondsColumn: false,
                             onChanged: (date) {
                               selectedTimeEnd =
                                   DateFormat("HH:mm").format(date);
                               _TimeEnd.text = selectedTimeEnd;
                             }, onConfirm: (date) {
                               selectedTimeEnd =
                                   DateFormat("HH:mm").format(date);
                               _TimeEnd.text = selectedTimeEnd;
                             },
                             currentTime: DateTime.now(),);
                         },
                       ),
                     )


                   ],
                 )
            ),
      bottomSheet:

      getAttenceMessage != "0" ?
      Container(
          padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
          width: double.infinity,
          height: 55,
          child:
          _isPressed == false ?
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: HexColor(AppHelper().main_color),
                elevation: 0,
                shape: RoundedRectangleBorder(side: BorderSide(
                    color: Colors.white,
                    width: 0.1,
                    style: BorderStyle.solid
                ),
                  borderRadius: BorderRadius.circular(5.0),
                )),
            child: Text("Request"),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              setState(() {
                _isPressed = true;
              });
              showDialogme(context);
            },
          ) :
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: HexColor("#DDDDDD"),
                elevation: 0,
                shape: RoundedRectangleBorder(side: BorderSide(
                    color: Colors.white,
                    width: 0.1,
                    style: BorderStyle.solid
                ),
                  borderRadius: BorderRadius.circular(5.0),
                )),
            child: Text("Request"),
            onPressed: () {},
          )
      ) : Container(
        width: double.infinity,
        height: 55,)

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