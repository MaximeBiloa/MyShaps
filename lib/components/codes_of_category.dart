import 'package:flutter/material.dart';
import 'package:mysharps/components/code.dart';
import 'package:mysharps/core/models/category_model.dart';
import 'package:mysharps/core/models/code_model.dart';
import 'package:mysharps/screens/code_screen.dart';
import 'package:mysharps/utils/functions.dart';

class CodeOfCategory extends StatefulWidget {
  CodeOfCategory({required this.category});
  CategoryModel category;
  @override
  _CodeOfCategoryState createState() => _CodeOfCategoryState();
}

class _CodeOfCategoryState extends State<CodeOfCategory> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
            'children': widget.category.codes[index]['children']
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
}
