import 'package:flutter/material.dart';
import 'package:silentsignal/features/crime_report_form.dart';
import 'package:silentsignal/common/components/base_layout.dart';


void main() {
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
      home: const BaseLayout(),
    );
  }
}
