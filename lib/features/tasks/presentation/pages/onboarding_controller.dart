import 'package:flutter/material.dart';
import 'package:kaizen/features/tasks/presentation/pages/onboarding_slide_1.dart';
import 'package:kaizen/features/tasks/presentation/pages/onboarding_slide_2.dart';
import 'package:kaizen/features/tasks/presentation/pages/onboarding_slide_3.dart';

class Onboarding extends StatelessWidget {
  Onboarding({super.key});
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [OnboardingSlide1(), OnboardingSlide2(), OnboardingSlide3()],
      ),
    );
  }
}
