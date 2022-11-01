


import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Request%20Attendance/page_reqattend_gantishift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'page_reqattend_correction.dart';
import 'page_reqattend_lemburanotherday.dart';
import 'page_reqattend_lembursameday.dart';

class AddRequestAttendance2 extends StatefulWidget{
  final String getKaryawanNo;
  const AddRequestAttendance2(this.getKaryawanNo);
  @override
  _AddRequestAttendance2 createState() => _AddRequestAttendance2();
}


class _AddRequestAttendance2 extends State<AddRequestAttendance2> {

  TextEditingController _datefrom = TextEditingController();
  TextEditingController _TimeStart = TextEditingController();
  TextEditingController _TimeEnd = TextEditingController();
  TextEditingController _description = TextEditingController();



  var selectedTimeStart;
  var selectedTimeEnd;
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

  String dropdownvalue = 'Correction';
  var items = [
    'Correction',
    'Ganti Shift',
    'Lembur in Same Day',
    'Lembur in Another Day'
  ];



  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#3a5664"),
        title: Text("Add Attendance", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
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
      body: Container(
        padding: EdgeInsets.only(left: 25,right: 25,top: 30),
        child: Column(
          children: [
            TextFormField(
              style: GoogleFonts.workSans(fontSize: 16),
              textCapitalization: TextCapitalization.sentences,
              controller: _datefrom,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 2),
                hintText: 'Pick Request Date',
                labelText: 'Pick Date',
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




             Stack(
               children: [
                 Align(alignment: Alignment.centerLeft, child: Padding(
                   padding: const EdgeInsets.only(left: 0, top: 25),
                   child: Text("Request Type",
                     style: TextStyle(fontFamily: "VarelaRound",
                         fontSize: 11.5, color: Colors.black87),),
                 ),),
                Align(alignment: Alignment.centerLeft, child: Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child:
                 DropdownButton(
                   isExpanded: false,
                   hint: Text("Choose time off type",
                     style: GoogleFonts.workSans(
                         fontSize: 15, color: Colors.black),),
                   value: dropdownvalue,
                   items: items.map((String items) {
                     return DropdownMenuItem(
                       value: items,
                       child: Text(items,
                           style: GoogleFonts.workSans(
                               fontSize: 15, color: Colors.black)),
                     );
                   }).toList(),
                   onChanged: (value) {
                     setState(() {
                       dropdownvalue = value!;
                     });
                   },
                 ),
                 ))
               ],
             )
            ,




            Padding(
              padding: EdgeInsets.only(top: 25),
              child:  TextFormField(
                style: GoogleFonts.workSans(fontSize: 16),
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
            )
          ],
        )
      ),
      bottomSheet: Container(
          padding: EdgeInsets.only(left: 45, right: 45, bottom: 10),
          width: double.infinity,
          height: 58,
          child:
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
            child: Text("Next",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                fontSize: 14),),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              if(_datefrom.text == "") {
                AppHelper().showFlushBarsuccess(
                    context, "Tanggal tidak boleh kosong");
                return;
              } else if(_description.text == "") {
                AppHelper().showFlushBarsuccess(
                    context, "Description tidak boleh kosong");
                return;
              } else {
                if(dropdownvalue.toString() == 'Correction') {
                  Navigator.push(context, ExitPage(page: CorrectionAttendance(widget.getKaryawanNo, dropdownvalue.toString(), startDate.toString(), _description.text,
                      _datefrom.text)));
                } else if(dropdownvalue.toString() == 'Ganti Shift')  {
                  Navigator.push(context, ExitPage(page: RequestGantiShift(widget.getKaryawanNo, dropdownvalue.toString(), startDate.toString(), _description.text,
                      _datefrom.text)));
                } else if(dropdownvalue.toString() == 'Lembur in Same Day')  {
                  Navigator.push(context, ExitPage(page: RequestLemburSameDay(widget.getKaryawanNo, dropdownvalue.toString(), startDate.toString(), _description.text,
                      _datefrom.text)));
                } else if(dropdownvalue.toString() == 'Lembur in Another Day')  {
                  Navigator.push(context, ExitPage(page: RequestLemburAnotherDay(widget.getKaryawanNo, dropdownvalue.toString(), startDate.toString(), _description.text,
                      _datefrom.text)));
                }
              }
            },
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