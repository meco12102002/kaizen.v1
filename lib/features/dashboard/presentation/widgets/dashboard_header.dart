import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.onMenuPressed,
    required this.showMenuButton,
    required this.onTestNotification,
  });

  final VoidCallback onMenuPressed;
  final bool showMenuButton;
  final VoidCallback onTestNotification;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final title = Text(
      'Small progress today, big results tomorrow.',
      style: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w800,
      ),
    );
    final search = SearchBar(
      hintText: 'Search',
      leading: const Icon(Icons.search_rounded),
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainer),
    );
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.tonalIcon(
          onPressed: onTestNotification,
          icon: const Icon(Icons.notifications_active_outlined),
          label: const Text('Test'),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Notifications',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        IconButton(
          tooltip: 'More',
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showMenuButton) ...[
                    IconButton(
                      onPressed: onMenuPressed,
                      icon: const Icon(Icons.menu_rounded),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(child: title),
                  actions,
                ],
              ),
              const SizedBox(height: 16),
              search,
            ],
          );
        }

        return Row(
          children: [
            if (showMenuButton) ...[
              IconButton(
                onPressed: onMenuPressed,
                icon: const Icon(Icons.menu_rounded),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(child: title),
            SizedBox(width: 260, child: search),
            const SizedBox(width: 8),
            actions,
          ],
        );
      },
    );
  }
}
