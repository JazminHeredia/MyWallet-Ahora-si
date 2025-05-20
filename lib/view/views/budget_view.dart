import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/controller/budget_controller.dart';
import 'package:my_wallet/controller/categories_controller.dart';
import 'package:my_wallet/model/budget_model.dart';
import 'package:my_wallet/model/categories_model.dart' as my_wallet;
import 'package:firebase_auth/firebase_auth.dart';

class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  final BudgetController _budgetController = BudgetController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          title: const Text('Alertas de Presupuesto'),
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
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<BudgetAlert>>(
                stream: _budgetController.getUserAlertsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: \\${snapshot.error}'));
                  }
                  final alerts = snapshot.data ?? [];
                  if (alerts.isEmpty) {
                    return const Center(child: Text('No hay alertas de presupuesto'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.notifications, color: Colors.orange),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      alert.category,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        'Límite: \$${alert.limit.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                    ),
                                    if ((alert.alert ?? '').isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          'Estado: ${alert.alert}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) => EditBudgetAlertDialog(
                                          alert: alert,
                                          controller: _budgetController,
                                        ),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                                    onPressed: () async {
                                      await _budgetController.deleteAlert(alert.id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => CreateBudgetAlertDialog(controller: _budgetController),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Agregar Alerta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateBudgetAlertDialog extends StatefulWidget {
  final BudgetController controller;
  const CreateBudgetAlertDialog({super.key, required this.controller});

  @override
  State<CreateBudgetAlertDialog> createState() => _CreateBudgetAlertDialogState();
}

class _CreateBudgetAlertDialogState extends State<CreateBudgetAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _limitController = TextEditingController();
  String? _selectedCategory;
  final CategoriesController _categoriesController = CategoriesController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<my_wallet.Category>>(
      stream: _categoriesController.getUserCategoriesStream(),
      builder: (context, snapshot) {
        // Categorías por defecto
        final defaultCategories = ['Alimentos', 'Transporte', 'Entretenimiento', 'Salud'];
        final userCategories = snapshot.data?.map((cat) => cat.name).toList() ?? [];
        final allCategories = [...defaultCategories, ...userCategories];
        _selectedCategory ??= allCategories.isNotEmpty ? allCategories.first : null;
        return AlertDialog(
          title: const Text('Nueva Alerta de Presupuesto'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: allCategories.map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _limitController,
                  decoration: const InputDecoration(labelText: 'Límite'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;
                  final alert = BudgetAlert(
                    id: '',
                    category: _selectedCategory!,
                    limit: double.tryParse(_limitController.text.trim()) ?? 0.0,
                    userId: user.uid,
                    alert: null,
                  );
                  await widget.controller.addAlert(alert);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}

class EditBudgetAlertDialog extends StatefulWidget {
  final BudgetAlert alert;
  final BudgetController controller;
  const EditBudgetAlertDialog({super.key, required this.alert, required this.controller});

  @override
  State<EditBudgetAlertDialog> createState() => _EditBudgetAlertDialogState();
}

class _EditBudgetAlertDialogState extends State<EditBudgetAlertDialog> {
  late TextEditingController _categoryController;
  late TextEditingController _limitController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.alert.category);
    _limitController = TextEditingController(text: widget.alert.limit.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Alerta de Presupuesto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(labelText: 'Categoría'),
          ),
          TextFormField(
            controller: _limitController,
            decoration: const InputDecoration(labelText: 'Límite'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final updatedAlert = BudgetAlert(
              id: widget.alert.id,
              category: _categoryController.text.trim(),
              limit: double.tryParse(_limitController.text.trim()) ?? 0.0,
              userId: widget.alert.userId,
              alert: widget.alert.alert,
            );
            await widget.controller.updateAlert(widget.alert.id, updatedAlert);
            Navigator.of(context).pop();
          },
          child: const Text('Actualizar'),
        ),
      ],
    );
  }
}
