import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_wallet/model/budget_model.dart'; // Importar el modelo de presupuesto

class ExpenseService {
  void checkBudget(BuildContext context, double currentExpense, String category) async {
    final budgetModel = Provider.of<BudgetModel>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no autenticado')),
      );
      return;
    }

    // Verificar si el gasto actual supera el límite
    if (currentExpense >= budgetModel.limit) {
      // Mostrar una alerta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Alerta! Has superado tu límite de $category.')),
      );

      // Registrar la alerta en Firestore
      try {
        await FirebaseFirestore.instance.collection('budgets_alert').add({
          'category': category,
          'limit': budgetModel.limit,
          'userId': user.uid,
          'createdAt': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar la alerta: $e')),
        );
      }
    }
  }
}
