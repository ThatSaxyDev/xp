import 'dart:async';

import 'package:exptrak/features/settings/screens/categories_screen.dart';
import 'package:exptrak/models/category.dart';
import 'package:exptrak/models/expense.dart';
import 'package:exptrak/realm.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/app_elements/app_constants.dart';
import 'package:exptrak/shared/utils/picker.dart';
import 'package:exptrak/shared/types/recurrence.dart';
import 'package:exptrak/shared/utils/utils.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:realm/realm.dart';

var recurrences = List.from(Recurrence.values);

class AddScreen extends ConsumerStatefulWidget {
  const AddScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen> {
  var realmCategories = realm.all<Category>();
  StreamSubscription<RealmResultsChanges<Category>>? _categoriesSub;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late FToast fToast;

  List<Category> categories = [];
  int _selectedRecurrenceIndex = 0;
  int _selectedCategoryIndex = 0;
  DateTime _selectedDate = DateTime.now();
  bool canSubmit = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    _amountController = TextEditingController();
    _noteController = TextEditingController();
    categories = realmCategories.toList();
    canSubmit = categories.isNotEmpty && _amountController.text.isNotEmpty;
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _categoriesSub?.cancel();
  }

  void submitExpense() {
    try {
      realm.write(() => realm.add<Expense>(Expense(
            ObjectId(),
            double.parse(_amountController.value.text),
            _selectedDate,
            category: categories[_selectedCategoryIndex],
            note: _noteController.value.text.isNotEmpty
                ? _noteController.value.text
                : categories[_selectedCategoryIndex].name,
            recurrence: recurrences[_selectedRecurrenceIndex],
          )));

      _showToast(ref);
      setState(() {
        _amountController.clear();
        _selectedRecurrenceIndex = 0;
        _selectedDate = DateTime.now();
        _noteController.clear();
        _selectedCategoryIndex = 0;
      });
    } catch (e) {
      showSnackBar(context, 'Type a valid amount');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currenTheme = ref.watch(themeNotifierProvider);
    _categoriesSub ??= realmCategories.changes.listen((event) {
      categories = event.results.toList();
    });

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // backgroundColor: AppColors.black,
        appBar: AppBar(
          backgroundColor:currenTheme.backgroundColor,
          title: Text(
            'Add Expense',
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w700,
              color: currenTheme.textTheme.bodyText2!.color!,
            ),
          ),
        ),
        body: Column(
          children: [
            //  amount
            CupertinoFormRow(
              prefix: Text(
                "Amount 🤑",
                style: TextStyle(
                  color: currenTheme.textTheme.bodyText2!.color!,
                  fontSize: 18.sp,
                ),
              ),
              helper: null,
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: CupertinoTextField.borderless(
                placeholder: "0",
                placeholderStyle: TextStyle(
                  color: AppColors.grey.withOpacity(0.4),
                  fontSize: 17.sp,
                ),
                controller: _amountController,
                onChanged: (value) {
                  setState(() => canSubmit =
                      categories.isNotEmpty && value.isNotEmpty);
                },
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.end,
                textInputAction: TextInputAction.continueAction,
                style: TextStyle(
                  color: currenTheme.textTheme.bodyText2!.color!,
                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                ),
              ),
            ),

            // recurrence
            CupertinoFormRow(
              prefix: Text(
                "Recurrence 🔁",
                style: TextStyle(
                  color: currenTheme.textTheme.bodyText2!.color!,
                  fontSize: 18.sp,
                ),
              ),
              helper: null,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CupertinoButton(
                onPressed: () => showPicker(
                  context,
                  CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedRecurrenceIndex,
                    ),
                    magnification: 1.2,
                    squeeze: 1.2,
                    useMagnifier: false,
                    itemExtent: kItemExtent,
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItem) {
                      setState(() {
                        _selectedRecurrenceIndex = selectedItem;
                      });
                    },
                    children: List<Widget>.generate(recurrences.length,
                        (int index) {
                      return Center(
                        child: Text(recurrences[index]),
                      );
                    }),
                  ),
                ),
                child: Text(
                  recurrences[_selectedRecurrenceIndex],
                  style: const TextStyle(
                    color: AppColors.purple,
                  ),
                ),
              ),
            ),

            // date
            CupertinoFormRow(
              prefix: Text(
                "Date 📆",
                style: TextStyle(
                  color: currenTheme.textTheme.bodyText2!.color!,
                  fontSize: 18.sp,
                ),
              ),
              helper: null,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CupertinoButton(
                onPressed: () => showPicker(
                  context,
                  CupertinoDatePicker(
                    initialDateTime: _selectedDate,
                    mode: CupertinoDatePickerMode.dateAndTime,
                    use24hFormat: true,
                    // This is called when the user changes the time.
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() => _selectedDate = newTime);
                    },
                  ),
                ),
                child: Text(
                  '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year} ${_selectedDate.hour}:${_selectedDate.minute}',
                  style: const TextStyle(
                    color: AppColors.purple,
                  ),
                ),
              ),
            ),

            // note
            CupertinoFormRow(
              prefix: Text(
                "Note 📝",
                style: TextStyle(
                  color: currenTheme.textTheme.bodyText2!.color!,
                  fontSize: 18.sp,
                ),
              ),
              helper: null,
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: CupertinoTextField.borderless(
                placeholder: "Keep it short",
                placeholderStyle: TextStyle(
                  color: AppColors.grey.withOpacity(0.4),
                  fontSize: 17.sp,
                ),
                controller: _noteController,
                textAlign: TextAlign.end,
                textInputAction: TextInputAction.continueAction,
                style: TextStyle(
                  color: currenTheme.textTheme.bodyText2!.color!,
                  backgroundColor: Color.fromARGB(0, 0, 0, 0),
                ),
              ),
            ),

            // category
            CupertinoFormRow(
              prefix: Text(
                "Category 🤔",
                style: TextStyle(
                  color: currenTheme.textTheme.bodyText2!.color!,
                  fontSize: 18.sp,
                ),
              ),
              helper: null,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CupertinoButton(
                onPressed: () => categories.isNotEmpty ? showPicker(
                  context,
                  CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: _selectedCategoryIndex),
                    magnification: 1,
                    squeeze: 1.2,
                    useMagnifier: false,
                    itemExtent: kItemExtent,
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItem) {
                      setState(() {
                        _selectedCategoryIndex = selectedItem;
                      });
                    },
                    children: List<Widget>.generate(categories.length,
                        (int index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 64),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: 12,
                                height: 12,
                                margin:
                                    const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                decoration: BoxDecoration(
                                  color: categories[index].color,
                                  shape: BoxShape.circle,
                                )),
                            Text(categories[index].name),
                          ],
                        ),
                      );
                    }),
                  ),
                ) : null,
                child: Text(
                  categories.isEmpty
                      ? "Create a category first"
                      : categories[_selectedCategoryIndex].name,
                  style: TextStyle(
                    color: categories.isEmpty
                        ? AppColors.grey.withOpacity(0.7)
                        : categories[_selectedCategoryIndex].color,
                  ),
                ),
              ),
            ),

            // button
            Container(
              margin: const EdgeInsets.only(top: 32),
              child: CupertinoButton(
                onPressed: canSubmit ? submitExpense : null,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 13),
                color: AppColors.midPurple,
                disabledColor: AppColors.midPurple.withOpacity(0.35),
                borderRadius: BorderRadius.circular(10),
                pressedOpacity: 0.7,
                child: Text(
                  "Add expense",
                  style: TextStyle(
                    color: canSubmit
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(100, 255, 255, 255),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Spc(h: 60.h),
          ],
        ),
      ),
    );
  }

  _showToast(WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: currentTheme.textTheme.bodyText2!.color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            color: currentTheme.backgroundColor,
          ),
          SizedBox(
            width: 12.w,
          ),
          Text(
            "Expense added",
            style: TextStyle(
              color: currentTheme.backgroundColor,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            top: 100.h,
            left: 100.w,
            child: child,
          );
        });
  }
}
