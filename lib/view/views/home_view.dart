// home_view.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:my_wallet/model/home_model.dart'; // Importa el modelo
import 'package:my_wallet/view/views/widgets/custom_appbar.dart';
import 'package:my_wallet/controller/expense_controller.dart';
import 'package:my_wallet/controller/activity_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedPeriod = 'Semana';
  String selectedType = 'Gasto';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ExpenseController _expenseController = ExpenseController();
  final TransactionController _transactionController = TransactionController();
  List<String> _allCategories = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<QueryDocumentSnapshot> _filterTransactions(List<QueryDocumentSnapshot> transactions) {
    if (_searchQuery.isEmpty) return transactions;
    return transactions.where((doc) {
      final transaction = doc.data() as Map<String, dynamic>;
      final name = transaction['name']?.toString().toLowerCase() ?? '';
      final description = transaction['description']?.toString().toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase()) ||
          description.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Agregar método para calcular balance
  Stream<double> _calculateBalance(String userId) {
    return FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      double total = 0;
      for (var doc in snapshot.docs) {
        final transaction = doc.data();
        final amount = (transaction['amount'] ?? 0).toDouble();
        if (transaction['type'] == 'Ingreso') {
          total += amount;
        } else {
          total -= amount;
        }
      }
      return total;
    });
  }

  Future<void> _deleteTransaction(String transactionId) async {
    await FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionId)
        .delete();
    // Puedes mostrar un SnackBar si quieres feedback visual
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transacción eliminada')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    await _transactionController.loadUserCategories();
    setState(() {
      _allCategories = _transactionController.getAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Usuario no autenticado'),
      );
    }
  //ignore: avoid_print
    print('UID del usuario autenticado: ${user.uid}');

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Barra de búsqueda
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Buscar transacciones...',
                      hintStyle: TextStyle(
                        color: Theme.of(context).hintColor,
                      ),
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                // Botones de período existentes
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
                          color: selectedPeriod == 'Día' ? Theme.of(context).colorScheme.primary : Colors.grey,
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
                          color: selectedPeriod == 'Semana' ? Theme.of(context).colorScheme.primary : Colors.grey,
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
                          color: selectedPeriod == 'Mes' ? Theme.of(context).colorScheme.primary : Colors.grey,
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
                          color: selectedPeriod == 'Año' ? Theme.of(context).colorScheme.primary : Colors.grey,
                          fontWeight: selectedPeriod == 'Año' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Agregar el widget de balance
                StreamBuilder<double>(
                  stream: _calculateBalance(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final balance = snapshot.data ?? 0.0;
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'BALANCE TOTAL',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                             '\$${balance.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: balance >= 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                /*
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ExpenseTrends()),
                    );
                  },
                  child: const Text('Ver Tendencias de Gastos'),
                ),*/
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
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
                              color: selectedType == 'Gasto' ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
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
                              color: selectedType == 'Ingreso' ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                              fontWeight: selectedType == 'Ingreso' ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('transactions')
                          .where('userId', isEqualTo: user.uid)
                          .where('type', isEqualTo: selectedType)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          // ignore: avoid_print
                          print('No se encontraron transacciones para el tipo: $selectedType');
                          return const Center(
                            child: Text(
                              'No hay transacciones',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final transactions = snapshot.data!.docs;
                        final filteredTransactions = _filterTransactions(transactions);
                        // ignore: avoid_print
                        print('Transacciones obtenidas: ${transactions.length}');
                        for (var doc in transactions) {
                          // ignore: avoid_print
                          print('Transacción: ${doc.data()}');
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = filteredTransactions[index].data() as Map<String, dynamic>;
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Theme.of(context).cardColor,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: selectedType == 'Gasto' 
                                            ? Theme.of(context).colorScheme.error.withOpacity(0.2)
                                            : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        selectedType == 'Gasto' ? Icons.remove : Icons.add,
                                        color: selectedType == 'Gasto' ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            transaction['name'] ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Theme.of(context).textTheme.bodyLarge?.color,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            transaction['description'] ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.white70
                                                  : Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Monto: ${transaction['amount'] != null ? transaction['amount'].toString() : ''}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.white
                                                  : Theme.of(context).colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          (() {
                                            final ts = transaction['date'] ?? transaction['timestamp'];
                                            if (ts is Timestamp) {
                                              final d = ts.toDate();
                                              return '${d.day}/${d.month}/${d.year}';
                                            } else if (ts is String) {
                                              final d = DateTime.tryParse(ts);
                                              if (d != null) {
                                                return '${d.day}/${d.month}/${d.year}';
                                              }
                                            } else if (ts is DateTime) {
                                              return '${ts.day}/${ts.month}/${ts.year}';
                                            }
                                            return '';
                                          })(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white70
                                                : Colors.black54,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.delete, color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.error),
                                              onPressed: () => _deleteTransaction(filteredTransactions[index].id),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) => EditTransactionDialog(
                                                    transaction: transaction,
                                                    transactionId: filteredTransactions[index].id,
                                                    categories: _allCategories,
                                                    onUpdate: (id, data, ctx) async {
                                                      await _expenseController.updateTransaction(id, data, ctx);
                                                      setState(() {});
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditTransactionDialog extends StatefulWidget {
  final Map<String, dynamic> transaction;
  final String transactionId;
  final List<String> categories;
  final void Function(String, Map<String, dynamic>, BuildContext) onUpdate;

  const EditTransactionDialog({
    super.key,
    required this.transaction,
    required this.transactionId,
    required this.categories,
    required this.onUpdate,
  });

  @override
  State<EditTransactionDialog> createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<EditTransactionDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController amountController;
  late String selectedCategory;
  late String selectedType;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.transaction['name'] ?? '');
    descriptionController = TextEditingController(text: widget.transaction['description'] ?? '');
    amountController = TextEditingController(text: widget.transaction['amount']?.toString() ?? '');
    selectedCategory = widget.transaction['category'] ?? (widget.categories.isNotEmpty ? widget.categories.first : '');
    selectedType = widget.transaction['type'] ?? 'Gasto';
    final ts = widget.transaction['date'] ?? widget.transaction['timestamp'];
    if (ts is Timestamp) {
      selectedDate = ts.toDate();
    } else if (ts is String) {
      selectedDate = DateTime.tryParse(ts) ?? DateTime.now();
    } else if (ts is DateTime) {
      selectedDate = ts;
    } else {
      selectedDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Transacción'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monto'),
            ),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: widget.categories.map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Categoría'),
            ),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: ['Gasto', 'Ingreso'].map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Fecha'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                    const Icon(Icons.calendar_today, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedData = {
              'name': nameController.text.trim(),
              'description': descriptionController.text.trim(),
              'amount': double.tryParse(amountController.text.trim()) ?? 0.0,
              'category': selectedCategory,
              'type': selectedType,
              'date': selectedDate,
            };
            widget.onUpdate(widget.transactionId, updatedData, context);
            Navigator.of(context).pop();
          },
          child: const Text('Actualizar'),
        ),
      ],
    );
  }
}