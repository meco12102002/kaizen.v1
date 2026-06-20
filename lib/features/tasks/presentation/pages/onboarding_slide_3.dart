import 'package:flutter/material.dart';

class OnboardingSlide3 extends StatelessWidget {
  const OnboardingSlide3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // IMAGE
              Image.asset('assets/images/rise_up.png', height: 280),

              const SizedBox(height: 48),

              // TITLE
              Text(
                'Grow 1% Every Day.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 16),

              // DESCRIPTION
              Text(
                'Track your journey, celebrate small wins, and build lasting habits that help you become the person you aspire to be.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
