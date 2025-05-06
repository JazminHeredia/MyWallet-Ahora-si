import 'package:cloud_firestore/cloud_firestore.dart';
class TransactionModel {
  final String id;
  final String userId;
  final String category;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.date,
  });

  factory TransactionModel.fromMap(String id, Map<String, dynamic> data) {
    return TransactionModel(
      id: id,
      userId: data['userId'] ?? '',
      category: data['category'] ?? 'Sin categoría',
      amount: (data['amount'] ?? 0).toDouble(),
      date: data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.parse(data['date']),
    );
  }
}
