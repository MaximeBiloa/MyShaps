import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mysharps/screens/code_screen.dart';
import 'package:mysharps/screens/onboard_1.dart';
import 'package:mysharps/screens/onboard_2.dart';
import 'package:mysharps/screens/onboard_3.dart';
import 'package:mysharps/screens/onboard_4.dart';
import 'package:mysharps/screens/onboard_page.dart';
import 'package:mysharps/screens/splashcreen.dart';
import 'package:mysharps/screens/ussd_list.dart';

void main() {
  runApp(MyApp());
  HttpOverrides.global = new MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MySharp's",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splashcreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
