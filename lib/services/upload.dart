import 'dart:io';
import 'package:packedoo_app_material/models/photo.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

UploadService uploadService = UploadService();

class UploadService {
  static final _storage = 'https://firebasestorage.googleapis.com/v0/b';
  static final _storageBucket = 'packedoo-prod.appspot.com';
  // static final _storageBucket = 'packedoo-dev.appspot.com';

  final _server = '$_storage/$_storageBucket/o/images%2F';
  final _thumb = 'thumbnail200x200_';
  final _alt = '?alt=media';

  Future<Photo> upload(File file) async {
    final imageName = _randomFileId;

    StorageReference imageStorageRef =
        FirebaseStorage.instance.ref().child('images');
    final imageRef = imageStorageRef.child(imageName);

    final StorageUploadTask uploadTask = imageRef.putFile(
      file,
      StorageMetadata(
        contentType: lookupMimeType(file.path),
        cacheControl: 'max-age=30672000',
        customMetadata: <String, String>{'fileId': '$imageName'},
      ),
    );

    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    String thumbUrl = _getThumbUrl(imageName);

    return Photo(url: downloadUrl, thumbUrl: thumbUrl, fileId: imageName);
  }

  String _getThumbUrl(imageName) => '$_server$_thumb$imageName$_alt';

  String get _randomFileId => Uuid().v4();
}
