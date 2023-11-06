import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/CategoryListModel.dart';
import 'package:mudda/model/HotMuddaPaginateResponse.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserJoinLeadersModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/home_screen/widget/component/hot_mudda_post.dart';
import 'package:mudda/ui/screens/home_screen/widget/component/walkthrough_card.dart';
import 'package:mudda/ui/screens/home_screen/widget/show_case_widget.dart';
import 'package:mudda/ui/screens/leader_board/controller/LeaderBoardApprovalController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../model/UnapprovedMuddaCount.dart';
import '../../../shared/Hot_Mudda_Ad.dart';
import '../../../shared/report_post_dialog_box.dart';
import 'component/hot_mudda_post_with_showcase.dart';
import 'component/loading_view.dart';

class MuddaFireNews extends StatefulWidget {
  const MuddaFireNews(
      {Key? key,
      required this.globaleKey,
      required this.globaleKey1,
      required this.globalKey2})
      : super(key: key);
  final GlobalKey globaleKey;
  final GlobalKey globaleKey1;
  final GlobalKey globalKey2;


  @override
  State<MuddaFireNews> createState() => _MuddaFireNewsState();

}

class _MuddaFireNewsState extends State<MuddaFireNews> {
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();

  int page = 1;
  int topPage = 1;
  int invitedPage = 1;
  String? lastReadId;
  LeaderBoardApprovalController leaderBoardApprovalController =
      Get.put(LeaderBoardApprovalController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // NativeAd? _ad;

  @override
  void initState() {
    // muddaScrollController.addListener(() {
    //   if (muddaScrollController.position.maxScrollExtent ==
    //       muddaScrollController.position.pixels) {
    //     page++;
    //     _getMuddaPost(context);
    //   }
    // });

    Api.get.call(context,
        method: "category/index",
        param: {
          "search": "",
          "page": "1",
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = CategoryListModel.fromJson(object);
      print(result);
      muddaNewsController.categoryList.clear();
      for (Category category in result.data!) {
        print("Category Data $category");
        muddaNewsController.categoryList.add(category.name!);
      }
    });
    Api.get.call(context, method: "mudda/count", param: {}, isLoading: false,
        onResponseSuccess: (Map object) {
      var result = UnapprovedMuddaCount.fromJson(object);
      muddaNewsController.unapprovedMuddaCount.value =
          result.result!.underApproval!;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onRefresh() async {
    _getTopPaginateMuddaPost(
        lastReadPostID: lastReadId ??
            "${muddaNewsController.muddaPostList.first.createdAt}",
        type: 'prev');
  }

  void _onLoading() async {
    _getPaginateMuddaPost(
        lastReadPostID:
            lastReadId ?? "${muddaNewsController.muddaPostList.last.createdAt}",
        type: 'next');
  }


  @override
  Widget build(BuildContext context) {
    // muddaNewsController.addListener(() {
    //   if(muddaNewsController.visible.value) {
    //     _backtoTop(context);
    //     muddaNewsController.visible.value=false;
    //   }
    // });
    return Obx(() => SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: const WaterDropHeader(),
          footer: CustomFooter(
            height: Get.height * 0.2,
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = const Center(child: Text("Pull Up To Load More..."));
              } else if (mode == LoadStatus.loading) {
                body = const HotMuddaLoadingView();
              } else if (mode == LoadStatus.failed) {
                body = const Center(child: Text("Load Failed!Click retry!"));
              } else if (mode == LoadStatus.canLoading) {
                body = const Center(child: Text("Release to load more..."));
              } else {
                body = const Center(child: Text("No more Data"));
              }
              return body;
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView(
            controller: muddaNewsController.homeScrollController,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setSp(16),
                    bottom: ScreenUtil().setSp(12)),
                child: Text(
                  "Hot Muddas",
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(14),
                      color: blackGray),
                ),
              ),
              if (muddaNewsController.unapprovedMuddaCount > 0 &&
                  muddaNewsController.isRemind.value == false)
                Obx(() => Dismissible(
                      key: const ValueKey('dismiss'),
                      onDismissed: (DismissDirection v) {
                        muddaNewsController.isRemind.value = true;
                      },
                      background: Container(
                        color: buttonBlue.withOpacity(0.25),
                      ),
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 16),
                        margin: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                                'You have ${muddaNewsController.unapprovedMuddaCount} Unapproved Mudda. Invite the required number of Leaders to bring them to Public',
                                style:
                                    size14_M_normal(textColor: Colors.black)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      muddaNewsController.isRemind.value = true;
                                    },
                                    child: const Text('Dismiss')),
                                TextButton(
                                    onPressed: () {
                                      muddaNewsController.tabController.index =
                                          2;
                                      Get.toNamed(RouteConstants.homeScreen);
                                    },
                                    child: const Text('Invite Leaders Now ->')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
               WalkthroughCardWidget(),
              Obx(() => muddaNewsController.isHotMuddaLoading.value
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 24);
                      },
                      itemBuilder: (context, index) {
                        return const HotMuddaLoadingView();
                      })
                  : ListView.builder(
                //ShowCaseView(
                //                       globalKey: widget.globaleKey,
                //                       title:
                //                           'This is feed that contains all the Mudda (Topics)',
                //                       description: 'Scroll to see them',
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
                      itemCount: muddaNewsController.muddaPostList.length,
                      itemBuilder: (followersContext, index) {
                        MuddaPost muddaPost =
                            muddaNewsController.muddaPostList[index];

                        int muddaCreator = muddaPost.leaders!
                            .where((element) =>
                                element.joinerType == 'creator')
                            .length;
                        int muddaLeader = muddaPost.leaders!
                            .where(
                                (element) => element.joinerType == 'leader')
                            .length;
                        int muddaInitialLeader = muddaPost.leaders!
                            .where((element) =>
                                element.joinerType == 'initial_leader')
                            .length;
                        int muddaOpposition = muddaPost.leaders!
                            .where((element) =>
                                element.joinerType == 'opposition')
                            .length;
                        int muddaReaction = muddaPost.myReaction!
                            .where((element) =>
                                element.joinerType == 'unsupport')
                            .length;

                        if (index != 0 && index == 2) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(height:ScreenUtil().setSp(16)),
                              const HotMuddaAD(),
                              HotMuddaPost(
                                  muddaPost: muddaPost,
                                  index: index,
                                  muddaCreator: muddaCreator,
                                  muddaInitialLeader: muddaInitialLeader,
                                  muddaLeader: muddaLeader,
                                  muddaOpposition: muddaOpposition)
                            ],
                          );
                        } else if (index != 0 && (index - 2) % 5 == 0) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(height:ScreenUtil().setSp(16)),
                              const HotMuddaAD(),
                              HotMuddaPost(
                                muddaPost: muddaPost,
                                index: index,
                                muddaCreator: muddaCreator,
                                muddaInitialLeader: muddaInitialLeader,
                                muddaLeader: muddaLeader,
                                muddaOpposition: muddaOpposition,
                              )
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // index == 0
                              //     ? ShowCaseView(
                              //         globalKey: widget.globaleKey1,
                              //         title:
                              //             'To visit the Mudda Debate Forum',
                              //         description:
                              //             'Click on any Mudda Card',
                              //         child: HotMuddaPostWishShowcase(
                              //             muddaPost: muddaPost,
                              //             index: index,
                              //             globaleKey: widget.globalKey2,
                              //             muddaCreator: muddaCreator,
                              //             muddaInitialLeader:
                              //                 muddaInitialLeader,
                              //             muddaLeader: muddaLeader,
                              //             muddaOpposition: muddaOpposition),
                              //       )
                              //     :
                              HotMuddaPost(
                                      muddaPost: muddaPost,
                                      index: index,
                                      muddaCreator: muddaCreator,
                                      muddaInitialLeader:
                                          muddaInitialLeader,
                                      muddaLeader: muddaLeader,
                                      muddaOpposition: muddaOpposition),

                              /*index % 5 == 4
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 8, right: 8),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            'To help you serve better...\n',
                                        style: size14_M_normal(
                                          textColor: color606060,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Choose',
                                            style: size14_M_normal(
                                              textColor: color606060,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' Categories ',
                                            style: size14_M_bold(
                                              textColor: color202020,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'of your Choice',
                                            style: size14_M_normal(
                                              textColor: color606060,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Obx(
                                      () => Padding(
                                        padding: EdgeInsets.only(
                                            bottom:
                                                ScreenUtil().setWidth(20)),
                                        child: GroupButton(
                                          textPadding: EdgeInsets.only(
                                              left: ScreenUtil().setSp(8),
                                              right: ScreenUtil().setSp(8)),
                                          runSpacing: ScreenUtil().setSp(9),
                                          groupingType: GroupingType.wrap,
                                          spacing: ScreenUtil().setSp(5),
                                          crossGroupAlignment:
                                              CrossGroupAlignment.start,
                                          buttonHeight:
                                              ScreenUtil().setSp(24),
                                          isRadio: false,
                                          direction: Axis.horizontal,
                                          selectedButtons:
                                              muddaNewsController
                                                  .selectedCategory,
                                          onSelected: (index, ageSelected) {
                                            if (ageSelected &&
                                                !muddaNewsController
                                                    .selectedCategory
                                                    .contains(index)) {
                                              muddaNewsController
                                                  .selectedCategory
                                                  .add(index);
                                            } else if (!ageSelected &&
                                                muddaNewsController
                                                    .selectedCategory
                                                    .contains(index)) {
                                              muddaNewsController
                                                  .selectedCategory
                                                  .remove(index);
                                            }
                                          },
                                          buttons: muddaNewsController
                                              .categoryList.value,
                                          selectedTextStyle:
                                              GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                ScreenUtil().setSp(12),
                                            color: Colors.white,
                                          ),
                                          unselectedTextStyle:
                                              GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                ScreenUtil().setSp(12),
                                            color: lightGray,
                                          ),
                                          selectedColor: darkGray,
                                          unselectedColor:
                                              Colors.transparent,
                                          selectedBorderColor: lightGray,
                                          unselectedBorderColor: lightGray,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  ScreenUtil().radius(15)),
                                          selectedShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.transparent)
                                          ],
                                          unselectedShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.transparent)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            List<String> hashtags = [];
                                            List<String> location = [];
                                            List<String> customLocation =
                                                [];
                                            List<String> locationValues =
                                                [];
                                            List<String>
                                                customLocationValues = [];
                                            List<String> gender = [];
                                            List<String> age = [];
                                            for (int index
                                                in muddaNewsController
                                                    .selectedLocation) {
                                              location.add(
                                                  muddaNewsController
                                                      .apiLocationList
                                                      .elementAt(index));
                                              if (index == 0) {
                                                locationValues.add(
                                                    AppPreference()
                                                        .getString(
                                                            PreferencesKey
                                                                .city));
                                              } else if (index == 1) {
                                                locationValues.add(
                                                    AppPreference()
                                                        .getString(
                                                            PreferencesKey
                                                                .state));
                                              } else if (index == 2) {
                                                locationValues.add(
                                                    AppPreference()
                                                        .getString(
                                                            PreferencesKey
                                                                .country));
                                              } else {
                                                locationValues.add("");
                                              }
                                            }
                                            for (int index
                                                in muddaNewsController
                                                    .selectedCategory) {
                                              hashtags.add(
                                                  muddaNewsController
                                                      .categoryList
                                                      .elementAt(index));
                                            }
                                            for (int index
                                                in muddaNewsController
                                                    .selectedGender) {
                                              gender.add(muddaNewsController
                                                  .genderList
                                                  .elementAt(index)
                                                  .toLowerCase());
                                            }
                                            for (int index
                                                in muddaNewsController
                                                    .selectedAge) {
                                              age.add(muddaNewsController
                                                  .ageList
                                                  .elementAt(index));
                                            }
                                            if (muddaNewsController
                                                .selectDistrict
                                                .value
                                                .isNotEmpty) {
                                              customLocation.add(
                                                  muddaNewsController
                                                      .apiLocationList
                                                      .elementAt(0));
                                              customLocationValues.add(
                                                  muddaNewsController
                                                      .selectDistrict
                                                      .value);
                                            }
                                            if (muddaNewsController
                                                .selectState
                                                .value
                                                .isNotEmpty) {
                                              customLocation.add(
                                                  muddaNewsController
                                                      .apiLocationList
                                                      .elementAt(1));
                                              customLocationValues.add(
                                                  muddaNewsController
                                                      .selectState.value);
                                            }
                                            if (muddaNewsController
                                                .selectCountry
                                                .value
                                                .isNotEmpty) {
                                              customLocation.add(
                                                  muddaNewsController
                                                      .apiLocationList
                                                      .elementAt(2));
                                              customLocationValues.add(
                                                  muddaNewsController
                                                      .selectCountry.value);
                                            }
                                            Map<String, dynamic> map = {
                                              "user_id": AppPreference()
                                                  .getString(PreferencesKey
                                                      .userId),
                                            };
                                            if (hashtags.isNotEmpty) {
                                              map.putIfAbsent(
                                                  "hashtags",
                                                  () =>
                                                      jsonEncode(hashtags));
                                            }
                                            if (location.isNotEmpty) {
                                              map.putIfAbsent(
                                                  "location_types",
                                                  () =>
                                                      jsonEncode(location));
                                            }
                                            if (locationValues.isNotEmpty) {
                                              map.putIfAbsent(
                                                  "location_types_values",
                                                  () => jsonEncode(
                                                      locationValues));
                                            }
                                            if (customLocation.isNotEmpty) {
                                              map.putIfAbsent(
                                                  "custom_location_types",
                                                  () => jsonEncode(
                                                      customLocation));
                                            }
                                            if (customLocationValues
                                                .isNotEmpty) {
                                              map.putIfAbsent(
                                                  "custom_location_types_values",
                                                  () => jsonEncode(
                                                      customLocationValues));
                                            }
                                            if (gender.isNotEmpty) {
                                              map.putIfAbsent(
                                                  "gender_types",
                                                  () => jsonEncode(gender));
                                            }
                                            if (age.isNotEmpty) {
                                              map.putIfAbsent("age_types",
                                                  () => jsonEncode(age));
                                            }
                                            Api.get.call(context,
                                                method: "mudda/index",
                                                param: map,
                                                isLoading: true,
                                                onResponseSuccess:
                                                    (Map object) {
                                              var result =
                                                  MuddaPostModel.fromJson(
                                                      object);
                                              if (result.data!.isNotEmpty) {
                                                muddaNewsController
                                                    .muddaProfilePath
                                                    .value = result.path!;
                                                muddaNewsController
                                                        .muddaUserProfilePath
                                                        .value =
                                                    result.userpath!;
                                                muddaNewsController
                                                    .muddaPostList
                                                    .clear();
                                                muddaNewsController
                                                    .muddaPostList
                                                    .addAll(result.data!);
                                                Get.back();
                                              } else {
                                                showDialog<void>(
                                                  context: Get.context!,
                                                  barrierDismissible: false,
                                                  // user must tap button!
                                                  builder: (BuildContext
                                                      context) {
                                                    return AlertDialog(
                                                      content: Text(
                                                          result.message!,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: const Text(
                                                              'OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          child: Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                              Container(
                                                width:
                                                    ScreenUtil().setSp(70),
                                                height:
                                                    ScreenUtil().setSp(25),
                                                margin: EdgeInsets.only(
                                                    right: ScreenUtil()
                                                        .setSp(17),
                                                    top: ScreenUtil()
                                                        .setSp(2.5),
                                                    bottom: ScreenUtil()
                                                        .setSp(2.5)),
                                                decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  border: Border.all(
                                                      color: color606060),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          ScreenUtil()
                                                              .setSp(8)),
                                                ),
                                                child: Center(
                                                  child: Text("Apply",
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          12),
                                                              color:
                                                                  black)),
                                                ),
                                              ),
                                              Positioned(
                                                right: 1,
                                                child: Container(
                                                  alignment:
                                                      Alignment.center,
                                                  height: ScreenUtil()
                                                      .setSp(30),
                                                  width: ScreenUtil()
                                                      .setSp(30),
                                                  margin:
                                                      const EdgeInsets.all(
                                                          2),
                                                  decoration: BoxDecoration(
                                                      shape:
                                                          BoxShape.circle,
                                                      color: colorWhite,
                                                      border: Border.all(
                                                          color:
                                                              color606060)),
                                                  child: const Icon(
                                                    Icons
                                                        .chevron_right_rounded,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              )
                            : SizedBox(),*/
                            ],
                          );
                        }
                      })),
            ],
          ),
        ));
  }

  anynymousDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.5),
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Container(
              height: ScreenUtil().setSp(97),
              width: ScreenUtil().screenWidth - ScreenUtil().setSp(50),
              decoration: const BoxDecoration(color: Colors.white),
              child: Material(
                child: commonPostText(
                  text:
                      "Anonymous user profiles can't be visited or contacted.",
                  onPressed: () {
                    Get.back();
                  },
                  color: Colors.black,
                  size: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  callInvitedLeaders(BuildContext context) async {
    Api.get.call(context,
        method: "mudda/invited-in-mudda",
        param: {
          "page": invitedPage.toString(),
          "search": leaderBoardApprovalController.invitedSearch.value,
          "_id": muddaNewsController.muddaPost.value.sId,
          "user_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
      print(object);
      var result = UserJoinLeadersModel.fromJson(object);
      leaderBoardApprovalController.invitedLeaderList.clear();
      if (result.data!.isNotEmpty) {
        leaderBoardApprovalController.profilePath.value = result.path!;
        leaderBoardApprovalController.invitedLeaderList.addAll(result.data!);
      } else {
        invitedPage = invitedPage > 1 ? invitedPage - 1 : invitedPage;
      }
    });
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hr ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} sec ago';
    } else {
      return 'just now';
    }
  }

  _getMuddaPost(BuildContext context) async {
    List<String> hashtags = [];
    List<String> location = [];
    List<String> customLocation = [];
    List<String> locationValues = [];
    List<String> customLocationValues = [];
    List<String> gender = [];
    List<String> age = [];
    for (int index in muddaNewsController.selectedLocation) {
      location.add(muddaNewsController.apiLocationList.elementAt(index));
      if (index == 0) {
        locationValues.add(AppPreference().getString(PreferencesKey.city));
      } else if (index == 1) {
        locationValues.add(AppPreference().getString(PreferencesKey.state));
      } else if (index == 2) {
        locationValues.add(AppPreference().getString(PreferencesKey.country));
      } else {
        locationValues.add("");
      }
    }
    for (int index in muddaNewsController.selectedCategory) {
      hashtags.add(muddaNewsController.categoryList.elementAt(index));
    }
    for (int index in muddaNewsController.selectedGender) {
      gender.add(muddaNewsController.genderList.elementAt(index).toLowerCase());
    }
    for (int index in muddaNewsController.selectedAge) {
      age.add(muddaNewsController.ageList.elementAt(index));
    }
    if (muddaNewsController.selectDistrict.value.isNotEmpty) {
      customLocation.add(muddaNewsController.apiLocationList.elementAt(0));
      customLocationValues.add(muddaNewsController.selectDistrict.value);
    }
    if (muddaNewsController.selectState.value.isNotEmpty) {
      customLocation.add(muddaNewsController.apiLocationList.elementAt(1));
      customLocationValues.add(muddaNewsController.selectState.value);
    }
    if (muddaNewsController.selectCountry.value.isNotEmpty) {
      customLocation.add(muddaNewsController.apiLocationList.elementAt(2));
      customLocationValues.add(muddaNewsController.selectCountry.value);
    }
    Map<String, dynamic> map = {
      "page": page.toString(),
      "user_id": AppPreference().getString(PreferencesKey.userId),
      "lastReadNotification":
          AppPreference().getString(PreferencesKey.notificationId) == ''
              ? null
              : AppPreference().getString(PreferencesKey.notificationId)
    };
    if (hashtags.isNotEmpty) {
      map.putIfAbsent("hashtags", () => jsonEncode(hashtags));
    }
    if (location.isNotEmpty) {
      map.putIfAbsent("location_types", () => jsonEncode(location));
    }
    if (locationValues.isNotEmpty) {
      map.putIfAbsent(
          "location_types_values", () => jsonEncode(locationValues));
    }
    if (customLocation.isNotEmpty) {
      map.putIfAbsent(
          "custom_location_types", () => jsonEncode(customLocation));
    }
    if (customLocationValues.isNotEmpty) {
      map.putIfAbsent("custom_location_types_values",
          () => jsonEncode(customLocationValues));
    }
    if (gender.isNotEmpty) {
      map.putIfAbsent("gender_types", () => jsonEncode(gender));
    }
    if (age.isNotEmpty) {
      map.putIfAbsent("age_types", () => jsonEncode(age));
    }
    Api.get.call(context, method: "mudda/index", param: map, isLoading: false,
        onResponseSuccess: (Map object) {
      var result = MuddaPostModel.fromJson(object);
      muddaNewsController.isNotiAvailaable.value =
          result.notifications ?? false;
      muddaNewsController.isHotMuddaLoading.value = false;
      _refreshController.refreshCompleted();
      if (result.data!.isNotEmpty) {
        muddaNewsController.muddaProfilePath.value = result.path!;
        muddaNewsController.muddaUserProfilePath.value = result.userpath!;
        muddaNewsController.muddaPostList.addAll(result.data!);

        // muddaNewsController.muddaPostList.forEach((element) async {
        //   log('========ok0');
        //   List<RecentDataOffline> temp =
        //       await DBProvider.db.getRecentData("${element.sId}");
        //   double inDebate = 0.0;
        //   if (temp.isEmpty || temp.length == 0) {
        //     log('========ok1');
        //     int totalVote = element.favour['totalAgree'] +
        //         element.favour['totalDisagree'] +
        //         element.opposition['totalAgree'] +
        //         element.opposition['totalDisagree'];
        //     double agreePercentage = (((element.favour['totalAgree'] +
        //                 element.opposition['totalDisagree']) /
        //             totalVote) *
        //         100);
        //     double disagreePercentage = (((element.favour['totalDisagree'] +
        //                 element.opposition['totalAgree']) /
        //             totalVote) *
        //         100);
        //     inDebate = agreePercentage - disagreePercentage;
        //     DBProvider.db.addRecentData(
        //         muddaId: element.sId!,
        //         leadersCount: "${element.leadersCount}",
        //         totalPost: "${element.totalPost}",
        //         support: "${element.support}",
        //         inDebate: "${inDebate.toStringAsFixed(2)}");
        //   } else {
        //     log('========ok2');
        //     double supportDiff = ((element.support)! -
        //             int.parse("${temp[0].support}") /
        //                 int.parse("${temp[0].support}")) *
        //         100;
        //     int newLeaderDiff =
        //         (element.leadersCount)! - int.parse("${temp[0].leadersCount}");
        //     int newTotalPostDiff =
        //         (element.totalPost)! - int.parse("${temp[0].totalPost}");
        //     double inDebateDiff =
        //         inDebate - double.parse("${temp[0].inDebate}");
        //     MuddaPost muddaPost = element;
        //     muddaPost.supportDiff = supportDiff;
        //     muddaPost.newLeaderDiff = newLeaderDiff;
        //     muddaPost.newPostDiff = newTotalPostDiff;
        //     muddaPost.inDebte = inDebateDiff;
        //     muddaNewsController.muddaPostList.add(muddaPost);
        //   }
        // });

      } else {
        _refreshController.refreshCompleted();

        page = page > 1 ? page - 1 : page;
      }
    });
  }

  _getPaginateMuddaPost(
      {required String lastReadPostID, required String type}) async {
    if (lastReadId == null) {
      lastReadId = '${muddaNewsController.muddaPostList.last.createdAt}';
      setState(() {});
    }
    Map<String, dynamic> map = {
      "page": page.toString(),
      "muddas": type,
      "muddaDate": lastReadPostID,
      "lastReadNotification":
          AppPreference().getString(PreferencesKey.notificationId) == ''
              ? null
              : AppPreference().getString(PreferencesKey.notificationId)
    };
    Api.get.call(context, method: "mudda/muddas", param: map, isLoading: false,
        onResponseSuccess: (Map object) {
      var result = MuddaPostNew.fromJson(object);
      page++;
      muddaNewsController.isNotiAvailaable.value =
          result.result!.notifications ?? false;
      _refreshController.refreshCompleted();
      if (result.result!.data!.isNotEmpty) {
        setState(() {});
        muddaNewsController.muddaProfilePath.value = result.result!.path!;
        muddaNewsController.muddaUserProfilePath.value =
            result.result!.userpath!;
        _refreshController.loadComplete();
        muddaNewsController.muddaPostList.addAll(result.result!.data!);
      } else {
        _refreshController.loadComplete();
        page = page > 1 ? page - 1 : page;
      }
    });
  }

  _getTopPaginateMuddaPost(
      {required String lastReadPostID, required String type}) async {
    if (lastReadId == null) {
      lastReadId = '${muddaNewsController.muddaPostList.first.createdAt}';
      setState(() {});
    }
    Map<String, dynamic> map = {
      "page": topPage.toString(),
      "muddas": type,
      "muddaDate": lastReadPostID,
      "lastReadNotification":
          AppPreference().getString(PreferencesKey.notificationId) == ''
              ? null
              : AppPreference().getString(PreferencesKey.notificationId)
    };
    Api.get.call(context, method: "mudda/muddas", param: map, isLoading: false,
        onResponseSuccess: (Map object) {
      var result = MuddaPostNew.fromJson(object);
      topPage++;
      muddaNewsController.isNotiAvailaable.value =
          result.result!.notifications ?? false;
      _refreshController.refreshCompleted();
      if (result.result!.data!.isNotEmpty) {
        setState(() {});
        muddaNewsController.muddaProfilePath.value = result.result!.path!;
        muddaNewsController.muddaUserProfilePath.value =
            result.result!.userpath!;
        muddaNewsController.muddaPostList.insertAll(0, result.result!.data!);
        _refreshController.loadComplete();
      } else {
        _refreshController.loadComplete();
        topPage = topPage > 1 ? topPage - 1 : topPage;
      }
    });
  }
}
