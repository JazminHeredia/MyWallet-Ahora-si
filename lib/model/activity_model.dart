class TransactionModel {
  final String name;
  final String description;
  final double amount;
  final String type;
  final DateTime date;
  final String category;

  TransactionModel({
    required this.name,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });
}
