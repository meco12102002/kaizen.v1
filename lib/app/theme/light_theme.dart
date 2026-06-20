import 'package:flutter/material.dart';
import 'app_colors.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: ColorScheme.light(

        primary: AppColors.primary,
        surface: AppColors.lightSurface,
        onPrimary: AppColors.darkText
      ),

      scaffoldBackgroundColor: AppColors.lightBackground,
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
      ),
    );
  }
}