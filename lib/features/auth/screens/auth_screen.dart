import 'dart:developer';

import 'package:exptrak/features/auth/widgets/numpad.dart';
import 'package:exptrak/features/auth/widgets/pin_input_box.dart';
import 'package:exptrak/features/navigation_bar/widgets/bottom_navigaion_bar.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_hero/local_hero.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late TextEditingController _pinController;
  late FToast fToast;
  // String _pin = '';

  @override
  void initState() {
    _pinController = TextEditingController();
    fToast = FToast();
    fToast.init(context);
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
    final navigator = Navigator.of(context);
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
            // Text(
            //   'Welcome',
            //   style: TextStyle(
            //     color: currentTheme.textTheme.bodyText2!.color,
            //     fontSize: 30.sp,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),

            //
            CircleAvatar(
              radius: 45.w,
              backgroundColor: AppColors.midPurple,
              child: CircleAvatar(
                radius: 39.w,
                backgroundColor: currentTheme.backgroundColor,
                child: Icon(
                  UniconsSolid.lock,
                  color: AppColors.midPurple,
                  size: 27.sp,
                ),
              ),
            ),
            Spc(h: 70.h),

            // input boxes
            Form(
              child: PinInputBox(
                controller: _pinController,
                onCompleted: (pin) async {
                  log(pin);
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  // get pin from shared prefs
                  String pinFromPrefs = prefs.getString('pin') ?? '';
                  log(pinFromPrefs);

                  if (pin == pinFromPrefs) {
                    navigator.pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const BottomNavBar(),
                        ),
                        (route) => false);
                  } else {
                    _showErrorToast(ref);
                    _pinController.clear();
                  }
                },
              ),
            ),

            const Spacer(),
            //! keypad
            LocalHeroScope(
              child: NumPadScramble(
                showTick: false,
                controller: _pinController,
                delete: () {
                  _pinController.text = _pinController.text
                      .substring(0, _pinController.text.length - 1);
                },
                onTap: () {},
              ),
            ),
            Spc(h: 50.h),
          ],
        ),
      ),
    );
  }

  // error toast
  _showErrorToast(WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: AppColors.primaryRed.withOpacity(0.6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.close,
            color: currentTheme.backgroundColor,
          ),
          SizedBox(
            width: 12.w,
          ),
          Text(
            'Incorrect pin! 🥶',
            style: TextStyle(
              color: currentTheme.backgroundColor,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            top: 100.h,
            left: 80.w,
            child: child,
          );
        });
  }
}
