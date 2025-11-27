import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service to upload images to Cloudinary
/// 
/// You need to add your Cloudinary credentials:
/// - cloudName: Your Cloudinary cloud name
/// - uploadPreset: Your unsigned upload preset (recommended for client-side uploads)
/// 
/// You can get these from your Cloudinary dashboard at https://cloudinary.com/
class CloudinaryService {
  Uri get _uploadUri {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    if (cloudName == null || cloudName.isEmpty) {
      throw StateError(
        'CLOUDINARY_CLOUD_NAME is not set. Please add it to your .env file.',
      );
    }
    return Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
  }

  String get _uploadPreset {
    final preset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];
    if (preset == null || preset.isEmpty) {
      throw StateError(
        'CLOUDINARY_UPLOAD_PRESET is not set. Please add it to your .env file.',
      );
    }
    return preset;
  }

  /// Uploads an image file to Cloudinary with metadata
  /// 
  /// [imageFile] - The image file to upload
  /// [description] - Description to attach as metadata
  /// [category] - Category to attach as metadata
  /// 
  /// Returns the secure URL of the uploaded image, or null if upload fails
  Future<String?> uploadImage({
    required File imageFile,
    String? description,
    String? category,
  }) async {
    try {
      // Prepare multipart request
      final uploadUri = _uploadUri;
      final uploadPreset = _uploadPreset;

      var request = http.MultipartRequest('POST', uploadUri);

      // Add upload preset (allows unsigned uploads)
      request.fields['upload_preset'] = uploadPreset;

      // Add metadata in the "context" field (Cloudinary's way to store metadata)
      Map<String, String> context = {};
      if (description != null && description.isNotEmpty) {
        context['description'] = description;
      }
      if (category != null && category.isNotEmpty) {
        context['category'] = category;
      }

      if (context.isNotEmpty) {
        // Format context as: key1=value1|key2=value2
        request.fields['context'] = context.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('|');
      }

      // Add the image file
      var fileStream = http.ByteStream(imageFile.openRead());
      var fileLength = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: imageFile.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Return secure URL
        return responseData['secure_url'] as String?;
      } else {
        print('Cloudinary upload failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  /// Uploads multiple images and returns their URLs
  Future<List<String>> uploadImages({
    required List<File> imageFiles,
    String? description,
    String? category,
  }) async {
    List<String> uploadedUrls = [];
    
    for (var imageFile in imageFiles) {
      final url = await uploadImage(
        imageFile: imageFile,
        description: description,
        category: category,
      );
      if (url != null) {
        uploadedUrls.add(url);
      }
    }
    
    return uploadedUrls;
  }
}

