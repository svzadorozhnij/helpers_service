import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoPickerService {
  static final formatImage = ['jpg', 'gif', 'png', 'tiff', 'raw'];
  static final blockedFormat = ['doc', 'docx', 'pdf', 'txt', 'raw'];

  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>?> getPhotoGallery() async {
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await Permission.storage.request();
    } else {
      permission = await Permission.photosAddOnly.request();
    }
    if (permission.isGranted || permission.isLimited) {
      final List<XFile> images = await _picker.pickMultiImage();
      return images;
    }
    return null;
  }

  Future<XFile?> getOnePhotoGallery() async {
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await Permission.storage.request();
      if(permission.isPermanentlyDenied) {
        permission = await Permission.photos.request();
      }
    } else {
      permission = await Permission.photosAddOnly.request();
    }
    if (!permission.isDenied) {
      final images = await _picker.pickImage(source: ImageSource.gallery);
      return images;
    }
    return null;
  }

  Future<XFile?> getPhotoCamera() async {
    final permission = await Permission.camera.request();
    if (!permission.isDenied) {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      return photo;
    }
    return null;
  }

  Future<XFile?> getVideoCamera({Duration? maxDuration}) async {
    final permission = await Permission.camera.request();
    if (permission.isGranted) {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: maxDuration ?? const Duration(hours: 1),
      );
      return video;
    }
    return null;
  }
}