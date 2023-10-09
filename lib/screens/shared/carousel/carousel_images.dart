import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:packedoo_app_material/models/photo.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:quiver/strings.dart';

class CarouselImages {
  static double _defaultHeight = 150;

  static get({List<Photo> photos, double height}) {
    var _items = List<Widget>();

    if (photos?.length == 0 ||
        (photos?.length == 1 && isEmpty(photos.first.url))) {
      _items.add(_singlePlaceholder(height));
      return _items;
    }

    if (photos?.length == 1) {
      _items.add(_singleImage(photos.first.url, height));
      return _items;
    }

    photos.forEach((p) => {
          _items.add(_singleImage(p.url, height)),
        });

    return _items;
  }

  static _singlePlaceholder(double height) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Image.asset(
        'assets/images/no_photo_placeholder.png',
        height: height ?? _defaultHeight,
        fit: BoxFit.scaleDown,
      ),
    );
  }

  static _singleImage(String imageUrl, double height) {
    return Container(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, imageUrl) =>
            Center(child: CustomCircularIndicator()),
        fit: BoxFit.fitWidth,
        height: height ?? _defaultHeight,
        width: double.infinity,
      ),
    );
  }
}
