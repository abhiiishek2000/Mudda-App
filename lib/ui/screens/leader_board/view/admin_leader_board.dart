import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/LeadersDataModel.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserJoinLeadersModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/leader_board/controller/LeaderBoardApprovalController.dart';
import 'package:mudda/ui/screens/leader_board/view/leader_board_approval_screen.dart';
import 'package:mudda/ui/shared/report_post_dialog_box.dart';

import '../../home_screen/widget/component/hot_mudda_post.dart';

class AdminLeaderBoard extends StatefulWidget {
  const AdminLeaderBoard({Key? key}) : super(key: key);

  @override
  State<AdminLeaderBoard> createState() => _AdminLeaderBoardState();
}

class _AdminLeaderBoardState extends State<AdminLeaderBoard>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isJoinLeaderShip = true;
  int page = 1;
  int oppositionPage = 1;
  String path = "";
  String muddaPath = "";
  AcceptUserDetail? creator;
  AcceptUserDetail? oppositionLeader;
  List<Leaders> favoursLeaders = [];
  List<Leaders> oppositionLeaders = [];
  MuddaPost? muddaPost;
  ScrollController favourScrollController = ScrollController();
  ScrollController oppositionScrollController = ScrollController();
  ScrollController requestScrollController = ScrollController();
  MuddaNewsController? muddaNewsController;
  LeaderBoardApprovalController leaderBoardApprovalController =
      Get.put(LeaderBoardApprovalController());

  String searchText = "";

  JoinLeader? oppositionUser;
  //
  dynamic dataMudda;

  @override
  void initState() {
    muddaPost = Get.arguments;
    favourScrollController.addListener(() {
      if (favourScrollController.position.maxScrollExtent ==
          favourScrollController.position.pixels) {
        page++;
        Map<String, dynamic> map = {
          "page": page.toString(),
          "leaderType": "favour",
          "_id": muddaPost!.sId,
        };
        Api.get.call(context,
            method: "mudda/leaders-in-mudda",
            param: map,
            isLoading: false, onResponseSuccess: (Map object) {
          var result = LeadersDataModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            path = result.path!;
            favoursLeaders.addAll(result.data!);
            setState(() {});
          } else {
            page = page > 1 ? page - 1 : page;
          }
        });
      }
    });
    oppositionScrollController.addListener(() {
      if (oppositionScrollController.position.maxScrollExtent ==
          oppositionScrollController.position.pixels) {
        oppositionPage++;
        Map<String, dynamic> mapOpposition = {
          "page": oppositionPage.toString(),
          "leaderType": "opposition",
          "_id": muddaPost!.sId,
        };
        Api.get.call(context,
            method: "mudda/leaders-in-mudda",
            param: mapOpposition,
            isLoading: false, onResponseSuccess: (Map object) {
          var result = LeadersDataModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            path = result.path!;
            oppositionLeaders.addAll(result.data!);
            setState(() {});
          } else {
            oppositionPage =
                oppositionPage > 1 ? oppositionPage - 1 : oppositionPage;
          }
        });
      }
    });
    tabController = TabController(
      length: 3,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {});
      if (tabController.index == 1 && oppositionLeaders.isEmpty) {
        Map<String, dynamic> map = {
          "page": oppositionPage.toString(),
          "leaderType": "opposition",
          "_id": muddaPost!.sId,
        };
        Api.get.call(context,
            method: "mudda/leaders-in-mudda",
            param: map,
            isLoading: false, onResponseSuccess: (Map object) {
          var result = LeadersDataModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            path = result.path!;
            muddaPath = result.path!;
            creator = result.dataMudda!.creator != null
                ? result.dataMudda!.creator!.user
                : null;
            oppositionUser = result.dataMudda!.oppositionLeader;
            oppositionLeader = result.dataMudda!.oppositionLeader != null
                ? result.dataMudda!.oppositionLeader!.user
                : null;
            oppositionLeaders.addAll(result.data!);
            setState(() {});
          } else {
            oppositionPage =
                oppositionPage > 1 ? oppositionPage - 1 : oppositionPage;
          }
        });
      }
    });
    Map<String, dynamic> map = {
      "page": page.toString(),
      "leaderType": "favour",
      "_id": muddaPost!.sId,
    };
    Api.get.call(context,
        method: "mudda/leaders-in-mudda",
        param: map,
        isLoading: false, onResponseSuccess: (Map object) {
      log('-=-=- Favour -=-=-');
      dataMudda = object['dataMudda'];
      var result = LeadersDataModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        path = result.path!;
        muddaPath = result.path!;
        creator = result.dataMudda!.creator != null
            ? result.dataMudda!.creator!.user
            : null;
        oppositionUser = result.dataMudda!.oppositionLeader;
        oppositionLeader = result.dataMudda!.oppositionLeader != null
            ? result.dataMudda!.oppositionLeader!.user
            : null;
        favoursLeaders.addAll(result.data!);
        setState(() {});
      } else {
        page = page > 1 ? page - 1 : page;
      }
    });
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                IconButton(
                    onPressed: () {
                      searchBoxTextFiled();
                    },
                    icon: Image.asset(AppIcons.searchIcon,
                        height: 20, width: 20)),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                muddaPost!.title!,
                textAlign: TextAlign.center,
                style: size12_M_normal(textColor: Colors.black),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 30,
              // width: 290,
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
                          dataMudda != null
                              ? "Favour (${NumberFormat.compactCurrency(
                                  decimalDigits: 0,
                                  symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  // ).format(muddaPost!.favourCount)})",
                                ).format(dataMudda['favourCount'])})"
                              : "",
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
                          dataMudda != null
                              ? "Opposition (${NumberFormat.compactCurrency(
                                  decimalDigits: 0,
                                  symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  // ).format(muddaPost!.oppositionCount)})",
                                ).format(dataMudda['oppositionCount'])})"
                              : "",
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
                  ),
                  Tab(
                    icon: Column(
                      children: [
                        Text(
                          "Requests (${NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol:
                                '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(muddaPost!.requestsCount)})",
                          style: tabController.index == 2
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
                          color: tabController.index == 2
                              ? Colors.black
                              : Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
                controller: tabController,
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ListView(
                    controller: favourScrollController,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Founding Members:",
                            style: size12_M_bold(textColor: black),
                          ),
                          Row(
                            children: [
                              Text(
                                'Places: ',
                                style: size12_M_bold(textColor: black),
                              ),
                              Text(
                                muddaPost!.uniquePlaces!.join(', '),
                                // muddaNewsController!.muddaPost.value.country!,
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: ScreenUtil().setSp(12),
                                    color: buttonBlue),
                              ),
                              Visibility(
                                visible: muddaPost!.initialScope == "country"
                                    ? (muddaPost!.uniqueState! < 3)
                                    : muddaPost!.initialScope == "state"
                                        ? (muddaPost!.uniqueCity! < 3)
                                        : (muddaPost!.uniqueCountry! < 3),
                                child: Text(
                                  " (${muddaPost!.initialScope == "country" ? (3 - muddaPost!.uniqueState!) : muddaPost!.initialScope == "state" ? (3 - muddaPost!.uniqueCity!) : (3 - muddaPost!.uniqueCountry!)} more places required)",
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(12),
                                      fontStyle: FontStyle.italic,
                                      color: black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: favoursLeaders.length,
                          itemBuilder: (followersContext, index) {
                            Leaders leaders = favoursLeaders.elementAt(index);
                            return InkWell(
                              onTap: () {
                                if (leaders.userIdentity == 1) {
                                  if (leaders.acceptUserDetail!.sId ==
                                      AppPreference()
                                          .getString(PreferencesKey.userId)) {
                                    Get.toNamed(RouteConstants.profileScreen);
                                  } else {
                                    Map<String, String>? parameters = {
                                      "userDetail":
                                          jsonEncode(leaders.acceptUserDetail!)
                                    };
                                    Get.toNamed(
                                        RouteConstants.otherUserProfileScreen,
                                        parameters: parameters);
                                  }
                                } else {
                                  anynymousDialogBox(context);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    leaders.userIdentity == 0
                                        ? Container(
                                            width: ScreenUtil().setSp(36),
                                            height: ScreenUtil().setSp(36),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: darkGray,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text("A",
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(18),
                                                      color: black)),
                                            ),
                                          )
                                        : leaders.acceptUserDetail!.profile !=
                                                null
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    "${path}${leaders.acceptUserDetail!.profile}",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: ScreenUtil().setSp(36),
                                                  height:
                                                      ScreenUtil().setSp(36),
                                                  decoration: BoxDecoration(
                                                    color: colorWhite,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            ScreenUtil().setSp(
                                                                18)) //                 <--- border radius here
                                                        ),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                  backgroundColor: lightGray,
                                                  radius:
                                                      ScreenUtil().setSp(18),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        CircleAvatar(
                                                  backgroundColor: lightGray,
                                                  radius:
                                                      ScreenUtil().setSp(18),
                                                ),
                                              )
                                            : Container(
                                                height: ScreenUtil().setSp(36),
                                                width: ScreenUtil().setSp(36),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: darkGray,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      leaders.acceptUserDetail!
                                                          .fullname![0]
                                                          .toUpperCase(),
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          18),
                                                              color: black)),
                                                ),
                                              ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            children: [
                                              Visibility(
                                                visible: leaders
                                                        .acceptUserDetail!
                                                        .isProfileVerified ==
                                                    1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Image.asset(
                                                    AppIcons.verifyProfileIcon2,
                                                    height: 10,
                                                    width: 10,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                leaders.userIdentity == 1
                                                    ? "${leaders.acceptUserDetail!.fullname!},"
                                                    : "Anonymous,",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    color: black),
                                              ),
                                              Text(
                                                leaders
                                                    .acceptUserDetail!.country!,
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    color: buttonBlue),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            leaders.acceptUserDetail!
                                                    .profession ??
                                                "",
                                            style: size12_M_normal(
                                                textColor: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    leaders.userIdentity == 1 &&
                                            leaders.acceptUserDetail!.sId !=
                                                AppPreference().getString(
                                                    PreferencesKey
                                                        .interactUserId) &&
                                            leaders.acceptUserDetail!.sId !=
                                                AppPreference().getString(
                                                    PreferencesKey.userId) &&
                                            leaders.acceptUserDetail!
                                                    .amIFollowing ==
                                                0
                                        ? followButton(
                                            context,
                                            leaders.acceptUserDetail!.sId!,
                                            index,
                                            "favour")
                                        : Container()
                                  ],
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                  ListView(
                    controller: oppositionScrollController,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          if (oppositionUser!.userIdentity == 1) {
                            if (oppositionLeader!.sId ==
                                    AppPreference()
                                        .getString(PreferencesKey.userId) ||
                                oppositionLeader!.sId ==
                                    AppPreference()
                                        .getString(PreferencesKey.orgUserId)) {
                              Get.toNamed(RouteConstants.profileScreen);
                            } else if (oppositionLeader!.userType == "user") {
                              Map<String, String>? parameters = {
                                "userDetail": jsonEncode(oppositionLeader!)
                              };
                              Get.toNamed(RouteConstants.otherUserProfileScreen,
                                  parameters: parameters);
                            } else {
                              Map<String, String>? parameters = {
                                "userDetail": jsonEncode(oppositionLeader!)
                              };
                              Get.toNamed(RouteConstants.otherOrgProfileScreen,
                                  parameters: parameters);
                            }
                          } else {
                            anynymousDialogBox(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      creator != null &&
                                              creator!.profile != null
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  "$path${creator!.profile}",
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: ScreenUtil().setSp(45),
                                                height: ScreenUtil().setSp(45),
                                                decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  border: Border.all(
                                                    width:
                                                        ScreenUtil().setSp(1),
                                                    color: buttonBlue,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          ScreenUtil().setSp(
                                                              22.5)) //                 <--- border radius here
                                                      ),
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                backgroundColor: lightGray,
                                                radius:
                                                    ScreenUtil().setSp(22.5),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CircleAvatar(
                                                backgroundColor: lightGray,
                                                radius:
                                                    ScreenUtil().setSp(22.5),
                                              ),
                                            )
                                          : Container(
                                              height: ScreenUtil().setSp(45),
                                              width: ScreenUtil().setSp(45),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: darkGray,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                    creator != null
                                                        ? creator!.fullname![0]
                                                            .toUpperCase()
                                                        : "",
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                        22.5),
                                                            color: black)),
                                              ),
                                            ),
                                      Visibility(
                                        visible: creator != null
                                            ? creator!.isProfileVerified == 1
                                            : false,
                                        child: Positioned(
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
                                              backgroundColor:
                                                  colorAppBackground),
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    creator != null ? creator!.fullname! : "",
                                    style:
                                        size12_M_bold(textColor: Colors.black),
                                  ),
                                  Text(
                                    "Mudda Creator",
                                    style: size12_M_normal(
                                      textColor: Colors.blue,
                                    ),
                                  ),
                                  followButton()
                                ],
                              ),*/
                              Visibility(
                                visible: oppositionLeader != null,
                                child: Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        oppositionLeader != null &&
                                                oppositionLeader!.profile !=
                                                    null
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    "$path${oppositionLeader!.profile}",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: ScreenUtil().setSp(45),
                                                  height:
                                                      ScreenUtil().setSp(45),
                                                  decoration: BoxDecoration(
                                                    color: colorWhite,
                                                    border: Border.all(
                                                      width:
                                                          ScreenUtil().setSp(1),
                                                      color: buttonBlue,
                                                    ),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            ScreenUtil().setSp(
                                                                22.5)) //                 <--- border radius here
                                                        ),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                  backgroundColor: lightGray,
                                                  radius:
                                                      ScreenUtil().setSp(22.5),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        CircleAvatar(
                                                  backgroundColor: lightGray,
                                                  radius:
                                                      ScreenUtil().setSp(22.5),
                                                ),
                                              )
                                            : Container(
                                                height: ScreenUtil().setSp(45),
                                                width: ScreenUtil().setSp(45),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: darkGray,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      oppositionLeader != null
                                                          ? oppositionLeader!
                                                              .fullname![0]
                                                              .toUpperCase()
                                                          : "",
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          22.5),
                                                              color: black)),
                                                ),
                                              ),
                                        Visibility(
                                          visible: oppositionLeader != null
                                              ? oppositionLeader!
                                                      .isProfileVerified ==
                                                  1
                                              : false,
                                          child: Positioned(
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
                                                backgroundColor:
                                                    colorAppBackground),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      oppositionLeader != null
                                          ? oppositionLeader!.fullname!
                                          : "",
                                      style: size12_M_bold(
                                          textColor: Colors.black),
                                    ),
                                    Text(
                                      "Muddebaaz",
                                      style: size12_M_normal(
                                        textColor: Colors.amber,
                                      ),
                                    ),
                                    oppositionLeader != null &&
                                            oppositionLeader!.sId !=
                                                AppPreference().getString(
                                                    PreferencesKey
                                                        .interactUserId) &&
                                            oppositionLeader!.sId !=
                                                AppPreference().getString(
                                                    PreferencesKey.userId) &&
                                            oppositionLeader!.amIFollowing == 0
                                        ? followButton(
                                            context,
                                            oppositionLeader!.sId!,
                                            -2,
                                            "opposition")
                                        : Container()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(2, 2),
                                    color: Colors.black.withOpacity(.2))
                              ],
                            ),
                          ),
                          Visibility(
                            visible: creator != null
                                ? AppPreference().getString(
                                        creator!.userType == "user"
                                            ? PreferencesKey.userId
                                            : PreferencesKey.orgUserId) !=
                                    creator!.sId!
                                : true,
                            child: muddaPost!.isInvolved == null &&
                                    muddaPost!.amIRequested == null
                                ? Row(
                                    children: [
                                      getSizedBox(w: ScreenUtil().setSp(15)),
                                      Expanded(
                                        child: SizedBox(
                                          height: ScreenUtil().setSp(25),
                                          child:
                                              DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: ScreenUtil()
                                                            .setSp(8)),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        borderSide: BorderSide(
                                                            color: grey)),
                                                border: const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: grey)),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide:
                                                      BorderSide(color: grey),
                                                ),
                                                filled: true,
                                                fillColor: white),
                                            hint: Text("Join Favour",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    color: buttonBlue)),
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                color: buttonBlue),
                                            items: <String>[
                                              "Join Normal",
                                              "Join Anonymous",
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(12),
                                                            color: black)),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              if (AppPreference().getBool(
                                                  PreferencesKey.isGuest)) {
                                                updateProfileDialog(context);
                                              } else {
                                                // muddaNewsController!.selectJoinFavour
                                                //     .value = newValue!;
                                                Api.post.call(
                                                  context,
                                                  method:
                                                      "request-to-user/store",
                                                  param: {
                                                    "user_id": AppPreference()
                                                        .getString(
                                                            PreferencesKey
                                                                .userId),
                                                    "request_to_user_id":
                                                        muddaPost!
                                                            .leaders![0].userId,
                                                    "joining_content_id":
                                                        muddaPost!.sId,
                                                    "requestModalPath":
                                                        muddaPath,
                                                    "requestModal": "RealMudda",
                                                    "request_type": "leader",
                                                    "user_identity": newValue ==
                                                            "Join Normal"
                                                        ? "1"
                                                        : "0",
                                                  },
                                                  onResponseSuccess: (object) {
                                                    muddaPost!.amIRequested =
                                                        MyReaction.fromJson(
                                                            object['data']);
                                                    setState(() {});
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      getSizedBox(w: ScreenUtil().setSp(15)),
                                      Expanded(
                                        child: SizedBox(
                                          height: ScreenUtil().setSp(25),
                                          child:
                                              DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: ScreenUtil()
                                                            .setSp(8)),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        borderSide: BorderSide(
                                                            color: grey)),
                                                border: const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: grey)),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide:
                                                      BorderSide(color: grey),
                                                ),
                                                filled: true,
                                                fillColor: white),
                                            hint: Text("Join Opposition",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    color: buttonYellow)),
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                color: buttonYellow),
                                            items: <String>[
                                              "Join Normal",
                                              "Join Anonymous",
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(12),
                                                            color: black)),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              if (AppPreference().getBool(
                                                  PreferencesKey.isGuest)) {
                                                updateProfileDialog(context);
                                              } else {
                                                // muddaNewsController!.selectJoinFavour
                                                //     .value = newValue!;
                                                Api.post.call(
                                                  context,
                                                  method:
                                                      "request-to-user/store",
                                                  param: {
                                                    "user_id": AppPreference()
                                                        .getString(
                                                            PreferencesKey
                                                                .userId),
                                                    "request_to_user_id":
                                                        muddaPost!
                                                            .leaders![0].userId,
                                                    "joining_content_id":
                                                        muddaPost!.sId,
                                                    "requestModalPath":
                                                        muddaPath,
                                                    "requestModal": "RealMudda",
                                                    "request_type":
                                                        "opposition",
                                                    "user_identity": newValue ==
                                                            "Join Normal"
                                                        ? "1"
                                                        : "0",
                                                  },
                                                  onResponseSuccess: (object) {
                                                    muddaPost!.isInvolved =
                                                        MyReaction.fromJson(
                                                            object['data']);
                                                    muddaPost!.oppositionCount =
                                                        muddaPost!
                                                                .oppositionCount! +
                                                            1;
                                                    setState(() {});
                                                    oppositionPage = 1;
                                                    oppositionLeaders.clear();
                                                    Map<String, dynamic> map = {
                                                      "page": oppositionPage
                                                          .toString(),
                                                      "leaderType":
                                                          "opposition",
                                                      "_id": muddaPost!.sId,
                                                    };
                                                    Api.get.call(context,
                                                        method:
                                                            "mudda/leaders-in-mudda",
                                                        param: map,
                                                        isLoading: false,
                                                        onResponseSuccess:
                                                            (Map object) {
                                                      var result =
                                                          LeadersDataModel
                                                              .fromJson(object);
                                                      if (result
                                                          .data!.isNotEmpty) {
                                                        path = result.path!;
                                                        oppositionLeaders
                                                            .addAll(
                                                                result.data!);
                                                        setState(() {});
                                                      } else {
                                                        oppositionPage =
                                                            oppositionPage > 1
                                                                ? oppositionPage -
                                                                    1
                                                                : oppositionPage;
                                                      }
                                                    });
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      getSizedBox(w: ScreenUtil().setSp(15)),
                                    ],
                                  )
                                : Visibility(
                                    visible: muddaPost!.isInvolved != null &&
                                        muddaPost!.isInvolved!.joinerType! ==
                                            "opposition",
                                    child: InkWell(
                                      onTap: () {
                                        if (muddaPost!.isInvolved != null) {
                                          Api.delete.call(
                                            context,
                                            method:
                                                "request-to-user/joined-delete/${muddaPost!.isInvolved!.sId}",
                                            param: {
                                              "_id": muddaPost!.isInvolved!.sId
                                            },
                                            onResponseSuccess: (object) {
                                              muddaPost!.isInvolved = null;
                                              muddaPost!.oppositionCount =
                                                  muddaPost!.oppositionCount! -
                                                      1;
                                              setState(() {});
                                              oppositionPage = 1;
                                              oppositionLeaders.clear();
                                              Map<String, dynamic> map = {
                                                "page":
                                                    oppositionPage.toString(),
                                                "leaderType": "opposition",
                                                "_id": muddaPost!.sId,
                                              };
                                              Api.get.call(context,
                                                  method:
                                                      "mudda/leaders-in-mudda",
                                                  param: map,
                                                  isLoading: false,
                                                  onResponseSuccess:
                                                      (Map object) {
                                                var result =
                                                    LeadersDataModel.fromJson(
                                                        object);
                                                if (result.data!.isNotEmpty) {
                                                  path = result.path!;
                                                  oppositionLeaders
                                                      .addAll(result.data!);
                                                  setState(() {});
                                                } else {
                                                  oppositionPage =
                                                      oppositionPage > 1
                                                          ? oppositionPage - 1
                                                          : oppositionPage;
                                                }
                                              });
                                            },
                                          );
                                        } else {
                                          Api.delete.call(
                                            context,
                                            method:
                                                "request-to-user/delete/${muddaPost!.amIRequested!.sId}",
                                            param: {
                                              "_id":
                                                  muddaPost!.amIRequested!.sId
                                            },
                                            onResponseSuccess: (object) {
                                              muddaPost!.amIRequested = null;
                                              setState(() {});
                                              oppositionPage = 1;
                                              oppositionLeaders.clear();
                                              Map<String, dynamic> map = {
                                                "page":
                                                    oppositionPage.toString(),
                                                "leaderType": "opposition",
                                                "_id": muddaPost!.sId,
                                              };
                                              Api.get.call(context,
                                                  method:
                                                      "mudda/leaders-in-mudda",
                                                  param: map,
                                                  isLoading: false,
                                                  onResponseSuccess:
                                                      (Map object) {
                                                var result =
                                                    LeadersDataModel.fromJson(
                                                        object);
                                                if (result.data!.isNotEmpty) {
                                                  path = result.path!;
                                                  oppositionLeaders
                                                      .addAll(result.data!);
                                                  setState(() {});
                                                } else {
                                                  oppositionPage =
                                                      oppositionPage > 1
                                                          ? oppositionPage - 1
                                                          : oppositionPage;
                                                }
                                              });
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: ScreenUtil().setSp(25),
                                        margin: EdgeInsets.only(
                                            left: ScreenUtil().setSp(25),
                                            right: ScreenUtil().setSp(25)),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: grey,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            color: white),
                                        child: Center(
                                          child: Text(
                                              muddaPost!.isInvolved != null
                                                  ? "Leave Leadership"
                                                  : "Cancel Request",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(12),
                                                  color: black)),
                                        ),
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: oppositionLeaders.length,
                          itemBuilder: (followersContext, index) {
                            Leaders leaders =
                                oppositionLeaders.elementAt(index);
                            return InkWell(
                              onTap: () {
                                if (leaders.userIdentity == 1) {
                                  if (leaders.acceptUserDetail!.sId ==
                                      AppPreference()
                                          .getString(PreferencesKey.userId)) {
                                    Get.toNamed(RouteConstants.profileScreen);
                                  } else {
                                    Map<String, String>? parameters = {
                                      "userDetail":
                                          jsonEncode(leaders.acceptUserDetail!)
                                    };
                                    Get.toNamed(
                                        RouteConstants.otherUserProfileScreen,
                                        parameters: parameters);
                                  }
                                } else {
                                  anynymousDialogBox(context);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    leaders.userIdentity == 0
                                        ? Container(
                                            width: ScreenUtil().setSp(36),
                                            height: ScreenUtil().setSp(36),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: darkGray,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text("A",
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(18),
                                                      color: black)),
                                            ),
                                          )
                                        : leaders.acceptUserDetail!.profile !=
                                                null
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    "${path}${leaders.acceptUserDetail!.profile}",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: ScreenUtil().setSp(36),
                                                  height:
                                                      ScreenUtil().setSp(36),
                                                  decoration: BoxDecoration(
                                                    color: colorWhite,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            ScreenUtil().setSp(
                                                                18)) //                 <--- border radius here
                                                        ),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                  backgroundColor: lightGray,
                                                  radius:
                                                      ScreenUtil().setSp(18),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        CircleAvatar(
                                                  backgroundColor: lightGray,
                                                  radius:
                                                      ScreenUtil().setSp(18),
                                                ),
                                              )
                                            : Container(
                                                height: ScreenUtil().setSp(36),
                                                width: ScreenUtil().setSp(36),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: darkGray,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      leaders.acceptUserDetail!
                                                          .fullname![0]
                                                          .toUpperCase(),
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          18),
                                                              color: black)),
                                                ),
                                              ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            children: [
                                              Visibility(
                                                visible: leaders
                                                        .acceptUserDetail!
                                                        .isProfileVerified ==
                                                    1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Image.asset(
                                                    AppIcons.verifyProfileIcon2,
                                                    height: 10,
                                                    width: 10,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                leaders.userIdentity == 1
                                                    ? "${leaders.acceptUserDetail!.fullname!},"
                                                    : "Anonymous,",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    color: black),
                                              ),
                                              Text(
                                                leaders
                                                    .acceptUserDetail!.country!,
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    color: buttonBlue),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            leaders.acceptUserDetail!
                                                    .profession ??
                                                "",
                                            style: size12_M_normal(
                                                textColor: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    leaders.userIdentity == 1 &&
                                            leaders.acceptUserDetail!.sId !=
                                                AppPreference().getString(
                                                    PreferencesKey
                                                        .interactUserId) &&
                                            leaders.acceptUserDetail!.sId !=
                                                AppPreference().getString(
                                                    PreferencesKey.userId) &&
                                            leaders.acceptUserDetail!
                                                    .amIFollowing ==
                                                0
                                        ? followButton(
                                            context,
                                            leaders.acceptUserDetail!.sId!,
                                            index,
                                            "opposition")
                                        : Container()
                                  ],
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                  // Container(),
                  leaderBoardApprovalController.invitedLeaderList.isEmpty
                      ? const Center(child: Text("No Invited"))
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: requestScrollController,
                          itemCount: leaderBoardApprovalController
                              .invitedLeaderList.length,
                          itemBuilder: (followersContext, index) {
                            JoinLeader joinLeader =
                                leaderBoardApprovalController.invitedLeaderList
                                    .elementAt(index);
                            return InkWell(
                              onTap: () {
                                muddaNewsController!.acceptUserDetail.value =
                                    joinLeader.user!;
                                if (joinLeader.user!.sId ==
                                    AppPreference()
                                        .getString(PreferencesKey.userId)) {
                                  Get.toNamed(RouteConstants.profileScreen);
                                } else {
                                  Map<String, String>? parameters = {
                                    "userDetail": jsonEncode(joinLeader.user!)
                                  };
                                  Get.toNamed(
                                      RouteConstants.otherUserProfileScreen,
                                      parameters: parameters);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              joinLeader.user!.profile != null
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          "${leaderBoardApprovalController.profilePath.value}${joinLeader.user!.profile}",
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        width: ScreenUtil()
                                                            .setSp(40),
                                                        height: ScreenUtil()
                                                            .setSp(40),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colorWhite,
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          20)) //                 <--- border radius here
                                                              ),
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      placeholder:
                                                          (context, url) =>
                                                              CircleAvatar(
                                                        backgroundColor:
                                                            lightGray,
                                                        radius: ScreenUtil()
                                                            .setSp(20),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          CircleAvatar(
                                                        backgroundColor:
                                                            lightGray,
                                                        radius: ScreenUtil()
                                                            .setSp(20),
                                                      ),
                                                    )
                                                  : Container(
                                                      height: ScreenUtil()
                                                          .setSp(40),
                                                      width: ScreenUtil()
                                                          .setSp(40),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: darkGray,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                            joinLeader.user!
                                                                .fullname![0]
                                                                .toUpperCase(),
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            20),
                                                                color: black)),
                                                      ),
                                                    ),
                                              getSizedBox(w: 8),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text.rich(TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "${joinLeader.user!.fullname},",
                                                              style: size12_M_bold(
                                                                  textColor: Colors
                                                                      .black)),
                                                          TextSpan(
                                                              text:
                                                                  " ${joinLeader.user!.country}",
                                                              style: size12_M_bold(
                                                                  textColor:
                                                                      buttonBlue)),
                                                          TextSpan(
                                                              text:
                                                                  "  ${convertToAgo(DateTime.parse(joinLeader.createdAt!))}",
                                                              style: size10_M_regular300(
                                                                  textColor:
                                                                      blackGray)),
                                                        ])),
                                                    getSizedBox(h: 2),
                                                    Text(
                                                      joinLeader.user!
                                                              .profession ??
                                                          '',
                                                      style: size12_M_normal(
                                                          textColor: colorGrey),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          getSizedBox(h: 5),
                                          Container(
                                            height: 1,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Api.delete.call(
                                          context,
                                          method:
                                              "request-to-user/delete/${joinLeader.sId}",
                                          param: {},
                                          onResponseSuccess: (object) {
                                            print("Abhishek $object");
                                            MuddaPost muddaPost =
                                                muddaNewsController!
                                                    .muddaPost.value;
                                            muddaPost.inviteCount =
                                                muddaPost.inviteCount! - 1;
                                            muddaNewsController!
                                                .muddaPost.value = MuddaPost();
                                            muddaNewsController!
                                                .muddaPost.value = muddaPost;
                                            leaderBoardApprovalController
                                                .invitedLeaderList
                                                .removeAt(index);
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Cancel",
                                          style: size12_M_normal(
                                              textColor: colorGrey),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                ],
                controller: tabController,
              ),
            )
          ],
        ),
      ),
    );
  }

  searchBoxTextFiled() {
    return showDialog(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              height: ScreenUtil().setSp(50),
              color: Colors.white,
              child: Material(
                child: Container(
                  height: ScreenUtil().setSp(50),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf7f7f7),
                    border: Border.all(color: colorGrey),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: size13_M_normal(textColor: color606060),
                          textInputAction: TextInputAction.search,
                          initialValue: searchText,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            hintStyle: size13_M_normal(textColor: color606060),
                            hintText: "Search",
                            border: InputBorder.none,
                          ),
                          onChanged: (text) {
                            if (text.isEmpty) {
                              searchText = text;
                              if (tabController.index == 1) {
                                oppositionPage = 1;
                                oppositionLeaders.clear();
                                Map<String, dynamic> map = {
                                  "page": oppositionPage.toString(),
                                  "leaderType": "opposition",
                                  "search": text,
                                  "_id": muddaPost!.sId,
                                };
                                Api.get.call(context,
                                    method: "mudda/leaders-in-mudda",
                                    param: map,
                                    isLoading: false,
                                    onResponseSuccess: (Map object) {
                                  var result =
                                      LeadersDataModel.fromJson(object);
                                  if (result.data!.isNotEmpty) {
                                    path = result.path!;
                                    muddaPath = result.path!;
                                    creator = muddaPost!
                                        .leaders![0].acceptUserDetail!;
                                    oppositionUser =
                                        result.dataMudda!.oppositionLeader;
                                    oppositionLeader =
                                        result.dataMudda!.oppositionLeader !=
                                                null
                                            ? result.dataMudda!
                                                .oppositionLeader!.user
                                            : null;
                                    oppositionLeaders.addAll(result.data!);
                                    setState(() {});
                                  } else {
                                    oppositionPage = oppositionPage > 1
                                        ? oppositionPage - 1
                                        : oppositionPage;
                                  }
                                });
                              } else {
                                page = 1;
                                favoursLeaders.clear();
                                Map<String, dynamic> map = {
                                  "page": page.toString(),
                                  "leaderType": "favour",
                                  "search": text,
                                  "_id": muddaPost!.sId,
                                };
                                Api.get.call(context,
                                    method: "mudda/leaders-in-mudda",
                                    param: map,
                                    isLoading: false,
                                    onResponseSuccess: (Map object) {
                                  var result =
                                      LeadersDataModel.fromJson(object);
                                  if (result.data!.isNotEmpty) {
                                    path = result.path!;
                                    favoursLeaders.addAll(result.data!);
                                    setState(() {});
                                  } else {
                                    page = page > 1 ? page - 1 : page;
                                  }
                                });
                              }
                            }
                          },
                          onFieldSubmitted: (text) {
                            searchText = text;
                            if (tabController.index == 1) {
                              oppositionPage = 1;
                              oppositionLeaders.clear();
                              Map<String, dynamic> map = {
                                "page": oppositionPage.toString(),
                                "leaderType": "opposition",
                                "search": text,
                                "_id": muddaPost!.sId,
                              };
                              Api.get.call(context,
                                  method: "mudda/leaders-in-mudda",
                                  param: map,
                                  isLoading: false,
                                  onResponseSuccess: (Map object) {
                                var result = LeadersDataModel.fromJson(object);
                                if (result.data!.isNotEmpty) {
                                  path = result.path!;
                                  muddaPath = result.path!;
                                  creator =
                                      muddaPost!.leaders![0].acceptUserDetail!;
                                  oppositionUser =
                                      result.dataMudda!.oppositionLeader;
                                  oppositionLeader =
                                      result.dataMudda!.oppositionLeader != null
                                          ? result
                                              .dataMudda!.oppositionLeader!.user
                                          : null;
                                  oppositionLeaders.addAll(result.data!);
                                  setState(() {});
                                } else {
                                  oppositionPage = oppositionPage > 1
                                      ? oppositionPage - 1
                                      : oppositionPage;
                                }
                              });
                            } else {
                              page = 1;
                              favoursLeaders.clear();
                              Map<String, dynamic> map = {
                                "page": page.toString(),
                                "leaderType": "favour",
                                "search": text,
                                "_id": muddaPost!.sId,
                              };
                              Api.get.call(context,
                                  method: "mudda/leaders-in-mudda",
                                  param: map,
                                  isLoading: false,
                                  onResponseSuccess: (Map object) {
                                var result = LeadersDataModel.fromJson(object);
                                if (result.data!.isNotEmpty) {
                                  path = result.path!;
                                  favoursLeaders.addAll(result.data!);
                                  setState(() {});
                                } else {
                                  page = page > 1 ? page - 1 : page;
                                }
                              });
                            }
                            Get.back();
                          },
                        ),
                      ),
                      Image.asset(
                        AppIcons.searchIcon,
                        height: 18,
                        width: 18,
                      ),
                      getSizedBox(w: 10)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  followButton(BuildContext context, String sId, int index, String type) {
    return InkWell(
      onTap: () {
        Api.post.call(
          context,
          method: "request-to-user/store",
          isLoading: true,
          param: {
            "user_id": AppPreference().getString(PreferencesKey.userId),
            "request_to_user_id": sId,
            "request_type": "follow",
          },
          onResponseSuccess: (object) {
            if (index >= 0) {
              if (type == "favour") {
                favoursLeaders.elementAt(index).acceptUserDetail!.amIFollowing =
                    favoursLeaders
                                .elementAt(index)
                                .acceptUserDetail!
                                .amIFollowing ==
                            0
                        ? 1
                        : 0;
              } else {
                oppositionLeaders
                    .elementAt(index)
                    .acceptUserDetail!
                    .amIFollowing = oppositionLeaders
                            .elementAt(index)
                            .acceptUserDetail!
                            .amIFollowing ==
                        0
                    ? 1
                    : 0;
              }
            } else if (index == -1) {
              creator!.amIFollowing = creator!.amIFollowing == 0 ? 1 : 0;
            } else if (index == -2) {
              oppositionLeader!.amIFollowing =
                  oppositionLeader!.amIFollowing == 0 ? 1 : 0;
            }
            setState(() {});
          },
        );
      },
      child: Container(
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
      ),
    );
  }
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
                text: "Anonymous user profiles can be visited or contacted.",
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
