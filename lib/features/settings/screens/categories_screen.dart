import 'dart:async';

import 'package:exptrak/models/category.dart';
import 'package:exptrak/realm.dart';
// import 'package:exptrak/models/category.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/utils/alert_dialog.dart';
import 'package:exptrak/shared/utils/utils.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);
  List<Category> categories = [];

  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    categories = realm.all<Category>().toList();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void createCategory() {
    try {
      if (_textController.text.isNotEmpty) {
        var newCategory = realm.write<Category>(
            () => realm.add(Category(_textController.text, pickerColor.value)));
        setState(() => categories.add(newCategory));
        _textController.clear();
      } else {
        showSnackBar(context, 'Type a category name');
      }
    } catch (e) {
      showSnackBar(context, 'Category exists already! 😗');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      // backgroundColor: AppColors.black,
      appBar: AppBar(
        // backgroundColor: AppColors.black,
        title: Text(
          'Categories',
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,
            color: currenTheme.textTheme.bodyText2!.color!,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            categories.isNotEmpty
                ? Expanded(
                    child: Column(
                      children: [
                        ...List.generate(
                          categories.length,
                          (index) => GestureDetector(
                            onTap: () {},
                            child: Dismissible(
                              key: Key(categories[index].name),
                              confirmDismiss: (_) {
                                var confirmer = Completer<bool>();
                                showAlertDialog(
                                  context,
                                  () {
                                    confirmer.complete(true);
                                  },
                                  "Are you sure?",
                                  "This action cannot be undone.",
                                  "Delete ${categories[index].name} category",
                                  cancellationCallback: () {
                                    confirmer.complete(false);
                                  },
                                );

                                return confirmer.future;
                              },
                              onDismissed: (_) {
                                setState(() {
                                  realm.write(
                                      () => realm.delete(categories[index]));
                                  categories.removeAt(index);
                                });
                              },
                              background: Container(
                                color: AppColors.primaryRed,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16),
                                child: const Icon(
                                  PhosphorIcons.trash,
                                  color: AppColors.neutralWhite,
                                ),
                              ),
                              child: Container(
                                height: 50.h,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: AppColors.grey)),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 10.w,
                                      backgroundColor: categories[index].color,
                                    ),
                                    Spc(
                                      w: 20.w,
                                    ),
                                    Expanded(
                                      child: Text(
                                        categories[index].name,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: currenTheme
                                              .textTheme.bodyText2!.color!,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        children: [
                          // Lottie.asset('lib/assets/lottie/empty.json'),
                          Spc(h: 40.h),
                          Text(
                            "No categories yet!",
                            style: TextStyle(
                              color: currenTheme.textTheme.bodyText2!.color!,
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            const Spacer(),
            Container(
              margin: EdgeInsets.only(bottom: 20.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('Pick a category color'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              color: pickerColor,
                              onColorChanged: changeColor,
                              heading: const Text('Select color'),
                              subheading: const Text('Select color shade'),
                              wheelSubheading:
                                  const Text('Selected color and its shades'),
                              pickersEnabled: const <ColorPickerType, bool>{
                                ColorPickerType.primary: true,
                                ColorPickerType.accent: true,
                                ColorPickerType.custom: true,
                                ColorPickerType.wheel: true,
                              },
                            ),
                          ),
                          actions: <Widget>[
                            CupertinoButton(
                              child: const Text('Got it'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                        width: 30.w,
                        height: 30.h,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: pickerColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              width: 2),
                        )),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: CupertinoTextField(
                        style: TextStyle(
                          color: currenTheme.textTheme.bodyText2!.color!,
                        ),
                        placeholder: "Category name",
                        placeholderStyle: TextStyle(
                          color: currenTheme.textTheme.bodyText2!.color!,
                          fontFamily: 'Sk-Modernist'
                        ),
                        controller: _textController,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.midPurple),
                    onPressed: createCategory,
                    child: const Icon(
                      PhosphorIcons.paperPlaneTilt,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
