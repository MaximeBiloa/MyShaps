import 'package:flutter/material.dart';
import 'package:mysharps/data/variables.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/fonts.dart';

class NotificationTemplate extends StatefulWidget {
  NotificationTemplate(
      {required this.notificationTitle,
      required this.notificationSubtitle,
      required this.notificationTime});
  String notificationTitle;
  String notificationSubtitle;
  String notificationTime;
  @override
  _NotificationTemplateState createState() => _NotificationTemplateState();
}

class _NotificationTemplateState extends State<NotificationTemplate> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {},
        child: Container(
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          decoration: BoxDecoration(
              color: themeMode ? darkModeColorPrimary : Colors.white,
              borderRadius: BorderRadius.circular(10),
              //border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
              boxShadow: themeMode
                  ? []
                  : [
                      BoxShadow(
                          offset: Offset(0, 2),
                          color: Colors.grey.shade200,
                          spreadRadius: 1,
                          blurRadius: 1),
                    ]),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: themeMode
                    ? darkModeColorSecondary.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${widget.notificationTitle}',
                            style: TextStyle(
                                fontFamily: Fonts.fontRegular,
                                fontSize: 13,
                                color: themeMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w700)),
                        Text('${widget.notificationTime}',
                            style: TextStyle(
                                fontFamily: Fonts.fontRegular,
                                fontSize: 11,
                                color: themeMode
                                    ? Colors.grey.shade400
                                    : Colors.black.withOpacity(0.4),
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Text('${widget.notificationSubtitle}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: Fonts.fontRegular,
                          fontSize: 12,
                          color: themeMode
                              ? Colors.grey.shade500
                              : Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
