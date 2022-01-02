import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:mysharps/components/operatorchoose_button.dart';
import 'package:mysharps/data/variables.dart';
import 'package:mysharps/screens/onboard_1.dart';
import 'package:mysharps/screens/onboard_2.dart';
import 'package:mysharps/screens/ussd_list.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/extensions.dart';
import 'package:mysharps/utils/fonts.dart';
import 'package:mysharps/utils/functions.dart';
import 'package:page_transition/page_transition.dart';

class Onboard4 extends StatefulWidget {
  @override
  _Onboard4State createState() => _Onboard4State();
}

class _Onboard4State extends State<Onboard4> {
  bool animationStarted = false;

  @override
  void initState() {
    super.initState();
    //Functions.setStatuBarColor();
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        animationStarted = true;
      });
    });
  }

  void getActiveOperator(int id) {
    setState(() {
      for (int i = 0; i < operatorsChoose.length; i++) {
        if (operatorsChoose[i].id == id) {
          operatorsChoose[i].isActive = true;
          operatorId = operatorsChoose[i].id;
        } else {
          operatorsChoose[i].isActive = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
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
              right: -50,
              top: animationStarted ? 10 : -25,
              child: AnimatedContainer(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 800),
                width: 1000,
                transform: Matrix4.rotationZ(animationStarted ? -0.07 : 0.07),
                margin: EdgeInsets.only(
                  top: context.screenHeight * 0.5,
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
                                    fontSize: 9,
                                    letterSpacing: 4.8)),
                            SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              'assets/images/onboard_4.png',
                              width: 260,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text('Quel est votre opérateur ?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 1.5,
                                    color: Colors.white,
                                    fontFamily: Fonts.fontRegular,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              height: 8,
                            ),
                            Text('Faites un choix dans la liste ci dessous',
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
                    margin: EdgeInsets.only(top: 20),
                    width: context.screenWidth,
                    height: 140,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                              child: Container(
                            width: context.screenWidth,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.symmetric(horizontal: 0),
                            child: Center(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: operatorsChoose.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return OperatorChooseButton(
                                      operatorModel: operatorsChoose[index],
                                      onTap: () {
                                        getActiveOperator(operators[index].id);
                                      },
                                    );
                                  }),
                            ),
                          )),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 29, right: 29, top: 20, bottom: 30),
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
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CircleAvatar(
                                        radius: 5.5,
                                        backgroundColor: Colors.white),
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
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child: UssdList()));
                                  },
                                  child: Row(
                                    children: [
                                      Text('Commencer',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: Fonts.fontRegular,
                                            fontSize: 16,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.arrow_forward,
                                          color: Colors.white, size: 20)
                                    ],
                                  ),
                                ),
                              ))
                            ],
                          ),
                        ),
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
