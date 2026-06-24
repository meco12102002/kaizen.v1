import 'package:flutter/material.dart';
import 'app_colors.dart';

class LightTheme {
  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.light,
      surface: AppColors.lightSurface,
    ).copyWith(
      surface: AppColors.lightSurface,
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFF8FAF5),
      surfaceContainer: const Color(0xFFF1F4EE),
      surfaceContainerHigh: const Color(0xFFEAEFE8),
      surfaceContainerHighest: const Color(0xFFE3E9E1),
      outlineVariant: AppColors.lightOutline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainer),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(color: colorScheme.onSurface),
        ),
        hintStyle: WidgetStatePropertyAll(
          TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
      ),
    );
  }
}
