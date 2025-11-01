import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery
  Future<File?> pickFromGallery({int imageQuality = 80}) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
    if (pickedFile != null) return File(pickedFile.path);
    return null;
  }

  /// Capture an image using the camera
  Future<File?> pickFromCamera({int imageQuality = 80}) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
    if (pickedFile != null) return File(pickedFile.path);
    return null;
  }
}
