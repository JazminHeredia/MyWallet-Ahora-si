import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/providers/theme_provider.dart'; // Importa el ThemeProvider correcto

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
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
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
