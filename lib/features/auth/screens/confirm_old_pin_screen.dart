import 'dart:async';
import 'dart:developer';

import 'package:exptrak/features/auth/widgets/numpad.dart';
import 'package:exptrak/features/auth/widgets/pin_input_box.dart';
import 'package:exptrak/features/navigation_bar/widgets/bottom_navigaion_bar.dart';
import 'package:exptrak/features/settings/screens/change_pin_screen.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/widgets/spacer.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_hero/local_hero.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

class ConfirmOldPinScreen extends ConsumerStatefulWidget {
  const ConfirmOldPinScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfirmOldPinScreenState();
}

class _ConfirmOldPinScreenState extends ConsumerState<ConfirmOldPinScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;

  late TextEditingController _pinController;
  late FToast fToast;
  bool isPinCorrect = true;
  // String _pin = '';

  var localAuth = LocalAuthentication();

  // Read values
  Future<void> _readFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isBiometricEnabled = prefs.getBool('biometricEnabled') ?? false;

    if (isBiometricEnabled) {
      bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Please authenticate to sign in');

      if (didAuthenticate) {
       _pinController.text = prefs.getString('pin') ?? '';
      }
    } else {
      // _usernameController.text = await _storage.read(key: KEY_USERNAME) ?? '';
      // _passwordController.text = await _storage.read(key: KEY_PASSWORD) ?? '';
    }
  }

  @override
  void initState() {
    _pinController = TextEditingController();
    _lottieController = AnimationController(vsync: this);
    _readFromStorage();
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _lottieController.dispose();
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
            // CircleAvatar(
            //   radius: 45.w,
            //   backgroundColor: isPinCorrect
            //       ? currentTheme.textTheme.bodyText2!.color
            //       : AppColors.midPurple,
            //   child: CircleAvatar(
            //     radius: 39.w,
            //     backgroundColor: currentTheme.backgroundColor,
            //     child: Icon(
            //       UniconsSolid.lock,
            //       color: isPinCorrect
            //           ? currentTheme.textTheme.bodyText2!.color
            //           : AppColors.midPurple,
            //       size: 27.sp,
            //     ),
            //   ),
            // ),

            SizedBox(
              height: 90.h,
              child: Lottie.asset(
                'lib/assets/lottie/newunlock.json',
                repeat: false,
                controller: _lottieController,
                onLoaded: (composition) =>
                    _lottieController..duration = composition.duration,
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
                    _lottieController.forward();
                    Timer(const Duration(milliseconds: 550), () {
                      HapticFeedback.heavyImpact();
                    });

                    Timer(const Duration(milliseconds: 1000), () {
                      navigator.push(
                          MaterialPageRoute(
                            builder: (context) => const ChangePinScreen(),
                          ),
                          // (route) => false
                          );
                    });
                  } else {
                    log(pinFromPrefs);
                    _showErrorToast(ref);
                    HapticFeedback.vibrate();

                    setState(() {
                      isPinCorrect = false;
                    });
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
            'Incorrect pin!🥶',
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
            top: 50.h,
            left: 80.w,
            child: child,
          );
        });
  }
}
