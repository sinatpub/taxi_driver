import 'package:flutter/material.dart';
import 'package:tara_driver_application/core/theme/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.main,
      primaryColorLight: AppColors.lighter,
      primaryColorDark: AppColors.darker,
      hintColor: AppColors.subtitle,
      scaffoldBackgroundColor: AppColors.light4,
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.main,
        secondary: AppColors.lighter,
        error: AppColors.error,
        surface: AppColors.light3,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onError: Colors.white,
      ).copyWith(error: AppColors.error),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darker,
      primaryColorLight: AppColors.dark3,
      primaryColorDark: AppColors.dark1,
      hintColor: AppColors.dark4,
      scaffoldBackgroundColor: AppColors.dark1,
      // Customize text theme here if needed
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darker,
        secondary: AppColors.dark2,
        error: AppColors.error,
        surface: AppColors.dark3,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.black,
      ).copyWith(error: AppColors.error),
    );
  }
}
