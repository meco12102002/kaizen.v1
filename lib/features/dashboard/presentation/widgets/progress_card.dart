import 'package:flutter/material.dart';
import 'package:kaizen/features/dashboard/domain/dashboard_models.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.progress,
    required this.completedText,
    required this.weeklyProgress,
  });

  final double progress;
  final String completedText;
  final List<WeeklyProgress> weeklyProgress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Progress",
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 22),
            Center(
              child: SizedBox.square(
                dimension: 128,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      color: colorScheme.primary,
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                completedText,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                "Keep going, you're doing great!",
                style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weeklyProgress
                  .map((item) => Expanded(child: _WeeklyBar(progress: item)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyBar extends StatelessWidget {
  const _WeeklyBar({required this.progress});

  final WeeklyProgress progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          height: 72,
          width: 8,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
          ),
          child: FractionallySizedBox(
            heightFactor: progress.value,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(progress.day, style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
