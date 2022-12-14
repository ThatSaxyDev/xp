import 'dart:developer';

import 'package:exptrak/features/auth/widgets/numpad.dart';
import 'package:exptrak/features/auth/widgets/pin_input_box.dart';
import 'package:exptrak/features/navigation_bar/widgets/bottom_navigaion_bar.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/palette.dart';

class ConfirmPinScreen extends ConsumerStatefulWidget {
  const ConfirmPinScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends ConsumerState<ConfirmPinScreen> {
  late TextEditingController _pinController;
  // String _pin = '';

  @override
  void initState() {
    _pinController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      appBar: AppBar(
        foregroundColor: AppColors.grey,
        backgroundColor: currentTheme.backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40.w, 0, 40.w, 36.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Confirm pin',
              style: TextStyle(
                color: currentTheme.textTheme.bodyText2!.color,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spc(h: 90.h),

            // input boxes
            Form(
              child: PinInputBox(
                controller: _pinController,
                onCompleted: (pin) {
                  log(pin);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) {
                        return const BottomNavBar();
                      }),
                    ),
                  );
                },
              ),
            ),

            const Spacer(),
            //! keypad
            NumPad(
              showTick: false,
              controller: _pinController,
              delete: () {
                _pinController.text = _pinController.text
                    .substring(0, _pinController.text.length - 1);
              },
              onTap: () {},
            ),
            Spc(h: 50.h),
          ],
        ),
      ),
    );
  }
}
