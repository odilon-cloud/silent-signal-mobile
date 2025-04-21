import 'package:flutter/foundation.dart';

class TokenProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }
  void clearToken() {
  _token = null; // Assuming _token is your token variable
  notifyListeners();
}
}
