import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:academe/constant.dart';

class EmailAuthService {
  static Future<Map<String, Object>> registerUser(
      String email, String password, String fullName) async {
    Map<String, Object> result = new Map();
    try {
      var uri = Uri.https(kAPIDomain, '/api/signup');
      Map requestData = {
        "name": fullName,
        "email": email,
        "password": password
      };
      var body = convert.jsonEncode(requestData);
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = convert.jsonDecode(response.body);
      print('Response: ' + responseMap.toString());
      if (responseMap["error"] == true) {
        throw Exception(responseMap["cause"].toString());
      }
      result['data'] = responseMap["data"];
      return result;
    } catch (e) {
      result['error'] =
          'Error occured while registering your account: ' + e.toString();
      return result;
    }
  }

  static Future<Map<String, Object>> signInWithEmailAndPassword(
      String email, String password) async {
    Map<String, Object> result = new Map();
    try {
      var uri = Uri.https(kAPIDomain, '/api/login');
      Map requestData = {"email": email, "password": password};
      var body = convert.jsonEncode(requestData);
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = convert.jsonDecode(response.body);
      print('Response: ' + responseMap.toString());
      if (responseMap["error"] == true) {
        throw Exception(responseMap["cause"].toString());
      }
      result['data'] = responseMap["data"];
      return result;
    } catch (e) {
      result['error'] = 'Error occured while logging in: ' + e.toString();
      return result;
    }
  }

  static Future<Map<String, Object>> doesAccountExist(String email) async {
    Map<String, Object> result = new Map();
    try {
      var uri = Uri.https(kAPIDomain, '/api/userexists');
      Map requestData = {
        "email": email,
      };
      var body = convert.jsonEncode(requestData);
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = convert.jsonDecode(response.body);
      print('Response: ' + responseMap.toString());
      if (responseMap["error"] == true &&
          responseMap["cause"].toString() == "email does not exist") {
        responseMap["exists"] = false;
      } else if (responseMap["error"] == false &&
          responseMap["data"].toString() == 'User already exists') {
        responseMap["exists"] = true;
      } else {
        throw Exception(
            'Unable to check whehter the account exits or not. Please contact support');
      }
      result['exists'] = responseMap["exists"];
      return result;
    } catch (e) {
      result['error'] =
          'Error occured while checking the account: ' + e.toString();
      return result;
    }
  }
}
