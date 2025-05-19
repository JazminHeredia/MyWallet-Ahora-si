import 'package:flutter/material.dart';
import 'package:my_wallet/config/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme _appTheme = AppTheme();

  ThemeData get themeData => _appTheme.getTheme();
  bool get isDarkMode => _appTheme.isDarkMode;
  Color get primaryColor => _appTheme.primaryColor;

  void toggleTheme() {
    _appTheme = _appTheme.copyWith(isDarkMode: !_appTheme.isDarkMode);
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _appTheme = _appTheme.copyWith(primaryColor: color);
    notifyListeners();
  }
}
