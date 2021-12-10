import 'package:flutter/material.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ContainerTemplate extends StatefulWidget {
  ContainerTemplate(
      {required this.width,
      required this.height,
      required this.radiusbottomLeft,
      required this.radiusbottomRight,
      required this.radiustopLeft,
      required this.radiustopRight,
      required this.color});
  double width;
  double height;
  double radiustopLeft;
  double radiustopRight;
  double radiusbottomLeft;
  double radiusbottomRight;
  Color color;

  @override
  _ContainerTemplateState createState() => _ContainerTemplateState();
}

class _ContainerTemplateState extends State<ContainerTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.radiustopLeft),
              topRight: Radius.circular(widget.radiustopRight),
              bottomLeft: Radius.circular(widget.radiusbottomLeft),
              bottomRight: Radius.circular(widget.radiusbottomRight))),
    );
  }
}
