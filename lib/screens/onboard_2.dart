import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:mysharps/screens/onboard_3.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/extensions.dart';
import 'package:mysharps/utils/fonts.dart';
import 'package:mysharps/utils/functions.dart';
import 'package:page_transition/page_transition.dart';

class Onboard2 extends StatefulWidget {
  @override
  _Onboard2State createState() => _Onboard2State();
}

class _Onboard2State extends State<Onboard2> {
  bool animationStarted = true;

  @override
  void initState() {
    super.initState();
    //Functions.setStatuBarColor();
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        animationStarted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent),*/
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 800),
              curve: Curves.decelerate,
              left: -60,
              right: -60,
              top: animationStarted ? 10 : -25,
              child: AnimatedContainer(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 800),
                width: 1000,
                transform: Matrix4.rotationZ(animationStarted ? -0.07 : 0.07),
                margin: EdgeInsets.only(
                  top: context.screenHeight * 0.6,
                ),
                height: 500,
                decoration: BoxDecoration(color: greenColor),
              ),
            ),
            Positioned(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(left: 60, right: 60, top: 40),
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 60,
                            ),
                            SizedBox(height: 24),
                            Text(
                              'MYSHARP’S',
                              style: TextStyle(
                                  color: greenColor,
                                  fontFamily: Fonts.fontMedium,
                                  fontSize: 16,
                                  letterSpacing: 8.8,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12),
                            Text('YOUR NETWORK CODES IN THE POCKET',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontFamily: Fonts.fontRegular,
                                    fontSize: 11,
                                    letterSpacing: 4.8)),
                            SizedBox(
                              height: 50,
                            ),
                            Image.asset(
                              'assets/images/onboard_2.png',
                              width: 260,
                            ),
                            SizedBox(
                              height: 48,
                            ),
                            Text('Activation rapide',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: Fonts.fontRegular,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                                'Sélectionnez un code USSD et activez le en un clic.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontFamily: Fonts.fontRegular,
                                  fontSize: 12,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: context.screenWidth,
                    padding: EdgeInsets.only(
                        left: 29, right: 29, top: 60, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              CircleAvatar(
                                  radius: 5.5,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2)),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                  radius: 5.5, backgroundColor: Colors.white),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                  radius: 5.5,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2)),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                  radius: 5.5,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2)),
                            ],
                          ),
                        ),
                        Container(
                            child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: Onboard3()));
                            },
                            child: Row(
                              children: [
                                Text('Next',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: Fonts.fontRegular,
                                      fontSize: 16,
                                    )),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(Icons.arrow_forward,
                                    color: Colors.white, size: 20)
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
