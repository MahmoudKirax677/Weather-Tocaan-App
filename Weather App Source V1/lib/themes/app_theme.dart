import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_constants.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1C1C4D),
    primaryColor: AppConstants.primaryColor,
    textTheme: GoogleFonts.poppinsTextTheme(),
    useMaterial3: true,
  );
}
