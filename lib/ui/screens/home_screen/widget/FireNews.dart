import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/screens/home_screen/widget/hot_mudda.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';
import 'box_one_widget.dart';

class StagesFireNews extends StatefulWidget {
  const StagesFireNews({Key? key}) : super(key: key);

  @override
  _StagesFireNewsState createState() => _StagesFireNewsState();
}

class _StagesFireNewsState extends State<StagesFireNews> {
  final GlobalKey globalKeyOne = GlobalKey();
  final GlobalKey globalKeyTwo = GlobalKey();
  final GlobalKey globalKeyThree = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BoxContainerOne(),
              Container(
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
                    ), //BoxShadow//BoxShadow
                  ],
                ),
                child: Column(
                  children: [
                    Vs(height: 8.h),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.network(
                              "https://images.indianexpress.com/2014/03/russia-1200.jpg?w=626",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                              "भारत को फिर से विश्वगुरु बनाना है।  चलो करो सपोर्ट एंड लगाओ पोस्ट्स",
                              style: size14_M_bold(textColor: colorDarkBlack)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 130,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Vs(height: 10),
                                SizedBox(
                                  width: 140,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                const Icon(
                                  Icons.add,
                                  size: 15,
                                ),
                                Text(
                                  "32 Paksh Leaders",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 150,
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 90,
                              width: 0.5,
                              color: colorA0A0A0,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Vs(height: 10),
                                SizedBox(
                                  width: 140,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                const Icon(
                                  Icons.add,
                                  size: 15,
                                ),
                                Text(
                                  "32 Vipaksh Leaders",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
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
                                    style:
                                    size12_M_bold(textColor: colorDarkBlack)
                                        .copyWith(height: 1.8))
                              ]),
                              style: size12_M_normal(textColor: color606060)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("25",
                                  style:
                                  size16_M_normal(textColor: color0060FF)),
                              Hs(
                                width: 8.w,
                              ),
                              Image.asset(
                                AppIcons.blueMic,
                                height: 20.h,
                                width: 12.w,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text("2.5K",
                                  style:
                                  size12_M_normal(textColor: color606060)),
                              const Hs(
                                width: 5,
                              ),
                              Image.asset(
                                AppIcons.groupPeople,
                                height: 16.h,
                                width: 22.w,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text("1.2% ",
                                  style: size12_M_bold(textColor: colorFF2121)),
                              const Icon(
                                Icons.arrow_downward,
                                color: colorFF2121,
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
              ),
              MuddaFireNews(globaleKey: globalKeyOne,globaleKey1: globalKeyTwo,globalKey2: globalKeyThree),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10),
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
                    ), //BoxShadow//BoxShadow
                  ],
                ),
                child: Column(
                  children: [
                    Vs(height: 8.h),
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: 70.h,
                                width: 70.w,
                                child: Image.network(
                                  "https://images.indianexpress.com/2014/03/russia-1200.jpg?w=626",
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                  "Pesticide is the reason for Cancer. We want this to be banned",
                                  style:
                                  size14_M_bold(textColor: colorDarkBlack)),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Utter Pradesh",
                                        style: size12_M_bold(
                                            textColor: colorDarkBlack)
                                            .copyWith(height: 1.8)),
                                    const Hs(
                                      width: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text("82.31%",
                                            style: size12_M_bold(
                                                textColor: color0060FF)
                                                .copyWith(height: 1.8)),
                                        Text("  / 1.3B",
                                            style: size12_M_regular300(
                                                textColor: color0060FF)
                                                .copyWith(height: 1.8)),
                                        const Hs(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          AppIcons.bluehandsheck,
                                          height: 20,
                                          width: 20,
                                        ),
                                        const Hs(width: 10),
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colorDarkBlack),
                                        ),
                                        const Hs(width: 5),
                                        Text("Follow",
                                            style: size10_M_regular300(
                                                textColor: colorDarkBlack)
                                                .copyWith(height: 1.8)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Vs(height: 10.h),
                    SizedBox(
                      height: 80.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RoundImages(name: "Subbraminam S"),
                              Hs(width: 5.w),
                              RoundImages(name: "Trilok C"),
                              Hs(width: 10.w),
                              RoundImages(name: "Trilok C"),
                              Hs(width: 10.w),
                              RoundImages(name: "Trilok C"),
                              Hs(width: 10.w),
                              Icon(Icons.add, size: 15.sp),
                              // Hs(width: 5.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "1032 Leaders",
                                    style: size12_M_normal(
                                        textColor: colorDarkBlack),
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
                    Vs(height: 10.h),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: colorF2F2F2,
                    ),
                    Vs(height: 10.h),
                    Row(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 40.h,
                                width: 40.w,
                                alignment: Alignment.center,
                                child: SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: Image.asset(
                                      AppIcons.shakeHandIcon,
                                      color: Colors.white,
                                    )),
                                decoration: BoxDecoration(
                                  color: color606060,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: color606060),
                                ),
                              ),
                            ),
                            const Hs(width: 15),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 40.h,
                                width: 40.w,
                                alignment: Alignment.center,
                                child: SizedBox(
                                    height: 15.h,
                                    width: 15.w,
                                    child: Image.asset(AppIcons.dislike)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: colorA0A0A0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Hs(width: 10.w),
                        Column(
                          children: [
                            Text(
                              "Recent Updates:         ",
                              style: size12_M_normal(textColor: colorDarkBlack),
                            ),
                            Vs(height: 5.h),
                            Text(
                              "10.21k New supports\n5% Up, 100 new posts\n1.2k reactions\n100 New Leaders Joined.",
                              style: size10_M_normal(textColor: color0060FF),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Column(
                          children: [
                            SizedBox(
                                height: 30.h,
                                child: Image.asset(AppIcons.description)),
                            SizedBox(
                                height: 30.h,
                                child: Image.asset(AppIcons.action)),
                          ],
                        ),
                      ],
                    ),
                    Vs(height: 10.h),
                    Container(
                      width: double.infinity,
                      height: 1.h,
                      color: colorF2F2F2,
                    ),
                    Vs(
                      height: 4.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("#Political, #Social, #Educational",
                            style: size10_M_normal(textColor: colorDarkBlack)),
                        Hs(width: 5.h),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorDarkBlack),
                        ),
                        Hs(width: 5.h),
                        Text("Lucknow, UP, India",
                            style: size12_M_normal(textColor: colorDarkBlack)),
                        Hs(width: 5.h),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorDarkBlack),
                        ),
                        Hs(width: 5.h),
                        Text("2 days ago",
                            style: size10_M_normal(textColor: colorDarkBlack)),
                      ],
                    ),
                  ],
                ),
              ),
              const Vs(height: 70)
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkImageBox extends StatelessWidget {
  NetworkImageBox({Key? key, required this.imageString}) : super(key: key);

  String imageString;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.network(
          imageString,
          fit: BoxFit.cover,
          height: 40.h,
          width: 40.w,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
              border: Border.all(color: colorWhite),
              borderRadius: BorderRadius.circular(5)),
          child: const Icon(
            Icons.play_arrow_outlined,
            color: colorWhite,
            size: 12,
          ),
        )
      ],
    );
  }
}

class RoundImages extends StatelessWidget {
  String? name;

  RoundImages({this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteConstants.otherUserProfileScreen);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
                "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg"),
          ),
          Vs(height: 5.h),
          Text(
            "$name",
            style: size10_M_regular300(
                letterSpacing: 0.0, textColor: colorDarkBlack),
          ),
        ],
      ),
    );
  }
}