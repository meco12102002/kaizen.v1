import 'package:flutter/material.dart';
import 'package:kaizen/features/tasks/presentation/pages/homepage.dart';
import 'package:kaizen/features/tasks/presentation/pages/onboarding_slide_1.dart';
import 'package:kaizen/features/tasks/presentation/pages/onboarding_slide_2.dart';
import 'package:kaizen/features/tasks/presentation/pages/onboarding_slide_3.dart';
import 'package:kaizen/features/tasks/presentation/widgets/page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _pageCount = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLastPage = _currentPage == _pageCount - 1;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
            children: const [
              OnboardingSlide1(),
              OnboardingSlide2(),
              OnboardingSlide3(),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Homepage(),
                          ),
                        );
                      },
                      child: const Text('Skip for now'),
                    ),
                    Text(
                      'Step ${_currentPage + 1} of $_pageCount',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 0, 20, 88),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: PageIndicator(
                currentPage: _currentPage,
                pageCount: _pageCount,
              ),
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: _currentPage == 0
                          ? null
                          : () {
                              _controller.previousPage(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOut,
                              );
                            },
                      child: const Text('Back'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        if (isLastPage) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Homepage(),
                            ),
                          );
                          return;
                        }

                        _controller.nextPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Text(isLastPage ? 'Get started' : 'Next'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
