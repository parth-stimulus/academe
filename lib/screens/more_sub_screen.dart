import 'package:academe/services/authentication_service.dart';
import 'package:academe/services/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:academe/constant.dart';
import 'package:academe/components/buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:academe/components/dialogs.dart';
import 'package:academe/components/fields.dart';
import 'package:academe/utils/text_field_validators.dart';
import 'package:academe/screens/home_screen.dart';
import 'package:academe/services/profile_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MoreSubScreen extends StatefulWidget {
  @override
  _MoreSubScreenState createState() => _MoreSubScreenState();
}

class _MoreSubScreenState extends State<MoreSubScreen> {
  bool _loading = false;
  Future<bool> _isAuthenticated;

  @override
  void initState() {
    super.initState();
    _isAuthenticated = AuthenticationService.isAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isAuthenticated, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.toString());
          return ModalProgressHUD(
            inAsyncCall: _loading,
            child: ListView(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AboutAcademeDialog(),
                    );
                  },
                  child: Ink(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 35,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                          child: Text(
                            'About Academe',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                          child: Divider(),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (snapshot.data == false) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage(subScreenIndex: 2)),
                          (_) => false);
                    }
                    if (snapshot.data == true) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => ContactUsDialog(),
                      );
                    }
                  },
                  child: Ink(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 22,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                          child: Text(
                            'Contact Us',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                          child: Divider(),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: snapshot.data == true,
                  child: InkWell(
                    onTap: () async {
                      Dialogs().showConfirmationDialog(
                          context: context,
                          confirmationMessage:
                              "Are you sure you want to log out?",
                          cancelButtonText: 'CANCEL',
                          actionButtonText: 'LOG OUT',
                          actionButtonOnPress: () async {
                            Navigator.of(context).pop();
                            setState(() {
                              _loading = true;
                            });
                            print('Logging out..');
                            Map result = await SharedPrefService.clear();
                            if (result.containsKey('error')) {
                              setState(() {
                                _loading = false;
                              });
                              Dialogs().showErrorDialog(
                                  context, 'Oops!', result['error']);
                            }
                            setState(() {
                              _isAuthenticated =
                                  AuthenticationService.isAuthenticated();
                              _loading = false;
                            });
                          });
                    },
                    child: Ink(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 22,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 34,
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 30, 0, 30),
                        child: Image.asset(
                          'assets/images/academe_logo.png',
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error while loading data, please retry'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class AboutAcademeDialog extends StatelessWidget {
  AboutAcademeDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(33),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'About Academe',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Academe started in 1993 as a tution class run by John Doe. Since then, it has been continously growing and changing lives of hundreds of students who are looking for quality study material to crack the exams they’ve been preparing for and make their dreams come true.',
                        style: TextStyle(color: AcademeAppTheme.lightText),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(33, 0, 33, 33),
            child: Buttons.primary(
                text: 'Back',
                onTap: () {
                  Navigator.of(context).pop();
                }),
          )
        ],
      ),
    );
  }
}

class ContactUsDialog extends StatelessWidget {
  ContactUsDialog();
  final GlobalKey<FormState> contactUsFormKey = GlobalKey<FormState>();
  final TextEditingController _subjectFieldController = TextEditingController();
  final TextEditingController _messageFieldController = TextEditingController();
  bool _loading=false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Form(
          key: contactUsFormKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(33),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Subject',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 0),
                            child: Fields.customTextField(
                              controller: _subjectFieldController,
                              textInputType: TextInputType.text,
                              validator: TextFieldValidators.nameValidator,
                            ),
                          ),
                          Text(
                            'Message',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 0),
                            child: Fields.customTextField(
                              minLines: 4,
                              maxLines: 7,
                              controller: _messageFieldController,
                              textInputType: TextInputType.text,
                              validator: TextFieldValidators.nameValidator,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(33, 0, 33, 33),
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : Buttons.primary(
                        text: 'Send Message',
                        onTap: () async{
                          if (contactUsFormKey.currentState.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            contactUsFormKey.currentState.save();
                            Map contactUsResult =await ProfileService.contactUs(
                                _subjectFieldController.text.trim(),
                                _messageFieldController.text.trim());
                            if (contactUsResult.containsKey('error')) {
                              Dialogs().showErrorDialog(context, 'Oops!',
                                  contactUsResult['error']);
                              setState(() {
                                _loading = false;
                              });
                              return;
                            }
                            setState(() {
                              _loading = true;
                            });
                            Fluttertoast.showToast(
                                msg: "Request created successfully",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.of(context).pop();
                          }
                        }),
              )
            ],
          ),
        ),
      );
    });
  }
}
