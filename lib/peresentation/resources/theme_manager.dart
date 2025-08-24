import 'package:flutter/material.dart';

import 'color_manager.dart';

class ThemeManager {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorManager.brown,
    scaffoldBackgroundColor: ColorManager.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorManager.brown,
      foregroundColor: ColorManager.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: ColorManager.gray),
      bodyMedium: TextStyle(color: ColorManager.gray),
      bodySmall: TextStyle(color: ColorManager.gray),
      titleLarge: TextStyle(color: ColorManager.brown, fontWeight: FontWeight.bold),
    ),
    colorScheme: const ColorScheme.light(
      primary: ColorManager.brown,
      secondary: ColorManager.lightBrown,
      surface: ColorManager.beige,
      onPrimary: ColorManager.white,
      onSecondary: ColorManager.white,
      onSurface: ColorManager.gray,

    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorManager.darkBrown,
    scaffoldBackgroundColor: ColorManager.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorManager.darkBrown,
      foregroundColor: ColorManager.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: ColorManager.lightGray),
      bodyMedium: TextStyle(color: ColorManager.lightGray),
      bodySmall: TextStyle(color: ColorManager.lightGray),
      titleLarge: TextStyle(color: ColorManager.darkLightBrown, fontWeight: FontWeight.bold),
    ),
    colorScheme: const ColorScheme.dark(
      primary: ColorManager.darkBrown,
      secondary: ColorManager.darkLightBrown,
      surface: ColorManager.darkBeige,
      onPrimary: ColorManager.white,
      onSecondary: ColorManager.white,
      onSurface: ColorManager.lightGray,
    ),
  );
}
