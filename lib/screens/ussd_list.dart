//import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_store/json_store.dart';
import 'package:mysharps/components/category_empty.dart';
import 'package:mysharps/components/code.dart';
import 'package:mysharps/components/enable_package.dart';
import 'package:mysharps/components/menu_option.dart';
import 'package:mysharps/components/notification_template.dart';
import 'package:mysharps/components/operator_button.dart';
import 'package:mysharps/components/operator_loading_shimmer.dart';
import 'package:mysharps/core/models/category_model.dart';
import 'package:mysharps/core/models/code_model.dart';
import 'package:mysharps/core/providers/categories_provider.dart';
import 'package:mysharps/core/providers/operators_provider.dart';
import 'package:mysharps/screens/code_screen.dart';
import 'package:mysharps/data/variables.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/fonts.dart';
import 'package:mysharps/utils/extensions.dart';
import 'package:mysharps/utils/functions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:ussd_service/ussd_service.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';

class UssdList extends StatefulWidget {
  @override
  _UssdListState createState() => _UssdListState();
}

class _UssdListState extends State<UssdList> with TickerProviderStateMixin {
  //BUTTONS
  bool more = false;
  bool searchMode = false;
  bool notification = false;
  bool whatNew = false;
  bool about = false;
  bool enablePackage = false;
  bool operatorDatasLoading = true;
  bool openCodeChildren = false;
  bool backAnimation = false;
  bool startAnimation = false;
  late CodeModel currentCode;
  //===============================

  late TextEditingController searchValue;

  //LIST OF ALL CODE FOUND ON SEARCH
  dynamic searchResultList = [];

  //PROVIDERS
  late CategoriesProvider categoriesProvider;
  late OperatorsProvider operatorsProvider;

  //CONTROLLERS
  late TabController _categoriesController;
  int currentCategoryIndex = 0;
  int currentOperatorIndex = 0;

  late FocusNode searchFocus;
  late JsonStore jsonStore;

  @override
  void initState() {
    super.initState();

    searchValue = new TextEditingController();
    searchFocus = new FocusNode();
    jsonStore = new JsonStore();

    //INITIALIZE CATEGORIES PROVIDER
    categoriesProvider = new CategoriesProvider();
    operatorsProvider = new OperatorsProvider();

    searchValue = new TextEditingController();

    //BACK REQUEST TO GET OPERATORS DATAS
    getAllOperatorsDatasToSaveLocal();
    //===================================

    //INITIALIZE CATEGORIES CONTROLLER;
    _categoriesController = new TabController(
        length: categories.length,
        vsync: this,
        initialIndex: currentCategoryIndex);
    _categoriesController.addListener(() {
      setState(() {
        currentCategoryIndex = _categoriesController.index;
        getActiveCategory(currentCategoryIndex);
      });
    });

    //GET CONTENT OF CURRENT OPERATOR
    getCurrentOperatorDatas(operatorId);
  }

  @override
  void dispose() {
    _categoriesController.dispose();
    super.dispose();
  }

  void getActiveOperator(int id) {
    setState(() {
      for (int i = 0; i < operators.length; i++) {
        if (operators[i].id == id) {
          operators[i].isActive = true;
          operatorId = operators[i].id;
        } else {
          operators[i].isActive = false;
        }
      }
    });
    if (localOperators.length == 0) {
      //After loop, get content of this current operator
      getCurrentOperatorDatas(operatorId);
    } else {
      getLocalCurrentOperatorDatasById(operatorId);
    }
  }

  void getActiveCategory(int index) {
    setState(() {
      currentCategoryIndex = index;
      print(currentCategoryIndex);
    });
  }

  void getCurrentOperatorDatas(int operatorId) {
    setState(() {
      //start Loading of operator datas
      operatorDatasLoading = true;
      if (localOperators.length == 0) {
        operatorsProvider.getAllOperatorsDatas(operatorId).then((datas) {
          //Stop Loading of operator datas
          operatorDatasLoading = false;
          if (datas != null) {
            dynamic operatorDatas = datas['data'];
            constructOperatorCategories(operatorDatas['categories']);
          } else {
            print("Erreur de récupération du contenu");
          }
        });
      } else {
        operatorDatasLoading = false;
        getLocalCurrentOperatorDatasById(operatorId);
      }
    });
  }

  void constructOperatorCategories(dynamic operatorCategories) {
    setState(() {
      //CLEAR CATEGORIES LIST
      categories = [];
      //CLEAR CATEGORIES CONTENT LIST
      tabBarViewCategories = [];
      //CLEAR TABBAR CATEGORY LIST
      tabBarCategories = [];

      //GET TABS CONTENT
      for (int i = 0; i < operatorCategories.length; i++) {
        CategoryModel category = new CategoryModel.fromJson({
          "id": operatorCategories[i]['id'],
          "name": operatorCategories[i]['name'],
          "description": operatorCategories[i]['description'],
          "color": operatorCategories[i]['color'],
          "photo": operatorCategories[i]['photo'],
          "state": operatorCategories[i]['state'],
          "codes": operatorCategories[i]['codes'],
          "isNew": false,
          "isActive": i == 0 ? true : false
        });

        //SAVE  CURRENT CATEGORY ON LIST
        categories.insert(i, category);

        //CONSTRUCTION OF TABAR CATEGORIES
        tabBarCategories.insert(
            i,
            Tab(
              text: category.name.toUpperCase(),
            ));

        //CONSTRUCTION OF ALL CODE OF CATEGORIES
        if (category.codes.length != 0) {
          tabBarViewCategories.insert(i, codeList(category));
        } else {
          tabBarViewCategories.insert(i, CategoryEmpty());
        }
      }

      //UPDATE LENGTH OF TABCONTROLLER
      _categoriesController = TabController(
          length: categories.length,
          vsync: this,
          initialIndex: currentCategoryIndex);
      _categoriesController.addListener(() {
        setState(() {
          currentCategoryIndex = _categoriesController.index;
          getActiveCategory(currentCategoryIndex);
        });
      });
    });
  }

  //Methode permettant de renvoyer
  List<CodeModel> getChildrenOfCode(dynamic children) {
    List<CodeModel> listCode = [];
    for (int i = 0; i < children.length; i++) {
      if (children.runtimeType != CodeModel) {
        CodeModel code = CodeModel.fromJson({
          'id': children[i]['id'],
          'name': children[i]['name'],
          'description': children[i]['description'],
          'photo': children[i]['photo'],
          'state': children[i]['state'],
          'color': Functions.getColorCode(children[i]['color']),
          'inputs': children[i]['inputs'],
          'format': children[i]['format'],
          'type': children[i]['type'],
          'level': children[i]['level'],
          'ussd_code': children[i]['ussd_code'],
          'isActive': false,
          'children': children[i]['children']
        });
        //code.children = children[i]['children'].length != 0
        //? getChildrenOfCode(children[i]['children'])
        //: [];

        listCode.insert(i, code);
      } else {
        CodeModel code = CodeModel.fromJson({
          'id': children[i].id,
          'name': children[i].name,
          'description': children[i].description,
          'photo': children[i].photo,
          'state': children[i].state,
          'color': Functions.getColorCode(children[i].color),
          'inputs': children[i].inputs,
          'format': children[i].format,
          'type': children[i].type,
          'level': children[i].level,
          'ussd_code': children[i].ussd_code,
          'isActive': false,
          'children': []
        });
        code.children = children[i]['children'].length != 0
            ? getChildrenOfCode(children[i]['children'])
            : [];

        listCode.insert(i, code);
      }
    }
    return listCode;
  }

  //Methode permettant de renvoyer la liste de codes
  Widget codeList(CategoryModel category) {
    return ListView.builder(
        padding: EdgeInsets.only(left: 21, right: 21),
        itemCount: category.codes.length,
        itemBuilder: (BuildContext context, int index) {
          CodeModel code = CodeModel.fromJson({
            'id': category.codes[index]['id'],
            'name': category.codes[index]['name'],
            'description': category.codes[index]['description'],
            'photo': category.codes[index]['photo'],
            'state': category.codes[index]['state'],
            'color': Functions.getColorCode(category.codes[index]['color']),
            'inputs': category.codes[index]['inputs'],
            'format': category.codes[index]['format'],
            'type': category.codes[index]['type'],
            'level': category.codes[index]['level'],
            'ussd_code': category.codes[index]['ussd_code'],
            'isActive': false,
            'children': category.codes[index]['children']
          });
          //code.children = getChildrenOfCode(category.codes[index]['children']);

          return Codes(
            codeModel: code,
            onTap: () {
              if (code.children.length != 0) {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            CodeScreen(codeModel: code),
                        transitionDuration: Duration.zero));
              }
            },
          );
        });
  }

  //LOCAL FONCTION===================================================
  //Méthode permettant de récupérer tous les opérateurs et leurs données depuis l'API
  void getAllOperatorsDatasToSaveLocal() {
    operatorsProvider.getAllOperators().then((datas) {
      if (datas != null) {
        List<dynamic> operatorsDatas = datas['data']['operators'];
        //Loop to get all operators datas
        for (int i = 0; i < operatorsDatas.length; i++) {
          //REQUEST TO GET OPERATOR DATAS BY ID
          int id = operatorsDatas[i]['id'];
          operatorsProvider.getAllOperatorsDatas(id).then((datas) {
            if (datas != null) {
              setState(() {
                onlineOperators.addAll({
                  'operator_${i + 1}': datas['data'],
                });
              });
            } else {
              print(
                  "Erreur de récupération des données de l'operateur en arrère plan");
            }
          });
        }
      } else {
        print(
            "Erreur de récupération des données des operateurs en arrère plan");
      }
    });
  }

  //Méthode permettant de récupérer toutes les données de l'opérateur en cours en local
  void getLocalCurrentOperatorDatasById(int id) {
    for (int i = 1; i <= localOperators.length; i++) {
      if (localOperators['operator_$i']['operator']['id'] == id) {
        constructOperatorCategories(
            localOperators['operator_$id']['categories']);
      }
    }
  }

  //Méthode permettant d'enrégistrer tous les opérateurs et leurs données dans le fichier local json
  void saveOperatorsInLocal() {
    //jsonStore.clearDataBase();
    jsonStore.setItem('localOperators', onlineOperators);
    print("Saved in local");
  }
  //=================================================================

  Widget searchResultContent() {
    return Container(
      height: context.screenHeight - 100,
      width: context.screenWidth,
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      color: Colors.white,
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
                                      color: Colors.black,
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
                                      color: Colors.white,
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
    for (int i = 0; i < categories[currentCategoryIndex].codes.length; i++) {
      dynamic code = categories[currentCategoryIndex].codes[i];
      print(code);
      if ((code['name'].toLowerCase()).indexOf(value.toLowerCase()) != -1) {
        searchResultList.insert(0, code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //Save operators on json file when all datas get
    if (operators.length == onlineOperators.length) {
      saveOperatorsInLocal();
    }
    //print(currentCode.children[0].id);
    Functions.setStatuBarColor();

    return WillPopScope(
      onWillPop: () async {
        if (!searchMode && !more && !about && !notification && !whatNew) {
          return true;
        } else {
          setState(() {
            searchMode = false;
            more = false;
            about = false;
            notification = false;
            whatNew = false;
          });
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 0,
            elevation: 0,
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent),
        body: operatorDatasLoading
            ? OperatorLoadingShimmer()
            : Container(
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: searchMode ? 0 : 1,
                      duration: Duration(milliseconds: 500),
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 20, left: 18, right: 18),
                                  height: 165,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.black.withOpacity(0.1),
                                          width: 1),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            spreadRadius: 1,
                                            blurRadius: 1),
                                      ]),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 12),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        hoverColor:
                                                            Colors.transparent,
                                                        splashColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () {
                                                          //jsonStore.deleteItem(
                                                          //'localOperators');
                                                          //setState(() {});
                                                        },
                                                        child: Image.asset(
                                                          'assets/images/logo.png',
                                                          width: 40,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 14,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('MYSHARP’S',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily: Fonts
                                                                    .fontMedium,
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    3,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          height: 1.86,
                                                        ),
                                                        Text('CAMEROON',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.25),
                                                                fontFamily: Fonts
                                                                    .fontMedium,
                                                                fontSize: 11,
                                                                letterSpacing:
                                                                    2.4,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )),
                                              SizedBox(
                                                width: 69,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Expanded(
                                          child: Container(
                                              child: Container(
                                            width: context.screenWidth,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: Center(
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemCount: operators.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return OperatorButton(
                                                      operatorModel:
                                                          operators[index],
                                                      onTap: () {
                                                        getActiveOperator(
                                                            operators[index]
                                                                .id);
                                                      },
                                                    );
                                                  }),
                                            ),
                                          )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                //TabBar of categories
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Expanded(
                                                child: DefaultTabController(
                                                    length: categories.length,
                                                    // length of tabs
                                                    initialIndex:
                                                        currentCategoryIndex,
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: <Widget>[
                                                          Container(
                                                            child: TabBar(
                                                              onTap: (index) {
                                                                getActiveCategory(
                                                                    index);
                                                              },
                                                              controller:
                                                                  _categoriesController,
                                                              isScrollable:
                                                                  true,
                                                              indicatorColor:
                                                                  Colors.black,
                                                              indicatorWeight:
                                                                  1.5,
                                                              labelColor:
                                                                  Colors.black,
                                                              unselectedLabelColor:
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          0.25),
                                                              labelStyle: TextStyle(
                                                                  fontFamily: Fonts
                                                                      .fontMedium,
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      -0.36,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              tabs:
                                                                  tabBarCategories,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            15),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .transparent,
                                                                    border: Border(
                                                                        top: BorderSide(
                                                                            color:
                                                                                greyColor,
                                                                            width:
                                                                                0.5))),
                                                                child: TabBarView(
                                                                    controller:
                                                                        _categoriesController,
                                                                    children:
                                                                        tabBarViewCategories)),
                                                          )
                                                        ])),
                                              ),
                                            ]),
                                      ),
                                      /* AnimatedPositioned(
                                        top: openCodeChildren
                                            ? 50
                                            : context.screenHeight,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.decelerate,
                                        child: AnimatedOpacity(
                                          opacity: openCodeChildren ? 1 : 0,
                                          duration: Duration(milliseconds: 600),
                                          child: Container(
                                            width: context.screenWidth,
                                            height: context.screenHeight,
                                            color: Colors.white,
                                            padding: EdgeInsets.only(
                                                left: 21, right: 21),
                                            child: Column(
                                              children: [
                                                Codes(
                                                    codeModel: currentCode,
                                                    onTap: () {
                                                      setState(() {
                                                        openCodeChildren = false;
                                                      });
                                                    }),
                                                Expanded(
                                                  child: ListView.builder(
                                                      itemCount: currentCode
                                                          .children.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        CodeModel code =
                                                            CodeModel.fromJson({
                                                          'id': currentCode
                                                              .children[index].id,
                                                          'name': currentCode
                                                              .children[index]
                                                              .name,
                                                          'description':
                                                              currentCode
                                                                  .children[index]
                                                                  .description,
                                                          'photo': currentCode
                                                              .children[index]
                                                              .photo,
                                                          'state': currentCode
                                                              .children[index]
                                                              .state,
                                                          'color': currentCode
                                                              .children[index]
                                                              .color,
                                                          'inputs': currentCode
                                                              .children[index]
                                                              .inputs,
                                                          'format': currentCode
                                                              .children[index]
                                                              .format,
                                                          'type': currentCode
                                                              .children[index]
                                                              .type,
                                                          'level': currentCode
                                                              .children[index]
                                                              .level,
                                                          'ussd_code': currentCode
                                                              .children[index]
                                                              .ussd_code,
                                                          'isActive': false,
                                                          'children': []
                                                        });
                                                        code.children =
                                                            getChildrenOfCode(
                                                                currentCode
                                                                    .children[
                                                                        index]
                                                                    .children);
                                                        return Codes(
                                                          codeModel: code,
                                                          onTap: () {
                                                            setState(() {
                                                              currentCode = code;
                                                            });
                                                          },
                                                        );
                                                      }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    */
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (more ||
                              whatNew ||
                              notification ||
                              about ||
                              enablePackage)
                            Positioned.fill(
                              child: AnimatedOpacity(
                                opacity: (more ||
                                        whatNew ||
                                        notification ||
                                        about ||
                                        enablePackage)
                                    ? 1
                                    : 0,
                                duration: Duration(milliseconds: 2000),
                                curve: Curves.decelerate,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        more = false;
                                        notification = false;
                                        whatNew = false;
                                        about = false;
                                        enablePackage = false;
                                      });
                                    },
                                    child: Center(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 8.0,
                                          sigmaY: 8.0,
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
                            right: 17,
                            top: more ? 105 : 180,
                            child: IgnorePointer(
                              ignoring: false,
                              child: AnimatedOpacity(
                                opacity: more ? 1 : 0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.decelerate,
                                child: IgnorePointer(
                                  ignoring: more ? false : true,
                                  child: Container(
                                    width: 272,
                                    height: 275,
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
                                      children: [
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            hoverColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              setState(() {
                                                notification = true;
                                                more = false;
                                              });
                                            },
                                            child: MenuOption(
                                                optionIcon:
                                                    'assets/images/notification-icon.png',
                                                optionLabel: 'Notifications'),
                                          ),
                                        ),
                                        SizedBox(height: 35),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            hoverColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              setState(() {
                                                whatNew = true;
                                                more = false;
                                              });
                                            },
                                            child: MenuOption(
                                                optionIcon:
                                                    'assets/images/star-icon.png',
                                                optionLabel: 'What’s new'),
                                          ),
                                        ),
                                        SizedBox(height: 35),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            hoverColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              setState(() {
                                                about = true;
                                                more = false;
                                              });
                                            },
                                            child: MenuOption(
                                                optionIcon:
                                                    'assets/images/information-icon.png',
                                                optionLabel: 'About'),
                                          ),
                                        ),
                                        SizedBox(height: 40),
                                        Container(
                                          width: 272,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('MySharp’s v0.1.0',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          Fonts.fontMedium,
                                                      fontSize: 16,
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 5),
                                              Text('Powered by TheBrains',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          Fonts.fontLight,
                                                      fontSize: 12,
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          EnablePackage(
                              position: enablePackage
                                  ? context.screenHeight / 2
                                  : context.screenHeight),
                          IgnorePointer(
                            child: OverflowBox(
                              maxWidth: context.screenWidth,
                              maxHeight: context.screenHeight,
                              alignment: Alignment.center,
                              child: Container(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        more = !more;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      margin: EdgeInsets.only(
                                          left: context.screenWidth - 98,
                                          bottom: context.screenHeight - 140),
                                      curve: Curves.decelerate,
                                      duration: Duration(
                                          milliseconds: !about ? 700 : 200),
                                      width: more ? 52 : 0,
                                      height: more ? 52 : 0,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                spreadRadius: 3,
                                                blurRadius: 3),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (!notification && !about && !enablePackage)
                            Positioned(
                              top: 45,
                              right: 36.8,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      more = !more;
                                    });
                                  },
                                  child: Image.asset(
                                    'assets/images/more-icon.png',
                                    width: 25,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 600),
                            top: 32,
                            right: searchMode ? 30 : 60,
                            left: searchMode ? 30 : context.screenWidth - 125,
                            curve: Curves.decelerate,
                            child: AnimatedOpacity(
                              opacity: more ? 0 : 1,
                              duration: Duration(milliseconds: 600),
                              child: Container(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                width:
                                    searchMode ? context.screenWidth - 45 : 75,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: !searchMode
                                        ? []
                                        : [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
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
                                        onChanged: (value) {
                                          searchCodeInList(value);
                                        },
                                        focusNode: searchFocus,
                                        style: TextStyle(
                                            fontFamily: Fonts.fontRegular,
                                            fontSize: 16,
                                            color: Colors.black,
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
                                      )),
                                    if (!notification &&
                                        !about &&
                                        !enablePackage)
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
                                            'assets/images/search-icon.png',
                                            width: 25,
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
                    AnimatedPositioned(
                      top: whatNew ? 20 : context.screenHeight,
                      left: 0,
                      right: 0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate,
                      child: Container(
                        height: context.screenHeight - 60,
                        width: context.screenWidth,
                        margin:
                            EdgeInsets.only(left: 28, right: 28, bottom: 15),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  spreadRadius: 2.5,
                                  blurRadius: 3),
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('What’s new',
                                      style: TextStyle(
                                          fontFamily: Fonts.fontMedium,
                                          fontSize: 16,
                                          color: greenColor,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text(
                                      'All the news of the application updates',
                                      style: TextStyle(
                                          fontFamily: Fonts.fontRegular,
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.3),
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 30),
                                  Text('v1.0.0',
                                      style: TextStyle(
                                          fontFamily: Fonts.fontMedium,
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(height: 8),
                                  Text(
                                      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.',
                                      style: TextStyle(
                                          height: 2,
                                          fontFamily: Fonts.fontMedium,
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
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
                                        setState(() {
                                          whatNew = false;
                                        });
                                      },
                                      child: Text('Fermer',
                                          style: TextStyle(
                                              fontFamily: Fonts.fontMedium,
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //Notification Container
                    AnimatedOpacity(
                      opacity: notification ? 1 : 0,
                      duration: Duration(milliseconds: notification ? 800 : 0),
                      curve: Curves.decelerate,
                      child: IgnorePointer(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 25, right: 25, bottom: 15, top: 20),
                          height: context.screenHeight,
                          child: Stack(
                            children: [
                              Positioned(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Notifications',
                                        style: TextStyle(
                                            fontFamily: Fonts.fontMedium,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                    Container(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          hoverColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            setState(() {
                                              notification = false;
                                            });
                                          },
                                          child: Text('Fermer',
                                              style: TextStyle(
                                                  fontFamily: Fonts.fontMedium,
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      top: notification ? 50 : context.screenHeight,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate,
                      child: Container(
                        height: context.screenHeight - 120,
                        width: context.screenWidth,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: 1000,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    dynamic notification = NotificationTemplate(
                                        notificationTitle: 'Lorem impsum',
                                        notificationSubtitle:
                                            'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonu',
                                        notificationTime: '12:30');
                                    return notification;
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      bottom: notification ? 15 : -10,
                      left: 0,
                      right: 0,
                      duration: Duration(milliseconds: 800),
                      curve: Curves.decelerate,
                      child: AnimatedOpacity(
                        opacity: notification ? 1 : 0,
                        duration:
                            Duration(milliseconds: notification ? 800 : 0),
                        curve: Curves.decelerate,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {},
                                child: Text('Voir plus de notifications',
                                    style: TextStyle(
                                        fontFamily: Fonts.fontRegular,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: about ? 1 : 0,
                      duration: Duration(milliseconds: about ? 800 : 0),
                      curve: Curves.decelerate,
                      child: IgnorePointer(
                        ignoring: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 150,
                            ),
                            SizedBox(height: 38),
                            Text('MYSHARP’S',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: Fonts.fontMedium,
                                    fontSize: 18,
                                    letterSpacing: 5,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            Text('V1.0.0',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: Fonts.fontMedium,
                                    fontSize: 10,
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 45),
                            Text('Powered by',
                                style: TextStyle(
                                    fontFamily: Fonts.fontLight,
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.4),
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            Text('TheBrains',
                                style: TextStyle(
                                    fontFamily: Fonts.fontLight,
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.4),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      top: whatNew ? 20 : context.screenHeight,
                      left: 0,
                      right: 0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate,
                      child: Container(
                        height: context.screenHeight - 60,
                        width: context.screenWidth,
                        margin:
                            EdgeInsets.only(left: 28, right: 28, bottom: 15),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  spreadRadius: 2.5,
                                  blurRadius: 3),
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('What’s new',
                                      style: TextStyle(
                                          fontFamily: Fonts.fontMedium,
                                          fontSize: 16,
                                          color: greenColor,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text(
                                      'All the news of the application updates',
                                      style: TextStyle(
                                          fontFamily: Fonts.fontRegular,
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.3),
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 30),
                                  Text('v1.0.0',
                                      style: TextStyle(
                                          fontFamily: Fonts.fontMedium,
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(height: 8),
                                  Text(
                                      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.',
                                      style: TextStyle(
                                          height: 2,
                                          fontFamily: Fonts.fontMedium,
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
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
                                        setState(() {
                                          whatNew = false;
                                        });
                                      },
                                      child: Text('Fermer',
                                          style: TextStyle(
                                              fontFamily: Fonts.fontMedium,
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
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
                              color: Colors.white,
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
                                          color: Colors.black.withOpacity(0.3),
                                          fontFamily: Fonts.fontMedium,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
