import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
const String BASE_URL = 'https://quiz.alasmari.dev/api';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class HttpClient {
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final url = Uri.parse(path);
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.post(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> get(String path, {String? token}) async {
    final url = Uri.parse(path);
    final headers = <String, String>{};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(url, headers: headers);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        if (jsonDecode(response.body) is List) {
          return {'list': jsonDecode(response.body)};
        }
        return jsonDecode(response.body);
      } catch (e) {
        throw ApiException(
          'Failed to decode response JSON.',
          statusCode: response.statusCode,
        );
      }
    } else if (response.statusCode == 401) {
      throw ApiException('Unauthorized access.', statusCode: 401);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      String errorMsg = 'Client error';

      try {
        final errorJson = jsonDecode(response.body);
        errorMsg = errorJson['message'] ?? errorJson['error'] ?? errorMsg;
      } catch (_) {}
      throw ApiException(errorMsg, statusCode: response.statusCode);
    } else if (response.statusCode >= 500) {
      throw ApiException('Server error.', statusCode: response.statusCode);
    } else {
      throw ApiException(
        'Unexpected network error.',
        statusCode: response.statusCode,
      );
    }
  }
}
