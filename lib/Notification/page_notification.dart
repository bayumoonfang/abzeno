


import 'dart:async';
import 'dart:convert';

import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Notification/page_detailnotification.dart';
import 'package:abzeno/helper/app_helper.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
class PageNotification extends StatefulWidget{
  final String getEmail;
  const PageNotification(this.getEmail);
  @override
  _PageNotification createState() => _PageNotification();
}


class _PageNotification extends State<PageNotification> {



  String filter = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getNotification&"
        "getEmail="+widget.getEmail+"&filter="+filter)).timeout(
        Duration(seconds: 10),onTimeout: (){
      AppHelper().showFlushBarsuccess(context,"Koneksi terputus..");
      EasyLoading.dismiss();
      http.Client().close();
      return http.Response('Error',500);
    }
    );
    return json.decode(response.body);

  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      getData();
    });
  }


  _read_allnotif() async {
    EasyLoading.show(status: "Loading...");
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=read_allnotif"),
        body: {
          "message_email": widget.getEmail,
        }).timeout(Duration(seconds: 20), onTimeout: () {
      http.Client().close();
      AppHelper().showFlushBarerror(
          context, "Koneksi Terputus, silahkan ulangi sekali lagi");
      EasyLoading.dismiss();
      return http.Response('Error', 500);
    });
    Navigator.pop(context);
  }



  showDialogAllRead(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: GoogleFonts.nunito(color: Colors.black)),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = TextButton(
      child: Text("Yes, Make All Read", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.blue)),
      onPressed:  () {

        _read_allnotif();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Mark All As Read", style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold)),
      content: Text("Would you like to continue mark all as read ?", style: GoogleFonts.nunitoSans(),),
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
        title: Text("Activity", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
        elevation: 0,
        actions: [
          Padding(padding: EdgeInsets.only(right: 10,top: 4),
          child: TextButton(
            child: Text("Mark All As Read", style: GoogleFonts.workSans(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white)),
            onPressed: (){
              showDialogAllRead(context);
            },
          ),)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: getData,
        child : Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child : Column(
              children: [
                Padding(padding: const EdgeInsets.only(top: 10),),
                Expanded(
                    child: FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot){
                        if (snapshot.data == null) {
                          return Center(
                              child: CircularProgressIndicator()
                          );
                        } else {
                          return snapshot.data == 0 || snapshot.data?.length == 0 ?
                          Container(
                              height: double.infinity, width : double.infinity,
                              child: new
                              Center(
                                  child :
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('assets/notfound.png',width: 250,),
                                      new Text(
                                        "No Time Off Request",
                                        style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 15),
                                      ),
                                    ],
                                  )))
                              :
                          Column(
                            children: [
                              Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15,bottom: 10),
                                  child: Container(
                                    height: 50,
                                    child: TextFormField(
                                      enableInteractiveSelection: false,
                                      onChanged: (text) {
                                        setState(() {
                                          filter = text;
                                        });
                                      },
                                      style: GoogleFonts.nunito(fontSize: 15),
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(10),
                                        fillColor: HexColor("#f4f4f4"),
                                        filled: true,
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: Icon(Icons.search,size: 18,color: HexColor("#6c767f"),),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 1.0,),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: HexColor("#f4f4f4"), width: 1.0),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        hintText: 'Cari My Notification...',
                                      ),
                                    ),
                                  )
                              ),
                              Expanded(
                                child: ListView.builder(
                                  //itemExtent: 92,
                                  itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                  padding: const EdgeInsets.only(left: 10,right: 15,bottom: 85),
                                  itemBuilder: (context, i) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          child : ListTile(
                                              visualDensity: VisualDensity(vertical: -2),
                                              dense : true,
                                              title:
                                              snapshot.data![i]["f"].toString() == "0" ?
                                              Badge(
                                                showBadge: true,
                                                position: BadgePosition.topStart(top: -2,start: -5),
                                                animationType:  BadgeAnimationType.scale,
                                                shape: BadgeShape.circle,
                                                child: Container(
                                                  width: double.infinity,
                                                  padding : EdgeInsets.all(6),
                                                  child: Text(AppHelper().getTanggalCustom(snapshot.data![i]["e"].toString()) + " "+
                                                      AppHelper().getNamaBulanCustomFull(snapshot.data![i]["e"].toString()) + " "+
                                                      AppHelper().getTahunCustom(snapshot.data![i]["e"].toString()),
                                                      style: GoogleFonts.workSans(fontSize: 12,color: Colors.black)),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: HexColor("#EDEDED"),
                                                  ),
                                                ),
                                              ) : Container(
                                                width: double.infinity,
                                                padding : EdgeInsets.all(6),
                                                child: Text(AppHelper().getTanggalCustom(snapshot.data![i]["e"].toString()) + " "+
                                                    AppHelper().getNamaBulanCustomFull(snapshot.data![i]["e"].toString()) + " "+
                                                    AppHelper().getTahunCustom(snapshot.data![i]["e"].toString()),
                                                    style: GoogleFonts.workSans(fontSize: 12,color: Colors.black)),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: HexColor("#EDEDED"),
                                                ),
                                              ),
                                            subtitle: Column(
                                              children: [
                                               Padding(
                                                 padding: EdgeInsets.only(top: 5),
                                                 child:  Align(alignment: Alignment.centerLeft,
                                                   child:  Text(snapshot.data![i]["b"].toString(),
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.montserrat(
                                                            fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black))),
                                               ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 5),
                                                  child:  Align(alignment: Alignment.centerLeft,
                                                    child: Text(snapshot.data![i]["c"].toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),),
                                                )
                                              ],
                                            ),

                                          ),
                                          onTap: (){
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            Navigator.push(context, ExitPage(page: PageDetailNotification(snapshot.data![i]["b"].toString(),
                                                snapshot.data![i]["c"].toString(),
                                                AppHelper().getTanggalCustom(snapshot.data![i]["e"].toString()) + " "+
                                                    AppHelper().getNamaBulanCustomFull(snapshot.data![i]["e"].toString()) + " "+
                                                    AppHelper().getTahunCustom(snapshot.data![i]["e"].toString()),
                                                snapshot.data![i]["g"].toString()))).then(onGoBack);

                                          },
                                        ),
                                        Padding(padding: const EdgeInsets.only(top:15)),
                                      ],
                                    );
                                  },
                                ),
                              ),

                            ],
                          );

                        }
                      },
                    )
                ),
              ],
            )
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