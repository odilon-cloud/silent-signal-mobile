// Create a file named auth_check.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:silentsignal/providers/user_provider.dart';
import 'package:silentsignal/providers/token_provider.dart';
import 'package:silentsignal/common/components/base_layout.dart';
import 'package:silentsignal/features/auth/LoginForm.dart';
import 'dart:convert';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    // Get the saved token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null && token.isNotEmpty) {
      // Token exists, set it in the provider
      Provider.of<TokenProvider>(context, listen: false).setToken(token);
      
      // Get and set user info if available
      final userInfo = prefs.getString('user_info');
      if (userInfo != null && userInfo.isNotEmpty) {
        try {
          final userMap = jsonDecode(userInfo);
          Provider.of<UserProvider>(context, listen: false).setUser(userMap);
        } catch (e) {
          print('Error parsing saved user info: $e');
        }
      }
      
      // Navigate to the BaseLayout screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BaseLayout()),
      );
    } else {
      // No token found, navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Loginform()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This is just a loading indicator that will be briefly shown
    // while checking authentication state
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}