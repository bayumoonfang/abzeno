


import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/page_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'page_DetailFileAttendanceReq.dart';


class TimeOffApproveDetail extends StatefulWidget{
  final String getTimeOffCode;
  final String getKaryawanNo;
  final String getKaryawanNama;
  const TimeOffApproveDetail(this.getTimeOffCode,this.getKaryawanNo, this.getKaryawanNama);
  @override
  _TimeOffApproveDetail createState() => _TimeOffApproveDetail();
}


class _TimeOffApproveDetail extends State<TimeOffApproveDetail> {
  bool _isPressed = false;
  TextEditingController _rejectnote1 = TextEditingController();
  TextEditingController _rejectnote2 = TextEditingController();
  TextEditingController _approveNote1 = TextEditingController();
  TextEditingController _approveNote2 = TextEditingController();


  String timeoff_reqBy = "...";
  String timeoff_datefrom = "2022-05-23";
  String timeoff_dateto = "2022-05-23";
  String timeoff_jumlahhari = "...";
  String timeoff_number = "...";
  String timeoff_tipe = "...";
  String timeoff_saldo = "...";
  String timeoff_description = "...";
  String timeoff_needtime = "...";
  String timeoff_starttime = "...";
  String timeoff_endtime = "...";
  String timeoff_status = "...";
  String timeoff_jabatan1 = "...";
  String timeoff_jabatan2 = "...";

  String timeoff_appr1_name = "...";
  String timeoff_appr1_date = "...";
  String timeoff_appr1_status = "...";
  String timeoff_appr1_note = "...";
  String timeoff_appr2_name = "...";
  String timeoff_appr2_date = "...";
  String timeoff_appr2_status = "...";
  String timeoff_appr2_note = "...";
  String timeoff_delegate = "...";
  String timeoff_delegate_name = "...";
  String timeoff_appr1 = "...";
  String timeoff_appr2 = "...";
  String timeoff_file = "...";
  _getTimeOffDetail() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      AppHelper().showFlushBarsuccess(context, "Koneksi Putus");
      EasyLoading.dismiss();
      return false;
    }});
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getTimeOffDetail&timeoffcode=" +
            widget.getTimeOffCode+"&getKaryawanNo="+widget.getKaryawanNo)).timeout(
        Duration(seconds: 10), onTimeout: () {
      AppHelper().showFlushBarsuccess(context, "Koneksi terputus..");
      EasyLoading.dismiss();
      http.Client().close();
      return http.Response('Error', 500);
    }
    );
    Map data = jsonDecode(response.body);
    setState(() {
      EasyLoading.dismiss();
      timeoff_reqBy = data["attrequest_reqby_name"].toString();
      timeoff_datefrom = data["attrequest_datefrom"].toString();
      timeoff_dateto = data["attrequest_dateto"].toString();
      timeoff_jumlahhari = data["attrequest_numdays"].toString();
      timeoff_number = data["attrequest_number"].toString();
      timeoff_tipe = data["setttimeoff_name"].toString();
      timeoff_saldo = data["timeoff_quota"].toString();
      timeoff_description = data["attrequest_description"].toString();
      timeoff_needtime = data["attrequest_needtime"].toString();
      timeoff_starttime= data["attrequest_timefrom"].toString();
      timeoff_endtime = data["attrequest_timeto"].toString();
      timeoff_status = data["attrequest_status"].toString();
      timeoff_jabatan1 = data["jabatan_nama1"].toString();
      timeoff_jabatan2 = data["jabatan_nama2"].toString();
      timeoff_appr1_name = data["attrequest_appr1_name"].toString();
      timeoff_appr1_date = data["attrequest_dateappr1"].toString();
      timeoff_appr1_status = data["attrequest_appr1_status"].toString();
      timeoff_appr1_note = data["attrequest_appr1_note"].toString();
      timeoff_appr2_name = data["attrequest_appr2_name"].toString();
      timeoff_appr2_date = data["attrequest_dateappr2"].toString();
      timeoff_appr2_status = data["attrequest_appr2_status"].toString();
      timeoff_appr2_note = data["attrequest_appr2_note"].toString();
      timeoff_delegate = data["attrequest_delegated"].toString();
      timeoff_delegate_name = data["attrequest_delegated_name"].toString();
      timeoff_appr1 = data["attrequest_appr1"].toString();
      timeoff_appr2 = data["attrequest_appr2"].toString();
      timeoff_file = data["attrequest_file"].toString();
      //saldoTimeOff = data["timeoff_quota"].toString();
    });
  }


  loadData2() async {
    await _getTimeOffDetail();
    EasyLoading.dismiss();
  }


  @override
  void initState() {
    super.initState();
    loadData2();
    setState(() {
      _isPressed = false;
    });
  }



  var noteApproveVal;
  _approvedRequest(String valApp2) async {
    EasyLoading.show(status: "Loading...");
    setState(() {
      _isPressed = true;
      if(valApp2== "1") {
        noteApproveVal = _approveNote1.text;
      } else {
        noteApproveVal = _approveNote2.text;
      }
    });
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      AppHelper().showFlushBarsuccess(context, "Koneksi Putus");
      EasyLoading.dismiss();
      return false;
    }});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=approveRequest"), body: {
      "approve_timeoffnumber": timeoff_number,
      "approve_timeoffkaryawanno": widget.getKaryawanNo,
      "approve_timeoffapp": valApp2,
      "approve_timeoffNote" : noteApproveVal
    }).timeout(Duration(seconds: 10),onTimeout: (){
      http.Client().close();
      AppHelper().showFlushBarerror(context, "Koneksi Terputus, silahkan ulangi sekali lagi");
      return http.Response('Error',500);
    });
    Map data = jsonDecode(response.body);
    setState(() {
      if(data["message"] != '') {
        EasyLoading.dismiss();
        if(data["message"] == '1') {
          //Navigator.pushReplacement(context, ExitPage(page: Home()));
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          AppHelper().showFlushBarconfirmed(context, "Time Off Request has been Approved");
          loadData2();
        } else {
          AppHelper().showFlushBarsuccess(context, data["message"]);
          //print(data["message"]);
          return;
        }
      }
    });
  }


  var noteRejectVal;
  _rejectRequest(String valApp) async {
    EasyLoading.show(status: "Loading...");
    setState(() {
      _isPressed = true;
      if(valApp == "1") {
        noteRejectVal = _rejectnote1.text;
      } else {
        noteRejectVal = _rejectnote2.text;
      }
    });
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      AppHelper().showFlushBarsuccess(context, "Koneksi Putus");
      EasyLoading.dismiss();
      return false;
    }});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=rejectRequest"), body: {
      "reject_timeoffnumber": timeoff_number,
      "reject_timeoffkaryawanno": widget.getKaryawanNo,
      "reject_timeoffapp": valApp,
      "reject_timeoffNote" : noteRejectVal
    }).timeout(Duration(seconds: 10),onTimeout: (){
      http.Client().close();
      AppHelper().showFlushBarerror(context, "Koneksi Terputus, silahkan ulangi sekali lagi");
      return http.Response('Error',500);
    });
    Map data = jsonDecode(response.body);
    setState(() {
      if(data["message"] != '') {
        EasyLoading.dismiss();
        if(data["message"] == '1') {
          //Navigator.pushReplacement(context, ExitPage(page: Home()));
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          AppHelper().showFlushBarconfirmed(context, "Time Off Request has been Reject");
          loadData2();
        } else {
          AppHelper().showFlushBarsuccess(context, data["message"]);
          return;
        }
      }
    });
  }



  showDialogReject1(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: GoogleFonts.nunito(color: Colors.black)),
      onPressed:  () {Navigator.pop(context);_rejectnote1.clear();},
    );
    Widget continueButton = TextButton(
      child: Text("Reject", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: HexColor("#e21b4c"))),
      onPressed:  () {
        _rejectRequest("1");
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Reject Request", style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold)),
      content: Text("Would you like to continue reject this request as Approval 1 ?", style: GoogleFonts.nunitoSans(),),
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



  showDialogReject2(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: GoogleFonts.nunito(color: Colors.black)),
      onPressed:  () {Navigator.pop(context);_rejectnote2.clear();},
    );
    Widget continueButton = TextButton(
      child: Text("Reject", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: HexColor("#e21b4c"))),
      onPressed:  () {
        _rejectRequest("2");
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Reject Request", style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold)),
      content: Text("Would you like to continue reject this request as Approval 2 ?", style: GoogleFonts.nunitoSans(),),
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

  showDialog1(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: GoogleFonts.nunito(color: Colors.black)),
      onPressed:  () {Navigator.pop(context);_approveNote1.clear();},
    );
    Widget continueButton = TextButton(
      child: Text("Approve", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: HexColor("#1a76d2"))),
      onPressed:  () {
        _approvedRequest("1");
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Approve Request", style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold)),
      content: Text("Would you like to continue approve this request as Approval 1 ?", style: GoogleFonts.nunitoSans(),),
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


  showDialog2(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: GoogleFonts.nunito(color: Colors.black)),
      onPressed:  () {
          Navigator.pop(context);
          _approveNote2.clear();
        },
    );
    Widget continueButton = TextButton(
      child: Text("Approve", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: HexColor("#1a76d2"))),
      onPressed:  () {
        _approvedRequest("2");
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Approve Request", style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold)),
      content: Text("Would you like to continue approve this request as Approval 2 ?", style: GoogleFonts.nunitoSans(),),
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
        //shape: Border(bottom: BorderSide(color: Colors.red)),
        backgroundColor: HexColor("#3a5664"),
        title: Text("Detail Time Off", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
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
      body:Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(left: 25,right: 25,top: 35,bottom: 80),
          child:
          SingleChildScrollView(
    child :
          Column(
              children: [
          Row(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
           Flexible(child:    Padding(
             padding: EdgeInsets.only(bottom: 10),
             child: Align(
               alignment: Alignment.centerLeft,
               child: Column(
                 children: [
                   Align(
                     alignment: Alignment.centerLeft,
                     child:Text("Time Off Number",
                         style: GoogleFonts.nunito(fontSize: 13)),),
                   Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: 5),
                     child: Text(timeoff_number.toString(), style: GoogleFonts.montserrat(fontSize: 19,fontWeight: FontWeight.bold)),))
                 ],
               ),
             ),
           ),),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Align(alignment: Alignment.centerLeft,child: Text("Status",
                          style: GoogleFonts.nunito(fontSize: 13)),),
                      Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: 5),
                        child:
                       Container(
                            child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                side: BorderSide(
                                  width: 1,
                                  color: timeoff_status.toString() == 'Pending'? Colors.black54 :
                                  timeoff_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                                  timeoff_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                  HexColor("#FF4136"),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Text(timeoff_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                  color: timeoff_status.toString() == 'Pending'? Colors.black54 :
                                  timeoff_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                                  timeoff_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                  HexColor("#FF4136")),),
                              onPressed: (){},
                            ),
                            height: 25,
                          ),))
                    ],
                  ),
                ),
              ),
            ],
          ),
      Padding(
        padding: EdgeInsets.only(bottom: 10),
      child: Divider(height: 3,),),

                 Card(
                   child: Padding(
                     padding: EdgeInsets.all(18),
                     child: Column(
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text("Request By", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                             Text(timeoff_reqBy.toString(), style: GoogleFonts.nunito(fontSize: 14),),],
                         ),



                         Padding(
                           padding: EdgeInsets.only(top: 10),
                           child:  Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("Delegate", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                               Text(
                                   timeoff_delegate == 'null' ? '-' : timeoff_delegate_name,
                                   style: GoogleFonts.nunito(fontSize: 14)),],
                           ),
                         ),




                         Padding(
                           padding: EdgeInsets.only(top: 10),
                           child:  Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("Start Date", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                               Text(
                                   AppHelper().getTanggalCustom(timeoff_datefrom.toString()) + " "+
                                       AppHelper().getNamaBulanCustomSingkat(timeoff_datefrom.toString()) + " "+
                                       AppHelper().getTahunCustom(timeoff_datefrom.toString()),
                                   style: GoogleFonts.nunito(fontSize: 14)),],
                           ),
                         ),
                         Padding(
                           padding: EdgeInsets.only(top: 10),
                           child:  Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("End Date", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                               Text(
                                   AppHelper().getTanggalCustom(timeoff_dateto.toString()) + " "+
                                       AppHelper().getNamaBulanCustomSingkat(timeoff_dateto.toString()) + " "+
                                       AppHelper().getTahunCustom(timeoff_dateto.toString()),
                                   style: GoogleFonts.nunito(fontSize: 14)),],
                           ),
                         ),
                         timeoff_needtime.toString() == 'Yes' ?
                         Padding(
                           padding: EdgeInsets.only(top: 10),
                           child:  Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("Start Time", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                               Text(timeoff_starttime.toString().substring(0,5),
                                   style: GoogleFonts.nunito(fontSize: 14)),],
                           ),
                         ) : Container(),

                         timeoff_needtime.toString() == 'Yes' ?
                         Padding(
                           padding: EdgeInsets.only(top: 10),
                           child:  Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("End Time", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                               Text(timeoff_endtime.toString().substring(0,5),
                                   style: GoogleFonts.nunito(fontSize: 14)),],
                           ),
                         ) : Container(),


                         Padding(
                           padding: EdgeInsets.only(top: 10),
                           child:  Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("Number Days", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                               Text(timeoff_jumlahhari.toString()+" hari",
                                   style: GoogleFonts.nunito(fontSize: 14)),],
                           ),
                         ),

                         Padding(
                           padding: EdgeInsets.only(top: 10),
                           child:  Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("Time Off Type", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                               Text(timeoff_tipe.toString(),
                                   style: GoogleFonts.nunito(fontSize: 14)),],
                           ),
                         ),

                         timeoff_saldo.toString() != '99' ?
                         Padding(
                           padding: EdgeInsets.only(top: 10),
                           child:  Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("Saldo", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                               Text(timeoff_saldo.toString()+" hari",
                                   style: GoogleFonts.nunito(fontSize: 14)),],
                           ),
                         ) : Container(),

                         Padding(
                           padding: EdgeInsets.only(top: 10),
                           child:  Column(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Align(
                                 alignment: Alignment.centerLeft,
                                 child:  Text("Description", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14,
                                     fontWeight: FontWeight.bold),),
                               ),
                               Align(
                                   alignment: Alignment.centerLeft,
                                   child:  Text(timeoff_description.toString(),
                                       style: GoogleFonts.nunito(fontSize: 14)))
                             ],
                           ),
                         ),



                         timeoff_file.toString() != "" ?
                         Padding(
                           padding: EdgeInsets.only(top: 10),
                           child:  Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text("Attachment", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                                 GestureDetector(
                                   child : Hero(
                                     tag: timeoff_file.toString() ,
                                     child : Text("Tap to view the attachment", style: GoogleFonts.nunito(fontSize: 14,color: Colors.blue,fontWeight:
                                     FontWeight.bold)),

                                   ),
                                   onTap: (){
                                     Navigator.of(context).push(
                                         new MaterialPageRoute(
                                             builder: (BuildContext context) => DetailImageAttRequest(timeoff_file.toString())));
                                   },
                                 ),
                               ]
                           ),
                         ) : Container(),



                       ],
                     ),
                   ),
                 ),


                Padding(
                  padding: EdgeInsets.only(top: 20,bottom: 20),
                  child: Divider(height: 3,),),




                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(alignment: Alignment.centerLeft,child: Text("Approval List",
                          style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold)),),
                      Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                          ),
                          child: Text("Show All"),
                          onPressed: (){
                            showModalBottomSheet(
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
                                              Align(alignment: Alignment.centerLeft,child: Text("Approval List",
                                                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                              Padding(
                                                padding: EdgeInsets.only(top:15),
                                                child: Divider(height: 2,),
                                              ),
                                              Padding(padding: EdgeInsets.only(top: 5,bottom: 10),
                                                child: Column(
                                                  children: [


                                                    Container(
                                                        child:  Padding(padding: EdgeInsets.only(top: 8),
                                                            child: ListTile(
                                                                minLeadingWidth : 10,
                                                                leading: Transform.translate(
                                                                    offset: Offset(-16, 0),
                                                                    child :Container(
                                                                      width: 45,
                                                                      height: 45,
                                                                      decoration: new BoxDecoration(
                                                                          shape: BoxShape.circle, border: Border.all(
                                                                        color: HexColor("#DDDDDD"),
                                                                        width: 1,
                                                                      )
                                                                      ),
                                                                      child: CircleAvatar(
                                                                        backgroundColor: Colors.white,
                                                                        backgroundImage: AssetImage(
                                                                            'assets/user.png'),
                                                                      ),)),
                                                                title:  Transform.translate(
                                                                    offset: Offset(-18, 0),child :Padding(padding: EdgeInsets.only(top: 10),child:
                                                                Text(timeoff_appr1_name.toString(),style: GoogleFonts.montserrat(
                                                                    fontWeight: FontWeight.bold,fontSize: 14),),)),
                                                                subtitle: Transform.translate(
                                                                    offset: Offset(-18, 0),child :Column(
                                                                  children: [
                                                                    Align(alignment: Alignment.centerLeft,child: Text(timeoff_jabatan1,
                                                                        style: GoogleFonts.montserrat(fontSize: 13)),),
                                                                    Padding(padding: EdgeInsets.only(top: 5),
                                                                      child: Align(alignment: Alignment.centerLeft,child: Text(timeoff_appr1_note == '' ? "-" : "#"+timeoff_appr1_note,
                                                                          style: GoogleFonts.montserrat(fontSize: 13,color: Colors.black)),),)
                                                                  ],
                                                                )),
                                                                trailing: Transform.translate(
                                                                    offset: Offset(10, 0),child :Container(
                                                                  width: 100,
                                                                  child: Column(
                                                                    children: [
                                                                      Align(alignment: Alignment.centerRight,child: Text(timeoff_appr1_status,
                                                                          style: GoogleFonts.nunito(fontSize: 13)),),
                                                                      Align(alignment: Alignment.centerRight,child: Text(timeoff_appr1_date == '0000-00-00' ? "-" : timeoff_appr1_date,
                                                                          style: GoogleFonts.nunito(fontSize: 13)),),
                                                                    ],
                                                                  ),
                                                                ))

                                                            )

                                                        )),


                                                    Container(
                                                        child:  Padding(padding: EdgeInsets.only(top: 5),
                                                            child: ListTile(
                                                                minLeadingWidth : 10,
                                                                leading: Transform.translate(
                                                                    offset: Offset(-16, 0),
                                                                    child :Container(
                                                                      width: 45,
                                                                      height: 45,
                                                                      decoration: new BoxDecoration(
                                                                          shape: BoxShape.circle, border: Border.all(
                                                                        color: HexColor("#DDDDDD"),
                                                                        width: 1,
                                                                      )
                                                                      ),
                                                                      child: CircleAvatar(
                                                                        backgroundColor: Colors.white,
                                                                        backgroundImage: AssetImage(
                                                                            'assets/user.png'),
                                                                      ),)),
                                                                title:  Transform.translate(
                                                                    offset: Offset(-18, 0),child :Padding(padding: EdgeInsets.only(top: 10),child:
                                                                Text(timeoff_appr2_name.toString(),style: GoogleFonts.montserrat(
                                                                    fontWeight: FontWeight.bold,fontSize: 14),),)),
                                                                subtitle: Transform.translate(
                                                                    offset: Offset(-18, 0),child :Column(
                                                                  children: [
                                                                    Align(alignment: Alignment.centerLeft,child: Text(timeoff_jabatan2,
                                                                        style: GoogleFonts.montserrat(fontSize: 13)),),
                                                                    Padding(padding: EdgeInsets.only(top: 5),
                                                                      child: Align(alignment: Alignment.centerLeft,child: Text(timeoff_appr2_note == '' ? "-" : "#"+timeoff_appr2_note,
                                                                          style: GoogleFonts.montserrat(fontSize: 13,color: Colors.black)),),)
                                                                  ],
                                                                )),
                                                                trailing: Transform.translate(
                                                                    offset: Offset(10, 0),child :Container(
                                                                  width: 100,
                                                                  child: Column(
                                                                    children: [
                                                                      Align(alignment: Alignment.centerRight,child: Text(timeoff_appr2_status,
                                                                          style: GoogleFonts.nunito(fontSize: 13)),),
                                                                      Align(alignment: Alignment.centerRight,child: Text(timeoff_appr2_date == '0000-00-00' ? "-" :
                                                                      timeoff_appr2_date,
                                                                          style: GoogleFonts.nunito(fontSize: 13)),),
                                                                    ],
                                                                  ),
                                                                ))

                                                            )

                                                        )),

                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      )
                                  );
                                });


                          },
                        ),
                        height: 30,
                      )
                    ]
                ),




              ],
          )),
        ),
      bottomSheet:Container(
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
        width: double.infinity,
        height: 50,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceEvenly,
          children: [


            timeoff_appr1.toString() == widget.getKaryawanNo && timeoff_appr1_status.toString() == 'Waiting Approval' ?
            Container(
                width: 150,
                child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: HexColor("#1a76d2"),
                      elevation: 0,
                      shape: RoundedRectangleBorder(side: BorderSide(
                          color: Colors.white,
                          width: 0.1,
                          style: BorderStyle.solid
                      ),
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                  child: Text("Approve Request",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                      fontSize: 14),),
                  onPressed: () {
                    showModalBottomSheet(
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
                                      Align(alignment: Alignment.centerLeft,child: Text("Approval Note",
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                      Padding(padding: EdgeInsets.only(top: 25,bottom: 25),
                                        child: Column(
                                          children: [
                                            Align(alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 0),
                                                child: TextFormField(
                                                  style: GoogleFonts.workSans(fontSize: 16),
                                                  textCapitalization: TextCapitalization
                                                      .sentences,
                                                  controller: _approveNote1,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.only(
                                                        top: 2),
                                                    hintText: 'Write your notes as approval 1',
                                                    labelText: 'Note',
                                                    labelStyle: TextStyle(fontFamily: "VarelaRound",
                                                        fontSize: 16.5, color: Colors.black87
                                                    ),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    hintStyle: GoogleFonts.nunito(color: HexColor("#c4c4c4"), fontSize: 15),
                                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#8c8989")),
                                                    ),
                                                    border: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                  ),

                                                ),
                                              ),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 60,
                                        padding: EdgeInsets.only(top: 10,bottom: 10),
                                        child:
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: HexColor("#1a76d2"),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(side: BorderSide(
                                                  color: Colors.white,
                                                  width: 0.1,
                                                  style: BorderStyle.solid
                                              ),
                                                borderRadius: BorderRadius.circular(5.0),
                                              )),
                                          child: Text("Approve",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                              fontSize: 14),),
                                          onPressed: () {
                                            showDialog1(context);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          );
                        });
                  },
                )
            ) : Container(),



            timeoff_appr1.toString() == widget.getKaryawanNo && timeoff_appr1_status.toString() == 'Waiting Approval' ?
            Container(
                width: 150,
                child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: HexColor("#e21b4c"),
                      elevation: 0,
                      shape: RoundedRectangleBorder(side: BorderSide(
                          color: Colors.white,
                          width: 0.1,
                          style: BorderStyle.solid
                      ),
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                  child: Text("Reject Request",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                      fontSize: 14),),
                  onPressed: () {
                    showModalBottomSheet(
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
                                        Align(alignment: Alignment.centerLeft,child: Text("Reject Note",
                                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                        Padding(padding: EdgeInsets.only(top: 25,bottom: 25),
                                          child: Column(
                                            children: [
                                              Align(alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 0),
                                                  child: TextFormField(
                                                    style: GoogleFonts.workSans(fontSize: 16),
                                                    textCapitalization: TextCapitalization
                                                        .sentences,
                                                    controller: _rejectnote1,
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.only(
                                                          top: 2),
                                                      hintText: 'Write your notes as approval 1',
                                                      labelText: 'Note',
                                                      labelStyle: TextStyle(fontFamily: "VarelaRound",
                                                          fontSize: 16.5, color: Colors.black87
                                                      ),
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      hintStyle: GoogleFonts.nunito(color: HexColor("#c4c4c4"), fontSize: 15),
                                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                          color: HexColor("#DDDDDD")),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                          color: HexColor("#8c8989")),
                                                      ),
                                                      border: UnderlineInputBorder(borderSide: BorderSide(
                                                          color: HexColor("#DDDDDD")),
                                                      ),
                                                    ),

                                                  ),
                                                ),),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 60,
                                          padding: EdgeInsets.only(top: 10,bottom: 10),
                                          child:
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: HexColor("#e21b4c"),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(side: BorderSide(
                                                    color: Colors.white,
                                                    width: 0.1,
                                                    style: BorderStyle.solid
                                                ),
                                                  borderRadius: BorderRadius.circular(5.0),
                                                )),
                                            child: Text("Reject",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                                fontSize: 14),),
                                            onPressed: () {
                                              showDialogReject1(context);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                           );
                        });
                  },
                )
            ) : Container(),



            timeoff_appr2.toString() == widget.getKaryawanNo &&
                (timeoff_appr1_status.toString() == 'Approved' || timeoff_appr1_status.toString() != 'Rejected'
                    || timeoff_appr1_status.toString() != 'Waiting Approval') &&
                (timeoff_appr2_status.toString() == 'Waiting Approval') ?
            Container(
                width: 150,
                child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: HexColor("#1a76d2"),
                      elevation: 0,
                      shape: RoundedRectangleBorder(side: BorderSide(
                          color: Colors.white,
                          width: 0.1,
                          style: BorderStyle.solid
                      ),
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                  child: Text("Approve Request",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                      fontSize: 14),),
                  onPressed: () {
                    showModalBottomSheet(
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
                                      Align(alignment: Alignment.centerLeft,child: Text("Approval Note",
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                      Padding(padding: EdgeInsets.only(top: 25,bottom: 25),
                                        child: Column(
                                          children: [
                                            Align(alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 0),
                                                child: TextFormField(
                                                  style: GoogleFonts.workSans(fontSize: 16),
                                                  textCapitalization: TextCapitalization
                                                      .sentences,
                                                  controller: _approveNote2,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.only(
                                                        top: 2),
                                                    hintText: 'Write your notes as approval 2',
                                                    labelText: 'Note',
                                                    labelStyle: TextStyle(fontFamily: "VarelaRound",
                                                        fontSize: 16.5, color: Colors.black87
                                                    ),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    hintStyle: GoogleFonts.nunito(color: HexColor("#c4c4c4"), fontSize: 15),
                                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#8c8989")),
                                                    ),
                                                    border: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                  ),

                                                ),
                                              ),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 60,
                                        padding: EdgeInsets.only(top: 10,bottom: 10),
                                        child:
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: HexColor("#1a76d2"),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(side: BorderSide(
                                                  color: Colors.white,
                                                  width: 0.1,
                                                  style: BorderStyle.solid
                                              ),
                                                borderRadius: BorderRadius.circular(5.0),
                                              )),
                                          child: Text("Approve",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                              fontSize: 14),),
                                          onPressed: () {
                                            showDialog2(context);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          );
                        });
                  },
                )
            ) : Container(),


            timeoff_appr2.toString() == widget.getKaryawanNo &&
                (timeoff_appr1_status.toString() == 'Approved' || timeoff_appr1_status.toString() != 'Rejected'
                    || timeoff_appr1_status.toString() != 'Waiting Approval') &&
                (timeoff_appr2_status.toString() == 'Waiting Approval') ?
            Container(
                width: 150,
                child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: HexColor("#e21b4c"),
                      elevation: 0,
                      shape: RoundedRectangleBorder(side: BorderSide(
                          color: Colors.white,
                          width: 0.1,
                          style: BorderStyle.solid
                      ),
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                  child: Text("Reject Request",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                      fontSize: 14),),
                  onPressed: () {
                    showModalBottomSheet(
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
                                      Align(alignment: Alignment.centerLeft,child: Text("Approval Note",
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                      Padding(padding: EdgeInsets.only(top: 25,bottom: 25),
                                        child: Column(
                                          children: [
                                            Align(alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 0),
                                                child: TextFormField(
                                                  style: GoogleFonts.workSans(fontSize: 16),
                                                  textCapitalization: TextCapitalization
                                                      .sentences,
                                                  controller: _rejectnote2,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.only(
                                                        top: 2),
                                                    hintText: 'Write your notes as approval 2',
                                                    labelText: 'Note',
                                                    labelStyle: TextStyle(fontFamily: "VarelaRound",
                                                        fontSize: 16.5, color: Colors.black87
                                                    ),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    hintStyle: GoogleFonts.nunito(color: HexColor("#c4c4c4"), fontSize: 15),
                                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#8c8989")),
                                                    ),
                                                    border: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                  ),

                                                ),
                                              ),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 60,
                                        padding: EdgeInsets.only(top: 10,bottom: 10),
                                        child:
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: HexColor("#e21b4c"),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(side: BorderSide(
                                                  color: Colors.white,
                                                  width: 0.1,
                                                  style: BorderStyle.solid
                                              ),
                                                borderRadius: BorderRadius.circular(5.0),
                                              )),
                                          child: Text("Reject",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                              fontSize: 14),),
                                          onPressed: () {
                                            showDialogReject2(context);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          );
                        });
                  },
                )
            ) : Container(),





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