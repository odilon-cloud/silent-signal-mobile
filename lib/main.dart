import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:silentsignal/features/auth/LoginForm.dart';


void main() async  {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    print("Error loading .env: $e"); // Catch any loading errors
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Loginform(),
    );
  }
}
