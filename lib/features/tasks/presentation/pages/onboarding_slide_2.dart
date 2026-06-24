import 'package:flutter/material.dart';
import 'package:kaizen/features/tasks/presentation/widgets/onboarding_slide_shell.dart';

class OnboardingSlide2 extends StatelessWidget {
  const OnboardingSlide2({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingSlideShell(
      image: Image.asset(
        'assets/images/onboarding_clock_image.png',
        height: 280,
        fit: BoxFit.contain,
      ),
      title: 'Everything in one place.',
      description:
          'Plan tasks, track progress, and move through focus sessions without bouncing between tools.',
    );
  }
}
