



import 'dart:convert';

import 'package:abzeno/helper/app_helper.dart';
import 'package:abzeno/helper/app_link.dart';
import 'package:abzeno/helper/page_route.dart';
import 'package:abzeno/page_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;


class ClockOut extends StatefulWidget {
  final String getKaryawanNo;
  final String getJam;
  final String getNamaHari;
  final String getNote;
  final String getType;
  final String getKaryawanNama;
  final String getKaryawanJabatan;
  final String getStartTime;
  final String getEndTime;
  final String getScheduleName;
  const ClockOut(this.getKaryawanNo, this.getJam, this.getNamaHari,this.getNote,this.getType,
      this.getKaryawanNama,
      this.getKaryawanJabatan,this.getStartTime,this.getEndTime,this.getScheduleName);
  @override
  _ClockOut createState()=> _ClockOut();
}


class _ClockOut extends State<ClockOut> {



  _addattendance() async {
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=add_attendance"), body: {
      "att_karyawanno": widget.getKaryawanNo,
      "att_namaHari": widget.getNamaHari,
      "att_jam": widget.getJam,
      "att_note": widget.getNote,
      "att_getStartTime": widget.getStartTime,
      "att_getEndTime": widget.getEndTime,
      "att_getScheduleName": widget.getScheduleName,
      "att_type" : widget.getType
    }).timeout(Duration(seconds: 10),onTimeout: (){
      http.Client().close();
      AppHelper().showFlushBarerror(context, "Koneksi Terputus, silahkan ulangi sekali lagi");
      return http.Response('Error',500);
    });
    Map data = jsonDecode(response.body);
    setState(() {
      if(data["message"] != '') {
        EasyLoading.dismiss();
        if(data["message"] == '0') {
          AppHelper().showFlushBarsuccess(context, "Anda sudah absen, atau anda tidak ada jadwal untuk hari ini");
          return;
        } else if(data["message"] == '1') {
          Navigator.pushReplacement(context, ExitPage(page: Home()));
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            AppHelper().showFlushBarconfirmed(context, "Horray ! "+widget.getType+" berhasil");
          });
        } else {
          AppHelper().showFlushBarsuccess(context, data["message"]);
          return;
        }
      }
    });
  }


  @override
  void initState() {
    super.initState();
    EasyLoading.dismiss();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        //backgroundColor: HexColor(AppHelper().main_color),
        backgroundColor: HexColor("#3a5664"),
        title: Text(
          widget.getType.toString(), style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
        leading: Builder(
          builder: (context) => IconButton(
              icon: new Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => {
                Navigator.pop(context)
              }),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
              Padding(padding: EdgeInsets.only(top: 50),
              child: Align(
                alignment: Alignment.center,
                child: Text(widget.getKaryawanNama,style: GoogleFonts.nunito(fontSize: 23,fontWeight: FontWeight.bold),),
              ),),
            Padding(padding: EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment.center,
                child: Text(widget.getKaryawanJabatan,style: GoogleFonts.nunito(fontSize: 15),),
              ),),

            Padding(padding: EdgeInsets.only(top: 55),
              child: Align(
                alignment: Alignment.center,
                child: Text(AppHelper().getTanggal_withhari().toString(),style: GoogleFonts.nunito(fontSize: 12),),
              ),),

            Padding(padding: EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment.center,
                child: Text(widget.getJam,style: GoogleFonts.nunito(fontSize: 32,fontWeight: FontWeight.bold),),
              ),),

            Padding(padding: EdgeInsets.only(top: 15),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 150,
                  child: ElevatedButton(child : Text(widget.getType.toString(),style: GoogleFonts.lexendDeca(color:Colors.white,fontWeight: FontWeight.bold,
                      fontSize: 14),),
                    style: ElevatedButton.styleFrom(
                        primary: HexColor("#075E54"),
                        elevation: 0,
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.white,
                            width: 0.1,
                            style: BorderStyle.solid
                        ),
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    onPressed: (){
                      EasyLoading.show(status: "Loading...");
                      _addattendance();
                      //Navigator.push(context, ExitPage(page: PageClockIn(getKaryawanNo, getJam, getWorkLocationId, AppHelper().getNamaHari().toString(),getWorkLat.toString(),getWorkLong.toString(),getScheduleID.toString()))).then(onGoBack);
                    },)
                )
              ),)


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