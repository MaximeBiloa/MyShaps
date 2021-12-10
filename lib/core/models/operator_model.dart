import 'package:flutter/cupertino.dart';

class OperatorModel {
  OperatorModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.state,
    required this.logo,
    required this.color,
    required this.slogan,
    required this.isActive,
  });

  int id;
  String name;
  String description;
  String? photo;
  int state;
  String slogan;
  String logo;
  Color color;
  bool isActive;

  OperatorModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        photo = json['photo'],
        state = json['state'],
        slogan = json['slogan'],
        logo = json['logo'],
        color = json['color'],
        isActive = json['isActive'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'descritpion': description,
        'photo': photo,
        'state': state,
        'slogan': slogan,
        'logo': logo,
        'color': color,
        'isActive': isActive,
      };
}
