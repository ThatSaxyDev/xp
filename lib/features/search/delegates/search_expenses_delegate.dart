import 'package:exptrak/models/expense.dart';
import 'package:exptrak/realm.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/app_elements/app_constants.dart';
import 'package:exptrak/shared/app_elements/app_texts.dart';
import 'package:exptrak/shared/components.dart/category_badge.dart';
import 'package:exptrak/shared/extensions/expense_extensions.dart';
import 'package:exptrak/shared/extensions/number_extensions.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:realm/realm.dart';

import '../../../shared/components.dart/expense_row.dart';
import '../../../theme/palette.dart';

class SearchExpensesDelegate extends SearchDelegate {
  SearchExpensesDelegate()
      : super(
          searchFieldLabel: 'Search expense notes...',
          searchFieldStyle: TextStyle(
            fontSize: 15.sp,
          ),
        );

  List<Expense> expenses = realm.all<Expense>().toList();

  // void searchExpense(String query) {
  //   final expenseSuggestions = expenses.where((expense) {
  //     final expenseNote = expense.note!.toLowerCase();
  //     final input = query.toLowerCase();

  //     return expenseNote.contains(input);
  //   }).toList();

  //   expenses = expenseSuggestions;
  // }

  @override
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(PhosphorIcons.x),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = expenses
        .where(
          (expense) => expense.note!.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          // leading: CircleAvatar(
          //   radius: 15.w,
          //   backgroundColor: expense.category!.color,
          // ),
          title: Text(
            results[index].note!,
            style: TextStyle(color: results[index].category!.color),
          ),
          onTap: () {},
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? []
        : expenses
            .where(
              (expense) => expense.note!.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();

    return suggestions.isEmpty
        ? Center(
            child: Icon(
            PhosphorIcons.magnifyingGlassBold,
            color: AppColors.grey,
            size: 150.w,
          )
                .animate()
                .shimmer(delay: 2000.ms, duration: 1800.ms) // shimmer +
                .shake(hz: 4, curve: Curves.easeInOutCubic) // shake +
            )
        : ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return Consumer(
                builder: (context, ref, child) {
                  final currenTheme = ref.watch(themeNotifierProvider);

                  return Container(
                    margin:
                        EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w, top: 14.h),
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: currenTheme.textTheme.bodyText2!.color!,
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.yMMMEd().format(suggestions[index].date),
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
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 250.w,
                                  child: Text(
                                    suggestions[index].note ?? 'Unknown',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17.sp,
                                      color: currenTheme
                                          .textTheme.bodyText2!.color!,
                                    ),
                                  ),
                                ),
                                Text(
                                  'NGN ${suggestions[index].amount.toStringAsFixed(0)}',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CategoryBadge(
                                      category: suggestions[index].category),
                                  Text(
                                    DateFormat.Hm()
                                        .format(suggestions[index].date),
                                    style: const TextStyle(
                                      color: CupertinoColors.inactiveGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spc(h: 7.h),
                        // Divider(
                        //   thickness: 1,
                        //   color: currenTheme.textTheme.bodyText2!.color!,
                        // ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     const Expanded(
                        //       child: Text(
                        //         "Total:",
                        //         style: TextStyle(
                        //           color: CupertinoColors.inactiveGray,
                        //         ),
                        //       ),
                        //     ),
                        //     Text(
                        //       "NGN ${expenses.sum().removeDecimalZeroFormat()}",
                        //       style: TextStyle(
                        //         color: currenTheme.textTheme.bodyText2!.color,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  );
                },
              );
            },
          );
  }
}


// color: suggestions[index]
//                                 .category
//                                 ?.color
//                                 .withOpacity(0.27) ??
//                             currenTheme.textTheme.bodyText2!.color,
