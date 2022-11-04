



import 'dart:async';
import 'dart:convert';
import 'dart:ui';


import 'package:abzeno/MySchedule/page_myschedule.dart';
import 'package:abzeno/Profile/page_changepin.dart';
import 'package:abzeno/Request%20Attendance/page_reqattendancehome.dart';
import 'package:abzeno/attendance/page_doattendance.dart';
import 'package:abzeno/page_changecabang.dart';
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
import 'Request Attendance/page_reqattendance.dart';
import 'Setting/page_setting.dart';
import 'Time Off/page_timeoffhome.dart';
import 'helper/app_helper.dart';
import 'helper/app_link.dart';
import 'helper/page_route.dart';
import 'attendance/page_attendance.dart';
import 'page_login.dart';





class Home2 extends StatefulWidget{
  final String getKaryawanNama;
  final String getKaryawanJabatan;
  final String getKaryawanNo;
  final String getScheduleName;
  final String getStartTime;
  final String getEndTime;
  final String getScheduleID;
  final String getJamMasukSebelum;
  final String getJamKeluarSebelum;
  final String getPIN;
  final String getScheduleBtn;
  final String getKaryawanEmail;
  const Home2(this.getKaryawanNama, this.getKaryawanJabatan, this.getKaryawanNo,
      this.getScheduleName,
      this.getStartTime,
      this.getEndTime,
      this.getScheduleID,
      this.getJamMasukSebelum,
      this.getJamKeluarSebelum,this.getPIN, this.getScheduleBtn, this.getKaryawanEmail);
  @override
  _Home2 createState() => _Home2();
}


class _Home2 extends State<Home2> with AutomaticKeepAliveClientMixin<Home2> {

  @override
  bool get wantKeepAlive => true;
  bool _isVisibleBtn = false;
  var getJam = DateFormat('HH:mm').format(DateTime.now());


  String getWorkLocation = "...";
  String getWorkLocationId = "...";
  String getWorkLong = "...";
  String getWorkLat = "...";
  refreshworklocation() async {
    await AppHelper().getWorkLocation().then((value){
      setState(() {
        getWorkLocation = value[0];
        getWorkLocationId = value[1];
        getWorkLat = value[2];
        getWorkLong = value[3];
      });});
  }

  String getJamMasuk = "...";
  String getJamKeluar = "...";
  refreshAttendance() async {
    await AppHelper().getAttendance().then((value){
      setState(() {
        getJamMasuk = value[0];
        getJamKeluar = value[1];
      });});
  }

  String getPINq = '...';
  getDefaultPass() async {
    await AppHelper().getDetailUser();
    await AppHelper().getSession().then((value){
      setState(() {
        getPINq = value[18];
      });});
  }





  loadData() async {
    refreshworklocation();
    refreshAttendance();
    getDefaultPass();
    setState(() {
      _isVisibleBtn = true;
    });
  }



  FutureOr onGoBack(dynamic value2) {
    refreshworklocation();
    getDefaultPass();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }



  Future refreshData() async {
    loadData();
  }


  @override
  Widget build(BuildContext context) {
      return WillPopScope(child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(bottom:15),
          child : RefreshIndicator(
            onRefresh: refreshData,
            child : SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.only(left:28,right: 25),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            HexColor(AppHelper().main_color),
                            HexColor(AppHelper().second_color),
                          ],
                        ),
                        color:  HexColor("#3aa13d"),
                        image: DecorationImage(
                          image: AssetImage("assets/doodleme30.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: double.infinity,
                      height: 225,
                      child : Stack(
                        clipBehavior: Clip.none, alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                              top: -18, right: 0, left:-8, child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Container(
                                height: 160,
                                width: 118,

                              ),
                              InkWell(
                                  onTap:() {
                                    Navigator.push(context, ExitPage(page: SettingHome(widget.getKaryawanEmail)));
                                  },
                                  child :
                                  FaIcon(FontAwesomeIcons.cog, color: Colors.white,)
                              )
                            ],
                          )),

                          Positioned(
                              top: 90, right: 0, left:0, child:
                          Align(
                            alignment: Alignment.bottomLeft,
                            child:  Text('Halo', style: TextStyle(color: Colors.white,
                                fontFamily: 'VarelaRound', fontSize: 12,
                                fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                          )),
                          Positioned(
                              top: 110, right: 0, left:0, child: Text(
                            widget.getKaryawanNama.toString(),
                            style: TextStyle(color: Colors.white, fontFamily: 'VarelaRound', fontWeight: FontWeight.bold, fontSize: 22),)
                          ),
                          Positioned(
                            top: 137, right: 0, left:0, child: Text(widget.getKaryawanJabatan.toString(), style: TextStyle(color: Colors.white,
                              fontFamily: 'VarelaRound', fontSize: 11,
                              fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                          ),
                        ],
                      )
                  ),


                  Padding(padding: const EdgeInsets.only(top: 170,left: 25,right: 25),
                      child : Container(
                          height: 212,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child:  Padding(padding: const EdgeInsets.only(top: 12,left: 25,right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                StreamBuilder(
                                  stream: Stream.periodic(const Duration(seconds: 1)),
                                  builder: (context, snapshot) {
                                    return Center(
                                      child: Text(
                                        DateFormat('HH:mm').format(DateTime.now()),
                                        style: GoogleFonts.lato(fontSize: 32, fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  },
                                ),
                                Padding(padding: const EdgeInsets.only(top: 8,left: 25,right: 25),
                                  child: Text(
                                      AppHelper().getTanggal_withhari().toString(),
                                      style: GoogleFonts.nunito(fontSize: 13)
                                  ),
                                ),

                                widget.getScheduleID.toString() == '1' || widget.getScheduleID.toString() == '2' ||
                                    widget.getScheduleID.toString() == '3' || widget.getScheduleID.toString() == '4' ||
                                    widget.getScheduleID.toString() == '5'?
                                Padding(padding: const EdgeInsets.only(top: 8,left: 25,right: 25),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                        crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                        children: [
                                          Text(
                                              widget.getStartTime.toString(),
                                              style: GoogleFonts.nunito(fontSize: 17,fontWeight: FontWeight.bold)
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child:      Text(
                                                "-",
                                                style: GoogleFonts.nunito(fontSize: 17,fontWeight: FontWeight.bold)
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child:      Text(
                                                widget.getEndTime.toString(),
                                                style: GoogleFonts.nunito(fontSize: 17,fontWeight: FontWeight.bold)
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                ) :
                                Padding(padding: const EdgeInsets.only(top: 8,left: 25,right: 25),
                                  child: Text(
                                      widget.getScheduleName.toString(),
                                      style: GoogleFonts.nunito(fontSize: 17,fontWeight: FontWeight.bold)
                                  ),
                                ),

                                Padding(padding: const EdgeInsets.only(top: 13,left: 18,right: 25),
                                    child: InkWell(
                                      child : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FaIcon(FontAwesomeIcons.mapMarker,size: 12,color: Colors.blue,),
                                          Padding(padding: const EdgeInsets.only(left: 10),
                                            child: Text(
                                                getWorkLocation.toString()
                                                /*getWorkLocation.toString() != 'null' || getWorkLocation.toString() != '' ? getWorkLocation.toString() :
                                              "Belum Disetting"*/,
                                                style: GoogleFonts.nunito(fontSize: 17,color: Colors.blue)
                                            ),)
                                        ],
                                      ),
                                      onTap: (){
                                        //show_otherlocation();
                                        Navigator.push(context, ExitPage(page: ChangeCabang(widget.getKaryawanNo))).then(onGoBack);
                                      },
                                    )
                                ),

                                Padding(padding: const EdgeInsets.only(top: 20,left: 25,right: 25),
                                    child: Visibility(
                                      visible: _isVisibleBtn,
                                      child : Wrap(
                                        spacing: 30,
                                        children: [
                                          Container(
                                              width: 90,
                                              height: 35,
                                              child:
                                              widget.getScheduleBtn.toString() != 'disable' && getJamMasuk.toString() == '0' ?
                                              ElevatedButton(child : Text("Clock In",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                                  fontSize: 11.5),),
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
                                                  Navigator.push(context, ExitPage(page: PageClockIn(
                                                      widget.getKaryawanNo,
                                                      getJam, getWorkLocationId,AppHelper().getNamaHari().toString(),
                                                      getWorkLat.toString(),
                                                      getWorkLong.toString(),"Clock In",
                                                      widget.getKaryawanNama.toString(),
                                                      widget.getKaryawanJabatan.toString(),
                                                      widget.getStartTime.toString(),
                                                      widget.getEndTime.toString(),
                                                      widget.getScheduleName,
                                                      getWorkLocation.toString()
                                                  ))).then(onGoBack);
                                                },) :
                                              Opacity(
                                                  opacity: 0.6,
                                                  child : ElevatedButton(child : Text("Clock In",style: GoogleFonts.lexendDeca(color: Colors.black,fontWeight: FontWeight.bold,
                                                      fontSize: 11.5),),
                                                    style: ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        primary: HexColor("#DDDDDD"),
                                                        shape: RoundedRectangleBorder(side: BorderSide(
                                                            color: Colors.white,
                                                            width: 0.1,
                                                            style: BorderStyle.solid
                                                        ), borderRadius: BorderRadius.circular(5.0),
                                                        )),onPressed: (){},)
                                              )
                                          ),
                                          Container(
                                              width: 90,
                                              height: 35,
                                              child:
                                              widget.getScheduleBtn.toString() != 'disable'
                                                  && getJamMasuk.toString() != '0' && getJamKeluar.toString() == '00:00' ?
                                              ElevatedButton(child : Text("Clock Out",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                                  fontSize: 11.5),),
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    primary: HexColor("#075E54"),
                                                    shape: RoundedRectangleBorder(side: BorderSide(
                                                        color: Colors.white,
                                                        width: 0.1,
                                                        style: BorderStyle.solid
                                                    ),
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    )),onPressed: (){
                                                  EasyLoading.show(status: "Loading...");
                                                  Navigator.push(context, ExitPage(page: PageClockIn(
                                                      widget.getKaryawanNo,
                                                      getJam, getWorkLocationId,AppHelper().getNamaHari().toString(),
                                                      getWorkLat.toString(),
                                                      getWorkLong.toString(),"Clock Out",
                                                      widget.getKaryawanNama.toString(),
                                                      widget.getKaryawanJabatan.toString(),
                                                      widget.getStartTime.toString(),
                                                      widget.getEndTime.toString(),
                                                      widget.getScheduleName,
                                                      getWorkLocation.toString()
                                                  ))).then(onGoBack);
                                                },) :
                                              Opacity(
                                                  opacity: 0.6,
                                                  child : ElevatedButton(child : Text("Clock Out",style: GoogleFonts.lexendDeca(color: Colors.black,fontWeight: FontWeight.bold,
                                                      fontSize: 11.5),),
                                                    style: ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        primary: HexColor("#DDDDDD"),
                                                        shape: RoundedRectangleBorder(side: BorderSide(
                                                            color: Colors.white,
                                                            width: 0.1,
                                                            style: BorderStyle.solid
                                                        ), borderRadius: BorderRadius.circular(5.0),
                                                        )),onPressed: (){

                                                    },)
                                              )
                                          )
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          )
                      )
                  ),

                  SizedBox(
                    height: 25,
                  ),



                  Padding(
                      padding:
                      getPINq == AppHelper().default_pass ?
                      const EdgeInsets.only(top: 415,left: 25,right: 25) : const EdgeInsets.only(top: 435,left: 25,right: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getPINq == AppHelper().default_pass ?
                          Container(
                              height: 72,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: HexColor("#ffeaef"),
                              ),
                              child:InkWell(
                                onTap: (){
                                  Navigator.push(context, ExitPage(page: ChangePIN(widget.getKaryawanNo))).then(onGoBack);
                                },
                                child:  ListTile(
                                  title: Text("You Have Default PIN",style: GoogleFonts.montserrat(color: Colors.black,fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  subtitle: Text("Lets change your PIN to more security",style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 12)),
                                  trailing: FaIcon(FontAwesomeIcons.angleRight,size: 15,),
                                ),
                              )
                          ) : Container(),
                          getPINq == AppHelper().default_pass ?
                          SizedBox(
                            height: 30,
                          ) : Container(),


                          Wrap(
                            spacing: 35,
                            runSpacing: 30,
                            children: [
                              InkWell(
                                onTap: (){
                                  // EasyLoading.show(status: "Loading...");
                                  Navigator.push(context, ExitPage(page: PageTimeOffHome(widget.getKaryawanNo,widget.getKaryawanNama.toString())));
                                },
                                child:Column(
                                  children: [
                                    Container(
                                        height: 45, width: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: HexColor("#eef9ff"),
                                          border: Border.all(
                                            color: HexColor("#DDDDDD"),
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: FaIcon(FontAwesomeIcons.calendarAlt, color: HexColor("#36bbf6"), size: 24,),
                                        )
                                    ),
                                    Padding(padding: const EdgeInsets.only(top:8),
                                      child: Text("Time Off", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 12)),)
                                  ],
                                ),
                              ),

                              InkWell(
                                onTap: (){
                                  Navigator.push(context, ExitPage(page: PageReqAttendanceHome(widget.getKaryawanNo, widget.getKaryawanNama)));
                                  //
                                  /* showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return SingleChildScrollView(
                                          child : Container(
                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 25,right: 25,top: 25),
                                              child: Column(
                                                children: [
                                                 Padding(padding: EdgeInsets.only(left: 7),child:
                                                 Align(alignment: Alignment.centerLeft,child: Text("Attendance Type",
                                                   style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold,fontSize: 22),)),),
                                                  Padding(padding: EdgeInsets.only(top: 15,bottom: 25),
                                                    child: Column(
                                                      children: [
                                                     InkWell(
                                                       child: Card(
                                                           elevation: 0,
                                                           shape: RoundedRectangleBorder(
                                                             side: BorderSide(
                                                                 color: HexColor("#DDDDDD")
                                                             ),
                                                             borderRadius: BorderRadius.circular(15.0),
                                                           ),
                                                           child: Padding(
                                                             padding: EdgeInsets.all(5),
                                                             child:    ListTile(
                                                               title: Text("Attendance Correction", style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold,
                                                                   fontSize: 17),),
                                                               subtitle: Text("Koreksi kehadiran kamu ", style: GoogleFonts.nunitoSans(
                                                                   fontSize: 14)),
                                                             ),
                                                           )
                                                       ),
                                                       onTap: (){
                                                         Navigator.pop(context);
                                                        /* Navigator.push(
                                                             context,
                                                             MaterialPageRoute(builder: (context) => RequestAttendance(widget.getKaryawanNo,"Correction")));*/
                                                         Navigator.push(context, ExitPage(page: RequestAttendance(widget.getKaryawanNo,"Correction")));
                                                       },
                                                     ),
                                                       InkWell(
                                                         child:  Card(
                                                             elevation: 0,
                                                             shape: RoundedRectangleBorder(
                                                               side: BorderSide(
                                                                   color: HexColor("#DDDDDD")
                                                               ),
                                                               borderRadius: BorderRadius.circular(15.0),
                                                             ),
                                                             child: Padding(
                                                               padding: EdgeInsets.all(5),
                                                               child:    ListTile(
                                                                 title: Text("Attendance Request", style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold,
                                                                     fontSize: 17),),
                                                                 subtitle: Text("Permintaan kehadiran diluar shift kamu", style: GoogleFonts.nunitoSans(
                                                                     fontSize: 14)),
                                                               ),
                                                             )
                                                         ),
                                                         onTap: (){},
                                                       )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      );
                                    });*/
                                },
                                child:Column(
                                  children: [
                                    Container(
                                        height: 45, width: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: HexColor("#f7faff"),
                                          border: Border.all(
                                            //color: HexColor("#1c6bea"),
                                            color : HexColor("#DDDDDD"),
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: FaIcon(FontAwesomeIcons.userClock, color: HexColor("#1c6bea"), size: 21,),
                                        )
                                    ),
                                    Padding(padding: const EdgeInsets.only(top:8),
                                      child: Text("Request", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 12)),)
                                  ],
                                ),
                              ),

                              InkWell(
                                onTap: (){
                                  Navigator.push(context, ExitPage(page: MySchedule(widget.getKaryawanNo)));

                                },
                                child:Column(
                                  children: [
                                    Container(
                                        height: 45, width: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: HexColor("#fff4f0"),
                                          border: Border.all(
                                            //color: HexColor("#ff8556"),
                                            color : HexColor("#DDDDDD"),
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: FaIcon(FontAwesomeIcons.calendarDay, color: HexColor("#ff8556"), size: 24,),
                                        )
                                    ),
                                    Padding(padding: const EdgeInsets.only(top:8),
                                      child: Text("Attendance", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 12)),)
                                  ],
                                ),
                              ),

                              Opacity(
                                opacity: 0.5,
                                child:  InkWell(
                                  onTap: (){

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                          height: 45, width: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: HexColor("#e8e8e8"),
                                            border: Border.all(
                                              //color: HexColor("#ff8556"),
                                              color : HexColor("#DDDDDD"),
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Center(
                                            child: FaIcon(FontAwesomeIcons.clipboard, color: HexColor("#646464"), size: 24,),
                                          )
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:8),
                                        child: Text("Reimburs", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 12)),)
                                    ],
                                  ),
                                ),
                              ),


                              Opacity(
                                opacity: 0.5,
                                child:  InkWell(
                                  onTap: (){
                                    // Navigator.push(context, ExitPage(page: PageRedeemPoint())).then(onGoBack);
                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                          height: 45, width: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: HexColor("#e8e8e8"),
                                            border: Border.all(
                                              //color: HexColor("#6238b6"),
                                              color : HexColor("#DDDDDD"),
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Center(
                                            child: FaIcon(FontAwesomeIcons.users, color: HexColor("#646464"), size: 24,),
                                          )
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:8),
                                        child: Text("My Teams", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 12)),)
                                    ],
                                  ),
                                ),
                              ),



                              Opacity(
                                opacity: 0.5,
                                child:  InkWell(
                                  onTap: (){
                                    // Navigator.push(context, ExitPage(page: PageRedeemPoint())).then(onGoBack);
                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                          height: 45, width: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: HexColor("#e8e8e8"),
                                            border: Border.all(
                                              //color: HexColor("#6238b6"),
                                              color : HexColor("#DDDDDD"),
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Center(
                                            child: FaIcon(FontAwesomeIcons.computer, color: HexColor("#646464"), size: 24,),
                                          )
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:8),
                                        child: Text("My Assets", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 12)),)
                                    ],
                                  ),
                                ),
                              ),



                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Opacity(opacity: 0.5, child: Container(height: 4, width: double.infinity, color: HexColor("#DDDDDD"),),)),

                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Center(
                                child :
                                Text("Kehadiran",style: GoogleFonts.varela(fontWeight: FontWeight.bold,fontSize: 16),)
                            ),
                          ),

                          Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child:
                              Table(
                                border: TableBorder.all(
                                    color: HexColor("#DDDDDD"),
                                    style: BorderStyle.solid,
                                    width: 1),
                                children: [
                                  TableRow(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0))
                                      ),
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(10),
                                            child :  Align(
                                              alignment : Alignment.centerLeft,
                                              child: Text('Hari ini, ('+ AppHelper().getTanggal_nohari().toString()+')' , style:
                                              GoogleFonts.nunitoSans(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold)),
                                            )
                                        )
                                      ]),
                                  TableRow( children: [
                                    Column(children:[
                                      Padding(padding: const EdgeInsets.only(top: 10,right: 10,left: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              height: 70,
                                              width: 145,
                                              child:    ListTile(
                                                  dense: true,
                                                  leading: FaIcon(FontAwesomeIcons.clock, color: HexColor("#128C7E"), size: 36,),
                                                  title: Column(
                                                    children: [
                                                      Align(alignment: Alignment.centerLeft,child:Padding(padding: const EdgeInsets.only(top: 11,
                                                          left: 2),
                                                        child: Opacity(
                                                          opacity: 0.5,
                                                          child: Text("Jam Masuk",style: GoogleFonts.lato(fontSize: 10,color: Colors.black,
                                                              fontWeight: FontWeight.bold)),
                                                        ),),),
                                                      Align(alignment: Alignment.centerLeft,child: Padding(padding: const EdgeInsets.only(top: 5),
                                                        child: Text(getJamMasuk.toString() == "0" ||
                                                            getJamMasuk.toString() == "00:00" ? "-" : getJamMasuk.toString(),style: GoogleFonts.lato(fontSize: 19,color: Colors.black,
                                                            fontWeight: FontWeight.bold)),),)
                                                    ],
                                                  )
                                              ),
                                            ),
                                            Container(
                                              height: 70,
                                              width: 145,
                                              child:    ListTile(
                                                  dense: true,
                                                  leading: FaIcon(FontAwesomeIcons.clock, color: HexColor("#128C7E"), size: 35,),
                                                  title: Column(
                                                    children: [
                                                      Align(alignment: Alignment.centerLeft,child:Padding(padding: const EdgeInsets.only(top: 10,
                                                          left: 2),
                                                        child: Opacity(
                                                          opacity: 0.5,
                                                          child: Text("Jam Keluar",style: GoogleFonts.lato(fontSize: 10,color: Colors.black,
                                                              fontWeight: FontWeight.bold)),
                                                        ),),),
                                                      Align(alignment: Alignment.centerLeft,child: Padding(padding: const EdgeInsets.only(top: 5),
                                                        child: Text(
                                                            getJamKeluar.toString() == "0" ||
                                                                getJamKeluar.toString() == "00:00" ? "-" : getJamKeluar.toString(),style: GoogleFonts.lato(fontSize: 19,color: Colors.black,
                                                            fontWeight: FontWeight.bold)),),)
                                                    ],
                                                  )
                                              ),
                                            ),

                                          ],
                                        ),),
                                    ]),
                                  ]),
                                ],
                              )
                          ),



                          Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child:
                              Table(
                                border: TableBorder.all(
                                    color: HexColor("#DDDDDD"),
                                    style: BorderStyle.solid,
                                    width: 1),
                                children: [
                                  TableRow(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0))
                                      ),
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(10),
                                            child :  Align(
                                              alignment : Alignment.centerLeft,
                                              child: Text('Kemarin, ('+ AppHelper().getTanggal_nohari_before().toString()+')' , style:
                                              GoogleFonts.nunitoSans(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold)),
                                            )
                                        )
                                      ]),
                                  TableRow( children: [
                                    Column(children:[
                                      Padding(padding: const EdgeInsets.only(top: 10,right: 10,left: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              height: 70,
                                              width: 145,
                                              child:    ListTile(
                                                  dense: true,
                                                  leading: FaIcon(FontAwesomeIcons.clock, color: HexColor("#128C7E"), size: 36,),
                                                  title: Column(
                                                    children: [
                                                      Align(alignment: Alignment.centerLeft,child:Padding(padding: const EdgeInsets.only(top: 11,
                                                          left: 2),
                                                        child: Opacity(
                                                          opacity: 0.5,
                                                          child: Text("Jam Masuk",style: GoogleFonts.lato(fontSize: 10,color: Colors.black,
                                                              fontWeight: FontWeight.bold)),
                                                        ),),),
                                                      Align(alignment: Alignment.centerLeft,child: Padding(padding: const EdgeInsets.only(top: 5),
                                                        child: Text(widget.getJamMasukSebelum.toString() == "0" ? "-" : widget.getJamMasukSebelum.toString(),style: GoogleFonts.lato(fontSize: 19,color: Colors.black,
                                                            fontWeight: FontWeight.bold)),),)
                                                    ],
                                                  )
                                              ),
                                            ),
                                            Container(
                                              height: 70,
                                              width: 145,
                                              child:    ListTile(
                                                  dense: true,
                                                  leading: FaIcon(FontAwesomeIcons.clock, color: HexColor("#128C7E"), size: 35,),
                                                  title: Column(
                                                    children: [
                                                      Align(alignment: Alignment.centerLeft,child:Padding(padding: const EdgeInsets.only(top: 10,
                                                          left: 2),
                                                        child: Opacity(
                                                          opacity: 0.5,
                                                          child: Text("Jam Keluar",style: GoogleFonts.lato(fontSize: 10,color: Colors.black,
                                                              fontWeight: FontWeight.bold)),
                                                        ),),),
                                                      Align(alignment: Alignment.centerLeft,child: Padding(padding: const EdgeInsets.only(top: 5),
                                                        child: Text(
                                                            widget.getJamKeluarSebelum.toString() == "0" ? "-" : widget.getJamKeluarSebelum.toString(),style: GoogleFonts.lato(fontSize: 19,color: Colors.black,
                                                            fontWeight: FontWeight.bold)),),)
                                                    ],
                                                  )
                                              ),
                                            ),

                                          ],
                                        ),),
                                    ]),
                                  ]),
                                ],
                              )
                          ),
                        ],
                      )
                  ),

                ],
              ),
            )
          )
        ),


      ), onWillPop: onWillPop);
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