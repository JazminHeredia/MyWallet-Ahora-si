import 'package:flutter/material.dart';
import 'package:my_wallet/utils/icons.dart'; // Adjust the import path as necessary

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear categoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre de la categoría',
                hintText: 'Introduzca un nombre para la categoría',
              ),
              onChanged: (value) {
                setState(() {
                  categoryName = value;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('Gastos'),
                    value: true,
                    groupValue: isExpense,
                    onChanged: (value) {
                      setState(() {
                        isExpense = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('Ingresos'),
                    value: false,
                    groupValue: isExpense,
                    onChanged: (value) {
                      setState(() {
                        isExpense = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Símbolos'),
            Wrap(
              spacing: 8,
              children: iconButtons.map((iconButton) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIcon = (iconButton as IconButton).icon.toString();
                    });
                  },
                  child: iconButton,
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text('Color'),
            Wrap(
              spacing: 8,
              children: [
                // Example colors
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = '#FF0000';
                    });
                  },
                  child: CircleAvatar(backgroundColor: Colors.red),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = '#00FF00';
                    });
                  },
                  child: CircleAvatar(backgroundColor: Colors.green),
                ),
                // Add more colors as needed
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Call controller to save the category
              },
              child: Text('Añadir'),
            ),
          ],
        ),
      ),
    );
  }
}
