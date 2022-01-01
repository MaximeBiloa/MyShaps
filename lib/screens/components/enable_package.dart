import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/fonts.dart';
import 'package:mysharps/utils/extensions.dart';

class EnablePackage extends StatefulWidget {
  EnablePackage({required this.position});
  double position;

  @override
  _EnablePackageState createState() => _EnablePackageState();
}

class _EnablePackageState extends State<EnablePackage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.decelerate,
      duration: Duration(milliseconds: 700),
      right: 30,
      left: 30,
      top: widget.position,
      child: IgnorePointer(
        ignoring: false,
        child: AnimatedOpacity(
          opacity: widget.position != context.screenHeight ? 1 : 0,
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate,
          child: IgnorePointer(
            ignoring: widget.position != context.screenHeight ? false : true,
            child: Container(
              width: 272,
              height: 190,
              padding: EdgeInsets.all(26),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        spreadRadius: 2,
                        blurRadius: 3),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activation',
                      style: TextStyle(
                          fontFamily: Fonts.fontMedium,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text('Are you sure you want to activate this code?',
                      style: TextStyle(
                          fontFamily: Fonts.fontRegular,
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black.withOpacity(0.3),
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 30),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                        Material(
                            color: Colors.transparent,
                            child: InkWell(
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {},
                                child: Text('Non',
                                    style: TextStyle(
                                        fontFamily: Fonts.fontRegular,
                                        fontSize: 18,
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.w600)))),
                        SizedBox(width: 20),
                        Container(
                          height: 20,
                          width: 1,
                          color: Colors.grey.shade500,
                        ),
                        SizedBox(width: 20),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {},
                              child: Text('Oui, je veux',
                                  style: TextStyle(
                                      fontFamily: Fonts.fontRegular,
                                      fontSize: 18,
                                      color: greenColor,
                                      fontWeight: FontWeight.w600))),
                        ),
                      ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
