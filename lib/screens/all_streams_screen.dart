import 'package:academe/screens/stream_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:academe/components/streams_view.dart';

import '../constant.dart';

class AllStreams extends StatefulWidget {
  @override
  _AllStreamsState createState() => _AllStreamsState();
}

class _AllStreamsState extends State<AllStreams> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Streams'),
      ),
      body: Scrollbar(
        child: ListView(
          children: <Widget>[
            StreamsView(
              callBack: (Map<dynamic, dynamic> streamData) {
                Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => StreamDetailScreen(
                      streamId: streamData,
                    ),
                  ),
                );
              },
              url: Uri.https(kAPIDomain, '/api/streamlist').toString(),
            )
          ],
        ),
      ),
    );
  }
}
