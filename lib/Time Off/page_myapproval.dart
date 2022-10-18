


import 'dart:async';
import 'dart:convert';

import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Time%20Off/page_timeoffapprovedetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../Helper/app_helper.dart';
import '../Helper/app_link.dart';
import 'page_timeoffdetail.dart';


class PageMyApproval extends StatefulWidget {
  final String getKaryawanNo;
  final String getKaryawanNama;
  const PageMyApproval(this.getKaryawanNo,this.getKaryawanNama);
  @override
  _PageMyApproval createState() => _PageMyApproval();
}


class _PageMyApproval extends State<PageMyApproval> {


  FutureOr onGoBack(dynamic value) {
    setState(() {
      getData();
    });
  }



  String filter = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getAttendanceApproval&"
        "karyawan_no="+widget.getKaryawanNo+"&filter="+filter)).timeout(
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
    return Scaffold(
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
                                          hintText: 'Cari Need My Approval...',
                                        ),
                                      ),
                                    )
                                ),
                                Expanded(
                                    child: ListView.builder(
                                      itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                      padding: const EdgeInsets.only(left: 10,right: 15,bottom: 85),
                                      itemBuilder: (context, i) {
                                        return Column(
                                          children: [

                                            InkWell(
                                              child : ListTile(
                                                  title: Opacity(
                                                      opacity: 0.9,
                                                      child:
                                                      Padding(padding: EdgeInsets.only(top: 5),child:
                                                      Text(snapshot.data![i]["j"].toString(),style: GoogleFonts.nunito(
                                                          fontWeight: FontWeight.bold,fontSize: 16),),)
                                                  ),
                                                  subtitle: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 2),
                                                        child:   Align(alignment: Alignment.centerLeft,child: Row(
                                                          children: [
                                                            Text(
                                                                AppHelper().getTanggalCustom(snapshot.data![i]["c"].toString()) + " "+
                                                                    AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["c"].toString()) + " "+
                                                                    AppHelper().getTahunCustom(snapshot.data![i]["c"].toString()),
                                                                style: GoogleFonts.nunito(fontSize: 14)),
                                                            Text(" - "),
                                                            Text(
                                                                AppHelper().getTanggalCustom(snapshot.data![i]["d"].toString()) + " "+
                                                                    AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["d"].toString()) + " "+
                                                                    AppHelper().getTahunCustom(snapshot.data![i]["d"].toString()),style: GoogleFonts.nunito(
                                                                fontWeight: FontWeight.bold,fontSize: 14)),
                                                            Text(" "),
                                                            Text("("+snapshot.data![i]["k"].toString()+" Hari"+")",style: GoogleFonts.nunito(
                                                                fontWeight: FontWeight.bold,fontSize: 14))
                                                          ],
                                                        ),),
                                                      ),

                                                      Padding(
                                                          padding: EdgeInsets.only(top: 3,bottom: 1),
                                                          child: Align(alignment: Alignment.centerLeft,
                                                              child:Text("Jenis : "+snapshot.data![i]["m"].toString(),style: TextStyle(fontSize: 13)))),


                                                    ],
                                                  ),
                                                  trailing: Opacity(
                                                    opacity: 0.9,
                                                    child: Container(
                                                      child: OutlinedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          side: BorderSide(
                                                            width: 1,
                                                            color: snapshot.data![i]["l"].toString() == 'Pending'? Colors.black54 :
                                                            snapshot.data![i]["l"].toString() == 'Approved 1' ? HexColor("#0074D9") :
                                                            snapshot.data![i]["l"].toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                                            HexColor("#FF4136"),
                                                            style: BorderStyle.solid,
                                                          ),
                                                        ),
                                                        child: Text(snapshot.data![i]["l"].toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                            color: snapshot.data![i]["l"].toString() == 'Pending'? Colors.black54 :
                                                            snapshot.data![i]["l"].toString() == 'Approved 1' ? HexColor("#0074D9") :
                                                            snapshot.data![i]["l"].toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                                            HexColor("#FF4136")),),
                                                        onPressed: (){},
                                                      ),
                                                      height: 25,
                                                    ),
                                                  )
                                              ),
                                              onTap: (){
                                                EasyLoading.show(status: "Loading...");
                                                FocusScope.of(context).requestFocus(FocusNode());
                                                Navigator.push(context, ExitPage(page: TimeOffApproveDetail(snapshot.data![i]["a"].toString(), widget.getKaryawanNo, widget.getKaryawanNama))).then(onGoBack);
                                                //_changeLocation(snapshot.data![i]["a"].toString());
                                              },
                                            ),
                                            Padding(padding: const EdgeInsets.only(top:8),child:
                                            Divider(height: 4,),)
                                          ],
                                        );
                                      },
                                    )
                                )

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

    );

  }
}