


import 'dart:async';
import 'dart:convert';

import 'package:abzeno/attendance/page_doattendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart%20';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geolocator; // you can change this to what you want
import 'package:location/location.dart' as locator;
import '../helper/app_helper.dart';
import '../helper/app_link.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helper/page_route.dart';
import '../page_login.dart';


class PageClockIn extends StatefulWidget{
  final String getKaryawanNo;
  final String getJam;
  final String getLocationId;
  final String getNamaHari;
  final String getLocationLat;
  final String getLocationLong;
  final String getScheduleID;
  final String getAttendanceType;
  final String getKaryawanNama;
  final String getKaryawanJabatan;
  const PageClockIn(this.getKaryawanNo,this.getJam,this.getLocationId, this.getNamaHari,
      this.getLocationLat, this.getLocationLong,this.getScheduleID,this.getAttendanceType,this.getKaryawanNama,
      this.getKaryawanJabatan);
  @override
  _PageClockIn createState() => _PageClockIn();
}



class _PageClockIn extends State<PageClockIn> {
  late double _distanceInMeters;
  bool _isvisibleBtn = false;
  bool isPressed = false;
  var jarak = 0;
  LatLng _initialcameraposition = LatLng(-7.281798579483975, 112.73688279669264);
  late LatLng currentPostion = LatLng(-7.281798579483975, 112.73688279669264);
  late LatLng _locationCabang;
  late GoogleMapController _controller;
  locator.Location _location = locator.Location();
  bool servicestatus = false;
  bool haspermission = false;
  late geolocator.Position position;
  String long = "", lat = "";
  final _noteclockin = TextEditingController();
  //Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Set<Marker> markers = new Set();




  checkGps() async {
    setState(() {
      _locationCabang = LatLng(double.parse(widget.getLocationLat), double.parse(widget.getLocationLong));
    });
    LocationPermission permission = await Geolocator.checkPermission();
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppHelper().showFlushBarerror(context,'Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          AppHelper().showFlushBarerror(context,"'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }
      if(haspermission){
        await getLocation();
      }
    }else{
      AppHelper().showFlushBarerror(context,"GPS Service is not enabled, turn on GPS location");
    }
    setState((){});
  }




  late LocationSettings locationSettings;

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      long = position.longitude.toString();
      lat = position.latitude.toString();
      getme(long,lat);
    });
   /*position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {
        long = position.longitude.toString();
        lat = position.latitude.toString();
        getme(long,lat);
        setState(() {});
    });
   positionStream;*/

  }


  void _onMapCreated(GoogleMapController _cntlr) async
  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          //CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
          CameraPosition(target: currentPostion,zoom: 15),
        ),
      );
    });
  }


  Set<Marker> getmarkers() { //markers to place on map
    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId(currentPostion.toString()),
        position: currentPostion, //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Lokasi Saya',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add second marker
        markerId: MarkerId(_locationCabang.toString()),
        position: _locationCabang, //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Lokasi Absen',
          //snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });
    return markers;
  }





  void getme(String LongVal, String LatVal) async {
    _distanceInMeters = await GeolocatorPlatform.instance.distanceBetween(double.parse(widget.getLocationLat)
        , double.parse(widget.getLocationLong), double.parse(LatVal), double.parse(LongVal));
    jarak = _distanceInMeters.ceil();
  }



  _startingVariable() async {
    _noteclockin.clear();
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      AppHelper().showFlushBarsuccess(context,"Koneksi terputus..");
      EasyLoading.dismiss();
      return false;
    }});
    await AppHelper().getSession().then((value){
      setState(() {
        if(value[0] == "" || value[0] == null) {
          Navigator.pushReplacement(context, ExitPage(page: PageLogin()));
          EasyLoading.dismiss();
        }
      });});
    await checkGps();
    setState(() {
      _isvisibleBtn = true;
    });
    EasyLoading.dismiss();
  }


  _loaddata() async {
      await _startingVariable();
  }

  @override
  void initState() {
    super.initState();
    _loaddata();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        backgroundColor: HexColor("#128C7E"),
        title: Text(widget.getJam, style: GoogleFonts.nunito(fontSize: 20),),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 20,),
              color: Colors.white,
              onPressed: ()  {
                Navigator.pop(context);

              }),
        ),

      ),
      body: Container(
        width: double.infinity,
        height: 350,
        child: SingleChildScrollView(
          child : Column(
            children: <Widget>[
              Container(
                height: 180,
                child : GoogleMap(
                  initialCameraPosition: CameraPosition(target: currentPostion),
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: false,
                  markers: getmarkers(),
                  zoomGesturesEnabled : false,
                  scrollGesturesEnabled : false,
                  rotateGesturesEnabled : false,
                  circles: Set.from([Circle( circleId: CircleId('currentCircle'),
                    center: _locationCabang,
                    radius: 300,
                    fillColor: Colors.blue.shade100.withOpacity(0.5),
                    strokeColor:  Colors.blue.shade100.withOpacity(0.1),
                  ),],),
                ),
              ),

              Padding(padding: const EdgeInsets.only(left: 25,top: 5,right: 25),
                  child: Column(
                    children: [


                  widget.getAttendanceType == 'Clock In' ?
                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 0,top: 15),
                        child: Text("Note  ",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                            fontSize: 12,color: HexColor("#0074D9")),),
                      ),)
                  : Container(),
                      widget.getAttendanceType == 'Clock In' ?
                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: TextFormField(
                          style: GoogleFonts.nunito(fontSize: 16),
                          textCapitalization: TextCapitalization.sentences,
                          controller: _noteclockin,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top:2),
                            hintText: 'Input Attendance Note',
                            labelText: '',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4"), fontSize: 13),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD")),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#8c8989")),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD")),
                            ),
                          ),
                        ),
                      ),): Container()
                    ],
                  )
              ),

              Padding(padding: const EdgeInsets.only(top: 40,left: 25,right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child:     Text(
                        "Your distance from current location",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.varelaRound(fontSize: 12),
                      ),
                    ),
                    Text(jarak.toString()+" meters",
                        style: GoogleFonts.varelaRound(fontSize: 13,fontWeight: FontWeight.bold)),
                  ],
                ),),
              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Align(alignment: Alignment.centerLeft, child : Text("(Not Allowed in more than 60 meters)",
                    style: GoogleFonts.varelaRound(fontSize: 10))),
              ),
              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Divider(),
              ),
            ],
          )
        ),
      ),
      bottomSheet: Container(
        height: 120,
        width: double.infinity,
        child : Column(
          children: [

       Opacity(
         opacity: 0.8,
         child :    Container(
           width: double.infinity,
           color: HexColor("#DDDDDD"),
           padding : const EdgeInsets.only(left: 25,right: 25),
           child: ListTile(
               leading: FaIcon(FontAwesomeIcons.infoCircle,size: 25,),
               title: Padding(
                 padding: const EdgeInsets.all(5),
                 child: Text("Pastikan GPS anda menyala saat melakukan absensi",style: GoogleFonts.nunitoSans(fontSize: 12),),
               )
           ),
         ),
       ),
            Container(
                width: double.infinity,
                height: 62,
                padding : const EdgeInsets.only(left: 25,right: 25,bottom: 10,top: 5),
                child :
                  Visibility(
                    visible: _isvisibleBtn,
                    child:

                    isPressed == false ?
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: HexColor("#075E54"),
                          shape: RoundedRectangleBorder(side: BorderSide(
                              color: Colors.white,
                              width: 0.1,
                              style: BorderStyle.solid
                          ),
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                      child : Text(widget.getAttendanceType.toString(), style: GoogleFonts.lato(fontWeight: FontWeight.bold,color: Colors.white),),
                      onPressed: (){
                        setState(() {
                          //isPressed = true;
                        });
                        //_addattendance();
                        if(int.parse(jarak.toString()) > 999999999 ) {
                          AppHelper().showFlushBarerror(context, "Maaf anda tidak absen karena berada diluar area yang ditentukan");
                          setState(() {
                            //isPressed = false;
                          });
                          return;
                        } else {

                          FocusScope.of(context).requestFocus(FocusNode());
                          widget.getAttendanceType.toString() == 'Clock In' ?
                          Navigator.push(context, ExitPage(page: ClockOut(
                              widget.getKaryawanNo,
                              widget.getJam,
                              AppHelper().getNamaHari().toString(),
                              widget.getScheduleID,
                              _noteclockin.text,
                              "Clock In",
                              widget.getKaryawanNama,
                          widget.getKaryawanJabatan)))
                              :
                          Navigator.push(context, ExitPage(page: ClockOut(
                              widget.getKaryawanNo,
                              widget.getJam,
                              AppHelper().getNamaHari().toString(),
                              widget.getScheduleID,
                              _noteclockin.text,
                              "Clock Out",
                              widget.getKaryawanNama,
                              widget.getKaryawanJabatan)));
                        }
                        //EasyLoading.show(status: "Loading...");
                      },
                    )
                :
                Opacity(
                  opacity : 0.5,
                      child : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: HexColor("#DDDDDD"),
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.white,
                                width: 0.1,
                                style: BorderStyle.solid
                            ),
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        child : Text("CLOCK IN", style: GoogleFonts.lato(fontWeight: FontWeight.bold,color: Colors.white),),
                        onPressed: (){
                        },
                      )
                    )
                )
            ),
          ],
        )
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

