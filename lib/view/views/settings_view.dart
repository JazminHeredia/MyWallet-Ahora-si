import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/providers/theme_provider.dart'; // Importa el ThemeProvider correcto
import 'package:my_wallet/config/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    final colorOptions = AppColors.colorOptions;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes de Usuario'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Modo Oscuro'),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(colorOptions: colorOptions);
            },
          ),
        ],
      ),
    );
  }
}
