import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:academe/constant.dart';
import 'shared_pref_service.dart';

class ProfileService {
  static Future<Map<String, Object>> updateUserProfile(
      {String name, String email}) async {
    String authToken;
    Map<String, Object> result = new Map();
    try {
      Map _authTokenResult =
          await SharedPrefService.fetchFromSharedPref('authToken');
      if (_authTokenResult.containsKey('error')) {
        throw Exception(_authTokenResult['error']);
      }
      if (_authTokenResult.containsKey('authToken') &&
          _authTokenResult['authToken'] != null &&
          _authTokenResult['authToken'].toString().isNotEmpty) {
        authToken = _authTokenResult['authToken'];
      }
      var uri = Uri.https(kAPIDomain, '/api/updateprofile');
      Map requestData = {"token": authToken};
      if (name != null && name.isNotEmpty) {
        requestData['name'] = name;
      }
      if (email != null && email.isNotEmpty) {
        requestData['email'] = email;
      }
      var body = convert.jsonEncode(requestData);
      print("Profile update request body: " + requestData.toString());
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

  static Future<Map<String, Object>> changePassword(String currentPassword,
      String newPassword, String newPasswordConfirm) async {
    String authToken;
    Map<String, Object> result = new Map();
    try {
      Map _authTokenResult =
          await SharedPrefService.fetchFromSharedPref('authToken');
      if (_authTokenResult.containsKey('error')) {
        throw Exception(_authTokenResult['error']);
      }
      if (_authTokenResult.containsKey('authToken') &&
          _authTokenResult['authToken'] != null &&
          _authTokenResult['authToken'].toString().isNotEmpty) {
        authToken = _authTokenResult['authToken'];
      }
      var uri = Uri.https(kAPIDomain, '/api/changepassword');
      Map requestData = {
        "current_password": currentPassword,
        "new_password": newPassword,
        "new_password_confirmation": newPasswordConfirm,
        "token": authToken
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
          'Error occured while updating password: ' + e.toString();
      return result;
    }
  }

  static Future<Map<String, Object>> contactUs(
      String subject, String message) async {
    String authToken;
    Map<String, Object> result = new Map();
    try {
      Map _authTokenResult =
          await SharedPrefService.fetchFromSharedPref('authToken');
      if (_authTokenResult.containsKey('error')) {
        throw Exception(_authTokenResult['error']);
      }
      if (_authTokenResult.containsKey('authToken') &&
          _authTokenResult['authToken'] != null &&
          _authTokenResult['authToken'].toString().isNotEmpty) {
        authToken = _authTokenResult['authToken'];
      }
      var uri = Uri.https(kAPIDomain, '/api/contactus');
      Map requestData = {
        "subject": subject,
        "message": message,
        "token": authToken
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
      result['error'] = 'Error occured while sending message: ' + e.toString();
      return result;
    }
  }
}
