import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/screens/login_screen/widget/indicator_widget.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int selectedIndex = 0;
  PageController controller = PageController();
  bool isLoginTour = false;

  @override
  Widget build(BuildContext context) {
    isLoginTour = Get.arguments;
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setSp(24),
                right: ScreenUtil().setSp(14),
                top: ScreenUtil().setSp(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      if (isLoginTour) {
                        Get.back();
                      } else {
                        Get.offAllNamed(RouteConstants.homeScreen);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                      child: Text(
                        "Skip Intro",
                        style: GoogleFonts.nunitoSans(
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.w400,
                            color: blackGray),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Know MUDDA",
                  style: GoogleFonts.nunitoSans(
                      fontSize: ScreenUtil().setSp(26),
                      fontWeight: FontWeight.w700,
                      color: black),
                ),
                Text(
                  "... in quick easy steps",
                  style: GoogleFonts.nunitoSans(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w400,
                      color: grey),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(50),
                ),
                Expanded(
                  child: PageView.builder(
                      itemCount: 3,
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (value) {
                        selectedIndex = value;
                        setState(() {});
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          color: white,
                          child: selectedIndex == 0
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Step 1: Raise your Mudda",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: ScreenUtil().setSp(20),
                                    fontWeight: FontWeight.w600,
                                    color: color0060FF),
                              ),
                              getSizedBox(h: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(right: 8.w),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'What change or\nimprovement do you\nwant to bring?',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.nunitoSans(
                                                fontSize: ScreenUtil()
                                                    .setSp(16),
                                                fontWeight:
                                                FontWeight.w400,
                                                color: black),
                                          ),
                                          SizedBox(
                                            height:
                                            ScreenUtil().setSp(20),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(6),
                                              child: Icon(
                                                CupertinoIcons.add,
                                                size: 37,
                                                color: colorWhite,
                                              ),
                                            ),
                                            decoration:
                                            BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color(0XFFF79824),
                                                    Color(0XFFFDCA40),
                                                    Color(0XFFF79824),
                                                  ],
                                                ),
                                                color: Colors.amber,
                                                shape:
                                                BoxShape.circle,
                                                border: Border.all(color: colorWhite),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: colorA0A0A0,
                                                    blurRadius: 2.0,
                                                    spreadRadius: 0.0,
                                                    offset: Offset(
                                                      0.0,
                                                      3.0,
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 21.h,
                                        horizontal: 18.w),
                                    child: SvgPicture.asset(
                                      "${AppIcons.loginScreenSliderImage}$selectedIndex.svg",
                                      height: 120,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setSp(30),
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                      "assets/svg/down_line.svg")),
                              SizedBox(
                                height: ScreenUtil().setSp(40),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        text: "Step 2: Invite Leadership",
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: ScreenUtil().setSp(20),
                                            fontWeight: FontWeight.w600,
                                            color: color0060FF),
                                        children: [TextSpan(text: '   Know More',style: GoogleFonts.nunitoSans(
                                            fontSize: ScreenUtil().setSp(10),
                                            fontWeight: FontWeight.w400,
                                            color: colorF1B008)),
                                        ]
                                    ),
                                  ),
                                  getSizedBox(w: 3),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7),
                                    child: Container(
                                      // alignment: Alignment.center,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(2),
                                        child: Icon(
                                          CupertinoIcons.question,
                                          size: 7,
                                          color: colorF1B008,
                                        ),
                                      ),
                                      decoration:
                                      BoxDecoration(
                                        color: colorWhite,
                                        shape:
                                        BoxShape.circle,
                                        border: Border.all(color: colorF1B008),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 18.w),
                                    child: SvgPicture.asset(
                                      "${AppIcons.loginScreenSliderImage}1.svg",
                                      height: 100,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(right: 8.w),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 30),
                                            child: Text(
                                              inviteMinimum,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.nunitoSans(
                                                  fontSize: ScreenUtil()
                                                      .setSp(16),
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  color: black),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                            ScreenUtil().setSp(20),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: SvgPicture.asset(
                                                "assets/svg/share.svg",height: 40,))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                              : selectedIndex == 1
                              ? Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Step 3: Gather Public Support",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: ScreenUtil().setSp(20),
                                    fontWeight: FontWeight.w600,
                                    color: color0060FF),
                              ),
                              SizedBox(
                                height: ScreenUtil().setSp(20),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 100,
                                        margin:
                                        EdgeInsets.only(left: 25),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: blackGray,
                                          border: Border.all(
                                              color: white),
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                        ),
                                        child: Text(
                                          "Support",
                                          style: size12_M_regular300(
                                              textColor: white),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Image.asset(
                                              AppIcons.shakeHandIcon,
                                              color: white,
                                            )),
                                        decoration: BoxDecoration(
                                          color: blackGray,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Hs(width: 10),
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 100,
                                        margin:
                                        EdgeInsets.only(left: 25),
                                        alignment: Alignment.center,
                                        padding:
                                        const EdgeInsets.only(
                                            left: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: colorA0A0A0),
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                        ),
                                        child: Text(
                                          "Not Support",
                                          style: size12_M_regular300(
                                              textColor:
                                              colorDarkBlack),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: Image.asset(
                                                AppIcons.dislike)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: colorA0A0A0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setSp(20),
                              ),
                              Text.rich(TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: 'Discuss, Debate',
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                        ScreenUtil().setSp(16),
                                        color: black)),
                                TextSpan(
                                    text: ' and',
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        color: black,
                                        fontSize:
                                        ScreenUtil().setSp(16))),
                                TextSpan(
                                    text: ' Support',
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                        ScreenUtil().setSp(16),
                                        color: black)),
                                TextSpan(
                                    text:
                                    ' various Muddas and be part of the change initiative',
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        color: black,
                                        fontSize:
                                        ScreenUtil().setSp(16))),
                              ])),
                              SizedBox(
                                height: ScreenUtil().setSp(40),
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                      "assets/svg/down_line.svg")),
                              SizedBox(
                                height: ScreenUtil().setSp(40),
                              ),
                              Text(
                                "Step 4: Join Digital Stages",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: ScreenUtil().setSp(20),
                                    fontWeight: FontWeight.w600,
                                    color: color0060FF),
                              ),
                              SizedBox(
                                height: ScreenUtil().setSp(24),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(right: 8.w),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            goLiveOn,
                                            textAlign:
                                            TextAlign.center,
                                            style: GoogleFonts
                                                .nunitoSans(
                                                fontSize:
                                                ScreenUtil()
                                                    .setSp(
                                                    16),
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                color: black),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil()
                                                .setSp(20),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: SvgPicture.asset(
                                                "assets/svg/ic_video.svg",))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                              "assets/svg/ic_mic.svg")),
                                      SvgPicture.asset(
                                        "${AppIcons.loginScreenSliderImage}2.svg",
                                        height: 140,
                                      )
                                    ],
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                  ),
                                ],
                              ),
                            ],
                          )
                              : Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Step 5: Conclude Mudda",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: ScreenUtil().setSp(20),
                                    fontWeight: FontWeight.w600,
                                    color: color0060FF),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(right: 8.w),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            youHaveBrought2,
                                            textAlign:
                                            TextAlign.center,
                                            style: GoogleFonts
                                                .nunitoSans(
                                                fontSize:
                                                ScreenUtil()
                                                    .setSp(
                                                    16),
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                color: black),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil()
                                                .setSp(25),
                                          ),
                                          Text(
                                            startOver,
                                            textAlign:
                                            TextAlign.center,
                                            style: GoogleFonts
                                                .nunitoSans(
                                                fontSize:
                                                ScreenUtil()
                                                    .setSp(
                                                    14),
                                                fontWeight:
                                                FontWeight
                                                    .w700,
                                                color: colorF1B008,
                                                fontStyle:
                                                FontStyle
                                                    .italic),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 21.h,
                                            horizontal: 18.w),
                                        child: SvgPicture.asset(
                                          "${AppIcons.loginScreenSliderImage}3.svg",
                                          height: 125,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setSp(30),
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                      "assets/svg/horizontal_line.svg")),
                              SizedBox(
                                height: ScreenUtil().setSp(40),
                              ),
                              Text(
                                "Additional things you can do:",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: ScreenUtil().setSp(20),
                                    fontWeight: FontWeight.w600,
                                    color: color0060FF),
                              ),
                              SizedBox(
                                height:
                                ScreenUtil().setSp(25),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 21.h,
                                        horizontal: 18.w),
                                    child: SvgPicture.asset(
                                      "assets/svg/ic_network.svg",height: 50,),
                                  ),
                                  getSizedBox(w: 15),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(right: 8.w),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Create your Org Profile:',
                                            // textAlign: TextAlign.center,
                                            style: GoogleFonts.nunitoSans(
                                                fontSize: ScreenUtil()
                                                    .setSp(16),
                                                fontWeight:
                                                FontWeight.w700,
                                                color: colorF1B008),
                                          ),
                                          SizedBox(
                                            height:
                                            ScreenUtil().setSp(5),
                                          ),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:[
                                                Text("\u2022", style: TextStyle(fontSize: 16),), //bullet text
                                                SizedBox(width: 10,), //space between bullet and text
                                                Expanded(
                                                  child:Text("Join Members",style: GoogleFonts.nunitoSans(
                                                      fontSize: ScreenUtil()
                                                          .setSp(16),
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      color: black)), //text
                                                )
                                              ]
                                          ),
                                          SizedBox(
                                            height:
                                            ScreenUtil().setSp(5),
                                          ),
                                          Row(
                                              children:[
                                                Text("\u2022", style: TextStyle(fontSize: 16),), //bullet text
                                                SizedBox(width: 10,), //space between bullet and text
                                                Expanded(
                                                  child:RichText(
                                                    text: TextSpan(text: "Increase your ", style: GoogleFonts.nunitoSans(
                                                        fontSize: ScreenUtil()
                                                            .setSp(16),
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        color: black),
                                                        children: [
                                                          TextSpan(text: 'NETWORK', style: GoogleFonts.nunitoSans(
                                                              fontSize: ScreenUtil()
                                                                  .setSp(16),
                                                              fontWeight:
                                                              FontWeight.w700,
                                                              color: black),)
                                                        ]),
                                                  ), //text
                                                )
                                              ]
                                          ) //
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   height: 40,
                                  //   width: 50,
                                  //   alignment: Alignment.center,
                                  //   child: Image.asset(
                                  //       AppIcons.leftSideIcon),
                                  //   decoration: BoxDecoration(
                                  //     color: color606060
                                  //         .withOpacity(0.75),
                                  //     borderRadius:
                                  //         const BorderRadius.only(
                                  //       topRight: Radius.circular(16),
                                  //       bottomRight:
                                  //           Radius.circular(16),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Column(
                                  //   children: [
                                  //     Container(
                                  //       height:
                                  //           ScreenUtil().setSp(20),
                                  //       width: ScreenUtil().setSp(20),
                                  //       decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //           color: buttonBlue,
                                  //         ),
                                  //         shape: BoxShape.circle,
                                  //       ),
                                  //       child: Center(
                                  //         child: Text("1",
                                  //             style: GoogleFonts
                                  //                 .nunitoSans(
                                  //                     fontWeight:
                                  //                         FontWeight
                                  //                             .w400,
                                  //                     fontSize:
                                  //                         ScreenUtil()
                                  //                             .setSp(
                                  //                                 12),
                                  //                     color:
                                  //                         buttonBlue)),
                                  //       ),
                                  //     ),
                                  //     Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         Text("Circle Page:",
                                  //             style: GoogleFonts
                                  //                 .nunitoSans(
                                  //                     fontWeight:
                                  //                         FontWeight
                                  //                             .w700,
                                  //                     fontSize:
                                  //                         ScreenUtil()
                                  //                             .setSp(
                                  //                                 16),
                                  //                     color: black)),
                                  //         Text("Connect with\npeople",
                                  //             style: GoogleFonts
                                  //                 .nunitoSans(
                                  //                     fontWeight:
                                  //                         FontWeight
                                  //                             .w400,
                                  //                     fontSize:
                                  //                         ScreenUtil()
                                  //                             .setSp(
                                  //                                 16),
                                  //                     color: black)),
                                  //       ],
                                  //     )
                                  //   ],
                                  // ),
                                  // Column(
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.end,
                                  //   children: [
                                  //     Container(
                                  //       height:
                                  //           ScreenUtil().setSp(20),
                                  //       width: ScreenUtil().setSp(20),
                                  //       decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //           color: buttonBlue,
                                  //         ),
                                  //         shape: BoxShape.circle,
                                  //       ),
                                  //       child: Center(
                                  //         child: Text("2",
                                  //             style: GoogleFonts
                                  //                 .nunitoSans(
                                  //                     fontWeight:
                                  //                         FontWeight
                                  //                             .w400,
                                  //                     fontSize:
                                  //                         ScreenUtil()
                                  //                             .setSp(
                                  //                                 12),
                                  //                     color:
                                  //                         buttonBlue)),
                                  //       ),
                                  //     ),
                                  //     Text("Muddebaaz Page:",
                                  //         style:
                                  //             GoogleFonts.nunitoSans(
                                  //                 fontWeight:
                                  //                     FontWeight.w700,
                                  //                 fontSize:
                                  //                     ScreenUtil()
                                  //                         .setSp(16),
                                  //                 color: black)),
                                  //     Text(
                                  //       "Show your\nactivities",
                                  //       style: GoogleFonts.nunitoSans(
                                  //           fontWeight:
                                  //               FontWeight.w400,
                                  //           fontSize: ScreenUtil()
                                  //               .setSp(16),
                                  //           color: black),
                                  //       textAlign: TextAlign.end,
                                  //     ),
                                  //   ],
                                  // ),
                                  // Container(
                                  //   height: 40,
                                  //   width: 50,
                                  //   alignment: Alignment.center,
                                  //   child: Image.asset(
                                  //       AppIcons.rightSideIcon),
                                  //   decoration: BoxDecoration(
                                  //     color: color606060
                                  //         .withOpacity(0.75),
                                  //     borderRadius:
                                  //         const BorderRadius.only(
                                  //       topLeft: Radius.circular(16),
                                  //       bottomLeft:
                                  //           Radius.circular(16),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              // SizedBox(
                              //   height: ScreenUtil().setSp(5),
                              // ),
                              // Column(
                              //   children: [
                              //     Container(
                              //       height: ScreenUtil().setSp(20),
                              //       width: ScreenUtil().setSp(20),
                              //       decoration: BoxDecoration(
                              //         border: Border.all(
                              //           color: buttonBlue,
                              //         ),
                              //         shape: BoxShape.circle,
                              //       ),
                              //       child: Center(
                              //         child: Text("3",
                              //             style:
                              //                 GoogleFonts.nunitoSans(
                              //                     fontWeight:
                              //                         FontWeight.w400,
                              //                     fontSize:
                              //                         ScreenUtil()
                              //                             .setSp(12),
                              //                     color: buttonBlue)),
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       height: ScreenUtil().setSp(5),
                              //     ),
                              //
                              //     Text(
                              //         "Create Org Profile, Join Members, Increase you",
                              //         style: GoogleFonts.nunitoSans(
                              //             fontWeight: FontWeight.w400,
                              //             fontSize:
                              //                 ScreenUtil().setSp(16),
                              //             color: black)),
                              //     Text("NETWORK",
                              //         style: GoogleFonts.nunitoSans(
                              //             fontWeight: FontWeight.w700,
                              //             fontSize:
                              //                 ScreenUtil().setSp(16),
                              //             color: black)),
                              //   ],
                              // ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setSp(14),
                right: ScreenUtil().setSp(14),
                bottom: ScreenUtil().setSp(50)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (selectedIndex != 0) {
                      selectedIndex = selectedIndex - 1;
                      setState(() {});
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                    child: Text(
                      "<- Previous",
                      style: GoogleFonts.nunitoSans(
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.w400,
                          color: selectedIndex != 0 ? blackGray : white),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildPageIndicator(selectedIndex),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (selectedIndex != 2) {
                      selectedIndex = selectedIndex + 1;
                      setState(() {});
                    } else {
                      if (isLoginTour) {
                        Get.back();
                      } else {
                        Get.offAllNamed(RouteConstants.homeScreen);
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                    child: Text(
                      selectedIndex != 2 ? "Next ->" : "Enter ->",
                      style: GoogleFonts.nunitoSans(
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.w700,
                          color: buttonBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildPageIndicator(selectedIndex) {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == selectedIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return SizedBox(
      height: ScreenUtil().setSp(3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        height: ScreenUtil().setSp(3),
        width: ScreenUtil().setSp(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
          Border.all(color: isActive ? buttonYellow : Colors.transparent),
          color: isActive ? buttonYellow : colorF2F2F2,
        ),
      ),
    );
  }
}
