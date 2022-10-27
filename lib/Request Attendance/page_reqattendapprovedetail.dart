




import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;


class ReqAttendApproveDetail extends StatefulWidget{
  final String getReqAttendCode;
  final String getKaryawanNo;

  const ReqAttendApproveDetail(this.getReqAttendCode,this.getKaryawanNo);
  @override
  _ReqAttendApproveDetail createState() => _ReqAttendApproveDetail();
}

class _ReqAttendApproveDetail extends State<ReqAttendApproveDetail> {

  bool _isPressed = false;

  TextEditingController _rejectnote1 = TextEditingController();
  TextEditingController _rejectnote2 = TextEditingController();
  TextEditingController _approveNote1 = TextEditingController();
  TextEditingController _approveNote2 = TextEditingController();



  String reqattend_status = "...";
  String reqattend_date = "2022-05-23";
  String reqattend_type = "...";
  String reqattend_scheduleclockin = "...";
  String reqattend_scheduleclockout = "...";
  String reqattend_clockin = "...";
  String reqattend_clockout = "...";
  String reqattend_description = "...";
  String reqattend_approv1 = "...";
  String reqattend_approve1_status = "...";
  String reqattend_approve1_date = "...";
  String reqattend_approv1_nama = "...";
  String reqattend_approv1_jabatan = "...";

  String reqattend_approv2 = "...";
  String reqattend_approve2_status = "...";
  String reqattend_approve2_date = "...";
  String reqattend_approv2_nama = "...";
  String reqattend_approv2_jabatan = "...";
  String reqattend_datecreated = "2022-05-23";


  _getReqAttendDetail() async {
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getReqAttendDetail&reqattendcode=" +
            widget.getReqAttendCode+"&getKaryawanNo="+widget.getKaryawanNo)).timeout(
        Duration(seconds: 10), onTimeout: () {
      AppHelper().showFlushBarsuccess(context, "Koneksi terputus..");
      http.Client().close();
      return http.Response('Error', 500);
    }
    );
    Map data = jsonDecode(response.body);
    setState(() {
      EasyLoading.dismiss();
      reqattend_status = data["reqattend_status"].toString();
      reqattend_type = data["reqattend_type"].toString();
      reqattend_date = data["reqattend_date"].toString();
      reqattend_scheduleclockin = data["reqattend_scheduleclockin"].toString();
      reqattend_scheduleclockout = data["reqattend_scheduleclockout"].toString();
      reqattend_clockin = data["reqattend_clockin"].toString();
      reqattend_clockout = data["reqattend_clockout"].toString();
      reqattend_description = data["reqattend_description"].toString();
      reqattend_approv1 = data["reqattend_approv1"].toString();
      reqattend_approve1_status = data["reqattend_approve1_status"].toString();
      reqattend_approve1_date = data["reqattend_approve1_date"].toString();
      reqattend_approv1_nama = data["reqattend_approv1_nama"].toString();
      reqattend_approv1_jabatan = data["reqattend_approv1_jabatan"].toString();
      reqattend_approv2 = data["reqattend_approv2"].toString();
      reqattend_approve2_status = data["reqattend_approve2_status"].toString();
      reqattend_approve2_date = data["reqattend_approve2_date"].toString();
      reqattend_approv2_nama = data["reqattend_approv2_nama"].toString();
      reqattend_approv2_jabatan = data["reqattend_approv2_jabatan"].toString();
      reqattend_datecreated = data["reqattend_datecreated"].toString();

    });
  }



  loadData2() async {
    await _getReqAttendDetail();
    EasyLoading.dismiss();
  }


  @override
  void initState() {
    super.initState();
    loadData2();
  }



  _approvedRequest(String valApp2) async {
    EasyLoading.show(status: "Loading...");
    setState(() {
      _isPressed = true;
    });
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=approveRequestAttend"), body: {
      "approve_reqattendnumber": widget.getReqAttendCode,
      "approve_reqattendkaryawanno": widget.getKaryawanNo,
      "approve_reqattendapp": valApp2,
      "approve_type" : reqattend_type.toString()
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
          AppHelper().showFlushBarconfirmed(context, "Request has been Approved");
          loadData2();
        } else {
          AppHelper().showFlushBarsuccess(context, data["message"]);
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
    });
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=rejectRequestAttend"), body: {
      "reject_reqattendnumber": widget.getReqAttendCode,
      "reject_reqattendkaryawanno": widget.getKaryawanNo,
      "reject_reqattendapp": valApp
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
          AppHelper().showFlushBarconfirmed(context, "Request has been Reject");
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
      title: Text("Reject Request", style: GoogleFonts.nunito(fontSize: 18,fontWeight: FontWeight.bold)),
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
      title: Text("Reject Request", style: GoogleFonts.nunito(fontSize: 18,fontWeight: FontWeight.bold)),
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
      title: Text("Approve Request", style: GoogleFonts.nunito(fontSize: 18,fontWeight: FontWeight.bold)),
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
      title: Text("Approve Request", style: GoogleFonts.nunito(fontSize: 18,fontWeight: FontWeight.bold)),
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
        //backgroundColor: HexColor("#128C7E"),
        backgroundColor: HexColor("#3a5664"),
        title: Text("Detail Request Attendance", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
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
      child: SingleChildScrollView(
        child : Column(
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
                          child:Text("Request Number",
                              style: GoogleFonts.nunito(fontSize: 13)),),
                        Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: 5),
                          child: Text(widget.getReqAttendCode.toString(), style: GoogleFonts.montserrat(fontSize: 19,fontWeight: FontWeight.bold)),))
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
                                  color: reqattend_status.toString() == 'Pending'? Colors.black54 :
                                  reqattend_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                                  reqattend_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                  HexColor("#FF4136"),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Text(reqattend_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                  color: reqattend_status.toString() == 'Pending'? Colors.black54 :
                                  reqattend_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                                  reqattend_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
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
              padding: EdgeInsets.only(bottom:10),
              child: Divider(height: 3,),),

            Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Request Type", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                          Text(reqattend_type.toString(), style: GoogleFonts.nunito(fontSize: 14),),],
                      ),


                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                            Text(
                                AppHelper().getTanggalCustom(reqattend_date.toString()) + " "+
                                    AppHelper().getNamaBulanCustomFull(reqattend_date.toString()) + " "+
                                    AppHelper().getTahunCustom(reqattend_date.toString()),
                                style: GoogleFonts.nunito(fontSize: 14)),],
                        ),
                      ),


                      reqattend_type.toString() == "Correction" ?
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Schedule Clock In", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                                Text(reqattend_scheduleclockin.toString(),
                                    style: GoogleFonts.nunito(fontSize: 14)),],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Schedule Clock In", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                                Text(reqattend_scheduleclockout.toString(),
                                    style: GoogleFonts.nunito(fontSize: 14)),],
                            ),
                          ),
                        ],
                      ) : Container(),

                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Clock In Request", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                            Text(reqattend_clockin.toString(),
                                style: GoogleFonts.nunito(fontSize: 14)),],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Clock Out Request", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                            Text(reqattend_clockout.toString(),
                                style: GoogleFonts.nunito(fontSize: 14)),],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date Created", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                            Text( AppHelper().getTanggalCustom(reqattend_datecreated.toString()) + " "+
                                AppHelper().getNamaBulanCustomFull(reqattend_datecreated.toString()) + " "+
                                AppHelper().getTahunCustom(reqattend_datecreated.toString()),
                                style: GoogleFonts.nunito(fontSize: 14)),],
                        ),
                      ),

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
                                child:  Text(reqattend_description.toString(),
                                    style: GoogleFonts.nunito(fontSize: 14)))
                          ],
                        ),
                      ),


                    ],
                  ),

                )),


            Padding(
              padding: EdgeInsets.only(top: 20,bottom: 20),
              child: Divider(height: 3,),),

            Align(alignment: Alignment.centerLeft,child: Text("Approval List",
                style: GoogleFonts.nunito(fontSize: 17,fontWeight: FontWeight.bold)),),

            Container(
                child:  Padding(padding: EdgeInsets.only(top: 15),
                    child: ListTile(
                        leading: Transform.translate(
                            offset: Offset(-16, -10),
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
                            offset: Offset(-18, -10),child :Padding(padding: EdgeInsets.only(top: 10),child: Text(reqattend_approv1_nama.toString(),style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,fontSize: 15),),)),
                        subtitle: Transform.translate(
                            offset: Offset(-18, -10),child :Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,child: Text(reqattend_approv1_jabatan,
                                style: GoogleFonts.nunito(fontSize: 13)),),
                          ],
                        )),
                        trailing: Transform.translate(
                            offset: Offset(10, 0),child :Container(
                          width: 100,
                          child: Column(
                            children: [
                              Align(alignment: Alignment.centerRight,child: Text(reqattend_approve1_status,
                                  style: GoogleFonts.nunito(fontSize: 13)),),
                              Align(alignment: Alignment.centerRight,child: Text(reqattend_approve1_date == '0000-00-00' ? "-" : reqattend_approve1_date,
                                  style: GoogleFonts.nunito(fontSize: 13)),),
                            ],
                          ),
                        ))

                    )

                )),


            Container(
                child:  Padding(padding: EdgeInsets.only(top: 5),
                    child: ListTile(
                        leading: Transform.translate(
                            offset: Offset(-16, -10),
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
                            offset: Offset(-18, -10),child :Padding(padding: EdgeInsets.only(top: 10),child: Text(reqattend_approv2_nama.toString(),style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,fontSize: 15),),)),
                        subtitle: Transform.translate(
                            offset: Offset(-18, -10),child :Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,child: Text(reqattend_approv2_jabatan,
                                style: GoogleFonts.nunito(fontSize: 13)),),
                          ],
                        )),
                        trailing: Transform.translate(
                            offset: Offset(10, 0),child :Container(
                          width: 100,
                          child: Column(
                            children: [
                              Align(alignment: Alignment.centerRight,child: Text(reqattend_approve2_status,
                                  style: GoogleFonts.nunito(fontSize: 13)),),
                              Align(alignment: Alignment.centerRight,child: Text(reqattend_approve2_date == '0000-00-00' ? "-" : reqattend_approve2_date,
                                  style: GoogleFonts.nunito(fontSize: 13)),),
                            ],
                          ),
                        ))

                    )

                )),
          ],
        )
      ),

    ),
      bottomSheet:Container(
    padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
      width: double.infinity,
      height: 50,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          reqattend_approv1.toString() == widget.getKaryawanNo && reqattend_approve1_status.toString() == 'Waiting Approval' ?
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
                child: Text("Approve Request", style: TextStyle(color: HexColor("#fffdfc"),fontWeight: FontWeight.bold),),
                onPressed: () {
                  showDialog1(context);
                },
              )
          ) : Container(),



          reqattend_approv1.toString() == widget.getKaryawanNo && reqattend_approve1_status.toString() == 'Waiting Approval' ?
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
                child: Text("Reject Request", style: TextStyle(color: HexColor("#ffeaef"),fontWeight: FontWeight.bold),),
                onPressed: () {
                  showDialogReject1(context);
                },
              )
          ) : Container(),



          reqattend_approv2.toString() == widget.getKaryawanNo &&
              (reqattend_approve2_status.toString() == 'Waiting Approval' && reqattend_status.toString() == 'Approved 1') ?
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
                child: Text("Approve Request", style: TextStyle(color: HexColor("#fffdfc"),fontWeight: FontWeight.bold),),
                onPressed: () {
                  showDialog2(context);
                },
              )
          ) : Container(),


          reqattend_approv2.toString() == widget.getKaryawanNo &&
              (reqattend_approve2_status.toString() == 'Waiting Approval' && reqattend_status.toString() == 'Approved 1') ?
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
                child: Text("Reject Request", style: TextStyle(color: HexColor("#ffeaef"),fontWeight: FontWeight.bold),),
                onPressed: () {
                  showDialogReject2(context);
                },
              )
          ) : Container(),

        ],

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