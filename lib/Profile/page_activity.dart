


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


class MyActivity extends StatefulWidget{
  final String getKaryawanNo;
  const MyActivity(this.getKaryawanNo);
  @override
  _MyActivity createState() => _MyActivity();
}



class _MyActivity extends State<MyActivity> {


  String filter = "";
  String sortby = '0';
  Future<List> getData() async {

    http.Response response = await http.get(Uri.parse(applink+"mobile/api_mobile.php?act=getLogs&"
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
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(AppHelper().main_color),
        title: Text("My Activity", style: GoogleFonts.nunito(fontSize: 17),),
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
        child: Column(
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
                                    "No Data",
                                    style: new TextStyle(
                                        fontFamily: 'VarelaRound', fontSize: 15),
                                  ),
                                ],
                              )))
                          :
                      Column(
                        children: [
                          Padding(padding: const EdgeInsets.only(bottom: 2),
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
                                    hintText: 'Cari My Activity...',
                                  ),
                                ),
                              )
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemExtent: 65,
                              itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                              padding: const EdgeInsets.only(bottom: 85),
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    ListTile(
                                     // visualDensity: VisualDensity(vertical: -2),
                                      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
                                      dense:true,
                                      title: Opacity(
                                              opacity: 0.9,
                                              child:
                                              Text(AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                  AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["a"].toString()) + " "+
                                                  AppHelper().getTahunCustom(snapshot.data![i]["a"].toString())+ " | "+snapshot.data![i]["b"].toString(),style: GoogleFonts.nunito(
                                                  fontWeight: FontWeight.bold,fontSize: 15),)
                                          ),
                                          subtitle:Text(
                                          snapshot.data![i]["c"].toString(),
                                              style: GoogleFonts.nunito(fontSize: 14)),

                                      ),
                                    Divider(height: 1,)
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