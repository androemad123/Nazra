import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service to communicate with your ML API endpoint
/// 
/// Replace [apiBaseUrl] with your actual ML API endpoint
/// The API should accept a POST request with:
/// - imageUrl: The Cloudinary URL of the image
/// - description: Optional description
/// - category: Optional category
/// 
/// And return:
/// - severity: The predicted severity level
/// - Other fields as needed by your model
class MlApiService {
  Uri _buildAnalyzeUri(
    String imageUrl, {
    String? description,
    String? category,
  }) {
    final endpoint = dotenv.env['ML_VALIDATE_IMAGE_URL'];
    if (endpoint == null || endpoint.isEmpty) {
      throw StateError(
        'ML_VALIDATE_IMAGE_URL is not set. Please add it to your .env file.',
      );
    }

    final baseUri = Uri.parse(endpoint);
    final queryParams = {
      ...baseUri.queryParameters,
      'img_url': imageUrl,
      if (description != null && description.isNotEmpty) 'description': description,
      if (category != null && category.isNotEmpty) 'category': category,
    };

    return baseUri.replace(queryParameters: queryParams);
  }

  /// Sends image URL and metadata to ML API for analysis
  /// 
  /// Returns a Map containing:
  /// - severity: The predicted severity
  /// - Other fields returned by your model
  Future<Map<String, dynamic>?> analyzeImage({
    required String imageUrl,
    String? description,
    String? category,
  }) async {
    try {
      final uri = _buildAnalyzeUri(
        imageUrl,
        description: description,
        category: category,
      );
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('ML API request failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error calling ML API: $e');
      return null;
    }
  }

  /// Analyzes multiple images (takes the first one as primary)
  /// 
  /// This is a convenience method if you want to analyze only the first image
  /// or aggregate results from multiple images
  Future<Map<String, dynamic>?> analyzeImages({
    required List<String> imageUrls,
    String? description,
    String? category,
  }) async {
    if (imageUrls.isEmpty) return null;
    
    // Use the first image for analysis
    // You can modify this to analyze all images and aggregate results
    return await analyzeImage(
      imageUrl: imageUrls.first,
      description: description,
      category: category,
    );
  }
}

