import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, List<double>>> getExpenseTrends(String userId) async {
    final snapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'Gasto')
        .get();

    Map<String, List<double>> categoryTrends = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final category = data['category'] ?? 'Sin categoría';
      final amount = (data['amount'] ?? 0).toDouble();

      // Manejar el campo 'date' como Timestamp o String
      DateTime date;
      if (data['date'] is Timestamp) {
        date = (data['date'] as Timestamp).toDate();
      } else if (data['date'] is String) {
        date = DateTime.parse(data['date']);
      } else {
        continue; // Ignorar si el formato no es válido
      }

      final weekOfYear = _getWeekOfYear(date);

      if (!categoryTrends.containsKey(category)) {
        categoryTrends[category] = List.filled(52, 0.0); // 52 semanas
      }
      categoryTrends[category]![weekOfYear - 1] += amount;
    }

    // Asegúrate de que todas las categorías tengan al menos un valor para mostrar
    categoryTrends.forEach((key, value) {
      if (value.every((amount) => amount == 0)) {
        value[0] = 0.01; // Agrega un valor mínimo para que se muestre en la gráfica
      }
    });

    return categoryTrends;
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil();
  }
}
