



import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var value;

  static getEmail() async {
    final SharedPreferences preferences = await _prefs;
    var value1 = preferences.getString('email');
    return value1;
  }
  static getUsername() async {
    final SharedPreferences preferences = await _prefs;
    var value2 = preferences.getString('username');
    return value2;
  }
  static getKaryawanId() async {
    final SharedPreferences preferences = await _prefs;
    var value3 = preferences.getString('karyawan_id');
    return value3;
  }
  static getKaryawanNama() async {
    final SharedPreferences preferences = await _prefs;
    var value4 = preferences.getString('karyawan_nama');
    return value4;
  }
  static getKaryawanNo() async {
    final SharedPreferences preferences = await _prefs;
    var value5 = preferences.getString('karyawan_no');
    return value5;
  }
  static getKaryawanJabatan() async {
    final SharedPreferences preferences = await _prefs;
    var value12 = preferences.getString('karyawan_jabatan');
    return value12;
  }




  //EXTERNAL SESSION======
  static getClockIn() async {
    final SharedPreferences preferences = await _prefs;
    var value6 = preferences.getString('getClockIn');
    return value6;
  }

  static getClockOut() async {
    final SharedPreferences preferences = await _prefs;
    var value7 = preferences.getString('getClockOut');
    return value7;
  }


  static getWorkLocation() async {
    final SharedPreferences preferences = await _prefs;
    var value8 = preferences.getString('getWorkLocation');
    return value8;
  }


  static getWorkLocationId() async {
    final SharedPreferences preferences = await _prefs;
    var value9 = preferences.getString('getWorkLocationId');
    return value9;
  }

  static getWorkLat() async {
    final SharedPreferences preferences = await _prefs;
    var value10 = preferences.getString('getWorkLat');
    return value10;
  }

  static getWorkLong() async {
    final SharedPreferences preferences = await _prefs;
    var value11 = preferences.getString('getWorkLong');
    return value11;
  }

  static getJamMasukSebelum() async {
    final SharedPreferences preferences = await _prefs;
    var value13 = preferences.getString('getJamMasukSebelum');
    return value13;
  }

  static getJamKeluarSebelum() async {
    final SharedPreferences preferences = await _prefs;
    var value14 = preferences.getString('getJamKeluarSebelum');
    return value14;
  }


  static getJamMasuk() async {
    final SharedPreferences preferences = await _prefs;
    var value15 = preferences.getString('getJamMasuk');
    return value15;
  }

  static getJamKeluar() async {
    final SharedPreferences preferences = await _prefs;
    var value16 = preferences.getString('getJamKeluar');
    return value16;
  }

  static getStartTime() async {
    final SharedPreferences preferences = await _prefs;
    var value17 = preferences.getString('getStartTime');
    return value17;
  }

  static getEndTime() async {
    final SharedPreferences preferences = await _prefs;
    var value18 = preferences.getString('getEndTime');
    return value18;
  }

  static getScheduleMessage() async {
    final SharedPreferences preferences = await _prefs;
    var value19 = preferences.getString('getScheduleMessage');
    return value19;
  }

  static getScheduleID() async {
    final SharedPreferences preferences = await _prefs;
    var value20 = preferences.getString('getScheduleID');
    return value20;
  }

}