import 'package:exptrak/models/expense.dart';
import 'package:exptrak/realm.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchExpenseScreen extends ConsumerStatefulWidget {
  const SearchExpenseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchExpenseScreenState();
}

class _SearchExpenseScreenState extends ConsumerState<SearchExpenseScreen> {
  late TextEditingController _textController;
  List<Expense> expenses = realm.all<Expense>().toList();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void searchExpense(String query) {
    final expenseSuggestions = expenses.where((expense) {
      final expenseNote = expense.note!.toLowerCase();
      final input = query.toLowerCase();

      return expenseNote.contains(input);
    }).toList();

    setState(() => expenses = expenseSuggestions);
  }

  @override
  Widget build(BuildContext context) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: currenTheme.backgroundColor,
        title: Text(
          'Search',
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,
            color: currenTheme.textTheme.bodyText2!.color!,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: CupertinoTextField(
              style: TextStyle(
                color: currenTheme.textTheme.bodyText2!.color!,
              ),
              placeholder: "Search for expenses...",
              placeholderStyle: TextStyle(
                fontFamily: 'Sk-Modernist',
                color: currenTheme.textTheme.bodyText2!.color!,
              ),
              controller: _textController,
              onChanged: searchExpense,
            ),
          ),
          SizedBox(
            height: 600.h,
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(
                    expense.note!,
                    style: TextStyle(color: expense.category!.color),
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
