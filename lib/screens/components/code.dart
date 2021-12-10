import 'package:flutter/material.dart';
import 'package:mysharps/core/models/code_model.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/fonts.dart';
import 'package:mysharps/utils/extensions.dart';

class Codes extends StatefulWidget {
  Codes({required this.codeModel});
  CodeModel codeModel;

  @override
  _CodesState createState() => _CodesState();
}

class _CodesState extends State<Codes> {
  late List<Widget> children;
  late Column childrenList;
  @override
  void initState() {
    super.initState();
    children = [];
    setState(() {
      for (int i = 0; i < widget.codeModel.children.length; i++) {
        children.insert(i, Codes(codeModel: widget.codeModel.children[i]));
      }
    });
    childrenList = new Column(
      children: children,
    );
  }

  void test() {}

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            if (widget.codeModel.isActive) {
              widget.codeModel.isActive = false;
            } else {
              widget.codeModel.isActive = true;
            }
          });
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 18),
          width: context.screenWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.codeModel.level == 1)
                Container(
                  height: 70,
                  width: 8,
                  decoration: BoxDecoration(
                      color: widget.codeModel.color,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4))),
                ),
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  height: widget.codeModel.isActive
                      ? (double.parse(
                          (90 * widget.codeModel.children.length).toString()))
                      : 70,
                  decoration: BoxDecoration(
                      color: widget.codeModel.level == 1
                          ? widget.codeModel.color.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(7)),
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text('${widget.codeModel.name}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: widget.codeModel.color,
                                            fontFamily: Fonts.fontRegular,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.chevron_right,
                                    color: widget.codeModel.color,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('${widget.codeModel.description}',
                                style: TextStyle(
                                    color: Color(0xFF95989A),
                                    fontFamily: Fonts.fontMedium,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      /*if (widget.codeModel.isActive)
                        Expanded(child: childrenList)*/
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
