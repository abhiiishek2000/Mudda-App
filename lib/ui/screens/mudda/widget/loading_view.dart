import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/utils/color.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

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
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: ScreenUtil().screenWidth,
                margin:
                const EdgeInsets.only(top: 0, bottom: 4, right: 8, left: 28),
                child: Column(
                  children: [
                    Stack(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 0, right: 44, left: 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: ScreenUtil().screenWidth,
                            height: ScreenUtil().screenHeight * 0.25,
                            decoration: const BoxDecoration(
                              color: white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(

                                child:
                                  Container(
                                  width: ScreenUtil().screenWidth,

                                  ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Stack(
                                  children:
                                  [
                                    Container(
                                            width: ScreenUtil().setSp(40),
                                            height: ScreenUtil().setSp(40),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              shape: BoxShape.circle,

                                            ),
                                          )

                                  ]))],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Stack(
            children: [
              Container(
                width: ScreenUtil().screenWidth,
                margin: const EdgeInsets.only(
                    top: 0, bottom: 8, right: 28, left: 8),

                child: Column(
                  children: [

                    Stack(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 0, right: 0, left: 44),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: ScreenUtil().screenWidth,
                            height: ScreenUtil().screenHeight * 0.25,
                            decoration: const BoxDecoration(
                              color: white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Stack(children: [
                                        Container(
                                          width:
                                          ScreenUtil().setSp(40),
                                          height:
                                          ScreenUtil().setSp(40),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                ])

                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 0, left: 8),
                                child: Row(
                                  children: [

                                    const SizedBox(width: 10),


                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
