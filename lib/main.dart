// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:provider/provider.dart';
// import 'package:silentsignal/features/auth/LoginForm.dart';
// import 'package:silentsignal/providers/user_provider.dart';
// import 'package:silentsignal/providers/token_provider.dart'; // Import TokenProvider

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     await dotenv.load(fileName: ".env");
//   } catch (e) {
//     print("Error loading .env: $e");
//   }

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => UserProvider()),  // Register UserProvider
//         ChangeNotifierProvider(create: (_) => TokenProvider()), // Register TokenProvider
//       ],
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: const Loginform(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:silentsignal/features/auth/auth_check.dart';
import 'package:silentsignal/providers/user_provider.dart';
import 'package:silentsignal/providers/token_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TokenProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Silent Signal',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthCheck(), // Use AuthCheck instead of LoginForm
      ),
    );
  }
}