import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mudda/core/constant/app_colors.dart';

List<Widget> buildPageIndicator(selectedIndex) {
  List<Widget> list = [];
  for (int i = 0; i < 4; i++) {
    list.add(i == selectedIndex ? _indicator(true) : _indicator(false));
  }
  return list;
}

Widget _indicator(bool isActive) {
  return SizedBox(
    height: 10.h,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      height: 7.w,
      width: 25.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isActive ? colorF2F2F2 : Colors.transparent),
        color: isActive ? colorF1B008 : colorF2F2F2,
      ),
    ),
  );
}
