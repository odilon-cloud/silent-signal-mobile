import 'package:flutter/foundation.dart';

class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal();

  void info(String message) {
    if (kDebugMode) {
      print('ℹ️ INFO: $message');
    }
  }

  void success(String message) {
    if (kDebugMode) {
      print('✅ SUCCESS: $message');
    }
  }

  void warning(String message) {
    if (kDebugMode) {
      print('⚠️ WARNING: $message');
    }
  }

  void error(String message, [dynamic error]) {
    if (kDebugMode) {
      print('❌ ERROR: $message');
      if (error != null) {
        print('   Details: $error');
      }
    }
  }

  void debug(String message) {
    if (kDebugMode) {
      print('🐛 DEBUG: $message');
    }
  }

  void api(String endpoint, dynamic data) {
    if (kDebugMode) {
      print('🌐 API: $endpoint');
      print('   Data: $data');
    }
  }

  void response(String endpoint, dynamic response) {
    if (kDebugMode) {
      print('📡 RESPONSE: $endpoint');
      print('   Response: $response');
    }
  }
}

// Global logger instance
final logger = Logger(); 