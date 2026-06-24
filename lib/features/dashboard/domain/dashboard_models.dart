import 'package:flutter/material.dart';

enum TaskRepeat { none, daily, weekly, monthly }

class DashboardStat {
  const DashboardStat({
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

  DashboardStat copyWith({
    IconData? icon,
    String? label,
    String? value,
    String? supportingText,
    double? progress,
  }) {
    return DashboardStat(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      value: value ?? this.value,
      supportingText: supportingText ?? this.supportingText,
      progress: progress ?? this.progress,
    );
  }
}

class DashboardTask {
  const DashboardTask({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.isCompleted,
    this.dueDate,
    this.dueTime,
    this.repeat = TaskRepeat.none,
    this.reminderMinutesBefore,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final String duration;
  final bool isCompleted;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final TaskRepeat repeat;
  final int? reminderMinutesBefore;

  DashboardTask copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? duration,
    bool? isCompleted,
    DateTime? dueDate,
    bool clearDueDate = false,
    TimeOfDay? dueTime,
    bool clearDueTime = false,
    TaskRepeat? repeat,
    int? reminderMinutesBefore,
    bool clearReminderMinutesBefore = false,
  }) {
    return DashboardTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      dueTime: clearDueTime ? null : dueTime ?? this.dueTime,
      repeat: repeat ?? this.repeat,
      reminderMinutesBefore: clearReminderMinutesBefore
          ? null
          : reminderMinutesBefore ?? this.reminderMinutesBefore,
    );
  }
}

class WeeklyProgress {
  const WeeklyProgress({required this.day, required this.value});

  final String day;
  final double value;
}

class FocusSettings {
  const FocusSettings({
    required this.focusMinutes,
    required this.hasBreak,
    required this.breakMinutes,
  });

  final int focusMinutes;
  final bool hasBreak;
  final int breakMinutes;

  FocusSettings copyWith({
    int? focusMinutes,
    bool? hasBreak,
    int? breakMinutes,
  }) {
    return FocusSettings(
      focusMinutes: focusMinutes ?? this.focusMinutes,
      hasBreak: hasBreak ?? this.hasBreak,
      breakMinutes: breakMinutes ?? this.breakMinutes,
    );
  }
}
