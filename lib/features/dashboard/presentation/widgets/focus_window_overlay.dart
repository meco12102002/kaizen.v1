import 'package:flutter/material.dart';
import 'package:kaizen/features/dashboard/domain/dashboard_models.dart';

class FocusWindowOverlay extends StatelessWidget {
  const FocusWindowOverlay({
    super.key,
    required this.offset,
    required this.settings,
    required this.remainingDuration,
    required this.isRunning,
    required this.isBreakPhase,
    required this.completedMinutes,
    required this.onOffsetChanged,
    required this.onPrimaryAction,
    required this.onReset,
    required this.onClose,
  });

  final Offset? offset;
  final FocusSettings settings;
  final Duration remainingDuration;
  final bool isRunning;
  final bool isBreakPhase;
  final int completedMinutes;
  final ValueChanged<Offset> onOffsetChanged;
  final VoidCallback onPrimaryAction;
  final VoidCallback onReset;
  final VoidCallback onClose;

  static const _windowSize = 240.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final windowSize = constraints.maxWidth < _windowSize + 32
            ? constraints.maxWidth - 32
            : _windowSize;
        final maxLeft = (constraints.maxWidth - windowSize)
            .clamp(16.0, double.infinity)
            .toDouble();
        final maxTop = (constraints.maxHeight - windowSize)
            .clamp(16.0, double.infinity)
            .toDouble();
        final position =
            offset ??
            Offset(
              ((constraints.maxWidth - windowSize) / 2)
                  .clamp(16.0, maxLeft)
                  .toDouble(),
              ((constraints.maxHeight - windowSize) / 2)
                  .clamp(16.0, maxTop)
                  .toDouble(),
            );
        final left = position.dx.clamp(16.0, maxLeft).toDouble();
        final top = position.dy.clamp(16.0, maxTop).toDouble();
        final sessionDuration = Duration(
          minutes: isBreakPhase ? settings.breakMinutes : settings.focusMinutes,
        );
        final progress = sessionDuration.inSeconds == 0
            ? 0.0
            : 1 - (remainingDuration.inSeconds / sessionDuration.inSeconds);

        return Positioned(
          left: left,
          top: top,
          width: windowSize,
          height: windowSize,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanUpdate: (details) {
              onOffsetChanged(
                Offset(
                  (left + details.delta.dx).clamp(16.0, maxLeft).toDouble(),
                  (top + details.delta.dy).clamp(16.0, maxTop).toDouble(),
                ),
              );
            },
            child: _FocusWindowCard(
              colorScheme: colorScheme,
              textTheme: textTheme,
              isBreakPhase: isBreakPhase,
              remainingDuration: remainingDuration,
              progress: progress,
              isRunning: isRunning,
              onPrimaryAction: onPrimaryAction,
              onReset: onReset,
              onClose: onClose,
              completedMinutes: completedMinutes,
            ),
          ),
        );
      },
    );
  }
}

class _FocusWindowCard extends StatelessWidget {
  const _FocusWindowCard({
    required this.colorScheme,
    required this.textTheme,
    required this.isBreakPhase,
    required this.remainingDuration,
    required this.progress,
    required this.isRunning,
    required this.onPrimaryAction,
    required this.onReset,
    required this.onClose,
    required this.completedMinutes,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isBreakPhase;
  final Duration remainingDuration;
  final double progress;
  final bool isRunning;
  final VoidCallback onPrimaryAction;
  final VoidCallback onReset;
  final VoidCallback onClose;
  final int completedMinutes;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 14,
      color: colorScheme.surfaceContainerHigh,
      shadowColor: colorScheme.shadow.withOpacity(0.18),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.drag_indicator_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isBreakPhase ? 'Break Timer' : 'Focus Timer',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close focus window',
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const Spacer(),
            SizedBox.square(
              dimension: 118,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.18),
                        width: 1,
                      ),
                    ),
                  ),
                  CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 9,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    color: colorScheme.primary,
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
                        isBreakPhase ? 'break' : 'focus',
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
            const SizedBox(height: 10),
            Text(
              isBreakPhase ? 'Break time' : 'Stay focused',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(
              '$completedMinutes min today',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onPrimaryAction,
                    icon: Icon(
                      isRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    label: Text(isRunning ? 'Pause' : 'Resume'),
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
