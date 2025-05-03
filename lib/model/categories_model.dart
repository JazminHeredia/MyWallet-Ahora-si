class Category {
  String name;
  bool isExpense; // true for "Gastos", false for "Ingresos"
  String icon; // Icon identifier
  String color; // Hex color code
  double? scheduledExpense; // Optional scheduled expense

  Category({
    required this.name,
    required this.isExpense,
    required this.icon,
    required this.color,
    this.scheduledExpense,
  });
}
