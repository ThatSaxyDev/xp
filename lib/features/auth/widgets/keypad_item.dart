import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_hero/local_hero.dart';

class KeyPadItem extends StatelessWidget {
  final String number;
  final TextEditingController controller;
  const KeyPadItem({
    Key? key,
    required this.number,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocalHero(
      tag: 'digit_$number',
      child: SizedBox(
        height: 72.h,
        width: 72.w,
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            controller.text += number;
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: AppColors.grey,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(24.r),
              ),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.midPurple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// keypad for transfer and fund
class KeyPadItemAlt extends StatelessWidget {
  final String number;
  final TextEditingController controller;
  const KeyPadItemAlt({
    Key? key,
    required this.number,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72.h,
      width: 72.w,
      child: ElevatedButton(
        onPressed: () {
          controller.text += number;
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: AppColors.neutralWhite.withOpacity(0.15),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(24.r),
            ),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.neutralWhite,
            ),
          ),
        ),
      ),
    );
  }
}
