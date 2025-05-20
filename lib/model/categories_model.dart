import 'package:cloud_firestore/cloud_firestore.dart';


// Clase que representa una categoría de transacción (Gastos o Ingresos)
class Category {
  final String? id; // ID de la categoria (opcional, se asigna al crear en Firestore)
  final String name; // Nombre de la categoria
  final String? description; // Descripción de la categoría
  final DateTime date; // Fecha de creación de la categoría
  final bool isExpense; // true para "Gastos" o false para "Ingresos"
  final String? userId; // User ID asociado con la categoria

  // Constructor de la clase Category
  // Se utiliza "required" para los campos obligatorios y se asignan valores por defecto para los opcionales
  Category({
    this.id, // campo opcional
    required this.name, // campo obligatorio
    this.description,
    required this.date,
    required this.isExpense,
    this.userId, 
  });

 // Método para crear una instancia de Category desde un mapa (Firestore)
  factory Category.fromMap(Map<String, dynamic> data, String? id) {
    DateTime parsedDate;
    if (data['date'] is Timestamp) {
      parsedDate = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      parsedDate = DateTime.parse(data['date']);
    } else {
      parsedDate = DateTime.now();
    }
    return Category(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      date: parsedDate,
      isExpense: data['isExpense'] ?? false,
      userId: data['userId'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'isExpense': isExpense,
      'userId': userId, // Include userId in the map
    };
  }
}
