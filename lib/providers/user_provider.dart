// lib/providers/user_provider.dart
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  DateTime? _loginTime;

  Map<String, dynamic>? get user => _user;
  DateTime? get loginTime => _loginTime;

  void setUser(Map<String, dynamic> user) {
    _user = user;
    _loginTime = DateTime.now();
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _loginTime = null;
    notifyListeners();
  }

  // Check if session is still valid (24 hours)
  bool isSessionValid() {
    if (_loginTime == null || _user == null) return false;
    
    // Session expires after 24 hours
    final sessionDuration = DateTime.now().difference(_loginTime!).inHours;
    return sessionDuration < 24;
  }

  // Get remaining session time in hours
  int getRemainingSessionHours() {
    if (_loginTime == null) return 0;
    final elapsed = DateTime.now().difference(_loginTime!).inHours;
    return 24 - elapsed;
  }
}
