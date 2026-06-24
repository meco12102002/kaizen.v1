import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaizen/features/dashboard/domain/dashboard_models.dart';
import 'package:kaizen/features/dashboard/presentation/pages/dashboard_content.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/focus_window_overlay.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/sidebar.dart';
import 'package:kaizen/features/dashboard/presentation/widgets/task_editor_sheet.dart';
import 'package:kaizen/core/services/notification_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<DashboardTask> _tasks = [];
  Timer? _focusTimer;
  Timer? _reminderTimer;
  FocusSettings _focusSettings = const FocusSettings(
    focusMinutes: 25,
    hasBreak: true,
    breakMinutes: 5,
  );
  Duration _remainingFocusDuration = const Duration(minutes: 25);
  int _completedFocusMinutes = 0;
  bool _isFocusRunning = false;
  bool _isBreakPhase = false;
  bool _showFocusWindow = false;
  Offset? _focusWindowOffset;
  final _notificationService = NotificationService.instance;
  final Set<int> _shownReminderIds = {};

  @override
  void initState() {
    super.initState();
    _notificationService.initialize();
    _reminderTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkDueTaskReminders();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDueTaskReminders();
    });
  }

  static const _categories = ['Learning', 'Health', 'Project', 'Focus'];

  static const _stats = [
    DashboardStat(
      icon: Icons.timer_rounded,
      label: 'Focus Time',
      value: '',
      supportingText: 'Time spent in focus sessions',
    ),
    DashboardStat(
      icon: Icons.local_fire_department_rounded,
      label: 'Current Streak',
      value: '7 Days',
      supportingText: 'Keep it going!',
    ),
    DashboardStat(
      icon: Icons.stars_rounded,
      label: 'Total Points',
      value: '320',
      supportingText: '+50 from yesterday',
    ),
  ];

  static const _weeklyProgress = [
    WeeklyProgress(day: 'Mon', value: 0.45),
    WeeklyProgress(day: 'Tue', value: 0.65),
    WeeklyProgress(day: 'Wed', value: 0.4),
    WeeklyProgress(day: 'Thu', value: 0.75),
    WeeklyProgress(day: 'Fri', value: 0.55),
    WeeklyProgress(day: 'Sat', value: 0.25),
    WeeklyProgress(day: 'Sun', value: 0.35),
  ];

  List<DashboardStat> get _derivedStats {
    final completed = _tasks.where((task) => task.isCompleted).length;
    final total = _tasks.length;
    final progress = total == 0 ? 0.0 : completed / total;
    final focusHours = _completedFocusMinutes ~/ 60;
    final focusMinutes = _completedFocusMinutes % 60;
    final focusLabel = focusHours > 0
        ? '${focusHours}h ${focusMinutes}m'
        : '${focusMinutes}m';

    return [
      DashboardStat(
        icon: Icons.task_alt_rounded,
        label: 'Tasks Completed',
        value: '$completed / $total',
        supportingText: '${(progress * 100).round()}%',
        progress: progress,
      ),
      _stats[0].copyWith(
        value: focusLabel,
        supportingText: _isFocusRunning
            ? 'Session currently running'
            : 'Time spent in focus sessions',
      ),
      _stats[1],
      _stats[2],
    ];
  }

  double get _progressValue {
    if (_tasks.isEmpty) return 0;
    return _tasks.where((task) => task.isCompleted).length / _tasks.length;
  }

  String get _progressText {
    final completed = _tasks.where((task) => task.isCompleted).length;
    return '$completed of ${_tasks.length} tasks completed';
  }

  void _toggleTask(int index, bool isCompleted) {
    setState(() {
      _tasks[index] = _tasks[index].copyWith(isCompleted: isCompleted);
    });
  }

  void _deleteTask(int index) {
    final task = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
    });
    _notificationService.cancelTaskReminder(task.id);
    _shownReminderIds.remove(task.id);
  }

  Future<void> _sendTestNotification() async {
    if (!mounted) return;

    unawaited(_notificationService.initialize());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Testing notification delivery now.')),
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Test notification'),
          content: const Text(
            'This is the built-in fallback so we can confirm the button is working.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );

    try {
      await _notificationService.showImmediateTestNotification();
    } catch (_) {
      // Windows toast delivery can fail silently in unpackaged desktop apps.
    }
  }

  Future<void> _updateTask(int index, DashboardTask task) async {
    final previous = _tasks[index];
    setState(() {
      _tasks[index] = task;
    });
    _notificationService.cancelTaskReminder(previous.id);
    _shownReminderIds.remove(previous.id);
    await _scheduleTaskReminder(task);
  }

  void _setFocusSettings(FocusSettings settings) {
    final sanitized = settings.copyWith(
      focusMinutes: settings.focusMinutes < 1 ? 1 : settings.focusMinutes,
      breakMinutes: settings.breakMinutes < 1 ? 1 : settings.breakMinutes,
    );

    _focusTimer?.cancel();
    setState(() {
      _focusSettings = sanitized;
      _isFocusRunning = false;
      _isBreakPhase = false;
      _remainingFocusDuration = Duration(minutes: sanitized.focusMinutes);
    });
  }

  void _toggleFocusSession() {
    if (_isFocusRunning) {
      _focusTimer?.cancel();
      setState(() => _isFocusRunning = false);
      return;
    }

    if (_remainingFocusDuration.inSeconds == 0) {
      _remainingFocusDuration = Duration(
        minutes: _isBreakPhase
            ? _focusSettings.breakMinutes
            : _focusSettings.focusMinutes,
      );
    }

    setState(() {
      _isFocusRunning = true;
      _showFocusWindow = true;
    });

    _focusTimer?.cancel();
    _focusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remainingFocusDuration.inSeconds <= 1) {
        timer.cancel();

        if (_isBreakPhase) {
          setState(() {
            _isFocusRunning = false;
            _isBreakPhase = false;
            _remainingFocusDuration = Duration(
              minutes: _focusSettings.focusMinutes,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Break complete. Ready for the next round.'),
            ),
          );
          return;
        }

        setState(() {
          _isFocusRunning = false;
          _completedFocusMinutes += _focusSettings.focusMinutes;
        });

        if (_focusSettings.hasBreak) {
          setState(() {
            _isBreakPhase = true;
            _isFocusRunning = true;
            _remainingFocusDuration = Duration(
              minutes: _focusSettings.breakMinutes,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Focus session complete. Starting ${_focusSettings.breakMinutes}-minute break.',
              ),
            ),
          );
        } else {
          setState(() {
            _remainingFocusDuration = Duration(
              minutes: _focusSettings.focusMinutes,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Focus session complete. Nice work.')),
          );
        }
        return;
      }

      setState(() {
        _remainingFocusDuration =
            _remainingFocusDuration - const Duration(seconds: 1);
      });
    });
  }

  void _resetFocusSession() {
    _focusTimer?.cancel();
    setState(() {
      _isFocusRunning = false;
      _isBreakPhase = false;
      _showFocusWindow = false;
      _focusWindowOffset = null;
      _remainingFocusDuration = Duration(minutes: _focusSettings.focusMinutes);
    });
  }

  void _checkDueTaskReminders() {
    if (!mounted) return;

    final now = DateTime.now();
    for (final task in _tasks) {
      if (task.isCompleted || task.dueDate == null || task.dueTime == null) {
        continue;
      }

      final dueAt = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
        task.dueTime!.hour,
        task.dueTime!.minute,
      );
      final reminderAt = task.reminderMinutesBefore == null
          ? dueAt
          : dueAt.subtract(Duration(minutes: task.reminderMinutesBefore!));
      final inReminderWindow =
          now.isAfter(reminderAt) &&
          now.isBefore(dueAt.add(const Duration(minutes: 1)));

      if (inReminderWindow && !_shownReminderIds.contains(task.id)) {
        _shownReminderIds.add(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              now.isBefore(dueAt)
                  ? 'Upcoming: ${task.title} is due soon.'
                  : 'Due now: ${task.title}',
            ),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () {
                final index = _tasks.indexWhere((item) => item.id == task.id);
                if (index != -1) {
                  _showTaskDetails(index);
                }
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _showAddTaskDialog() async {
    final task = await showModalBottomSheet<DashboardTask>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return TaskEditorSheet(
          categories: _categories,
          title: 'Create a task',
          subtitle: 'Plan the details now so future-you does less guessing.',
        );
      },
    );

    if (task != null) {
      setState(() => _tasks.add(task));
      await _scheduleTaskReminder(task);
    }
  }

  Future<void> _showTaskDetails(int index) async {
    final updatedTask = await showModalBottomSheet<DashboardTask>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return TaskEditorSheet(
          categories: _categories,
          initialTask: _tasks[index],
          title: 'Task details',
          subtitle: 'Review, reschedule, or refine this task.',
          submitLabel: 'Save Changes',
        );
      },
    );

    if (updatedTask != null) {
      await _updateTask(index, updatedTask);
    }
  }

  Future<void> _scheduleTaskReminder(DashboardTask task) async {
    final scheduledAt = _resolveReminderTime(task);
    if (scheduledAt == null) return;

    await _notificationService.scheduleTaskReminder(
      id: task.id,
      title: 'Task reminder',
      body: task.title,
      scheduledAt: scheduledAt,
    );
  }

  DateTime? _resolveReminderTime(DashboardTask task) {
    if (task.dueDate == null || task.dueTime == null) return null;

    final dueAt = DateTime(
      task.dueDate!.year,
      task.dueDate!.month,
      task.dueDate!.day,
      task.dueTime!.hour,
      task.dueTime!.minute,
    );
    final reminderMinutes = task.reminderMinutesBefore;
    if (reminderMinutes == null || reminderMinutes <= 0) return dueAt;

    return dueAt.subtract(Duration(minutes: reminderMinutes));
  }

  String _buildTaskScheduleText(DashboardTask task) {
    final parts = <String>[];
    if (task.duration.isNotEmpty && task.duration != 'No schedule') {
      parts.add(task.duration);
    }
    if (task.dueDate != null) {
      parts.add(_formatDate(task.dueDate!));
    }
    if (task.dueTime != null) {
      parts.add(task.dueTime!.format(context));
    }
    if (task.repeat != TaskRepeat.none) {
      parts.add(_repeatLabel(task.repeat));
    }
    return parts.isEmpty ? 'No schedule' : parts.join(' | ');
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _repeatLabel(TaskRepeat repeat) {
    switch (repeat) {
      case TaskRepeat.none:
        return 'No repeat';
      case TaskRepeat.daily:
        return 'Daily';
      case TaskRepeat.weekly:
        return 'Weekly';
      case TaskRepeat.monthly:
        return 'Monthly';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1100;
        final colorScheme = Theme.of(context).colorScheme;

        return Scaffold(
          drawer: isDesktop ? null : Drawer(child: Sidebar()),
          body: Stack(
            children: [
              IgnorePointer(
                ignoring: _showFocusWindow,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: _showFocusWindow ? 0.28 : 1,
                  child: Row(
                    children: [
                      if (isDesktop) Sidebar(),
                      Expanded(
                        child: DashboardContent(
                          stats: _derivedStats,
                          tasks: _tasks,
                          weeklyProgress: _weeklyProgress,
                          progress: _progressValue,
                          completedText: _progressText,
                          onAddTask: _showAddTaskDialog,
                          onTaskChanged: _toggleTask,
                          onDeleteTask: _deleteTask,
                          onTaskTap: _showTaskDetails,
                          scheduleTextBuilder: _buildTaskScheduleText,
                          focusSettings: _focusSettings,
                          remainingFocusDuration: _remainingFocusDuration,
                          isFocusRunning: _isFocusRunning,
                          isBreakPhase: _isBreakPhase,
                          completedFocusMinutes: _completedFocusMinutes,
                          onTestNotification: _sendTestNotification,
                          onFocusSettingsChanged: _setFocusSettings,
                          onFocusPrimaryAction: _toggleFocusSession,
                          onFocusReset: _resetFocusSession,
                          showFocusWindow: _showFocusWindow,
                          onOpenFocusWindow: () {
                            setState(() {
                              _showFocusWindow = true;
                              _focusWindowOffset = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showFocusWindow)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: colorScheme.surface.withValues(alpha: 0.08),
                    ),
                  ),
                ),
              if (_showFocusWindow)
                FocusWindowOverlay(
                  offset: _focusWindowOffset,
                  settings: _focusSettings,
                  remainingDuration: _remainingFocusDuration,
                  isRunning: _isFocusRunning,
                  isBreakPhase: _isBreakPhase,
                  completedMinutes: _completedFocusMinutes,
                  onOffsetChanged: (offset) {
                    setState(() => _focusWindowOffset = offset);
                  },
                  onPrimaryAction: _toggleFocusSession,
                  onReset: _resetFocusSession,
                  onClose: () {
                    setState(() => _showFocusWindow = false);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    _reminderTimer?.cancel();
    super.dispose();
  }
}
