import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'Gasto';
  final List<String> _categories = ['Alimentos', 'Transporte', 'Entretenimiento', 'Salud'];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Agregar Transacción'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home'); // Navega a la pantalla "Home" usando go_router
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green, Colors.lightGreen],
          ),
        ),
        child: Center(
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
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Campo Nombre
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.person),
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Por favor ingresa un nombre' : null,
                        ),
                        const SizedBox(height: 12),

                        // Campo Descripción
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.description),
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Campo Monto
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Monto',
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.money),
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un monto';
                            }
                            final parsed = double.tryParse(value.trim());
                            if (parsed == null || parsed <= 0) {
                              return 'Ingresa un monto válido mayor a 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Selector de Categorías
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
                          },
                          validator: (value) =>
                              value == null ? 'Por favor selecciona una categoría' : null,
                        ),
                        const SizedBox(height: 12),

                        // Selector de Tipo
                        DropdownButtonFormField<String>(
                          value: _selectedType,
                          decoration: const InputDecoration(
                            labelText: 'Tipo',
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.category),
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          items: ['Gasto', 'Ingreso']
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 12),

                        // Selector de Fecha
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Fecha',
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: Icon(Icons.calendar_today),
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Botón Guardar
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) {
                                //ignore: avoid_print
                                print('Error: Usuario no autenticado');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Usuario no autenticado')),
                                );
                                return;
                              }
                              //ignore: avoid_print
                              print('UID del usuario autenticado: ${user.uid}');

                              final newTransaction = {
                                'name': _nameController.text.trim(),
                                'description': _descriptionController.text.trim(),
                                'amount': double.parse(_amountController.text.trim()),
                                'category': _selectedCategory,
                                'type': _selectedType,
                                'date': _selectedDate.toIso8601String(),
                                'userId': user.uid, // UID del usuario autenticado
                              };
                              //ignore: avoid_print
                              print('Datos enviados a Firestore: $newTransaction');

                              try {
                                await FirebaseFirestore.instance
                                    .collection('transactions')
                                    .add(newTransaction);

                                // Mostrar mensaje de éxito
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Transacción guardada con éxito')),
                                );

                                // Limpiar los campos del formulario
                                _nameController.clear();
                                _descriptionController.clear();
                                _amountController.clear();
                                setState(() {
                                  _selectedCategory = null;
                                  _selectedType = 'Gasto';
                                  _selectedDate = DateTime.now();
                                });
                              } catch (e) {
                                //ignore: avoid_print
                                print('Error al guardar en Firestore: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al guardar: $e')),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Guardar'),
                     // Navega a la pantalla "Home" usando go_router
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}