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
  List<String> userCategories = []; // Lista para categorías personalizadas
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

        // ignore: use_build_context_synchronously
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
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  // Método para cargar categorías personalizadas del usuario
  Future<void> loadUserCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('userId', isEqualTo: user.uid)
          .get();

      userCategories = querySnapshot.docs
          .map((doc) => doc['name'] as String)
          .toList();
    } catch (e) {
      debugPrint('Error al cargar categorías personalizadas: $e');
    }
  }

  // Método para obtener todas las categorías (predeterminadas + personalizadas)
  List<String> getAllCategories() {
    return [...categories, ...userCategories];
  }
}