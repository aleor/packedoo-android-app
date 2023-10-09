import 'package:flutter/material.dart';
import 'package:packedoo_app_material/models/photo.dart';
import 'package:packedoo_app_material/services/images.dart';

class CardPhotoColumn extends StatefulWidget {
  final List<Photo> photos;

  const CardPhotoColumn({Key key, this.photos}) : super(key: key);

  @override
  _CardPhotoColumnState createState() => _CardPhotoColumnState();
}

class _CardPhotoColumnState extends State<CardPhotoColumn> {
  final ImageService _imageService = imageService;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(4)),
          child: Container(
            child: _imageService.getThumbnailOrFirstImage(widget.photos),
          ),
        ),
      ],
    );
  }
}
