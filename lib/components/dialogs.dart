import 'package:flutter/material.dart';
class Dialogs{
  void showErrorDialog(BuildContext context, String title, String error) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OKAY'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void showInfoDialog(BuildContext context, String title, String info) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(info),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OKAY'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void showConfirmationDialog({@required context,
    @required String confirmationMessage,
    @required String cancelButtonText,
    @required String actionButtonText,
    @required Function actionButtonOnPress}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(confirmationMessage),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(cancelButtonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(actionButtonText),
              onPressed: actionButtonOnPress,
            ),
          ],
        );
      },
    );
  }
}