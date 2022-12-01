import 'package:exptrak/models/category.dart';
import 'package:exptrak/theme/palette.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryBadge extends ConsumerWidget {
  final Category? category;

  const CategoryBadge({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
      decoration: BoxDecoration(
        color: category?.color.withAlpha(102) ?? currenTheme.textTheme.bodyText2!.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category?.name ?? "Unknown",
        style: TextStyle(
          color: category?.color ?? currenTheme.backgroundColor,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}