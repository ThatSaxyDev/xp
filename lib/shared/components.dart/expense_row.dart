import 'package:exptrak/models/expense.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/components.dart/category_badge.dart';
import 'package:exptrak/shared/extensions/date_extensions.dart';
import 'package:exptrak/shared/extensions/number_extensions.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseRow extends ConsumerWidget {
  final Expense expense;

  const ExpenseRow({super.key, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 250.w,
              child: Text(
                expense.note ?? expense.category?.name ?? 'Unknown',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17.sp,
                  color: currenTheme.textTheme.bodyText2!.color!,
                ),
              ),
            ),
            Text(
              "NGN ${expense.amount.removeDecimalZeroFormat()}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17.sp,
                color: AppColors.midPurple,
              ),
            ),
          ],
        ),
        Spc(h: 7.h),
        Container(
          margin: EdgeInsets.only(top: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CategoryBadge(category: expense.category),
              Text(
                expense.date.time,
                style: const TextStyle(
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
