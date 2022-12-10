// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:exptrak/features/auth/screens/auth_screen.dart';
import 'package:exptrak/features/settings/screens/change_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:exptrak/features/auth/screens/splash_screen.dart';
import 'package:exptrak/features/navigation_bar/widgets/bottom_navigaion_bar.dart';
import 'package:exptrak/theme/palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // check shared prefs if pin has been set
  SharedPreferences appPrefs = await SharedPreferences.getInstance();
  final bool showHome = appPrefs.getBool('showHome') ?? false;

  runApp(
    ProviderScope(
      child: MyApp(showHome: showHome),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool showHome;
  const MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Xp',
          theme: ref.watch(themeNotifierProvider),
          home: child,
        );
      },
      child: showHome ? const AuthScreen() : const SplashScreen(),
      // child: const ChangePinScreen(),
    );
  }
}
