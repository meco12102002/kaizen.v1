import 'package:flutter/material.dart';
import 'package:kaizen/features/dashboard/domain/dashboard_models.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/category_chip.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
    required this.onTap,
    required this.scheduleText,
  });

  final DashboardTask task;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final String scheduleText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final textColor = task.isCompleted
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurface;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) => onChanged(value ?? false),
      ),
      title: Text(
        task.title,
        style: textTheme.titleSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              task.description,
              style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            CategoryChip(label: task.category),
            Icon(Icons.schedule_rounded, size: 16, color: colorScheme.onSurfaceVariant),
            Text(
              scheduleText,
              style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
      trailing: IconButton(
        tooltip: 'Delete task',
        onPressed: onDelete,
        icon: const Icon(Icons.delete_outline_rounded),
      ),
    );
  }
}
