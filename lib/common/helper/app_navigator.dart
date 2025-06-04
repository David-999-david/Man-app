import 'package:flutter/material.dart';
import 'package:user_auth/main.dart';

class AppNavigator {
  static GlobalKey<NavigatorState> get key => navigationKey;

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  static Future<T?> push<T extends Object?>(BuildContext context, Widget page) {
    return Navigator.push<T>(
        context, MaterialPageRoute<T>(builder: (context) => page));
  }

  static Future<T?> pushAndRemoveUntil<T extends Object?>(Widget page) {
    final ctx = key.currentContext;
    if (ctx == null) return Future.value(null);

    return Navigator.of(ctx).pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
        (Route<dynamic> route) => false);
  }

  static Future<T?> pushReplacement<T extends Object?, To extends Object?>(
      BuildContext context, Widget page, To? resultForPrevious) {
    return Navigator.pushReplacement<T, To>(
        context, MaterialPageRoute<T>(builder: (context) => page),
        result: resultForPrevious);
  }
}
