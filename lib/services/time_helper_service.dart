import 'dart:async';
//import 'dart:convert';

import 'package:flutter/services.dart';
//import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart';

class TimeHelperService {
  void setup() async {
    try {
      var byteData = await rootBundle.load('packages/timezone/data/2019c.tzf');
      initializeDatabase(byteData.buffer.asUint8List());
    }
    catch (e) {
      print('Unable to load time zone file' + e.toString());
    }

  }

  final String timeAPIURL =
      'https://worldtimeapi.org/api/timezone/Asia/Kolkata';
  final String localTimeIndex = 'datetime';

  Future getCurrentTimeInUTC() async {
    //final response = await http.get(timeAPIURL);
    //Map<String, dynamic> responseMap = jsonDecode(response.body);
    //return responseMap[localTimeIndex];

    //TEMPORARILY USING DEVICE TIME
    var now = new DateTime.now();
    print(now);
    return now;

  }

  String getMonthName(DateTime dateTime) {
    switch (dateTime.month.toString()) {
      case '1':
        {
          return 'January';
        }
      case '2':
        {
          return 'February';
        }
      case '3':
        {
          return 'March';
        }
      case '4':
        {
          return 'April';
        }
      case '5':
        {
          return 'May';
        }
      case '6':
        {
          return 'June';
        }
      case '7':
        {
          return 'July';
        }
      case '8':
        {
          return 'August';
        }
      case '9':
        {
          return 'September';
        }
      case '10':
        {
          return 'October';
        }
      case '11':
        {
          return 'November';
        }
      case '12':
        {
          return 'December';
        }
    }
    return '';
  }

  String getWeekdayName(DateTime dateTime) {
    switch (dateTime.weekday.toString()) {
      case '1':
        {
          return 'Monday';
        }
      case '2':
        {
          return 'Tuesday';
        }
      case '3':
        {
          return 'Wednesday';
        }
      case '4':
        {
          return 'Thursday';
        }
      case '5':
        {
          return 'Friday';
        }
      case '6':
        {
          return 'Saturday';
        }
      case '7':
        {
          return 'Sunday';
        }
    }
    return '';
  }
}
