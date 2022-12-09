// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:unicons/unicons.dart';

import 'package:exptrak/features/auth/widgets/keypad_item.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/widgets/spacer.dart';

class NumPad extends StatelessWidget {
  final TextEditingController controller;
  final Function delete;
  final void Function()? onTap;
  final bool showTick;
  const NumPad({
    Key? key,
    required this.controller,
    required this.delete,
    required this.onTap,
    this.showTick = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //! keypad
        //! one, two, three
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KeyPadItem(number: '1', controller: controller),
            KeyPadItem(number: '2', controller: controller),
            KeyPadItem(number: '3', controller: controller),
          ],
        ),
        Spc(h: 15.h),

        //! four, five, six
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KeyPadItem(number: '4', controller: controller),
            KeyPadItem(number: '5', controller: controller),
            KeyPadItem(number: '6', controller: controller),
          ],
        ),
        Spc(h: 15.h),

        //! seven, eight, nine
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KeyPadItem(number: '7', controller: controller),
            KeyPadItem(number: '8', controller: controller),
            KeyPadItem(number: '9', controller: controller),
          ],
        ),
        Spc(h: 15.h),

        // backspace, zero
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 88.h,
              width: 88.w,
              child: ElevatedButton(
                onPressed: () => delete(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.r),
                    ),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.midPurple,
                  ),
                ),
              ),
            ),
            KeyPadItem(number: '0', controller: controller),
            showTick
                ? SizedBox(
                    height: 88.h,
                    width: 88.w,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(24.r),
                          ),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.done_all,
                          color: AppColors.midPurple,
                        ),
                      ),
                    ),
                  )
                : Spc(h: 88.h, w: 88.w),
          ],
        ),
      ],
    );
  }
}

// numpad for confirming pin
class NumPadAlt extends StatelessWidget {
  final TextEditingController controller;
  final Function delete;
  final void Function()? onTap;
  final bool showTick;
  const NumPadAlt({
    Key? key,
    required this.controller,
    required this.delete,
    required this.onTap,
    this.showTick = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> nums = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    nums.shuffle();
    return Column(
      children: [
        //! keypad
        //! one, two, three
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KeyPadItem(number: nums[0], controller: controller),
            KeyPadItem(number: nums[1], controller: controller),
            KeyPadItem(number: nums[2], controller: controller),
          ],
        ),
        Spc(h: 15.h),

        //! four, five, six
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KeyPadItem(number: nums[3], controller: controller),
            KeyPadItem(number: nums[4], controller: controller),
            KeyPadItem(number: nums[5], controller: controller),
          ],
        ),
        Spc(h: 15.h),

        //! seven, eight, nine
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KeyPadItem(number: nums[6], controller: controller),
            KeyPadItem(number: nums[7], controller: controller),
            KeyPadItem(number: nums[8], controller: controller),
          ],
        ),
        Spc(h: 15.h),

        // backspace, zero
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 88.h,
              width: 88.w,
              child: ElevatedButton(
                onPressed: () => delete(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.r),
                    ),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.midPurple,
                  ),
                ),
              ),
            ),
           KeyPadItem(number: nums[9], controller: controller),
            // showTick
            //     ? SizedBox(
            //         height: 88.h,
            //         width: 88.w,
            //         child: ElevatedButton(
            //           onPressed: onTap,
            //           style: ElevatedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //               side: BorderSide.none,
            //               borderRadius: BorderRadius.all(
            //                 Radius.circular(24.r),
            //               ),
            //             ),
            //             elevation: 0,
            //             shadowColor: Colors.transparent,
            //             backgroundColor: Colors.transparent,
            //           ),
            //           child: const Center(
            //             child: Icon(
            //               Icons.done_all,
            //               color: AppColors.midPurple,
            //             ),
            //           ),
            //         ),
            //       )
            //     :
            Spc(h: 88.h, w: 88.w),
          ],
        ),
      ],
    );
  }
}

// scrambling num pad for auth
class NumPadScramble extends StatelessWidget {
  final TextEditingController controller;
  final Function delete;
  final void Function()? onTap;
  final bool showTick;
  const NumPadScramble({
    Key? key,
    required this.controller,
    required this.delete,
    required this.onTap,
    this.showTick = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> nums = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    nums.shuffle();
    return Column(
      children: [
        //! keypad
        //! one, two, three
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KeyPadItem(number: nums[0], controller: controller),
            KeyPadItem(number: nums[1], controller: controller),
            KeyPadItem(number: nums[2], controller: controller),
          ],
        ),
        Spc(h: 15.h),

        //! four, five, six
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KeyPadItem(number: nums[3], controller: controller),
            KeyPadItem(number: nums[4], controller: controller),
            KeyPadItem(number: nums[5], controller: controller),
          ],
        ),
        Spc(h: 15.h),

        //! seven, eight, nine
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KeyPadItem(number: nums[6], controller: controller),
            KeyPadItem(number: nums[7], controller: controller),
            KeyPadItem(number: nums[8], controller: controller),
          ],
        ),
        Spc(h: 15.h),

        // backspace, zero
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 88.h,
              width: 88.w,
              child: ElevatedButton(
                onPressed: () => delete(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.r),
                    ),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.midPurple,
                  ),
                ),
              ),
            ),
            KeyPadItem(number: nums[9], controller: controller),
            showTick
                ? SizedBox(
                    height: 88.h,
                    width: 88.w,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(24.r),
                          ),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.done_all,
                          color: AppColors.midPurple,
                        ),
                      ),
                    ),
                  )
                : Spc(h: 88.h, w: 88.w),
          ],
        ),
      ],
    );
  }
}
