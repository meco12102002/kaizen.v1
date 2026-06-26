import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  colorScheme: const ColorScheme.light(
    // Main brand color.
    // Examples:
    // - Primary Buttons
    // - Active Navigation Item
    // - Progress Bars
    // - Selected Checkbox
    primary: Color(0xFF4CAF50),
    onPrimary: Colors.white,

    // Secondary accent.
    // Examples:
    // - Current Streak Card
    // - Links
    // - Info Chips
    secondary: Color(0xFF3B82F6),
    onSecondary: Colors.white,

    // Third accent.
    // Examples:
    // - Focus Time
    // - Charts
    // - Analytics
    tertiary: Color(0xFF8B5CF6),
    onTertiary: Colors.white,

    // Main card color.
    // Examples:
    // - Cards
    // - Dialogs
    // - Containers
    surface: Color(0xFFFFFFFF),

    // Text placed on surfaces.
    onSurface: Color(0xFF1A1F2B),

    // Slightly darker surface.
    // Examples:
    // - Sidebar
    // - Search Bar
    // - Input Fields
    surfaceContainerHighest: Color(0xFFF5F7F8),

    // Error states.
    // Examples:
    // - Validation Errors
    // - Delete Buttons
    error: Color(0xFFEF4444),
    onError: Colors.white,
  ),

  // Entire page background.
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),

  // Divider between widgets.
  dividerColor: const Color(0xFFE7EAEE),

  // Default card color.
  cardColor: Colors.white,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Color(0xFF1A1F2B),
    elevation: 0,
    centerTitle: false,
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: const ColorScheme.dark(
    // Main brand color.
    // Examples:
    // - Primary Buttons
    // - Active Navigation Item
    // - Progress Bars
    // - Selected Checkbox
    primary: Color(0xFF4CAF50),
    onPrimary: Colors.white,

    // Secondary accent.
    // Examples:
    // - Current Streak Card
    // - Links
    // - Info Chips
    secondary: Color(0xFF3B82F6),
    onSecondary: Colors.white,

    // Third accent.
    // Examples:
    // - Focus Time
    // - Analytics
    // - Charts
    tertiary: Color(0xFF8B5CF6),
    onTertiary: Colors.white,

    // Main card background.
    // Examples:
    // - Cards
    // - Dialogs
    // - Containers
    surface: Color(0xFF161B22),

    // Main text color.
    onSurface: Color(0xFFF3F4F6),

    // Elevated surface.
    // Examples:
    // - Sidebar
    // - Search Bar
    // - Input Fields
    surfaceContainerHighest: Color(0xFF1D2430),

    // Error states.
    error: Color(0xFFEF4444),
    onError: Colors.white,
  ),

  // Entire app background.
  scaffoldBackgroundColor: const Color(0xFF0E1117),

  // Borders & separators.
  dividerColor: const Color(0xFF262D38),

  // Card background.
  cardColor: const Color(0xFF161B22),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Color(0xFFF3F4F6),
    elevation: 0,
    centerTitle: false,
  ),
);
