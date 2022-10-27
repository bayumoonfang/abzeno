



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'helper/app_helper.dart';
import 'helper/app_link.dart';
import 'helper/page_route.dart';
import 'page_login.dart';


class ChangeCabang extends StatefulWidget{
  final String getKaryawanNo;
  const ChangeCabang(this.getKaryawanNo);
  @override
  _ChangeCabang createState() => _ChangeCabang();
}



class _ChangeCabang extends State<ChangeCabang> {

  late List data;

  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      AppHelper().showFlushBarsuccess(context,"Koneksi terputus..");
      EasyLoading.dismiss();
      return false;
    }});
  }

  @override
  void initState() {
    super.initState();
    _startingVariable();
  }


  String filter = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getOtherLocation&"
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



  _changeLocation(String getLocationID) async {
    EasyLoading.show(status: "Loading...");
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=changeLocation"), body: {
      "location_id": getLocationID,
      "karyawan_no": widget.getKaryawanNo
    }).timeout(
        Duration(seconds: 10),onTimeout: (){
      AppHelper().showFlushBarsuccess(context,"Koneksi terputus..");
      EasyLoading.dismiss();
      http.Client().close();
      return http.Response('Error',500);
    });

    Map data = jsonDecode(response.body);
    if(data["message"] != '') {
      EasyLoading.dismiss();
      if(data["message"] == '1') {
        AppHelper().getWorkLocation();
        Navigator.pop(context);
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          AppHelper().showFlushBarconfirmed(context, "Working location has been changed");
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
          "Ubah Lokasi Absen", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
        leading: Builder(
          builder: (context) => IconButton(
              icon: new Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => {
                Navigator.pop(context)
              }),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: getData,
          child :
          Container(
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
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
                          hintText: 'Cari Lokasi...',
                        ),
                      ),
                    )
                ),

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
                                      new Text(
                                        "Data tidak ditemukan",
                                        style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 18),
                                      ),
                                      new Text(
                                        "Mohon hubungi HRD terkait hal ini",
                                        style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 12),
                                      ),
                                    ],
                                  )))
                              :
                          ListView.builder(
                            itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                            padding: const EdgeInsets.only(left: 10,right: 15),
                            itemBuilder: (context, i) {
                              return Column(
                                children: [
                                  InkWell(
                                    child : ListTile(
                                      leading: FaIcon(FontAwesomeIcons.building,size: 23,),
                                      title: Row(
                                        children: [
                                          Padding(padding: const EdgeInsets.only(right: 5),child:
                                          Text(snapshot.data![i]["b"].toString(), style: GoogleFonts.nunito(fontSize: 15),),),
                                        ],
                                      ),
                                    ),
                                    onTap: (){
                                      EasyLoading.show(status: "Loading...");
                                      _changeLocation(snapshot.data![i]["a"].toString());
                                    },
                                  ),
                                  Padding(padding: const EdgeInsets.only(top: 0),child:
                                  Divider(height: 4,),)
                                ],
                              );
                            },
                          );
                        }
                      },
                    )
                ),

              ],
            ),
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