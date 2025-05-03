import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_wallet/model/budget_model.dart';
import 'package:my_wallet/service/expense_service.dart'; // Importar el servicio de gastos

class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _categories = ['Alimentos', 'Transporte', 'Entretenimiento', 'Salud'];
  String? _selectedCategory;
  final _limitController = TextEditingController();
  final _expenseService = ExpenseService(); // Instancia del servicio de gastos

  @override
  Widget build(BuildContext context) {
    final budgetModel = Provider.of<BudgetModel>(context, listen: false);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green, Colors.lightGreen], // Gradient for entire screen
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make Scaffold background transparent
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green, Colors.lightGreen], // Gradient for AppBar
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.green[700], // Transparent AppBar
              centerTitle: true,
              title: const Text('Presupuestos por Categoría'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.go('/home');
                },
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
            ),
          ),
        ),
        body: Center( // Center the content
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: const InputDecoration(
                                labelText: 'Categoría',
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: Icon(Icons.category_outlined),
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              ),
                              items: _categories
                                  .map((category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(category),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                                budgetModel.setCategory(value ?? '');
                              },
                              validator: (value) =>
                                  value == null ? 'Por favor selecciona una categoría' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _limitController,
                              decoration: const InputDecoration(
                                labelText: 'Límite',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                budgetModel.setLimit(double.tryParse(value) ?? 0.0);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa un límite';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Por favor ingresa un número válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                final user = FirebaseAuth.instance.currentUser;

                                if (user == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Usuario no autenticado')),
                                  );
                                  return;
                                }

                                try {
                                  await FirebaseFirestore.instance.collection('budgets_alert').add({
                                    'category': budgetModel.category.trim(),
                                    'limit': budgetModel.limit,
                                    'userId': user.uid,
                                    'createdAt': DateTime.now().toIso8601String(),
                                  });

                                  // Verificar si se debe generar una alerta
                                  _expenseService.checkBudget(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    budgetModel.limit, // Simular gasto actual como el límite
                                    budgetModel.category,
                                  );

                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Presupuesto guardado')),
                                  );

                                  // Limpia los campos
                                  setState(() {
                                    _selectedCategory = null;
                                    _limitController.clear();
                                  });
                                  budgetModel.setCategory('');
                                  budgetModel.setLimit(0.0);
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error al guardar: $e')),
                                  );
                                }
                              },
                              child: const Text('Guardar Presupuesto'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
