// home_model.dart
import 'package:flutter/foundation.dart';

class HomeModel with ChangeNotifier {
  // Estado para el período seleccionado (Día, Semana, Mes, Año)
  String _selectedPeriod = 'Semana';
  String get selectedPeriod => _selectedPeriod;

  // Estado para el tipo seleccionado (Gasto, Ingreso)
  String _selectedType = 'Gasto';
  String get selectedType => _selectedType;

  // Método para cambiar el período
  void setSelectedPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners(); // Notifica a los widgets escuchando este modelo
  }

  // Método para cambiar el tipo
  void setSelectedType(String type) {
    _selectedType = type;
    notifyListeners(); // Notifica a los widgets escuchando este modelo
  }
}
