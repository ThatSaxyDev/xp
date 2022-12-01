import 'package:flutter/material.dart';

class Spc extends StatelessWidget {
  final double? h;
  final double? w;
  const Spc({
    Key? key,
    this.h,
    this.w,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h,
      width: w,
    );
  }
}