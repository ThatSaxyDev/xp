import 'dart:async';

import 'package:exptrak/features/reports/widgets/charts/monthly_charts.dart';
import 'package:exptrak/features/reports/widgets/charts/yearly_charts.dart';
import 'package:exptrak/realm.dart';
import 'package:exptrak/shared/components.dart/expenses_list.dart';
import 'package:exptrak/shared/extensions/date_extensions.dart';
import 'package:exptrak/shared/extensions/expense_extensions.dart';
import 'package:exptrak/shared/extensions/number_extensions.dart';
import 'package:exptrak/models/expense.dart';
import 'package:exptrak/shared/app_elements/app_constants.dart';
import 'package:exptrak/shared/utils/picker.dart';
import 'package:exptrak/shared/types/period.dart';
import 'package:exptrak/features/reports/widgets/charts/weekly_charts.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:realm/realm.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with AutomaticKeepAliveClientMixin {
  final PageController _controller = PageController(initialPage: 0);
  set _currentPage(int value) {
    setStateValues(value);
  }

  double _spentInPeriod = 0;
  double _avgPerDay = 0;

  StreamSubscription<RealmResultsChanges<Expense>>? _expensesSub;
  var realmExpenses = realm.all<Expense>();
  List<Expense> _expenses = [];

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int get _numberOfPages {
    switch (periods[_selectedPeriodIndex]) {
      case Period.day:
        return 365; // not used
      case Period.week:
        return 53;
      case Period.month:
        return 12;
      case Period.year:
        return 1;
    }
  }

  int _periodIndex = 1;
  int get _selectedPeriodIndex => _periodIndex;
  set _selectedPeriodIndex(int value) {
    _periodIndex = value;
    setStateValues(0);
    _controller.jumpToPage(0);
  }

  @override
  void initState() {
    super.initState();
    setStateValues(0);
  }

  void setStateValues(int page) {
    var filterResults = realmExpenses
        .toList()
        .filterByPeriod(periods[_selectedPeriodIndex], page);

    var expenses = filterResults[0] as List<Expense>;
    var start = filterResults[1] as DateTime;
    var end = filterResults[2] as DateTime;
    var numOfDays = end.difference(start).inDays;

    setState(() {
      _expenses = expenses;
      _startDate = start;
      _endDate = end;
      _spentInPeriod = expenses.sum();
      _avgPerDay = _spentInPeriod / numOfDays;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currenTheme = ref.watch(themeNotifierProvider);
    _expensesSub ??= realmExpenses.changes.listen((changes) {
      setStateValues(_controller.page!.toInt());
    });

    return Scaffold(
      // backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: currenTheme.backgroundColor,
        centerTitle: true,
        title: Text(
          'Reports',
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,
            color: currenTheme.textTheme.bodyText2!.color!,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => showPicker(
              context,
              CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: _selectedPeriodIndex - 1,
                ),
                magnification: 1,
                squeeze: 1.2,
                useMagnifier: false,
                itemExtent: kItemExtent,
                // This is called when selected item is changed.
                onSelectedItemChanged: (int selectedItem) {
                  setState(() {
                    _selectedPeriodIndex = selectedItem + 1;
                  });
                },
                children:
                    List<Widget>.generate(periods.length - 1, (int index) {
                  return Center(
                    child: Text(periods[index + 1].name),
                  );
                }),
              ),
            ),
            icon: const Icon(
              PhosphorIcons.calendar,
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (newPage) => _currentPage = newPage,
        itemCount: _numberOfPages,
        reverse: true,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_startDate.shortDate} - ${_endDate.shortDate}",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: currenTheme.textTheme.bodyText2!.color!,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const Text(
                                "NGN ",
                                style: TextStyle(
                                  color: CupertinoColors.inactiveGray,
                                ),
                              ),
                              Text(
                                _spentInPeriod.removeDecimalZeroFormat(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Avg/day",
                          style: TextStyle(
                            fontSize: 20,
                            color: currenTheme.textTheme.bodyText2!.color!,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const Text(
                                "NGN ",
                                style: TextStyle(
                                  color: CupertinoColors.inactiveGray,
                                ),
                              ),
                              Text(
                                _avgPerDay.removeDecimalZeroFormat(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                (() {
                  switch (_selectedPeriodIndex) {
                    case 1:
                      return WeeklyChart(expenses: _expenses.groupWeekly());
                    case 2:
                      return MonthlyChart(
                        expenses: _expenses,
                        startDate: _startDate,
                        endDate: _endDate,
                      );
                    case 3:
                      return YearlyChart(expenses: _expenses);
                    default:
                      return const Text("");
                  }
                }()),
                (() {
                  if (_expenses.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 230.h,
                          child: Lottie.asset(
                            'lib/assets/lottie/empty.json',
                            repeat: false,
                          ),
                        ),
                        Text(
                          "No data for selected period!",
                          style: TextStyle(
                            color: currenTheme.textTheme.bodyText2!.color!,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Expanded(
                      child: ExpensesList(
                        expenses: _expenses,
                      ),
                    );
                  }
                }()),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
