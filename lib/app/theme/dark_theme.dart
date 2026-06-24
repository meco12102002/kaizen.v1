import 'package:flutter/material.dart';
import 'app_colors.dart';

class DarkTheme {
  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
    ).copyWith(
      surface: AppColors.darkSurface,
      surfaceContainerLowest: const Color(0xFF0D110E),
      surfaceContainerLow: const Color(0xFF151A16),
      surfaceContainer: const Color(0xFF1B211D),
      surfaceContainerHigh: const Color(0xFF222923),
      surfaceContainerHighest: const Color(0xFF2A312B),
      outlineVariant: AppColors.darkOutline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
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
        backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainerHigh),
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
