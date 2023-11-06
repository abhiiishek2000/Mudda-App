import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/screens/muddabuzz_screen/widgets/tab_screens/follow_screen/follow_tab.dart';

import '../../home_screen/widget/tab_screens/search_screen/search_screen.dart';

class MuddabuzzScreen extends StatefulWidget {
  const MuddabuzzScreen({Key? key}) : super(key: key);

  @override
  _MuddabuzzScreenState createState() => _MuddabuzzScreenState();
}

class _MuddabuzzScreenState extends State<MuddabuzzScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  double tabIconHeight = 20;
  double tabIconWidth = 30;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              AppIcons.notificationIcon,
                              color: Colors.transparent,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                AppIcons.profileIcon,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text("Muddebaaz",
                          style: size18_M_semiBold(textColor: colorDarkBlack)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteConstants.notificationScreen);
                            },
                            child: Image.asset(AppIcons.notificationIcon),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(RouteConstants.profileScreen);
                              },
                              child: Image.asset(AppIcons.profileIcon),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 230.w,
                      child: TabBar(
                        onTap: (index) {
                          setState(() {});
                        },
                        controller: tabController,
                        indicatorColor: Colors.transparent,
                        labelColor: const Color(0xff3e3e3e),
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(
                            icon: Image.asset(
                              AppIcons.feedicon,
                              height: tabIconHeight,
                              width: tabIconWidth,
                            ),
                            child: Container(
                              width: 50,
                              height: 1,
                              color: tabController.index == 0
                                  ? colorDarkBlack
                                  : colorWhite,
                            ),
                          ),
                          Tab(
                            icon: Image.asset(
                              AppIcons.quotes,
                              height: 20,
                              width: tabIconWidth,
                            ),
                            child: Container(
                              width: 50,
                              height: 1,
                              color: tabController.index == 1
                                  ? colorDarkBlack
                                  : colorWhite,
                            ),
                          ),
                          Tab(
                            icon: Image.asset(
                              AppIcons.ribbon,
                              height: tabIconHeight,
                              width: tabIconWidth,
                            ),
                            child: Container(
                              width: 50,
                              height: 1,
                              color: tabController.index == 2
                                  ? colorDarkBlack
                                  : colorWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Image.asset(
                        AppIcons.searchIcon,
                        height: 20,
                        width: 20,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(120)),
      body: Stack(
        children: [
          TabBarView(
            children: const [
              FollowScreen(),
              Center(child: Text("Tab 2")),
              Center(child: Text("Tab 3")),
            ],
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
          ),
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 40,
                    width: 50,
                    alignment: Alignment.center,
                    child: Image.asset(
                      AppIcons.fireIcon,
                      color: Colors.white,
                      height: 20,
                      width: 20,
                    ),
                    decoration: BoxDecoration(
                      color: color606060.withOpacity(0.75),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteConstants.muddaBuzzFeed);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 8),
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
                              "Done",
                              style: size13_M_normal(textColor: colorDarkBlack),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,
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
                              size: 25,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
