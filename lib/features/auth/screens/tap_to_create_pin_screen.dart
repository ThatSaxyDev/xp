import 'package:exptrak/features/auth/screens/create_pin_screen.dart';
import 'package:exptrak/features/navigation_bar/widgets/bottom_navigaion_bar.dart';
import 'package:exptrak/shared/app_elements/app_images.dart';
import 'package:exptrak/shared/widgets/button.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/widgets/spacer.dart';

class TapToCreatePinScreen extends ConsumerWidget {
  const TapToCreatePinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Spc(h: 50.h),

            // logo
            SizedBox(
              height: 200.h,
              width: 200.w,
              child: Image.asset(
                AppImages.appLogo,
                color: currentTheme.textTheme.bodyText2!.color,
              ),
            ),
            Spc(h: 50.h),

            // pin
            BButton(
              height: 56.h,
              width: 200.w,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const CreatePinScreen(),
                  ),
                  (route) => false,
                );
              },
              text: 'Create a pin',
            ),
          ],
        ),
      ),
    );
  }
}
