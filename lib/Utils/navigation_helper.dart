import 'package:flutter/material.dart';

class NavigationHelper {
  static pushRoute(BuildContext context, Widget targetClasss) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => targetClasss));
  }
}

class NavigationHelperreplace {
  static pushRoute(BuildContext context, Widget targetClasss) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => targetClasss));
  }
}
