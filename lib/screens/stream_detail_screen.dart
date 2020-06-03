import 'package:academe/screens/course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:academe/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class StreamDetailScreen extends StatefulWidget {

  final Map streamId;
  StreamDetailScreen({
    @required this.streamId,
  });
  @override
  _StreamDetailScreenState createState() => _StreamDetailScreenState();
}

class _StreamDetailScreenState extends State<StreamDetailScreen> {
  Map <dynamic,dynamic> streamData;

  var courseData = <Map> [
    {
      'imagePath': 'assets/design_course/interFace3.png',
      'title': 'User interface Design',
      'subtitle': '23 sessions',
      'duration': '2h 20m',
      'money': 399,
      'purchaseDate': '13/04/2020',
    },
    {
      'imagePath': 'assets/design_course/interFace4.png',
      'title': 'User interface Design',
      'subtitle': '23 sessions',
      'duration': '2h 20m',
      'money': 399,
      'purchaseDate': '13/04/2020',
    },
    {
      'imagePath': 'assets/design_course/interFace4.png',
      'title': 'User interface Design',
      'subtitle': '23 sessions',
      'duration': '2h 20m',
      'money': 399,
      'purchaseDate': '13/04/2020',
    },
    {
      'imagePath': 'assets/design_course/interFace3.png',
      'title': 'User interface Design',
      'subtitle': '23 sessions',
      'duration': '2h 20m',
      'money': 399,
      'purchaseDate': '13/04/2020',
    }
  ];

  @override
  void initState() {
    super.initState();
//    streamData = getStreamData();
//    print('INIT: $streamData.');
  }

  getStreamData() async {
    var url = Uri.https(kAPIDomain, '/api/streamdetails/').toString()
        +widget.streamId['id'].toString();
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      streamData = jsonResponse['data'];
      print('Stream data: $streamData.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return streamData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.streamId['name']),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Image.asset(
                'assets/images/StreamImage1.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'About '+widget.streamId['name'],
                        style: TextStyle(fontSize: 12, color: AcademeAppTheme.lightText),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      widget.streamId['description'],
                      style: TextStyle(fontSize: 12, color: AcademeAppTheme.lightText),

                    ),
                  )

                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.streamId['total_courses'].toString()+' Courses for '+ widget.streamId['name'],
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: getStreamData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      print('-------data-----------');
                      print(snapshot.data);

                      if (!snapshot.hasData) {
                        return const SizedBox();
                      } else {
                        return ListView.builder(
//                    physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data['courses']['data'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return courseList(snapshot.data['courses']['data'][index]);
                            }

                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget courseList(Map data) {
    return ListTile(
      onTap: (){
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => CourseDetailScreen(
              courseDetails: data,
              isSubscribed: false,
            ),
          ),
        );
      },
      isThreeLine: true,
      contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.network(
            data['courses_image'],
            width: 80.0,
            height: 80.0,
            fit: BoxFit.contain,
          )
      ),
      title: Row(
        children: <Widget>[
          Text(
            data['name'].trim(),
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16
            ),
          ),
          Spacer(),
          Text(
            data['course_duration'],
            style: TextStyle(
                color: AcademeAppTheme.lightText,
                fontSize: 12
            ),
          )
        ],
      ),
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                data['total_sessions'].toString()+' Sessions',
                style: TextStyle(
                    color: AcademeAppTheme.lightText,
                    fontSize: 12
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: <Widget>[
                Text(
                  'View Course',
                  style: TextStyle(
                      color: AcademeAppTheme.primaryColor,
                      fontSize: 12
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

