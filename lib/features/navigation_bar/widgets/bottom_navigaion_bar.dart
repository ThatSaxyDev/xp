import 'package:exptrak/features/add_expense/screens/add_expense_screen.dart';
import 'package:exptrak/features/expenses/screens/expenses_screen.dart';
import 'package:exptrak/features/navigation_bar/icons/nav_bar_item.dart';
import 'package:exptrak/features/reports/screens/reports_screen.dart';
import 'package:exptrak/features/settings/screens/settings_acreen.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicons/unicons.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  int _page = 0;
  final PageController controller = PageController();

  List<Widget> pages = [
    const ExpensesScreen(),
    const ReportsScreen(),
    const AddExpenseScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: pages,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      // body: pages[_page],
      bottomNavigationBar: Material(
        elevation: 0,
        color: currenTheme.backgroundColor,
        child: SizedBox(
          height: 83.h,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 36.w, right: 36.w, top: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // home
                NavBarItem(
                  onTap: () {
                    controller.jumpToPage(0);
                    setState(() {
                      _page = 0;
                    });
                  },
                  icon: UniconsLine.money_stack,
                  color: _page == 0 ? AppColors.midPurple : AppColors.grey,
                ),

                // transfer
                NavBarItem(
                  onTap: () {
                    controller.jumpToPage(1);
                    setState(() {
                      _page = 1;
                    });
                  },
                  icon: UniconsLine.graph_bar,
                  color: _page == 1 ? AppColors.midPurple : AppColors.grey,
                ),

                // history
                NavBarItem(
                  onTap: () {
                    controller.jumpToPage(2);
                    setState(() {
                      _page = 2;
                    });
                  },
                  icon: UniconsLine.plus_circle,
                  color: _page == 2 ? AppColors.midPurple : AppColors.grey,
                ),

                // settings
                NavBarItem(
                  onTap: () {
                    controller.jumpToPage(3);
                    setState(() {
                      _page = 3;
                    });
                  },
                  icon: UniconsLine.setting,
                  color: _page == 3 ? AppColors.midPurple : AppColors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
