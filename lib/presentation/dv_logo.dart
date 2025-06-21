import 'package:flutter/material.dart';

class DvLogo extends StatelessWidget {
  const DvLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Image.asset(
          height: 75,
          width: 75,
          'assets/images/DV.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
