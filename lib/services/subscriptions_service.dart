import 'shared_pref_service.dart';
import 'package:academe/constant.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SubscriptionsService {
  static Future<Map> getSubscriptionsData() async {
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
        var uri = Uri.https(kAPIDomain, '/api/subscription', params);
        var response = await http.get(uri);
        Map<String, dynamic> responseMap = convert.jsonDecode(response.body);
        print('Subscriptions Response: ' + responseMap.toString());
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
}
