//import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json_store/json_store.dart';
import 'package:mysharps/core/models/category_model.dart';
import 'package:mysharps/core/models/code_model.dart';
import 'package:mysharps/core/providers/categories_provider.dart';
import 'package:mysharps/core/providers/operators_provider.dart';
import 'package:mysharps/screens/components/category_button.dart';
import 'package:mysharps/screens/components/category_empty.dart';
import 'package:mysharps/screens/components/code.dart';
import 'package:mysharps/screens/components/code_list.dart';
import 'package:mysharps/screens/components/menu_option.dart';
import 'package:mysharps/screens/components/operator_button.dart';
import 'package:mysharps/screens/components/notification_template.dart';
import 'package:mysharps/screens/components/operator_loading_shimmer.dart';
import 'package:mysharps/screens/data/variables.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/fonts.dart';
import 'package:mysharps/utils/extensions.dart';
import 'package:mysharps/utils/functions.dart';

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
  //=======================================

  //PROVIDERS
  late CategoriesProvider categoriesProvider;
  late OperatorsProvider operatorsProvider;

  //CONTROLLERS
  late TabController _categoriesController;
  int currentCategoryIndex = 0;
  int currentOperatorIndex = 0;

  late TextEditingController searchValue;
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
              /*child: CategoryButton(
                categoryModel: category,
                onTap: () {
                  print("Category id : ${category.id}");
                },
              ),*/
            ));

        //CONSTRUCTION OF ALL CODE OF CATEGORIES
        if (category.codes.length != 0) {
          tabBarViewCategories.insert(i, CodeList(category: category));
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

  @override
  Widget build(BuildContext context) {
    //Save operators on json file when all datas get
    if (operators.length == onlineOperators.length) {
      saveOperatorsInLocal();
    }

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
            : Stack(
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
                                                        jsonStore.deleteItem(
                                                            'localOperators');
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
                                                              color:
                                                                  Colors.black,
                                                              fontFamily: Fonts
                                                                  .fontMedium,
                                                              fontSize: 14,
                                                              letterSpacing: 3,
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
                                                          operators[index].id);
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
                                child: Container(
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
                                                        isScrollable: true,
                                                        indicatorColor:
                                                            Colors.black,
                                                        indicatorWeight: 1.5,
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
                                                        tabs: tabBarCategories,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20),
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
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [],
                                  ),
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
                                                    fontFamily: Fonts.fontLight,
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
                          right: searchMode ? 30 : 70,
                          left: searchMode ? 30 : context.screenWidth - 140,
                          curve: Curves.decelerate,
                          child: AnimatedOpacity(
                            opacity: more ? 0 : 1,
                            duration: Duration(milliseconds: 600),
                            child: Container(
                              padding: EdgeInsets.only(right: 20, left: 20),
                              width: searchMode ? context.screenWidth - 45 : 75,
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
                                  if (!notification && !about && !enablePackage)
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
                      margin: EdgeInsets.only(left: 28, right: 28, bottom: 15),
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
                                Text('All the news of the application updates',
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
                                itemBuilder: (BuildContext context, int index) {
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
                      duration: Duration(milliseconds: notification ? 800 : 0),
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
                  /* AnimatedPositioned(
              top: enablePackage
                  ? context.screenHeight * 0.5 - 75.2
                  : context.screenHeight,
              left: 0,
              right: 0,
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate,
              child: Container(
                height: 155,
                width: context.screenWidth,
                margin: EdgeInsets.only(left: 28, right: 28, bottom: 15),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 2.5,
                          offset: Offset(2, 0),
                          blurRadius: 3),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Activation',
                        style: TextStyle(
                            fontFamily: Fonts.fontMedium,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Are you sure you want to activate this code?',
                        style: TextStyle(
                            fontFamily: Fonts.fontRegular,
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.3),
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 30),
                    Row(
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
                                enablePackage = false;
                              });
                            },
                            child: Text('Non',
                                style: TextStyle(
                                    fontFamily: Fonts.fontMedium,
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(0.6),
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        Container(
                            height: 15,
                            width: 2,
                            margin: EdgeInsets.symmetric(horizontal: 22),
                            color: Colors.black.withOpacity(0.1)),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                enablePackage = false;
                              });
                            },
                            child: Text('Oui, je veux',
                                style: TextStyle(
                                    fontFamily: Fonts.fontRegular,
                                    fontSize: 15,
                                    color: greenColor,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          */
                ],
              ),
      ),
    );
  }
}
