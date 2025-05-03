import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String? id;
  final String name;
  final String? description;
  final double amount;
  final String? category;
  final String type;
  final DateTime date;
  final String? userId;

  Transaction({
    this.id,
    required this.name,
    this.description,
    required this.amount,
    this.category,
    required this.type,
    required this.date,
    this.userId,
  });

  // Método para crear una instancia de Transaction desde un mapa (Firestore)
  factory Transaction.fromMap(Map<String, dynamic> data, String? id) {
    return Transaction(
      id: id,
      name: data['name'] ?? '',
      description: data['description'],
      amount: (data['amount'] ?? 0).toDouble(),
      category: data['category'],
      type: data['type'] ?? 'Gasto',
      date: (data['date'] as Timestamp).toDate(),
      userId: data['userId'],
    );
  }

  // Método para convertir la instancia de Transaction a un mapa (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'amount': amount,
      'category': category,
      'type': type,
      'date': date.toIso8601String(),
      'userId': userId,
    };
  }
}