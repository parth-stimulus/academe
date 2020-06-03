import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<Map> storeInSharedPref(String key, String value) async {
    Map<String, Object> result = new Map();
    result['isStored'] = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      result['isStored'] = await prefs.setString(key, value);
    } catch (e) {
      result['error'] =
          'Error occured while storing ' + key + ': ' + e.toString();
    }
    return result;
  }

  static Future<Map> fetchFromSharedPref(String key) async {
    Map<String, Object> result = new Map();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      result[key] = prefs.getString(key);
    } catch (e) {
      result['error'] =
          'Error occured while getting ' + key + ': ' + e.toString();
    }
    return result;
  }

  static Future<Map> clear() async {
    Map<String, Object> result = new Map();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      result['cleared'] = prefs.clear();
      print('Persistence storage cleared.');
    } catch (e) {
      result['error'] =
          'Error occured while clearing shared prefernces : ' + e.toString();
    }
    return result;
  }
//  static Future<Map> storeAuthToken(String token) async {
//    Map<String, Object> result = new Map();
//    result['isStored'] = false;
//    try {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      result['isStored'] = await prefs.setString('authToken', token);
//    } catch (e) {
//      result['error'] =
//          'Error occured while storing auth token: ' + e.toString();
//    }
//    return result;
//  }
//
//  static Future<Map> fetchAuthToken() async {
//    Map<String, Object> result = new Map();
//    try {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      result['token'] = prefs.getString('authToken');
//    } catch (e) {
//      result['error'] =
//          'Error occured while getting auth token: ' + e.toString();
//    }
//    return result;
//  }
//
//  static Future<Map> storeUserName(String userName) async {
//    Map<String, Object> result = new Map();
//    result['isStored'] = false;
//    try {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      result['isStored'] = await prefs.setString('userName', userName);
//    } catch (e) {
//      result['error'] =
//          'Error occured while storing user name: ' + e.toString();
//    }
//    return result;
//  }
//
//  static Future<Map> fetchUserName() async {
//    Map<String, Object> result = new Map();
//    try {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      result['userName'] = prefs.getString('userName');
//    } catch (e) {
//      result['error'] =
//          'Error occured while getting user name: ' + e.toString();
//    }
//    return result;
//  }
}
