


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


class PageFullProfile extends StatefulWidget{
  final String getKaryawanNo;
  const PageFullProfile(this.getKaryawanNo);
  @override
  _PageFullProfile createState() => _PageFullProfile();
}


class _PageFullProfile extends State<PageFullProfile> {

  String getKaryawanNama = '...';
  String karyawan_alamat_ktp = '...';
  String karyawan_alamat = '...';
  String karyawan_kelamin = '...';
  String karyawan_ktp = '...';
  String karyawan_marriage = '...';
  String karyawan_agama = '...';
  String karyawan_notelp = '...';
  String karyawan_emailpribadi = '...';
  String karyawan_email = '...';
  String cabang_nama = '...';

  String departemen_nama = '...';
  String jabatan_nama = '...';
  String level_nama = '...';
  String nama_golongan = '...';
  String karyawan_status = '...';
  String karyawan_sip = '...';
  String karyawan_tglmasuk = '...';
  String karyawan_tgl_batas = '...';


  String karyawan_bank = '...';
  String karyawan_banklocation = '...';
  String karyawan_accountname = '...';
  String karyawan_accountnumber = '...';

  String karyawan_pph21 = '...';
  String karyawan_salarytype = '...';
  String karyawan_bpjs_kes = '...';
  String karyawan_bpjs_ket = '...';
  String karyawan_bpjskelas = '...';
  String karyawan_bpjspaidby = '...';
  String karyawan_npwp = '...';


  _startingVariable() async {
    await AppHelper().getDetailUser().then((value){
      setState(() {
          getKaryawanNama = value[1];
          karyawan_alamat_ktp = value[2];
          karyawan_alamat = value[3];
          karyawan_kelamin = value[4];
          karyawan_ktp = value[5];
          karyawan_marriage = value[6];
          karyawan_agama = value[7];
          karyawan_notelp = value[8];
          karyawan_emailpribadi = value[9];
          karyawan_email = value[10];
          cabang_nama = value[11];

          departemen_nama = value[12];
          jabatan_nama = value[13];
          level_nama = value[14];
          nama_golongan = value[15];
          karyawan_status = value[16];
          karyawan_sip = value[17];
          karyawan_tglmasuk = value[18];
          karyawan_tgl_batas = value[19];

          karyawan_bank = value[20];
          karyawan_banklocation = value[21];
          karyawan_accountname = value[22];
          karyawan_accountnumber = value[23];

          karyawan_pph21 = value[24];
          karyawan_salarytype = value[25];
          karyawan_bpjs_kes = value[26];
          karyawan_bpjs_ket = value[27];
          karyawan_bpjskelas = value[28];
          karyawan_bpjspaidby = value[29];
          karyawan_npwp = value[30];

      });});
  }


  loadData() async {
    await _startingVariable();
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: "Loading...");
    loadData();
  }

  String selectedValue = "1";
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Personal Info",style: GoogleFonts.nunitoSans(),),value: "1"),
      DropdownMenuItem(child: Text("Employee Info",style: GoogleFonts.nunitoSans(),),value: "2"),
      DropdownMenuItem(child: Text("Payroll Info",style: GoogleFonts.nunitoSans(),),value: "4"),
      DropdownMenuItem(child: Text("Bank Info",style: GoogleFonts.nunitoSans(),),value: "3"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#3a5664"),
        title: Text("Detail Profile", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
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
        padding: EdgeInsets.only(left: 25,right: 25,top: 30),
        child: Column(
          children: [
            Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: HexColor("#DDDDDD"), width: 1),),
                child:Padding(
                    padding: const EdgeInsets.only(left: 15,top: 5,right: 15), //here include this to get padding
                    child: DropdownButton(
                          isExpanded: true,
                          underline: Container(),
                          alignment: Alignment.bottomCenter,
                          elevation: 1,
                          borderRadius: BorderRadius.circular(5 ),
                          value: selectedValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          onChanged: (String? newValue){
                            setState(() {
                              selectedValue = newValue!;
                            });
                          },
                          items: dropdownItems
                ))
              ),

                 Padding(
                   padding: EdgeInsets.only(top: 25),
                   child: Divider(height: 5,),
                 ),


            selectedValue.toString() == "1" ?
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(children: [
                          Align(alignment: Alignment.centerLeft,child:
                          Text("Karyawan No", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                          Align(alignment: Alignment.centerLeft,
                            child: Text(widget.getKaryawanNo, style: GoogleFonts.nunito(fontSize: 15,
                                fontWeight: FontWeight.bold),),)],),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(children: [
                          Align(alignment: Alignment.centerLeft,child:
                          Text("Nama", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                          Align(alignment: Alignment.centerLeft,
                            child: Text(getKaryawanNama, style: GoogleFonts.nunito(fontSize: 15,
                                fontWeight: FontWeight.bold),),)],),
                      ),



                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(children: [
                         Align(alignment: Alignment.centerLeft,child:
                              Text("Adress KTP", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                          Align(alignment: Alignment.centerLeft,
                            child: Text(karyawan_alamat_ktp, style: GoogleFonts.nunito(fontSize: 15,
                                fontWeight: FontWeight.bold),),)],),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(children: [
                          Align(alignment: Alignment.centerLeft,child:
                          Text("Adress", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                          Align(alignment: Alignment.centerLeft,
                            child: Text(karyawan_alamat, style: GoogleFonts.nunito(fontSize: 15,
                                fontWeight: FontWeight.bold),),)],),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(children: [
                          Align(alignment: Alignment.centerLeft,child:
                          Text("Jenis Kelamin", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                          Align(alignment: Alignment.centerLeft,
                            child: Text(karyawan_kelamin, style: GoogleFonts.nunito(fontSize: 15,
                                fontWeight: FontWeight.bold),),)],),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(children: [
                          Align(alignment: Alignment.centerLeft,child:
                          Text("Identity Number", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                          Align(alignment: Alignment.centerLeft,
                            child: Text(karyawan_ktp, style: GoogleFonts.nunito(fontSize: 15,
                                fontWeight: FontWeight.bold),),)],),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(children: [
                          Align(alignment: Alignment.centerLeft,child:
                          Text("Marriage Status", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                          Align(alignment: Alignment.centerLeft,
                            child: Text(karyawan_marriage, style: GoogleFonts.nunito(fontSize: 15,
                                fontWeight: FontWeight.bold),),)],),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(children: [
                          Align(alignment: Alignment.centerLeft,child:
                          Text("Religion", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                          Align(alignment: Alignment.centerLeft,
                            child: Text(karyawan_agama, style: GoogleFonts.nunito(fontSize: 15,
                                fontWeight: FontWeight.bold),),)],),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(children: [
                          Align(alignment: Alignment.centerLeft,child:
                          Text("Phone Number", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                          Align(alignment: Alignment.centerLeft,
                            child: Text(karyawan_notelp, style: GoogleFonts.nunito(fontSize: 15,
                                fontWeight: FontWeight.bold),),)],),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(children: [
                          Align(alignment: Alignment.centerLeft,child:
                          Text("Private Email", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                          Align(alignment: Alignment.centerLeft,
                            child: Text(karyawan_emailpribadi, style: GoogleFonts.nunito(fontSize: 15,
                                fontWeight: FontWeight.bold),),)],),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(children: [
                          Align(alignment: Alignment.centerLeft,child:
                          Text("Official Email", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                          Align(alignment: Alignment.centerLeft,
                            child: Text(karyawan_email, style: GoogleFonts.nunito(fontSize: 15,
                                fontWeight: FontWeight.bold),),)],),
                      ),

                    ],
                  ),
                )
              )
                :  selectedValue.toString() == "2" ?
                  Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(children: [
                                Align(alignment: Alignment.centerLeft,child:
                                Text("Cabang", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                Align(alignment: Alignment.centerLeft,
                                  child: Text(cabang_nama, style: GoogleFonts.nunito(fontSize: 15,
                                      fontWeight: FontWeight.bold),),)],),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Column(children: [
                                Align(alignment: Alignment.centerLeft,child:
                                Text("Departemen", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                Align(alignment: Alignment.centerLeft,
                                  child: Text(departemen_nama, style: GoogleFonts.nunito(fontSize: 15,
                                      fontWeight: FontWeight.bold),),)],),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Column(children: [
                                Align(alignment: Alignment.centerLeft,child:
                                Text("Jabatan", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                Align(alignment: Alignment.centerLeft,
                                  child: Text(jabatan_nama, style: GoogleFonts.nunito(fontSize: 15,
                                      fontWeight: FontWeight.bold),),)],),
                            ),


                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Column(children: [
                                Align(alignment: Alignment.centerLeft,child:
                                Text("Level", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                Align(alignment: Alignment.centerLeft,
                                  child: Text(level_nama, style: GoogleFonts.nunito(fontSize: 15,
                                      fontWeight: FontWeight.bold),),)],),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Column(children: [
                                Align(alignment: Alignment.centerLeft,child:
                                Text("Golongan", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                Align(alignment: Alignment.centerLeft,
                                  child: Text(nama_golongan, style: GoogleFonts.nunito(fontSize: 15,
                                      fontWeight: FontWeight.bold),),)],),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Column(children: [
                                Align(alignment: Alignment.centerLeft,child:
                                Text("Status", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                Align(alignment: Alignment.centerLeft,
                                  child: Text(karyawan_status, style: GoogleFonts.nunito(fontSize: 15,
                                      fontWeight: FontWeight.bold),),)],),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Column(children: [
                                Align(alignment: Alignment.centerLeft,child:
                                Text("Karyawan SIP", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                Align(alignment: Alignment.centerLeft,
                                  child: Text(karyawan_sip, style: GoogleFonts.nunito(fontSize: 15,
                                      fontWeight: FontWeight.bold),),)],),
                            ),


                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Column(children: [
                                Align(alignment: Alignment.centerLeft,child:
                                Text("Tanggal Masuk", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                Align(alignment: Alignment.centerLeft,
                                  child: Text(karyawan_tglmasuk, style: GoogleFonts.nunito(fontSize: 15,
                                      fontWeight: FontWeight.bold),),)],),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Column(children: [
                                Align(alignment: Alignment.centerLeft,child:
                                Text("Tanggal Berakhir", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                Align(alignment: Alignment.centerLeft,
                                  child: Text(karyawan_tgl_batas, style: GoogleFonts.nunito(fontSize: 15,
                                      fontWeight: FontWeight.bold),),)],),
                            ),


                          ],
                        ),
                      ),
                  )

                : selectedValue.toString() == "3" ?
                    Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Column(children: [
                                  Align(alignment: Alignment.centerLeft,child:
                                  Text("Bank ", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                  Align(alignment: Alignment.centerLeft,
                                    child: Text(karyawan_bank, style: GoogleFonts.nunito(fontSize: 15,
                                        fontWeight: FontWeight.bold),),)],),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Column(children: [
                                  Align(alignment: Alignment.centerLeft,child:
                                  Text("Bank Location ", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                  Align(alignment: Alignment.centerLeft,
                                    child: Text(karyawan_banklocation, style: GoogleFonts.nunito(fontSize: 15,
                                        fontWeight: FontWeight.bold),),)],),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Column(children: [
                                  Align(alignment: Alignment.centerLeft,child:
                                  Text("Account Number ", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                  Align(alignment: Alignment.centerLeft,
                                    child: Text(karyawan_accountnumber, style: GoogleFonts.nunito(fontSize: 15,
                                        fontWeight: FontWeight.bold),),)],),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Column(children: [
                                  Align(alignment: Alignment.centerLeft,child:
                                  Text("Account Name", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                  Align(alignment: Alignment.centerLeft,
                                    child: Text(karyawan_accountname, style: GoogleFonts.nunito(fontSize: 15,
                                        fontWeight: FontWeight.bold),),)],),
                              ),


                            ],
                          ),
                        ),
                    ): selectedValue.toString() == "4" ?
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Column(children: [
                                  Align(alignment: Alignment.centerLeft,child:
                                  Text("Pph21", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                  Align(alignment: Alignment.centerLeft,
                                    child: Text(karyawan_pph21, style: GoogleFonts.nunito(fontSize: 15,
                                        fontWeight: FontWeight.bold),),)],),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Column(children: [
                                  Align(alignment: Alignment.centerLeft,child:
                                  Text("Salary Type", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                  Align(alignment: Alignment.centerLeft,
                                    child: Text(karyawan_salarytype, style: GoogleFonts.nunito(fontSize: 15,
                                        fontWeight: FontWeight.bold),),)],),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Column(children: [
                                  Align(alignment: Alignment.centerLeft,child:
                                  Text("BPJS Kesehatan", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                  Align(alignment: Alignment.centerLeft,
                                    child: Text(karyawan_bpjs_kes, style: GoogleFonts.nunito(fontSize: 15,
                                        fontWeight: FontWeight.bold),),)],),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Column(children: [
                                  Align(alignment: Alignment.centerLeft,child:
                                  Text("BPJS Ketenagakerjaan", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                  Align(alignment: Alignment.centerLeft,
                                    child: Text(karyawan_bpjs_ket, style: GoogleFonts.nunito(fontSize: 15,
                                        fontWeight: FontWeight.bold),),)],),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Column(children: [
                                  Align(alignment: Alignment.centerLeft,child:
                                  Text("BPJS Kelas", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                  Align(alignment: Alignment.centerLeft,
                                    child: Text(karyawan_bpjskelas, style: GoogleFonts.nunito(fontSize: 15,
                                        fontWeight: FontWeight.bold),),)],),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Column(children: [
                                  Align(alignment: Alignment.centerLeft,child:
                                  Text("BPJS Paid By", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                  Align(alignment: Alignment.centerLeft,
                                    child: Text(karyawan_bpjspaidby, style: GoogleFonts.nunito(fontSize: 15,
                                        fontWeight: FontWeight.bold),),)],),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Column(children: [
                                  Align(alignment: Alignment.centerLeft,child:
                                  Text("NPWP", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),),
                                  Align(alignment: Alignment.centerLeft,
                                    child: Text(karyawan_npwp, style: GoogleFonts.nunito(fontSize: 15,
                                        fontWeight: FontWeight.bold),),)],),
                              ),


                            ],
                          ),
                        ),
                      ) : Container()

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