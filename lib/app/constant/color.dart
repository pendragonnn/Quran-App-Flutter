import 'package:flutter/material.dart';

const appPurple = Color(0xFF431AA1);
const appPurpleDark = Color(0xFF1E0771);
const appPurpleLight1 = Color(0xFF9345F2);
const appPurpleLight2 = Color(0xFF89A2D8);
const appWhite = Color(0xFFFAF8FC);
const appOrange = Color(0xFFE6704A);

ThemeData themeLight = ThemeData(
  brightness: Brightness.light,
  primaryColor: appPurple,
  scaffoldBackgroundColor: appWhite,
  appBarTheme: AppBarTheme(
    backgroundColor: appPurple,
    elevation: 4,
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: appPurpleDark),
    bodySmall: TextStyle(color: appPurpleDark),
  ),
);

ThemeData themeDark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: appPurpleLight2,
  scaffoldBackgroundColor: appPurpleDark,
  appBarTheme: AppBarTheme(
    backgroundColor: appPurpleDark,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: appWhite),
    bodySmall: TextStyle(color: appWhite),
  ),
);
