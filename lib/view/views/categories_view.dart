import 'package:flutter/material.dart';
import 'package:my_wallet/utils/icons.dart'; // Ajusta la ruta de importación según sea necesario
import 'package:go_router/go_router.dart';

class CreateCategoryView extends StatefulWidget {
  const CreateCategoryView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateCategoryViewState createState() => _CreateCategoryViewState();
}

class _CreateCategoryViewState extends State<CreateCategoryView> {
  String categoryName = '';
  bool isExpense = true;
  String selectedIcon = '';
  String selectedColor = '';
  double? scheduledExpense;

  // Colores disponibles para seleccionar
  final List<Color> availableColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];
  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make Scaffold background transparent
        appBar: AppBar(
          backgroundColor: Colors.green[700], // Make AppBar background transparent
          elevation: 0,
          title: const Text(
            'Crear categoría',
            style: TextStyle(fontWeight: FontWeight.bold),
            
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/home'); // Navega a la pantalla "Home" usando go_router
            },
            ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
        ),
        body: SingleChildScrollView(
          
          padding: const EdgeInsets.all(20.0),
          
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              
              Card(
                color: Colors.green[700],
                
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      const Text(
                        
                        'Información básica',
                        style: TextStyle(
                          
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Nombre de la categoría',
                          hintText: 'Ej: Comida, Transporte, Salario...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          prefixIcon: const Icon(Icons.category),
                        ),
                        onChanged: (value) {
                          setState(() {
                            categoryName = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              Card(
                color: Colors.green[700],
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tipo de categoría',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Gastos'),
                              selected: isExpense,
                              onSelected: (value) {
                                setState(() {
                                  isExpense = true;
                                });
                              },
                              // ignore: deprecated_member_use
                              selectedColor: Colors.red.withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: isExpense ? Colors.red : Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Ingresos'),
                              selected: !isExpense,
                              onSelected: (value) {
                                setState(() {
                                  isExpense = false;
                                });
                              },
                              // ignore: deprecated_member_use
                              selectedColor: Colors.green.withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: !isExpense ? Colors.green : Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              Card(
                color: Colors.green[700],
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seleccionar ícono',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 6,
                        children: iconButtons.map((iconButton) {
                          bool isSelected = selectedIcon == (iconButton as IconButton).icon.toString();
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIcon = iconButton.icon.toString();
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    // ignore: deprecated_member_use
                                    ? Theme.of(context).primaryColor.withOpacity(0.2)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2)
                                    : null,
                              ),
                              child: Center(
                                child: IconTheme(
                                  data: IconThemeData(
                                    color: isSelected 
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[700],
                                    size: 24,
                                  ),
                                  child: iconButton,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              Card(
                color: Colors.green[700],
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seleccionar color',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: availableColors.map((color) {
                          // ignore: deprecated_member_use
                          bool isSelected = selectedColor == color.value.toRadixString(16);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                // ignore: deprecated_member_use
                                selectedColor = color.value.toRadixString(16);
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: Colors.white,
                                        width: 3)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Llamar al controlador para guardar la categoría
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    // ignore: deprecated_member_use
                    shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                  child: const Text(
                    'CREAR CATEGORÍA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}