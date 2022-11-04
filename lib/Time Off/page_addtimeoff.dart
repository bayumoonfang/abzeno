



import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../Helper/page_route.dart';
import '../page_home.dart';



class PageAddTimeOff extends StatefulWidget{
    final String getKaryawanNo;
    final String getKaryawanNama;
    const PageAddTimeOff(this.getKaryawanNo, this.getKaryawanNama);
  @override
  _PageAddTimeOff createState() => _PageAddTimeOff();
}


class _PageAddTimeOff extends State<PageAddTimeOff> {

  var selectedTimeOffTipe;
  List timeOffTypeList = [];
  var selectedRequestto;
  var needTime;
  var selectedTimeStart;
  var selectedTimeEnd;
  var startDate;
  var endDate;
  var delegatedNo;
  var delegatedName;
  List RequesttoList = [];
  String provinsi = '';
  bool _isPressed = false;
  String timeoffType = 'For Myself';
  var items = [
    'For Myself',
    'Request for Someone'
  ];

  TextEditingController _datefrom = TextEditingController();
  TextEditingController _dateto = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _delegate = TextEditingController();
  TextEditingController _TimeStart = TextEditingController();
  TextEditingController _TimeEnd = TextEditingController();
  TextEditingController _uploadme = TextEditingController();

  Future getAlltimeOffType() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      AppHelper().showFlushBarsuccess(context, "Koneksi Putus");
      EasyLoading.dismiss();
      return false;
    }});
    var response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getAlltimeOffType&karyawan_no=" +
            widget.getKaryawanNo));
    var jsonData = json.decode(response.body);
    setState(() {
      timeOffTypeList = jsonData;
    });
  }

  @override
  void initState() {
    super.initState();
    getAlltimeOffType();
    //getAllrequestTo();
  }

  String filter2 = "";

  Future<List> getAllrequestTo() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      AppHelper().showFlushBarsuccess(context, "Koneksi Putus");
      EasyLoading.dismiss();
      return false;
    }});
    http.Response response = await http.Client().get(
        Uri.parse(
            applink + "mobile/api_mobile.php?act=getAllrequestTo&filter=" +
                filter2.toString()),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"}
    ).timeout(
        Duration(seconds: 10), onTimeout: () {
      AppHelper().showFlushBarsuccess(context, "Koneksi terputus..");
      EasyLoading.dismiss();
      http.Client().close();
      return http.Response('Error', 500);
    }
    );
    return json.decode(response.body);
  }

  String saldoTimeOff = "";

  _getTimeOffNeedTime(String getVal) async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      AppHelper().showFlushBarsuccess(context, "Koneksi Putus");
      EasyLoading.dismiss();
      return false;
    }});
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getTimeOffNeedTime&timeoffcode=" +
            getVal + "&karyawan_no=" + widget.getKaryawanNo)).timeout(
        Duration(seconds: 10), onTimeout: () {
      AppHelper().showFlushBarsuccess(context, "Koneksi terputus..");
      EasyLoading.dismiss();
      http.Client().close();
      return http.Response('Error', 500);
    }
    );
    Map data = jsonDecode(response.body);
    setState(() {
      EasyLoading.dismiss();
      needTime = data["setttimeoff_needtime"].toString();
      saldoTimeOff = data["timeoff_quota"].toString();
    });
  }


  var Base64;
 imageSelectorGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg']);
    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size > 5243194) {
        AppHelper().showFlushBarerror(
            context, "File tidak boleh lebih dari 5 MB");
        return false;
      } else {
        final file = result.files.first;
        final bytes = File(file.path!).readAsBytesSync();
        setState(() {
          _uploadme.text = file.name;
          Base64 = base64Encode(bytes);
        });
      }
      //print(file.name);//print(file.readStream);//print(file.size);// print(file.extension);//print(file.path);
    } else { // User canceled the picker//
    }
  }


  late DateTime aa;
  late DateTime bb;
  var Baseme;
  String durationme = "";
  _addtimeoff_req() async {
    setState(() {
      _isPressed = true;
    });
   EasyLoading.show(status: "Loading...");

    if(selectedTimeOffTipe.toString() == 'null') {
      AppHelper().showFlushBarsuccess(
          context, "Type Time Off harus dipilih");
      EasyLoading.dismiss();
      setState(() {
        _isPressed = false;
      });
      return false;
    }

    if(needTime == 'Yes') {
      if(_TimeStart == '' || _TimeEnd == '') {
        AppHelper().showFlushBarsuccess(
            context, "Jam tidak boleh kosong");
        EasyLoading.dismiss();
        setState(() {
          _isPressed = false;
        });
        return false;
      }
    }

    if(_dateto.text == '' || _datefrom.text == '') {
      AppHelper().showFlushBarsuccess(
          context, "Tanggal tidak boleh kosong");
      EasyLoading.dismiss();
      setState(() {
        _isPressed = false;
      });
      return false;
    } else if(_description.text == '') {
      AppHelper().showFlushBarsuccess(
          context, "Description tidak boleh kosong");
      EasyLoading.dismiss();
      setState(() {
        _isPressed = false;
      });
      return false;
    } else {
      DateTime aa = DateTime.parse(startDate.toString());
      DateTime bb = DateTime.parse(endDate.toString());
      int time = DateTime(bb.year, bb.month, bb.day).difference(DateTime(aa.year, aa.month, aa.day)).inDays;

      if(time < 0) {
        AppHelper().showFlushBarsuccess(
            context, "Tanggal start date tidak boleh kurang dari end date");
        EasyLoading.dismiss();
        setState(() {
          _isPressed = false;
        });
        return false;
      } else if(time == 0) {
        setState(() {
          durationme = "1";
        });
      } else {
        setState(() {
          int durationint = time + 1;
          durationme = durationint.toString();
        });
      }
    }


    if(Base64 == null) {
      Baseme = '0';
    } else {
      Baseme = Base64;
    }

    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      AppHelper().showFlushBarsuccess(context, "Koneksi Putus");
      EasyLoading.dismiss();
      return false;
    }});
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=addtimeoff_req"),
        body: {
          "attreq_code": selectedTimeOffTipe,
          "attreq_datefrom": startDate.toString(),
          "attreq_dateend": endDate.toString(),
          "attreq_timefrom": _TimeStart.text,
          "attreq_timeto": _TimeEnd.text,
          "attreq_needtime": needTime.toString(),
          "attreq_reqby": widget.getKaryawanNo,
          "attreq_reqname": widget.getKaryawanNama,
          "attreq_delegated": delegatedNo.toString(),
          "attreq_delegatedname": delegatedName.toString(),
          "attreq_description": _description.text,
          "attreq_lamahari" : durationme.toString(),
          "attreq__uploadme" : Baseme
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
          setState(() {
            _isPressed = false;
          });
              if (data["message"] == '0') {
                AppHelper().showFlushBarsuccess(context,
                    "Maaf kuota anda tidak mencukupi");
                return;
              } else if (data["message"] == '1') {
                AppHelper().showFlushBarsuccess(context,
                    "Maaf data approval anda belum lengkap,silahkan hubungi HRD terkait hal ini");
                return;
              } else if (data["message"] == '2') {
                AppHelper().showFlushBarsuccess(context,
                    "Maaf anda masih ada request attendance yang belum di tindaklanjuti  di hari yang sama,"
                        "silahkan batalkan request attendance atau tunggu pengajuan di approved");
                return;
              } else if (data["message"] == '3') {
                AppHelper().showFlushBarsuccess(context,
                    "Maaf anda masih ada pengajuan Time Off yang belum di tindaklanjuti  di hari yang sama,"
                        "silahkan batalkan pengajuan Time Off atau tunggu pengajuan di approved");
                return;
              } else if (data["message"] == '4') {
                AppHelper().showFlushBarsuccess(context,
                    "Maaf ada jadwal OFF di hari atau salah satu hari pengajuan anda");
                return;
              } else if (data["message"] == '5') {
                Navigator.pop(context);
                Navigator.pop(context);
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  AppHelper().showFlushBarconfirmed(context,
                      "Time Off Request has been posted, waiting for approval");
                });
              }  else {
                AppHelper().showFlushBarsuccess(context, data["message"]);
                return;
              }
      }
    });
  }



  showDialog2(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: GoogleFonts.nunito(color: Colors.black)),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes, Create", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: HexColor("#1a76d2"))),
      onPressed:  () {
        _addtimeoff_req();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Create Time Off Request", style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold)),
      content: Text("Would you like to continue create this request ?", style: GoogleFonts.nunitoSans(),),
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


  void show_requestto() {
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.all(20),
              content: StatefulBuilder(
                builder: (context, setState) =>
                    Container(
                        height: 380,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: FutureBuilder(
                            future: getAllrequestTo(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return Center(
                                    child: CircularProgressIndicator()
                                );
                              } else {
                                return snapshot.data == 0 || snapshot.data
                                    .length == 0 ?
                                Container(
                                    height: double.infinity, width: double
                                    .infinity,
                                    child: new
                                    Center(
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            new Text(
                                              "Tidak ada data",
                                              style: new TextStyle(
                                                  fontFamily: 'VarelaRound',
                                                  fontSize: 18),
                                            )
                                          ],
                                        )))
                                    :
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .stretch,
                                  children: [
                                    Padding(padding: const EdgeInsets.only(
                                        top: 5),
                                        child: Container(
                                          height: 55,
                                          child: TextFormField(
                                            enableInteractiveSelection: false,
                                            onChanged: (text) {
                                              setState(() {
                                                filter2 = text;
                                                //print(applink+"mobile/api_mobile.php?act=getAllrequestTo&filter="+text);
                                              });
                                            },
                                            style: GoogleFonts.nunito(
                                                fontSize: 15),
                                            decoration: new InputDecoration(
                                              contentPadding: const EdgeInsets
                                                  .all(10),
                                              fillColor: HexColor("#f4f4f4"),
                                              filled: true,
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets
                                                    .only(bottom: 4),
                                                child: Icon(
                                                  Icons.search, size: 18,
                                                  color: HexColor(
                                                      "#6c767f"),),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1.0,),
                                                borderRadius: BorderRadius
                                                    .circular(5.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: HexColor(
                                                        "#f4f4f4"),
                                                    width: 1.0),
                                                borderRadius: BorderRadius
                                                    .circular(5.0),
                                              ),
                                              hintText: 'Search...',
                                            ),
                                          ),
                                        )
                                    ),
                                    Container(
                                        width: 100,
                                        height: 315,
                                        child: ListView.builder(
                                            itemCount: snapshot.data == null
                                                ? 0
                                                : snapshot.data.length,
                                            itemBuilder: (context, i) {
                                              return SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .only(top: 5),
                                                          child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  //_changeLocation(snapshot.data[i]["a"].toString());
                                                                  _delegate
                                                                      .text =
                                                                      snapshot
                                                                          .data[i]["b"]
                                                                          .toString();
                                                                  delegatedNo =
                                                                      snapshot
                                                                          .data[i]["a"]
                                                                          .toString();
                                                                  delegatedName =
                                                                      snapshot
                                                                          .data[i]["b"]
                                                                          .toString();
                                                                  Navigator
                                                                      .pop(
                                                                      context);
                                                                });
                                                              },
                                                              child: ListTile(
                                                                leading: Container(
                                                                  width: 35,
                                                                  height: 35,
                                                                  decoration: new BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border
                                                                          .all(
                                                                        color: HexColor(
                                                                            "#DDDDDD"),
                                                                        width: 1,
                                                                      )
                                                                  ),
                                                                  child: CircleAvatar(
                                                                    backgroundColor: Colors
                                                                        .white,
                                                                    backgroundImage: AssetImage(
                                                                        'assets/user.png'),
                                                                  ),),
                                                                title: Text(
                                                                  snapshot
                                                                      .data[i]["b"]
                                                                      .toString(),
                                                                  style: GoogleFonts
                                                                      .nunito(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight
                                                                          .bold),),
                                                                subtitle: Text(
                                                                  snapshot
                                                                      .data[i]["c"]
                                                                      .toString(),
                                                                  style: GoogleFonts
                                                                      .nunito(
                                                                      fontSize: 13),),
                                                              )
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding: const EdgeInsets
                                                              .only(top: 5),
                                                          child: Divider(
                                                              height: 1)),
                                                    ],
                                                  )
                                              );
                                            }
                                        )
                                    ),
                                  ],

                                );
                              }
                            }
                        )

                    ),
              )
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        //shape: Border(bottom: BorderSide(color: Colors.red)),
        backgroundColor: HexColor("#3a5664"),
        title: Text("Add Time Off", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
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
                padding: EdgeInsets.only(right: 25,top: 16),
                child: InkWell(
                  child: FaIcon(FontAwesomeIcons.save),
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    showDialog2(context);
                  },
                ),
              )
        ],
      ),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.only(left: 25, top: 5, right: 45),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(alignment: Alignment.centerLeft, child: Padding(
                        padding: const EdgeInsets.only(left: 0, top: 35),
                        child: Text("Time Off Type",
                          style: TextStyle(fontFamily: "VarelaRound",
                              fontSize: 11.5, color: Colors.black87),),
                      ),),
                      Align(alignment: Alignment.centerLeft, child: Padding(
                        padding: const EdgeInsets.only(top: 45),
                        child: DropdownButton(
                          isExpanded: false,
                          hint: Text("Choose time off type",
                            style: GoogleFonts.workSans(
                                fontSize: 15, color: Colors.black),),
                          value: selectedTimeOffTipe,
                          items:
                          timeOffTypeList.map((item) {
                            return DropdownMenuItem(
                              value: item['c'].toString(),
                              child: Text(item['b'].toString(),
                                  style: GoogleFonts.workSans(
                                      fontSize: 15, color: Colors.black)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              FocusScope.of(context).requestFocus(
                                  FocusNode());
                              EasyLoading.show(status: "Loading...");
                              selectedTimeOffTipe = value.toString();
                              _getTimeOffNeedTime(value.toString());

                            });
                          },
                        ),
                      )),
                    ],
                  ),

                  saldoTimeOff.toString() != "" && saldoTimeOff.toString() != "99" ?
                  Padding(padding: const EdgeInsets.only(top: 10,),
        child : Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black26, // Set border color
                  width: 1),
              borderRadius: BorderRadius.all(
                  Radius.circular(5))// Make rounded corner of border
          ),child:  Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    Text("Saldo", style: GoogleFonts.workSans(fontSize: 15,fontWeight: FontWeight.bold)),
                    Text(saldoTimeOff.toString()+" Hari", style: GoogleFonts.workSans(fontSize: 15,fontWeight: FontWeight.bold))
                ]),


        )
                  ) : Container(),

                  Padding(padding: const EdgeInsets.only(top: 15, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        new Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child:
                            TextFormField(
                              style: GoogleFonts.workSans(fontSize: 16),
                              textCapitalization: TextCapitalization
                                  .sentences,
                              controller: _datefrom,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(top: 2),
                                hintText: 'Pick Start Date',
                                labelText: 'Start Date',
                                labelStyle: TextStyle(
                                    fontFamily: "VarelaRound",
                                    fontSize: 15, color: Colors.black87,
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
                              onTap: () async {
                                FocusScope.of(context).requestFocus(
                                    new FocusNode());
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2022),
                                    confirmText: 'CHOOSE',
                                    helpText: 'Select start date',
                                    lastDate: DateTime(2100));
                                if (pickedDate != null) {
                                  String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                                  setState(() {
                                    startDate = pickedDate;
                                    _datefrom.text =
                                        formattedDate; //set output date to TextField value.

                                  });
                                } else {}
                              },
                            ),

                          ),
                        ),
                        new Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child:
                                needTime == 'Yes' ?
                                TextFormField(
                                  style: GoogleFonts.workSans(fontSize: 16),
                                  textCapitalization: TextCapitalization
                                      .sentences,
                                  controller: _TimeStart,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        top: 2),
                                    hintText: 'Pick Time',
                                    labelText: 'Start Time',
                                    labelStyle: TextStyle(
                                        fontFamily: "VarelaRound",
                                        fontSize: 16.5, color: Colors.black87
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior
                                        .always,
                                    hintStyle: GoogleFonts.nunito(
                                        color: HexColor("#c4c4c4"),
                                        fontSize: 15),
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
                                  onTap: () async {
                                    FocusScope.of(context).requestFocus(
                                        new FocusNode());
                                    DatePicker.showTimePicker(context,
                                      //showTitleActions: true,
                                      showSecondsColumn: false,
                                      onChanged: (date) {
                                        selectedTimeStart =
                                            DateFormat("HH:mm").format(date);
                                        _TimeStart.text = selectedTimeStart;
                                      }, onConfirm: (date) {
                                        selectedTimeStart =
                                            DateFormat("HH:mm").format(date);
                                        _TimeStart.text = selectedTimeStart;
                                      },
                                      currentTime: DateTime.now(),);
                                  },
                                ) : Container()
                            )
                        ),
                      ],
                    ),),


                  Padding(padding: const EdgeInsets.only(top: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        new Flexible(
                          child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child:
                              TextFormField(
                                style: GoogleFonts.workSans(fontSize: 16),
                                textCapitalization: TextCapitalization
                                    .sentences,
                                controller: _dateto,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 2),
                                  hintText: 'Pick End Date',
                                  labelText: 'End Date',
                                  labelStyle: TextStyle(
                                      fontFamily: "VarelaRound",
                                      fontSize: 16.5, color: Colors.black87
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior
                                      .always,
                                  hintStyle: GoogleFonts.nunito(
                                      color: HexColor("#c4c4c4"),
                                      fontSize: 15),
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
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(
                                      new FocusNode());
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2022),
                                      confirmText: 'CHOOSE',
                                      helpText: 'Select end date',
                                      lastDate: DateTime(2100));
                                  if (pickedDate != null) {
                                    String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(
                                        pickedDate);
                                    setState(() {
                                      endDate = pickedDate;
                                      _dateto.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                },
                              )

                          ),
                        ),
                        new Flexible(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child:
                              needTime == 'Yes' ?
                              TextFormField(
                                style: GoogleFonts.workSans(fontSize: 16),
                                textCapitalization: TextCapitalization
                                    .sentences,
                                controller: _TimeEnd,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 2),
                                  hintText: 'Pick Time',
                                  labelText: 'End Time',
                                  labelStyle: TextStyle(
                                      fontFamily: "VarelaRound",
                                      fontSize: 16.5, color: Colors.black87
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior
                                      .always,
                                  hintStyle: GoogleFonts.nunito(
                                      color: HexColor("#c4c4c4"),
                                      fontSize: 15),
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
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(
                                      new FocusNode());
                                  DatePicker.showTimePicker(context,
                                    //showTitleActions: true,
                                    showSecondsColumn: false,
                                    onChanged: (date) {
                                      selectedTimeEnd =
                                          DateFormat("HH:mm").format(date);
                                      _TimeEnd.text = selectedTimeEnd;
                                    }, onConfirm: (date) {
                                      selectedTimeEnd =
                                          DateFormat("HH:mm").format(date);
                                      _TimeEnd.text = selectedTimeEnd;
                                    },
                                    currentTime: DateTime.now(),);
                                },
                              ) : Container()


                          ),
                        ),
                      ],
                    ),),


                  Padding(padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        children: [

                          Align(alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: TextFormField(
                                style: GoogleFonts.workSans(fontSize: 16),
                                textCapitalization: TextCapitalization
                                    .sentences,
                                maxLines: 3,
                                controller: _description,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 2),
                                  hintText: 'Description of your time off',
                                  labelText: 'Description',
                                  labelStyle: TextStyle(
                                      fontFamily: "VarelaRound",
                                      fontSize: 16.5, color: Colors.black87
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior
                                      .always,
                                  hintStyle: GoogleFonts.nunito(
                                      color: HexColor("#c4c4c4"),
                                      fontSize: 15),
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

                              ),
                            ),),
                        ],
                      )
                  ),


                  Padding(padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          Align(alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: TextFormField(
                                style: GoogleFonts.workSans(fontSize: 16),
                                textCapitalization: TextCapitalization
                                    .sentences,
                                controller: _delegate,
                                decoration: InputDecoration(
                                  suffixIcon:
                                  _delegate.text != '' ?
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 5),
                                      child:
                                      IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.times, size: 18,),
                                        onPressed: () {
                                          setState(() {
                                            _delegate.clear();
                                          });
                                        },
                                      )) : null,
                                  suffixIconConstraints: BoxConstraints(
                                      minWidth: 23, maxHeight: 30),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.account_circle,
                                      //color: clockColor,
                                    ),
                                  ),
                                  //isDense: true,
                                  prefixIconConstraints: BoxConstraints(
                                      minWidth: 23, maxHeight: 25),
                                  hintText: 'Delegated to (Optional)',
                                  hintStyle: GoogleFonts.nunito(
                                      color: HexColor("#c4c4c4"),
                                      fontSize: 15),
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
                                onTap: () async {
                                  show_requestto();
                                  FocusScope.of(context).requestFocus(
                                      new FocusNode());
                                },
                              ),
                            ),),
                        ],
                      )
                  ),


                  Padding(padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          Align(alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: TextFormField(
                                style: GoogleFonts.workSans(fontSize: 16),
                                textCapitalization: TextCapitalization
                                    .sentences,
                                controller: _uploadme,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 7),
                                  hintText: 'Upload File (max 5MB)',
                                  suffixIcon:
                                  _uploadme.text != '' ?
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 5),
                                      child:
                                      IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.times, size: 18,),
                                        onPressed: () {
                                          setState(() {
                                            _uploadme.clear();
                                          });
                                        },
                                      )) : null,
                                  suffixIconConstraints: BoxConstraints(
                                      minWidth: 23, maxHeight: 30),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.add_a_photo,
                                      //color: clockColor,
                                    ),
                                  ),
                                  //isDense: true,
                                  prefixIconConstraints: BoxConstraints(
                                      minWidth: 23, maxHeight: 35),
                                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                                  hintStyle: GoogleFonts.nunito(
                                      color: HexColor("#c4c4c4"),
                                      fontSize: 15),
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
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(
                                      new FocusNode());
                                  imageSelectorGallery();
                                },
                              ),
                            ),),
                        ],
                      )
                  ),


                ],
              ),
            )
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