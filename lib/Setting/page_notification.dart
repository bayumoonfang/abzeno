



import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;


class ChangeNotifikasi extends StatefulWidget{
  final String getEmail;
  const ChangeNotifikasi(this.getEmail);
  @override
  _ChangeNotifikasi createState() => _ChangeNotifikasi();
}



class _ChangeNotifikasi extends State<ChangeNotifikasi> {

  late List data;

  String getNotif1 = "...";
  String getNotif2 = "...";
  String getBahasa = "...";
  _notifDetail() async {
    await AppHelper().cekSettings();
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
        getNotif1 = value[21];
        getNotif2 = value[22];
      });});
  }



  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      AppHelper().showFlushBarsuccess(context,"Koneksi terputus..");
      EasyLoading.dismiss();
      return false;
    }});
    await _notifDetail();
  }

  @override
  void initState() {
    super.initState();
    _startingVariable();
  }



  _gantiNotif1(String valme) async {

    EasyLoading.show(status: "Loading...");
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=changeNotif1"), body: {
      "notif_id": valme.toString(),
      "karyawan_email": widget.getEmail
    }).timeout(
        Duration(seconds: 10),onTimeout: (){
      AppHelper().showFlushBarsuccess(context,"Koneksi terputus..");
      EasyLoading.dismiss();
      http.Client().close();
      return http.Response('Error',500);
    });

    Map data = jsonDecode(response.body);
    print(data["message"]);
    if(data["message"] != '') {
      EasyLoading.dismiss();
      if(data["message"] == '1') {
        //AppHelper().getWorkLocation();
        //Navigator.pop(context);
        AppHelper().showFlushBarconfirmed(context, "Notification Email has been changed");
        setState(() {
          _startingVariable();
        });
      } else {
        AppHelper().showFlushBarsuccess(context,data["message"].toString());
        return false;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        backgroundColor: HexColor("#3a5664"),
        title: Text(
          "Ubah Setting Notifikasi", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
        leading: Builder(
          builder: (context) => IconButton(
              icon: new Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => {
                Navigator.pop(context)
              }),
        ),
      ),
      body:
          Container(
            child: Column(
              children: [

                Padding(padding: const EdgeInsets.only(left: 9,right: 25),
                  child: ListTile(
                      onTap: (){
                        //Navigator.pushReplacement(context, ExitPage(page: ProfileUbahNama()));
                      },
                      title: Padding(padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,child:
                            Text("Notifikasi Email", style: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.bold),),),
                            Padding(padding: const EdgeInsets.only(top: 5),
                              child:    Align(alignment: Alignment.centerLeft,child:
                              Text("Notifikasi yang dikirim via email",
                                style: GoogleFonts.nunitoSans(fontSize: 13),),),)
                          ],
                        ),),
                      trailing:
                      Container(
                          alignment: Alignment.centerRight,
                          width: 50,
                          child:
                          Padding(padding: const EdgeInsets.only(top: 10),child:
                          Align(
                            alignment: Alignment
                                .centerRight,
                            child: Switch(
                              value: getNotif1 == '1' ? true : false,
                              onChanged: (value) {
                                setState(() {
                                  _gantiNotif1(getNotif1 == '1' ? '0' : '1');
                                });
                              },
                              activeTrackColor: HexColor("#bbffce"),
                              activeColor: Colors.green,
                            ),
                          ),)
                      )
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                  child: Divider(height: 3,),),

                Opacity(
                  opacity: 0.3,
                  child:   Padding(padding: const EdgeInsets.only(left: 9,right: 25),
                    child: ListTile(
                        onTap: (){
                          //Navigator.pushReplacement(context, ExitPage(page: ProfileUbahNama()));
                        },
                        title: Padding(padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft,child:
                              Text("Notifikasi Aplikasi", style: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.bold),),),
                              Padding(padding: const EdgeInsets.only(top: 5),
                                child:    Align(alignment: Alignment.centerLeft,child:
                                Text("Notifikasi yang dikirim via email",
                                  style: GoogleFonts.nunitoSans(fontSize: 13),),),)
                            ],
                          ),),
                        trailing:
                        Container(
                            alignment: Alignment.centerRight,
                            width: 50,
                            child:
                            Padding(padding: const EdgeInsets.only(top: 10),child:
                            Align(
                              alignment: Alignment
                                  .centerRight,
                              child: Switch(
                                value: getNotif2 == '1' ? true : false,
                                onChanged: (value) {
                                  setState(() {
                                    //_gantiStatus();
                                  });
                                },
                                activeTrackColor: HexColor("#bbffce"),
                                activeColor: Colors.green,
                              ),
                            ),)
                        )
                    ),
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