import 'package:exptrak/models/expense.dart';
import 'package:exptrak/realm.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/app_elements/app_constants.dart';
import 'package:exptrak/shared/app_elements/app_texts.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:realm/realm.dart';

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

                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                      decoration: BoxDecoration(
                        color: suggestions[index]
                                .category
                                ?.color
                                .withOpacity(0.27) ??
                            currenTheme.textTheme.bodyText2!.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        suggestions[index].category?.name ?? "Unknown",
                        style: TextStyle(
                          color: suggestions[index].category?.color ??
                              currenTheme.backgroundColor,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    title: Text(
                      suggestions[index].note!,
                      style: TextStyle(
                        // color: suggestions[index].category!.color,
                        color: currenTheme.textTheme.bodyText2!.color!,
                      ),
                    ),
                    subtitle: Text(
                      '${AppTexts.naira}${suggestions[index].amount}',
                      style: TextStyle(
                          color: AppColors.midPurple, fontSize: 13.sp),
                    ),
                    onTap: () {},
                  );
                },
              );
            },
          );
  }
}
