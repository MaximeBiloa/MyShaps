import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysharps/core/models/code_model.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/extensions.dart';
import 'package:mysharps/utils/fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:sim_data/sim_model.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class EnablePackage extends StatefulWidget {
  EnablePackage({required this.codeModel});
  CodeModel codeModel;
  @override
  _EnablePackageState createState() => _EnablePackageState();
}

class _EnablePackageState extends State<EnablePackage> {
  Future<void> sendUssdRequest(String ussd_code) async {
    //String _requestCode = "";
    String _responseCode = "";
    String _responseMessage = "";
    try {
      await Permission.phone.request();
      if (!await Permission.phone.isGranted) {
        throw Exception("permission missing");
      }

      SimData simData = await SimDataPlugin.getSimData();
      await UssdAdvanced.sendUssd(
          code: ussd_code, subscriptionId: simData.cards.first.subscriptionId);
      //responseMessage = await UssdService.makeRequest(
      //    simData.cards.first.subscriptionId, _requestCode);
      setState(() {
        //_responseMessage = responseMessage;
      });
    } on PlatformException catch (e) {
      setState(() {
        _responseCode = e is PlatformException ? e.code : "";
        _responseMessage = e.message ?? '';
      });
      print("Erreur ici $_responseCode");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
        height: context.screenHeight,
        width: context.screenWidth,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: 1,
                duration: Duration(milliseconds: 2000),
                curve: Curves.decelerate,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                        ),
                        child: Container(
                          color: Colors.grey.withOpacity(0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.decelerate,
              duration: Duration(milliseconds: 700),
              right: 30,
              left: 30,
              top: 230,
              child: IgnorePointer(
                ignoring: false,
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  child: IgnorePointer(
                    ignoring: false,
                    child: Container(
                      width: 272,
                      height: 200,
                      padding: EdgeInsets.all(26),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 1,
                                blurRadius: 3),
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              child: Row(children: [
                            Text('Activation',
                                style: TextStyle(
                                    fontFamily: Fonts.fontMedium,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                  height: 28,
                                  decoration: BoxDecoration(
                                      color: widget.codeModel.color
                                          .withOpacity(0.2),
                                      border: Border.all(
                                          color: widget.codeModel.color
                                              .withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text('${widget.codeModel.ussd_code}',
                                        style: TextStyle(
                                            color: widget.codeModel.color,
                                            fontFamily: Fonts.fontMedium,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  )),
                            )
                          ])),
                          SizedBox(height: 12),
                          Text('Êtes-vous sûr de vouloir activer ce code ?',
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
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Non',
                                            style: TextStyle(
                                                fontFamily: Fonts.fontRegular,
                                                fontSize: 18,
                                                color: Colors.black
                                                    .withOpacity(0.6),
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
                                      onTap: () {
                                        Navigator.pop(context);

                                        sendUssdRequest(
                                            widget.codeModel.ussd_code);
                                      },
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
            )
          ],
        ),
      ),
    );
  }
}
