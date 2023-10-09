import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/models/packedoo_user.dart';
import 'package:packedoo_app_material/models/user_statistics.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/screens/shared/custom_drawer_widget.dart';
import 'package:packedoo_app_material/screens/shared/side_menu_widget.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/images.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/permissions.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/services/upload.dart';
import 'package:packedoo_app_material/services/users.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ImageService _imageService = imageService;
  UsersService _usersService = usersService;
  PermissionsService _permissionsService = permissionsService;
  UIService _uiService = uiService;
  UploadService _uploadService = uploadService;

  UserStatistics _userStats;
  PackedooUser _user;
  StateWidgetState _state;

  @override
  void initState() {
    _loadUser();
    GoogleAnalytics().setScreen('user_profile');
    super.initState();
  }

  Future _loadUser() async {
    final _userData = await _usersService.getCurrentUser();
    setState(() {
      _user = _userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    _state = StateWidget.of(context);

    if (_user == null) {
      return Scaffold(body: Center(child: CustomCircularIndicator()));
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).profile),
        leading: CustomDrawer(scaffoldKey: _scaffoldKey),
      ),
      drawer: SideMenu(activeItem: MenuItem.Profile),
      body: _profile(),
    );
  }

  Widget _profile() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _mainHeaderRow(),
              _about(),
              Divider(),
              _contacts(),
              Divider(),
              _reviews(),
              Divider(),
              _settings(),
              Divider(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainHeaderRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _editPhoto,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(children: [
                _photo(),
                Container(
                  padding: EdgeInsets.only(top: 80, left: 60),
                  child: Icon(
                    Icons.add_a_photo,
                    size: 24,
                    color: Colors.teal,
                  ),
                ),
              ]),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _name(),
                _rating(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _photo() {
    return Container(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        height: 80,
        width: 80,
        child: _getUserAvatar(),
      ),
    );
  }

  Widget _name() {
    return Container(
      child: Text(
        _user.safeUserName ?? AppLocalizations.of(context).nameNotDefined,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _rating() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: FlutterRatingBarIndicator(
        rating: _user.rating ?? 0,
        itemCount: 5,
        itemSize: 25,
        fillColor: Styles.kGreenColor,
        emptyColor: Colors.grey,
      ),
    );
  }

  Widget _about() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _editAboutMe,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).aboutMyself,
                    style: TextStyle(color: Styles.kGreenColor),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(isEmpty(_user.aboutMe)
                        ? AppLocalizations.of(context).noAdditionalDescription
                        : _user.aboutMe),
                  ),
                ],
              ),
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey[500]),
                onPressed: _editAboutMe,
              )),
        ],
      ),
    );
  }

  Widget _contacts() {
    return Container(
      child: Column(
        children: [
          _phoneRow(),
          _mailRow(),
        ],
      ),
    );
  }

  Widget _phoneRow() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toEditPhoneScreen,
      child: Container(
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.only(top: 8),
            child: Icon(Icons.phone_android),
          ),
          trailing: Icon(Icons.edit, color: Colors.grey[500]),
          title: Text(_user.phoneNumber ??
              AppLocalizations.of(context).phoneNumberNotDefined),
          subtitle: Text(_phoneStatus),
        ),
      ),
    );
  }

  Widget _mailRow() {
    return Container(
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.only(top: 8),
          child: Icon(Icons.mail),
        ),
        title: Text(_user.email),
        subtitle: Text(_mailStatus),
      ),
    );
  }

  Widget _getUserAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: _imageService.getNetworkImageOrPlaceholder(
        imageUrl: _state.state.user.photoUrl ?? '',
        placeholder: 'assets/images/default_user.png',
      ),
    );
  }

  Widget _reviews() {
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _showReviews,
        child: ListTile(
          leading: Icon(Icons.grade),
          title: Text(AppLocalizations.of(context).reviews),
          trailing: Container(
            padding: EdgeInsets.only(right: 10),
            child: _reviewCount(),
          ),
        ),
      ),
    );
  }

  Widget _reviewCount() {
    return FutureBuilder(
      future: _usersService.getUserStats(_user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return Container(
            height: 20,
            width: 20,
            child: CustomCircularIndicator(),
          );
        }

        _userStats = snapshot.data;

        return Text(
          _userStats?.reviewCount?.toString() ?? 0.toString(),
          style: TextStyle(color: Colors.grey, fontSize: 16),
        );
      },
    );
  }

  Widget _settings() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toSettingsScreen,
      child: Container(
        child: ListTile(
          leading: Icon(Icons.settings),
          title: Text(AppLocalizations.of(context).settings),
        ),
      ),
    );
  }

  _editPhoto() {
    showModalBottomSheet(
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

  _makeNewPhoto() async {
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

    final _originalImage = await _imageService.getPhotoFromCamera();
    final _processedImage = await _processImage(_originalImage);
    await _savePhoto(_processedImage);
  }

  _selectFromGallery() async {
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

    final _originalImage = await _imageService.getPhotoFromGallery();
    final _processedImage = await _processImage(_originalImage);
    await _savePhoto(_processedImage);
  }

  Future<File> _processImage(File originalImage) async {
    final croppedImage = await _imageService.cropImage(
      imageFile: originalImage,
      ratioX: 0.5,
      ratioY: 0.5,
    );

    final compressedImage = await _imageService.compressImage(croppedImage);

    return compressedImage;
  }

  _savePhoto(File file) async {
    if (file == null) {
      return;
    }

    _uiService.showActivityIndicator(context);

    try {
      final _photo = await _uploadService.upload(file);
      await _usersService.updatePhoto(_photo.url);
      _state.setPhotoUrl(_photo.url);
    } catch (error) {}

    _uiService.hideActivityIndicator(context, true);
  }

  _showReviews() {
    NavigationService.toReviews(_user.uid);
  }

  _toEditPhoneScreen() {
    NavigationService.toEditPhone(
        phoneNumber: _user.phoneNumber, isVerified: _user.phoneVerified);
  }

  _toSettingsScreen() {
    NavigationService.toSettings();
  }

  _editAboutMe() async {
    bool updated = await NavigationService.toAboutUserInfo(_user.aboutMe);
    if (updated != null && updated) {
      _loadUser();
    }
  }

  String get _phoneStatus => _user.phoneVerified
      ? AppLocalizations.of(context).confirmedM
      : AppLocalizations.of(context).notConfirmedM;

  String get _mailStatus => _user.emailVerified
      ? AppLocalizations.of(context).confirmedM
      : AppLocalizations.of(context).notConfirmedM;
}
