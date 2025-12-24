import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anime_hub/core/constants/api_constants.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Generic GET request
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      // Build URL
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final finalUri = queryParams != null
          ? uri.replace(queryParameters: queryParams)
          : uri;

      print('🌐 API Request: ${finalUri.toString()}');

      // Make request
      final response = await client
          .get(finalUri)
          .timeout(ApiConstants.timeout);

      // Handle response
      if (response.statusCode == 200) {
        print('✅ API Success: ${finalUri.path} (${response.statusCode})');
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 429) {
        print('⚠️ Rate limit exceeded');
        throw ApiException('Rate limit exceeded. Please try again later.');
      } else if (response.statusCode == 404) {
        print('❌ Resource not found');
        throw ApiException('Resource not found.');
      } else {
        print('❌ Request failed: ${response.statusCode}');
        throw ApiException(
          'Request failed with status: ${response.statusCode}',
        );
      }
    } on http.ClientException catch (e) {
      print('❌ Network error: ${e.message}');
      throw ApiException('Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      print('❌ Unexpected error: $e');
      throw ApiException('Unexpected error: $e');
    }
  }

  void dispose() {
    client.close();
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}
