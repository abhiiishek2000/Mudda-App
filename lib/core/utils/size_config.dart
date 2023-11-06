import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

double getHeight(double inputHeight) {
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * Get.height;
}

// Get the proportionate height as per screen size
double getWidth(double inputWidth) {
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * Get.width;
}

SizedBox getSizedBox({double? h, double? w}) {
  return SizedBox(
    height: h == null ? null : getHeight(h),
    width: w == null ? null : getWidth(w),
  );
}
