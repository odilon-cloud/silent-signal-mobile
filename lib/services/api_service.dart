import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final int maxRetries;
  final Duration timeout;
  
  ApiService({
    required this.baseUrl, 
    this.maxRetries = 3,
    this.timeout = const Duration(seconds: 10),
  });
  
  Future<Map<String, dynamic>> getData() async {
    return _requestWithRetry(
      () => http.get(Uri.parse('$baseUrl/api/data')),
    );
  }
  
  Future<Map<String, dynamic>> _requestWithRetry(Future<http.Response> Function() request) async {
    int attempts = 0;
    Exception? lastException;
    
    while (attempts < maxRetries) {
      try {
        final response = await request().timeout(timeout);
        
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return jsonDecode(response.body);
        } else if (response.statusCode >= 500) {
          // Server error, might be worth retrying
          lastException = Exception('Server error: ${response.statusCode}');
        } else {
          // Client error, probably not worth retrying
          throw Exception('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
      }
      
      attempts++;
      if (attempts < maxRetries) {
        // Exponential backoff
        await Future.delayed(Duration(milliseconds: 200 * (1 << attempts)));
      }
    }
    
    throw lastException ?? Exception('Request failed after $maxRetries attempts');
  }
  
  // Add more API methods here with similar error handling
}