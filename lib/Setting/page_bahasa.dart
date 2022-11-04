



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


class ChangeBahasa extends StatefulWidget{
  final String getEmail;
  const ChangeBahasa(this.getEmail);
  @override
  _ChangeBahasa createState() => _ChangeBahasa();
}



class _ChangeBahasa extends State<ChangeBahasa> {

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
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getBahasa")).timeout(
        Duration(seconds: 10),onTimeout: (){
      AppHelper().showFlushBarsuccess(context,"Koneksi terputus..");
      EasyLoading.dismiss();
      http.Client().close();
      return http.Response('Error',500);
    }
    );
    return json.decode(response.body);

  }



  _changeLocation(String getBahasaID) async {
    EasyLoading.show(status: "Loading...");
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=changeBahasa"), body: {
      "bahasa_id": getBahasaID,
      "karyawan_email": widget.getEmail
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
          AppHelper().showFlushBarconfirmed(context, "Bahasa has been changed");
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
          "Ubah Bahasa", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
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
                                      leading: FaIcon(FontAwesomeIcons.mobileScreen,size: 23,),
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