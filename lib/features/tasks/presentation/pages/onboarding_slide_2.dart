import 'package:flutter/material.dart';

class OnboardingSlide2 extends StatelessWidget {
  const OnboardingSlide2({super.key});

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
              Image.asset(
                'assets/images/onboarding_clock_image.png',
                height: 280,
              ),

              const SizedBox(height: 48),

              // TITLE
              Text(
                'Everything in One Place.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 16),

              // DESCRIPTION
              Text(
                'Manage tasks, build habits, track progress, and stay focused without switching between multiple apps.',
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
