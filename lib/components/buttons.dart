import 'package:flutter/material.dart';
import 'package:academe/constant.dart';
class Buttons {
  ///Full width primary button, takes button [text] and
  ///button [onTap]
  static Widget primary({@required String text, @required Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AcademeAppTheme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        height: 43,
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 18,
                color: AcademeAppTheme.primaryComplementaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
  ///Mini primary button, takes button [text] and
  ///button [onTap]
  static Widget miniPrimaryButton(String text, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AcademeAppTheme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        height: 43,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11,8,11,9),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                  color: AcademeAppTheme.primaryComplementaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
