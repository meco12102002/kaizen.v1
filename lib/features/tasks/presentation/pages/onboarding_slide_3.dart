import 'package:flutter/material.dart';
import 'package:kaizen/features/tasks/presentation/widgets/onboarding_slide_shell.dart';

class OnboardingSlide3 extends StatelessWidget {
  const OnboardingSlide3({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingSlideShell(
      image: Image.asset(
        'assets/images/rise_up.png',
        height: 280,
        fit: BoxFit.contain,
      ),
      title: 'Grow a little every day.',
      description:
          'Keep momentum visible, celebrate small wins, and build habits that actually stick.',
    );
  }
}
