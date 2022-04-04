import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static late double blockW;
  static late double blockH;

  static late bool isDarkMode;

  static Color primaryColor = Colors.black;
  static Color secondaryColor = Colors.white;
  static Color backgroundColor = secondaryColor;
  static const Color accentColor = Color(0xff5B5EA6);
  static const Color darkGreenColor = Color(0xff263D36);
  static const Color darkGreyColor = Color(0xff181A19);
  static const Color lightGreyColor = Color(0xff9AABA6);
  static const Color lightGreyColor_1 = Color(0xffD9E5E2);
  static const Color shadowColor = Color(0xFF2C885C);
  static Color dividerColor = const Color(0xFFE1EBE8);
  static const Color bottomBarColor = Color(0x46F5F9F7);

  static const standardAnimationDuration = Duration(milliseconds: 300);
  static const fastAnimationDuration = Duration(milliseconds: 200);

  static double screenHorizontalPadding = blockW;

  static TextStyle getSearchTextStyle({bool hint = false}) {
    return GoogleFonts.rubik(
      fontSize: Style.blockW * 1,
      fontWeight: FontWeight.w400,
      color: hint ? lightGreyColor : primaryColor,
    );
  }

  static TextStyle getTitleTextStyle() {
    return GoogleFonts.rubik(fontSize: Style.blockW * 0.9, fontWeight: FontWeight.w700, color: accentColor);
  }

  static TextStyle getBookTitleTextStyle() {
    return GoogleFonts.rubik(
        fontSize: Style.blockW * 0.9, fontWeight: FontWeight.w400, color: isDarkMode ? primaryColor : darkGreyColor);
  }

  static TextStyle getBookSubtitleTextStyle({bool date = false}) {
    return GoogleFonts.rubik(
      fontSize: Style.blockW * 0.9 * 12 / 14,
      fontWeight: FontWeight.w400,
      color: isDarkMode ? primaryColor : (date ? darkGreenColor : darkGreyColor.withOpacity(0.5)),
    );
  }

  static TextStyle getBottomBarTextStyle() {
    return GoogleFonts.rubik(fontSize: Style.blockW * 0.7, fontWeight: FontWeight.w400, color: accentColor);
  }

  static void init(BuildContext context) {
    // almost all sizes are represented in blocks, so the design is well scalable
    blockW = MediaQuery.of(context).size.width / 20; // 1 block = 5% of screen size
    blockH = MediaQuery.of(context).size.height / 20; // 1 block = 5% of screen size

    isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (isDarkMode) {// it's not beautiful, but it is what it is
      secondaryColor = Colors.blueGrey.shade900;
      primaryColor = Colors.white;
      backgroundColor = secondaryColor;
      dividerColor = Colors.black;
    }
  }
}
