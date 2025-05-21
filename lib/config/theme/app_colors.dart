import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E88E5); // Azul
  static const Color secondary = Color(0xFFD32F2F); // Rojo
  static const Color background = Color(0xFFF5F5F5); // Gris clarito
  static const Color surface = Color(0xFFFFFFFF); // Blanco
  static const Color textPrimary = Color(0xFF212121); // Texto oscuro
  static const Color textSecondary = Color(0xFF757575); // Texto más clarito
  static const Color accent = Color(0xFF4CAF50); // Verde 

  // Paleta centralizada de opciones de color para temas
  static final List<Map<String, dynamic>> colorOptions = [
    {
      'name': 'Verde (default)',
      'light': const Color(0xFF388E3C),
      'dark': const Color(0xFF1B5E20),
    },
    {
      'name': 'Rosa',
      'light': Colors.pink,
      'dark': Colors.pink.shade900,
    },
    {
      'name': 'Gris',
      'light': Colors.grey,
      'dark': Colors.grey.shade800,
    },
    {
      'name': 'Morado',
      'light': Colors.purple,
      'dark': Colors.purple.shade900,
    },
    {
      'name': 'Aqua',
      'light': Colors.cyan,
      'dark': Colors.cyan.shade900,
    },
    {
      'name': 'Rojo',
      'light': Colors.red,
      'dark': Colors.red.shade900,
    },
    {
      'name': 'Azul',
      'light': Colors.blue,
      'dark': Colors.blue.shade900,
    },
    {
      'name': 'Amarillo',
      'light': Colors.yellow[700],
      'dark': Colors.yellow.shade800,
    },
    {
      'name': 'Naranja',
      'light': Colors.orange,
      'dark': Colors.orange.shade900,
    },
  ];
}
