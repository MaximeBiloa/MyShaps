import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:mysharps/data/variables.dart';
import 'package:mysharps/utils/colors.dart';

class Functions {
  static Color getColorCode(String color) {
    //Get part of color
    int colorPart = int.parse("0xFF${color.replaceAll('#', '')}");
    return Color(colorPart);
  }

  static setStatuBarColor() async {
    FlutterStatusbarManager.setHidden(true);
    FlutterStatusbarManager.setColor(
      themeMode ? darkModeColorPrimary : Colors.white,
    );
    FlutterStatusbarManager.setStyle(
        themeMode ? StatusBarStyle.LIGHT_CONTENT : StatusBarStyle.DARK_CONTENT);
    Timer(Duration(milliseconds: 100), () {
      FlutterStatusbarManager.setHidden(false);
    });

    //await
  }
}
