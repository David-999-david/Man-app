import 'package:flutter/material.dart';
import 'package:user_auth/core/theme/app_text_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: 21.sp(color: Color(0xFFBDBDBD)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          child: Text(
            'HOME SCREEN',
            style: 17.sp(color: Color(0xFFBDBDBD)),
          ),
        ),
      ),
    );
  }
}
