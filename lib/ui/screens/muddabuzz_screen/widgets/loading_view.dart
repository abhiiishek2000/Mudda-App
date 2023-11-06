import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/utils/color.dart';
class MuddeBazzLoadingView extends StatelessWidget {
  const MuddeBazzLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _shimmerGradient = LinearGradient(
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFEBEBF4),
        Color(0xFFFFFFFF),
      ],
      stops: [
        0.1,
        0.3,
        0.4,
      ],
      begin: Alignment(-1.0, -0.5),
      end: Alignment(1.0, 0.5),
      tileMode: TileMode.repeated,
    );
    return Shimmer(
      gradient: _shimmerGradient,
      child: Container(
        width: ScreenUtil().screenWidth,
        height: Get.height * 0.6,
        color: white,
        margin:
        const EdgeInsets.only(top: 0, bottom: 8, right:0, left: 0),
      ),
    );
  }
}
