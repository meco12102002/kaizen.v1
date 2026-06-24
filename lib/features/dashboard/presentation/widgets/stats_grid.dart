import 'package:flutter/material.dart';
import 'package:kaizen/features/dashboard/domain/dashboard_models.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/stat_card.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key, required this.stats, required this.columns});

  final List<DashboardStat> stats;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 164,
      ),
      itemBuilder: (context, index) {
        final stat = stats[index];
        return StatCard(
          icon: stat.icon,
          label: stat.label,
          value: stat.value,
          supportingText: stat.supportingText,
          progress: stat.progress,
        );
      },
    );
  }
}
