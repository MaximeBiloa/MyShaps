import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysharps/components/code.dart';
import 'package:mysharps/core/models/code_model.dart';
import 'package:mysharps/data/variables.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/extensions.dart';
import 'package:mysharps/utils/fonts.dart';
import 'package:mysharps/utils/functions.dart';
import 'package:page_transition/page_transition.dart';

class CodeScreen extends StatefulWidget {
  CodeScreen({required this.codeModel});
  CodeModel codeModel;

  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  //BUTTONS
  bool searchMode = false;
  late FocusNode searchFocus;
  bool startAnimation = false;
  late TextEditingController searchValue;

  //LIST OF ALL CODE FOUND ON SEARCH
  dynamic searchResultList = [];

  @override
  void initState() {
    super.initState();
    searchFocus = new FocusNode();
    searchValue = new TextEditingController();
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        startAnimation = true;
      });
    });
  }

  Widget searchResultContent() {
    return Container(
      height: context.screenHeight - 100,
      width: context.screenWidth,
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      color: themeMode ? Colors.transparent : Colors.white,
      child: searchResultList.length == 0
          ? Container(
              padding: EdgeInsets.only(left: 21, right: 21),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 600),
                curve: Curves.decelerate,
                margin: EdgeInsets.only(bottom: 8, top: 10),
                width: double.infinity, // context.screenWidth,
                height: 80,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 80,
                                  width: 8,
                                  decoration: BoxDecoration(
                                      color: themeMode
                                          ? darkModeColorSecondary
                                              .withOpacity(0.2)
                                          : Colors.black,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          bottomLeft: Radius.circular(4))),
                                ),
                                Expanded(
                                  child: Container(
                                    //duration: Duration(milliseconds: 100),
                                    //curve: Curves.decelerate,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(7),
                                        bottomRight: Radius.circular(7),
                                      ),
                                      color: themeMode
                                          ? darkModeColorSecondary
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
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text('Ooops',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: themeMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontFamily: Fonts
                                                                  .fontMedium,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Nous n’avons pas trouvé de résultat',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(0xFF95989A),
                                                      fontFamily:
                                                          Fonts.fontMedium,
                                                      fontSize: 12.5,
                                                      fontWeight:
                                                          FontWeight.w500)),
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
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(left: 21, right: 21),
                      itemCount: searchResultList.length,
                      itemBuilder: (BuildContext context, int index) {
                        CodeModel code = CodeModel.fromJson({
                          'id': searchResultList[index]['id'],
                          'name': searchResultList[index]['name'],
                          'description': searchResultList[index]['description'],
                          'photo': searchResultList[index]['photo'],
                          'state': searchResultList[index]['state'],
                          'color': Functions.getColorCode(
                              searchResultList[index]['color']),
                          'inputs': searchResultList[index]['inputs'],
                          'format': searchResultList[index]['format'],
                          'level': searchResultList[index]['level'],
                          'type': searchResultList[index]['type'],
                          'ussd_code': searchResultList[index]['ussd_code'],
                          'isActive': false,
                          'children': searchResultList[index]['children']
                        });
                        //code.children = getChildrenOfCode(widget.codeModel.children[index]['children']);

                        return Codes(
                          codeModel: code,
                          onTap: () {
                            if (code.children.length != 0) {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: CodeScreen(codeModel: code)));
                            }
                          },
                        );
                      }),
                ),
              ],
            ),
    );
  }

  void searchCodeInList(value) {
    setState(() {
      searchResultList = [];
    });
    for (int i = 0; i < widget.codeModel.children.length; i++) {
      dynamic code = widget.codeModel.children[i];
      if ((code['name'].toLowerCase()).indexOf(value.toLowerCase()) != -1) {
        searchResultList.insert(0, code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.codeModel.level);
    return WillPopScope(
      onWillPop: () async {
        if (!searchMode) {
          return true;
        } else {
          setState(() {
            searchMode = false;
          });
        }
        return false;
      },
      child: Scaffold(
          /*appBar: AppBar(
              elevation: 0,
              toolbarHeight: 0,
              brightness: Brightness.dark,
              backgroundColor: Colors.transparent),*/
          body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        color: themeMode ? darkModeColorPrimary : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Stack(
          //alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              opacity: searchMode ? 0 : 1,
              duration: Duration(milliseconds: 500),
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 18, right: 18),
                  padding: EdgeInsets.all(15),
                  height: 165,
                  decoration: BoxDecoration(
                      color: themeMode
                          ? darkModeColorSecondary.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.black.withOpacity(0.1), width: 1),
                      boxShadow: themeMode
                          ? []
                          : [
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  spreadRadius: 1,
                                  blurRadius: 1),
                            ]),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: Icon(Icons.chevron_left,
                                          color: themeMode
                                              ? Colors.white
                                              : Colors.black))),
                              SizedBox(width: 12),
                              Expanded(
                                  child: Text(
                                '${widget.codeModel.name}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color:
                                      themeMode ? Colors.white : Colors.black,
                                  fontSize: 18,
                                  fontFamily: Fonts.fontBold,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            width: context.screenWidth,
                            color: Colors.transparent,
                            child: Text(
                              '${widget.codeModel.description}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: themeMode
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade700,
                                fontSize: 14,
                                height: 1.5,
                                fontFamily: Fonts.fontMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Stack(
                    children: [
                      /* AnimatedPositioned(
                            duration: Duration(milliseconds: 500),
                            top: -20,
                            child: Container(
                              height: context.screenHeight,
                              width: context.screenWidth,
                              child: ListView.builder(
                                  padding: EdgeInsets.only(left: 21, right: 21),
                                  itemCount: widget.codeModel.children.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    CodeModel code = CodeModel.fromJson({
                                      'id': widget.codeModel.children[index]
                                          ['id'],
                                      'name': widget.codeModel.children[index]
                                          ['name'],
                                      'description': widget.codeModel
                                          .children[index]['description'],
                                      'photo': widget.codeModel.children[index]
                                          ['photo'],
                                      'state': widget.codeModel.children[index]
                                          ['state'],
                                      'color': Functions.getColorCode(widget
                                          .codeModel.children[index]['color']),
                                      'inputs': widget.codeModel.children[index]
                                          ['inputs'],
                                      'format': widget.codeModel.children[index]
                                          ['format'],
                                      'level': widget.codeModel.children[index]
                                          ['level'],
                                      'type': widget.codeModel.children[index]
                                          ['type'],
                                      'ussd_code': widget
                                          .codeModel.children[index]['ussd_code'],
                                      'isActive': false,
                                      'children': widget.codeModel.children[index]
                                          ['children']
                                    });
                                    //code.children = getChildrenOfCode(widget.codeModel.children[index]['children']);
    
                                    return Codes(
                                      codeModel: code,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                child:
                                                    CodeScreen(codeModel: code)));
                                      },
                                    );
                                  }),
                            ),
                          ),
                        */
                    ],
                  ),
                )
              ]),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 600),
              top: widget.codeModel.level != 1
                  ? 25
                  : startAnimation
                      ? 25
                      : 32,
              right: widget.codeModel.level != 1
                  ? 30
                  : (searchMode || startAnimation)
                      ? 30
                      : 60,
              left: searchMode
                  ? 30
                  : (widget.codeModel.level != 1)
                      ? context.screenWidth - 100
                      : startAnimation
                          ? context.screenWidth - 100
                          : context.screenWidth - 140,
              curve: Curves.decelerate,
              child: AnimatedOpacity(
                opacity: 1,
                duration: Duration(milliseconds: 500),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  padding: EdgeInsets.only(right: 20, left: 20),
                  //width: searchMode ? context.screenWidth - 45 : 100,
                  height: 50,
                  decoration: BoxDecoration(
                      color: !searchMode
                          ? Colors.white.withOpacity(0)
                          : themeMode
                              ? darkModeColorSecondary.withOpacity(0.1)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: (!searchMode || themeMode)
                          ? []
                          : [
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  spreadRadius: 1,
                                  blurRadius: 1),
                            ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (searchMode)
                        Expanded(
                            child: TextFormField(
                          controller: searchValue,
                          focusNode: searchFocus,
                          style: TextStyle(
                              fontFamily: Fonts.fontRegular,
                              fontSize: 16,
                              color: themeMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Rechercher',
                            hintStyle: TextStyle(
                                fontFamily: Fonts.fontRegular,
                                fontSize: 16,
                                color: grey2Color,
                                fontWeight: FontWeight.w600),
                          ),
                          onChanged: (value) {
                            searchCodeInList(value);
                          },
                        )),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              searchMode = !searchMode;
                              if (searchMode) {
                                searchFocus.requestFocus();
                              } else {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }
                            });
                          },
                          child: Image.asset(
                            themeMode
                                ? 'assets/images/search-icon-dark.png'
                                : 'assets/images/search-icon.png',
                            width: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              curve: Curves.decelerate,
              top: (startAnimation && !searchMode) ? 190 : context.screenHeight,
              child: Container(
                height: context.screenHeight - 200,
                width: context.screenWidth,
                child: ListView.builder(
                    padding: EdgeInsets.only(left: 21, right: 21, bottom: 10),
                    itemCount: widget.codeModel.children.length,
                    itemBuilder: (BuildContext context, int index) {
                      CodeModel code = CodeModel.fromJson({
                        'id': widget.codeModel.children[index]['id'],
                        'name': widget.codeModel.children[index]['name'],
                        'description': widget.codeModel.children[index]
                            ['description'],
                        'photo': widget.codeModel.children[index]['photo'],
                        'state': widget.codeModel.children[index]['state'],
                        'color': Functions.getColorCode(
                            widget.codeModel.children[index]['color']),
                        'inputs': widget.codeModel.children[index]['inputs'],
                        'format': widget.codeModel.children[index]['format'],
                        'level': widget.codeModel.children[index]['level'],
                        'type': widget.codeModel.children[index]['type'],
                        'ussd_code': widget.codeModel.children[index]
                            ['ussd_code'],
                        'isActive': false,
                        'children': widget.codeModel.children[index]['children']
                      });
                      //code.children = getChildrenOfCode(widget.codeModel.children[index]['children']);

                      return Codes(
                        codeModel: code,
                        onTap: () {
                          if (code.children.length != 0) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: CodeScreen(codeModel: code)));
                          }
                        },
                      );
                    }),
              ),
            ),
            AnimatedPositioned(
              top: searchMode ? 120 : context.screenHeight,
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate,
              child: searchValue.text.length != 0
                  ? searchResultContent()
                  : Container(
                      height: context.screenHeight,
                      width: context.screenWidth,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      color: themeMode ? Colors.transparent : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/search-img.png',
                              width: 240),
                          SizedBox(height: 36),
                          Text(
                              'Retrouvez instantanément les forfaits de votre opérateur téléphonique',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: themeMode
                                      ? Colors.grey.shade500
                                      : Colors.black.withOpacity(0.3),
                                  fontFamily: Fonts.fontMedium,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
            )
          ],
        ),
      )),
    );
  }
}
