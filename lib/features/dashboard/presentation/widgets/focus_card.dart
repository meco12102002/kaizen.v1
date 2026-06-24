import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaizen/features/dashboard/domain/dashboard_models.dart';

class FocusCard extends StatelessWidget {
  const FocusCard({
    super.key,
    required this.settings,
    required this.remainingDuration,
    required this.isRunning,
    required this.isBreakRunning,
    required this.completedMinutes,
    required this.onSettingsChanged,
    required this.onPrimaryAction,
    required this.onReset,
    required this.showOpenWindowButton,
    required this.onOpenWindow,
  });

  final FocusSettings settings;
  final Duration remainingDuration;
  final bool isRunning;
  final bool isBreakRunning;
  final int completedMinutes;
  final ValueChanged<FocusSettings> onSettingsChanged;
  final VoidCallback onPrimaryAction;
  final VoidCallback onReset;
  final bool showOpenWindowButton;
  final VoidCallback onOpenWindow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selectedDuration = Duration(
      minutes: isBreakRunning ? settings.breakMinutes : settings.focusMinutes,
    );
    final progress = selectedDuration.inSeconds == 0
        ? 0.0
        : 1 - (remainingDuration.inSeconds / selectedDuration.inSeconds);
    final hasStarted = remainingDuration.inSeconds != selectedDuration.inSeconds;
    final statusText = isRunning
        ? isBreakRunning
              ? 'Break in progress. Step away for a moment.'
              : 'Stay with it. Your session is in progress.'
        : hasStarted
        ? isBreakRunning
              ? 'Break paused. Resume when you are ready.'
              : 'Paused. Jump back in when you are ready.'
        : 'Set your timer and start a focus session.';

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Focus Session',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 26),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.square(
                    dimension: 132,
                    child: CircularProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      strokeWidth: 10,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      color: colorScheme.primary,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDuration(remainingDuration),
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        isBreakRunning ? 'break' : 'focus',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                statusText,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (showOpenWindowButton) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onOpenWindow,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Open focus window'),
                ),
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _MinutesField(
                    key: ValueKey('focus-${settings.focusMinutes}'),
                    label: 'Focus',
                    initialValue: settings.focusMinutes.toString(),
                    enabled: !isRunning && !isBreakRunning,
                    onChanged: (value) {
                      final minutes = int.tryParse(value);
                      if (minutes != null && minutes > 0) {
                        onSettingsChanged(
                          settings.copyWith(focusMinutes: minutes),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MinutesField(
                    key: ValueKey('break-${settings.breakMinutes}-${settings.hasBreak}'),
                    label: 'Break',
                    initialValue: settings.breakMinutes.toString(),
                    enabled: settings.hasBreak && !isRunning && !isBreakRunning,
                    onChanged: (value) {
                      final minutes = int.tryParse(value);
                      if (minutes != null && minutes > 0) {
                        onSettingsChanged(
                          settings.copyWith(breakMinutes: minutes),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: settings.hasBreak,
              onChanged: (value) {
                onSettingsChanged(settings.copyWith(hasBreak: value));
              },
              title: const Text('Auto-start break'),
              subtitle: Text(
                settings.hasBreak
                    ? 'A ${settings.breakMinutes}-minute break starts after focus.'
                    : 'End the session without a break timer.',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  '$completedMinutes min completed today',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onPrimaryAction,
                    icon: Icon(
                      isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    ),
                    label: Text(
                      isRunning
                          ? 'Pause Session'
                          : isBreakRunning
                          ? 'Pause Break'
                          : hasStarted
                          ? 'Resume Session'
                          : 'Start Session',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  tooltip: 'Reset session',
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      final hours = duration.inHours.toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }
}

class _MinutesField extends StatefulWidget {
  const _MinutesField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final String initialValue;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  State<_MinutesField> createState() => _MinutesFieldState();
}

class _MinutesFieldState extends State<_MinutesField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _MinutesField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: widget.label,
        suffixText: 'mins',
      ),
      onChanged: widget.onChanged,
    );
  }
}
