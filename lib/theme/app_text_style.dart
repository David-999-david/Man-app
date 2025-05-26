import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension MerriweatherText on num {
  TextStyle sp(
    {
      FontWeight weight = FontWeight.w400,
      Color color = Colors.black
    }
  ){
    return GoogleFonts.merriweather(
      fontSize: toDouble(),
      fontWeight: weight,
      color: color
    );
  }
}