import 'package:flutter/material.dart';
import 'package:mysharps/utils/fonts.dart';

class MenuOption extends StatefulWidget {
  MenuOption({required this.optionIcon, required this.optionLabel});
  String optionIcon;
  String optionLabel;

  @override
  _MenuOptionState createState() => _MenuOptionState();
}

class _MenuOptionState extends State<MenuOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image.asset('${widget.optionIcon}', width: 20),
          SizedBox(
            width: 20,
          ),
          Text('${widget.optionLabel}',
              style: TextStyle(
                  fontFamily: Fonts.fontMedium,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
