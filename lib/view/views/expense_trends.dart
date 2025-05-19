import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_wallet/controller/expense_controller.dart';
import 'dart:math';

class ExpenseTrends extends StatefulWidget {
  const ExpenseTrends({super.key});

  @override
  State<ExpenseTrends> createState() => _ExpenseTrendsState();
}

class _ExpenseTrendsState extends State<ExpenseTrends> {
  final ExpenseController _expenseController = ExpenseController();
  Map<String, List<double>> _categoryTrends = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrends();
  }

  Future<void> _fetchTrends() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final trends = await _expenseController.getExpenseTrends(user.uid);
        setState(() {
          _categoryTrends = trends;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar las tendencias: $e')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final totalPerCategory = <String, double>{};
    for (var entry in _categoryTrends.entries) {
      totalPerCategory[entry.key] = entry.value.fold(0.0, (sum, item) => sum + item);
    }

    final total = totalPerCategory.values.fold(0.0, (sum, item) => sum + item);
    // ignore: unused_local_variable
    final random = Random();
    int index = 0;

    return totalPerCategory.entries.map((entry) {
      final percentage = total == 0 ? 0 : (entry.value / total * 100).round();
      return PieChartSectionData(
        color: Colors.primaries[index++ % Colors.primaries.length],
        value: entry.value,
        title: '$percentage%',
        radius: 100,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Widget _buildLegend() {
    // 
    // ignore: unused_local_variable
    final random = Random();
    int index = 0;

    return Column(
      children: _categoryTrends.keys.map((category) {
        final color = Colors.primaries[index++ % Colors.primaries.length];
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(category, style: const TextStyle(fontSize: 24)),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_categoryTrends.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          title: const Text('Tendencias de Gastos'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/home');
            },
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
        ),
        body: const Center(
          child: Text('No hay datos disponibles para mostrar.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          title: const Text('Tendencias de Gastos'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/home');
            },
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegend(),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: PieChart(
                PieChartData(
                  sections: _buildPieChartSections(),
                  centerSpaceRadius: 50,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
