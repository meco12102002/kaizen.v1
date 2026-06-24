import 'package:flutter/material.dart';
import 'package:kaizen/features/dashboard/domain/dashboard_models.dart';

class TaskEditorSheet extends StatefulWidget {
  const TaskEditorSheet({
    super.key,
    required this.categories,
    required this.title,
    required this.subtitle,
    this.submitLabel = 'Create Task',
    this.initialTask,
  });

  final List<String> categories;
  final String title;
  final String subtitle;
  final String submitLabel;
  final DashboardTask? initialTask;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _durationController;
  late String _selectedCategory;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TaskRepeat _selectedRepeat = TaskRepeat.none;
  int? _reminderMinutesBefore;

  @override
  void initState() {
    super.initState();
    final task = widget.initialTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _durationController = TextEditingController(
      text: task == null || task.duration == 'No schedule' ? '' : task.duration,
    );
    _selectedCategory = task?.category ?? 'Learning';
    _selectedDate = task?.dueDate;
    _selectedTime = task?.dueTime;
    _selectedRepeat = task?.repeat ?? TaskRepeat.none;
    _reminderMinutesBefore = task?.reminderMinutesBefore;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(
      DashboardTask(
        id: widget.initialTask?.id ?? DateTime.now().microsecondsSinceEpoch,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? 'No description added'
            : _descriptionController.text.trim(),
        category: _selectedCategory,
        duration: _durationController.text.trim().isEmpty
            ? 'No schedule'
            : _durationController.text.trim(),
        isCompleted: widget.initialTask?.isCompleted ?? false,
        dueDate: _selectedDate,
        dueTime: _selectedTime,
        repeat: _selectedRepeat,
        reminderMinutesBefore: _reminderMinutesBefore,
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _repeatLabel(TaskRepeat repeat) {
    switch (repeat) {
      case TaskRepeat.none:
        return 'Does not repeat';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, bottomInset + 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
                const SizedBox(height: 8),
                Text(widget.subtitle, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Task title',
                    hintText: 'Finish dashboard layout',
                    prefixIcon: Icon(Icons.edit_note_rounded),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a task title' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 2,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Add context, next step, or what done looks like',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 18),
                Text('Category', style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = category),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_month_rounded),
                        label: Text(_selectedDate == null ? 'Add date' : _formatDate(_selectedDate!)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickTime,
                        icon: const Icon(Icons.access_time_rounded),
                        label: Text(_selectedTime == null ? 'Add time' : _selectedTime!.format(context)),
                      ),
                    ),
                  ],
                ),
                if (_selectedDate != null || _selectedTime != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => setState(() {
                        _selectedDate = null;
                        _selectedTime = null;
                      }),
                      icon: const Icon(Icons.close_rounded),
                      label: const Text('Clear date & time'),
                    ),
                  ),
                const SizedBox(height: 8),
                DropdownButtonFormField<TaskRepeat>(
                  value: _selectedRepeat,
                  decoration: const InputDecoration(
                    labelText: 'Repeat',
                    prefixIcon: Icon(Icons.repeat_rounded),
                  ),
                  items: TaskRepeat.values.map((repeat) {
                    return DropdownMenuItem<TaskRepeat>(
                      value: repeat,
                      child: Text(_repeatLabel(repeat)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedRepeat = value);
                  },
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<int?>(
                  value: _reminderMinutesBefore,
                  decoration: const InputDecoration(
                    labelText: 'Reminder',
                    prefixIcon: Icon(Icons.notifications_active_outlined),
                  ),
                  items: const [
                    DropdownMenuItem<int?>(value: null, child: Text('No reminder')),
                    DropdownMenuItem<int?>(value: 10, child: Text('10 minutes before')),
                    DropdownMenuItem<int?>(value: 30, child: Text('30 minutes before')),
                    DropdownMenuItem<int?>(value: 60, child: Text('1 hour before')),
                  ],
                  onChanged: (value) {
                    setState(() => _reminderMinutesBefore = value);
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _durationController,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(
                    labelText: 'Duration or schedule',
                    hintText: '30m, 1h, tonight, after class',
                    prefixIcon: Icon(Icons.schedule_rounded),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.save_rounded),
                        label: Text(widget.submitLabel),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
