import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {
  // static const Color kGreenColor = Color(0xff008c94);
  static const Color kGreenColor = Color(0xff50bbc3);
  static const Color kLightGreenColor = Color(0xff00bdc4);
  static const Color kGreyTextColor = Color(0xff4a4a4a);
  static const BoxDecoration kNoBordersDecoration = BoxDecoration(
    border: Border(
      top: BorderSide.none,
      left: BorderSide.none,
      right: BorderSide.none,
      bottom: BorderSide.none,
    ),
  );

  static const TextStyle kButtonUpperTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.8,
  );

  static const TextStyle kDealActionSubTextStyle = TextStyle(
    color: Styles.kGreyTextColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static Widget kRowDivider = Container(
    height: 1,
    color: CupertinoColors.lightBackgroundGray,
  );

  static const Color kBlackWithOpacityTextColor = Color(0xc0000000);

  static const kProgressBarBgColor = Color(0xffcde7e5);
  static const kProgressBarLineColor = Color(0xff009688);
}
