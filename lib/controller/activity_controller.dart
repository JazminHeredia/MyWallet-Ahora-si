import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_wallet/model/activity_model.dart' as my_wallet;

class TransactionController {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedType = 'Gasto';
  final List<String> categories = ['Alimentos', 'Transporte', 'Entretenimiento', 'Salud'];
  String? selectedCategory;

  GlobalKey<FormState> get formKey => _formKey;

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

  Future<void> saveTransaction(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no autenticado')),
        );
        return;
      }

      final newTransaction = my_wallet.Transaction(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        amount: double.parse(amountController.text.trim()),
        category: selectedCategory,
        type: selectedType,
        date: selectedDate,
        userId: user.uid,
      );

      try {
        await FirebaseFirestore.instance
            .collection('transactions')
            .add(newTransaction.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transacción guardada con éxito')),
        );

        // Limpiar los campos
        nameController.clear();
        descriptionController.clear();
        amountController.clear();
        selectedCategory = null;
        selectedType = 'Gasto';
        selectedDate = DateTime.now();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }
}