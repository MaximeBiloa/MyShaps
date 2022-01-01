import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

class Functions {
  static Color getColorCode(String color) {
    //Get part of color
    int colorPart = int.parse("0xFF${color.replaceAll('#', '')}");
    return Color(colorPart);
  }

  static setStatuBarColor() async {
    //await FlutterStatusbarManager.setColor(Colors.white, animated: true);
    //await FlutterStatusbarManager.setStyle(StatusBarStyle.DARK_CONTENT);
  }
}
