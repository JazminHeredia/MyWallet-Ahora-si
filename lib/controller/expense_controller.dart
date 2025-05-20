import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/expense_model.dart';
import 'package:flutter/material.dart';

class ExpenseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, List<double>>> getExpenseTrends(String userId) async {
    final snapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'Gasto')
        .get();

    Map<String, List<double>> categoryTrends = {};

    for (var doc in snapshot.docs) {
      final transaction = TransactionModel.fromMap(doc.id, doc.data());

      final weekOfYear = _getWeekOfYear(transaction.date);

      if (!categoryTrends.containsKey(transaction.category)) {
        categoryTrends[transaction.category] = List.filled(52, 0.0); // 52 semanas
      }
      categoryTrends[transaction.category]![weekOfYear - 1] += transaction.amount;
    }

    // Asegúrate de que todas las categorías tengan al menos un valor para mostrar
    categoryTrends.forEach((key, value) {
      if (value.every((amount) => amount == 0)) {
        value[0] = 0.01; // Agrega un valor mínimo para que se muestre en la gráfica
      }
    });

    return categoryTrends;
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil();
  }

  Future<void> updateTransaction(String transactionId, Map<String, dynamic> updatedData, BuildContext context) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transacción actualizada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la transacción: $e')),
      );
    }
  }

  Future<void> deleteTransaction(String transactionId, BuildContext context) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transacción eliminada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la transacción: $e')),
      );
    }
  }
}
