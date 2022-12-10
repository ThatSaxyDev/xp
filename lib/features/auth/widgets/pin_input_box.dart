import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/app_elements/app_texts.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class PinInputBox extends ConsumerWidget {
  final void Function(String)? onCompleted;
  final TextEditingController? controller;
  const PinInputBox({
    Key? key,
    this.onCompleted,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final currentTheme = ref.watch(themeNotifierProvider);
    return Pinput(
      showCursor: false,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      obscuringCharacter: AppTexts.obsureCharacter,
      obscureText: true,
      useNativeKeyboard: false,
      defaultPinTheme: PinTheme(
        width: 56.h,
        height: 56.h,
        textStyle: TextStyle(
          fontSize: 30.sp,
          color: AppColors.midPurple,
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey),
          borderRadius: BorderRadius.circular(28.r),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 56.h,
        height: 56.h,
        textStyle: TextStyle(
          fontSize: 30.sp,
          color: AppColors.midPurple,
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.midPurple),
          borderRadius: BorderRadius.circular(28.r),
        ),
      ),
      submittedPinTheme: PinTheme(
        width: 56.h,
        height: 56.h,
        textStyle: TextStyle(
          fontSize: 30.sp,
          color: AppColors.midPurple,
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.midPurple),
          borderRadius: BorderRadius.circular(28.r),
        ),
      ),
      controller: controller,
      onCompleted: onCompleted,
    );
  }
}
