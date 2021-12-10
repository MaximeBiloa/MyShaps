import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/extensions.dart';
import 'package:mysharps/utils/fonts.dart';

class OnBoardPage extends StatefulWidget {
  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  bool animationStarted_1 = true;
  bool animationStarted_2 = false;
  bool animationStarted_3 = false;
  late CarouselSliderController _carouselSliderController;

  @override
  void initState() {
    super.initState();

    _carouselSliderController = CarouselSliderController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  GlobalKey<dynamic> _sliderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<Widget> slides = [
      Container(
        width: context.screenWidth,
        height: context.screenHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 1000),
              curve: Curves.decelerate,
              left: animationStarted_1 ? -50 : -50,
              right: -50,
              top: animationStarted_1 ? 10 : -25,
              child: AnimatedContainer(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 1000),
                width: 1000,
                transform: Matrix4.rotationZ(animationStarted_1 ? -0.07 : 0.07),
                margin: EdgeInsets.only(
                  top: context.screenHeight - 275,
                ),
                height: 320,
                decoration: BoxDecoration(color: greenColor),
              ),
            ),
            Positioned(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 72, right: 72, top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 80,
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
                      'assets/images/onboard_1.png',
                      width: 240,
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    Text('Aucune mémorisation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: Fonts.fontRegular,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 7,
                    ),
                    Text('Plus de 500 codes USSD de vos opérateurs préferés.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontFamily: Fonts.fontRegular,
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 22,
              right: 30,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _carouselSliderController.nextPage();
                    setState(() {
                      animationStarted_1 = !animationStarted_1;
                      Timer(Duration(milliseconds: 2000), () {
                        animationStarted_2 = true;
                      });
                    });
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
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      Container(
        width: context.screenWidth,
        height: context.screenHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 1000),
              curve: Curves.decelerate,
              left: animationStarted_2 ? -50 : -50,
              right: -50,
              top: animationStarted_2 ? 10 : -25,
              child: AnimatedContainer(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 1000),
                width: 1000,
                transform: Matrix4.rotationZ(animationStarted_2 ? -0.07 : 0.07),
                margin: EdgeInsets.only(
                  top: context.screenHeight - 275,
                ),
                height: 320,
                decoration: BoxDecoration(color: greenColor),
              ),
            ),
            Positioned(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 72, right: 72, top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 80,
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
                      width: 240,
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    Text('Activation rapide',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: Fonts.fontRegular,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 7,
                    ),
                    Text('Sélectionnez un code USSD et activez le en un clic.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontFamily: Fonts.fontRegular,
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 22,
              right: 30,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _carouselSliderController.nextPage();
                    setState(() {
                      animationStarted_2 = !animationStarted_2;
                    });
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
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      Container(
        width: context.screenWidth,
        height: context.screenHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 1000),
              curve: Curves.decelerate,
              left: animationStarted_3 ? -50 : -50,
              right: -50,
              top: animationStarted_3 ? 10 : -25,
              child: AnimatedContainer(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 1000),
                width: 1000,
                transform: Matrix4.rotationZ(animationStarted_3 ? -0.07 : 0.07),
                margin: EdgeInsets.only(
                  top: context.screenHeight - 275,
                ),
                height: 320,
                decoration: BoxDecoration(color: greenColor),
              ),
            ),
            Positioned(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 72, right: 72, top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          animationStarted_3 = !animationStarted_3;
                        });
                      },
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 80,
                      ),
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
                      'assets/images/onboard_3.png',
                      width: 240,
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    Text('Partage instantané',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: Fonts.fontRegular,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                        'Sélectionnez et partagez rapidement tout les codes USSD',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontFamily: Fonts.fontRegular,
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 22,
              right: 30,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _carouselSliderController.nextPage();
                    setState(() {
                      animationStarted_3 = !animationStarted_3;
                    });
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
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ];

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: CarouselSlider.builder(
            key: _sliderKey,
            unlimitedMode: true,
            controller: _carouselSliderController,
            slideBuilder: (index) {
              return slides[index];
            },
            slideTransform: DefaultTransform(),
            autoSliderTransitionTime: Duration(milliseconds: 10),
            slideIndicator: CircularSlideIndicator(
                padding: EdgeInsets.only(bottom: 30, left: 25),
                alignment: Alignment.bottomLeft,
                indicatorBorderColor: Colors.transparent,
                indicatorBackgroundColor: Colors.white.withOpacity(0.2),
                indicatorRadius: 4,
                currentIndicatorColor: Colors.white,
                indicatorBorderWidth: 0),
            itemCount: slides.length,
            initialPage: 0,
            enableAutoSlider: false));
  }
}
