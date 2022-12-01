import 'dart:developer';

import 'package:exptrak/features/settings/screens/categories_screen.dart';
import 'package:exptrak/features/settings/screens/report_screen.dart';
import 'package:exptrak/models/category.dart';
import 'package:exptrak/models/expense.dart';
import 'package:exptrak/realm.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/app_elements/app_images.dart';
import 'package:exptrak/shared/utils/alert_dialog.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      // backgroundColor: AppColors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: currenTheme.backgroundColor,
        title: Text(
          'Settings',
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
              Column(
                children: items
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          switch (e.label) {
                            case 'Categories':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoriesScreen(),
                                ),
                              );
                              break;

                            case 'Report a bug':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ReportABugScreen(),
                                ),
                              );
                              break;

                            case 'Erase all data':
                              showAlertDialog(
                                context,
                                () {
                                  realm.write(() {
                                    realm.deleteAll<Expense>();
                                    realm.deleteAll<Category>();
                                  });
                                },
                                "Are you sure?",
                                "This action cannot be undone.",
                                "Erase data",
                              );
                              break;
                          }
                        },
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: AppColors.grey)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.label,
                                style: TextStyle(
                                  color: e.isDestructive
                                      ? AppColors.primaryRed
                                      : currenTheme.textTheme.bodyText2!.color!,
                                  fontSize: 20.sp,
                                ),
                              ),
                              e.isDestructive
                                  ? const SizedBox()
                                  : const Icon(
                                      PhosphorIcons.caretRight,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Spc(h: 58.h),
              Container(
                height: 50.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                     top: BorderSide(color: AppColors.grey),
                    bottom: BorderSide(color: AppColors.grey),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        color: currenTheme.textTheme.bodyText2!.color!,
                        fontSize: 20.sp,
                      ),
                    ),
                    Switch.adaptive(
                      value: ref.watch(themeNotifierProvider.notifier).mode ==
                          ThemeMode.dark,
                      onChanged: (val) => toggleTheme(ref),
                    ),
                  ],
                ),
              ),
              Spc(h: 100.h),
              SizedBox(
                height: 150.h,
                width: 150.w,
                child: Image.asset(
                  AppImages.appLogo,
                  color: currenTheme.textTheme.bodyText2!.color,
                ),
              ),
              Text(
                '@kiishidart',
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item {
  final String label;
  final bool isDestructive;

  const Item(this.label, this.isDestructive);
}

const items = [
  Item('Categories', false),
  Item('Report a bug', false),
  Item('Erase all data', true),
];

// void eraseData(BuildContext context) {
//   showDialog(
//       context: context,
//       builder: (BuildContext ctx) {
//         return AlertDialog(
//           title: const Text('Please Confirm'),
//           content: const Text('Are you sure you want to erase all data?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 'Yes',
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 'No',
//               ),
//             ),
//           ],
//         );
//       });
// }
