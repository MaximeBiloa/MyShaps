import 'package:flutter/material.dart';
import 'package:mysharps/utils/fonts.dart';

class CategoryEmpty extends StatefulWidget {
  @override
  _CategoryEmptyState createState() => _CategoryEmptyState();
}

class _CategoryEmptyState extends State<CategoryEmpty> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 50, right: 50, bottom: 30),
        children: [
          Image.asset('assets/images/code-empty-img.png', width: 240),
          SizedBox(height: 20),
          Text('Ooops !',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: Fonts.fontBold,
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Il n’y a rien ici pour le moment',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: Fonts.fontRegular,
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.w600)),
        ],
      ),
    ));
  }
}
