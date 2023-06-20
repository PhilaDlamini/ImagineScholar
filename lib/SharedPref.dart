import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//For saving data to shared preferences
class SharedPref {

  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? val = prefs.getString(key);
    if(val == null) return null;
    return json.decode(val);
  }

  static save(String key, data) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(data);
    prefs.setString(key, encoded);
  }


}