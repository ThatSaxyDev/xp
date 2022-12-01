// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class BButton extends StatelessWidget {
  final double height;
  final double width;
  final void Function()? onTap;
  final String text;
  const BButton({
    Key? key,
    required this.height,
    required this.width,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.r),
            ),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: AppColors.purple,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.neutralWhite),
          ),
        ),
      ),
    );
  }
}

// SMALL BUTTON
class SmallButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const SmallButton({
    Key? key,
    this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      width: 74.w,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4.r),
            ),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: AppColors.green,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black),
          ),
        ),
      ),
    );
  }
}

class TransparentButton extends StatelessWidget {
  final double height;
  final double width;
  final void Function()? onTap;
  final String text;
  const TransparentButton({
    Key? key,
    required this.height,
    required this.width,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: AppColors.darkBlue,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.r),
            ),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.darkBlue),
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final void Function()? onTap;
  final Widget content;
  const AnimatedButton({
    Key? key,
    required this.height,
    required this.width,
    required this.radius,
    this.onTap,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.purple,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: content,
      ),
    );
  }
}
