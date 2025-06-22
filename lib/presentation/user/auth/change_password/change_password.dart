import 'package:flutter/material.dart';
import 'package:user_auth/core/theme/app_text_style.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Change password',
          style: 20.sp(color: Colors.white),
        ),
      ),
    );
  }
}
