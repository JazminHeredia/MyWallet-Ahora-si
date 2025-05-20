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

class BudgetAlert {
  final String id;
  final String category;
  final double limit;
  final String userId;
  final String? alert;

  BudgetAlert({
    required this.id,
    required this.category,
    required this.limit,
    required this.userId,
    this.alert,
  });

  factory BudgetAlert.fromMap(Map<String, dynamic> data, String id) {
    return BudgetAlert(
      id: id,
      category: data['category'] ?? '',
      limit: (data['limit'] ?? 0).toDouble(),
      userId: data['userId'] ?? '',
      alert: data['alert'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'limit': limit,
      'userId': userId,
      if (alert != null) 'alert': alert,
    };
  }
}
