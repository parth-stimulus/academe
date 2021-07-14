import 'package:academe/screens/purchase_course_screen.dart';
import 'package:academe/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:academe/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:chewie/chewie.dart';

class CourseDetailScreen extends StatefulWidget {
  Map<dynamic, dynamic> courseDetails;
  bool isSubscribed;

  CourseDetailScreen({@required this.courseDetails, @required this.isSubscribed});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
  String videoUrl;
  Map<dynamic, dynamic> courseData;
  Future<Map> userData;
  bool courseSubscribed;

  @override
  void initState() {
    super.initState();
    print('------course details-----');
    // print(widget.courseDetails);
    videoUrl = widget.courseDetails['intro_video'];
    _videoPlayerController1 = VideoPlayerController.network(videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoInitialize: true,
    );
    userData = AuthenticationService.getLoggedInUserDataFromAPI();
    userData.then((subscriptionData) {
      print('--------------object------------');
      var length = subscriptionData['data']['courses'].length;
      for (var i = 0; i < length; i++) {
        if (subscriptionData['data']['courses'][i]['id'] == widget.courseDetails['id']) {
          this.setState(() {
            courseSubscribed = true;
          });
        } else {
          continue;
        }
      }
    });
  }

  getCourseData() async {
    var url = Uri.https(kAPIDomain, '/api/coursedetails/').toString() + widget.courseDetails['id'].toString();
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      courseData = jsonResponse['data'];
      // print('Stream data: $courseData.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return courseData;
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseDetails['name']),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(padding: const EdgeInsets.only(top: 20.0)),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Introduction',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                height: 300,
                child: Center(
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: LinearGradient(
                  // Where the linear gradient begins and ends

                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.2, 0.9],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    Colors.deepPurple[700],
                    Colors.blue[600],
                  ],
                ),
              ),
              child: InkWell(
                onTap: () {
                  this.setState(() {
                    _videoPlayerController1.pause();
                    _chewieController.pause();
                  });
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => PurchaseCourseScreen(
                        selectedCourseData: widget.courseDetails,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '₹ ' + widget.courseDetails['price'].toString(),
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: <Widget>[
                          Text(
                            'Purchase Course',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'What is covered in this course?',
                        style: TextStyle(fontSize: 12, color: AcademeAppTheme.lightText),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      widget.courseDetails['description'],
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
                            'All Sessions',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                          Text(
                            widget.courseDetails['total_sessions'].toString() + ' Sessions',
                            style: TextStyle(fontSize: 16, color: AcademeAppTheme.lightText),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: getCourseData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      print('-------data-----------');
                      // print(snapshot.data);

                      if (!snapshot.hasData) {
                        return const SizedBox();
                      } else {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data['sessions']['data'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return courseList(snapshot.data['sessions']['data'][index]);
                          },
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
      onTap: () {
        if (courseSubscribed == true && courseSubscribed != null) {
          this.setState(() {
            _videoPlayerController1.pause();
            _chewieController.pause();
            videoUrl = data['video_url'];
            _videoPlayerController1 = VideoPlayerController.network(videoUrl);
            _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController1,
              aspectRatio: 3 / 2,
              autoInitialize: true,
            );
          });
        } else {
          Fluttertoast.showToast(
              msg: "You need to purchase this course to view this session.", toastLength: Toast.LENGTH_LONG);
        }
      },
      isThreeLine: true,
      contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.network(
            data['image'],
            width: 80.0,
            height: 80.0,
            fit: BoxFit.contain,
          )),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              data['name'],
              overflow: TextOverflow.visible,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Spacer(),
          Text(
            data['course_duration'],
            style: TextStyle(color: AcademeAppTheme.lightText, fontSize: 12),
          )
        ],
      ),
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  data['description'],
                  style: TextStyle(color: AcademeAppTheme.lightText, fontSize: 12),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: <Widget>[
                Text(
                  'Start Now >',
                  style: TextStyle(color: AcademeAppTheme.primaryColor, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
