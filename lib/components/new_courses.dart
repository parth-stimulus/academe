import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';

import '../constant.dart';

class NewCourses extends StatefulWidget {
  const NewCourses({Key key, this.callBack, this.url}) : super(key: key);

  final Function callBack;
  final String url;

  @override
  _NewCoursesState createState() => _NewCoursesState();
}

class _NewCoursesState extends State<NewCourses> with TickerProviderStateMixin {
  Map<dynamic, dynamic> popularCourses;

  @override
  void initState() {
    super.initState();
  }

  Future getCourses() async {
    var url = widget.url;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      popularCourses = jsonResponse['data'];
      // log("what's new: $popularCourses");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return popularCourses;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 134,
      width: double.infinity,
      child: FutureBuilder(
        future: getCourses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 0, bottom: 0, right: 16, left: 16),
              itemCount: snapshot.data['courses'].length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return CategoryView(
                  category: snapshot.data['courses'][index],
                  callback: () {
                    widget.callBack(snapshot.data['courses'][index]);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({Key key, this.category, this.callback}) : super(key: key);

  final VoidCallback callback;
  final category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        callback();
      },
      child: SizedBox(
        width: 280,
        child: Stack(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 48,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48 + 24.0,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          category['name'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0, right: 16, bottom: 8),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          '${category['total_sessions'].toString()} lesson',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          category['stream_name'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 24, left: 16),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                      child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Image.network(
                            category['courses_image'] != null
                                ? category['courses_image']
                                : Uri.https(kAPIDomain, 'storage/Hindi-Literature.jpeg'),
                            fit: BoxFit.contain,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
