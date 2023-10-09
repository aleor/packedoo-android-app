import 'package:flutter/material.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/navigation.dart';

class ViewLotIconButton extends StatefulWidget {
  final String lotId;
  final String userId;
  final bool actionsEnabled;

  const ViewLotIconButton(
      {Key key,
      @required this.lotId,
      @required this.userId,
      this.actionsEnabled = false})
      : super(key: key);

  @override
  _ViewLotIconButtonState createState() => _ViewLotIconButtonState();
}

class _ViewLotIconButtonState extends State<ViewLotIconButton> {
  final AuthService _authService = authService;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Colors.black54,
          ),
          onPressed: _viewLot,
        ),
      ),
    );
  }

  _viewLot() {
    final _isMy = _authService.currentUserId == widget.userId;

    NavigationService.toLotViewScreen(
        lotId: widget.lotId,
        isMy: _isMy,
        actionsEnabled: widget.actionsEnabled);
  }
}
