import 'package:flutter/material.dart';
import 'package:my_wallet/config/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme _appTheme = AppTheme();
  int _selectedColorIndex = 0;

  ThemeProvider();

  ThemeData get themeData => _appTheme.getTheme();
  bool get isDarkMode => _appTheme.isDarkMode;
  Color get primaryColor => _appTheme.primaryColor;
  int get selectedColorIndex => _selectedColorIndex;

  void toggleTheme({required List<Map<String, dynamic>> colorOptions}) async {
    _appTheme = _appTheme.copyWith(isDarkMode: !_appTheme.isDarkMode);
    setPrimaryColorByIndex(_selectedColorIndex, isDark: _appTheme.isDarkMode, colorOptions: colorOptions);
    await _savePreferences();
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _appTheme = _appTheme.copyWith(primaryColor: color);
    notifyListeners();
  }

  void setPrimaryColorByIndex(int index, {required bool isDark, required List<Map<String, dynamic>> colorOptions}) async {
    _selectedColorIndex = index;
    final color = isDark ? colorOptions[index]['dark'] as Color : colorOptions[index]['light'] as Color;
    setPrimaryColor(color);
    await _savePreferences();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _appTheme.isDarkMode);
    prefs.setInt('selectedColorIndex', _selectedColorIndex);
  }

  // Nuevo: método público para cargar preferencias y aplicar el color
  Future<void> loadAndApplyPreferences(List<Map<String, dynamic>> colorOptions) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    final colorIndex = prefs.getInt('selectedColorIndex') ?? 0;
    _appTheme = _appTheme.copyWith(isDarkMode: isDark);
    _selectedColorIndex = colorIndex;
    setPrimaryColorByIndex(_selectedColorIndex, isDark: isDark, colorOptions: colorOptions);
    notifyListeners();
  }
}
