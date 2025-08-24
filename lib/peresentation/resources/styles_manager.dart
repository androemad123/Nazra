import 'package:flutter/material.dart';
import 'package:nazra/peresentation/resources/font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontWeight: fontWeight,
    fontFamily: FontConstants.fontFamily,
    color: color,
    fontSize: fontSize,
  );
}

TextStyle regularStyle({required double fontSize, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

TextStyle boldStyle({required double fontSize, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.bold, color);
}
