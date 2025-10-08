import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';

class ThemeManager {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: FontConstants.fontFamily,
    primaryColor: ColorManager.brown,
    scaffoldBackgroundColor: ColorManager.white,
    textTheme: TextTheme(
      displayLarge: TextStyle(fontFamily: FontConstants.fontFamily),
      displayMedium: TextStyle(fontFamily: FontConstants.fontFamily),
      displaySmall: TextStyle(fontFamily: FontConstants.fontFamily),
      headlineLarge: TextStyle(fontFamily: FontConstants.fontFamily),
      headlineMedium: TextStyle(fontFamily: FontConstants.fontFamily),
      headlineSmall: TextStyle(fontFamily: FontConstants.fontFamily),
      titleLarge: TextStyle(
        color: ColorManager.black,
        fontWeight: FontWeightManager.semiBold,
        fontFamily: FontConstants.fontFamily,
      ),
      titleMedium: TextStyle(fontFamily: FontConstants.fontFamily),
      titleSmall: TextStyle(fontFamily: FontConstants.fontFamily),
      bodyLarge: const TextStyle(color: ColorManager.lightGray),
      bodyMedium: const TextStyle(color: ColorManager.gray),
      bodySmall: const TextStyle(color: ColorManager.gray),
      labelLarge: TextStyle(fontFamily: FontConstants.fontFamily),
      labelMedium: TextStyle(fontFamily: FontConstants.fontFamily),
      labelSmall: TextStyle(fontFamily: FontConstants.fontFamily),
    ),
    colorScheme: const ColorScheme.light(
      primary: ColorManager.brown,
      secondary: ColorManager.lightBrown,
      surface: ColorManager.beige,
      onPrimary: ColorManager.black,
      onSecondary: ColorManager.white,
      onSurface: ColorManager.gray,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.brown,
        foregroundColor: ColorManager.white,
        disabledBackgroundColor: ColorManager.lightGray,
        disabledForegroundColor: ColorManager.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          fontWeight: FontWeightManager.semiBold,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorManager.black,
        textStyle: TextStyle(
          fontWeight: FontWeightManager.semiBold,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: FontConstants.fontFamily,
    primaryColor: ColorManager.darkBrown,
    // Lighten overall dark background as requested
    scaffoldBackgroundColor: ColorManager.beige,

    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: FontConstants.fontFamily),
      displayMedium: TextStyle(fontFamily: FontConstants.fontFamily),
      displaySmall: TextStyle(fontFamily: FontConstants.fontFamily),
      headlineLarge: TextStyle(fontFamily: FontConstants.fontFamily),
      headlineMedium: TextStyle(fontFamily: FontConstants.fontFamily),
      headlineSmall: TextStyle(fontFamily: FontConstants.fontFamily),
      titleLarge: TextStyle(color: ColorManager.white, fontWeight: FontWeight.bold, fontFamily: FontConstants.fontFamily),
      titleMedium: TextStyle(fontFamily: FontConstants.fontFamily),
      titleSmall: TextStyle(fontFamily: FontConstants.fontFamily),
      bodyLarge: TextStyle(color: ColorManager.lightGray),
      bodyMedium: TextStyle(color: ColorManager.lighterGray),
      bodySmall: TextStyle(color: ColorManager.lightGray),
      labelLarge: TextStyle(fontFamily: FontConstants.fontFamily),
      labelMedium: TextStyle(fontFamily: FontConstants.fontFamily),
      labelSmall: TextStyle(fontFamily: FontConstants.fontFamily),
    ),
    colorScheme: const ColorScheme.dark(
      primary: ColorManager.darkBrown,
      secondary: ColorManager.darkLightBrown,
      surface: ColorManager.darkBeige,
      onPrimary: ColorManager.white,
      onSecondary: ColorManager.white,
      onSurface: ColorManager.lightGray,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.darkBrown,
        foregroundColor: ColorManager.white,
        disabledBackgroundColor: ColorManager.darkLightBrown,
        disabledForegroundColor: ColorManager.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          fontWeight: FontWeightManager.semiBold,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorManager.darkLightBrown,
        textStyle: TextStyle(
          fontWeight: FontWeightManager.semiBold,
        ),
      ),
    ),
  );
}
