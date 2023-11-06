import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:share_plus/share_plus.dart';

import '../../../../const/const.dart';
import '../../home_screen/widget/component/hot_mudda_post.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isJoinLeaderShip = true;
  int page = 1;
  int oppositionPage = 1;
  String path = "";
  String muddaPath = "";
  AcceptUserDetail? creator;
  AcceptUserDetail? oppositionLeader;
  MuddaPost? muddaPost;
  ScrollController favourScrollController = ScrollController();
  ScrollController oppositionScrollController = ScrollController();
  ScrollController invitedScrollController = ScrollController();
  MuddaNewsController muddaNewsController = Get.put(MuddaNewsController());
  LeaderBoardApprovalController leaderBoardApprovalController =
      Get.put(LeaderBoardApprovalController());

  String searchText = "";

  JoinLeader? oppositionUser;

  //
  dynamic dataMudda;

  @override
  void initState() {
    leaderBoardApprovalController.oppositionLeaders.clear();
    leaderBoardApprovalController.favoursLeaders.clear();

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
          leaderBoardApprovalController.dataMuddaForFavour.value = result;
          if (result.data!.isNotEmpty) {
            leaderBoardApprovalController.favourMuddebaaz.value =
                result.dataMudda!.muddebaaz!.favour!;
            path = result.path!;
            leaderBoardApprovalController.favoursLeaders.addAll(result.data!);
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
          leaderBoardApprovalController.dataMuddaForOpposition.value = result;
          if (result.data!.isNotEmpty) {
            leaderBoardApprovalController.oppositionMuddebaaz.value =
                result.dataMudda!.muddebaaz!.opposition!;
            path = result.path!;
            leaderBoardApprovalController.oppositionLeaders
                .addAll(result.data!);
            setState(() {});
          } else {
            oppositionPage =
                oppositionPage > 1 ? oppositionPage - 1 : oppositionPage;
          }
        });
      }
    });
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {});
      if (tabController.index == 1) {
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
          leaderBoardApprovalController.dataMuddaForOpposition.value = result;
          if (result.data!.isNotEmpty) {
            leaderBoardApprovalController.oppositionLeaders.clear();
            path = result.path!;
            muddaPath = result.path!;
            leaderBoardApprovalController.oppositionMuddebaaz.value =
                result.dataMudda!.muddebaaz!.opposition!;
            creator = result.dataMudda!.creator != null
                ? result.dataMudda!.creator!.user
                : null;
            oppositionUser = result.dataMudda!.oppositionLeader;
            oppositionLeader = result.dataMudda!.oppositionLeader != null
                ? result.dataMudda!.oppositionLeader!.user
                : null;
            leaderBoardApprovalController.oppositionLeaders
                .addAll(result.data!);
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
      var result = LeadersDataModel.fromJson(object);
      leaderBoardApprovalController.dataMuddaForFavour.value = result;
      if (result.data!.isNotEmpty) {
        path = result.path!;
        leaderBoardApprovalController.favourMuddebaaz.value =
            result.dataMudda!.muddebaaz!.favour!;
        muddaPath = result.path!;
        creator = result.dataMudda!.creator != null
            ? result.dataMudda!.creator!.user
            : null;
        oppositionUser = result.dataMudda!.oppositionLeader;
        oppositionLeader = result.dataMudda!.oppositionLeader != null
            ? result.dataMudda!.oppositionLeader!.user
            : null;
        leaderBoardApprovalController.favoursLeaders.addAll(result.data!);
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorAppBackground,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Leader Board",
          style: size18_M_bold(textColor: Colors.black),
        ),
        actions: [
          Visibility(
            // visible: AppPreference()
            //     .getString(PreferencesKey
            //     .userId) ==
            //     muddaPost!.leaders!
            //         .elementAt(0)
            //         .acceptUserDetail!
            //         .sId,
            visible: muddaPost!.isInvolved != null,
            child: IconButton(
                onPressed: () {
                  String? joinerType = muddaPost!.isInvolved!.joinerType;
                  log('-=- type$joinerType');

                  Get.toNamed(RouteConstants.invitedSearchScreen);
                },
                icon: SvgPicture.asset("assets/svg/ic_leader.svg",
                    height: ScreenUtil().setSp(20),
                    width: ScreenUtil().setSp(21))),
          ),
          IconButton(
              onPressed: () {
                Share.share(
                  '${Const.shareUrl}mudda/${muddaPost!.sId}',
                );
              },
              icon: Image.asset(AppIcons.shareIcon, height: 20, width: 20)),
        ],
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 25,
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
                muddaPost!.title ?? '',
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
                  Obx(() => Tab(
                        icon: Column(
                          children: [
                            Text(
                              leaderBoardApprovalController
                                          .dataMuddaForFavour.value.dataMudda !=
                                      null
                                  ? "Favour (${NumberFormat.compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                          '', // if you want to add currency symbol then pass that in this else leave it empty.
                                      // ).format(muddaPost!.favourCount)})",
                                    ).format(leaderBoardApprovalController.dataMuddaForFavour.value.dataMudda!.favourCount)})"
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
                      )),
                  Obx(() => Tab(
                        icon: Column(
                          children: [
                            Text(
                              leaderBoardApprovalController
                                          .dataMuddaForFavour.value.dataMudda !=
                                      null
                                  ? "Opposition (${NumberFormat.compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                          '', // if you want to add currency symbol then pass that in this else leave it empty.
                                      // ).format(muddaPost!.oppositionCount)})",
                                    ).format(leaderBoardApprovalController.dataMuddaForFavour.value.dataMudda!.oppositionCount)})"
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
                      ))
                  // Tab(
                  //   icon: Column(
                  //     children: [
                  //       Text(
                  //         "Invited (${NumberFormat.compactCurrency(
                  //           decimalDigits: 0,
                  //           symbol:
                  //           '', // if you want to add currency symbol then pass that in this else leave it empty.
                  //         ).format(muddaPost!.inviteCount)})",
                  //         style: tabController.index == 2
                  //             ? size14_M_normal(
                  //           textColor: Colors.black,
                  //         )
                  //             : size14_M_normal(
                  //           textColor: Colors.grey,
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 2,
                  //       ),
                  //       Container(
                  //         height: 1,
                  //         color: tabController.index == 2
                  //             ? Colors.black
                  //             : Colors.white,
                  //       )
                  //     ],
                  //   ),
                  // ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if (creator!.sId ==
                                        AppPreference()
                                            .getString(PreferencesKey.userId) ||
                                    creator!.sId ==
                                        AppPreference().getString(
                                            PreferencesKey.orgUserId)) {
                                  Get.toNamed(RouteConstants.profileScreen);
                                } else if (creator!.userType == "user") {
                                  Map<String, String>? parameters = {
                                    "userDetail": jsonEncode(creator!)
                                  };
                                  Get.toNamed(
                                      RouteConstants.otherUserProfileScreen,
                                      parameters: parameters);
                                } else {
                                  Map<String, String>? parameters = {
                                    "userDetail": jsonEncode(creator!)
                                  };
                                  Get.toNamed(
                                      RouteConstants.otherOrgProfileScreen,
                                      parameters: parameters);
                                }
                              },
                              child: Column(
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
                                    creator != null
                                        ? creator!.fullname ?? ''
                                        : "",
                                    style:
                                        size12_M_bold(textColor: Colors.black),
                                  ),
                                  Text(
                                    "Mudda Creator",
                                    style: size12_M_normal(
                                      textColor: Colors.blue,
                                    ),
                                  ),
                                  creator != null &&
                                          creator!.sId !=
                                              AppPreference().getString(
                                                  PreferencesKey
                                                      .interactUserId) &&
                                          creator!.sId !=
                                              AppPreference().getString(
                                                  PreferencesKey.userId)
                                      ? followButton(context, creator!.sId!,
                                          creator!.amIFollowing!, -1, "favour")
                                      : Container()
                                ],
                              ),
                            ),
                            if (leaderBoardApprovalController
                                    .favourMuddebaaz.length !=
                                0)
                              Obx(() => InkWell(
                                    onTap: () {
                                      // if (leaderBoardApprovalController
                                      //     .favourMuddebaaz[0].user!.Id ==
                                      //     AppPreference().getString(
                                      //         PreferencesKey
                                      //             .userId) ||
                                      //     leaderBoardApprovalController
                                      //         .oppositionLeader
                                      //         .value
                                      //         .sId ==
                                      //         AppPreference().getString(
                                      //             PreferencesKey
                                      //                 .orgUserId)) {
                                      //   Get.toNamed(
                                      //       RouteConstants.profileScreen);
                                      // } else if (leaderBoardApprovalController
                                      //     .oppositionLeader
                                      //     .value
                                      //     .userType ==
                                      //     "user") {
                                      //   Map<String, String>? parameters =
                                      //   {
                                      //     "userDetail": jsonEncode(
                                      //         leaderBoardApprovalController
                                      //             .oppositionLeader.value)
                                      //   };
                                      //   Get.toNamed(
                                      //       RouteConstants
                                      //           .otherUserProfileScreen,
                                      //       parameters: parameters);
                                      // } else {
                                      //   Map<String, String>? parameters =
                                      //   {
                                      //     "userDetail": jsonEncode(
                                      //         leaderBoardApprovalController
                                      //             .oppositionLeader.value)
                                      //   };
                                      //   Get.toNamed(
                                      //       RouteConstants
                                      //           .otherOrgProfileScreen,
                                      //       parameters: parameters);
                                      // }
                                    },
                                    child: Column(
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            leaderBoardApprovalController
                                                        .favourMuddebaaz[0]
                                                        .user!
                                                        .profile !=
                                                    null
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        "$path${leaderBoardApprovalController.favourMuddebaaz[0].user!.profile}",
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      width: ScreenUtil()
                                                          .setSp(45),
                                                      height: ScreenUtil()
                                                          .setSp(45),
                                                      decoration: BoxDecoration(
                                                        color: colorWhite,
                                                        border: Border.all(
                                                          width: ScreenUtil()
                                                              .setSp(1),
                                                          color: buttonBlue,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            22.5)) //                 <--- border radius here
                                                                ),
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            CircleAvatar(
                                                      backgroundColor:
                                                          lightGray,
                                                      radius: ScreenUtil()
                                                          .setSp(22.5),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            CircleAvatar(
                                                      backgroundColor:
                                                          lightGray,
                                                      radius: ScreenUtil()
                                                          .setSp(22.5),
                                                    ),
                                                  )
                                                : Container(
                                                    height:
                                                        ScreenUtil().setSp(45),
                                                    width:
                                                        ScreenUtil().setSp(45),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: darkGray,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                          leaderBoardApprovalController
                                                                      .favourMuddebaaz[
                                                                          0]
                                                                      .user!
                                                                      .fullname !=
                                                                  null
                                                              ? leaderBoardApprovalController
                                                                  .favourMuddebaaz[
                                                                      0]
                                                                  .user!
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
                                                                  color:
                                                                      black)),
                                                    ),
                                                  ),
                                            // Visibility(
                                            //   visible: leaderBoardApprovalController
                                            //       .oppositionLeader
                                            //       .value
                                            //       .isProfileVerified !=
                                            //       null
                                            //       ? leaderBoardApprovalController
                                            //       .oppositionLeader
                                            //       .value!
                                            //       .isProfileVerified ==
                                            //       1
                                            //       : false,
                                            //   child: Positioned(
                                            //     bottom: 0,
                                            //     right: -5,
                                            //     child: CircleAvatar(
                                            //         child: Image.asset(
                                            //           AppIcons
                                            //               .verifyProfileIcon2,
                                            //           width: 13,
                                            //           height: 13,
                                            //           color: Colors.blue,
                                            //         ),
                                            //         radius: 8,
                                            //         backgroundColor:
                                            //         colorAppBackground),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                        Text(
                                          leaderBoardApprovalController
                                                      .favourMuddebaaz[0]
                                                      .user!
                                                      .fullname !=
                                                  null
                                              ? leaderBoardApprovalController
                                                  .favourMuddebaaz[0]
                                                  .user!
                                                  .fullname!
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
                                        // leaderBoardApprovalController
                                        //     .favourMuddebaaz[0].user!.Id !=
                                        //     null &&
                                        //     leaderBoardApprovalController
                                        //         .favourMuddebaaz[0].user!.Id !=
                                        //         AppPreference().getString(
                                        //             PreferencesKey
                                        //                 .interactUserId) &&
                                        //     leaderBoardApprovalController
                                        //         .favourMuddebaaz[0].user!.Id !=
                                        //         AppPreference()
                                        //             .getString(
                                        //             PreferencesKey
                                        //                 .userId)
                                        //     ? followButton(
                                        //     context,
                                        //     leaderBoardApprovalController
                                        //         .favourMuddebaaz[0].user!.Id!,
                                        //     leaderBoardApprovalController
                                        //         .oppositionLeader
                                        //         .value
                                        //         .amIFollowing!,
                                        //     -2,
                                        //     "favour")
                                        //     : Container()
                                      ],
                                    ),
                                  )),
                          ],
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
                              // boxShadow: [
                              //   BoxShadow(
                              //       offset: const Offset(2, 2),
                              //       color: Colors.black.withOpacity(.2))
                              // ],
                            ),
                          ),
                          Obx(() => leaderBoardApprovalController
                                          .dataMuddaForFavour.value.dataMudda !=
                                      null &&
                                  leaderBoardApprovalController
                                          .dataMuddaForFavour
                                          .value
                                          .dataMudda!
                                          .inviteData !=
                                      null
                              ? Visibility(
                                  visible: leaderBoardApprovalController
                                          .dataMuddaForFavour
                                          .value
                                          .dataMudda!
                                          .inviteData !=
                                      null,
                                  child: InkWell(
                                    onTap: () {
                                      Api.post.call(
                                        context,
                                        method: "request-to-user/update",
                                        param: {
                                          "_id": leaderBoardApprovalController
                                              .dataMuddaForFavour
                                              .value
                                              .dataMudda!
                                              .inviteData!
                                              .Id
                                        },
                                        onResponseSuccess: (object) {
                                          // MyReaction temp = MyReaction();
                                          // temp.sId = 'ok';
                                          // muddaPost!.isInvolved= temp;
                                          Get.back();
                                        },
                                      );
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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          color: white),
                                      child: Center(
                                        child: Text('Accept Request',
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                color: black)),
                                      ),
                                    ),
                                  ),
                                )
                              : Visibility(
                                  visible: (creator != null
                                      ? AppPreference().getString(
                                              creator!.userType == "user"
                                                  ? PreferencesKey.userId
                                                  : PreferencesKey.orgUserId) !=
                                          creator!.sId!
                                      : false),
                                  child: muddaPost!.isInvolved == null &&
                                          muddaPost!.amIRequested == null
                                      ? Row(
                                          children: [
                                            getSizedBox(
                                                w: ScreenUtil().setSp(15)),
                                            Text(
                                              'Join Leadership',
                                              style: size12_M_regular(
                                                  textColor: Color(0xff31393C)),
                                            ),
                                            getSizedBox(
                                                w: ScreenUtil().setSp(8)),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () => showJoinDialog(
                                                    context,
                                                    isFromFav: true),
                                                child: Container(
                                                  height:
                                                      ScreenUtil().setSp(20),
                                                  decoration: BoxDecoration(
                                                    color: white,
                                                    border: Border.all(
                                                        color: grey, width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    'Favour',
                                                    style: size12_M_regular(
                                                        textColor: buttonBlue),
                                                  )),
                                                ),
                                              ),
                                            ),
                                            // Expanded(
                                            //   child: SizedBox(
                                            //     height: ScreenUtil().setSp(25),
                                            //     child: DropdownButtonFormField<String>(
                                            //       isExpanded: true,
                                            //       decoration: InputDecoration(
                                            //           contentPadding:
                                            //           EdgeInsets.symmetric(
                                            //               vertical: 0,
                                            //               horizontal: ScreenUtil()
                                            //                   .setSp(8)),
                                            //           enabledBorder:
                                            //           const OutlineInputBorder(
                                            //               borderRadius:
                                            //               BorderRadius.all(
                                            //                   Radius.circular(5)),
                                            //               borderSide: BorderSide(
                                            //                   color: grey)),
                                            //           border: const OutlineInputBorder(
                                            //               borderRadius: BorderRadius.all(
                                            //                   Radius.circular(5)),
                                            //               borderSide:
                                            //               BorderSide(color: grey)),
                                            //           focusedBorder:
                                            //           const OutlineInputBorder(
                                            //             borderRadius: BorderRadius.all(
                                            //                 Radius.circular(5)),
                                            //             borderSide:
                                            //             BorderSide(color: grey),
                                            //           ),
                                            //           filled: true,
                                            //           fillColor: white),
                                            //       hint: Text("Join Favour",
                                            //           style: GoogleFonts.nunitoSans(
                                            //               fontWeight: FontWeight.w400,
                                            //               fontSize:
                                            //               ScreenUtil().setSp(12),
                                            //               color: buttonBlue)),
                                            //       style: GoogleFonts.nunitoSans(
                                            //           fontWeight: FontWeight.w400,
                                            //           fontSize: ScreenUtil().setSp(12),
                                            //           color: buttonBlue),
                                            //       items: <String>[
                                            //         "Join Normal",
                                            //         "Join Anonymous",
                                            //       ].map((String value) {
                                            //         return DropdownMenuItem<String>(
                                            //           value: value,
                                            //           child: Text(value,
                                            //               overflow: TextOverflow.ellipsis,
                                            //               style: GoogleFonts.nunitoSans(
                                            //                   fontWeight: FontWeight.w400,
                                            //                   fontSize:
                                            //                   ScreenUtil().setSp(12),
                                            //                   color: black)),
                                            //         );
                                            //       }).toList(),
                                            //       onChanged: (String? newValue) {
                                            //         if (AppPreference().getBool(
                                            //             PreferencesKey.isGuest)) {
                                            //           Get.toNamed(
                                            //               RouteConstants.userProfileEdit);
                                            //         } else {
                                            //           // muddaNewsController!.selectJoinFavour
                                            //           //     .value = newValue!;
                                            //           Api.post.call(
                                            //             context,
                                            //             method: "request-to-user/store",
                                            //             param: {
                                            //               "user_id": AppPreference()
                                            //                   .getString(
                                            //                   PreferencesKey.userId),
                                            //               "request_to_user_id":
                                            //               muddaPost!.leaders![0].userId,
                                            //               "joining_content_id":
                                            //               muddaPost!.sId,
                                            //               "requestModalPath": muddaPath,
                                            //               "requestModal": "RealMudda",
                                            //               "request_type": "leader",
                                            //               "user_identity":
                                            //               newValue == "Join Normal"
                                            //                   ? "1"
                                            //                   : "0",
                                            //             },
                                            //             onResponseSuccess: (object) {
                                            //               muddaPost!.amIRequested =
                                            //                   MyReaction.fromJson(
                                            //                       object['data']);
                                            //               setState(() {});
                                            //             },
                                            //           );
                                            //         }
                                            //       },
                                            //     ),
                                            //   ),
                                            // ),
                                            getSizedBox(
                                                w: ScreenUtil().setSp(15)),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () => showJoinDialog(
                                                    context,
                                                    isFromFav: false),
                                                child: Container(
                                                  height:
                                                      ScreenUtil().setSp(20),
                                                  decoration: BoxDecoration(
                                                    color: white,
                                                    border: Border.all(
                                                        color: grey, width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    'Opposition',
                                                    style: size12_M_regular(
                                                        textColor:
                                                            buttonYellow),
                                                  )),
                                                ),
                                              ),
                                            ),
                                            // Expanded(
                                            //   child: SizedBox(
                                            //     height: ScreenUtil().setSp(25),
                                            //     child: DropdownButtonFormField<String>(
                                            //       isExpanded: true,
                                            //       decoration: InputDecoration(
                                            //           contentPadding:
                                            //           EdgeInsets.symmetric(
                                            //               vertical: 0,
                                            //               horizontal: ScreenUtil()
                                            //                   .setSp(8)),
                                            //           enabledBorder:
                                            //           const OutlineInputBorder(
                                            //               borderRadius:
                                            //               BorderRadius.all(
                                            //                   Radius.circular(5)),
                                            //               borderSide: BorderSide(
                                            //                   color: grey)),
                                            //           border: const OutlineInputBorder(
                                            //               borderRadius: BorderRadius.all(
                                            //                   Radius.circular(5)),
                                            //               borderSide:
                                            //               BorderSide(color: grey)),
                                            //           focusedBorder:
                                            //           const OutlineInputBorder(
                                            //             borderRadius: BorderRadius.all(
                                            //                 Radius.circular(5)),
                                            //             borderSide:
                                            //             BorderSide(color: grey),
                                            //           ),
                                            //           filled: true,
                                            //           fillColor: white),
                                            //       hint: Text("Join Opposition",
                                            //           overflow: TextOverflow.ellipsis,
                                            //           maxLines: 1,
                                            //           style: GoogleFonts.nunitoSans(
                                            //               fontWeight: FontWeight.w400,
                                            //               fontSize:
                                            //               ScreenUtil().setSp(12),
                                            //               color: buttonYellow)),
                                            //       style: GoogleFonts.nunitoSans(
                                            //           fontWeight: FontWeight.w400,
                                            //           fontSize: ScreenUtil().setSp(12),
                                            //           color: buttonYellow),
                                            //       items: <String>[
                                            //         "Join Normal",
                                            //         "Join Anonymous",
                                            //       ].map((String value) {
                                            //         return DropdownMenuItem<String>(
                                            //           value: value,
                                            //           child: Text(value,
                                            //               overflow: TextOverflow.ellipsis,
                                            //               style: GoogleFonts.nunitoSans(
                                            //                   fontWeight: FontWeight.w400,
                                            //                   fontSize:
                                            //                   ScreenUtil().setSp(12),
                                            //                   color: black)),
                                            //         );
                                            //       }).toList(),
                                            //       onChanged: (String? newValue) {
                                            //         if (AppPreference().getBool(
                                            //             PreferencesKey.isGuest)) {
                                            //           Get.toNamed(
                                            //               RouteConstants.userProfileEdit);
                                            //         } else {
                                            //           // muddaNewsController!.selectJoinFavour
                                            //           //     .value = newValue!;
                                            //           Api.post.call(
                                            //             context,
                                            //             method: "request-to-user/store",
                                            //             param: {
                                            //               "user_id": AppPreference()
                                            //                   .getString(
                                            //                   PreferencesKey.userId),
                                            //               "request_to_user_id":
                                            //               muddaPost!.leaders![0].userId,
                                            //               "joining_content_id":
                                            //               muddaPost!.sId,
                                            //               "requestModalPath": muddaPath,
                                            //               "requestModal": "RealMudda",
                                            //               "request_type": "opposition",
                                            //               "user_identity":
                                            //               newValue == "Join Normal"
                                            //                   ? "1"
                                            //                   : "0",
                                            //             },
                                            //             onResponseSuccess: (object) {
                                            //               muddaPost!.isInvolved =
                                            //                   MyReaction.fromJson(
                                            //                       object['data']);
                                            //               muddaPost!.oppositionCount =
                                            //                   muddaPost!.oppositionCount! +
                                            //                       1;
                                            //               setState(() {});
                                            //               oppositionPage = 1;
                                            //               leaderBoardApprovalController
                                            //                   .oppositionLeaders.clear();
                                            //               Map<String, dynamic> map = {
                                            //                 "page": oppositionPage
                                            //                     .toString(),
                                            //                 "leaderType": "opposition",
                                            //                 "_id": muddaPost!.sId,
                                            //               };
                                            //               Api.get.call(context,
                                            //                   method: "mudda/leaders-in-mudda",
                                            //                   param: map,
                                            //                   isLoading: false,
                                            //                   onResponseSuccess: (
                                            //                       Map object) {
                                            //                     var result = LeadersDataModel
                                            //                         .fromJson(object);
                                            //                     if (result.data!
                                            //                         .isNotEmpty) {
                                            //                       path = result.path!;
                                            //                       leaderBoardApprovalController
                                            //                           .oppositionLeaders
                                            //                           .addAll(
                                            //                           result.data!);
                                            //                       setState(() {});
                                            //                     } else {
                                            //                       oppositionPage =
                                            //                       oppositionPage > 1
                                            //                           ? oppositionPage - 1
                                            //                           : oppositionPage;
                                            //                     }
                                            //                   });
                                            //             },
                                            //           );
                                            //         }
                                            //       },
                                            //     ),
                                            //   ),
                                            // ),
                                            getSizedBox(
                                                w: ScreenUtil().setSp(15)),
                                          ],
                                        )
                                      : Visibility(
                                          visible: muddaPost!.amIRequested !=
                                                  null ||
                                              (muddaPost!.isInvolved != null &&
                                                      muddaPost!.isInvolved!
                                                              .joinerType! ==
                                                          "leader" ||
                                                  muddaPost!.isInvolved!
                                                          .joinerType! ==
                                                      "initial_leader"),
                                          child: InkWell(
                                            onTap: () {
                                              if (muddaPost!.isInvolved !=
                                                  null) {
                                                Api.delete.call(
                                                  context,
                                                  method:
                                                      "request-to-user/joined-delete/${muddaPost!.isInvolved!.sId}",
                                                  param: {
                                                    "_id": muddaPost!
                                                        .isInvolved!.sId
                                                  },
                                                  onResponseSuccess: (object) {
                                                    muddaPost!.isInvolved =
                                                        null;
                                                    setState(() {});
                                                    page = 1;
                                                    leaderBoardApprovalController
                                                        .favoursLeaders
                                                        .clear();
                                                    Map<String, dynamic> map = {
                                                      "page": page.toString(),
                                                      "leaderType": "favour",
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
                                                        leaderBoardApprovalController
                                                            .favoursLeaders
                                                            .addAll(
                                                                result.data!);
                                                        setState(() {});
                                                      } else {
                                                        page = page > 1
                                                            ? page - 1
                                                            : page;
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
                                                    "_id": muddaPost!
                                                        .amIRequested!.sId
                                                  },
                                                  onResponseSuccess: (object) {
                                                    muddaPost!.amIRequested =
                                                        null;
                                                    setState(() {});
                                                    page = 1;
                                                    leaderBoardApprovalController
                                                        .favoursLeaders
                                                        .clear();
                                                    Map<String, dynamic> map = {
                                                      "page": page.toString(),
                                                      "leaderType": "favour",
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
                                                        leaderBoardApprovalController
                                                            .favoursLeaders
                                                            .addAll(
                                                                result.data!);
                                                        setState(() {});
                                                      } else {
                                                        page = page > 1
                                                            ? page - 1
                                                            : page;
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
                                                  right:
                                                      ScreenUtil().setSp(25)),
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
                                                    muddaPost!.isInvolved !=
                                                            null
                                                        ? "Leave Leadership"
                                                        : "Pending Request",
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(12),
                                                            color: black)),
                                              ),
                                            ),
                                          ),
                                        ),
                                ))
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          height: ScreenUtil().setSp(35),
                          color: Colors.white,
                          child: Material(
                            child: Container(
                              height: ScreenUtil().setSp(35),
                              decoration: BoxDecoration(
                                color: const Color(0xFFf7f7f7),
                                border: Border.all(color: colorGrey),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, 6),
                                    blurRadius: 6,
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: size13_M_normal(
                                          textColor: color606060),
                                      textInputAction: TextInputAction.search,
                                      initialValue: searchText,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 15, bottom: 16),
                                        hintStyle: size13_M_normal(
                                            textColor: color606060),
                                        hintText: "Search",
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (text) {
                                        if (text.isEmpty) {
                                          searchText = text;
                                          if (tabController.index == 1) {
                                            oppositionPage = 1;
                                            leaderBoardApprovalController
                                                .oppositionLeaders
                                                .clear();
                                            Map<String, dynamic> map = {
                                              "page": oppositionPage.toString(),
                                              "leaderType": "opposition",
                                              "search": text,
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
                                                muddaPath = result.path!;
                                                creator = muddaPost!.leaders![0]
                                                    .acceptUserDetail!;
                                                oppositionUser = result
                                                    .dataMudda!
                                                    .oppositionLeader;
                                                oppositionLeader = result
                                                            .dataMudda!
                                                            .oppositionLeader !=
                                                        null
                                                    ? result.dataMudda!
                                                        .oppositionLeader!.user
                                                    : null;
                                                leaderBoardApprovalController
                                                    .oppositionLeaders
                                                    .addAll(result.data!);
                                                setState(() {});
                                              } else {
                                                oppositionPage =
                                                    oppositionPage > 1
                                                        ? oppositionPage - 1
                                                        : oppositionPage;
                                              }
                                            });
                                          } else {
                                            page = 1;
                                            leaderBoardApprovalController
                                                .favoursLeaders
                                                .clear();
                                            Map<String, dynamic> map = {
                                              "page": page.toString(),
                                              "leaderType": "favour",
                                              "search": text,
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
                                                leaderBoardApprovalController
                                                    .favoursLeaders
                                                    .addAll(result.data!);
                                                setState(() {});
                                              } else {
                                                page =
                                                    page > 1 ? page - 1 : page;
                                              }
                                            });
                                          }
                                        }
                                      },
                                      onFieldSubmitted: (text) {
                                        searchText = text;
                                        if (tabController.index == 1) {
                                          oppositionPage = 1;
                                          leaderBoardApprovalController
                                              .oppositionLeaders
                                              .clear();
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
                                                LeadersDataModel.fromJson(
                                                    object);
                                            if (result.data!.isNotEmpty) {
                                              path = result.path!;
                                              muddaPath = result.path!;
                                              creator = muddaPost!.leaders![0]
                                                  .acceptUserDetail!;
                                              oppositionUser = result
                                                  .dataMudda!.oppositionLeader;
                                              oppositionLeader = result
                                                          .dataMudda!
                                                          .oppositionLeader !=
                                                      null
                                                  ? result.dataMudda!
                                                      .oppositionLeader!.user
                                                  : null;
                                              leaderBoardApprovalController
                                                  .oppositionLeaders
                                                  .addAll(result.data!);
                                              setState(() {});
                                            } else {
                                              oppositionPage =
                                                  oppositionPage > 1
                                                      ? oppositionPage - 1
                                                      : oppositionPage;
                                            }
                                          });
                                        } else {
                                          page = 1;
                                          leaderBoardApprovalController
                                              .favoursLeaders
                                              .clear();
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
                                                LeadersDataModel.fromJson(
                                                    object);
                                            if (result.data!.isNotEmpty) {
                                              path = result.path!;
                                              leaderBoardApprovalController
                                                  .favoursLeaders
                                                  .addAll(result.data!);
                                              setState(() {});
                                            } else {
                                              page = page > 1 ? page - 1 : page;
                                            }
                                          });
                                        }
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
                      const SizedBox(
                        height: 15,
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

                          // Visibility(
                          //   visible:
                          //   muddaPost!.initialScope ==
                          //       "country"
                          //       ? (muddaPost!.uniqueState! <
                          //       3)
                          //       : muddaPost!.initialScope ==
                          //       "state"
                          //       ? (muddaPost!.uniqueCity! <
                          //       3)
                          //       : (muddaPost!.uniqueCountry! <
                          //       3),
                          //   child: Text(
                          //     " (${muddaPost!.initialScope == "country" ? (3 - muddaPost!.uniqueState!) : muddaPost!.initialScope == "state" ? (3 - muddaPost!.uniqueCity!) : (3 - muddaPost!.uniqueCountry!)} more places required)",
                          //     style: GoogleFonts.nunitoSans(
                          //         fontWeight: FontWeight.w400,
                          //         fontSize: ScreenUtil().setSp(12),
                          //         fontStyle: FontStyle.italic,
                          //         color: black),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Members:",
                            style: size12_M_bold(textColor: black),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Obx(() => ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: leaderBoardApprovalController
                              .favoursLeaders.length,
                          itemBuilder: (followersContext, index) {
                            Leaders leaders = leaderBoardApprovalController
                                .favoursLeaders
                                .elementAt(index);
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
                                                leaders.acceptUserDetail!
                                                        .country ??
                                                    '',
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
                                                    PreferencesKey.userId)
                                        ? followButton(
                                            context,
                                            leaders.acceptUserDetail!.sId!,
                                            leaders.acceptUserDetail!
                                                .amIFollowing!,
                                            index,
                                            "favour")
                                        : Container()
                                  ],
                                ),
                              ),
                            );
                          }))
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
                              if (leaderBoardApprovalController
                                      .oppositionMuddebaaz.length !=
                                  0)
                                Obx(() => InkWell(
                                      onTap: () {
                                        // if (leaderBoardApprovalController
                                        //     .favourMuddebaaz[0].user!.Id ==
                                        //     AppPreference().getString(
                                        //         PreferencesKey
                                        //             .userId) ||
                                        //     leaderBoardApprovalController
                                        //         .oppositionLeader
                                        //         .value
                                        //         .sId ==
                                        //         AppPreference().getString(
                                        //             PreferencesKey
                                        //                 .orgUserId)) {
                                        //   Get.toNamed(
                                        //       RouteConstants.profileScreen);
                                        // } else if (leaderBoardApprovalController
                                        //     .oppositionLeader
                                        //     .value
                                        //     .userType ==
                                        //     "user") {
                                        //   Map<String, String>? parameters =
                                        //   {
                                        //     "userDetail": jsonEncode(
                                        //         leaderBoardApprovalController
                                        //             .oppositionLeader.value)
                                        //   };
                                        //   Get.toNamed(
                                        //       RouteConstants
                                        //           .otherUserProfileScreen,
                                        //       parameters: parameters);
                                        // } else {
                                        //   Map<String, String>? parameters =
                                        //   {
                                        //     "userDetail": jsonEncode(
                                        //         leaderBoardApprovalController
                                        //             .oppositionLeader.value)
                                        //   };
                                        //   Get.toNamed(
                                        //       RouteConstants
                                        //           .otherOrgProfileScreen,
                                        //       parameters: parameters);
                                        // }
                                      },
                                      child: Column(
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              leaderBoardApprovalController
                                                          .oppositionMuddebaaz[
                                                              0]
                                                          .user!
                                                          .profile !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          "$path${leaderBoardApprovalController.oppositionMuddebaaz[0].user!.profile}",
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        width: ScreenUtil()
                                                            .setSp(45),
                                                        height: ScreenUtil()
                                                            .setSp(45),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colorWhite,
                                                          border: Border.all(
                                                            width: ScreenUtil()
                                                                .setSp(1),
                                                            color: buttonBlue,
                                                          ),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          22.5)) //                 <--- border radius here
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
                                                            .setSp(22.5),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          CircleAvatar(
                                                        backgroundColor:
                                                            lightGray,
                                                        radius: ScreenUtil()
                                                            .setSp(22.5),
                                                      ),
                                                    )
                                                  : Container(
                                                      height: ScreenUtil()
                                                          .setSp(45),
                                                      width: ScreenUtil()
                                                          .setSp(45),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: darkGray,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                            leaderBoardApprovalController
                                                                        .oppositionMuddebaaz[
                                                                            0]
                                                                        .user!
                                                                        .fullname !=
                                                                    null
                                                                ? leaderBoardApprovalController
                                                                    .oppositionMuddebaaz[
                                                                        0]
                                                                    .user!
                                                                    .fullname![
                                                                        0]
                                                                    .toUpperCase()
                                                                : "",
                                                            style: GoogleFonts.nunitoSans(
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
                                              // Visibility(
                                              //   visible: leaderBoardApprovalController
                                              //       .oppositionLeader
                                              //       .value
                                              //       .isProfileVerified !=
                                              //       null
                                              //       ? leaderBoardApprovalController
                                              //       .oppositionLeader
                                              //       .value!
                                              //       .isProfileVerified ==
                                              //       1
                                              //       : false,
                                              //   child: Positioned(
                                              //     bottom: 0,
                                              //     right: -5,
                                              //     child: CircleAvatar(
                                              //         child: Image.asset(
                                              //           AppIcons
                                              //               .verifyProfileIcon2,
                                              //           width: 13,
                                              //           height: 13,
                                              //           color: Colors.blue,
                                              //         ),
                                              //         radius: 8,
                                              //         backgroundColor:
                                              //         colorAppBackground),
                                              //   ),
                                              // )
                                            ],
                                          ),
                                          Text(
                                            leaderBoardApprovalController
                                                        .oppositionMuddebaaz[0]
                                                        .user!
                                                        .fullname !=
                                                    null
                                                ? leaderBoardApprovalController
                                                    .oppositionMuddebaaz[0]
                                                    .user!
                                                    .fullname!
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
                                          // leaderBoardApprovalController
                                          //     .favourMuddebaaz[0].user!.Id !=
                                          //     null &&
                                          //     leaderBoardApprovalController
                                          //         .favourMuddebaaz[0].user!.Id !=
                                          //         AppPreference().getString(
                                          //             PreferencesKey
                                          //                 .interactUserId) &&
                                          //     leaderBoardApprovalController
                                          //         .favourMuddebaaz[0].user!.Id !=
                                          //         AppPreference()
                                          //             .getString(
                                          //             PreferencesKey
                                          //                 .userId)
                                          //     ? followButton(
                                          //     context,
                                          //     leaderBoardApprovalController
                                          //         .favourMuddebaaz[0].user!.Id!,
                                          //     leaderBoardApprovalController
                                          //         .oppositionLeader
                                          //         .value
                                          //         .amIFollowing!,
                                          //     -2,
                                          //     "favour")
                                          //     : Container()
                                        ],
                                      ),
                                    )),
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
                              // boxShadow: [
                              //   BoxShadow(
                              //       offset: const Offset(2, 2),
                              //       color: Colors.black.withOpacity(.2))
                              // ],
                            ),
                          ),
                          if (leaderBoardApprovalController
                                      .dataMuddaForOpposition.value.dataMudda !=
                                  null &&
                              leaderBoardApprovalController
                                      .dataMuddaForOpposition
                                      .value
                                      .dataMudda!
                                      .inviteData !=
                                  null)
                            Obx(() => Visibility(
                                  visible: leaderBoardApprovalController
                                          .dataMuddaForOpposition
                                          .value
                                          .dataMudda!
                                          .inviteData !=
                                      null,
                                  child: InkWell(
                                    onTap: () {
                                      Api.post.call(
                                        context,
                                        method: "request-to-user/update",
                                        param: {
                                          "_id": leaderBoardApprovalController
                                              .dataMuddaForOpposition
                                              .value
                                              .dataMudda!
                                              .inviteData!
                                              .Id
                                        },
                                        onResponseSuccess: (object) {
                                          // MyReaction temp = MyReaction();
                                          // temp.sId = 'ok';
                                          // muddaPost!.isInvolved= temp;
                                          Get.back();
                                        },
                                      );
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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          color: white),
                                      child: Center(
                                        child: Text('Accept Request',
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                color: black)),
                                      ),
                                    ),
                                  ),
                                ))
                          else
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
                                        Text(
                                          'Join Leadership',
                                          style: size12_M_regular(
                                              textColor: Color(0xff31393C)),
                                        ),
                                        getSizedBox(w: ScreenUtil().setSp(8)),
                                      Obx(() => Visibility(
                                           visible:  leaderBoardApprovalController
                                          .dataMuddaForFavour
                                          .value
                                          .dataMudda!
                                          .inviteData ==
                                          null,
                                          child:Expanded(
                                            child: GestureDetector(
                                              onTap: () => showJoinDialog(context,
                                                  isFromFav: true),
                                              child: Container(
                                                height: ScreenUtil().setSp(20),
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  border: Border.all(
                                                      color: grey, width: 1),
                                                  borderRadius:
                                                  BorderRadius.circular(4),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                      'Favour',
                                                      style: size12_M_regular(
                                                          textColor: buttonBlue),
                                                    )),
                                              ),
                                            ),
                                          ) ))  ,
                                        // Expanded(
                                        //   child: SizedBox(
                                        //     height: ScreenUtil().setSp(25),
                                        //     child: DropdownButtonFormField<String>(
                                        //       isExpanded: true,
                                        //       decoration: InputDecoration(
                                        //           contentPadding:
                                        //           EdgeInsets.symmetric(
                                        //               vertical: 0,
                                        //               horizontal: ScreenUtil()
                                        //                   .setSp(8)),
                                        //           enabledBorder:
                                        //           const OutlineInputBorder(
                                        //               borderRadius:
                                        //               BorderRadius.all(
                                        //                   Radius.circular(5)),
                                        //               borderSide: BorderSide(
                                        //                   color: grey)),
                                        //           border: const OutlineInputBorder(
                                        //               borderRadius: BorderRadius.all(
                                        //                   Radius.circular(5)),
                                        //               borderSide:
                                        //               BorderSide(color: grey)),
                                        //           focusedBorder:
                                        //           const OutlineInputBorder(
                                        //             borderRadius: BorderRadius.all(
                                        //                 Radius.circular(5)),
                                        //             borderSide:
                                        //             BorderSide(color: grey),
                                        //           ),
                                        //           filled: true,
                                        //           fillColor: white),
                                        //       hint: Text("Join Favour",
                                        //           style: GoogleFonts.nunitoSans(
                                        //               fontWeight: FontWeight.w400,
                                        //               fontSize:
                                        //               ScreenUtil().setSp(12),
                                        //               color: buttonBlue)),
                                        //       style: GoogleFonts.nunitoSans(
                                        //           fontWeight: FontWeight.w400,
                                        //           fontSize: ScreenUtil().setSp(12),
                                        //           color: buttonBlue),
                                        //       items: <String>[
                                        //         "Join Normal",
                                        //         "Join Anonymous",
                                        //       ].map((String value) {
                                        //         return DropdownMenuItem<String>(
                                        //           value: value,
                                        //           child: Text(value,
                                        //               overflow: TextOverflow.ellipsis,
                                        //               style: GoogleFonts.nunitoSans(
                                        //                   fontWeight: FontWeight.w400,
                                        //                   fontSize:
                                        //                   ScreenUtil().setSp(12),
                                        //                   color: black)),
                                        //         );
                                        //       }).toList(),
                                        //       onChanged: (String? newValue) {
                                        //         if (AppPreference().getBool(
                                        //             PreferencesKey.isGuest)) {
                                        //           Get.toNamed(
                                        //               RouteConstants.userProfileEdit);
                                        //         } else {
                                        //           // muddaNewsController!.selectJoinFavour
                                        //           //     .value = newValue!;
                                        //           Api.post.call(
                                        //             context,
                                        //             method: "request-to-user/store",
                                        //             param: {
                                        //               "user_id": AppPreference()
                                        //                   .getString(
                                        //                   PreferencesKey.userId),
                                        //               "request_to_user_id":
                                        //               muddaPost!.leaders![0].userId,
                                        //               "joining_content_id":
                                        //               muddaPost!.sId,
                                        //               "requestModalPath": muddaPath,
                                        //               "requestModal": "RealMudda",
                                        //               "request_type": "leader",
                                        //               "user_identity":
                                        //               newValue == "Join Normal"
                                        //                   ? "1"
                                        //                   : "0",
                                        //             },
                                        //             onResponseSuccess: (object) {
                                        //               muddaPost!.amIRequested =
                                        //                   MyReaction.fromJson(
                                        //                       object['data']);
                                        //               setState(() {});
                                        //             },
                                        //           );
                                        //         }
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
                                        getSizedBox(w: ScreenUtil().setSp(15)),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => showJoinDialog(context,
                                                isFromFav: false),
                                            child: Container(
                                              height: ScreenUtil().setSp(20),
                                              decoration: BoxDecoration(
                                                color: white,
                                                border: Border.all(
                                                    color: grey, width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                'Opposition',
                                                style: size12_M_regular(
                                                    textColor: buttonYellow),
                                              )),
                                            ),
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: SizedBox(
                                        //     height: ScreenUtil().setSp(25),
                                        //     child: DropdownButtonFormField<String>(
                                        //       isExpanded: true,
                                        //       decoration: InputDecoration(
                                        //           contentPadding:
                                        //           EdgeInsets.symmetric(
                                        //               vertical: 0,
                                        //               horizontal: ScreenUtil()
                                        //                   .setSp(8)),
                                        //           enabledBorder:
                                        //           const OutlineInputBorder(
                                        //               borderRadius:
                                        //               BorderRadius.all(
                                        //                   Radius.circular(5)),
                                        //               borderSide: BorderSide(
                                        //                   color: grey)),
                                        //           border: const OutlineInputBorder(
                                        //               borderRadius: BorderRadius.all(
                                        //                   Radius.circular(5)),
                                        //               borderSide:
                                        //               BorderSide(color: grey)),
                                        //           focusedBorder:
                                        //           const OutlineInputBorder(
                                        //             borderRadius: BorderRadius.all(
                                        //                 Radius.circular(5)),
                                        //             borderSide:
                                        //             BorderSide(color: grey),
                                        //           ),
                                        //           filled: true,
                                        //           fillColor: white),
                                        //       hint: Text("Join Opposition",
                                        //           overflow: TextOverflow.ellipsis,
                                        //           maxLines: 1,
                                        //           style: GoogleFonts.nunitoSans(
                                        //               fontWeight: FontWeight.w400,
                                        //               fontSize:
                                        //               ScreenUtil().setSp(12),
                                        //               color: buttonYellow)),
                                        //       style: GoogleFonts.nunitoSans(
                                        //           fontWeight: FontWeight.w400,
                                        //           fontSize: ScreenUtil().setSp(12),
                                        //           color: buttonYellow),
                                        //       items: <String>[
                                        //         "Join Normal",
                                        //         "Join Anonymous",
                                        //       ].map((String value) {
                                        //         return DropdownMenuItem<String>(
                                        //           value: value,
                                        //           child: Text(value,
                                        //               overflow: TextOverflow.ellipsis,
                                        //               style: GoogleFonts.nunitoSans(
                                        //                   fontWeight: FontWeight.w400,
                                        //                   fontSize:
                                        //                   ScreenUtil().setSp(12),
                                        //                   color: black)),
                                        //         );
                                        //       }).toList(),
                                        //       onChanged: (String? newValue) {
                                        //         if (AppPreference().getBool(
                                        //             PreferencesKey.isGuest)) {
                                        //           Get.toNamed(
                                        //               RouteConstants.userProfileEdit);
                                        //         } else {
                                        //           // muddaNewsController!.selectJoinFavour
                                        //           //     .value = newValue!;
                                        //           Api.post.call(
                                        //             context,
                                        //             method: "request-to-user/store",
                                        //             param: {
                                        //               "user_id": AppPreference()
                                        //                   .getString(
                                        //                   PreferencesKey.userId),
                                        //               "request_to_user_id":
                                        //               muddaPost!.leaders![0].userId,
                                        //               "joining_content_id":
                                        //               muddaPost!.sId,
                                        //               "requestModalPath": muddaPath,
                                        //               "requestModal": "RealMudda",
                                        //               "request_type": "opposition",
                                        //               "user_identity":
                                        //               newValue == "Join Normal"
                                        //                   ? "1"
                                        //                   : "0",
                                        //             },
                                        //             onResponseSuccess: (object) {
                                        //               muddaPost!.isInvolved =
                                        //                   MyReaction.fromJson(
                                        //                       object['data']);
                                        //               muddaPost!.oppositionCount =
                                        //                   muddaPost!.oppositionCount! +
                                        //                       1;
                                        //               setState(() {});
                                        //               oppositionPage = 1;
                                        //               leaderBoardApprovalController
                                        //                   .oppositionLeaders.clear();
                                        //               Map<String, dynamic> map = {
                                        //                 "page": oppositionPage
                                        //                     .toString(),
                                        //                 "leaderType": "opposition",
                                        //                 "_id": muddaPost!.sId,
                                        //               };
                                        //               Api.get.call(context,
                                        //                   method: "mudda/leaders-in-mudda",
                                        //                   param: map,
                                        //                   isLoading: false,
                                        //                   onResponseSuccess: (
                                        //                       Map object) {
                                        //                     var result = LeadersDataModel
                                        //                         .fromJson(object);
                                        //                     if (result.data!
                                        //                         .isNotEmpty) {
                                        //                       path = result.path!;
                                        //                       leaderBoardApprovalController
                                        //                           .oppositionLeaders
                                        //                           .addAll(
                                        //                           result.data!);
                                        //                       setState(() {});
                                        //                     } else {
                                        //                       oppositionPage =
                                        //                       oppositionPage > 1
                                        //                           ? oppositionPage - 1
                                        //                           : oppositionPage;
                                        //                     }
                                        //                   });
                                        //             },
                                        //           );
                                        //         }
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
                                        getSizedBox(w: ScreenUtil().setSp(15)),
                                        // getSizedBox(w: ScreenUtil().setSp(15)),
                                        // Expanded(
                                        //   child: SizedBox(
                                        //     height: ScreenUtil().setSp(25),
                                        //     child: DropdownButtonFormField<String>(
                                        //       isExpanded: true,
                                        //       decoration: InputDecoration(
                                        //           contentPadding:
                                        //           EdgeInsets.symmetric(
                                        //               vertical: 0,
                                        //               horizontal: ScreenUtil()
                                        //                   .setSp(8)),
                                        //           enabledBorder:
                                        //           const OutlineInputBorder(
                                        //               borderRadius:
                                        //               BorderRadius.all(
                                        //                   Radius.circular(5)),
                                        //               borderSide: BorderSide(
                                        //                   color: grey)),
                                        //           border: const OutlineInputBorder(
                                        //               borderRadius: BorderRadius.all(
                                        //                   Radius.circular(5)),
                                        //               borderSide:
                                        //               BorderSide(color: grey)),
                                        //           focusedBorder:
                                        //           const OutlineInputBorder(
                                        //             borderRadius: BorderRadius.all(
                                        //                 Radius.circular(5)),
                                        //             borderSide:
                                        //             BorderSide(color: grey),
                                        //           ),
                                        //           filled: true,
                                        //           fillColor: white),
                                        //       hint: Text("Join Favour",
                                        //           style: GoogleFonts.nunitoSans(
                                        //               fontWeight: FontWeight.w400,
                                        //               fontSize:
                                        //               ScreenUtil().setSp(12),
                                        //               color: buttonBlue)),
                                        //       style: GoogleFonts.nunitoSans(
                                        //           fontWeight: FontWeight.w400,
                                        //           fontSize: ScreenUtil().setSp(12),
                                        //           color: buttonBlue),
                                        //       items: <String>[
                                        //         "Join Normal",
                                        //         "Join Anonymous",
                                        //       ].map((String value) {
                                        //         return DropdownMenuItem<String>(
                                        //           value: value,
                                        //           child: Text(value,
                                        //               overflow: TextOverflow.ellipsis,
                                        //               style: GoogleFonts.nunitoSans(
                                        //                   fontWeight: FontWeight.w400,
                                        //                   fontSize:
                                        //                   ScreenUtil().setSp(12),
                                        //                   color: black)),
                                        //         );
                                        //       }).toList(),
                                        //       onChanged: (String? newValue) {
                                        //         if (AppPreference().getBool(
                                        //             PreferencesKey.isGuest)) {
                                        //           Get.toNamed(
                                        //               RouteConstants.userProfileEdit);
                                        //         } else {
                                        //           // muddaNewsController!.selectJoinFavour
                                        //           //     .value = newValue!;
                                        //           Api.post.call(
                                        //             context,
                                        //             method: "request-to-user/store",
                                        //             param: {
                                        //               "user_id": AppPreference()
                                        //                   .getString(
                                        //                   PreferencesKey.userId),
                                        //               "request_to_user_id":
                                        //               muddaPost!.leaders![0].userId,
                                        //               "joining_content_id":
                                        //               muddaPost!.sId,
                                        //               "requestModalPath": muddaPath,
                                        //               "requestModal": "RealMudda",
                                        //               "request_type": "leader",
                                        //               "user_identity":
                                        //               newValue == "Join Normal"
                                        //                   ? "1"
                                        //                   : "0",
                                        //             },
                                        //             onResponseSuccess: (object) {
                                        //               muddaPost!.amIRequested =
                                        //                   MyReaction.fromJson(
                                        //                       object['data']);
                                        //               setState(() {});
                                        //             },
                                        //           );
                                        //         }
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
                                        // getSizedBox(w: ScreenUtil().setSp(15)),
                                        // Expanded(
                                        //   child: SizedBox(
                                        //     height: ScreenUtil().setSp(25),
                                        //     child: DropdownButtonFormField<String>(
                                        //       isExpanded: true,
                                        //       decoration: InputDecoration(
                                        //           contentPadding:
                                        //           EdgeInsets.symmetric(
                                        //               vertical: 0,
                                        //               horizontal: ScreenUtil()
                                        //                   .setSp(8)),
                                        //           enabledBorder:
                                        //           const OutlineInputBorder(
                                        //               borderRadius:
                                        //               BorderRadius.all(
                                        //                   Radius.circular(5)),
                                        //               borderSide: BorderSide(
                                        //                   color: grey)),
                                        //           border: const OutlineInputBorder(
                                        //               borderRadius: BorderRadius.all(
                                        //                   Radius.circular(5)),
                                        //               borderSide:
                                        //               BorderSide(color: grey)),
                                        //           focusedBorder:
                                        //           const OutlineInputBorder(
                                        //             borderRadius: BorderRadius.all(
                                        //                 Radius.circular(5)),
                                        //             borderSide:
                                        //             BorderSide(color: grey),
                                        //           ),
                                        //           filled: true,
                                        //           fillColor: white),
                                        //       hint: Text("Join Opposition",
                                        //           overflow: TextOverflow.ellipsis,
                                        //           maxLines: 1,
                                        //           style: GoogleFonts.nunitoSans(
                                        //               fontWeight: FontWeight.w400,
                                        //               fontSize:
                                        //               ScreenUtil().setSp(12),
                                        //               color: buttonYellow)),
                                        //       style: GoogleFonts.nunitoSans(
                                        //           fontWeight: FontWeight.w400,
                                        //           fontSize: ScreenUtil().setSp(12),
                                        //           color: buttonYellow),
                                        //       items: <String>[
                                        //         "Join Normal",
                                        //         "Join Anonymous",
                                        //       ].map((String value) {
                                        //         return DropdownMenuItem<String>(
                                        //           value: value,
                                        //           child: Text(value,
                                        //               overflow: TextOverflow.ellipsis,
                                        //               style: GoogleFonts.nunitoSans(
                                        //                   fontWeight: FontWeight.w400,
                                        //                   fontSize:
                                        //                   ScreenUtil().setSp(12),
                                        //                   color: black)),
                                        //         );
                                        //       }).toList(),
                                        //       onChanged: (String? newValue) {
                                        //         if (AppPreference().getBool(
                                        //             PreferencesKey.isGuest)) {
                                        //           Get.toNamed(
                                        //               RouteConstants.userProfileEdit);
                                        //         } else {
                                        //           // muddaNewsController!.selectJoinFavour
                                        //           //     .value = newValue!;
                                        //           Api.post.call(
                                        //             context,
                                        //             method: "request-to-user/store",
                                        //             param: {
                                        //               "user_id": AppPreference()
                                        //                   .getString(
                                        //                   PreferencesKey.userId),
                                        //               "request_to_user_id":
                                        //               muddaPost!.leaders![0].userId,
                                        //               "joining_content_id":
                                        //               muddaPost!.sId,
                                        //               "requestModalPath": muddaPath,
                                        //               "requestModal": "RealMudda",
                                        //               "request_type": "opposition",
                                        //               "user_identity":
                                        //               newValue == "Join Normal"
                                        //                   ? "1"
                                        //                   : "0",
                                        //             },
                                        //             onResponseSuccess: (object) {
                                        //               muddaPost!.isInvolved =
                                        //                   MyReaction.fromJson(
                                        //                       object['data']);
                                        //               muddaPost!.oppositionCount =
                                        //                   muddaPost!
                                        //                       .oppositionCount! +
                                        //                       1;
                                        //               setState(() {});
                                        //               oppositionPage = 1;
                                        //               leaderBoardApprovalController
                                        //                   .oppositionLeaders.clear();
                                        //               Map<String, dynamic> map = {
                                        //                 "page": oppositionPage
                                        //                     .toString(),
                                        //                 "leaderType": "opposition",
                                        //                 "_id": muddaPost!.sId,
                                        //               };
                                        //               Api.get.call(context,
                                        //                   method: "mudda/leaders-in-mudda",
                                        //                   param: map,
                                        //                   isLoading: false,
                                        //                   onResponseSuccess: (
                                        //                       Map object) {
                                        //                     var result = LeadersDataModel
                                        //                         .fromJson(object);
                                        //                     if (result.data!
                                        //                         .isNotEmpty) {
                                        //                       path = result.path!;
                                        //                       leaderBoardApprovalController
                                        //                           .oppositionLeaders
                                        //                           .addAll(
                                        //                           result.data!);
                                        //                       setState(() {});
                                        //                     } else {
                                        //                       oppositionPage =
                                        //                       oppositionPage > 1
                                        //                           ? oppositionPage - 1
                                        //                           : oppositionPage;
                                        //                     }
                                        //                   });
                                        //             },
                                        //           );
                                        //         }
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
                                        // getSizedBox(w: ScreenUtil().setSp(15)),
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
                                                "_id":
                                                    muddaPost!.isInvolved!.sId
                                              },
                                              onResponseSuccess: (object) {
                                                muddaPost!.isInvolved = null;
                                                muddaPost!.oppositionCount =
                                                    muddaPost!
                                                            .oppositionCount! -
                                                        1;
                                                setState(() {});
                                                oppositionPage = 1;
                                                leaderBoardApprovalController
                                                    .oppositionLeaders
                                                    .clear();
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
                                                    leaderBoardApprovalController
                                                        .oppositionLeaders
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
                                                leaderBoardApprovalController
                                                    .oppositionLeaders
                                                    .clear();
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
                                                    leaderBoardApprovalController
                                                        .oppositionLeaders
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
                                                    : "Pending Request",
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
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          height: ScreenUtil().setSp(35),
                          color: Colors.white,
                          child: Material(
                            child: Container(
                              height: ScreenUtil().setSp(35),
                              decoration: BoxDecoration(
                                color: const Color(0xFFf7f7f7),
                                border: Border.all(color: colorGrey),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, 6),
                                    blurRadius: 6,
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: size13_M_normal(
                                          textColor: color606060),
                                      textInputAction: TextInputAction.search,
                                      initialValue: searchText,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 15, bottom: 16),
                                        hintStyle: size13_M_normal(
                                            textColor: color606060),
                                        hintText: "Search",
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (text) {
                                        if (text.isEmpty) {
                                          searchText = text;
                                          if (tabController.index == 1) {
                                            oppositionPage = 1;
                                            leaderBoardApprovalController
                                                .oppositionLeaders
                                                .clear();
                                            Map<String, dynamic> map = {
                                              "page": oppositionPage.toString(),
                                              "leaderType": "opposition",
                                              "search": text,
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
                                                muddaPath = result.path!;
                                                creator = muddaPost!.leaders![0]
                                                    .acceptUserDetail!;
                                                oppositionUser = result
                                                    .dataMudda!
                                                    .oppositionLeader;
                                                oppositionLeader = result
                                                            .dataMudda!
                                                            .oppositionLeader !=
                                                        null
                                                    ? result.dataMudda!
                                                        .oppositionLeader!.user
                                                    : null;
                                                leaderBoardApprovalController
                                                    .oppositionLeaders
                                                    .addAll(result.data!);
                                                setState(() {});
                                              } else {
                                                oppositionPage =
                                                    oppositionPage > 1
                                                        ? oppositionPage - 1
                                                        : oppositionPage;
                                              }
                                            });
                                          } else {
                                            page = 1;
                                            leaderBoardApprovalController
                                                .favoursLeaders
                                                .clear();
                                            Map<String, dynamic> map = {
                                              "page": page.toString(),
                                              "leaderType": "favour",
                                              "search": text,
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
                                                leaderBoardApprovalController
                                                    .favoursLeaders
                                                    .addAll(result.data!);
                                                setState(() {});
                                              } else {
                                                page =
                                                    page > 1 ? page - 1 : page;
                                              }
                                            });
                                          }
                                        }
                                      },
                                      onFieldSubmitted: (text) {
                                        searchText = text;
                                        if (tabController.index == 1) {
                                          oppositionPage = 1;
                                          leaderBoardApprovalController
                                              .oppositionLeaders
                                              .clear();
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
                                                LeadersDataModel.fromJson(
                                                    object);
                                            if (result.data!.isNotEmpty) {
                                              path = result.path!;
                                              muddaPath = result.path!;
                                              creator = muddaPost!.leaders![0]
                                                  .acceptUserDetail!;
                                              oppositionUser = result
                                                  .dataMudda!.oppositionLeader;
                                              oppositionLeader = result
                                                          .dataMudda!
                                                          .oppositionLeader !=
                                                      null
                                                  ? result.dataMudda!
                                                      .oppositionLeader!.user
                                                  : null;
                                              leaderBoardApprovalController
                                                  .oppositionLeaders
                                                  .addAll(result.data!);
                                              setState(() {});
                                            } else {
                                              oppositionPage =
                                                  oppositionPage > 1
                                                      ? oppositionPage - 1
                                                      : oppositionPage;
                                            }
                                          });
                                        } else {
                                          page = 1;
                                          leaderBoardApprovalController
                                              .favoursLeaders
                                              .clear();
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
                                                LeadersDataModel.fromJson(
                                                    object);
                                            if (result.data!.isNotEmpty) {
                                              path = result.path!;
                                              leaderBoardApprovalController
                                                  .favoursLeaders
                                                  .addAll(result.data!);
                                              setState(() {});
                                            } else {
                                              page = page > 1 ? page - 1 : page;
                                            }
                                          });
                                        }
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
                      const SizedBox(
                        height: 15,
                      ),
                      Obx(() => ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: leaderBoardApprovalController
                              .oppositionLeaders.length,
                          itemBuilder: (followersContext, index) {
                            Leaders leaders = leaderBoardApprovalController
                                .oppositionLeaders
                                .elementAt(index);
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
                                                    PreferencesKey.userId)
                                        ? followButton(
                                            context,
                                            leaders.acceptUserDetail!.sId!,
                                            leaders.acceptUserDetail!
                                                .amIFollowing!,
                                            index,
                                            "opposition")
                                        : Container()
                                  ],
                                ),
                              ),
                            );
                          }))
                    ],
                  ),
                  // Container(),
                  // leaderBoardApprovalController
                  //     .invitedLeaderList.isEmpty ? const Center(child: Text("No Invited")) : ListView.builder(
                  //     physics: const AlwaysScrollableScrollPhysics(),
                  //     controller: invitedScrollController,
                  //     itemCount: leaderBoardApprovalController
                  //         .invitedLeaderList.length,
                  //     itemBuilder: (followersContext, index) {
                  //       JoinLeader joinLeader =
                  //       leaderBoardApprovalController
                  //           .invitedLeaderList
                  //           .elementAt(index);
                  //       return InkWell(
                  //         onTap: () {
                  //           muddaNewsController!.acceptUserDetail
                  //               .value = joinLeader.user!;
                  //           if (joinLeader.user!.sId ==
                  //               AppPreference().getString(
                  //                   PreferencesKey.userId)) {
                  //             Get.toNamed(
                  //                 RouteConstants.profileScreen);
                  //           } else {
                  //             Map<String, String>? parameters = {
                  //               "userDetail":
                  //               jsonEncode(joinLeader.user!)
                  //             };
                  //             Get.toNamed(
                  //                 RouteConstants
                  //                     .otherUserProfileScreen,
                  //                 parameters: parameters);
                  //           }
                  //         },
                  //         child: Padding(
                  //           padding:
                  //           const EdgeInsets.only(bottom: 10),
                  //           child: Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Column(
                  //                   children: [
                  //                     Row(
                  //                       children: [
                  //                         joinLeader.user!.profile !=
                  //                             null
                  //                             ? CachedNetworkImage(
                  //                           imageUrl:
                  //                           "${leaderBoardApprovalController.profilePath.value}${joinLeader.user!.profile}",
                  //                           imageBuilder: (context,
                  //                               imageProvider) =>
                  //                               Container(
                  //                                 width:
                  //                                 ScreenUtil()
                  //                                     .setSp(
                  //                                     40),
                  //                                 height:
                  //                                 ScreenUtil()
                  //                                     .setSp(
                  //                                     40),
                  //                                 decoration:
                  //                                 BoxDecoration(
                  //                                   color:
                  //                                   colorWhite,
                  //                                   borderRadius: BorderRadius.all(
                  //                                       Radius.circular(
                  //                                           ScreenUtil()
                  //                                               .setSp(20)) //                 <--- border radius here
                  //                                   ),
                  //                                   image: DecorationImage(
                  //                                       image:
                  //                                       imageProvider,
                  //                                       fit: BoxFit
                  //                                           .cover),
                  //                                 ),
                  //                               ),
                  //                           placeholder:
                  //                               (context,
                  //                               url) =>
                  //                               CircleAvatar(
                  //                                 backgroundColor:
                  //                                 lightGray,
                  //                                 radius:
                  //                                 ScreenUtil()
                  //                                     .setSp(
                  //                                     20),
                  //                               ),
                  //                           errorWidget: (context,
                  //                               url,
                  //                               error) =>
                  //                               CircleAvatar(
                  //                                 backgroundColor:
                  //                                 lightGray,
                  //                                 radius:
                  //                                 ScreenUtil()
                  //                                     .setSp(
                  //                                     20),
                  //                               ),
                  //                         )
                  //                             : Container(
                  //                           height: ScreenUtil()
                  //                               .setSp(40),
                  //                           width: ScreenUtil()
                  //                               .setSp(40),
                  //                           decoration:
                  //                           BoxDecoration(
                  //                             border:
                  //                             Border.all(
                  //                               color: darkGray,
                  //                             ),
                  //                             shape: BoxShape
                  //                                 .circle,
                  //                           ),
                  //                           child: Center(
                  //                             child: Text(
                  //                                 joinLeader
                  //                                     .user!
                  //                                     .fullname![
                  //                                 0]
                  //                                     .toUpperCase(),
                  //                                 style: GoogleFonts.nunitoSans(
                  //                                     fontWeight:
                  //                                     FontWeight
                  //                                         .w400,
                  //                                     fontSize: ScreenUtil()
                  //                                         .setSp(
                  //                                         20),
                  //                                     color:
                  //                                     black)),
                  //                           ),
                  //                         ),
                  //                         getSizedBox(w: 8),
                  //                         Expanded(
                  //                           child: Column(
                  //                             mainAxisAlignment:
                  //                             MainAxisAlignment
                  //                                 .start,
                  //                             crossAxisAlignment:
                  //                             CrossAxisAlignment
                  //                                 .start,
                  //                             children: [
                  //                               Text.rich(TextSpan(
                  //                                   children: <
                  //                                       TextSpan>[
                  //                                     TextSpan(
                  //                                         text:
                  //                                         "${joinLeader.user!.fullname},",
                  //                                         style: size12_M_bold(
                  //                                             textColor:
                  //                                             Colors.black)),
                  //                                     TextSpan(
                  //                                         text:
                  //                                         " ${joinLeader.user!.country}",
                  //                                         style: size12_M_bold(
                  //                                             textColor:
                  //                                             buttonBlue)),
                  //                                     TextSpan(
                  //                                         text:
                  //                                         "  ${convertToAgo(DateTime.parse(joinLeader.createdAt!))}",
                  //                                         style: size10_M_regular300(
                  //                                             textColor:
                  //                                             blackGray)),
                  //                                   ])),
                  //                               getSizedBox(h: 2),
                  //                               Text(
                  //                                 joinLeader.user!
                  //                                     .profession ??
                  //                                     '',
                  //                                 style: size12_M_normal(
                  //                                     textColor:
                  //                                     colorGrey),
                  //                               )
                  //                             ],
                  //                           ),
                  //                         )
                  //                       ],
                  //                     ),
                  //                     getSizedBox(h: 5),
                  //                     Container(
                  //                       height: 1,
                  //                       color: Colors.white,
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //               InkWell(
                  //                 onTap: () {
                  //                   Api.delete.call(
                  //                     context,
                  //                     method:
                  //                     "request-to-user/delete/${joinLeader.sId}",
                  //                     param: {},
                  //                     onResponseSuccess: (object) {
                  //                       print("Abhishek $object");
                  //                       MuddaPost muddaPost =
                  //                           muddaNewsController!
                  //                               .muddaPost.value;
                  //                       muddaPost.inviteCount =
                  //                           muddaPost.inviteCount! -
                  //                               1;
                  //                       muddaNewsController!.muddaPost
                  //                           .value = MuddaPost();
                  //                       muddaNewsController!.muddaPost
                  //                           .value = muddaPost;
                  //                       leaderBoardApprovalController
                  //                           .invitedLeaderList
                  //                           .removeAt(index);
                  //                     },
                  //                   );
                  //                 },
                  //                 child: Padding(
                  //                   padding:
                  //                   const EdgeInsets.all(8.0),
                  //                   child: Text(
                  //                     "Cancel",
                  //                     style: size12_M_normal(
                  //                         textColor: colorGrey),
                  //                   ),
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     }),
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
                                leaderBoardApprovalController.oppositionLeaders
                                    .clear();
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
                                    leaderBoardApprovalController
                                        .oppositionLeaders
                                        .addAll(result.data!);
                                    setState(() {});
                                  } else {
                                    oppositionPage = oppositionPage > 1
                                        ? oppositionPage - 1
                                        : oppositionPage;
                                  }
                                });
                              } else {
                                page = 1;
                                leaderBoardApprovalController.favoursLeaders
                                    .clear();
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
                                    leaderBoardApprovalController.favoursLeaders
                                        .addAll(result.data!);
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
                              leaderBoardApprovalController.oppositionLeaders
                                  .clear();
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
                                  leaderBoardApprovalController
                                      .oppositionLeaders
                                      .addAll(result.data!);
                                  setState(() {});
                                } else {
                                  oppositionPage = oppositionPage > 1
                                      ? oppositionPage - 1
                                      : oppositionPage;
                                }
                              });
                            } else {
                              page = 1;
                              leaderBoardApprovalController.favoursLeaders
                                  .clear();
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
                                  leaderBoardApprovalController.favoursLeaders
                                      .addAll(result.data!);
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

  followButton(
      BuildContext context, String sId, int status, int index, String type) {
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
                leaderBoardApprovalController.favoursLeaders
                    .elementAt(index)
                    .acceptUserDetail!
                    .amIFollowing = leaderBoardApprovalController.favoursLeaders
                            .elementAt(index)
                            .acceptUserDetail!
                            .amIFollowing ==
                        0
                    ? 1
                    : 0;
              } else {
                leaderBoardApprovalController.oppositionLeaders
                    .elementAt(index)
                    .acceptUserDetail!
                    .amIFollowing = leaderBoardApprovalController
                            .oppositionLeaders
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
            color: status == 0 ? Colors.transparent : Color(0xff606060),
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(3))),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: status == 0 ? 15 : 10, vertical: 2),
          child: Text(
            status == 0 ? "Follow" : 'Following',
            style: size10_M_normal(textColor: status == 0 ? colorGrey : white),
          ),
        ),
      ),
    );
  }

  showJoinDialog(BuildContext context, {required bool isFromFav}) {
    // TODO: Dialog code
    return showDialog(
      context: Get.context as BuildContext,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: white,
                border: Border.all(color: grey, width: 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: ScreenUtil().setSp(54),
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xff606060),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Join Mudda Leadership as-',
                          style: size16_M_bold(textColor: white))
                    ],
                  ),
                ),
                getSizedBox(h: ScreenUtil().setSp(16)),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            muddaNewsController.isSelectRole.value = 0;
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 18,
                                width: 18,
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: black),
                                ),
                                child:
                                    muddaNewsController.isSelectRole.value == 0
                                        ? Container(
                                            margin: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: black,
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        : const SizedBox(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Normal",
                                    style: muddaNewsController
                                                .isSelectRole.value ==
                                            0
                                        ? size14_M_bold(textColor: black)
                                        : size14_M_normal(textColor: black),
                                  ),
                                  Text(
                                    "(Public Profile)",
                                    style: GoogleFonts.nunitoSans(
                                        color: grey,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        GestureDetector(
                          onTap: () {
                            muddaNewsController.isSelectRole.value = 1;
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 18,
                                width: 18,
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: black),
                                ),
                                child:
                                    muddaNewsController.isSelectRole.value == 1
                                        ? Container(
                                            margin: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: black,
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        : const SizedBox(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Anonymous",
                                    style: muddaNewsController
                                                .isSelectRole.value ==
                                            1
                                        ? size14_M_bold(textColor: black)
                                        : size14_M_normal(textColor: black),
                                  ),
                                  Text(
                                    "(Hidden from Public)",
                                    style: GoogleFonts.nunitoSans(
                                        color: grey,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                getSizedBox(h: ScreenUtil().setSp(32)),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (isFromFav) {
                            if (AppPreference()
                                .getBool(PreferencesKey.isGuest)) {
                              updateProfileDialog(context);
                            } else {
                              // muddaNewsController!.selectJoinFavour
                              //     .value = newValue!;
                              Api.post.call(
                                context,
                                method: "request-to-user/store",
                                param: {
                                  "user_id": AppPreference()
                                      .getString(PreferencesKey.userId),
                                  "request_to_user_id":
                                      muddaPost!.leaders![0].userId,
                                  "joining_content_id": muddaPost!.sId,
                                  "requestModalPath": muddaPath,
                                  "requestModal": "RealMudda",
                                  "request_type": "leader",
                                  "user_identity":
                                      muddaNewsController.isSelectRole.value ==
                                              1
                                          ? "0"
                                          : "1",
                                },
                                onResponseSuccess: (object) {
                                  muddaPost!.amIRequested =
                                      MyReaction.fromJson(object['data']);
                                  setState(() {});
                                  Get.back();
                                },
                              );
                            }
                          } else {
                            if (AppPreference()
                                .getBool(PreferencesKey.isGuest)) {
                              updateProfileDialog(context);
                            } else {
                              // muddaNewsController!.selectJoinFavour
                              //     .value = newValue!;
                              Api.post.call(
                                context,
                                method: "request-to-user/store",
                                param: {
                                  "user_id": AppPreference()
                                      .getString(PreferencesKey.userId),
                                  "request_to_user_id":
                                      muddaPost!.leaders![0].userId,
                                  "joining_content_id": muddaPost!.sId,
                                  "requestModalPath": muddaPath,
                                  "requestModal": "RealMudda",
                                  "request_type": "opposition",
                                  "user_identity":
                                      muddaNewsController.isSelectRole.value ==
                                              1
                                          ? "0"
                                          : "1",
                                },
                                onResponseSuccess: (object) {
                                  muddaPost!.isInvolved =
                                      MyReaction.fromJson(object['data']);
                                  muddaPost!.oppositionCount =
                                      muddaPost!.oppositionCount! + 1;
                                  setState(() {});
                                  oppositionPage = 1;
                                  leaderBoardApprovalController
                                      .oppositionLeaders
                                      .clear();
                                  Map<String, dynamic> map = {
                                    "page": oppositionPage.toString(),
                                    "leaderType": "opposition",
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
                                      leaderBoardApprovalController
                                          .oppositionLeaders
                                          .addAll(result.data!);
                                      setState(() {});
                                    } else {
                                      oppositionPage = oppositionPage > 1
                                          ? oppositionPage - 1
                                          : oppositionPage;
                                    }
                                  });
                                  Get.back();
                                },
                              );
                            }
                          }
                        },
                        child: Text('Join')),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Cancel'))
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
                text: "Anonymous user profiles can't be visited or contacted.",
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
