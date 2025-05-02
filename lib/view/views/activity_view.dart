import 'package:flutter/material.dart';
import 'package:my_wallet/controller/activity_controller.dart';
import 'package:my_wallet/model/activity_model.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final TransactionController _controller = TransactionController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Agregar Transacción'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTextField(_controller.nameController, 'Nombre', Icons.person, true),
                        const SizedBox(height: 12),
                        _buildTextField(_controller.descriptionController, 'Descripción', Icons.description, false),
                        const SizedBox(height: 12),
                        _buildTextField(_controller.amountController, 'Monto', Icons.money, true, isNumber: true),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          label: 'Categoría',
                          value: _controller.selectedCategory,
                          items: _controller.categories,
                          icon: Icons.category_outlined,
                          onChanged: (value) {
                            setState(() {
                              _controller.selectedCategory = value;
                            });
                          },
                          validator: (value) => value == null ? 'Por favor selecciona una categoría' : null,
                        ),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          label: 'Tipo',
                          value: _controller.selectedType,
                          items: ['Gasto', 'Ingreso'],
                          icon: Icons.category,
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
                            setState(() {});
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
                          onPressed: () {
                            if (_controller.validateForm()) {
                              TransactionModel newTransaction = _controller.createTransaction();
                              Navigator.pop(context, newTransaction);
                            }
                          },
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

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon, bool required,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      validator: required
          ? (value) => (value == null || value.isEmpty)
              ? 'Por favor ingresa un $label'
              : (isNumber && double.tryParse(value.trim()) == null)
                  ? 'Ingresa un monto válido'
                  : null
          : null,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
