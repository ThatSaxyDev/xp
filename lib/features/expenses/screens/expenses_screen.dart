import 'dart:async';

import 'package:collection/collection.dart';
import 'package:exptrak/features/search/delegates/search_expenses_delegate.dart';
import 'package:exptrak/models/expense.dart';
import 'package:exptrak/realm.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/app_elements/app_constants.dart';
import 'package:exptrak/shared/app_elements/app_texts.dart';
import 'package:exptrak/shared/components.dart/expenses_list.dart';
import 'package:exptrak/shared/extensions/expense_extensions.dart';
import 'package:exptrak/shared/extensions/number_extensions.dart';
import 'package:exptrak/shared/types/period.dart';
import 'package:exptrak/shared/utils/picker.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:realm/realm.dart';
import 'package:unicons/unicons.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  int _selectedPeriodIndex = 1;
  Period get _selectedPeriod => periods[_selectedPeriodIndex];

  var realmExpenses = realm.all<Expense>();
  StreamSubscription<RealmResultsChanges<Expense>>? _expensesSub;
  List<Expense> _expenses = [];

  double get _total => _expenses.map((expense) => expense.amount).sum;

  @override
  void initState() {
    super.initState();
    _expenses = realmExpenses.toList().filterByPeriod(_selectedPeriod, 0)[0];
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _expensesSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: currenTheme.backgroundColor,
        centerTitle: true,
        title: Text(
          'Expenses',
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,
            color: currenTheme.textTheme.bodyText2!.color!,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchExpensesDelegate());
            },
            icon: const Icon(UniconsLine.search),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spc(h: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total for: ",
                style: TextStyle(
                  color: currenTheme.textTheme.bodyText2!.color!,
                ),
              ),
              CupertinoButton(
                onPressed: () => showPicker(
                  context,
                  CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: _selectedPeriodIndex),
                    magnification: 1,
                    squeeze: 1.2,
                    useMagnifier: false,
                    itemExtent: kItemExtent,
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItem) {
                      setState(() {
                        _selectedPeriodIndex = selectedItem;
                        _expenses = realmExpenses.toList().filterByPeriod(
                            periods[_selectedPeriodIndex], 0)[0];
                      });
                    },
                    children:
                        List<Widget>.generate(periods.length, (int index) {
                      return Center(
                        child: Text(
                          getPeriodDisplayName(periods[index]),
                          style: const TextStyle(fontFamily: 'Sk-Modernist'),
                        ),
                      );
                    }),
                  ),
                ),
                child: Container(
                  height: 25,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.midPurple,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      getPeriodDisplayName(_selectedPeriod),
                      style: TextStyle(
                          color: currenTheme.backgroundColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 4, 4, 0),
                child: Text(AppTexts.naira,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: CupertinoColors.inactiveGray,
                    )),
              ),
              Text(
                _total.removeDecimalZeroFormat(),
                style: TextStyle(
                  fontSize: 40.sp,
                  color: currenTheme.textTheme.bodyText2!.color!,
                ),
              ),
            ],
          ),
          _expenses.isNotEmpty
              ? Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 0),
                    child: ExpensesList(expenses: _expenses),
                  ),
                )
              : Expanded(
                  // height: 600,
                  // margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 230.h,
                          child: Lottie.asset(
                            'lib/assets/lottie/empty.json',
                            repeat: false,
                          ),
                        ),
                        Text(
                          "No expenses yet",
                          style: TextStyle(
                            color: currenTheme.textTheme.bodyText2!.color!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
