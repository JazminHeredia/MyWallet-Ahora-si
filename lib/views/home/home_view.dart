import 'package:flutter/material.dart';
import 'menu/menu.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedPeriod = 'Semana'; // Estado inicial
  String selectedType = 'Gasto'; // Nuevo estado para tipo

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
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedPeriod = 'Día';
                        });
                      },
                      child: Text(
                        'Día',
                        style: TextStyle(
                          color: selectedPeriod == 'Día' ? Colors.green : Colors.grey,
                          fontWeight: selectedPeriod == 'Día' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedPeriod = 'Semana';
                        });
                      },
                      child: Text(
                        'Semana',
                        style: TextStyle(
                          color: selectedPeriod == 'Semana' ? Colors.green : Colors.grey,
                          fontWeight: selectedPeriod == 'Semana' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedPeriod = 'Mes';
                        });
                      },
                      child: Text(
                        'Mes',
                        style: TextStyle(
                          color: selectedPeriod == 'Mes' ? Colors.green : Colors.grey,
                          fontWeight: selectedPeriod == 'Mes' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedPeriod = 'Año';
                        });
                      },
                      child: Text(
                        'Año',
                        style: TextStyle(
                          color: selectedPeriod == 'Año' ? Colors.green : Colors.grey,
                          fontWeight: selectedPeriod == 'Año' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
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
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = 'Gasto';
                            });
                          },
                          child: Text(
                            'GASTOS',
                            style: TextStyle(
                              color: selectedType == 'Gasto' ? Colors.white : Colors.white70,
                              fontWeight: selectedType == 'Gasto' ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = 'Ingreso';
                            });
                          },
                          child: Text(
                            'INGRESOS',
                            style: TextStyle(
                              color: selectedType == 'Ingreso' ? Colors.white : Colors.white70,
                              fontWeight: selectedType == 'Ingreso' ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
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
}
