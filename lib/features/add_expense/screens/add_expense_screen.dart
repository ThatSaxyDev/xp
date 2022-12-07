import 'dart:async';

import 'package:exptrak/models/category.dart';
import 'package:exptrak/realm.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/app_elements/app_constants.dart';
import 'package:exptrak/shared/app_elements/app_texts.dart';
import 'package:exptrak/shared/app_elements/app_utils.dart';
import 'package:exptrak/shared/types/recurrence.dart';
import 'package:exptrak/shared/utils/picker.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/shared/widgets/text_input.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:realm/realm.dart';

import '../../../models/expense.dart';

var recurrences = List.from(Recurrence.values);

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
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
            _selectedDate.add(const Duration(hours: 1)),
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
        appBar: AppBar(
          backgroundColor: currenTheme.backgroundColor,
          title: Text(
            'Add Expense',
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w700,
              color: currenTheme.textTheme.bodyText2!.color!,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                // amount input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount 🤑',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spc(h: 10.h),
                    TextInputBox(
                      textColor: AppColors.black,
                      onChanged: (value) {
                        setState(() => canSubmit =
                            categories.isNotEmpty && value.isNotEmpty);
                      },
                      height: 56.h,
                      hintText: '0',
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                    ),
                  ],
                ),

                Spc(h: 20.h),
                // note
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Note 📝',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spc(h: 10.h),
                    TextInputBox(
                      textColor: AppColors.black,
                      hintText: 'Type a note',
                      controller: _noteController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ],
                ),

                Spc(h: 20.h),

                SizedBox(
                  height: 95,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // category
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category 🤔',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spc(h: 10.h),
                          InkWell(
                            onTap: () => categories.isNotEmpty
                                ? showPicker(
                                    context,
                                    CupertinoPicker(
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem:
                                                  _selectedCategoryIndex),
                                      magnification: 1,
                                      squeeze: 1.2,
                                      useMagnifier: false,
                                      itemExtent: kItemExtent,
                                      // This is called when selected item is changed.
                                      onSelectedItemChanged:
                                          (int selectedItem) {
                                        setState(() {
                                          _selectedCategoryIndex = selectedItem;
                                        });
                                      },
                                      children: List<Widget>.generate(
                                          categories.length, (int index) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 64.w,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                  width: 12,
                                                  height: 12,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 8, 0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        categories[index].color,
                                                    shape: BoxShape.circle,
                                                  )),
                                              Expanded(
                                                child: Text(
                                                  categories[index].name,
                                                  style: const TextStyle(
                                                    fontFamily: 'Sk-Modernist',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  )
                                : null,
                            child: Container(
                              height: 56.h,
                              width: 160.w,
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              decoration: BoxDecoration(
                                color: AppColors.textFillGrey,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      categories.isEmpty
                                          ? "Create a category in settings first"
                                          : categories[_selectedCategoryIndex]
                                              .name,
                                      style: TextStyle(
                                        overflow: TextOverflow.fade,
                                        color: categories.isEmpty
                                            ? AppColors.grey.withOpacity(0.7)
                                            : categories[_selectedCategoryIndex]
                                                .color,
                                        fontFamily: 'Sk-Modernist',
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down_sharp,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // recurrence
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recurrence 🔁',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spc(h: 10.h),
                          InkWell(
                            onTap: () => showPicker(
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
                                children: List<Widget>.generate(
                                    recurrences.length, (int index) {
                                  return Center(
                                    child: Text(
                                      recurrences[index],
                                      style: const TextStyle(
                                        fontFamily: 'Sk-Modernist',
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            child: Container(
                              height: 56.h,
                              width: 150,
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              decoration: BoxDecoration(
                                color: AppColors.textFillGrey,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    recurrences[_selectedRecurrenceIndex],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down_sharp,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Spc(h: 20.h),
                // date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date 📆',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spc(h: 10.h),
                    InkWell(
                      onTap: () => showPicker(
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
                      child: Container(
                        height: 56.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        decoration: BoxDecoration(
                          color: AppColors.textFillGrey,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}  ${_selectedDate.hour}:${_selectedDate.minute}',
                              style: const TextStyle(
                                color: AppColors.black,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down_sharp,
                              color: AppColors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Spc(h: 20.h),
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
              ],
            ),
          ),
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
