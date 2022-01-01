import 'package:flutter/material.dart';
import 'package:mysharps/core/models/category_model.dart';
import 'package:mysharps/core/models/code_model.dart';
import 'package:mysharps/screens/components/code.dart';
import 'package:mysharps/utils/functions.dart';

class CodeList extends StatefulWidget {
  CodeList({required this.category});
  CategoryModel category;
  

  @override
  _CodeListState createState() => _CodeListState();
}

class _CodeListState extends State<CodeList> {
  List<CodeModel> getListCode(dynamic children) {
    List<CodeModel> listCode = [];
    for (int i = 0; i < children.length; i++) {
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
        'children': []
      });
      code.children = children[i]['children'].length != 0
          ? getListCode(children[i]['children'])
          : [];

      listCode.insert(i, code);
    }
    return listCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.only(left: 21, right: 21),
          itemCount: widget.category.codes.length,
          itemBuilder: (BuildContext context, int index) {
            CodeModel code = CodeModel.fromJson({
              'id': widget.category.codes[index]['id'],
              'name': widget.category.codes[index]['name'],
              'description': widget.category.codes[index]['description'],
              'photo': widget.category.codes[index]['photo'],
              'state': widget.category.codes[index]['state'],
              'color':
                  Functions.getColorCode(widget.category.codes[index]['color']),
              'inputs': widget.category.codes[index]['inputs'],
              'format': widget.category.codes[index]['format'],
              'type': widget.category.codes[index]['type'],
              'level': widget.category.codes[index]['level'],
              'ussd_code': widget.category.codes[index]['ussd_code'],
              'isActive': false,
              'children': []
            });
            code.children =
                getListCode(widget.category.codes[index]['children']);

            return Codes(
              codeModel: code,
              onTap: () {
                print("Je suis ici");
              },
            );
          }),
    );
  }
}
