import 'package:academe/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:academe/constant.dart';
import 'course_detail_screen.dart';
import 'package:academe/services/subscriptions_service.dart';
import 'package:academe/components/buttons.dart';
import 'package:academe/screens/home_screen.dart';

class SubscriptionsSubScreen extends StatefulWidget {
  static String id = 'subscription_sub_screen';
  @override
  _SubscriptionsSubScreenState createState() => _SubscriptionsSubScreenState();
}

class _SubscriptionsSubScreenState extends State<SubscriptionsSubScreen> {
  Future<Map> _subscriptionsData;
  Future<bool> _isAuthenticated;
  Map screenData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isAuthenticated,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return FutureBuilder(
                future: _subscriptionsData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data);
                  if (snapshot.hasData) {
                    if (snapshot.data['data'] == null) {
                      if (snapshot.data['error'] == true) {
                        return Center(
                            child: Text(
                                'Error while loading data, please retry' +
                                    snapshot.data['error']['cause']));
                      }
                      return Center(
                          child:
                              Text('Error while loading data, please retry'));
                    }
                    List subCourseDataFromAPI =
                        snapshot.data['data']['courses'];
                    if (subCourseDataFromAPI.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          'Oops! It seems you have not subscribed to any courses yet.',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Scrollbar(
                        child: ListView.builder(
//                physics: const NeverScrollableScrollPhysics(),
//                shrinkWrap: true,
                            itemCount: subCourseDataFromAPI.length,
                            itemBuilder: (BuildContext context, int index) {
                              return courseList(subCourseDataFromAPI[index]);
                            }),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error while loading data, please retry'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else if (snapshot.data == false) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    Text(
                      'Your subscriptions will appear here when you are logged in.',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Buttons.primary(text: 'Login', onTap: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage(subScreenIndex: 2)), (_) => false);
                      }),
                    )
                  ],
                )),
              );
            }
            return Center(
                child: Text('Error occured while checking authentication'));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error while loading data, please retry'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget courseList(Map data) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => CourseDetailScreen(
                  courseDetails: data,
                  isSubscribed: true,
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
              )),
          title: Row(
            children: <Widget>[
              Text(
                data['name'].trim(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Spacer(),
              Text(
                data['course_duration'],
                style:
                    TextStyle(color: AcademeAppTheme.lightText, fontSize: 12),
              )
            ],
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    data['total_sessions'].toString() + ' Sessions',
                    style: TextStyle(
                        color: AcademeAppTheme.lightText, fontSize: 12),
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _isAuthenticated = AuthenticationService.isAuthenticated();
    _subscriptionsData = SubscriptionsService.getSubscriptionsData();
  }
}
