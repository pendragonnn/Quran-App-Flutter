import 'package:flutter/material.dart';

const appPurple = Color(0xFF431AA1);
const appPurpleDark = Color(0xFF1E0771);
const appPurpleLight1 = Color(0xFF9345F2);
const appPurpleLight2 = Color(0xFF89A2D8);
const appWhite = Color(0xFFFAF8FC);
const appOrange = Color(0xFFE6704A);

ThemeData themeLight = ThemeData(
  primaryColor: appPurple,
  scaffoldBackgroundColor: appWhite,
  appBarTheme: AppBarTheme(
    backgroundColor: appPurple,
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: appPurpleDark),
    bodySmall: TextStyle(color: appPurpleDark),
  ),
);

ThemeData themeDark = ThemeData(
  primaryColor: appPurpleLight2,
  scaffoldBackgroundColor: appPurpleDark,
  appBarTheme: AppBarTheme(
    backgroundColor: appPurpleDark,
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: appWhite),
    bodySmall: TextStyle(color: appWhite),
  ),
);
