import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packedoo_app_material/models/photo.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';

final imageService = ImageService();

class ImageService {
  Widget getNetworkImageOrPlaceholder(
      {String imageUrl,
      String placeholder = 'assets/images/no_photo_placeholder.png',
      double width = 50,
      double height = 50}) {
    return isNotEmpty(imageUrl)
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, imageUrl) => CustomCircularIndicator(),
            fit: BoxFit.cover,
            width: width,
            height: height,
          )
        : Image.asset(
            placeholder,
            width: width,
            height: height,
          );
  }

  Future<File> cropImage(
      {File imageFile, double ratioX = 1.0, double ratioY = 0.6}) async {
    if (imageFile == null) return null;

    return await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
    );
  }

  Future<File> compressImage(File imageFile) async {
    if (imageFile == null) return null;

    final _tempDir = await _getTempDirectoryPath();
    final _targetPath = '$_tempDir/compressed-${Uuid().v4()}.jpg';

    final _compressedImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      _targetPath,
      quality: 70,
    );

    return _compressedImage;
  }

  Future<File> cropAndCompressImage(File image) async {
    if (image == null) return null;

    final _croppedImage = await cropImage(imageFile: image);

    final _compressedImage = await compressImage(_croppedImage);

    return _compressedImage;
  }

  Future<File> getPhotoFromCamera() async {
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Widget getThumbnailOrFirstImage(List<Photo> photos,
      {double width = 80, double height = 80}) {
    final firstThumbnail =
        photos?.firstWhere((p) => (isNotEmpty(p.thumbUrl)), orElse: () => null);

    if (firstThumbnail != null) {
      return _getPhoto(
          url: firstThumbnail.thumbUrl, width: width, height: height);
    }

    final firstPhoto =
        photos?.firstWhere((p) => (isNotEmpty(p.url)), orElse: () => null);

    if (firstPhoto != null) {
      return _getPhoto(url: firstPhoto.url, width: width, height: height);
    }

    return _getPlaceholder(width: width, height: height);
  }

  CachedNetworkImage _getPhoto({url: String, width: double, height: double}) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, imageUrl) => CustomCircularIndicator(),
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }

  static Image _getPlaceholder({width: double, height: double}) {
    return Image.asset(
      'assets/images/no_photo_placeholder.png',
      width: width,
      height: height,
    );
  }

  Future<File> getPhotoFromGallery() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<String> _getTempDirectoryPath() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.absolute.path;
  }
}
