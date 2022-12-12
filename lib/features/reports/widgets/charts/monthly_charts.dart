import 'package:exptrak/models/expense.dart';
import 'package:exptrak/shared/extensions/expense_extensions.dart';
import 'package:exptrak/shared/utils/charts.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlyChart extends ConsumerWidget {
  final List<Expense> expenses;
  final DateTime startDate;
  final DateTime endDate;

  const MonthlyChart(
      {super.key,
      required this.expenses,
      required this.startDate,
      required this.endDate});

  Map<int, List<Expense>> get groupedExpenses =>
      expenses.groupMonthly(startDate);

  Widget getTitles(double value, TitleMeta meta) {
    if (value % 5 != 0) {
      return Container();
    }

    const style = TextStyle(
      color: CupertinoColors.systemGrey,
      fontSize: 16,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text("${value.toInt()}", style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 55,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 32.h),
      height: 147.h,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(
            border: Border(
              left: BorderSide(
                color: currenTheme.textTheme.bodyText2!.color!,
              ),
              bottom: BorderSide(
                color: currenTheme.textTheme.bodyText2!.color!,
              ),
            ),
          ),
          barGroups: List.generate(
              groupedExpenses.length,
              (index) => makeGroupData(
                    index,
                    groupedExpenses[index]?.sum() ?? 0.0,
                    6,
                    currenTheme.textTheme.bodyText2!.color!,
                  )),
          titlesData: titlesData,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
          ),
        ),
      ),
    );
  }
}
