import 'package:exptrak/features/auth/screens/confirm_old_pin_screen.dart';
import 'package:exptrak/features/auth/screens/tap_to_create_pin_screen.dart';
import 'package:exptrak/features/auth/widgets/enable_biometrics_modal.dart';
import 'package:exptrak/features/settings/screens/categories_screen.dart';
import 'package:exptrak/features/settings/screens/change_pin_screen.dart';
import 'package:exptrak/models/category.dart';
import 'package:exptrak/models/expense.dart';
import 'package:exptrak/realm.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/app_elements/app_images.dart';
import 'package:exptrak/shared/utils/alert_dialog.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenTheme = ref.watch(themeNotifierProvider);
    final navigator = Navigator.of(context);
    return Scaffold(
      // backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: currenTheme.backgroundColor,
        centerTitle: true,
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

                            case 'Change pin':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ConfirmOldPinScreen(),
                                ),
                              );
                              break;

                            case 'Enable biometrics':
                              showModalBottomSheet<void>(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.r),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return EnableLocalAuthModalBottomSheet(
                                    yes: () async {
                                      HapticFeedback.mediumImpact();
                                      final SharedPreferences pref =
                                          await SharedPreferences.getInstance();

                                      pref.setBool('biometricEnabled', true);
                                    },
                                    no: () async {
                                      HapticFeedback.mediumImpact();
                                      final SharedPreferences pref =
                                          await SharedPreferences.getInstance();

                                      pref.setBool('biometricEnabled', false);
                                    },
                                  );
                                },
                              );
                              break;

                            case 'Erase all data':
                              showAlertDialog(
                                context,
                                () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove('pin');
                                  prefs.remove('showHome');
                                  prefs.remove('biometricEnabled');
                                  realm.write(() {
                                    realm.deleteAll<Expense>();
                                    realm.deleteAll<Category>();
                                  });
                                  navigator.pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TapToCreatePinScreen(),
                                      ),
                                      (route) => false);
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
                'kiishidart©',
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
  Item('Change pin', false),
  Item('Enable biometrics', false),
  Item('Erase all data', true),
];
