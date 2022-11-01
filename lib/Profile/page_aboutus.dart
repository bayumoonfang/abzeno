


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

class AboutUs extends StatefulWidget{
  @override
  _AboutUs createState() => _AboutUs();
}


class _AboutUs extends State<AboutUs> {



    @override
    Widget build(BuildContext context) {
      return WillPopScope(child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("About Us", style: GoogleFonts.nunito(fontSize: 17,color:Colors.black,),),
          elevation: 0,
          leading: Builder(
            builder: (context) =>
                IconButton(
                    icon: new FaIcon(FontAwesomeIcons.arrowLeft, size: 17,color:Colors.black,),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
          ),
        ),
        body: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2,bottom: 2),
                child: Text("MIS HR", style: GoogleFonts.nunitoSans(fontSize: 68,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Aplikasi HR terbaik karya anak bangsa", style: GoogleFonts.nunitoSans(fontSize: 14),),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text("Developer Team", style: GoogleFonts.nunitoSans(fontSize: 22,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text("Team Leader/ Mobile Apps Developer", style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Ragil Bayu Respati", style: GoogleFonts.nunitoSans(fontSize: 14),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text("Backend and Front End Developer", style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Christian Kurnadi", style: GoogleFonts.nunitoSans(fontSize: 14),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Akhmad Efendy Mooduto", style: GoogleFonts.nunitoSans(fontSize: 14),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Eko Utomo", style: GoogleFonts.nunitoSans(fontSize: 14),),
              )



            ],
          )
        ),
        bottomSheet: Container(
          color: Colors.white,
          height: 60,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("PT. Karya Anak Bangsa @2022", style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
              Text("Version 2.1")
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