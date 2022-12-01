import 'package:exptrak/models/expense.dart';
import 'package:exptrak/shared/utils/charts.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:exptrak/shared/extensions/expense_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeeklyChart extends ConsumerWidget {
  final Map<String, List<Expense>> expenses;

  const WeeklyChart({super.key, required this.expenses});

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: CupertinoColors.systemGrey,
      fontSize: 16,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'M';
        break;
      case 1:
        text = 'T';
        break;
      case 2:
        text = 'W';
        break;
      case 3:
        text = 'T';
        break;
      case 4:
        text = 'F';
        break;
      case 5:
        text = 'S';
        break;
      case 6:
        text = 'S';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
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
          barGroups: [
            makeGroupData(
              0,
              expenses["Monday"]?.sum() ?? 0.0,
              39,
              currenTheme.textTheme.bodyText2!.color!,
            ),
            makeGroupData(
              1,
              expenses["Tuesday"]?.sum() ?? 0.0,
              39,
              currenTheme.textTheme.bodyText2!.color!,
            ),
            makeGroupData(
              2,
              expenses["Wednesday"]?.sum() ?? 0.0,
              39,
              currenTheme.textTheme.bodyText2!.color!,
            ),
            makeGroupData(
              3,
              expenses["Thursday"]?.sum() ?? 0.0,
              39,
              currenTheme.textTheme.bodyText2!.color!,
            ),
            makeGroupData(
              4,
              expenses["Friday"]?.sum() ?? 0.0,
              39,
              currenTheme.textTheme.bodyText2!.color!,
            ),
            makeGroupData(
              5,
              expenses["Saturday"]?.sum() ?? 0.0,
              39,
              currenTheme.textTheme.bodyText2!.color!,
            ),
            makeGroupData(
              6,
              expenses["Sunday"]?.sum() ?? 0.0,
              39,
              currenTheme.textTheme.bodyText2!.color!,
            ),
          ],
          titlesData: titlesData,
          gridData: FlGridData(
            show: false,
          ),
        ),
      ),
    );
  }
}
