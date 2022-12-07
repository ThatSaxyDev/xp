// import 'package:exptrak/models/expense.dart';
// import 'package:exptrak/realm.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SearchController extends StateNotifier<bool> {
//   SearchController(super.state);

//   Stream<List<Expense>> searchExpenses(String query) {
//     List<Expense> expenses = realm.all<Expense>().toList();
//     final expenseSuggestions = expenses.where((expense) {
//       final expenseNote = expense.note!.toLowerCase();
//       final input = query.toLowerCase();

//       return expenseNote.contains(input);
//     }).toList();

//     final expensesStream = Stream.fromIterable(expenseSuggestions);

//     return expensesStream;
//   }
// }