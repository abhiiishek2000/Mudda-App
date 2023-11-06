import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/screens/leader_board/view/leader_board_screen.dart';

class LeaderBoardGridView extends StatefulWidget {
  const LeaderBoardGridView({Key? key}) : super(key: key);

  @override
  State<LeaderBoardGridView> createState() => _LeaderBoardGridViewState();
}

class _LeaderBoardGridViewState extends State<LeaderBoardGridView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isJoinLeaderShip = true;

  @override
  void initState() {
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                Text(
                  "Leader Board",
                  style: size18_M_bold(textColor: Colors.black),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    AppIcons.searchIcon,
                    height: 20,
                    width: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "BYCOTT CHINA SAVE THE WORLD, TO SAVE US TOO. IT’S JUST TESTING",
                textAlign: TextAlign.center,
                style: size12_M_normal(textColor: Colors.black),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 30,
              width: 290,
              child: TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.transparent,
                padding: EdgeInsets.zero,
                onTap: (int index) {
                  setState(() {});
                },
                tabs: [
                  Tab(
                    icon: Column(
                      children: [
                        Text(
                          "Favour(10.1k)",
                          style: tabController.index == 0
                              ? size14_M_normal(
                                  textColor: Colors.black,
                                )
                              : size14_M_normal(
                                  textColor: Colors.grey,
                                ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          height: 1,
                          color: tabController.index == 0
                              ? Colors.black
                              : Colors.white,
                        )
                      ],
                    ),
                  ),
                  Tab(
                    icon: Column(
                      children: [
                        Text(
                          "Opposition (2.1k)",
                          style: tabController.index == 1
                              ? size14_M_normal(
                                  textColor: Colors.black,
                                )
                              : size14_M_normal(
                                  textColor: Colors.grey,
                                ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          height: 1,
                          color: tabController.index == 1
                              ? Colors.black
                              : Colors.white,
                        )
                      ],
                    ),
                  )
                ],
                controller: tabController,
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ListView(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            AppIcons.dummyImage,
                                          ),
                                        ),
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: -5,
                                      child: CircleAvatar(
                                          child: Image.asset(
                                            AppIcons.verifyProfileIcon2,
                                            width: 13,
                                            height: 13,
                                            color: Colors.blue,
                                          ),
                                          radius: 8,
                                          backgroundColor: colorAppBackground),
                                    )
                                  ],
                                ),
                                Text(
                                  "Mohmadd Hussain",
                                  style: size12_M_bold(textColor: Colors.black),
                                ),
                                Text(
                                  "Mudda Creator",
                                  style: size12_M_normal(
                                    textColor: Colors.blue,
                                  ),
                                ),
                                followButton()
                              ],
                            ),
                            Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            AppIcons.dummyImage,
                                          ),
                                        ),
                                        border: Border.all(
                                          color: Colors.amber,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: -5,
                                      child: CircleAvatar(
                                          child: Image.asset(
                                            AppIcons.verifyProfileIcon2,
                                            width: 13,
                                            height: 13,
                                            color: Colors.amber,
                                          ),
                                          radius: 8,
                                          backgroundColor: colorAppBackground),
                                    )
                                  ],
                                ),
                                Text(
                                  "Mohmadd Hussain",
                                  style: size12_M_bold(textColor: Colors.black),
                                ),
                                Text(
                                  "Mudda Creator",
                                  style: size12_M_normal(
                                    textColor: Colors.amber,
                                  ),
                                ),
                                followButton()
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        runSpacing: 15,
                        spacing: 15,
                        children: List.generate(
                          25,
                          (index) => Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          AppIcons.dummyImage,
                                        ),
                                      ),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: -5,
                                    child: CircleAvatar(
                                        child: Image.asset(
                                          AppIcons.verifyProfileIcon2,
                                          width: 13,
                                          height: 13,
                                          color: Colors.black,
                                        ),
                                        radius: 8,
                                        backgroundColor: colorAppBackground),
                                  )
                                ],
                              ),
                              Text(
                                "Mohmadd Hussain",
                                style: size12_M_bold(textColor: Colors.black),
                              ),
                              Text(
                                "Mudda Creator",
                                style: size12_M_normal(
                                  textColor: Colors.black,
                                ),
                              ),
                              followButton()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  ListView(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            AppIcons.dummyImage,
                                          ),
                                        ),
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: -5,
                                      child: CircleAvatar(
                                          child: Image.asset(
                                            AppIcons.verifyProfileIcon2,
                                            width: 13,
                                            height: 13,
                                            color: Colors.blue,
                                          ),
                                          radius: 8,
                                          backgroundColor: colorAppBackground),
                                    )
                                  ],
                                ),
                                Text(
                                  "Mohmadd Hussain",
                                  style: size12_M_bold(textColor: Colors.black),
                                ),
                                Text(
                                  "Mudda Creator",
                                  style: size12_M_normal(
                                    textColor: Colors.blue,
                                  ),
                                ),
                                followButton()
                              ],
                            ),
                            Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            AppIcons.dummyImage,
                                          ),
                                        ),
                                        border: Border.all(
                                          color: Colors.amber,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: -5,
                                      child: CircleAvatar(
                                          child: Image.asset(
                                            AppIcons.verifyProfileIcon2,
                                            width: 13,
                                            height: 13,
                                            color: Colors.amber,
                                          ),
                                          radius: 8,
                                          backgroundColor: colorAppBackground),
                                    )
                                  ],
                                ),
                                Text(
                                  "Mohmadd Hussain",
                                  style: size12_M_bold(textColor: Colors.black),
                                ),
                                Text(
                                  "Mudda Creator",
                                  style: size12_M_normal(
                                    textColor: Colors.amber,
                                  ),
                                ),
                                followButton()
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        runSpacing: 15,
                        spacing: 15,
                        children: List.generate(
                          25,
                          (index) => Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          AppIcons.dummyImage,
                                        ),
                                      ),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: -5,
                                    child: CircleAvatar(
                                        child: Image.asset(
                                          AppIcons.verifyProfileIcon2,
                                          width: 13,
                                          height: 13,
                                          color: Colors.black,
                                        ),
                                        radius: 8,
                                        backgroundColor: colorAppBackground),
                                  )
                                ],
                              ),
                              Text(
                                "Mohmadd Hussain",
                                style: size12_M_bold(textColor: Colors.black),
                              ),
                              Text(
                                "Mudda Creator",
                                style: size12_M_normal(
                                  textColor: Colors.black,
                                ),
                              ),
                              followButton()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
                controller: tabController,
              ),
            )
          ],
        ),
      ),
    );
  }
  followButton() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(3))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: Text(
          "Follow",
          style: size10_M_normal(textColor: colorGrey),
        ),
      ),
    );
  }
}
