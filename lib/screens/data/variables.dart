//Liste des options du menu du Tab
import 'package:flutter/material.dart';
import 'package:mysharps/core/models/category_model.dart';
import 'package:mysharps/core/models/operator_model.dart';

List<dynamic> tabOptions = [
  {
    'menuIcon': 'assets/images/menu-icon.png',
    'menuState': true,
    'menuTitle': 'ALL',
    'isNew': false,
  },
  {
    'menuIcon': 'assets/images/menu-icon.png',
    'menuState': false,
    'menuTitle': 'NEW',
    'isNew': true,
  },
  {
    'menuIcon': 'assets/images/menu-icon.png',
    'menuState': true,
    'menuTitle': 'LIKED',
    'isNew': false,
  },
  {
    'menuIcon': 'assets/images/menu-icon.png',
    'menuState': false,
    'menuTitle': 'CALL',
    'isNew': false,
  },
  {
    'menuIcon': 'assets/images/menu-icon.png',
    'menuState': false,
    'menuTitle': 'INTERNET',
    'isNew': false,
  },
];

//Categories list
List<CategoryModel> categories = [];

//Countries list
List<Tab> countries = [];

//OPERATORS VARIABLES===================
//Operators list
List<OperatorModel> operators = [];

//Operators list fo choose
List<OperatorModel> operatorsChoose = [];

//Current operator Id
late int operatorId;
//======================================

//TabBar for Categories
List<Tab> tabBarCategories = [];

//TabBarView for Categories
List<Widget> tabBarViewCategories = [];

//TabBarView
List<Widget> tabBarViewOperators = [];

//Local storage of All Operators
Map<String, dynamic> localOperators = {};
