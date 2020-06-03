import 'package:academe/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:academe/constant.dart';
import 'package:academe/services/shared_pref_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:academe/screens/home_screen.dart';

class PurchaseCourseScreen extends StatefulWidget {
  static String id = 'purchase_course_screen';
  final Map<String, dynamic> selectedCourseData;
  PurchaseCourseScreen({@required this.selectedCourseData});
  @override
  _PurchaseCourseScreenState createState() => _PurchaseCourseScreenState();
}

class _PurchaseCourseScreenState extends State<PurchaseCourseScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Course'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Scrollbar(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    courseListTile(
                      imagePath: widget.selectedCourseData['courses_image'],
                      title: widget.selectedCourseData['name'],
                      subtitle: widget.selectedCourseData['total_sessions'].toString(),
                      duration: widget.selectedCourseData['course_duration'],
                      stream: widget.selectedCourseData['stream_name'],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Divider(
                        thickness: 0.5,
                      ),
                    ),
                    faq(
                        question: 'What is covered in the course?',
                        answer: widget.selectedCourseData['description']),
                    faq(
                        question: 'What is number of sessions in the course?',
                        answer: widget.selectedCourseData['total_sessions'].toString()),
                    faq(
                        question: 'What is duration of the course?',
                        answer: widget.selectedCourseData['course_duration']),
                    faq(
                        question: 'What is validity of purchase?',
                        answer:
                            'You can access this course on Academe App with a Lifetime validity.'),
                    faq(
                        question: 'Is it safe to purchase online?',
                        answer:
                            'Yes! Online purchases are 100% secure and safe. The world is moving towards e-learning.'),
                  ],
                ),
              ),
            ),
          ),
          proceedToPayButton(onTap: ()async {
            Map _authTokenResult =
                await SharedPrefService.fetchFromSharedPref('authToken');
            if(_authTokenResult['authToken'] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: RouteSettings(name: 'OrderProcessing'),
                  builder: (context) => PaymentScreen(
                    orderData: widget.selectedCourseData,
                  ),
                ),
              );
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage(subScreenIndex: 2)),
                      (_) => false);
              Fluttertoast.showToast(
                  msg: "You need to login before making a payment.", toastLength: Toast.LENGTH_LONG);
            }

          }),
        ],
      ),
    );
  }

  Widget proceedToPayButton({@required Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        height: 70,
        color: AcademeAppTheme.green,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 21),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '₹' + widget.selectedCourseData['price'].toString(),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Proceed to Pay',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget faq({@required String question, @required String answer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Text(
          question,
          style: TextStyle(color: AcademeAppTheme.lighterText, fontSize: 16),
        ),
        SizedBox(
          height: 9,
        ),
        Text(answer, style: TextStyle(fontSize: 16)),
        SizedBox(
          height: 4,
        ),
      ],
    );
  }
}

Widget courseListTile(
    {@required String imagePath,
    @required String title,
    @required String subtitle,
    @required String duration,
    @required String stream,
    int price}) {
  return ListTile(
    isThreeLine: true,
    leading: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.network(
          imagePath,
          width: 80.0,
          height: 80.0,
          fit: BoxFit.contain,
        )),
    title: Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.fade,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            duration,
            style: TextStyle(color: AcademeAppTheme.lightText, fontSize: 14),
          ),
        )
      ],
    ),
    subtitle: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              subtitle+" sessions",
              style: TextStyle(color: AcademeAppTheme.lightText, fontSize: 14),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                stream,
                style:
                    TextStyle(color: AcademeAppTheme.lightText, fontSize: 12),
              ),
              Visibility(
                visible: price != null,
                child: Text(
                  '₹' + price.toString(),
                  style:
                      TextStyle(color: AcademeAppTheme.lightText, fontSize: 12),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}


