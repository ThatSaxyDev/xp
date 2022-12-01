import 'package:exptrak/models/expense.dart';
import 'package:exptrak/shared/components.dart/expense_row.dart';
import 'package:exptrak/shared/extensions/date_extensions.dart';
import 'package:exptrak/shared/extensions/expense_extensions.dart';
import 'package:exptrak/shared/extensions/number_extensions.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DayExpenses extends ConsumerWidget {
  final DateTime date;
  final List<Expense> expenses;

  const DayExpenses({
    super.key,
    required this.date,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date.formattedDate,
            style: const TextStyle(
              color: CupertinoColors.inactiveGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spc(h: 7.h),
          Divider(
            thickness: 1,
            color: currenTheme.textTheme.bodyText2!.color!,
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: expenses
                .map((expense) => Container(
                    margin: EdgeInsets.only(top: 12.h),
                    child: ExpenseRow(
                      expense: expense,
                    )))
                .toList(),
          ),
          Spc(h: 7.h),
          Divider(
            thickness: 1,
            color: currenTheme.textTheme.bodyText2!.color!,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                child: Text(
                  "Total:",
                  style: TextStyle(
                    color: CupertinoColors.inactiveGray,
                  ),
                ),
              ),
              Text(
                "NGN ${expenses.sum().removeDecimalZeroFormat()}",
                style: const TextStyle(
                  color: CupertinoColors.inactiveGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
