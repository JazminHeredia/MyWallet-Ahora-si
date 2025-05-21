import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/config/theme/app_colors.dart';

class PersonalizeView extends StatelessWidget {
  const PersonalizeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorOptions = AppColors.colorOptions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar Color Principal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListView(
        children: colorOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final color = isDark ? option['dark'] as Color : option['light'] as Color;
          return ListTile(
            leading: CircleAvatar(backgroundColor: color),
            title: Text(option['name'] as String),
            trailing: themeProvider.selectedColorIndex == index
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              themeProvider.setPrimaryColorByIndex(index, isDark: isDark, colorOptions: colorOptions);
            },
          );
        }).toList(),
      ),
    );
  }
}
