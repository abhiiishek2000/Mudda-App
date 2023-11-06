import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/utils/color.dart';
import '../../../../shared/spacing_widget.dart';


class HotMuddaLoadingView extends StatelessWidget {
  const HotMuddaLoadingView({Key? key}) : super(key: key);

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
      child:  Container(
        height: ScreenUtil().screenHeight * 0.35,
        width:  ScreenUtil().screenWidth,
        margin: EdgeInsets.only(
            left: ScreenUtil().setSp(5),
            right: ScreenUtil().setSp(5),
            bottom: ScreenUtil().setSp(32)),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(10),
            vertical: ScreenUtil().setSp(12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              ScreenUtil().setSp(8)),

        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                     ClipRRect(
                      borderRadius:
                      BorderRadius.circular(
                          ScreenUtil()
                              .setSp(
                              8)),
                      child: Container(
                        color: grey,
                        height:
                        ScreenUtil()
                            .setSp(
                            80),
                        width:
                        ScreenUtil()
                            .setSp(
                            80),

                      ),
                    ),

                  ],
                ),
                SizedBox(
                  width: ScreenUtil().setSp(8),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Container(height:20,color:white),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize:
                        MainAxisSize.max,
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .center,
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Container(height:20,width: ScreenUtil().setWidth(60),color:white),
                          Container(height:20,width: ScreenUtil().setWidth(80),color:white),
                          Container(height:20,width: ScreenUtil().setWidth(80),color:white),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Vs(height: 24),
            Container(
              height: ScreenUtil().setSp(54),
              child: Row(
                mainAxisSize:
                MainAxisSize.max,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                mainAxisAlignment:
                MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: ListView.separated(
                          shrinkWrap:
                          true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          scrollDirection:
                          Axis
                              .horizontal,
                          itemBuilder:
                              (context,
                              int
                              index) {
                                return Column(
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: ScreenUtil().setSp(40),
                                        width: ScreenUtil().setSp(40),
                                        decoration: const BoxDecoration(
                                          color: white,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    ]);
                              },
                          separatorBuilder:
                              (context,
                              int
                              index) {
                            return SizedBox(
                                width:
                                12);
                          },
                          itemCount:4))
                ],
              ),
            ),
            const Vs(height: 24),

            Container(height: ScreenUtil().setHeight(80),width: ScreenUtil().screenWidth,color: white,),

            const Vs(
              height: 8,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: [
                Container(height:20,width: ScreenUtil().setWidth(80),color:white),
                Container(height:20,width: ScreenUtil().setWidth(80),color:white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
