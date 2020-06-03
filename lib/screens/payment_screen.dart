import 'package:academe/components/buttons.dart';
import 'package:academe/constant.dart';
import 'package:academe/screens/home_screen.dart';
import 'package:academe/screens/purchase_course_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:academe/services/time_helper_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:academe/services/shared_pref_service.dart';

class PaymentScreen extends StatefulWidget {
  static String id = 'payment_screen';
  final Map<String, dynamic> orderData;

  PaymentScreen({@required this.orderData});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  int academeOrderId;
  bool showLoader = true;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    startPayment(widget.orderData);
  }

   Future<Map<String, Object>> getOrderId(Map<String, dynamic> orderData) async {
    Map<String, Object> result = new Map();
    try {
      var uri = Uri.https(kAPIDomain, '/api/order');
      Map _authTokenResult =
      await SharedPrefService.fetchFromSharedPref('authToken');
      if (_authTokenResult.containsKey('error')) {
        throw Exception(_authTokenResult['error']);
      }
      Map requestData = {
        "course_id": orderData['id'],
        "token": _authTokenResult['authToken'],
      };
      var body = convert.jsonEncode(requestData);
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = convert.jsonDecode(response.body);
      print('Response: ' + responseMap.toString());
      if (responseMap["error"] == true) {
        throw Exception(responseMap["cause"].toString());
      }
      result['data'] = responseMap["data"];
      return result;
    } catch (e) {
      result['error'] =
          'Error occured while registering your account: ' + e.toString();
      return result;
    }
  }

  Future<Map<String, Object>> updateOrder(int orderId, bool paymentStatus, String tansactionId) async {
    Map<String, Object> result = new Map();
    try {
      var uri = Uri.https(kAPIDomain, '/api/paymentstatus');
      Map _authTokenResult =
      await SharedPrefService.fetchFromSharedPref('authToken');
      if (_authTokenResult.containsKey('error')) {
        throw Exception(_authTokenResult['error']);
      }
      Map requestData = {
        "order_id": orderId,
        "token": _authTokenResult['authToken'],
        "payment_status": paymentStatus,
        "transaction_id" : tansactionId
      };
      var body = convert.jsonEncode(requestData);
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = convert.jsonDecode(response.body);
      print('Response: ' + responseMap.toString());
      if (responseMap["error"] == true) {
        throw Exception(responseMap["cause"].toString());
      }
      result['data'] = responseMap["data"];
      return result;
    } catch (e) {
      result['error'] =
          'Error occured while registering your account: ' + e.toString();
      return result;
    }
  }

  void startPayment(Map<String, dynamic> orderData) async {
    var currentTime = await TimeHelperService().getCurrentTimeInUTC();
    //print('Order Data which is being stored: ' + jsonEncode(orderData));
    orderData['paymentStatus'] = 'paymentStarted';
    orderData['lastPaymentStartTime'] = currentTime;
    Map<String, dynamic> order = await getOrderId(orderData);
    print('********************ORDER ID*******************');
    print(order['data']['order_id']);
//    String orderId = '123456789';
    academeOrderId = order['data']['order_id'];
    print(orderData['courses_image'].toString());
    openCheckout(
        orderId: academeOrderId.toString(),
        amount: double.parse(orderData['price'].toStringAsFixed(2)),
        description: orderData['name'],
        fillEmail: orderData['userEmail'] != null
            ? orderData['userEmail']
            : "",
        fillPhone: orderData['userPhoneNumber'] != null
            ? orderData['userPhoneNumber']
            : "");
  }

  void clear() {
    _razorpay.clear();
  }

  void openCheckout(
      {@required String orderId,
        @required num amount,
        @required String description,
        @required String fillEmail,
        @required String fillPhone}) async {
    var options = {
      'key': 'rzp_test_lkFREAZCb2u471',
      'amount': (amount * 100).toStringAsFixed(2), //in paise
      'name': 'Academe',
      'description': description,
      'prefill': {'contact': fillPhone, 'email': fillEmail},
//      'external': {
//        'wallets': ['paytm']
//      }
    };

    print('Options: ' + options.toString());

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
      //TODO : SEND EMAIL IN CASE THIS HAPPENS WITH A USER
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    var currentTime = await TimeHelperService().getCurrentTimeInUTC();
    print('Order id: ' +
        academeOrderId.toString() +
        ' Successfull Payment id: ' +
        response.paymentId +
        ' on ' +
        currentTime.toString());

    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_LONG);
    Map<String, dynamic> successData = {
      'orderStatus': 'placed',
      'paymentStatus': 'completed',
      'placedAtTime': currentTime,
      'paymentId': response.paymentId
    };
    print(successData.toString());
    Map<String, dynamic> result;
    result = await updateOrder(academeOrderId, true, successData['paymentId']);
//    if(result['error'] == false) {
      this.setState((){
        showLoader = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => CoursePurchasedDialog(
            courseImagePath: widget.orderData['courses_image'],
            courseTitle: widget.orderData['name'],
            courseSubtitle: widget.orderData['total_sessions'].toString(),
            courseDuration: widget.orderData['course_duration'],
            courseSessions: widget.orderData['total_sessions'].toString(),
            courseStream: widget.orderData['stream_name'],
            coursePrice: widget.orderData['price']),
      );
//    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    print(response.toString());
    Navigator.pop(context);
    if (response.code != 2) {
      Fluttertoast.showToast(
          msg: "ERROR: " + response.code.toString() + " - " + response.message,
          toastLength: Toast.LENGTH_LONG);

    }
    Map<String, dynamic> failureData = {
      'paymentStatus': 'failed',
      'paymentFailureError': response.message
    };
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response.toString());
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment'),),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.security,
                  color: AcademeAppTheme.primaryColor,
                  size: 60,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 30, horizontal: 80),
                child: showLoader ? LinearProgressIndicator() : Container(),
              ),
              Flexible(
                child: Text(
                  'Secure payment options loading\nplease wait...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
//              Expanded(
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Text(
//                      'Payments partner',
//                      textAlign: TextAlign.center,
//                      style: TextStyle(fontStyle: FontStyle.italic),
//                    ),
//                    Image.asset(
//                      'assets/images/razorpay_seal.png',
//                      height: 45,
//                      width: 150,
//                    )
//                  ],
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoursePurchasedDialog extends StatelessWidget {
  final String courseImagePath,
      courseTitle,
      courseSubtitle,
      courseDuration,
      courseSessions,
      courseStream;
  final double coursePrice;
  CoursePurchasedDialog(
      {@required this.courseImagePath,
        @required this.courseTitle,
        @required this.courseSubtitle,
        @required this.courseDuration,
        @required this.courseSessions,
        @required this.courseStream,
        @required this.coursePrice});

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
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 40, 20, 40),
                child: Icon(
                  Icons.check_circle,
                  color: AcademeAppTheme.primaryColor,
                  size: 50,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Purchase Successful',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'You can find this course any time under “Subscriptions” tab of the Academe App.',
                        style: TextStyle(color: AcademeAppTheme.lightText),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: courseListTile(
                imagePath: this.courseImagePath,
                title: this.courseTitle,
                subtitle: this.courseSubtitle,
                duration: this.courseDuration,
                stream: this.courseStream,
                price: this.coursePrice.toInt()),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Buttons.primary(text: 'Start Course', onTap: () {
//              Navigator.pushNamedAndRemoveUntil(context, MyHomePage.id, (_) => false, arguments: ScreenArguments(1, true) );
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage(subScreenIndex: 1)), (_) => false);
            }),
          )
        ],
      ),
    );
  }
}

