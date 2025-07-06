import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingShow extends StatelessWidget {
  const LoadingShow({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: Colors.white,
        duration: Duration(seconds: 5),
        size: 30,
      ),
    );
  }
}
