import 'package:flutter/material.dart';
import 'package:mysharps/core/models/category_model.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/fonts.dart';

class CategoryButton extends StatefulWidget {
  CategoryButton({required this.categoryModel, required this.onTap});
  CategoryModel categoryModel;
  void Function() onTap;

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          if (widget.categoryModel.isActive)
            Image.asset(
              'assets/images/menu-icon.png',
              width: 18,
            ),
          SizedBox(
            width: 11,
          ),
          Text('${widget.categoryModel.name}'.toUpperCase(),
              style: TextStyle(
                  color: widget.categoryModel.isActive
                      ? Colors.black
                      : Colors.black.withOpacity(0.25),
                  fontFamily: Fonts.fontMedium,
                  fontSize: 14,
                  letterSpacing: -0.36,
                  fontWeight: FontWeight.bold)),
          if (widget.categoryModel.isNew)
            SizedBox(
              width: 5,
            ),
          if (widget.categoryModel.isNew)
            CircleAvatar(
              backgroundColor: redColor,
              radius: 3,
            )
        ],
      ),
    );
  }
}
