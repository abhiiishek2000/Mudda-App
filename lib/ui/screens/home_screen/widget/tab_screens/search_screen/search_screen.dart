import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/SearchModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/search_controller_new.dart';
import 'package:mudda/ui/screens/home_screen/widget/tab_screens/search_screen/initial_explore.dart';
import 'package:mudda/ui/screens/home_screen/widget/tab_screens/search_screen/muddas_search.dart';
import 'package:mudda/ui/screens/home_screen/widget/tab_screens/search_screen/orgs_search.dart';
import 'package:mudda/ui/screens/home_screen/widget/tab_screens/search_screen/profiles_search.dart';
import 'package:mudda/ui/shared/home_app_bar_actions.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';

import '../../../../../../core/constant/app_icons.dart';
import '../../../../../../core/constant/route_constants.dart';
import '../../../../../../core/utils/color.dart';
import '../../../../../../core/utils/text_style.dart';
import '../../../../../../model/MuddaPostModel.dart';
import '../../../controller/mudda_fire_news_controller.dart';
import 'all_search.dart';
import 'search_field_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late TabController tabController2;
  MuddaNewsController muddaNewsController = Get.put(MuddaNewsController());

  double tabIconHeight = 20;
  double tabIconWidth = 30;
  SearchController? searchController;
  int page = 1;

  @override
  void initState() {
    super.initState();
    searchController = Get.find<SearchController>();
    tabController2 = TabController(length: 1, vsync: this, initialIndex: 0);
    tabController = TabController(
      length: 4,
      vsync: this,
    );
    tabController2.addListener(() {
      if (tabController2.index == 1) {
        muddaNewsController.isHotMuddaLoading.value = true;
        Api.get.call(context,
            method: "mudda/index",
            param: {
              "user_id": AppPreference().getString(PreferencesKey.userId)
            },
            isLoading: true, onResponseSuccess: (Map object) {
          var result = MuddaPostModel.fromJson(object);
          muddaNewsController.isNotiAvailaable.value =
              result.notifications ?? false;
          muddaNewsController.isHotMuddaLoading.value = false;
          if (result.data!.isNotEmpty) {
            muddaNewsController.muddaProfilePath.value = result.path!;
            muddaNewsController.muddaUserProfilePath.value = result.userpath!;
            muddaNewsController.muddaPostList.clear();
            muddaNewsController.muddaPostList.addAll(result.data!);
          } else {
            muddaNewsController.isHotMuddaLoading.value = false;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorAppBackground,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: colorAppBackground,
          elevation: 0,
          leading: Obx(() => GestureDetector(
            onTap: () {
              Get.toNamed(RouteConstants.notificationScreen);
            },
            child: Center(
              child: Container(
                  height: ScreenUtil().setHeight(25),
                  width: ScreenUtil().setHeight(23),
                  child: Stack(children: [
                    SvgPicture.asset(
                      AppIcons.bellIcon,
                      width: 19,
                      height: 19,
                      fit: BoxFit.fill,
                      color: blackGray,
                    ),
                    if (muddaNewsController
                        .isNotiAvailaable.value)
                      Align(
                          alignment: Alignment.topRight,
                          child: Container(
                              height: 6,
                              width: 6,
                              decoration: const BoxDecoration(
                                  color: buttonBlue,
                                  shape: BoxShape.circle)))
                  ])),
            ),
          )),
          title: Text(
            "Explore",
            style: size18_M_semiBold(textColor: colorDarkBlack),
          ),
          actions: const [
            HomeAppBarActions()
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 35,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: CustomSearchFieldWidget(
                      borderColor: colorA0A0A0,
                      hintText: "Search",
                      onFieldSubmitted: (text) {
                        searchController!.search = text;
                        searchController!.flag.value = false;
                        Api.get.call(context,
                            method: "global/search",
                            param: {
                              "search": text,
                              "page": page.toString(),
                              "user_id": AppPreference()
                                  .getString(PreferencesKey.userId)
                            },
                            isLoading: false, onResponseSuccess: (Map object) {
                          var result = SearchModel.fromJson(object);
                          searchController!.muddaPath.value = result.path!;
                          searchController!.userProfilePath.value =
                              result.userpath!;
                          searchController!.muddaList.clear();
                          searchController!.userProfilesList.clear();
                          searchController!.orgList.clear();
                          searchController!.muddaList.addAll(result.mudda!);
                          searchController!.userProfilesList
                              .addAll(result.userdata!);
                          searchController!.orgList.addAll(result.orgData!);
                        });
                      },
                    ),
                  ),
                ),
                Vs(height: 15.h),
                SizedBox(
                  height: 35,
                  child: TabBar(
                    onTap: (index) {
                      setState(() {});
                    },
                    controller: tabController,
                    indicatorColor: Colors.transparent,
                    labelColor: const Color(0xff3e3e3e),
                    unselectedLabelColor: color606060,
                    tabs: [
                      Tab(
                        child: Column(
                          children: [
                            const Text("All"),
                            Container(
                              width: 50,
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
                            const Text("Muddas"),
                            Container(
                              width: 50,
                              height: 1,
                              color: tabController.index == 1
                                  ? colorDarkBlack
                                  : colorWhite,
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            const Text("Profiles"),
                            Container(
                              width: 50,
                              height: 1,
                              color: tabController.index == 2
                                  ? colorDarkBlack
                                  : colorWhite,
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            const Text("Orgs"),
                            Container(
                              width: 50,
                              height: 1,
                              color: tabController.index == 3
                                  ? colorDarkBlack
                                  : colorWhite,
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
                    child:
                        Obx(()=>searchController!.flag.value? InitialExplore():
                        TabBarView(
                      controller: tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        AllSearch(),
                        MuddasSearch(),
                        ProfilesSearch(),
                        OrgsSearch(),
                      ],
                    )),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: 50,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(AppIcons.icMudda,
                              height: 20, width: 16, color: Colors.white),
                          decoration: BoxDecoration(
                            color: color606060.withOpacity(0.75),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
    /* return Column(
      children: [
        SizedBox(
          height: 35,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: CustomSearchFieldWidget(
              borderColor: colorA0A0A0,
              hintText: "Search",
              onFieldSubmitted: (text){
                searchController!.search = text;
                Api.get.call(context,
                    method: "global/search",
                    param: {
                  "search":text,
                  "page":page.toString(),
                  "user_id": AppPreference().getString(PreferencesKey.userId)
                    },
                    isLoading: false, onResponseSuccess: (Map object) {
                      var result = SearchModel.fromJson(object);
                      searchController!.muddaPath.value = result.path!;
                      searchController!.userProfilePath.value = result.userpath!;
                      searchController!.muddaList.clear();
                      searchController!.userProfilesList.clear();
                      searchController!.orgList.clear();
                      searchController!.muddaList.addAll(result.mudda!);
                      searchController!.userProfilesList.addAll(result.userdata!);
                      searchController!.orgList.addAll(result.orgData!);
                    });
              },
            ),
          ),
        ),
        Vs(height: 15.h),
        SizedBox(
          height: 35,
          child: TabBar(
            onTap: (index) {
              setState(() {});
            },
            controller: tabController,
            indicatorColor: Colors.transparent,
            labelColor: const Color(0xff3e3e3e),
            unselectedLabelColor: color606060,
            tabs: [
              Tab(
                child: Column(
                  children: [
                    const Text("All"),
                    Container(
                      width: 50,
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
                    const Text("Muddas"),
                    Container(
                      width: 50,
                      height: 1,
                      color: tabController.index == 1
                          ? colorDarkBlack
                          : colorWhite,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    const Text("Profiles"),
                    Container(
                      width: 50,
                      height: 1,
                      color: tabController.index == 2
                          ? colorDarkBlack
                          : colorWhite,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    const Text("Orgs"),
                    Container(
                      width: 50,
                      height: 1,
                      color: tabController.index == 3
                          ? colorDarkBlack
                          : colorWhite,
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
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AllSearch(),
                MuddasSearch(),
                ProfilesSearch(),
                OrgsSearch(),
              ],
            ),
          ),
        ),
      ],
    );*/
  }
}


// Column(
//             children: [
//               SizedBox(
//                 height: ScreenUtil().setSp(35),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 20),
//                   child: CustomSearchFieldWidget(
//                     borderColor: colorA0A0A0,
//                     hintText: "Search",
//                     onFieldSubmitted: (text) {
//                       page = 1;
//                       setState(() {
//                         flag = 1;
//                       });
//                       searchController!.search = text;
//                       Api.get.call(context,
//                           method: "global/search",
//                           param: {
//                             "search": text,
//                             "page": page.toString(),
//                             "user_id":
//                                 AppPreference().getString(PreferencesKey.userId)
//                           },
//                           isLoading: false, onResponseSuccess: (Map object) {
//                         var result = SearchModel.fromJson(object);
//                         searchController!.muddaPath.value = result.path!;
//                         searchController!.userProfilePath.value =
//                             result.userpath!;
//                         searchController!.muddaList.clear();
//                         searchController!.userProfilesList.clear();
//                         searchController!.orgList.clear();
//                         searchController!.muddaList.addAll(result.mudda!);
//                         searchController!.userProfilesList
//                             .addAll(result.userdata!);
//                         searchController!.orgList.addAll(result.orgData!);
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               Vs(height: ScreenUtil().setSp(15).h),
//               SizedBox(
//                 height: ScreenUtil().setSp(35),
//                 child: TabBar(
//                   onTap: (index) {
//                     setState(() {});
//                   },
//                   controller: tabController,
//                   indicatorColor: Colors.transparent,
//                   labelColor: const Color(0xff3e3e3e),
//                   unselectedLabelColor: color606060,
//                   tabs: [
//                     Tab(
//                       child: Column(
//                         children: [
//                           const Text("All"),
//                           Container(
//                             width: 50,
//                             height: 1,
//                             color: tabController.index == 0
//                                 ? colorDarkBlack
//                                 : colorWhite,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Tab(
//                       child: Column(
//                         children: [
//                           const Text("Muddas"),
//                           Container(
//                             width: 50,
//                             height: 1,
//                             color: tabController.index == 1
//                                 ? colorDarkBlack
//                                 : colorWhite,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Tab(
//                       child: Column(
//                         children: [
//                           const Text("Profiles"),
//                           Container(
//                             width: 50,
//                             height: 1,
//                             color: tabController.index == 2
//                                 ? colorDarkBlack
//                                 : colorWhite,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Tab(
//                       child: Column(
//                         children: [
//                           const Text("Orgs"),
//                           Container(
//                             width: 50,
//                             height: 1,
//                             color: tabController.index == 3
//                                 ? colorDarkBlack
//                                 : colorWhite,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),