import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';

import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';

class FollowerFollowingSuggestionScreen extends StatefulWidget {
  const FollowerFollowingSuggestionScreen({Key? key, this.index = 0})
      : super(key: key);
  final int index;

  @override
  State<FollowerFollowingSuggestionScreen> createState() =>
      _FollowerFollowingSuggestionScreenState();
}

class _FollowerFollowingSuggestionScreenState
    extends State<FollowerFollowingSuggestionScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int tabIndexSelect = 0;
  @override
  void initState() {
    tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.index);
    tabIndexSelect = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Image.asset(AppIcons.searchIcon,
                              height: 20, width: 20),
                          const SizedBox(
                            width: 20,
                          ),
                          Image.asset(AppIcons.filterIcon,
                              height: 20, width: 20),
                          const SizedBox(
                            width: 20,
                          ),
                          Image.asset(AppIcons.filterIcon2,
                              height: 20, width: 20),
                        ],
                      ),
                    )
                  ],
                ),
                TabBar(
                  controller: tabController,
                  labelColor: colorGrey,
                  padding: EdgeInsets.only(top: 20),
                  indicatorWeight: .1,
                  indicatorColor: Colors.transparent,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                  labelStyle: TextStyle(
                      fontSize: getWidth(13), fontWeight: FontWeight.bold),
                  unselectedLabelColor: Colors.grey,
                  onTap: (int index) {
                    setState(() {});
                    tabIndexSelect = index;
                  },
                  tabs: [
                    Tab(
                      icon: Column(
                        children: [
                          const Text("Followers 1.5k"),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            color:
                                tabIndexSelect == 0 ? colorGrey : Colors.grey,
                            height: 2,
                          )
                        ],
                      ),
                    ),
                    Tab(
                      icon: Column(
                        children: [
                          const Text("Following 1.5k"),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            color:
                                tabIndexSelect == 1 ? colorGrey : Colors.grey,
                            height: 2,
                          )
                        ],
                      ),
                    ),
                    Tab(
                      icon: Column(
                        children: [
                          const Text("Suggestions"),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            color:
                                tabIndexSelect == 2 ? colorGrey : Colors.grey,
                            height: 2,
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          FollowersScreen(),
          FollowingScreen(),
          SuggestionsScreen()
        ],
      ),
    );
  }
}

class FollowersScreen extends StatelessWidget {
  const FollowersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        100,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
          child: Row(
            children: [
               CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(AppIcons.dummyImage),
                radius: 20,
              ),
              getSizedBox(w: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ranveer Singh",
                    style: size15_M_medium(textColor: Colors.black),
                  ),
                  Text(
                    "Mumbai,India",
                    style: size12_M_medium(textColor: colorGrey),
                  ),
                ],
              ),
              Spacer(),
              Text(
                "Follow Back",
                style: size13_M_medium(textColor: Colors.black),
              ),
              getSizedBox(w: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorGrey),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text("Remove"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        100,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
          child: Row(
            children: [
               CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(AppIcons.dummyImage),
                radius: 20,
              ),
              getSizedBox(w: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ranveer Singh",
                    style: size15_M_medium(textColor: Colors.black),
                  ),
                  Text(
                    "Mumbai,India",
                    style: size12_M_medium(textColor: colorGrey),
                  ),
                ],
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorGrey),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text("UnFollow"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController2;
  int tabIndexSelect = 0;
  @override
  void initState() {
    tabController2 = TabController(
      length: 5,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabList = [
      "Recommended",
      "Ujjain",
      "Madhya Pradesh",
      "Gujarat",
      "Rajasthan"
    ];
    return Column(
      children: [
        Container(
          height: 30,
          child: TabBar(
            controller: tabController2,
            labelColor: colorGrey,
            isScrollable: true,
            labelPadding: EdgeInsets.only(left: 20),
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.transparent,
            onTap: (int index) {
              setState(() {});
              tabIndexSelect = index;
            },
            tabs: List.generate(
              tabList.length,
              (index) => Tab(
                icon: Column(
                  children: [
                    Text(tabList[index]),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: tabIndexSelect == index ? colorGrey : Colors.grey,
                      height: 2,
                      width: 120,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        getSizedBox(h: 20),
        Expanded(
            child: TabBarView(
          controller: tabController2,
          children: [
            RecommendedScreen(),
            RecommendedScreen(),
            RecommendedScreen(),
            RecommendedScreen(),
            RecommendedScreen(),
          ],
        ))
      ],
    );
  }
}

class RecommendedScreen extends StatelessWidget {
  const RecommendedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        100,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
          child: Row(
            children: [
               CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(AppIcons.dummyImage),
                radius: 20,
              ),
              getSizedBox(w: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ranveer Singh",
                    style: size15_M_medium(textColor: Colors.black),
                  ),
                  Text(
                    "Mumbai,India",
                    style: size12_M_medium(textColor: colorGrey),
                  ),
                ],
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorGrey),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Text("Follow",
                      style: TextStyle(color: Colors.blueAccent)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
