import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/screens/home_screen/widget/FireNews.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';
class BoxContainerOne extends StatelessWidget {
  const BoxContainerOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.25),
            offset: const Offset(
              0.0,
              4.0,
            ),
            blurRadius: 4,
            spreadRadius: 0.8,
          ), //BoxShadow  //BoxShadow
        ],
      ),
      child: Column(
        children: [
          Vs(height: 8.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  "https://images.indianexpress.com/2014/03/russia-1200.jpg?w=626",
                  fit: BoxFit.cover,
                  height: 50.h,
                  width: 50.h,
                ),
              ),
              Hs(width: 10.h),
              Expanded(
                child: Text(
                    "भारत को फिर से विश्वगुरु बनाना है।   चलो करो सपोर्ट एंड लगाओ पोस्ट्स ",
                    style: size14_M_bold(textColor: colorDarkBlack)),
              ),
            ],
          ),
          Vs(height: 15.h),
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteConstants.videoStages);
            },
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      "https://static01.nyt.com/images/2022/02/24/business/24foxnews2/24foxnews2-mobileMasterAt3x.jpg",
                      fit: BoxFit.cover,
                      width: 115.w,
                      height: 115.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: colorWhite),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Icon(
                        Icons.play_arrow_outlined,
                        color: colorWhite,
                      ),
                    )
                  ],
                ),
                Hs(
                  width: 10.h,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NetworkImageBox(
                              imageString:
                                  "https://www.dailyexcelsior.com/wp-content/uploads/2022/02/Ukraine-Russia.jpg"),
                          Hs(width: 10.w),
                          NetworkImageBox(
                              imageString:
                                  "https://images.wsj.net/im-491703?width=599&height=399"),
                          Hs(width: 5.w),
                          Icon(Icons.add, size: 15.sp),
                          Hs(width: 5.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "32 Leaders",
                                style:
                                    size12_M_normal(textColor: colorDarkBlack),
                              ),
                              Vs(
                                height: 10.h,
                              ),
                              Image.asset(
                                AppIcons.nextLongArrow,
                                height: 8.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 1.h,
                        margin: EdgeInsets.only(
                            top: 15.h, bottom: 15.h, right: 70.h),
                        color: colorA0A0A0,
                        width: double.infinity,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NetworkImageBox(
                              imageString:
                                  "https://www.dailyexcelsior.com/wp-content/uploads/2022/02/Ukraine-Russia.jpg"),
                          Hs(width: 10.w),
                          NetworkImageBox(
                              imageString:
                                  "https://images.wsj.net/im-491703?width=599&height=399"),
                          Hs(width: 5.w),
                          Icon(Icons.add, size: 15.sp),
                          Hs(width: 5.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "32 Leaders",
                                style:
                                    size12_M_normal(textColor: colorDarkBlack),
                              ),
                              Vs(
                                height: 10.h,
                              ),
                              Image.asset(
                                AppIcons.nextLongArrow,
                                height: 8.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: colorF2F2F2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                    TextSpan(text: "Started: ", children: [
                      TextSpan(
                          text: "10 mins ago \n  Ad hoc",
                          style: size12_M_bold(textColor: colorDarkBlack)
                              .copyWith(height: 1.8))
                    ]),
                    style: size12_M_normal(textColor: color606060)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("25", style: size16_M_normal(textColor: color0060FF)),
                    Hs(
                      width: 5.w,
                    ),
                    const Icon(
                      Icons.live_tv,
                      color: color0060FF,
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("2.5K",
                        style: size12_M_normal(textColor: color606060)),
                    const Hs(
                      width: 5,
                    ),
                    Image.asset(AppIcons.eyeIcon)
                  ],
                ),
                Row(
                  children: [
                    Text("1.2% ", style: size12_M_bold(textColor: color26C123)),
                    const Icon(
                      Icons.arrow_upward,
                      color: color26C123,
                      size: 15,
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: colorF2F2F2,
          ),
          const Vs(
            height: 4,
          ),
          Row(
            children: [
              Text("#Political, #Social, #Educational",
                  style: size10_M_normal(textColor: colorDarkBlack)),
              Hs(width: 42.h),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: colorDarkBlack),
              ),
              const Hs(width: 5),
              Text("Lucknow, UP, India",
                  style: size12_M_normal(textColor: colorDarkBlack)),
            ],
          ),
        ],
      ),
    );
  }
}
