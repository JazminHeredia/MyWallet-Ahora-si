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
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green, Colors.lightGreen],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green[700],
          elevation: 0,
          title: const Text('Agregar Transacción'),
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
                        TextFormField(
                          controller: _controller.descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.description),
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _controller.amountController,
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
                        DropdownButtonFormField<String>(
                          value: _controller.selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Categoría',
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.category_outlined),
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          items: _controller.categories
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
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
                                  '${_controller.selectedDate.day}/${_controller.selectedDate.month}/${_controller.selectedDate.year}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _controller.saveTransaction(context),
                          icon: const Icon(Icons.save),
                          label: const Text('Guardar'),
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