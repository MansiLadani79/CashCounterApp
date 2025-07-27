import 'package:flutter/material.dart';

import 'color/colors.dart';

/// [NkGetXFontStyle] USE CUSTOM FONT

class NkGetXFontStyle {
  static TextTheme get primaryTextTheme => const TextTheme(
    displayLarge: TextStyle(
      letterSpacing: -1.5,
      fontSize: 48,
      fontFamily: 'SF Pro Display',
      color: primaryTextColor,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      letterSpacing: -1.0,
      fontSize: 40,
      fontFamily: 'SF Pro Display',
      color: primaryTextColor,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      letterSpacing: -1.0,
      fontSize: 32,
      fontFamily: 'SF Pro Display',
      color: primaryTextColor,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      letterSpacing: -1.0,
      color: primaryTextColor,
      fontSize: 28,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      letterSpacing: -1.0,
      color: primaryTextColor,
      fontSize: 24,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      color: primaryTextColor,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: 'SF Pro Display',
    ),
    titleMedium: TextStyle(
      color: primaryTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: 'SF Pro Display',
    ),
    titleSmall: TextStyle(
      color: primaryTextColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: 'SF Pro Display',
    ),
    bodyLarge: TextStyle(
      color: primaryTextColor,
      fontSize: 16,
      // fontFamily: 'ClashDisplay',
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      color: primaryTextColor,
      fontSize: 14,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      color: primaryTextColor,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: 'SF Pro Display',
    ),
    bodySmall: TextStyle(
      color: primaryTextColor,
      fontSize: 12,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      color: primaryTextColor,
      fontSize: 10,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w400,
      letterSpacing: -0.5,
    ),
  );

  // static TextTheme get secondaryTextTheme =>
  //     GoogleFonts.dmSansTextTheme().copyWith(
  //         labelMedium: GoogleFonts.dmSans().copyWith(
  //       color: primaryTextColor,
  //       // fontWeight: NkGeneralSize.generalFontWeight(),
  //     ));

  static TextTheme get secondaryTextTheme => const TextTheme(
    displayLarge: TextStyle(
      letterSpacing: -1.5,
      fontSize: 48,
      fontFamily: 'SF Pro Display',
      color: secondaryTextColour,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      letterSpacing: -1.0,
      fontSize: 40,
      fontFamily: 'SF Pro Display',
      color: secondaryTextColour,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      letterSpacing: -1.0,
      fontSize: 32,
      fontFamily: 'SF Pro Display',
      color: secondaryTextColour,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      letterSpacing: -1.0,
      color: secondaryTextColour,
      fontSize: 28,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      letterSpacing: -1.0,
      color: secondaryTextColour,
      fontSize: 24,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      color: secondaryTextColour,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: 'SF Pro Display',
    ),
    titleMedium: TextStyle(
      color: secondaryTextColour,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: 'SF Pro Display',
    ),
    titleSmall: TextStyle(
      color: secondaryTextColour,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: 'SF Pro Display',
    ),
    bodyLarge: TextStyle(
      color: secondaryTextColour,
      fontSize: 16,
      // fontFamily: 'ClashDisplay',
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      color: secondaryTextColour,
      fontSize: 14,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      color: secondaryTextColour,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: 'SF Pro Display',
    ),
    bodySmall: TextStyle(
      color: secondaryTextColour,
      fontSize: 12,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      color: secondaryTextColour,
      fontSize: 10,
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w400,
      letterSpacing: -0.5,
    ),
  );
}
