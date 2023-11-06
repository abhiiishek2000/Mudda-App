import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/shared/back_button.dart';

class BackBarWidget extends StatelessWidget {
  const BackBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomBackButton(),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(top: 25, right: 50.h),
          child: Text.rich(
            TextSpan(
              text: "Describe your",
              style: size18_M_normal(textColor: colorA0A0A0),
              children: [
                TextSpan(
                    text: " Issue",
                    style: size18_M_semiBold(textColor: colorDarkBlack))
              ],
            ),
          ),
        ),
        const Spacer()
      ],
    );
  }
}
