import 'package:flutter/material.dart';
import 'package:mysharps/core/models/operator_model.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/fonts.dart';

class OperatorButton extends StatefulWidget {
  OperatorButton({required this.operatorModel, required this.onTap});
  OperatorModel operatorModel;
  void Function() onTap;
  @override
  _OperatorButtonState createState() => _OperatorButtonState();
}

class _OperatorButtonState extends State<OperatorButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: widget.onTap,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: widget.operatorModel.isActive
                    ? widget.operatorModel.color.withOpacity(0.2)
                    : greyColor.withOpacity(0.2),
                child: Text(
                    '${widget.operatorModel.name[0]}${(widget.operatorModel.name[1]).toLowerCase()}',
                    style: TextStyle(
                        color: ((widget.operatorModel.color == Colors.white) &&
                                (widget.operatorModel.isActive))
                            ? greenColor
                            : widget.operatorModel.isActive
                                ? widget.operatorModel.color
                                : greyColor,
                        fontFamily: Fonts.fontBold,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          if (widget.operatorModel.isActive)
            Container(
              height: 6,
              width: 20,
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: widget.operatorModel.color,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5))),
            )
        ],
      ),
    );
  }
}
