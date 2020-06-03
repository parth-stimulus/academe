import 'package:academe/screens/subscriptions_sub_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academe',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
      routes: {
        SubscriptionsSubScreen.id: (context) => SubscriptionsSubScreen(),
        MyHomePage.id: (context) => MyHomePage()
      },
    );
  }
}


