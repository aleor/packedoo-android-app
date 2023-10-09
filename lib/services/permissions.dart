import 'package:permission_handler/permission_handler.dart';

PermissionsService permissionsService = PermissionsService();

class PermissionsService {
  Future<bool> checkAndRequestCameraPermissions() async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    if (permission == PermissionStatus.granted) {
      return true;
    }

    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);

    return permissions[PermissionGroup.camera] == PermissionStatus.granted;
  }

  Future<bool> checkAndRequestGalleryPermissions() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission == PermissionStatus.granted) {
      return true;
    }

    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    return permissions[PermissionGroup.storage] == PermissionStatus.granted;
  }

  Future<bool> openAppSettings() async {
    return await PermissionHandler().openAppSettings();
  }
}
