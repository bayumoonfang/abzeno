


import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';


class AttendanceHistory extends StatefulWidget{
  final String getKaryawanNo;
  const AttendanceHistory(this.getKaryawanNo);
  @override
  _AttendanceHistory createState() => _AttendanceHistory();
}



class _AttendanceHistory extends State<AttendanceHistory> {
  var yearme = DateFormat('yyyy').format(DateTime.now());
  var monthme = DateFormat('MM').format(DateTime.now());
  final availableMaps = MapLauncher.installedMaps;
  String filter = "";
  String sortby = '0';
  Future<List> getData() async {

    http.Response response = await http.get(Uri.parse(applink+"mobile/api_mobile.php?act=getAttendanceHistory&"
        "karyawan_no="+widget.getKaryawanNo+"&filter="+filter+"&yearme="+yearme.toString()+"&monthme="+monthme.toString())).timeout(
        Duration(seconds: 10),onTimeout: (){
      AppHelper().showFlushBarsuccess(context,"Koneksi terputus..");
      EasyLoading.dismiss();
      http.Client().close();
      return http.Response('Error',500);
    }
    );


    return json.decode(response.body);

  }


  show_map(String latme, String longme) async {
    bool isGoogleMaps =
        await MapLauncher.isMapAvailable(MapType.google) ?? false;

    if (isGoogleMaps) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(double.parse(latme), double.parse(longme)),
        title: "Location Clock In",

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#3a5664"),
        title: Text("Attendance History", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
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
        padding: EdgeInsets.only(left: 15,right: 15,top: 10),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            /*Padding(padding: const EdgeInsets.only(bottom: 15,top: 5),
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
                      hintText: 'Cari History...',
                    ),
                  ),
                )
            ),*/
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
                              itemExtent: 92,
                              itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                              padding: const EdgeInsets.only(bottom: 85,top: 5),
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    InkWell(
                                      child: ListTile(
                                          visualDensity: VisualDensity(vertical: -2),
                                          dense : true,
                                          title:Container(
                                            width: double.infinity,
                                            padding : EdgeInsets.all(6),
                                            child: Text(AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                AppHelper().getNamaBulanCustomFull(snapshot.data![i]["a"].toString()) + " "+
                                                AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()),
                                                style: GoogleFonts.workSans(fontSize: 12,color: Colors.black)),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: HexColor("#EDEDED"),
                                            ),
                                          ),
                                          subtitle:Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(top: 5,left: 2),
                                                  child:
                                                  Align(alignment: Alignment.centerLeft,
                                                    child: Text(
                                                        "Clock In : "+snapshot.data![i]["b"].toString()+" | Clock Out : "+snapshot.data![i]["c"].toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.montserrat(
                                                            fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black)
                                                    ),)),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 1,left: 3),
                                                  child: Align(alignment: Alignment.centerLeft,
                                                    child: Text(
                                                        "Late : "+snapshot.data![i]["d"].toString()+" minute | "
                                                            "Overtime : "+snapshot.data![i]["e"].toString()+" minute",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),)
                                              )
                                            ],
                                          )

                                      ),
                                      onTap: () {
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
                                                          Align(alignment: Alignment.centerLeft,child: Text("Attendance Detail",
                                                            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                                          Padding(
                                                            padding: EdgeInsets.only(top:15),
                                                            child: Divider(height: 2,),
                                                          ),
                                                          Padding(padding: EdgeInsets.only(top: 5,bottom: 10),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 10),
                                                                  child:  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text("Schedule Code", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                                                                      Text(snapshot.data![i]["j"].toString(),
                                                                          style: GoogleFonts.workSans(fontSize: 15)),],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 10),
                                                                  child:  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text("Schedule Check In", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                                                                      Text(snapshot.data![i]["f"].toString(),
                                                                          style: GoogleFonts.workSans(fontSize: 15)),],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 10),
                                                                  child:  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text("Schedule Check Out", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                                                                      Text(snapshot.data![i]["g"].toString(),
                                                                          style: GoogleFonts.workSans(fontSize: 15)),],
                                                                  ),
                                                                ),

                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 10),
                                                                  child:  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text("Clock In", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                                                                      Text(snapshot.data![i]["b"].toString(),
                                                                          style: GoogleFonts.workSans(fontSize: 15)),],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 10),
                                                                  child:  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text("Clock Out", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                                                                      Text(snapshot.data![i]["c"].toString(),
                                                                          style: GoogleFonts.workSans(fontSize: 15)),],
                                                                  ),
                                                                ),
                                                              Padding(
                                                                padding: EdgeInsets.only(top: 10),child: Divider(height: 5,),
                                                              ),

                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 10),
                                                                  child:  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Text("Clock In Location", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                                                                      ElevatedButton(onPressed: (){
                                                                        show_map(snapshot.data![i]["m"].toString(),
                                                                            snapshot.data![i]["n"].toString());
                                                                      }, child: Text(
                                                                          snapshot.data![i]["k"].toString(),style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                                                          fontSize: 14)
                                                                      )),

                                                                    ],
                                                                  ),
                                                                ),

                                                                snapshot.data![i]["c"].toString() != "00:00" ?
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 10),
                                                                  child:  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Text("Clock Out Location", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 14),),
                                                                      ElevatedButton(onPressed: (){}, child: Text(
                                                                          snapshot.data![i]["l"].toString(),style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                                                          fontSize: 14)
                                                                      )),

                                                                    ],
                                                                  ),
                                                                ) : Container()





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
                                    )
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