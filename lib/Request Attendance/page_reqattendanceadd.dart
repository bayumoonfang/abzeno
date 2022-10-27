


import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddRequestAttendance extends StatefulWidget{
  final String getKaryawanNo;
  final String getType;
  const AddRequestAttendance(this.getKaryawanNo, this.getType);
  @override
  _AddRequestAttendance createState() => _AddRequestAttendance();
}


class _AddRequestAttendance extends State<AddRequestAttendance> {

  TextEditingController _datefrom = TextEditingController();
  TextEditingController _TimeStart = TextEditingController();
  TextEditingController _TimeEnd = TextEditingController();
  TextEditingController _description = TextEditingController();



  var selectedTimeStart;
  var selectedTimeEnd;
  bool _isPressed = false;
  _addreq_attend() async {
    EasyLoading.show(status: "Loading...");
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=add_reqattend"),
        body: {
          "changepin_id": widget.getKaryawanNo,
          "changepin_value": _datefrom.text,
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
        if (data["message"] == '1') {
          _datefrom.clear();
          Navigator.pop(context);
          Navigator.pop(context);
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            AppHelper().showFlushBarconfirmed(context,
                "PIN has been changed");
          });
          return;
        }

      }
    });

  }



  showDialogme(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if(_datefrom.text == "") {
      AppHelper().showFlushBarsuccess(context, "Tanggal tidak boleh kosong");
      setState(() {
        _isPressed = false;
      });
      return false;
    } else  if(_TimeStart.text == "") {
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
    } else if (getNameShift == 'null') {
      AppHelper().showFlushBarsuccess(context, "Request Attendance cant be processed");
      setState(() {
        _isPressed = false;
      });
      return false;
    }


    Widget cancelButton = TextButton(
      child: Text("Cancel", style: GoogleFonts.nunito(color: Colors.black)),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = TextButton(
      child: Text("Yes", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: HexColor("#1a76d2"))),
      onPressed:  () {
        _addreq_attend();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Add Attendance Request", style: GoogleFonts.nunito(fontSize: 18,fontWeight: FontWeight.bold)),
      content: Text("Would you like to continue add attendance request ?", style: GoogleFonts.nunitoSans(),),
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

  var startDate;


  String getNameShift = "...";
  String getClockIn = "...";
  String getClockOut = "...";
  _getScheduleDetail(String getDate) async {
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getScheduleDetail&karyawanNo=" +
            widget.getKaryawanNo+"&getDate="+getDate.toString())).timeout(
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
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#3a5664"),
        title: Text("Add Attendance "+widget.getType, style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
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
      body: Container(
        padding: EdgeInsets.only(left: 25,right: 25,top: 30),
        child: Column(
          children: [
            TextFormField(
              style: GoogleFonts.nunito(fontSize: 16),
              textCapitalization: TextCapitalization.sentences,
              controller: _datefrom,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 2),
                hintText: 'Pick Start Date',
                labelText: 'Start Date',
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
                FocusScope.of(context).requestFocus(new FocusNode());
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    confirmText: 'CHOOSE',
                    helpText: 'Select start date',
                    lastDate: DateTime(2100));
                if (pickedDate != null) {
                  String formattedDate =
                  DateFormat('dd-MM-yyyy').format(pickedDate);
                  setState(() {
                    EasyLoading.show(status: "Loading...");
                     startDate = pickedDate;
                    _datefrom.text = formattedDate;
                    _getScheduleDetail(startDate.toString());
                    _TimeStart.clear();
                    _TimeEnd.clear();
                  });

                } else {}
              },
            ),


            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  height: 80,
                  width: double.infinity,
                  child: Wrap(
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
                )
            ),

            getNameShift.toString() != 'null' ?
            Padding(
              padding: EdgeInsets.only(top: 25),
              child:  TextFormField(
                style: GoogleFonts.nunito(fontSize: 16),
                textCapitalization: TextCapitalization.sentences,
                controller: _TimeStart,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 2),
                  hintText: 'Pick Clock In',
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
                    //showTitleActions: true,
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
            ) : Container(),

            getNameShift.toString() != 'null' ?
            Padding(
              padding: EdgeInsets.only(top: 25),
              child:  TextFormField(
                style: GoogleFonts.nunito(fontSize: 16),
                textCapitalization: TextCapitalization.sentences,
                controller: _TimeEnd,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 2),
                  hintText: 'Pick Clock Out',
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
            ) : Container(),

            getNameShift.toString() != 'null' ?
            Padding(
              padding: EdgeInsets.only(top: 25),
              child:  TextFormField(
                style: GoogleFonts.nunito(fontSize: 16),
                textCapitalization: TextCapitalization
                    .sentences,
                maxLines: 4,
                controller: _description,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      top: 2),
                  hintText: 'Description of your request attendance',
                  labelText: 'Description',
                  labelStyle: TextStyle(
                      fontFamily: "VarelaRound",
                      fontSize: 16.5, color: Colors.black87
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior
                      .always,
                  hintStyle: GoogleFonts.nunito(
                      color: HexColor("#c4c4c4"),
                      fontSize: 15),
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

              ),
            ) : Container()
          ],
        )
      ),
      bottomSheet: Container(
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