import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';

class FullPagePhoto extends StatelessWidget {
  final String imageUrl;
  final String title;

  const FullPagePhoto({@required this.imageUrl, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
            child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, imageUrl) => CustomCircularIndicator(),
        )),
      ),
    );
  }
}
