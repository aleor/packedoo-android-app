import 'package:flutter/material.dart';
import 'package:packedoo_app_material/styles.dart';

class PageIndicator extends StatefulWidget {
  final int max;
  final int current;

  PageIndicator({this.max, this.current});

  @override
  State createState() => PageIndicatorState();
}

class PageIndicatorState extends State<PageIndicator> {
  final double indicatorSize = 7.0;
  final double indicatorMargin = 5.0;
  final Color indicatorInactiveBackground = Colors.grey;
  final Color indicatorActiveBackground = Styles.kGreenColor;

  @override
  Widget build(BuildContext context) {
    if (widget.max <= 1) return Container();

    List<Widget> indicators = [];

    for (int i = 0; i < widget.max; i++) {
      indicators.add(Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
              color: widget.current == i
                  ? indicatorActiveBackground
                  : indicatorInactiveBackground,
              shape: BoxShape.circle),
          margin: EdgeInsets.symmetric(horizontal: indicatorMargin)));
    }

    return Container(
      height: 15.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: indicators,
      ),
    );
  }
}
