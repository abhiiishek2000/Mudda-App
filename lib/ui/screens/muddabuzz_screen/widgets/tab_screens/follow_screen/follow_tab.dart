import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/ui/screens/muddabuzz_screen/widgets/tab_screens/follow_screen/siuggestion_follow.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';

import '../../../../../../core/utils/text_style.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({Key? key}) : super(key: key);

  @override
  _FollowScreenState createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 5,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 60.h,
          alignment: Alignment.center,
          child: Text.rich(
            TextSpan(
                text: "To see ",
                style: size14_M_normal(textColor: color606060),
                children: [
                  TextSpan(
                    text: "Activites",
                    style: size14_M_bold(textColor: colorDarkBlack),
                  ),
                  TextSpan(
                    text: ", you need to\n   follow Muddebaaz or Org",
                    style: size14_M_normal(textColor: color606060),
                  ),
                ]),
          ),
        ),
        Vs(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "    Start\nFollowing",
              style: size12_M_regular300(textColor: color606060),
            ),
            Hs(
              width: 20.w,
            ),
            Container(
                height: 15, width: 15, child: Image.asset(AppIcons.downhand)),
          ],
        ),
        Vs(height: 30.h),
        SizedBox(
          height: 35,
          child: TabBar(
            onTap: (index) {
              setState(() {});
            },
            isScrollable: true,
            controller: tabController,
            indicatorColor: Colors.transparent,
            labelColor: const Color(0xff3e3e3e),
            unselectedLabelColor: color606060,
            padding: const EdgeInsets.only(right: 40),
            tabs: [
              Tab(
                child: Column(
                  children: [
                    Text("Suggestions",
                        style: tabController.index == 0
                            ? size14_M_bold(textColor: color606060)
                            : size12_M_regular300(textColor: colorA0A0A0)),
                    Vs(height: 2),
                    Container(
                      width: 80,
                      height: 1,
                      color: tabController.index == 0
                          ? colorDarkBlack
                          : colorWhite,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Text(
                      "Ujjain",
                      style: tabController.index == 1
                          ? size14_M_bold(textColor: color606060)
                          : size12_M_regular300(textColor: colorA0A0A0),
                    ),
                    Vs(height: 2),
                    Container(
                      width: 40,
                      height: 1,
                      color:
                          tabController.index == 1 ? color606060 : colorA0A0A0,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Text("Madhya Pradesh",
                        style: tabController.index == 2
                            ? size14_M_bold(textColor: color606060)
                            : size12_M_regular300(textColor: colorA0A0A0)),
                    Vs(height: 2),
                    Container(
                      width: 110,
                      height: 1,
                      color:
                          tabController.index == 2 ? color606060 : colorA0A0A0,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Text("India",
                        style: tabController.index == 3
                            ? size14_M_bold(textColor: color606060)
                            : size12_M_regular300(textColor: colorA0A0A0)),
                    Vs(height: 2),
                    Container(
                      width: 40,
                      height: 1,
                      color:
                          tabController.index == 3 ? color606060 : colorA0A0A0,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Text("World",
                        style: tabController.index == 4
                            ? size14_M_bold(textColor: color606060)
                            : size12_M_regular300(textColor: colorA0A0A0)),
                    Vs(height: 2),
                    Container(
                      width: 40,
                      height: 1,
                      color:
                          tabController.index == 4 ? color606060 : colorA0A0A0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TabBarView(
              controller: tabController,
              children: [
                SuggestionFollow(),
                Container(),
                Container(),
                Container(),
                Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
