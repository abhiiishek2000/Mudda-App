import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/text_style.dart';

class GetStartedButton extends StatelessWidget {
  GetStartedButton({Key? key, this.onTap, this.title}) : super(key: key);

  Function()? onTap;
  String? title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: 18.h, bottom: 41.h),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
              decoration: BoxDecoration(
                color: colorWhite,
                border: Border.all(color: color606060),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Center(
                  child: Text(
                    title.toString(),
                    style: size18_M_normal(textColor: colorDarkBlack),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.only(right: 10, top: 4),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: colorWhite),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorWhite,
                      border: Border.all(color: color606060)),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 40,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
