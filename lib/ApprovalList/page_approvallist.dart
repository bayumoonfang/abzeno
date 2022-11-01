


import 'dart:async';
import 'dart:convert';

import 'package:abzeno/ApprovalList/page_apprdetailreqattend.dart';
import 'package:abzeno/ApprovalList/page_apprdetailtimeoff.dart';
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
class PageApprovalList extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  const PageApprovalList(this.getKaryawanNo, this.getKaryawanNama);
  @override
  _PageApprovalList createState() => _PageApprovalList();
}


class _PageApprovalList extends State<PageApprovalList> {



  String filter = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getApprovalList&"
        "getKaryawanNo="+widget.getKaryawanNo+"&filter="+filter)).timeout(
        Duration(seconds: 10),onTimeout: (){
      AppHelper().showFlushBarsuccess(context,"Koneksi terputus..");
      EasyLoading.dismiss();
      http.Client().close();
      return http.Response('Error',500);
    }
    );
    return json.decode(response.body);

  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#3a5664"),
        title: Text("Approval  History",
            overflow: TextOverflow.ellipsis,style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
        elevation: 0,
      ),
      body: RefreshIndicator(
          onRefresh: getData,
          child : Container(
              padding: EdgeInsets.only(left: 15,right: 15,top: 10),
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child : Column(
                children: [
                  Padding(padding: const EdgeInsets.only(bottom: 15,top: 5),
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
                            hintText: 'Cari Approval History...',
                          ),
                        ),
                      )
                  ),
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
                                        Image.asset('assets/nodata.png',width: 150,),
                                        new Text(
                                          "Data Not Found",
                                          style: new TextStyle(
                                              fontFamily: 'VarelaRound', fontSize: 15),
                                        ),
                                      ],
                                    )))
                                :
                            Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemExtent: 105,
                                    itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                    padding: const EdgeInsets.only(left: 10,right: 15,bottom: 85),
                                    itemBuilder: (context, i) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            child : ListTile(
                                              visualDensity: VisualDensity(vertical: -2),
                                              dense : true,
                                              title:Opacity(
                                                  opacity: 0.9,
                                                  child:
                                                  Padding(padding: EdgeInsets.only(top: 2),child:
                                                  Text(AppHelper().getTanggalCustom(snapshot.data![i]["c"].toString()) + " "+
                                                      AppHelper().getNamaBulanCustomFull(snapshot.data![i]["c"].toString()) + " "+
                                                      AppHelper().getTahunCustom(snapshot.data![i]["c"].toString()),
                                                    overflow: TextOverflow.ellipsis,  style: GoogleFonts.montserrat(
                                                        fontWeight: FontWeight.bold,fontSize: 16),),)
                                              ),
                                              subtitle: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 2),
                                                    child:   Align(alignment: Alignment.centerLeft,child:
                                                    Text(snapshot.data![i]["a"].toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.workSans(fontSize: 14,color: Colors.black)),),
                                                  ),

                                                  Padding(
                                                      padding: EdgeInsets.only(top: 2),
                                                      child: Align(alignment: Alignment.centerLeft,
                                                          child:Text("#"+snapshot.data![i]["b"].toString(),
                                                              style: GoogleFonts.workSans(fontSize: 14)))),
                                                  Padding(
                                                      padding: EdgeInsets.only(top: 2,bottom: 1),
                                                      child: Align(alignment: Alignment.centerLeft,
                                                          child:Text("as "+snapshot.data![i]["d"].toString(),
                                                              style: GoogleFonts.workSans(fontSize: 14)))),
                                                ],
                                              ),
                                                trailing:
                                                snapshot.data![i]["e"].toString() != 'Approved' ?
                                                Opacity(
                                                  opacity: 0.9,
                                                  child: Container(
                                                    child: OutlinedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        side: BorderSide(
                                                          width: 1,
                                                          color: snapshot.data![i]["e"].toString() == 'Pending'? Colors.black54 :
                                                          snapshot.data![i]["e"].toString() == 'Approved 1' ? HexColor("#0074D9")  :
                                                          HexColor("#FF4136"),
                                                          style: BorderStyle.solid,
                                                        ),
                                                      ),
                                                      child: Text(snapshot.data![i]["e"].toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                          color: snapshot.data![i]["e"].toString() == 'Pending'? Colors.black54 :
                                                          snapshot.data![i]["e"].toString() == 'Approved 1' ? HexColor("#0074D9") :
                                                          HexColor("#FF4136")),),
                                                      onPressed: (){},
                                                    ),
                                                    height: 25,
                                                  ),
                                                ) :  FaIcon(FontAwesomeIcons.circleCheck,color: HexColor("#3D9970"),size: 30,)

                                            ),
                                            onTap: (){
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              snapshot.data![i]["b"].toString().substring(0,6) == 'REQATT' ?
                                              Navigator.push(context, ExitPage(page: ApprReqAttenDetail(snapshot.data![i]["b"].toString(), widget.getKaryawanNo)))
      :
                                              Navigator.push(context, ExitPage(page: ApprTimeOffDetail(snapshot.data![i]["b"].toString(), widget.getKaryawanNo, widget.getKaryawanNama)));


                                            },
                                          ),
                                          Padding(padding: const EdgeInsets.only(top:5),child:
                                          Divider(height: 4,),),
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
                  SizedBox(height: 15,)
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