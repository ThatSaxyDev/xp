import 'dart:developer';

import 'package:exptrak/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportABugScreen extends ConsumerStatefulWidget {
  const ReportABugScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReportABugScreenState();
}

class _ReportABugScreenState extends ConsumerState<ReportABugScreen> {
  @override
  Widget build(BuildContext context) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      // backgroundColor: AppColors.black,
      appBar: AppBar(
        // backgroundColor: AppColors.black,
        title: Text(
          'Report',
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,
            color: currenTheme.textTheme.bodyText2!.color,
          ),
        ),
      ),

      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            log('show home pref set to false');
            final SharedPreferences pref =
                await SharedPreferences.getInstance();

            pref.setBool('showHome', false);
          },
          child: Text('Set prefs to false'),
        ),
      ),
    );
  }
}
