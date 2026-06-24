import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 250,
      color: colorScheme.surfaceContainer,
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.eco_rounded, color: colorScheme.primary, size: 30),
              const SizedBox(width: 10),
              Text(
                'Kaizen',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const SidebarItem(icon: Icons.home_rounded, label: 'Home', isActive: true),
          const SidebarItem(icon: Icons.check_circle_outline_rounded, label: 'Tasks'),
          const SidebarItem(icon: Icons.repeat_rounded, label: 'Habits'),
          const SidebarItem(icon: Icons.timer_rounded, label: 'Focus'),
          const SidebarItem(icon: Icons.edit_note_rounded, label: 'Reflection'),
          const SidebarItem(icon: Icons.analytics_outlined, label: 'Analytics'),
          const SizedBox(height: 26),
          Text(
            'Journey',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          const SidebarItem(icon: Icons.trending_up_rounded, label: 'Progress'),
          const SidebarItem(icon: Icons.flag_rounded, label: 'Milestones'),
          const Spacer(),
          Text(
            'v0.1.0 - Build with consistency',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatefulWidget {
  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final backgroundColor = widget.isActive
        ? colorScheme.primary
        : _isHovered
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainer.withOpacity(0);
    final foregroundColor =
        widget.isActive ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          dense: true,
          leading: Icon(widget.icon, color: foregroundColor),
          title: Text(
            widget.label,
            style: textTheme.bodyMedium?.copyWith(
              color: foregroundColor,
              fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onTap: () {},
        ),
      ),
    );
  }
}
