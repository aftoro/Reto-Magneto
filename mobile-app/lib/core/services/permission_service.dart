import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  static Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  static Future<bool> hasStoragePermission() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  static Future<bool> hasPhotosPermission() async {
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  static Future<bool> requestAllImagePermissions() async {
    final cameraGranted = await requestCameraPermission();
    final storageGranted = await requestStoragePermission();
    final photosGranted = await requestPhotosPermission();
    
    return cameraGranted && storageGranted && photosGranted;
  }

  static Future<bool> hasAllImagePermissions() async {
    final cameraGranted = await hasCameraPermission();
    final storageGranted = await hasStoragePermission();
    final photosGranted = await hasPhotosPermission();
    
    return cameraGranted && storageGranted && photosGranted;
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
