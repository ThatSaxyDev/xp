import 'dart:developer';

import 'package:exptrak/features/auth/screens/confirm_pin_screen.dart';
import 'package:exptrak/features/auth/widgets/numpad.dart';
import 'package:exptrak/features/auth/widgets/pin_input_box.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:exptrak/features/navigation_bar/widgets/bottom_navigaion_bar.dart';
import 'package:exptrak/shared/app_elements/app_images.dart';
import 'package:exptrak/shared/app_elements/app_texts.dart';
import 'package:exptrak/shared/widgets/button.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/shared/widgets/text_input.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:local_hero/local_hero.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _animationDuration = Duration(milliseconds: 500);

class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _modeChangeController;
  late TextEditingController _pinController;
  late TextEditingController _confirmPinController;
  String _pin = '';
  // String _confirmPin = '';

  bool showCOnfirmScreen = false;

  @override
  void initState() {
    super.initState();
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
              showCOnfirmScreen ? 'Confirm pin' : 'Create a pin',
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
                          // save in shared prefs
                          final SharedPreferences pref = await SharedPreferences.getInstance();

                          pref.setBool('showHome', true);

                           Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) {
                                return const BottomNavBar();
                              }),
                            ),
                          );
                        }
                      },
                    )
                  : PinInputBox(
                      controller: _pinController,
                      onCompleted: (pin) {
                        if (pin == _pin) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: ((context) {
                                return const BottomNavBar();
                              }),
                            ),
                            (route) => false,
                          );
                        }
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
}
