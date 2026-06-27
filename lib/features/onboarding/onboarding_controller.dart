import 'package:flutter/material.dart';
import 'package:kaizen/features/onboarding/onboarding_slide2.dart';
import 'package:kaizen/features/onboarding/onboarding_slide3.dart';
import 'package:kaizen/features/onboarding/onboarding_slide_1.dart';

class Onboarding extends StatelessWidget {
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
