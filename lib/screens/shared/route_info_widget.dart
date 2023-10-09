import 'package:flutter/material.dart';
import 'package:packedoo_app_material/models/base_pack_info.dart';
import 'package:packedoo_app_material/styles.dart';

class RouteInfo extends StatelessWidget {
  final BasePackInfo lot;

  const RouteInfo({Key key, this.lot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildLeftColumn(),
          _buildMainColumn(),
        ],
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Container(
      padding: EdgeInsets.only(right: 18),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 18),
            child: Image.asset(
              'assets/images/red_circle.png',
              width: 35,
              height: 35,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 25),
            child: Image.asset(
              'assets/images/blue_circle.png',
              width: 35,
              height: 35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16),
            child: Text(lot.origin.city, style: TextStyle(fontSize: 16)),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              lot.origin.street ?? lot.origin.description,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Styles.kGreyTextColor),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text(lot.destination.city, style: TextStyle(fontSize: 16)),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              lot.destination.street ?? lot.destination.description,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Styles.kGreyTextColor),
            ),
          )
        ],
      ),
    );
  }
}
