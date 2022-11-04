


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

class ChangePIN extends StatefulWidget{
  final String getKaryawanNo;
  const ChangePIN(this.getKaryawanNo);
  @override
  _ChangePIN createState() => _ChangePIN();
}


class _ChangePIN extends State<ChangePIN> {

  TextEditingController _pinValue = TextEditingController();

  _changePIN() async {

    EasyLoading.show(status: "Loading...");


    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=change_pin"),
        body: {
          "changepin_id": widget.getKaryawanNo,
          "changepin_value": _pinValue.text,
        }).timeout(Duration(seconds: 20), onTimeout: () {
      http.Client().close();
      AppHelper().showFlushBarerror(
          context, "Koneksi Terputus, silahkan ulangi sekali lagi");
      EasyLoading.dismiss();
      return http.Response('Error', 500);
    });

    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"] != '') {
        EasyLoading.dismiss();
        if (data["message"] == '1') {
          _pinValue.clear();
          Navigator.pop(context);
          Navigator.pop(context);
          AppHelper().getDetailUser();
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            AppHelper().showFlushBarconfirmed(context,
                "PIN has been changed");
          });
          return;
        }

      }
    });

  }



  showDialogme(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if(_pinValue.text == "") {
      AppHelper().showFlushBarsuccess(context, "PIN tidak boleh kosong");
      return false;
    }
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: GoogleFonts.nunito(color: Colors.black)),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = TextButton(
      child: Text("Yes", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: HexColor("#1a76d2"))),
      onPressed:  () {
        _changePIN();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Change PIN", style: GoogleFonts.nunito(fontSize: 18,fontWeight: FontWeight.bold)),
      content: Text("Would you like to continue change PIN ?", style: GoogleFonts.nunitoSans(),),
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
        title: Text("Change PIN", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
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
        actions: [
      Padding(
        padding: EdgeInsets.only(right: 15),
        child:     Builder(
          builder: (context) =>
              IconButton(
                  icon: new FaIcon(FontAwesomeIcons.check, size: 20,),
                  color: Colors.white,
                  onPressed: () {
                    showDialogme(context);
                  }),
        ),
      )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 25,right: 25,top: 30),
        child: TextFormField(
          style: GoogleFonts.nunito(fontSize: 16),
          textCapitalization: TextCapitalization
              .sentences,
          controller: _pinValue,
          maxLength: 6,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 2),
            hintText: 'Enter your PIN',
            labelText: 'Enter PIN',
            labelStyle: TextStyle(
                fontFamily: "VarelaRound",
                fontSize: 16.5, color: Colors.black87
            ),
            floatingLabelBehavior: FloatingLabelBehavior
                .always,
            hintStyle: GoogleFonts.nunito(
                color: HexColor("#c4c4c4"), fontSize: 15),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: HexColor("#DDDDDD")),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: HexColor("#8c8989")),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: HexColor("#DDDDDD")),
            ),
          ),
          enableInteractiveSelection: false,
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