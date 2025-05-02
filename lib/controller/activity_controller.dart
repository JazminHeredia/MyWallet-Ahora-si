import 'package:flutter/material.dart';
import '../model/activity_model.dart';

class TransactionController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedType = 'Gasto';
  final List<String> categories = ['Alimentos', 'Transporte', 'Entretenimiento', 'Salud'];
  String? selectedCategory;

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  TransactionModel createTransaction() {
    return TransactionModel(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      amount: double.parse(amountController.text.trim()),
      type: selectedType,
      date: selectedDate,
      category: selectedCategory ?? '',
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate = picked;
    }
  }

  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    amountController.dispose();
  }
}
