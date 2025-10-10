import 'package:flutter/material.dart';
import 'package:nazra/peresentation/resources/font_manager.dart';

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
    textTheme: TextTheme(
      titleMedium: TextStyle(
        color: ColorManager.black,
        fontSize: FontSize.s26,
        fontFamily: FontConstants.fontFamily,
      ),
      bodyLarge: TextStyle(
        color: ColorManager.gray,
        fontSize: FontSize.s24,
        fontFamily: FontConstants.fontFamily,
      ),
      bodyMedium: TextStyle(
        color: ColorManager.gray,
        fontSize: FontSize.s20,
        fontFamily: FontConstants.fontFamily,
      ),
      bodySmall: TextStyle(
        color: ColorManager.gray,
        fontSize: FontSize.s16,
        fontFamily: FontConstants.fontFamily,
      ),
      titleLarge: TextStyle(
        color: ColorManager.brown,
        fontWeight: FontWeight.bold,
        fontSize: FontSize.s28,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: ColorManager.brown,
      secondary: ColorManager.lightBrown,
      surface: ColorManager.beige,
      onPrimary: ColorManager.white,
      onSecondary: ColorManager.white,
      onSurface: ColorManager.gray,
    ),
    shadowColor: Colors.grey.shade100,
    hoverColor: null,
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
      titleLarge: TextStyle(
        color: ColorManager.darkLightBrown,
        fontWeight: FontWeight.bold,
      ),
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
