import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mysharps/core/models/category_model.dart';
import 'package:mysharps/core/models/operator_model.dart';
import 'package:mysharps/core/providers/categories_provider.dart';
import 'package:mysharps/core/providers/countries_provider.dart';
import 'package:mysharps/core/providers/operators_provider.dart';
import 'package:mysharps/screens/components/category_button.dart';
import 'package:mysharps/screens/components/code.dart';
import 'package:mysharps/screens/data/variables.dart';
import 'package:mysharps/screens/onboard_1.dart';
import 'package:mysharps/screens/onboard_3.dart';
import 'package:mysharps/screens/onboard_4.dart';
import 'package:mysharps/screens/ussd_list.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/extensions.dart';
import 'package:mysharps/utils/functions.dart';
import 'package:page_transition/page_transition.dart';

class Splashcreen extends StatefulWidget {
  @override
  _SplashcreenState createState() => _SplashcreenState();
}

class _SplashcreenState extends State<Splashcreen> {
  bool animationStarted = false;
  late Timer splashTimer;
  int round = 0;
  bool contentGet = false;
  //=========================

  //PROVIDERS
  late CategoriesProvider categoriesProvider;
  late CountriesProvider countriesProvider;
  late OperatorsProvider operatorsProvider;

  void startAnimation() {
    splashTimer = Timer.periodic(Duration(milliseconds: 900), (Timer t) {
      setState(() {
        animationStarted = !animationStarted;
        if (contentGet) {
          splashTimer.cancel();
          Navigator.push(context,
              PageTransition(type: PageTransitionType.fade, child: Onboard1()));
        }
      });
    });
  }

  void getOperators() {
    operatorsProvider.getAllOperators().then((datas) {
      if (datas != null) {
        dynamic alloperators = datas['data']['operators'];
        //print(datas);
        setState(() {
          //GET ALL OPERATORS CONTENT FOR CHOOSE
          for (int i = 0; i < alloperators.length; i++) {
            OperatorModel _operator = new OperatorModel.fromJson({
              "id": alloperators[i]['id'],
              "name": alloperators[i]['name'],
              "description": alloperators[i]['description'],
              "photo": alloperators[i]['photo'],
              "state": alloperators[i]['state'],
              "logo": alloperators[i]['logo'],
              "color": Colors.white,
              "slogan": alloperators[i]['slogan'],
              "isActive": i == 0 ? true : false
            });
            operatorsChoose.insert(i, _operator);

            //SAVE FIRST OPERATOR ID
            operatorId = operatorsChoose[0].id;
          }

          //GET ALL OPERATORS CONTENT WITH COLOR
          for (int i = 0; i < alloperators.length; i++) {
            OperatorModel _operator = new OperatorModel.fromJson({
              "id": alloperators[i]['id'],
              "name": alloperators[i]['name'],
              "description": alloperators[i]['description'],
              "photo": alloperators[i]['photo'],
              "state": alloperators[i]['state'],
              "logo": alloperators[i]['logo'],
              "color": Functions.getColorCode(alloperators[i]['color']),
              "slogan": alloperators[i]['slogan'],
              "isActive": i == 0 ? true : false
            });
            operators.insert(i, _operator);
          }

          contentGet = true;
        });
      } else {
        print("Erreur lors de la recuperation");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //INITIALIZE CATEGORIES PROVIDER
    categoriesProvider = new CategoriesProvider();
    countriesProvider = new CountriesProvider();
    operatorsProvider = new OperatorsProvider();
    startAnimation();
    //getCategories();
    getOperators();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent),
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              curve: Curves.decelerate,
              top: animationStarted
                  ? context.screenHeight * 0.25
                  : context.screenHeight * 0.3,
              duration: Duration(milliseconds: 500),
              child: Container(
                  width: 230,
                  child: Image.asset(
                    'assets/images/logo.png',
                  )),
            ),
            Positioned(
              top: context.screenHeight * 0.7,
              child: Stack(
                children: [
                  AnimatedContainer(
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: 500),
                    height: 30,
                    width: animationStarted ? 100 : 210,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.20),
                          blurRadius: 20,
                          offset: Offset(4, 8), // Shadow position
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
