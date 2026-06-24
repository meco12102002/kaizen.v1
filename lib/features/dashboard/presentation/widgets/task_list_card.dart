import 'package:flutter/material.dart';
import 'package:kaizen/features/dashboard/domain/dashboard_models.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/task_tile.dart';

class TaskListCard extends StatelessWidget {
  const TaskListCard({
    super.key,
    required this.tasks,
    required this.onAddTask,
    required this.onTaskChanged,
    required this.onDeleteTask,
    required this.onTaskTap,
    required this.scheduleTextBuilder,
  });

  final List<DashboardTask> tasks;
  final VoidCallback onAddTask;
  final void Function(int index, bool isCompleted) onTaskChanged;
  final ValueChanged<int> onDeleteTask;
  final ValueChanged<int> onTaskTap;
  final String Function(DashboardTask task) scheduleTextBuilder;

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
                Text(
                  "Today's Tasks",
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: onAddTask,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add Task'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No tasks yet. Add your first task to get started.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...tasks.asMap().entries.map(
                (entry) => TaskTile(
                  task: entry.value,
                  onChanged: (isCompleted) =>
                      onTaskChanged(entry.key, isCompleted),
                  onDelete: () => onDeleteTask(entry.key),
                  onTap: () => onTaskTap(entry.key),
                  scheduleText: scheduleTextBuilder(entry.value),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
