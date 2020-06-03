import 'package:academe/services/profile_service.dart';
import 'package:academe/utils/text_field_validators.dart';
import 'package:flutter/material.dart';
import 'package:academe/components/buttons.dart';
import 'package:academe/components/fields.dart';
import 'package:academe/services/authentication_service.dart';
import 'package:academe/components/dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> updateDetailsFormKey = GlobalKey<FormState>();
  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _emailFieldController = TextEditingController();
  Future<Map> _userData;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _userData = AuthenticationService.getLoggedInUserDataFromAPI();
  }

  @override
  void dispose() {
    super.dispose();
    _nameFieldController.dispose();
    _emailFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _userData.asStream(),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['data'] == null) {
                if (snapshot.data['error'] == true) {
                  return Center(
                      child: Text('Error while loading data, please retry' +
                          snapshot.data['error']['cause']));
                }
                return Center(
                    child: Text('Error while loading data, please retry'));
              }
              Map userDataFromAPI = snapshot.data['data'];
              print('Name from API: ' + userDataFromAPI['name']);
              if (userDataFromAPI['name'] != null&&_nameFieldController.text.isEmpty) {
                _nameFieldController.text = userDataFromAPI['name'];
              }
              if (userDataFromAPI['email'] != null&&_emailFieldController.text.isEmpty) {
                _emailFieldController.text = userDataFromAPI['email'];
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 40, 15, 0),
                child: Form(
                  key: updateDetailsFormKey,
                  child: ListView(
                    children: <Widget>[
                      Text('Full Name'),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 18.0),
                        child: Fields.customTextField(
                          controller: _nameFieldController,
                          textInputType: TextInputType.text,
                          validator: TextFieldValidators.nameValidator,
                        ),
                      ),
                      Text('Email ID'),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 42),
                        child: Fields.customTextField(
                          controller: _emailFieldController,
                          textInputType: TextInputType.emailAddress,
                          validator: TextFieldValidators.emailValidator,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: !_loading
                            ? Buttons.primary(
                                text: 'Update Details',
                                onTap: () async {
                                  if (updateDetailsFormKey.currentState
                                      .validate()) {
                                    updateDetailsFormKey.currentState.save();
                                    String newName;
                                    String newEmail;
                                    setState(() {
                                      _loading = true;
                                    });
                                    if (_nameFieldController.text.trim() !=
                                        userDataFromAPI['name']) {
                                      newName =
                                          _nameFieldController.text.trim();
                                    }
                                    if (_emailFieldController.text.trim() !=
                                        userDataFromAPI['email']) {
                                      newEmail =
                                          _emailFieldController.text.trim();
                                    }
                                    Map updateProfileResult =
                                        await ProfileService
                                            .updateUserProfile(
                                      name: newName,
                                      email: newEmail,
                                    );
                                    if (updateProfileResult
                                        .containsKey('error')) {
                                      Dialogs().showErrorDialog(
                                          context,
                                          'Oops!',
                                          updateProfileResult['error']);
                                      setState(() {
                                        _loading = false;
                                      });
                                      return;
                                    }

                                    setState(() {
                                      _userData = AuthenticationService
                                          .getLoggedInUserDataFromAPI();
                                      _loading = false;
                                    });

                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Profile successfully updated.'),
                                      ),
                                    );
                                  }
                                })
                            : Center(child: CircularProgressIndicator()),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                ChangePasswordDialog(),
                          );
                        },
                        child: Text(
                          'Change Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error while loading data, please retry'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class ChangePasswordDialog extends StatelessWidget {
  ChangePasswordDialog();
  final GlobalKey<FormState> _changePasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordFieldController =
      TextEditingController();
  final TextEditingController _newPasswordFieldController =
      TextEditingController();
  final TextEditingController _newPasswordConfirmFieldController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    bool _loading = false;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Scrollbar(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(33, 33, 33, 10),
                  child: Form(
                    key: _changePasswordFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Current Password',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 0),
                          child: Fields.customTextField(
                            controller: _currentPasswordFieldController,
                            textInputType: TextInputType.text,
                            validator: TextFieldValidators.passwordValidator,
                          ),
                        ),
                        Text(
                          'New Password',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 0),
                          child: Fields.customTextField(
                            controller: _newPasswordFieldController,
                            textInputType: TextInputType.text,
                            validator: TextFieldValidators.passwordValidator,
                          ),
                        ),
                        Text(
                          'Confirm New Password',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 0),
                          child: Fields.customTextField(
                            controller: _newPasswordConfirmFieldController,
                            textInputType: TextInputType.text,
                            validator: TextFieldValidators.passwordValidator,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(33, 0, 33, 33),
                  child: _loading
                      ? Center(child: CircularProgressIndicator())
                      : Buttons.primary(
                          text: 'Change Password',
                          onTap: () async {
                            if (_changePasswordFormKey.currentState
                                .validate()) {
                              setState(() {
                                _loading = true;
                              });
                              _changePasswordFormKey.currentState.save();
                              Map changePasswordResult =
                                  await ProfileService.changePassword(
                                      _currentPasswordFieldController.text
                                          .trim(),
                                      _newPasswordFieldController.text.trim(),
                                      _newPasswordConfirmFieldController.text
                                          .trim());
                              if (changePasswordResult.containsKey('error')) {
                                Dialogs().showErrorDialog(context, 'Oops!',
                                    changePasswordResult['error']);
                                setState(() {
                                  _loading = false;
                                });
                                return;
                              }
                              setState(() {
                                _loading = false;
                              });
                              Fluttertoast.showToast(
                                  msg: "Password update successful",
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
      },
    );
  }
}
