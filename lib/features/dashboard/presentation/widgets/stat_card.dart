import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.supportingText,
    this.progress,
  });

  final IconData icon;
  final String label;
  final String value;
  final String supportingText;
  final double? progress;

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
            Row(
              children: [
                Icon(icon, color: colorScheme.primary),
                const Spacer(),
                Text(label, style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              supportingText,
              style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            if (progress != null) ...[
              const SizedBox(height: 14),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
