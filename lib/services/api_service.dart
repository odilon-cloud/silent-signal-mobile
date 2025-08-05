import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:silentsignal/utils/logger.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  /// Generic GET request
  Future<dynamic> get({required String endpoint}) async {
    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect to server'};
    }
  }

  /// Generic POST request
  Future<dynamic> post({required String endpoint, required Map<String, dynamic> data}) async {
   
    final Uri url = Uri.parse('$baseUrl$endpoint');
     logger.api(endpoint, data);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect to server'};
    }
  }

  /// Generic PUT request (for updating data)
  Future<dynamic> put({required String endpoint, required Map<String, dynamic> data}) async {
    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect to server'};
    }
  }

  /// Generic DELETE request
  Future<dynamic> delete({required String endpoint}) async {
    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect to server'};
    }
  }

  /// Helper function to handle responses
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {'status': 'error', 'message': jsonDecode(response.body)['message'] ?? 'Something went wrong'};
    }
  }

   
}
