import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/categories_model.dart' as my_wallet;

class CategoriesController {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedType = 'Gasto';

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

  Future<void> saveCategory(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no autenticado')),
        );
        return;
      }

      final newCategory = my_wallet.Category(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        date: selectedDate,
        isExpense: selectedType == 'Gasto',
        userId: user.uid,
      );

      try {
        await FirebaseFirestore.instance
            .collection('categories')
            .add(newCategory.toMap());

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoría guardada con éxito')),
        );

        // Limpiar los campos
        nameController.clear();
        descriptionController.clear();
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la categoría: $e')),
        );
      }
    }
  }

  Future<void> addCategory(my_wallet.Category category) async {
    try {
      await FirebaseFirestore.instance.collection('categories').add(category.toMap());
    } catch (e) {
      throw Exception('Error al agregar la categoría: $e');
    }
  }

  // Obtener todas las categorías del usuario actual
  Stream<List<my_wallet.Category>> getUserCategoriesStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('categories')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => my_wallet.Category.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Actualizar una categoría existente
  Future<void> updateCategory(String categoryId, my_wallet.Category updatedCategory, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .update(updatedCategory.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categoría actualizada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la categoría: $e')),
      );
    }
  }

  // Eliminar una categoría
  Future<void> deleteCategory(String categoryId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categoría eliminada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la categoría: $e')),
      );
    }
  }
}