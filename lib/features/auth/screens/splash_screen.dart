import 'dart:async';

import 'package:exptrak/features/auth/screens/tap_to_create_pin_screen.dart';
import 'package:exptrak/features/navigation_bar/widgets/bottom_navigaion_bar.dart';
import 'package:exptrak/shared/app_elements/app_colors.dart';
import 'package:exptrak/shared/app_elements/app_images.dart';
// import 'package:exptrak/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    startTime();
    super.initState();
  }

  startTime() {
    Timer(const Duration(milliseconds: 4000), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const TapToCreatePinScreen(),
          ),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final currenTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      // backgroundColor: AppColors.neutralWhite,
      body: Center(
        child: Container(
          height: 300.h,
          width: 300.w,
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1700),
              builder: (context, value, _) {
                return LiquidLinearProgressIndicator(
                  borderColor: Colors.transparent,
                  borderWidth: 0,
                  borderRadius: 500.r,
                  value: value,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.black),
                  backgroundColor: Colors.white,
                  direction: Axis.vertical,
                  center: SizedBox(
                    height: 200.h,
                    width: 200.w,
                    child: Image.asset(
                      AppImages.appLogo,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
