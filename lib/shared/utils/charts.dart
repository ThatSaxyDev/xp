import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

BarChartGroupData makeGroupData(int x, double y, double width, Color color) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: color,
        width: width,
        borderRadius: BorderRadius.circular(6),
      ),
    ],
  );
}