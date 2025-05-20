import 'package:flutter/material.dart';
import 'package:my_wallet/controller/categories_controller.dart';
import 'package:my_wallet/model/categories_model.dart' as my_wallet;
import 'package:go_router/go_router.dart';

class CreateCategoryView extends StatefulWidget {
  const CreateCategoryView({super.key});

  @override
  State<CreateCategoryView> createState() => _CreateCategoryViewState();
}

class _CreateCategoryViewState extends State<CreateCategoryView> {
  final _categoriesController = CategoriesController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withOpacity(0.7)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          title: const Text('Agregar Categoría'),
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
              child: StreamBuilder<List<my_wallet.Category>>(
                stream: _categoriesController.getUserCategoriesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: \\${snapshot.error}'));
                  }
                  final categories = snapshot.data ?? [];
                  if (categories.isEmpty) {
                    return const Center(child: Text('No hay categorías'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
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
                                  color: category.isExpense
                                      ? Theme.of(context).colorScheme.error.withOpacity(0.2)
                                      : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  category.isExpense ? Icons.remove : Icons.add,
                                  color: category.isExpense
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    if ((category.description ?? '').isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          category.description!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white70
                                                : Colors.black54,
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        'Tipo: ' + (category.isExpense ? 'Gasto' : 'Ingreso'),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        'Fecha: ' +
                                            '${category.date.day}/${category.date.month}/${category.date.year}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white70
                                              : Colors.black54,
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
                                        builder: (context) => EditCategoryDialog(
                                          category: category,
                                          controller: _categoriesController,
                                        ),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                                    onPressed: () async {
                                      await _categoriesController.deleteCategory(category.id!, context);
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
                  builder: (context) => CreateCategoryDialog(controller: _categoriesController),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Agregar Categoría'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog para crear categoría
class CreateCategoryDialog extends StatelessWidget {
  final CategoriesController controller;
  const CreateCategoryDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Categoría'),
      content: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: controller.descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Gasto'),
                    value: 'Gasto',
                    groupValue: controller.selectedType,
                    onChanged: (value) {
                      controller.selectedType = value!;
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Ingreso'),
                    value: 'Ingreso',
                    groupValue: controller.selectedType,
                    onChanged: (value) {
                      controller.selectedType = value!;
                    },
                  ),
                ),
              ],
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
            await controller.saveCategory(context);
            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

// Dialog para editar categoría
class EditCategoryDialog extends StatefulWidget {
  final my_wallet.Category category;
  final CategoriesController controller;
  const EditCategoryDialog({super.key, required this.category, required this.controller});

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late String selectedType;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category.name);
    descriptionController = TextEditingController(text: widget.category.description);
    selectedType = widget.category.isExpense ? 'Gasto' : 'Ingreso';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Categoría'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Gasto'),
                  value: 'Gasto',
                  groupValue: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Ingreso'),
                  value: 'Ingreso',
                  groupValue: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
              ),
            ],
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
            final updatedCategory = my_wallet.Category(
              id: widget.category.id,
              name: nameController.text.trim(),
              description: descriptionController.text.trim(),
              date: widget.category.date,
              isExpense: selectedType == 'Gasto',
              userId: widget.category.userId,
            );
            await widget.controller.updateCategory(widget.category.id!, updatedCategory, context);
            Navigator.of(context).pop();
          },
          child: const Text('Actualizar'),
        ),
      ],
    );
  }
}
