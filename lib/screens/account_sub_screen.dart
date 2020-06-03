import 'package:academe/constant.dart';
import 'package:academe/screens/edit_profile_screen.dart';
import 'package:academe/services/authentication_service.dart';
import 'package:academe/services/email_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:academe/utils/text_field_validators.dart';
import 'package:academe/components/buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:academe/components/dialogs.dart';
import 'package:academe/services/shared_pref_service.dart';

class AccountSubScreen extends StatefulWidget {
  @override
  _AccountSubScreenState createState() => _AccountSubScreenState();
}

class _AccountSubScreenState extends State<AccountSubScreen> {
  bool _loading = false;
  bool _accountExists = false;
  bool _accountCheckDone = false;
  bool _obscureText = true;
  Future<Map> _screenData;
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  final TextEditingController _emailFormEmailFieldController =
      TextEditingController();
  final TextEditingController _registrationFormEmailFieldController =
      TextEditingController();
  final TextEditingController _loginFormEmailFieldController =
      TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _choosePasswordController =
      TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _screenData = getDataForScreen();
  }

  Future<Map> getDataForScreen() async {
    Map _authTokenResultMap = new Map();
    Map _userNameResultMap = new Map();
    Map screenData = new Map();
    try {
      _authTokenResultMap =
          await SharedPrefService.fetchFromSharedPref('authToken');
      _userNameResultMap =
          await SharedPrefService.fetchFromSharedPref('userName');

      if (!_authTokenResultMap.containsKey('error') &&
          !_userNameResultMap.containsKey('error')) {
        screenData['authToken'] = _authTokenResultMap['authToken'];
        screenData['userName'] = _userNameResultMap['userName'];
      } else {
        if (_authTokenResultMap.containsKey('error')) {
          screenData['error'] += _authTokenResultMap['error'];
        }
        if (_userNameResultMap.containsKey('error')) {
          screenData['error'] += _userNameResultMap['error'];
        }
      }
    } catch (e) {
      print(e);
      screenData['error'] += e.toString();
    }
    return screenData;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map>(
        stream: _screenData.asStream(),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            //prepare screen
            if (snapshot.data.containsKey('authToken')) {
              if (snapshot.data['authToken'] != null) {
//                if (snapshot.data.containsKey('userName') &&
//                    snapshot.data['userName'] != null) {
//                  if (snapshot.data['userName'].toString().isNotEmpty)
//                    print('setting signed in usernma');
//                    _signedInUserName = snapshot.data['userName'].toString();
//                }
                return StreamBuilder<Map>(
                    stream: AuthenticationService.getLoggedInUserDataFromAPI()
                        .asStream(),
                    builder:
                        (BuildContext context, AsyncSnapshot<Map> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data['data'] != null) {
                          print('--------------recent purchases-----------');
                          print(snapshot.data['data']);
                          if (snapshot.data['data'].containsKey('courses')) {
                            if (snapshot.data['data']['courses'] != null) {
//                            return userProfileScreen(
//                                context, snapshot.data['data']['courses']);
                              return userProfileScreen(
                                  context, snapshot.data['data']);
                            }
                          }
                        }
                      } else if (snapshot.hasError) {
                        return Center(
                            child:
                                Text('Error while loading data, please retry'));
                      } else {
                        //show waiting state
                        return Center(child: CircularProgressIndicator());
                      }
                      //              //show full data with preparation done in hasData stage
                      return Center(child: CircularProgressIndicator());
                    });
              }
              if (snapshot.data['authToken'] == null) {
                return emailAuthScreen(context);
              }
            }
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error while loading data, please retry'));
          } else {
            //show waiting state
            return Center(child: CircularProgressIndicator());
          }
//        return FutureBuilder<Map>(
//            future: _screenData,
//            builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
//
//              //show full data with preparation done in hasData stage
          return Center(child: CircularProgressIndicator());
//            });
        });
  }

  Widget emailAuthScreen(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: <Widget>[
                Column(
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: Text(
                        'Enter your email',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Text(
                        'It will let you save your course progress and view your subscriptions.',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Visibility(
                      visible: !_accountCheckDone,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: emailForm(),
                      ),
                    ),
                    Visibility(
                      visible: _accountCheckDone && _accountExists,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: loginForm(),
                      ),
                    ),
                    Visibility(
                      visible: _accountCheckDone && !_accountExists,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: registrationForm(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailForm() {
    return Form(
      key: _emailFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailFormEmailFieldController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
            ),
            validator: TextFieldValidators.emailValidator,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
            child: Buttons.primary(
                text: 'Continue using Email',
                onTap: () async {
                  if (_emailFormKey.currentState.validate()) {
                    _emailFormKey.currentState.save();
                    setState(() {
                      _loading = true;
                    });
                    Map<String, Object> result =
                        await EmailAuthService.doesAccountExist(
                            _emailFormEmailFieldController.text.trim());
                    setState(() {
                      _loading = false;
                    });
                    if (result.containsKey('error')) {
                      Dialogs()
                          .showErrorDialog(context, 'Oops!', result['error']);

                      return;
                    }
                    if (result["exists"] == true) {
                      setState(() {
                        _accountExists = true;
                        _accountCheckDone = true;
                        _loginFormEmailFieldController.text =
                            _emailFormEmailFieldController.text;
                      });
                    } else if (result["exists"] == false) {
                      setState(() {
                        _accountExists = false;
                        _accountCheckDone = true;
                        _registrationFormEmailFieldController.text =
                            _emailFormEmailFieldController.text;
                      });
                    }
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _loginFormEmailFieldController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
            ),
            validator: TextFieldValidators.emailValidator,
          ),
          TextFormField(
//            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureText,
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              suffixIcon: passwordSuffixIcon(),
            ),
            validator: TextFieldValidators.passwordValidator,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Buttons.primary(
                text: 'Sign In using Email',
                onTap: () async {
                  signInUser(_loginFormEmailFieldController.text.trim(),
                      _passwordController.text.trim());
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: FlatButton(
              child: Text('Don\'t have an account? Register',
                  style: TextStyle(color: AcademeAppTheme.primaryColor)),
              onPressed: () {
                setState(() {
                  _accountExists = false;
                  _accountCheckDone = true;
                  _registrationFormEmailFieldController.text =
                      _emailFormEmailFieldController.text;
                });
              },
            ),
          ),
          FlatButton(
            child: Text('Forgot Password?',
                style: TextStyle(color: AcademeAppTheme.primaryColor)),
            onPressed: () async {
              setState(() {
                _loading = true;
              });

              Map result = await AuthenticationService.forgotPassword(
                  _loginFormEmailFieldController.text.trim());
              if (result.containsKey('error')) {
                Dialogs().showErrorDialog(context, 'Oops!', result['error']);
                setState(() {
                  _loading = false;
                });
                return;
              }
              if (result.containsKey('data')) {
                //String data = result['data'];
                setState(() {
                  _loading = false;
                });
                Dialogs().showInfoDialog(context, 'Password Updated',
                    'Email with new password sent succesfully');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget registrationForm() {
    return Form(
      key: _registrationFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _registrationFormEmailFieldController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
            ),
            validator: TextFieldValidators.emailValidator,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your full name',
            ),
            validator: TextFieldValidators.nameValidator,
          ),
          TextFormField(
//            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureText,
            controller: _choosePasswordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Choose a password',
              suffixIcon: passwordSuffixIcon(),
            ),
            validator: TextFieldValidators.passwordValidator,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Buttons.primary(
              text: 'Sign Up using Email',
              onTap: () async {
                if (_registrationFormKey.currentState.validate()) {
                  _registrationFormKey.currentState.save();
                  setState(() {
                    _loading = true;
                  });
                  Map<String, Object> signUpResult =
                      await EmailAuthService.registerUser(
                          _registrationFormEmailFieldController.text.trim(),
                          _choosePasswordController.text.trim(),
                          _fullNameController.text.trim());

                  if (signUpResult.containsKey('error')) {
                    Dialogs().showErrorDialog(
                        context, 'Oops!', signUpResult['error']);
                    setState(() {
                      _loading = false;
                    });
                    return;
                  }
                  signInUser(_registrationFormEmailFieldController.text.trim(),
                      _choosePasswordController.text.trim());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: FlatButton(
              child: Text('Already have an account? Login',
                  style: TextStyle(color: AcademeAppTheme.primaryColor)),
              onPressed: () {
                setState(() {
                  _accountExists = true;
                  _accountCheckDone = true;
                  _loginFormEmailFieldController.text =
                      _registrationFormEmailFieldController.text;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget passwordSuffixIcon() {
    return IconButton(
      color: _obscureText ? Colors.grey : AcademeAppTheme.primaryColor,
      icon: Icon(Icons.remove_red_eye),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }

  Widget userProfileScreen(BuildContext context, var data) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              height: 100,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 16, right: 16, bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Hello,',
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            data['name'] != null
                                ? data['name']
                                : 'Academe User',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      EditProfileScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Edit profile',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AcademeAppTheme.primaryColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Recent Purchases',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
//                    physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data['courses'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return courseList(data['courses'][index]);
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget courseList(Map data) {
    return ListTile(
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
            data['name'],
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Spacer(),
          Text(
            data['course_duration'],
            style: TextStyle(color: AcademeAppTheme.lightText, fontSize: 12),
          )
        ],
      ),
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                data['total_sessions'].toString() +
                    (data['total_sessions'] > 1 ? ' Sessions' : ' Session'),
                style:
                    TextStyle(color: AcademeAppTheme.lightText, fontSize: 12),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: <Widget>[
                Text(
                  data['price'].toString(),
                  style:
                      TextStyle(color: AcademeAppTheme.lightText, fontSize: 12),
                ),
                Spacer(),
                Text(
                  'Purchase on ' + data['purchased_date'],
                  style:
                      TextStyle(color: AcademeAppTheme.lightText, fontSize: 12),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void signInUser(String email, String password) async {
    setState(() {
      _loading = true;
    });

    Map<String, Object> result =
        await EmailAuthService.signInWithEmailAndPassword(
      email,
      password,
    );
    if (result.containsKey('error')) {
      Dialogs().showErrorDialog(context, 'Oops!', result['error']);
      setState(() {
        _loading = false;
      });
      return;
    }
    if (result.containsKey('data')) {
      Map data = result['data'];

      if (data.containsKey('token')) {
        Map tokenResult = await SharedPrefService.storeInSharedPref(
            'authToken', data['token']);

        if (tokenResult.containsKey('error')) {
          Dialogs().showErrorDialog(context, 'Oops!', tokenResult['error']);
          setState(() {
            _loading = false;
          });
          return;
        }
      }
      if (data.containsKey('name')) {
        Map nameTokenResult =
            await SharedPrefService.storeInSharedPref('userName', data['name']);

        if (nameTokenResult.containsKey('error')) {
          Dialogs().showErrorDialog(context, 'Oops!', nameTokenResult['error']);
          setState(() {
            _loading = false;
          });
          return;
        }
      }
      setState(() {
//        if (data.containsKey('name')) {
//          _signedInUserName = data['name'];
//        }
        _loading = false;
        _accountCheckDone = true;
        _accountExists = true;
        _screenData = getDataForScreen();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailFormEmailFieldController.dispose();
    _registrationFormEmailFieldController.dispose();
    _loginFormEmailFieldController.dispose();
    _passwordController.dispose();
    _choosePasswordController.dispose();
    _fullNameController.dispose();
  }
}
