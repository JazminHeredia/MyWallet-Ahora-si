import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/controller/activity_controller.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final _controller = TransactionController();

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Cargar categorías personalizadas al iniciar
  }

  Future<void> _loadCategories() async {
    await _controller.loadUserCategories();
    setState(() {}); // Actualizar la vista con las categorías cargadas
  }

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
          title: Text('Agregar Transacción', style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor)),
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
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _controller.nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            suffixIcon: const Icon(Icons.person),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                          validator: (value) =>
                              value!.isEmpty ? 'Por favor ingresa un nombre' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _controller.descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            suffixIcon: const Icon(Icons.description),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _controller.amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Monto',
                            labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            suffixIcon: const Icon(Icons.attach_money),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _controller.selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Categoría',
                            labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            suffixIcon: const Icon(Icons.category_outlined),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          items: _controller.getAllCategories()
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _controller.selectedCategory = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Por favor selecciona una categoría' : null,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _controller.selectedType,
                          decoration: InputDecoration(
                            labelText: 'Tipo',
                            labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            suffixIcon: const Icon(Icons.category),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          items: ['Gasto', 'Ingreso']
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _controller.selectedType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            await _controller.selectDate(context);
                            setState(() {}); // Actualizar la vista al cambiar la fecha
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Fecha',
                              labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              suffixIcon: const Icon(Icons.calendar_today),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_controller.selectedDate.day}/${_controller.selectedDate.month}/${_controller.selectedDate.year}',
                                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _controller.saveTransaction(context),
                          icon: Icon(Icons.save, color: Theme.of(context).colorScheme.onPrimary),
                          label: Text('Guardar', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}