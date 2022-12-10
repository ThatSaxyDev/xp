// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EnableLocalAuthModalBottomSheet extends ConsumerWidget {
  final void Function() yes;
  final void Function() no;

  const EnableLocalAuthModalBottomSheet({
    Key? key,
    required this.yes,
    required this.no,
  }) : super(key: key);

  static const Color primaryColor = Color(0xFF13B5A2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Container(
      height: 250.h,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 50.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 4.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: currentTheme.textTheme.bodyText2!.color,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          Spc(h: 30.h),
          Text(
            'Enable biometrics?',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
          ),
          Spc(h: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  no();
                  Navigator.pop(context);
                },
                child: Icon(
                  PhosphorIcons.x,
                  size: 60.sp,
                  color: AppColors.primaryRed,
                ),
              ),
              GestureDetector(
                onTap: () {
                  yes();
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.done,
                  size: 65.sp,
                  color: AppColors.green,
                ),
              ),
            ],
          ),
          Spc(h: 30.h),
        ],
      ),
    );
  }
}
