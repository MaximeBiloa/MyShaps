import 'package:flutter/material.dart';

class Functions {
  static Color getColorCode(String color) {
    //Get part of color
    int colorPart = int.parse("0xFF${color.replaceAll('#', '')}");
    return Color(colorPart);
  }
}
