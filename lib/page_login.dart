



import 'dart:convert';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'helper/app_helper.dart';
import 'helper/app_link.dart';
import 'helper/page_route.dart';
import 'page_loginpin.dart';


class PageLogin extends StatefulWidget{

  @override
  _PageLogin createState() => _PageLogin();
}



class _PageLogin extends State<PageLogin> {
  final _emailq = TextEditingController();
  bool isLoading = false;



  _checkEmail() async {
    if(_emailq.text.isEmpty) {
      AppHelper().showFlushBarerror(context, "Email tidak boleh kosong");
      return false;
    }

    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      isLoading = true;
    });
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=cek_emailuser"), body: {
      "email_user": _emailq.text
    }).timeout(Duration(seconds: 10),onTimeout: (){
      http.Client().close();
      setState(() {
        isLoading = false;
      });
      AppHelper().showFlushBarerror(context, "Koneksi Terputus, silahkan ulangi sekali lagi");
      return http.Response('Error',500);
    });

    Map data = jsonDecode(response.body);
    if(data["message"] != '') {
      setState(() {
        isLoading = false;
      });
      if(data["message"] == '0') {
        AppHelper().showFlushBarsuccess(context, "Mohon maaf, email tidak ditemukan");
      } else if(data["message"] == '2') {
        AppHelper().showFlushBarsuccess(context,"Mohon maaf, email anda sudah tidak aktif");
      } else if(data["message"] == '1') {

        Navigator.push(context, ExitPage(page: PageLoginPIN(_emailq.text)));
      }
    }

  }

  @override
  void initState() {
    super.initState();
    EasyLoading.dismiss();
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 25,right: 25),
        child : Align(
            alignment: Alignment.centerLeft,
            child :
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(alignment: Alignment.centerLeft,child : Text("Halo,", style : GoogleFonts.poppins(fontWeight: FontWeight.bold,
                    fontSize: 32, color: HexColor("#44a440")))),
                Padding(padding: const EdgeInsets.only(top: 1),child :  Align(alignment: Alignment.centerLeft,
                    child : Text("Email Anda", style : GoogleFonts.poppins(fontWeight: FontWeight.bold,
                        fontSize: 18))),),
                Opacity(
                    opacity: 0.8,
                    child :    Padding(padding: const EdgeInsets.only(top: 5),child :  Align(alignment: Alignment.centerLeft,
                        child : Text("Pastikan email anda sudah terdaftar dan aktif", style : GoogleFonts.lato(
                            fontSize: 13))),)
                ),

                Padding(padding: const EdgeInsets.only(top: 10,right: 15),
                  child: TextFormField(
                    controller: _emailq,
                    // keyboardType: TextInputType.number,
                    //textCapitalization: TextCapitalization.words,
                    style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                    decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                      ),
                      /* prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 2), // add padding to adjust icon
                        child: Icon(Icons.phone, size: 20,),
                      ),*/
                    ),
                  ),
                ),
              ],
            )

        ),
      ),
      bottomSheet:
      isLoading == true ?
      Container(
          width: double.infinity,
          color: Colors.white,
          height: 65,
          padding : const EdgeInsets.only(left: 25,right: 25,bottom: 10),
          child :
          Center(
            child:  SizedBox(
              child: CircularProgressIndicator(),
              height: 30.0,
              width: 30.0,
            ),
          ))
          :
      Container(
          width: double.infinity,
          height: 65,
          padding : const EdgeInsets.only(left: 25,right: 25,bottom: 20),
          child :
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(side: BorderSide(
                    color: Colors.white,
                    width: 0.1,
                    style: BorderStyle.solid
                ),
                  borderRadius: BorderRadius.circular(5.0),
                )),
            child : Text("CONTINUE", style: GoogleFonts.lato(fontWeight: FontWeight.bold),),
            onPressed: (){
              _checkEmail();
            },
          )
      ),

    ), onWillPop: onWillPop);
  }

  Future<bool> onWillPop() async {
   return false;
  }
}