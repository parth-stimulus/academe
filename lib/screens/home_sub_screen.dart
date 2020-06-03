import 'package:academe/components/new_courses.dart';
import 'package:academe/screens/all_streams_screen.dart';
import 'package:flutter/material.dart';
import 'package:academe/screens/course_detail_screen.dart';
import 'package:academe/screens/stream_detail_screen.dart';
import 'package:academe/constant.dart';
import 'package:academe/components/slider.dart';
import 'package:academe/components/buttons.dart';
import 'package:academe/components/streams_view.dart';

class HomeSubScreen extends StatefulWidget {
  @override
  _HomeSubScreenState createState() => _HomeSubScreenState();
}

class _HomeSubScreenState extends State<HomeSubScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome to',
                style: TextStyle(
                    color: AcademeAppTheme.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Image.asset(
                'assets/images/academe_logo.png',
                height: 30,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8),
          child: OffersSlider(sliderData: [
            'assets/images/Banner1.png',
            'assets/images/Banner2.png',
            'assets/images/Banner3.png'
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 15, right: 16),
          child: Text(
            'What\'s New',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 1.0),
          ),
        ),
        NewCourses(
            callBack: (popularCourses) {
              moveToCourseDetailScreen(popularCourses);
            },
            url: Uri.https(kAPIDomain, '/api/popularcourses').toString()),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 15, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Top Streams',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.0),
              ),
              Buttons.miniPrimaryButton('View All', () {
                //Navigate to all streams
                Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => AllStreams(),
                  ),
                );
              })
            ],
          ),
        ),
        StreamsView(
          callBack: (streamData) {
            moveToStreamDetailScreen(streamData);
          },
          url: Uri.https(kAPIDomain, '/api/topstreams').toString(),
        ),
      ],
    );
  }

  void moveToCourseDetailScreen(Map<dynamic, dynamic> popularCourses) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => CourseDetailScreen(
          courseDetails: popularCourses,
          isSubscribed: false,
        ),
      ),
    );
  }

  void moveToStreamDetailScreen(Map<dynamic, dynamic> streamData) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => StreamDetailScreen(
          streamId: streamData,
        ),
      ),
    );
  }
}
