import 'package:flutter/material.dart';
import 'package:kaizen/common/styles/themes.dart';
import 'package:kaizen/features/onboarding/onboarding_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Onboarding(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
