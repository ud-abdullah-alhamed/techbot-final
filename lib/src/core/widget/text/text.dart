import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:techbot/src/config/theme/theme.dart';

class TextApp {
  static Text splashAppText(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: AppColor.subappcolor,
              fontWeight: FontWeight.w400,
              fontSize: 64)),
    );
  }

  static Text mainAppText(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: AppColor.subappcolor,
              fontWeight: FontWeight.bold,
              fontSize: 20)),
    );
  }

  static Text subAppText(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: AppColor.buttonColor,
              fontWeight: FontWeight.w400,
              fontSize: 12)),
    );
  }

  static Text appBarText(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: AppColor.mainAppColor,
              fontWeight: FontWeight.bold,
              fontSize: 22)),
    );
  }
}
