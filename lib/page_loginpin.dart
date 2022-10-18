



import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'helper/app_helper.dart';
import 'helper/app_link.dart';
import 'helper/page_route.dart';
import 'page_home.dart';

class PageLoginPIN extends StatefulWidget{
  final String getEmail;
  const PageLoginPIN(this.getEmail);
  @override
  _PageLoginPIN createState() => _PageLoginPIN();
}


class _PageLoginPIN extends State<PageLoginPIN> {

  late FocusNode myFocusNode1;
  late FocusNode myFocusNode2;
  late FocusNode myFocusNode3;
  late FocusNode myFocusNode4;
  late FocusNode myFocusNode5;
  late FocusNode myFocusNode6;

  final _verif1 = TextEditingController();
  final _verif2 = TextEditingController();
  final _verif3 = TextEditingController();
  final _verif4 = TextEditingController();
  final _verif5 = TextEditingController();
  final _verif6 = TextEditingController();


  proses_login() async {
    EasyLoading.show(status: "Loading...");
    if(_verif1.text.isEmpty || _verif2.text.isEmpty || _verif3.text.isEmpty || _verif4.text.isEmpty || _verif5.text.isEmpty ||
        _verif6.text.isEmpty) {
      AppHelper().showFlushBarerror(context, "PIN tidak lengkap");
      return false;
    }
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=login"), body: {
      "login_pin": _verif1.text+_verif2.text+_verif3.text+_verif4.text+_verif5.text+_verif6.text,
      "login_email": widget.getEmail.toString()
    }).timeout(Duration(seconds: 10),onTimeout: (){
      http.Client().close();
      AppHelper().showFlushBarerror(context, "Koneksi Terputus, silahkan ulangi sekali lagi");
      return http.Response('Error',500);
    });

    Map data = jsonDecode(response.body);
    if(data["message"] != '') {
      EasyLoading.dismiss();
      if(data["message"] == '0') {
        AppHelper().showFlushBarsuccess(context, "Mohon maaf, email anda sudah tidak aktif");
        return false;
      } else if(data["message"] == '2') {
        AppHelper().showFlushBarsuccess(context, "Mohon maaf, password anda salah");
        return false;
      } else {
        savePref(widget.getEmail, data["username"].toString(), data["karyawan_id"].toString(), data["karyawan_nama"].toString(), data["karyawan_no"].toString(),
            data["karyawan_jabatan"].toString());
        Navigator.pushReplacement(context, ExitPage(page: Home()));
      }
    }
  }



  savePref(
      String val_email,
      String val_username,
      String val_karyawanid,
      String val_karyawannama,
      String val_karyawanno,
      String val_karyawanjabatan) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //preferences.setInt("value", value);
      preferences.setString("email", val_email);
      preferences.setString("username", val_username);
      preferences.setString("karyawan_id", val_karyawanid);
      preferences.setString("karyawan_nama", val_karyawannama);
      preferences.setString("karyawan_no", val_karyawanno);
      preferences.setString("karyawan_jabatan", val_karyawanjabatan);
      preferences.commit();
    });


  }



  void initState() {
    myFocusNode1 = new FocusNode();
    myFocusNode2 = new FocusNode();
    myFocusNode3 = new FocusNode();
    myFocusNode4 = new FocusNode();
    myFocusNode5 = new FocusNode();
    myFocusNode6 = new FocusNode();
    //myFocusNode.addListener(() => print('focusNode updated: hasFocus: ${myFocusNode.hasFocus}'));
  }


  clearPin() {
    _verif1.clear();
    _verif2.clear();
    _verif3.clear();
    _verif4.clear();
    _verif5.clear();
    _verif6.clear();
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode1);
    });
  }

  @override
  Widget build(BuildContext context) {
   return RawKeyboardListener(
       focusNode: FocusNode(),
     onKey: (event) {
       if(event.isKeyPressed(LogicalKeyboardKey.backspace)){
          if (_verif2.text == "") {
            FocusScope.of(context).requestFocus(myFocusNode1);
          } else if (_verif3.text == "") {
            FocusScope.of(context).requestFocus(myFocusNode2);
          } else if (_verif4.text == "") {
            FocusScope.of(context).requestFocus(myFocusNode3);
          } else if (_verif5.text == "") {
            FocusScope.of(context).requestFocus(myFocusNode4);
          } else if (_verif6.text == "") {
            FocusScope.of(context).requestFocus(myFocusNode5);
          }
       }
     },
     child : WillPopScope(child: Scaffold(
         appBar: new AppBar(
           elevation: 0,
           backgroundColor: Colors.white,
           leading: Builder(
             builder: (context) => IconButton(
                 icon: new FaIcon(FontAwesomeIcons.angleLeft,color: Colors.black,size: 25,),
                 color: Colors.white,
                 onPressed: () => {
                   Navigator.pop(context)
                 }),
           ),
         ),
         body: Container(
           height: double.infinity,
           width: double.infinity,
           color: Colors.white,
           padding: const EdgeInsets.only(left: 25,right: 25),
           child: Column(
             children: [
               Align(alignment: Alignment.center,
                   child : Padding(padding: const EdgeInsets.only(top: 50),child: Text("Login With Your PIN",style:
                   GoogleFonts.poppins(fontWeight: FontWeight.bold,
                       fontSize: 20),),)),
               Align(alignment: Alignment.center,
                   child : Padding(padding: const EdgeInsets.only(top: 3),child: Text("Masukan 6 digit PIN untuk masuk ke akun anda"
                     ,style: GoogleFonts.lato(fontSize: 13),),)),
               Center(
                   child : Padding(padding: const EdgeInsets.only(top: 50),
                     child: Form(
                         child : Wrap(
                           alignment: WrapAlignment.center,
                           spacing: 20,
                           children: [
                             SizedBox(
                               height: 28,
                               width: 32,

                               child: TextField(
                                 focusNode: myFocusNode1,
                                 autofocus: true,
                                 controller: _verif1,
                                 keyboardType: TextInputType.number,
                                 onChanged: (value) {
                                   if(value.length == 1) {
                                     FocusScope.of(context).nextFocus();
                                   }
                                 },
                                 style: GoogleFonts.roboto(fontSize: 35),
                                 textAlign: TextAlign.center,
                                 inputFormatters: [
                                   LengthLimitingTextInputFormatter(1),
                                   FilteringTextInputFormatter.digitsOnly
                                 ],
                               ),
                             ),

                             SizedBox(
                               height: 28,
                               width: 32,
                               child: TextField(
                                 focusNode: myFocusNode2,
                                 controller: _verif2,
                                 keyboardType: TextInputType.number,
                                 onChanged: (value) {
                                   if(value.length == 1) {
                                     FocusScope.of(context).nextFocus();
                                   }else {
                                     FocusScope.of(context).previousFocus();
                                   }
                                 },
                                 style: GoogleFonts.roboto(fontSize: 35),
                                 textAlign: TextAlign.center,
                                 inputFormatters: [
                                   LengthLimitingTextInputFormatter(1),
                                   FilteringTextInputFormatter.digitsOnly
                                 ],
                               ),
                             ),

                             SizedBox(
                               height: 28,
                               width: 32,
                               child: TextField(
                                 focusNode: myFocusNode3,
                                 controller: _verif3,
                                 keyboardType: TextInputType.number,
                                 onChanged: (value) {
                                   if(value.length == 1) {
                                     FocusScope.of(context).nextFocus();
                                   }else {
                                     FocusScope.of(context).previousFocus();
                                   }
                                 },
                                 style: GoogleFonts.roboto(fontSize: 35),
                                 textAlign: TextAlign.center,
                                 inputFormatters: [
                                   LengthLimitingTextInputFormatter(1),
                                   FilteringTextInputFormatter.digitsOnly
                                 ],
                               ),
                             ),

                             SizedBox(
                               height: 28,
                               width: 32,
                               child: TextField(
                                 focusNode: myFocusNode4,
                                 controller: _verif4,
                                 keyboardType: TextInputType.number,
                                 onChanged: (value) {
                                   if(value.length == 1) {
                                     FocusScope.of(context).nextFocus();
                                   }else {
                                     FocusScope.of(context).previousFocus();
                                   }
                                 },
                                 style: GoogleFonts.roboto(fontSize: 35),
                                 textAlign: TextAlign.center,
                                 inputFormatters: [
                                   LengthLimitingTextInputFormatter(1),
                                   FilteringTextInputFormatter.digitsOnly
                                 ],
                               ),
                             ),

                             SizedBox(
                               height: 28,
                               width: 32,
                               child: TextField(
                                 focusNode: myFocusNode5,
                                 controller: _verif5,
                                 keyboardType: TextInputType.number,
                                 onChanged: (value) {
                                   if(value.length == 1) {
                                     FocusScope.of(context).nextFocus();
                                   }else {
                                     FocusScope.of(context).previousFocus();
                                   }
                                 },
                                 style: GoogleFonts.roboto(fontSize: 35),
                                 textAlign: TextAlign.center,
                                 inputFormatters: [
                                   LengthLimitingTextInputFormatter(1),
                                   FilteringTextInputFormatter.digitsOnly
                                 ],
                               ),
                             ),

                             SizedBox(
                               height: 28,
                               width: 32,
                               child: TextField(
                                 focusNode: myFocusNode6,
                                 controller: _verif6,
                                 keyboardType: TextInputType.number,
                                 style: GoogleFonts.roboto(fontSize: 35),
                                 onChanged: (value) {
                                   if(value.length == 1) {
                                     proses_login();
                                     //FocusScope.of(context).nextFocus();
                                   } else {
                                     FocusScope.of(context).previousFocus();
                                   }
                                 },
                                 textAlign: TextAlign.center,
                                 inputFormatters: [
                                   LengthLimitingTextInputFormatter(1),
                                   FilteringTextInputFormatter.digitsOnly
                                 ],
                               ),
                             ),

                           ],
                         )
                     )

                     ,)),

               Center(
                 child : Padding(
                   padding: const EdgeInsets.only(top:30),
                   child : Container(
                     width: 100,
                     child : OutlinedButton(
                         child : Text("Clear"),
                       onPressed: (){
                           clearPin();
                       },
                     )
                   )
                 )
               )

             ],
           ),

         )

     ), onWillPop: onWillPop)
   );

  }

  Future<bool> onWillPop() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }

  }
}