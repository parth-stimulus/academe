import 'shared_pref_service.dart';
import 'package:academe/constant.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AuthenticationService {
  static Future<bool> isAuthenticated() async {
    Map _authTokenResultMap = new Map();
    try {
      _authTokenResultMap =
          await SharedPrefService.fetchFromSharedPref('authToken');
      if (_authTokenResultMap.containsKey('error')) {
        throw Exception(_authTokenResultMap['error']);
      }
      print(_authTokenResultMap.toString());
      if (_authTokenResultMap.containsKey('authToken') &&
          _authTokenResultMap['authToken'] != null &&
          _authTokenResultMap['authToken'].toString().isNotEmpty) {
        return true;
      }
    } catch (e) {
      print('Error occured while checking token: ' + e.toString());
      return false;
    }
    return false;
  }

  static Future<Map> getLoggedInUserDataFromAPI() async {
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
        Map<String, String> params = {
          "token": _authTokenResult['authToken'],
        };
        print(params.toString());
        var uri = Uri.https(kAPIDomain, '/api/me', params);
        var response = await http.get(uri);
        Map<String, dynamic> responseMap = convert.jsonDecode(response.body);
        print('ME Response: ' + responseMap.toString());
        if (responseMap["error"] == true) {
          throw Exception(responseMap["cause"].toString());
        }
        result['data'] = responseMap["data"];
        return result;
      }
    } catch (e) {
      print('Error occured while getting user data: ' + e.toString());
      return result;
    }
    return result;
  }
  static Future<Map> forgotPassword(String email) async {
    Map<String, Object> result = new Map();
    try {
      var uri = Uri.https(kAPIDomain, '/api/forgotpassword');
      Map requestData = {
        "email": email,
      };
      var body = convert.jsonEncode(requestData);
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = convert.jsonDecode(response.body);

      print('forgotpassword Response: ' + responseMap.toString());
      if (responseMap["error"] == true) {
        throw Exception(responseMap["cause"].toString());
      }
      result['data'] = responseMap["data"];
      return result;
    } catch (e) {
      print('Error occured while sending new password: ' + e.toString());
      return result;
    }
  }
}
