import 'package:flutter/material.dart';
import 'package:kaizen/features/dashboard/domain/dashboard_models.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/focus_card.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/progress_card.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/quote_card.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/stats_grid.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/task_list_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    super.key,
    required this.stats,
    required this.tasks,
    required this.weeklyProgress,
    required this.progress,
    required this.completedText,
    required this.onAddTask,
    required this.onTestNotification,
    required this.onTaskChanged,
    required this.onDeleteTask,
    required this.onTaskTap,
    required this.scheduleTextBuilder,
    required this.focusSettings,
    required this.remainingFocusDuration,
    required this.isFocusRunning,
    required this.isBreakPhase,
    required this.completedFocusMinutes,
    required this.onFocusSettingsChanged,
    required this.onFocusPrimaryAction,
    required this.onFocusReset,
    required this.showFocusWindow,
    required this.onOpenFocusWindow,
  });

  final List<DashboardStat> stats;
  final List<DashboardTask> tasks;
  final List<WeeklyProgress> weeklyProgress;
  final double progress;
  final String completedText;
  final VoidCallback onAddTask;
  final VoidCallback onTestNotification;
  final void Function(int index, bool isCompleted) onTaskChanged;
  final ValueChanged<int> onDeleteTask;
  final ValueChanged<int> onTaskTap;
  final String Function(DashboardTask task) scheduleTextBuilder;
  final FocusSettings focusSettings;
  final Duration remainingFocusDuration;
  final bool isFocusRunning;
  final bool isBreakPhase;
  final int completedFocusMinutes;
  final ValueChanged<FocusSettings> onFocusSettingsChanged;
  final VoidCallback onFocusPrimaryAction;
  final VoidCallback onFocusReset;
  final bool showFocusWindow;
  final VoidCallback onOpenFocusWindow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 980;
              final hasDrawer = Scaffold.hasDrawer(context);
              final statColumns = constraints.maxWidth >= 980
                  ? 4
                  : constraints.maxWidth >= 620
                  ? 2
                  : 1;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(
                    onMenuPressed: () => Scaffold.of(context).openDrawer(),
                    showMenuButton: hasDrawer,
                    onTestNotification: onTestNotification,
                  ),
                  const SizedBox(height: 24),
                  StatsGrid(stats: stats, columns: statColumns),
                  const SizedBox(height: 24),
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TaskListCard(
                            tasks: tasks,
                            onAddTask: onAddTask,
                            onTaskChanged: onTaskChanged,
                            onDeleteTask: onDeleteTask,
                            onTaskTap: onTaskTap,
                            scheduleTextBuilder: scheduleTextBuilder,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              ProgressCard(
                                progress: progress,
                                completedText: completedText,
                                weeklyProgress: weeklyProgress,
                              ),
                              const SizedBox(height: 24),
                              FocusCard(
                                settings: focusSettings,
                                remainingDuration: remainingFocusDuration,
                                isRunning: isFocusRunning,
                                isBreakRunning: isBreakPhase,
                                completedMinutes: completedFocusMinutes,
                                onSettingsChanged: onFocusSettingsChanged,
                                onPrimaryAction: onFocusPrimaryAction,
                                onReset: onFocusReset,
                                showOpenWindowButton: !showFocusWindow &&
                                    (isFocusRunning || isBreakPhase),
                                onOpenWindow: onOpenFocusWindow,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else ...[
                    TaskListCard(
                      tasks: tasks,
                      onAddTask: onAddTask,
                      onTaskChanged: onTaskChanged,
                      onDeleteTask: onDeleteTask,
                      onTaskTap: onTaskTap,
                      scheduleTextBuilder: scheduleTextBuilder,
                    ),
                    const SizedBox(height: 24),
                    ProgressCard(
                      progress: progress,
                      completedText: completedText,
                      weeklyProgress: weeklyProgress,
                    ),
                    const SizedBox(height: 24),
                    FocusCard(
                      settings: focusSettings,
                      remainingDuration: remainingFocusDuration,
                      isRunning: isFocusRunning,
                      isBreakRunning: isBreakPhase,
                      completedMinutes: completedFocusMinutes,
                      onSettingsChanged: onFocusSettingsChanged,
                      onPrimaryAction: onFocusPrimaryAction,
                      onReset: onFocusReset,
                      showOpenWindowButton: !showFocusWindow &&
                          (isFocusRunning || isBreakPhase),
                      onOpenWindow: onOpenFocusWindow,
                    ),
                  ],
                  const SizedBox(height: 24),
                  const QuoteCard(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
