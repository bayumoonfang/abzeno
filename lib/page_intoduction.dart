





import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/page_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Introduction extends StatefulWidget {

  @override
  _Introduction createState() => _Introduction();
}


class _Introduction extends State<Introduction> {



  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontFamily: "VarelaRound",fontSize: 16);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",fontSize: 20),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: IntroductionScreen(
          globalBackgroundColor: Colors.white,
          done: Text("Login"),
          onDone: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PageLogin()),
            );
          },
          pages: [
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/logo.png",width: 400,
                  ),
                ),
                title: "Aplikasi "+AppHelper().app_name,
                body: "Selamat Datang di aplikasi HR terbaik karya anak bangsa",
                footer: Text("@"+AppHelper().app_tag, style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/png1.png",width: 270,height: 50,
                  ),
                ),
                title: "Management kehadiran kamu",
                body: "Nikmati kemudahan manajamen kehadiran kamu setiap harinya",
                footer: Text("@"+AppHelper().app_tag, style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/png2.png",height: 275,
                  ),
                ),
                title: "Fitur Lengkap",
                body: "Fitur paling kengkap dan mudah digunakan tanpa ribet hanya dalam satu aplikasi",
                footer: Text("@"+AppHelper().app_tag, style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/png3.png",width: 300,
                  ),
                ),
                title: "Report lengkap dan mudah",
                body: "Semua kehadiran kamu terorganisir dengan baik dan sangat mudah dianalisa",
                footer: Text("@"+AppHelper().app_tag, style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
          ],
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip: const Text('Skip'),
          next: const Icon(Icons.arrow_forward),
          curve: Curves.fastLinearToSlowEaseIn,
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );


  }
}