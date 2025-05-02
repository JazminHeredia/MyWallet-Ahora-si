import 'package:flutter/foundation.dart';

class BudgetModel with ChangeNotifier {
  String _category = '';
  double _limit = 0.0;

  String get category => _category;
  double get limit => _limit;

  void setCategory(String newCategory) {
    _category = newCategory;
    notifyListeners();
  }

  void setLimit(double newLimit) {
    _limit = newLimit;
    notifyListeners();
  }
}
