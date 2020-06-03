import 'package:academe/screens/account_sub_screen.dart';
import 'package:academe/screens/home_sub_screen.dart';
import 'package:academe/screens/more_sub_screen.dart';
import 'package:academe/screens/subscriptions_sub_screen.dart';
import 'package:academe/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:academe/utils/academe_custom_icons_icons.dart';

class MyHomePage extends StatefulWidget {
  static String id = 'my_home_page';
  final int subScreenIndex;
  MyHomePage({
    @required this.subScreenIndex,
  });
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedSubScreen = 0;
  Future<bool> _isAuthenticated;
  List<AppBar> appbar = [
    null,
    AppBar(title: Text('Subscriptions')),
    null,
    AppBar(
      title: Text('More Info'),
    )
  ];

  @override
  void initState() {
    super.initState();
    if(widget.subScreenIndex != null) {
      this.setState((){
        _selectedSubScreen = widget.subScreenIndex;
      });
    }

    _isAuthenticated = AuthenticationService.isAuthenticated();
    print('-------change-------');
//    print(value);
    _isAuthenticated.then((value) {
      print('-------home-------');
      print(value);
      if (value == true) {
        this.setState(() {
          appbar = [
            null,
            AppBar(title: Text('Subscriptions')),
            AppBar(title: Text('Your Account')),
            AppBar(
              title: Text('More Info'),
            )
          ];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar != null ? appbar[_selectedSubScreen] : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        currentIndex: _selectedSubScreen,
        items: [
          BottomNavigationBarItem(
            icon: Icon(AcademeCustomIcons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(AcademeCustomIcons.subscriptions),
            title: Text('Subscriptions'),
          ),
          BottomNavigationBarItem(
            icon: Icon(AcademeCustomIcons.account),
            title: Text('Account'),
          ),
          BottomNavigationBarItem(
            icon: Icon(AcademeCustomIcons.more),
            title: Text('More'),
          ),
        ],
        onTap: _onItemTap,
      ),
      body: showSubScreen(_selectedSubScreen),
    );
  }

  void _onItemTap(int index) async {
    if (index != _selectedSubScreen) {
      setState(() {
        _selectedSubScreen = index;
      });
    }
  }

  Widget showSubScreen(int index) {
    switch (index) {
      case 0:
        return HomeSubScreen();
      case 1:
        return SubscriptionsSubScreen();
      case 2:
        return AccountSubScreen();
      case 3:
        return MoreSubScreen();
    }

    return SizedBox();
  }
}
