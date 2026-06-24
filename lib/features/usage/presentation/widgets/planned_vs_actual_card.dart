import 'package:flutter/material.dart';

class PlannedVsActualCard extends StatelessWidget {
  const PlannedVsActualCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
            'Planned vs Actual',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _ComparisonRow(
            label: 'Social Media',
            planned: '30m',
            actual: '45m',
            difference: '+15m',
            isPositive: false,
          ),
          const SizedBox(height: 12),
          _ComparisonRow(
            label: 'Learning',
            planned: '2h',
            actual: '1h 40m',
            difference: '-20m',
            isPositive: true,
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.planned,
    required this.actual,
    required this.difference,
    required this.isPositive,
  });

  final String label;
  final String planned;
  final String actual;
  final String difference;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.titleMedium),
                const SizedBox(height: 6),
                Text('Planned: $planned'),
                Text('Actual: $actual'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: (isPositive
                      ? colorScheme.tertiaryContainer
                      : colorScheme.errorContainer)
                  .withOpacity(0.5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              difference,
              style: textTheme.labelLarge?.copyWith(
                color: isPositive
                    ? colorScheme.onTertiaryContainer
                    : colorScheme.onErrorContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
