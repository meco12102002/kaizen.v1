import 'package:flutter/material.dart';
import 'package:kaizen/features/tasks/presentation/widgets/onboarding_slide_shell.dart';

class OnboardingSlide1 extends StatelessWidget {
  const OnboardingSlide1({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingSlideShell(
      image: Image.asset(
        'assets/images/kappa.png',
        height: 220,
        fit: BoxFit.contain,
      ),
      title: 'Progress over perfection.',
      description:
          'Start small, stay consistent, and let the app keep the moving parts easy to manage.',
    );
  }
}
