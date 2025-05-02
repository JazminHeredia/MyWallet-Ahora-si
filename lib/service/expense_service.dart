import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/model/budget_model.dart'; // Importar el modelo de presupuesto

class ExpenseService {
  void checkBudget(BuildContext context, double currentExpense, String category) {
    final budgetModel = Provider.of<BudgetModel>(context, listen: false);
    
    // Verificar si el gasto actual supera el límite
    if (currentExpense >= budgetModel.limit) {
      // Mostrar un alerta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Alerta! Has superado tu límite de $category.')),
      );
    }
  }
}
