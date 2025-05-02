import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseTrends extends StatelessWidget {
  final List<FlSpot> data = const [
    FlSpot(0, 20),
    FlSpot(1, 30),
    FlSpot(2, 40),
    FlSpot(3, 25),
    FlSpot(4, 50),
  ];

  const ExpenseTrends({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: 4,
        minY: 0,
        maxY: 60,
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
          ),
        ],
      ),
    );
  }
}
