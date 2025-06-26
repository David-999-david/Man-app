import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final appTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF212121), surface: Color(0xFF212121)),
      appBarTheme: AppBarTheme(backgroundColor: Color(0xFF212121)),
      textTheme: GoogleFonts.robotoTextTheme());
}
