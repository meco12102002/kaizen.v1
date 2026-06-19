import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Image.asset(
              height: 200,
              width: 200,
              "assets/images/toge.png",
            ),
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineLarge,
              children: [
                const TextSpan(text: 'Welcome to '),
                TextSpan(
                  text: 'Kaizen',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
