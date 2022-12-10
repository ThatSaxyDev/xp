import 'dart:async';
import 'dart:developer';

import 'package:exptrak/features/auth/widgets/pin_input_box.dart';
import 'package:exptrak/features/navigation_bar/widgets/bottom_navigaion_bar.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_hero/local_hero.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/widgets/numpad.dart';

const _animationDuration = Duration(milliseconds: 500);

class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _modeChangeController;
  late TextEditingController _pinController;
  late TextEditingController _confirmPinController;
  late FToast fToast;
  String _pin = '';
  // String _confirmPin = '';

  bool showCOnfirmScreen = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _pinController = TextEditingController();
    _confirmPinController = TextEditingController();
    _modeChangeController = AnimationController(
      duration: _animationDuration * 2,
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _modeChangeController.dispose();

    super.dispose();
  }

  void _onModeChanged() {
    if (_modeChangeController.isCompleted) {
      _changeInputMode();
      Future.delayed(_animationDuration, () => _modeChangeController.reverse());
    } else {
      _modeChangeController.forward().then((_) => _changeInputMode());
    }
  }

  void _changeInputMode() => setState(
        () => showCOnfirmScreen = !showCOnfirmScreen,
      );

  void pop() {
    Timer(
      const Duration(milliseconds: 1000),
      () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (route) => false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    // final navigator = Navigator.of(context);
    return Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              showCOnfirmScreen ? 'Confirm pin' : 'New pin',
              style: TextStyle(
                color: currentTheme.textTheme.bodyText2!.color,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spc(h: 90.h),

            // input boxes
            Form(
              child: showCOnfirmScreen
                  ? PinInputBox(
                      controller: _confirmPinController,
                      onCompleted: (pin) async {
                        if (pin == _pin) {
                          HapticFeedback.heavyImpact();
                          // save in shared prefs
                          final SharedPreferences pref =
                              await SharedPreferences.getInstance();

                          // set pin in shared prefs
                          pref.setString('pin', pin);

                          // // set bool for deciding how to start app
                          // pref.setBool('showHome', true);

                          pop();
                        } else {
                          _showErrorToast(ref);
                          HapticFeedback.vibrate();
                          _confirmPinController.clear();
                        }
                      },
                    )
                  : PinInputBox(
                      controller: _pinController,
                      onCompleted: (pin) {
                        // if (pin == _pin) {
                        //   Navigator.of(context).pushAndRemoveUntil(
                        //     MaterialPageRoute(
                        //       builder: ((context) {
                        //         return const BottomNavBar();
                        //       }),
                        //     ),
                        //     (route) => false,
                        //   );
                        // }
                      },
                    ),
            ),

            const Spacer(),
            //! keypad
            LocalHeroScope(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 500),
              child: showCOnfirmScreen
                  ? NumPadAlt(
                      controller: _confirmPinController,
                      delete: () {
                        _confirmPinController.text = _confirmPinController.text
                            .substring(
                                0, _confirmPinController.text.length - 1);
                      },
                      onTap: () {
                        // // log(_pin);
                        // _pinController.clear();
                        // _onModeChanged();
                        // // Navigator.of(context).push(
                        // //   MaterialPageRoute(
                        // //     builder: ((context) {
                        // //       return const ConfirmPinScreen();
                        // //     }),
                        // //   ),
                        // // );
                      },
                    )
                  : NumPad(
                      controller: _pinController,
                      delete: () {
                        _pinController.text = _pinController.text
                            .substring(0, _pinController.text.length - 1);
                      },
                      onTap: () {
                        if (_pinController.text.length == 4) {
                          setState(() {
                            _pin = _pinController.text;
                          });
                          log(_pin);
                          // _pinController.clear();
                          _onModeChanged();
                        }
                      },
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
      height: 45.h,
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: AppColors.primaryRed),
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
            'Pin not matching🥶',
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
            top: 150.h,
            left: 70.w,
            child: child,
          );
        });
  }
}
