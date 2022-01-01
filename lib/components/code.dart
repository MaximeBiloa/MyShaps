import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysharps/core/models/code_model.dart';
import 'package:mysharps/data/button_action.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/fonts.dart';
import 'package:mysharps/utils/extensions.dart';
import 'package:mysharps/utils/functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class Codes extends StatefulWidget {
  Codes({required this.codeModel, required this.onTap});
  CodeModel codeModel;
  void Function() onTap;

  @override
  _CodesState createState() => _CodesState();
}

class _CodesState extends State<Codes> {
  late List<Widget> children;
  late Column childrenList;
  double dragPositionUpdate = 0.0;
  double dragPositionStart = 0.0;
  double dragPositionEnd = 0.0;
  double realdragPosition = 0.0;
  @override
  void initState() {
    super.initState();
    children = [];
    //constructChildren();
  }

  Widget constructChildren() {
    setState(() {
      children = [];
      for (int i = 0; i < widget.codeModel.children.length; i++) {
        children.insert(
            i,
            //Expanded(
            // child: Text('Je suis ici'),
            // )); //
            Codes(
              codeModel: widget.codeModel.children[i],
              onTap: () {
                setState(() {
                  openCodeChildren = true;
                });
              },
            ));
      }
    });
    return Container(
      child: new Column(
        children: children,
      ),
    );

    /* if (widget.codeModel.isActive)
                        Expanded(child: childrenList)*/
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!widget.codeModel.isActive) {
      setState(() {
        if (realdragPosition <= 90) {
          if (dragPositionStart < details.globalPosition.dx) {
            realdragPosition = details.globalPosition.dx - dragPositionStart;
            print("Je suis partant");
          } else {
            realdragPosition = realdragPosition - dragPositionStart;
            print("Je ne suis plus partant");
          }
          print("$dragPositionStart/$realdragPosition");
        }
      });
    }
  }

  void onHorizontalDragStart(DragStartDetails details) {
    setState(() {
      dragPositionStart = details.globalPosition.dx;
    });
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      realdragPosition = realdragPosition > 60 ? 90 : 0.0;
    });
  }

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {},
        child: GestureDetector(
          onTap: widget.onTap,
          onHorizontalDragUpdate: onHorizontalDragUpdate,
          onHorizontalDragStart: onHorizontalDragStart,
          onHorizontalDragEnd: onHorizontalDragEnd,
          child: Center(
            child: Container(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 600),
                curve: Curves.decelerate,
                margin: EdgeInsets.only(bottom: 8, top: 10),
                width: double.infinity, // context.screenWidth,
                height: widget.codeModel.isActive ? context.screenHeight : 80,
                color: widget.codeModel.isActive
                    ? widget.codeModel.color.withOpacity(0.1)
                    : Colors.transparent,
                child: Stack(
                  children: [
                    Container(
                        height: 70,
                        width: 70,
                        margin: EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                            color: widget.codeModel.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(Icons.favorite,
                            color: widget.codeModel.color)),
                    Container(
                      color: Colors.transparent,
                      child: AnimatedContainer(
                        duration: Duration(
                            milliseconds: widget.codeModel.isActive
                                ? 600
                                : realdragPosition < 0
                                    ? 200
                                    : 100),
                        margin: EdgeInsets.only(
                          left: widget.codeModel.isActive
                              ? 0
                              : realdragPosition > 0
                                  ? realdragPosition
                                  : 0,
                        ),
                        curve: Curves.decelerate,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 8,
                                            decoration: BoxDecoration(
                                                color: widget.codeModel.color,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    bottomLeft:
                                                        Radius.circular(4))),
                                          ),
                                          Expanded(
                                            child: Container(
                                              //duration: Duration(milliseconds: 100),
                                              //curve: Curves.decelerate,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(7),
                                                  bottomRight: Radius.circular(
                                                      widget.codeModel.isActive
                                                          ? 0
                                                          : 7),
                                                ),
                                                color: widget.codeModel.isActive
                                                    ? widget.codeModel.color
                                                        .withOpacity(0.1)
                                                    : Colors.white,
                                              ),
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 10, top: 0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                    '${widget.codeModel.name}',
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        color: widget
                                                                            .codeModel
                                                                            .color,
                                                                        fontFamily:
                                                                            Fonts
                                                                                .fontRegular,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                              if (widget
                                                                      .codeModel
                                                                      .level ==
                                                                  1)
                                                                SizedBox(
                                                                    width: 8),
                                                              /*if (widget.codeModel
                                                                      .level ==
                                                                  1)
                                                                Icon(
                                                                  Icons.chevron_right,
                                                                  color: widget
                                                                      .codeModel.color,
                                                                ),*/
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                            '${widget.codeModel.description}',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF95989A),
                                                                fontFamily: Fonts
                                                                    .fontMedium,
                                                                fontSize: 12.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      ],
                                                    ),
                                                  ),
                                                  /*widget.codeModel.isActive
                                                      ? Expanded(child: constructChildren())
                                                      : Container()*/
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    //Expanded(child: constructChildren())
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    sendUssdRequest(widget.codeModel.ussd_code);
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: widget.codeModel.color,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Center(
                                      child: Text('#',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: Fonts.fontRegular,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
