import 'package:flutter/cupertino.dart';

class CodeModel {
  CodeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.state,
    required this.color,
    required this.type,
    required this.children,
    required this.format,
    required this.inputs,
    required this.isActive,
    required this.level,
    required this.ussd_code,
  });

  int id;
  String name;
  String description;
  String? photo;
  String inputs;
  String format;
  String type;
  int level;
  String ussd_code;
  List<dynamic> children;
  int state;
  Color color;
  bool isActive;

  CodeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        photo = json['photo'],
        state = json['state'],
        color = json['color'],
        inputs = json['inputs'],
        format = json['format'],
        type = json['type'],
        level = json['level'],
        ussd_code = json['ussd_code'],
        children = json['children'],
        isActive = json['isActive'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'photo': photo,
        'state': state,
        'color': color,
        'inputs': inputs,
        'format': format,
        'type': type,
        'level': level,
        'ussd_code': ussd_code,
        'children': children,
        'isActive': isActive,
      };
}
