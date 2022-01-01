import 'package:flutter/material.dart';
import 'package:mysharps/components/container_template.dart';
import 'package:mysharps/utils/colors.dart';
import 'package:mysharps/utils/extensions.dart';
import 'package:mysharps/utils/fonts.dart';
import 'package:shimmer/shimmer.dart';

class OperatorLoadingShimmer extends StatefulWidget {
  @override
  _OperatorLoadingShimmerState createState() => _OperatorLoadingShimmerState();
}

class _OperatorLoadingShimmerState extends State<OperatorLoadingShimmer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      height: context.screenHeight,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            width: context.screenWidth,
            margin: EdgeInsets.only(top: 20, left: 18, right: 18),
            height: 165,
            decoration: BoxDecoration(
              color: Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                  radius: 22,
                                  backgroundColor: greenColor.withOpacity(0.3)),
                              SizedBox(
                                width: 14,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ContainerTemplate(
                                      width: 116,
                                      height: 12,
                                      color: greyColor.withOpacity(0.2),
                                      radiusbottomLeft: 8,
                                      radiusbottomRight: 8,
                                      radiustopLeft: 8,
                                      radiustopRight: 8),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  ContainerTemplate(
                                      width: 90,
                                      height: 12,
                                      color: greyColor.withOpacity(0.2),
                                      radiusbottomLeft: 8,
                                      radiusbottomRight: 8,
                                      radiustopLeft: 8,
                                      radiustopRight: 8),
                                ],
                              )
                            ],
                          ),
                        )),
                        CircleAvatar(
                            radius: 16,
                            backgroundColor: greenColor.withOpacity(0.3)),
                        SizedBox(width: 12),
                        CircleAvatar(
                            radius: 16,
                            backgroundColor: greenColor.withOpacity(0.3))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Container(
                          width: context.screenWidth,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20)),
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        greyColor.withOpacity(0.2)),
                              ),
                              Expanded(
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        greyColor.withOpacity(0.2)),
                              ),
                              Expanded(
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        greyColor.withOpacity(0.2)),
                              ),
                              Expanded(
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        greyColor.withOpacity(0.2)),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
              child: Image.asset('assets/images/loading-img.png', width: 300)),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext, int index) {
                  return Container(
                    width: context.screenWidth,
                    margin: EdgeInsets.only(top: 15, left: 18, right: 18),
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ContainerTemplate(
                              width: context.screenWidth * 0.7,
                              height: 12,
                              radiusbottomLeft: 8,
                              radiusbottomRight: 8,
                              radiustopLeft: 8,
                              radiustopRight: 8,
                              color: greenColor.withOpacity(0.3)),
                          SizedBox(
                            height: 6,
                          ),
                          ContainerTemplate(
                              width: context.screenWidth * 0.4,
                              height: 12,
                              color: greyColor.withOpacity(0.2),
                              radiusbottomLeft: 8,
                              radiusbottomRight: 8,
                              radiustopLeft: 8,
                              radiustopRight: 8),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
