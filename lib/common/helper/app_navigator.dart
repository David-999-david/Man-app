import 'package:flutter/material.dart';

class AppNavigator {
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  static Future<T?> push<T extends Object?>(BuildContext context, Widget page) {
    return Navigator.push<T>(
        context, MaterialPageRoute<T>(builder: (context) => page));
  }

  static Future<T?> pushAndRemoveUntil<T extends Object?>(
      BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil<T>(
        context,
        MaterialPageRoute<T>(builder: (context) => page),
        (Route<dynamic> route) => false);
  }

  static Future<T?> pushReplacement<T extends Object?, To extends Object?>(
      BuildContext context, Widget page, To? resultForPrevious) {
    return Navigator.pushReplacement<T, To>(
        context, MaterialPageRoute<T>(builder: (context) => page),
        result: resultForPrevious);
  }
}
