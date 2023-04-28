import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle {
  
  late TextTheme textTheme = TextTheme(
      bodyLarge: GoogleFonts.roboto()
          .copyWith(fontSize: 23, fontWeight: FontWeight.bold),
      bodyMedium: GoogleFonts.roboto()
          .copyWith(fontSize: 17, fontWeight: FontWeight.normal),
      bodySmall: GoogleFonts.roboto()
          .copyWith(fontSize: 14, fontWeight: FontWeight.normal));
}
