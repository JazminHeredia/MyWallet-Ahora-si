// app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

// Paleta de verdes personalizada para toda la app
const Color primaryGreen = Color(0xFF388E3C); // Verde principal
const Color secondaryGreen = Color(0xFF66BB6A); // Verde secundario
const Color backgroundGreen = Color(0xFFF1F8E9); // Fondo claro
const Color darkGreen = Color(0xFF1B5E20); // Verde oscuro para dark mode

class AppTheme {
  final bool isDarkMode;
  final Color primaryColor;

  AppTheme({
    this.isDarkMode = false,
    this.primaryColor = primaryGreen,
  });

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: isDarkMode ? Colors.black : primaryColor,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: false,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: isDarkMode ? Colors.black : AppColors.background,
        ),
        colorScheme: ColorScheme(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: primaryColor,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: isDarkMode ? Colors.black : Colors.white,
          onSurface: isDarkMode ? Colors.white : AppColors.textPrimary,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: isDarkMode ? Colors.white : AppColors.textPrimary),
          bodyMedium: TextStyle(color: isDarkMode ? Colors.white70 : AppColors.textSecondary),
        ),
      );

  AppTheme copyWith({bool? isDarkMode, Color? primaryColor}) => AppTheme(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        primaryColor: primaryColor ?? this.primaryColor,
      );
}