import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/screens/shared/action_progress_bar_widget.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/screens/shared/custom_drawer_widget.dart';
import 'package:packedoo_app_material/screens/shared/side_menu_widget.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/images.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/permissions.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/services/users.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class NewItemFirstScreen extends StatefulWidget {
  @override
  _NewItemFirstScreenState createState() => _NewItemFirstScreenState();
}

class _NewItemFirstScreenState extends State<NewItemFirstScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UsersService _usersService = usersService;
  PermissionsService _permissionsService = permissionsService;
  ImageService _imageService = imageService;
  UIService _uiService = uiService;
  StateWidgetState _state;
  StateModel _stateModel;

  bool _phoneVerified;
  bool _phoneDefined;

  @override
  void initState() {
    GoogleAnalytics().setScreen('new_item_step_1');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _state = StateWidget.of(context);
    _stateModel = _state.state;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).sendPack),
        leading: CustomDrawer(scaffoldKey: _scaffoldKey),
      ),
      bottomNavigationBar: _stateModel.user.phoneVerified != null &&
              _stateModel.user.phoneVerified
          ? _progressBar()
          : null,
      drawer: SideMenu(activeItem: MenuItem.SendNew),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    if (_stateModel.user.phoneVerified != null &&
        _stateModel.user.phoneVerified) {
      return _buildContent();
    }

    if (_phoneVerified == null) {
      _ensurePhoneVerified();

      return Container(
        child: Center(
          child: CustomCircularIndicator(),
        ),
      );
    }

    if (!_phoneVerified) {
      _phoneDefined = isNotEmpty(_stateModel.user.phoneNumber?.trim());

      return _phoneDefined
          ? _phoneConfirmationRequiredBody()
          : _phoneRequiredBody();
    }

    return _buildContent();
  }

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _photo(),
          _addPhotoButton(),
          _hintMessage(),
        ],
      ),
    );
  }

  Widget _phoneConfirmationRequiredBody() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                AppLocalizations.of(context).canCreateOnlyWithConfirmedPhone,
                textAlign: TextAlign.center,
                style: TextStyle(color: Styles.kGreyTextColor),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30),
              child: RaisedButton(
                color: Styles.kGreenColor,
                child: Text(
                  AppLocalizations.of(context).confirmPhoneNumber,
                  style: Styles.kButtonUpperTextStyle,
                ),
                onPressed: _toPhoneConfirmation,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _phoneRequiredBody() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                AppLocalizations.of(context).canCreateOnlyWithConfirmedPhone,
                textAlign: TextAlign.center,
                style: TextStyle(color: Styles.kGreyTextColor),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30),
              child: RaisedButton(
                color: Styles.kGreenColor,
                child: Text(
                  AppLocalizations.of(context).addPhoneNumber,
                  style: Styles.kButtonUpperTextStyle,
                ),
                onPressed: _toPhoneAdd,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _progressBar() {
    return ActionProgressBar(
      value: 0.25,
      handler: _toSecondStep,
    );
  }

  Widget _photo() {
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _showActionSheet,
        child: Container(
          child: _stateModel.newPack.picture != null
              ? Image.file(
                  _stateModel.newPack.picture,
                  fit: BoxFit.fitHeight,
                )
              : Icon(
                  Icons.photo_camera,
                  color: Colors.black26,
                  size: 150,
                ),
          height: 250,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _addPhotoButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 30, left: 16, right: 16),
      child: OutlineButton(
        child: Text(
          _buttonText,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Styles.kGreenColor,
              letterSpacing: 0.8),
        ),
        borderSide: BorderSide(color: Styles.kGreenColor),
        onPressed: _showActionSheet,
      ),
    );
  }

  Widget _hintMessage() {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 16, right: 16),
      child: Text(
        AppLocalizations.of(context).goodPhotoHint,
        style: TextStyle(color: Styles.kGreyTextColor),
      ),
    );
  }

  String get _buttonText => _stateModel.newPack.picture != null
      ? AppLocalizations.of(context).changePhoto
      : AppLocalizations.of(context).addPhoto;

  void _ensurePhoneVerified() async {
    final _isPhoneVerified = await _usersService.isPhoneVerified();
    final _phoneNumber = await _usersService.getPhoneNumber();

    setState(() {
      _phoneVerified = _isPhoneVerified;
      _phoneDefined = isNotEmpty(_phoneNumber);
    });
  }

  Future _showActionSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 120,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text(AppLocalizations.of(context).makeNewPhoto),
                  onTap: () {
                    Navigator.of(context).pop();
                    _makeNewPhoto();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text(AppLocalizations.of(context).selectFromGallery),
                  onTap: () {
                    Navigator.of(context).pop();
                    _selectFromGallery();
                  },
                ),
              ],
            ));
      },
    );
  }

  Future _makeNewPhoto() async {
    if (!await _permissionsService.checkAndRequestCameraPermissions()) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).noCameraPermissions,
        AppLocalizations.of(context).cameraAccessRequired,
        actionText: AppLocalizations.of(context).toSettings,
      );

      await _permissionsService.openAppSettings();

      return;
    }

    final originalImage = await _imageService.getPhotoFromCamera();

    final procesedImage =
        await _imageService.cropAndCompressImage(originalImage);

    setState(() {
      _stateModel.newPack.picture = procesedImage;
    });
  }

  void _selectFromGallery() async {
    if (!await _permissionsService.checkAndRequestGalleryPermissions()) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).noGalleryPermissions,
        AppLocalizations.of(context).galleryAccessRequired,
        actionText: AppLocalizations.of(context).toSettings,
      );

      await _permissionsService.openAppSettings();

      return;
    }

    final originalImage = await _imageService.getPhotoFromGallery();

    final processedImage =
        await _imageService.cropAndCompressImage(originalImage);

    setState(() {
      _stateModel.newPack.picture = processedImage;
    });
  }

  void _toPhoneConfirmation() {
    NavigationService.toConfirmPhone();
  }

  void _toPhoneAdd() {
    NavigationService.toAddPhone();
  }

  void _toSecondStep() {
    NavigationService.toNewItemSecondStep();
  }
}
