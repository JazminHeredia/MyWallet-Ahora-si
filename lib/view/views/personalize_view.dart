import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class PersonalizeView extends StatelessWidget {
  const PersonalizeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorOptions = [
      {'name': 'Rojo', 'color': Colors.red},
      {'name': 'Azul', 'color': Colors.blue},
      {'name': 'Amarillo', 'color': Colors.yellow[700]},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar Color Principal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListView(
        children: colorOptions.map((option) {
          return ListTile(
            leading: CircleAvatar(backgroundColor: option['color'] as Color),
            title: Text(option['name'] as String),
            trailing: themeProvider.primaryColor == option['color']
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              themeProvider.setPrimaryColor(option['color'] as Color);
            },
          );
        }).toList(),
      ),
    );
  }
}
