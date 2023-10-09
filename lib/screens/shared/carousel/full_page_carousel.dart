import 'package:flutter/material.dart';
import 'package:packedoo_app_material/models/photo.dart';
import 'package:packedoo_app_material/screens/shared/carousel/carousel_widget.dart';

class FullPageCarousel extends StatelessWidget {
  final String title;
  final List<Photo> carouselItems;
  final int startPageIndex;

  const FullPageCarousel({this.title, this.carouselItems, this.startPageIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pop(context);
            },
            child: Carousel(
              children: this.carouselItems,
              title: title,
              fullScreenMode: true,
              startPageIndex: startPageIndex,
            )),
      ),
    );
  }
}
