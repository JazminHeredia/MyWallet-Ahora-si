import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/budget_model.dart';

class BudgetController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> checkAndAlertBudget(BuildContext context, String category, double newExpense) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Obtén el límite de la categoría desde budgets_alert
    final budgetSnapshot = await _firestore
        .collection('budgets_alert')
        .where('userId', isEqualTo: user.uid)
        .where('category', isEqualTo: category)
        .get();

    if (budgetSnapshot.docs.isEmpty) return;

    final budget = budgetSnapshot.docs.first.data();
    final limit = (budget['limit'] ?? 0).toDouble();

    // Suma todos los gastos de la categoría
    double totalSpent = 0;
    final transactionsSnapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .where('category', isEqualTo: category)
        .where('type', isEqualTo: 'Gasto')
        .get();

    for (var doc in transactionsSnapshot.docs) {
      totalSpent += (doc['amount'] ?? 0).toDouble();
    }

    // SUMA el nuevo gasto manualmente para asegurar que la alerta salga en el momento correcto
    totalSpent += newExpense;

    if (totalSpent > limit) {
      // Mostrar recuadro de alerta SIEMPRE que se pase el límite
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¡ALERTA!'),
          content: Text('Has llegado al límite de presupuesto para $category.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  // CRUD para alertas de presupuesto
  Future<List<BudgetAlert>> getUserAlerts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    final snapshot = await _firestore
        .collection('budgets_alert')
        .where('userId', isEqualTo: user.uid)
        .get();
    return snapshot.docs
        .map((doc) => BudgetAlert.fromMap(doc.data(), doc.id))
        .toList();
  }

  Stream<List<BudgetAlert>> getUserAlertsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();
    return _firestore
        .collection('budgets_alert')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BudgetAlert.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addAlert(BudgetAlert alert) async {
    await _firestore.collection('budgets_alert').add(alert.toMap());
  }

  Future<void> updateAlert(String alertId, BudgetAlert updatedAlert) async {
    await _firestore.collection('budgets_alert').doc(alertId).update(updatedAlert.toMap());
  }

  Future<void> deleteAlert(String alertId) async {
    await _firestore.collection('budgets_alert').doc(alertId).delete();
  }

  Future<double?> getTotalSpentForCategory(String category) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    double totalSpent = 0;
    final transactionsSnapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .where('category', isEqualTo: category)
        .where('type', isEqualTo: 'Gasto')
        .get();
    for (var doc in transactionsSnapshot.docs) {
      totalSpent += (doc['amount'] ?? 0).toDouble();
    }
    return totalSpent;
  }
}
