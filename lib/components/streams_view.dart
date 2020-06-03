import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:academe/screens/stream_detail_screen.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';


class StreamsView extends StatefulWidget {
  const StreamsView({Key key, this.callBack, this.url}) : super(key: key);

  final Function callBack;
  final String url;
  @override
  _StreamsViewState createState() => _StreamsViewState();
}

class _StreamsViewState extends State<StreamsView>
    with TickerProviderStateMixin {
  Map <dynamic,dynamic> topStreams;
  @override
  void initState() {
    super.initState();
  }


  Future<dynamic> getStreams() async {
//    var url = 'http://159.65.154.185:89/api/topstreams';
    var response = await http.get(widget.url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      topStreams = jsonResponse['data'];
     // print('Top Streams: $topStreams.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return topStreams;
  }

  void moveToStreamDetailScreen() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => StreamDetailScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<dynamic>(
        future: getStreams(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
         // print('--------------test--------------');
          //print(snapshot.data);
          print(snapshot.hasError);
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return GridView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              physics: NeverScrollableScrollPhysics(),
              children: List<Widget>.generate(
                snapshot.data['streams'].length,
                (int index) {
                  return Container(
                    height: 300,
                    child: StreamView(
                      callback: () {
                        widget.callBack(snapshot.data['streams'][index]);
                      },
                      stream: snapshot.data['streams'][index],
                    ),
                  );
                },
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 32.0,
                crossAxisSpacing: 32.0,
              ),
            );
          }
        },
      ),
    );
  }
}

class StreamView extends StatelessWidget {
  const StreamView(
      {Key key,
      this.stream,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final stream;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        callback();
      },
      child: SizedBox(
        height: 280,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, left: 26, right: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: TextOneLine(
                                            stream['name'],
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, left: 26, right: 16, bottom: 4),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          stream['total_courses'].toString() +
                                              ' Courses',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:0.0),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                        child: Image.network(stream['image'],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
//                  const SizedBox(
//                    height: 50,
//                  ),
                ],
              ),
            ),
//            Padding(
//              padding: const EdgeInsets.all(20.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                children: <Widget>[
//                  Container(
//                    child: ClipRRect(
//                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//                      child: Image.network(stream['image']),
//                    ),
//                  ),
//                ],
//              ),
//            ),
          ],
        ),
      ),
    );
//      },
//    );
  }
}
