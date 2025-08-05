// Create a file named auth_check.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:silentsignal/providers/user_provider.dart';
import 'package:silentsignal/common/components/base_layout.dart';
import 'package:silentsignal/features/auth/LoginForm.dart';
import 'dart:convert';
import 'package:silentsignal/utils/logger.dart';

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
    // Get the saved user info from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userInfo = prefs.getString('user_info');
    
    if (userInfo != null && userInfo.isNotEmpty) {
      try {
        final userMap = jsonDecode(userInfo);
        
        // Check if user data is valid (has required fields)
        if (userMap['id'] != null && userMap['email'] != null && userMap['first_name'] != null) {
          // Set user info in the provider
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(userMap);
          
          // Check if session is still valid
          if (userProvider.isSessionValid()) {
            // Navigate to the BaseLayout screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const BaseLayout()),
            );
          } else {
            // Session expired, clear user data and navigate to login
            userProvider.clearUser();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Loginform()),
            );
          }
        } else {
          // Invalid user data, navigate to login screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Loginform()),
          );
        }
      } catch (e) {
        logger.error('Error parsing saved user info', e);
        // Error parsing user data, navigate to login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Loginform()),
        );
      }
    } else {
      // No user info found, navigate to login screen
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
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}