import 'package:flutter/material.dart';

class WeeklyUsageChart extends StatelessWidget {
  const WeeklyUsageChart({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const planned = [0.6, 0.55, 0.5, 0.65, 0.58, 0.45, 0.4];
    const actual = [0.7, 0.6, 0.62, 0.72, 0.66, 0.5, 0.48];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Awareness Chart',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(days.length, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            FractionallySizedBox(
                              heightFactor: planned[index],
                              widthFactor: 0.34,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              heightFactor: actual[index],
                              widthFactor: 0.34,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        days[index],
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
