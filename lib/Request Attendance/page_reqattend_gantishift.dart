




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


class RequestGantiShift extends StatefulWidget{
  final String getKaryawanNo;
  final String getType;
  final String getDate;
  final String getDescription;
  final String getDate2;
  const RequestGantiShift(this.getKaryawanNo, this.getType, this.getDate, this.getDescription, this.getDate2);
  @override
  _RequestGantiShift createState() => _RequestGantiShift();
}


class _RequestGantiShift extends State<RequestGantiShift> {
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
  getAttendanceCheck() async {
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getAttendanceCheckGantiShift&karyawanNo=" +
            widget.getKaryawanNo+"&getDate="+widget.getDate)).timeout(
        Duration(seconds: 10), onTimeout: () {
      AppHelper().showFlushBarsuccess(context, "Koneksi terputus..");
      http.Client().close();
      return http.Response('Error', 500);
    }
    );
    Map data = jsonDecode(response.body);
    setState(() {
      getAttenceMessage = data["message"].toString();
      if(data["message"].toString() == "0") {
        _getScheduleDetail();
      }
      EasyLoading.dismiss();
    });
  }

  List scheduleList = [];
  var selectedscheduleList;
  Future getAllSchedule() async {
    var response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getAllSchedule"));
    var jsonData = json.decode(response.body);
    setState(() {
      scheduleList = jsonData;
    });
  }




  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: "Waiting for Attendance Check...");
    getAllSchedule();
    getAttendanceCheck();

  }



  _addreq_attend() async {
    EasyLoading.show(status: "Loading...");
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=add_reqattend_gantishift"),
        body: {
          "reqattend_karyawan": widget.getKaryawanNo,
          "reqattend_date": widget.getDate,
          "reqattend_type" : widget.getType,
          "reqattend_description" : widget.getDescription,
          "reqattend_newschedule" : selectedscheduleList,
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
    if(selectedscheduleList.toString() == 'null') {
      AppHelper().showFlushBarsuccess(
          context, "Schedule harus dipilih");
      EasyLoading.dismiss();
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
        setState(() {
          _isPressed = true;
        });
        _addreq_attend();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Add Attendance Ganti Shift", style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold)),
      content: Text("Would you like to continue add attendance ganti shift ?", style: GoogleFonts.nunitoSans(),),
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
        backgroundColor: HexColor("#3a5664"),
        title: Text("Attendance "+widget.getType, style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
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
        actions: [
          getAttenceMessage == "0" ?
          Padding(
            padding: EdgeInsets.only(right: 25,top: 16),
            child: InkWell(
              child: FaIcon(FontAwesomeIcons.save),
              onTap: (){
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(() {
                  _isPressed = true;
                });
                showDialogme(context);
              },
            ),
          ) : Container()
        ],
      ),
      body:
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(left: 25,right: 25),
              child: getAttenceMessage == "1" ?
                        Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Oh Sorry", style: GoogleFonts.nunito(fontSize: 45,fontWeight: FontWeight.bold)),
                            Text("We find your another attendance request", style: GoogleFonts.nunito(fontSize: 15)),
                            Text("Please wait for approval or cancel your latest request", style: GoogleFonts.nunito(fontSize: 15))
                        ]),
                ) : getAttenceMessage == "2" ?
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Oh Sorry", style: GoogleFonts.nunito(fontSize: 45,fontWeight: FontWeight.bold)),
                      Text("We find your another attendance request", style: GoogleFonts.nunito(fontSize: 15)),
                      Text("Please choose another date", style: GoogleFonts.nunito(fontSize: 15))
                    ]),
              ) : getAttenceMessage == "3" ?
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Oh Sorry", style: GoogleFonts.nunito(fontSize: 45,fontWeight: FontWeight.bold)),
                      Text("We Dont Find Attendance in your date request", style: GoogleFonts.nunito(fontSize: 15)),
                    ]),
              ) : getAttenceMessage == "4" ?
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Oh Sorry", style: GoogleFonts.nunito(fontSize: 45,fontWeight: FontWeight.bold)),
                      Text("We Find Another Request in your date", style: GoogleFonts.nunito(fontSize: 15)),
                      Text("Please wait for approval or cancel your latest request", style: GoogleFonts.nunito(fontSize: 15))
                    ]),
              ) :
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

                   Align(
                     alignment: Alignment.centerLeft,
                     child:   Padding(
                       padding: EdgeInsets.only(top:25),
                       child: Text(widget.getType+ " at ("+widget.getDate2+")",style: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.bold,
                           color: Colors.black)),
                     ),
                   ),


                     Padding(
                       padding: EdgeInsets.only(top: 25),
                       child:   Stack(
                         children: [
                           Align(alignment: Alignment.centerLeft, child: Padding(
                             padding: const EdgeInsets.only(left: 0),
                             child: Text("New Schedule",
                               style: TextStyle(fontFamily: "VarelaRound",
                                   fontSize: 11.5, color: Colors.black87),),
                           ),),
                           Align(alignment: Alignment.centerLeft, child: Padding(
                             padding: const EdgeInsets.only(top: 10),
                             child: DropdownButton(
                               isExpanded: false,
                               hint: Text("Choose new schedule",
                                 style: GoogleFonts.workSans(
                                     fontSize: 15, color: Colors.black),),
                               value: selectedscheduleList,
                               items:
                               scheduleList.map((item) {
                                 return DropdownMenuItem(
                                   value: item['a'].toString(),
                                   child: Text(item['a'].toString()+ " ("+item['b'].toString()+" - "+item['c'].toString()+")",
                                       style: GoogleFonts.workSans(
                                           fontSize: 15, color: Colors.black)),
                                 );
                               }).toList(),
                               onChanged: (value) {
                                 setState(() {
                                   FocusScope.of(context).requestFocus(
                                       FocusNode());
                                  // EasyLoading.show(status: "Loading...");
                                   selectedscheduleList = value.toString();
                                   //_getTimeOffNeedTime(value.toString());

                                 });
                               },
                             ),
                           )),
                         ],
                       ),
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