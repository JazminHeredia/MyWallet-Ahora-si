import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/model/budget_model.dart'; // Importa el modelo de presupuesto

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuestos por Categoría'),
      ),
      body: Consumer<BudgetModel>(
        builder: (context, budgetModel, child) {
          return Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Categoría'),
                onChanged: (value) => budgetModel.setCategory(value),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Límite'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  budgetModel.setLimit(double.tryParse(value) ?? 0.0);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  // Aquí se puede agregar lógica para guardar en Firestore
                },
                child: const Text('Guardar Presupuesto'),
              ),
            ],
          );
        },
      ),
    );
  }
}
