import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartService {
  // মাসিক বিক্রির বার চার্ট উইজেট
  static Widget buildSalesChart(List<double> monthlySales) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: monthlySales.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value,
                color: Colors.blue,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
