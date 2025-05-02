// home_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/model/home_model.dart'; // Importa el modelo
import 'package:my_wallet/view/views/widgets/custom_appbar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPeriodButton(context, 'Día'),
                    _buildPeriodButton(context, 'Semana'),
                    _buildPeriodButton(context, 'Mes'),
                    _buildPeriodButton(context, 'Año'),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTypeButton(context, 'Gasto'),
                        _buildTypeButton(context, 'Ingreso'),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white),
                  const Spacer(),
                  const Text('Total', style: TextStyle(color: Colors.white, fontSize: 18)),
                  const Text('0 \$', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir el botón del período
  Widget _buildPeriodButton(BuildContext context, String period) {
    final homeModel = Provider.of<HomeModel>(context); // Obtenemos el modelo desde el contexto
    return TextButton(
      onPressed: () {
        homeModel.setSelectedPeriod(period); // Actualizamos el período en el modelo
      },
      child: Text(
        period,
        style: TextStyle(
          color: homeModel.selectedPeriod == period ? Colors.green : Colors.grey,
          fontWeight: homeModel.selectedPeriod == period ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // Método para construir el botón del tipo (Gasto/Ingreso)
  Widget _buildTypeButton(BuildContext context, String type) {
    final homeModel = Provider.of<HomeModel>(context); // Obtenemos el modelo desde el contexto
    return GestureDetector(
      onTap: () {
        homeModel.setSelectedType(type); // Actualizamos el tipo en el modelo
      },
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: homeModel.selectedType == type ? Colors.white : Colors.white70,
          fontWeight: homeModel.selectedType == type ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
