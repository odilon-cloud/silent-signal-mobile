// lib/providers/user_provider.dart
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;

  Map<String, dynamic>? get user => _user;

  void setUser(Map<String, dynamic> user) {
    _user = user;
    notifyListeners();
  }
  void clearUser() {
  _user = null; // Assuming _user is your user data variable
  notifyListeners();
}
}
