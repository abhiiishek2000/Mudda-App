import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/const/const.dart';
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
import 'package:mudda/ui/screens/profile_screen/widget/invite_bottom_sheet.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';
import 'package:share_plus/share_plus.dart';

import 'leader_board_screen.dart';


class LeaderBoardApprovalScreen extends StatefulWidget {
  final String? muddaId;
  final bool isFromAdmin;

  const LeaderBoardApprovalScreen(
      {Key? key, this.muddaId, this.isFromAdmin = false})
      : super(key: key);

  @override
  State<LeaderBoardApprovalScreen> createState() =>
      _LeaderBoardApprovalScreenState();
}

class _LeaderBoardApprovalScreenState extends State<LeaderBoardApprovalScreen>
    with TickerProviderStateMixin {
  TabController? tabController;
  int selectedTabIndex = 0;
  String searchText = "";
  int inviteCount = 0;
  bool isJoinLeaderShip = true;
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  LeaderBoardApprovalController leaderBoardApprovalController =
  Get.put(LeaderBoardApprovalController());
  ScrollController scrollController = ScrollController();
  MuddaPost? muddaPost;
  ScrollController favourScrollController = ScrollController();
  ScrollController oppositionScrollController = ScrollController();
  ScrollController requestScrollController = ScrollController();
  ScrollController invitedScrollController = ScrollController();
  int page = 1;
  int requestPage = 1;
  int invitedPage = 1;
  int favourPage = 1;
  int oppositionPage = 1;
  String path = "";
  String muddaPath = "";




  @override
  void initState() {
    super.initState();
    muddaPost = Get.arguments;
    muddaNewsController = Get.find<MuddaNewsController>();

    // -=-=- Favour -=-=-
    favourScrollController.addListener(() {
      if (favourScrollController.position.maxScrollExtent ==
          favourScrollController.position.pixels) {
        favourPage++;
        paginateFavourCall();
      }
    });
    onFavourCall();

    // -=-=- Oppositions -=-=-
    oppositionScrollController.addListener(() {
      if (oppositionScrollController.position.maxScrollExtent ==
          oppositionScrollController.position.pixels) {
        oppositionPage++;
        paginateOppositionCall();
      }
    });
    onOppositionCall();

    //
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      setState(() {
        selectedTabIndex = tabController!.index;
      });
    });

    leaderBoardApprovalController.joinLeaderList.clear();
    leaderBoardApprovalController.invitedLeaderList.clear();
    leaderBoardApprovalController.requestsList.clear();
    leaderBoardApprovalController.favoursLeaders.clear();
    leaderBoardApprovalController.oppositionLeaders.clear();

    callJoinLeaders(context);
    callInvitedLeaders(context);
    callRequests(context);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        page = page + 1;
        callJoinLeaders(context);
      }
    });
    invitedScrollController.addListener(() {
      if (invitedScrollController.position.maxScrollExtent ==
          invitedScrollController.position.pixels) {
        invitedPage++;
        paginateInvitedLeaders(context);
      }
    });
    requestScrollController.addListener(() {
      if (requestScrollController.position.maxScrollExtent ==
          requestScrollController.position.pixels) {
        requestPage = requestPage + 1;
        callRequests(context);
      }
    });
    inviteCount = muddaNewsController.muddaPost.value.inviteCount!;
    leaderBoardApprovalController.controller!
        .animateTo(muddaNewsController.leaderBoardIndex.value);
    setState(() {});
  }

  paginateFavourCall() {
    Map<String, dynamic> map = {
      "page": favourPage.toString(),
      "leaderType": "favour",
      "_id": muddaNewsController.muddaPost.value.sId,
      // "_id": muddaNewsController?.muddaPost.value.sId,
      // "_id": muddaPost!.sId,
      // "_id": muddaNewsController!.muddaPost.value.sId,
    };
    Api.get.call(context,
        method: "mudda/leaders-in-mudda",
        param: map,
        isLoading: false, onResponseSuccess: (Map object) {
          log('------------------------- Favour -----------------------------');

          var result = LeadersDataModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            leaderBoardApprovalController.dataMudda.value = result.dataMudda!;
            leaderBoardApprovalController.favourMuddebaaz.value= result.dataMudda!.muddebaaz!.favour!;
            leaderBoardApprovalController.creator.value =
            (result.dataMudda!.creator != null
                ? result.dataMudda!.creator!.user
                : null)!;
            path = result.path!;
            leaderBoardApprovalController.favoursLeaders.addAll(result.data!);
            setState(() {});
          } else {
            favourPage = favourPage > 1 ? favourPage - 1 : favourPage;
          }
          setState(() {});
        });
  }

  onFavourCall() {
    Map<String, dynamic> map = {
      "page": favourPage.toString(),
      "leaderType": "favour",
      "_id": muddaNewsController.muddaPost.value.sId,
      // "_id": muddaNewsController?.muddaPost.value.sId,
      // "_id": muddaPost!.sId,
      // "_id": muddaNewsController!.muddaPost.value.sId,
    };
    Api.get.call(context,
        method: "mudda/leaders-in-mudda",
        param: map,
        isLoading: false, onResponseSuccess: (Map object) {
          log('------------------------- Favour -----------------------------');

          var result = LeadersDataModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            leaderBoardApprovalController.dataMudda.value = result.dataMudda!;
            leaderBoardApprovalController.favourMuddebaaz.value= result.dataMudda!.muddebaaz!.favour!;
            leaderBoardApprovalController.creator.value =
            (result.dataMudda!.creator != null
                ? result.dataMudda!.creator!.user
                : null)!;
            path = result.path!;
            leaderBoardApprovalController.favoursLeaders.clear();
            leaderBoardApprovalController.favoursLeaders.addAll(result.data!);
            setState(() {});
          } else {
            favourPage = favourPage > 1 ? favourPage - 1 : favourPage;
          }
          setState(() {});
        });
  }

  onOppositionCall() {
    Map<String, dynamic> mapOpposition = {
      "page": oppositionPage.toString(),
      "leaderType": "opposition",
      "_id": muddaNewsController.muddaPost.value.sId,
      // "_id":  muddaNewsController?.muddaPost.value.sId,
      // "_id": muddaPost!.sId,
      // "_id": muddaNewsController!.muddaPost.value.sId,
    };
    Api.get.call(context,
        method: "mudda/leaders-in-mudda",
        param: mapOpposition,
        isLoading: false, onResponseSuccess: (Map object) {
          log('------------------------- Opposition -----------------------------');

          var result = LeadersDataModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            leaderBoardApprovalController.creator.value =
            (result.dataMudda!.creator != null
                ? result.dataMudda!.creator!.user
                : null)!;
            path = result.path!;
            leaderBoardApprovalController.oppositionMuddebaaz.value= result.dataMudda!.muddebaaz!.opposition!;
            leaderBoardApprovalController.oppositionLeaders.clear();
            leaderBoardApprovalController.oppositionLeaders.addAll(result.data!);
          } else {
            oppositionPage =
            oppositionPage > 1 ? oppositionPage - 1 : oppositionPage;
          }
          setState(() {});
        });
  }
  paginateOppositionCall() {
    Map<String, dynamic> mapOpposition = {
      "page": oppositionPage.toString(),
      "leaderType": "opposition",
      "_id": muddaNewsController.muddaPost.value.sId,
      // "_id":  muddaNewsController?.muddaPost.value.sId,
      // "_id": muddaPost!.sId,
      // "_id": muddaNewsController!.muddaPost.value.sId,
    };
    Api.get.call(context,
        method: "mudda/leaders-in-mudda",
        param: mapOpposition,
        isLoading: false, onResponseSuccess: (Map object) {
          log('------------------------- Opposition -----------------------------');

          var result = LeadersDataModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            leaderBoardApprovalController.creator.value =
            (result.dataMudda!.creator != null
                ? result.dataMudda!.creator!.user
                : null)!;
            path = result.path!;
            leaderBoardApprovalController.oppositionMuddebaaz.value= result.dataMudda!.muddebaaz!.opposition!;
            leaderBoardApprovalController.oppositionLeaders.addAll(result.data!);
          } else {
            oppositionPage =
            oppositionPage > 1 ? oppositionPage - 1 : oppositionPage;
          }
          setState(() {});
        });
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: GestureDetector(
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
                Expanded(
                  child: Center(
                    child: Text(
                      "Leader Board",
                      style: size18_M_bold(textColor: Colors.black),
                    ),
                  ),
                ),
                if (muddaNewsController.muddaPost.value.isVerify == 1)
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteConstants.invitedSearchScreen,
                            arguments:
                            muddaNewsController.muddaPost.value.sId!)!
                            .then((value) {
                          if (value) {
                            invitedPage = 1;
                            leaderBoardApprovalController.invitedLeaderList
                                .clear();
                            return callInvitedLeaders(context);
                          }
                        });
                      },
                      child: Image.asset(
                        AppIcons.iconInviteNew,
                        height: ScreenUtil().setSp(20),
                        width: ScreenUtil().setSp(20),
                      ),
                    ),
                  ),
                if (muddaNewsController.muddaPost.value.isVerify == 1)
                  const SizedBox(
                    width: 32,
                  ),
                if (muddaNewsController.muddaPost.value.isVerify == 1)
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Share.share(
                          '${Const.shareUrl}mudda/${muddaNewsController.muddaPost.value.sId!}',
                        );
                      },
                      child: SvgPicture.asset(
                        "assets/svg/share.svg",
                        height: ScreenUtil().setSp(20),
                        width: ScreenUtil().setSp(20),
                      ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                muddaNewsController.muddaPost.value.title!,
                textAlign: TextAlign.center,
                style: size12_M_normal(textColor: Colors.black),
              ),
            ),

            const SizedBox(
              height: 15,
            ),
            Obx(
                  () => TabBar(
                controller: leaderBoardApprovalController.controller!,
                labelColor: Colors.black,
                indicatorColor: Colors.transparent,
                padding: EdgeInsets.zero,
                labelStyle: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w700,
                    fontSize: ScreenUtil().setSp(12),
                    color: black),
                unselectedLabelStyle: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(12),
                    color: blackGray),
                onTap: (int index) {
                  log("-=--= index =-=- $index");
                  leaderBoardApprovalController.isInvitedTab.value = false;
                  leaderBoardApprovalController.isOppositionInvitedTab.value = false;

                  setState(() {});
                },
                tabs: [
                  Tab(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Text(
                        //   "Joined (${NumberFormat.compactCurrency(
                        //     decimalDigits: 0,
                        //     symbol:
                        //         '', // if you want to add currency symbol then pass that in this else leave it empty.
                        //   ).format(muddaNewsController!.muddaPost.value.joinersCount)})",
                        //   style:
                        //       leaderBoardApprovalController.tabIndex.value == 0
                        //           ? size14_M_bold(
                        //               textColor: Colors.black,
                        //             )
                        //           : size14_M_normal(
                        //               textColor: Colors.grey,
                        //             ),
                        // ),
                        Text(
                          muddaNewsController.muddaPost.value.favourCount ==
                              null
                              ? ""
                              : "Favour (${NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol:
                            '', // if you want to add currency symbol then pass that in this else leave it empty.
                            // ).format(muddaNewsController!.muddaPost.value.favourCount)})",
                          ).format(muddaNewsController.muddaPost.value.favourCount)})",
                          style: leaderBoardApprovalController.tabIndex.value ==
                              0
                              ? size12_M_bold(
                            textColor: Colors.black,
                          )
                              : size12_M_normal(
                            textColor: Colors.grey,
                          ),
                        ),
/*                        muddaNewsController!.muddaPost.value.amISupport != 0
                            ? Text(
                                "Favour (${NumberFormat.compactCurrency(
                                  decimalDigits: 0,
                                  symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                ).format(muddaNewsController!.muddaPost.value.favourCount)})",
                                style: leaderBoardApprovalController
                                            .tabIndex.value ==
                                        0
                                    ? size13_M_bold(
                                        textColor: Colors.black,
                                      )
                                    : size13_M_normal(
                                        textColor: Colors.grey,
                                      ),
                              )
                            : muddaNewsController!
                                        .muddaPost.value.amIUnSupport !=
                                    0
                                ? Text(
                                    "Opposition (${NumberFormat.compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                          '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(muddaNewsController!.muddaPost.value.oppositionCount)})",
                                    style: leaderBoardApprovalController
                                                .tabIndex.value ==
                                            0
                                        ? size13_M_bold(
                                            textColor: Colors.black,
                                          )
                                        : size13_M_normal(
                                            textColor: Colors.grey,
                                          ),
                                  )
                                : Text(
                                    "Joined (${NumberFormat.compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                          '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(muddaNewsController!.muddaPost.value.joinersCount)})",
                                    style: leaderBoardApprovalController
                                                .tabIndex.value ==
                                            0
                                        ? size13_M_bold(
                                            textColor: Colors.black,
                                          )
                                        : size13_M_normal(
                                            textColor: Colors.grey,
                                          ),
                                  ),*/
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          height: 1,
                          color: leaderBoardApprovalController.tabIndex.value ==
                              0
                              ? Colors.black
                              : Colors.white,
                        )
                      ],
                    ),
                  ),
                  // Tab(
                  //   icon: Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Text(
                  //         "Invited (${NumberFormat.compactCurrency(
                  //           decimalDigits: 0,
                  //           symbol:
                  //           '', // if you want to add currency symbol then pass that in this else leave it empty.
                  //         ).format(muddaNewsController!.muddaPost.value.inviteCount ?? 0)})",
                  //         style:
                  //         leaderBoardApprovalController.tabIndex.value == 1
                  //             ? size14_M_bold(
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
                  //         color:
                  //         leaderBoardApprovalController.tabIndex.value == 1
                  //             ? Colors.black
                  //             : Colors.white,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Obx(()=>Tab(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          muddaNewsController.muddaPost.value.oppositionCount ==
                              null
                              ? ""
                              : "Opposition (${NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol:
                            '', // if you want to add currency symbol then pass that in this else leave it empty.
                            // ).format(muddaNewsController!.muddaPost.value.oppositionCount ?? 0)})",
                          ).format(muddaNewsController.muddaPost.value.oppositionCount)})",
                          style: leaderBoardApprovalController.tabIndex.value ==
                              1 ? size12_M_bold(
                            textColor: Colors.black,
                          )
                              : size12_M_normal(
                            textColor: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          height: 1,
                          color: leaderBoardApprovalController.tabIndex.value ==
                              1
                              ? Colors.black
                              : Colors.white,
                        )
                      ],
                    ),
                  )),
                  Obx(()=>Tab(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Requests (${NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol:
                            '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(muddaNewsController.muddaPost.value.requestsCount)})",
                          style: leaderBoardApprovalController.tabIndex.value ==
                              2 ? size12_M_bold(
                            textColor: Colors.black,
                          )
                              : size12_M_normal(
                            textColor: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          height: 1,
                          color: leaderBoardApprovalController.tabIndex.value ==
                              2 &&
                              leaderBoardApprovalController
                                  .isInvitedTab.value ==
                                  false
                              ? Colors.black
                              : Colors.white,
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Obx(() => Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    //TODO: Favour Tab
                    Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        muddaNewsController.muddaPost.value.isVerify == 1
                            ? Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (leaderBoardApprovalController
                                      .creator.value.sId ==
                                      AppPreference().getString(
                                          PreferencesKey.userId) ||
                                      leaderBoardApprovalController
                                          .creator.value.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.orgUserId)) {
                                    Get.toNamed(
                                        RouteConstants.profileScreen);
                                  } else if (leaderBoardApprovalController
                                      .creator.value.userType ==
                                      "user") {
                                    Map<String, String>? parameters = {
                                      "userDetail": jsonEncode(
                                          leaderBoardApprovalController
                                              .creator.value)
                                    };
                                    Get.toNamed(
                                        RouteConstants
                                            .otherUserProfileScreen,
                                        parameters: parameters);
                                  } else {
                                    Map<String, String>? parameters = {
                                      "userDetail": jsonEncode(
                                          leaderBoardApprovalController
                                              .creator.value)
                                    };
                                    Get.toNamed(
                                        RouteConstants
                                            .otherOrgProfileScreen,
                                        parameters: parameters);
                                  }
                                },
                                child: Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        leaderBoardApprovalController
                                            .creator
                                            .value
                                            .profile !=
                                            null &&
                                            leaderBoardApprovalController
                                                .creator
                                                .value
                                                .profile !=
                                                null
                                            ? CachedNetworkImage(
                                          imageUrl:
                                          "$path${leaderBoardApprovalController.creator.value.profile}",
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
                                                    .creator
                                                    .value
                                                    .fullname !=
                                                    null
                                                    ? leaderBoardApprovalController
                                                    .creator
                                                    .value
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
                                        Visibility(
                                          visible: leaderBoardApprovalController
                                              .creator
                                              .value
                                              .isProfileVerified !=
                                              null
                                              ? leaderBoardApprovalController
                                              .creator
                                              .value
                                              .isProfileVerified ==
                                              1
                                              : false,
                                          child: Positioned(
                                            bottom: 0,
                                            right: -5,
                                            child: CircleAvatar(
                                                child: Image.asset(
                                                  AppIcons
                                                      .verifyProfileIcon2,
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
                                      leaderBoardApprovalController
                                          .creator
                                          .value
                                          .fullname !=
                                          null
                                          ? leaderBoardApprovalController
                                          .creator.value.fullname!
                                          : "",
                                      style: size12_M_bold(
                                          textColor: Colors.black),
                                    ),
                                    Text(
                                      "Mudda Creator",
                                      style: size12_M_normal(
                                        textColor: Colors.blue,
                                      ),
                                    ),
                                    leaderBoardApprovalController.creator.value
                                        .sId !=
                                        null &&
                                        leaderBoardApprovalController
                                            .creator.value.sId !=
                                            AppPreference().getString(
                                                PreferencesKey
                                                    .interactUserId) &&
                                        leaderBoardApprovalController
                                            .creator.value.sId !=
                                            AppPreference().getString(
                                                PreferencesKey.userId)
                                        ? followButton(
                                        context,
                                        leaderBoardApprovalController
                                            .creator.value.sId!,
                                        leaderBoardApprovalController
                                            .creator
                                            .value
                                            .amIFollowing!,
                                        -1,
                                        "favour")
                                        : Container()
                                  ],
                                ),
                              ),
                           if(leaderBoardApprovalController.favourMuddebaaz.length!=0)   Obx(() => InkWell(
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
                                child:  Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        leaderBoardApprovalController
                                            .favourMuddebaaz[0].user!.profile !=
                                            null
                                            ? CachedNetworkImage(
                                          imageUrl:
                                          "$path${leaderBoardApprovalController
                                              .favourMuddebaaz[0].user!.profile}",
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
                                                    width:
                                                    ScreenUtil()
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
                                                      fit: BoxFit
                                                          .cover),
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
                                          decoration:
                                          BoxDecoration(
                                            border: Border.all(
                                              color: darkGray,
                                            ),
                                            shape:
                                            BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                                leaderBoardApprovalController
                                                    .favourMuddebaaz[0].user!.fullname !=
                                                    null
                                                    ? leaderBoardApprovalController
                                                    .favourMuddebaaz[0].user!.fullname![
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
                                          .favourMuddebaaz[0].user!
                                          .fullname !=
                                          null
                                          ? leaderBoardApprovalController
                                          .favourMuddebaaz[0].user!.fullname!
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
                        )
                            : const SizedBox(),
                        const SizedBox(
                          height: 15,
                        ),
                        muddaNewsController.muddaPost.value.isVerify != 1
                            ? Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                "Invite Leadership: ",
                                style: size14_M_bold(
                                    textColor: Colors.black),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                      RouteConstants
                                          .invitedSearchScreen,
                                      arguments: muddaNewsController
                                          .muddaPost.value.sId!)!
                                      .then((value) {
                                    if (value) {
                                      invitedPage = 1;
                                      leaderBoardApprovalController
                                          .invitedLeaderList
                                          .clear();
                                      return callInvitedLeaders(context);
                                    }
                                  });
                                },
                                child: Image.asset(
                                  AppIcons.iconInviteNew,
                                  height: ScreenUtil().setSp(20),
                                  width: ScreenUtil().setSp(20),
                                ),
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Share.share(
                                    '${Const.shareUrl}mudda/${muddaNewsController.muddaPost.value.sId!}',
                                  );
                                },
                                child: SvgPicture.asset(
                                  "assets/svg/share.svg",
                                  height: ScreenUtil().setSp(20),
                                  width: ScreenUtil().setSp(20),
                                ),
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     Share.share(
                              //       '${Const.shareUrl}mudda/${muddaNewsController!.muddaPost.value.sId!}',
                              //     );
                              //   },
                              //   icon: SvgPicture.asset("assets/svg/share.svg"),
                              // ),
                            ],
                          ),
                        )
                            : Container(),
                        const SizedBox(
                          height: 8,
                        ),
                        muddaNewsController.muddaPost.value.isVerify == 1
                            ? const SizedBox()
                            : Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          child:  Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text.rich(
                                          TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: "Minimum",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    color: black,
                                                    fontSize: ScreenUtil()
                                                        .setSp(12))),
                                            TextSpan(
                                                text:
                                                " (${muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "district" ? "11" :muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "state" ? "15" :muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "country" ? "20" : "25"}",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    fontSize: ScreenUtil()
                                                        .setSp(12),
                                                    color: black)),
                                          ])),
                                      muddaNewsController.muddaPost.value.initialScope!.toLowerCase() !=
                                          "district"
                                          ? Text.rich(TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: "From",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    color: black,
                                                    fontSize:
                                                    ScreenUtil()
                                                        .setSp(
                                                        12))),
                                            TextSpan(
                                                text:
                                                "${muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "country" ? "3 states" : muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "state" ? "3 districts" : "5 countries"})",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    fontSize:
                                                    ScreenUtil()
                                                        .setSp(
                                                        12),
                                                    color: black)),
                                          ]))
                                          : Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: "From",
                                            style: GoogleFonts
                                                .nunitoSans(
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                color: black,
                                                fontSize:
                                                ScreenUtil()
                                                    .setSp(
                                                    12))),
                                        TextSpan(
                                            text: " 0 district)",
                                            style: GoogleFonts
                                                .nunitoSans(
                                                fontWeight:
                                                FontWeight
                                                    .w700,
                                                fontSize:
                                                ScreenUtil()
                                                    .setSp(
                                                    12),
                                                color: black))
                                      ])),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                            // "While your Mudda is under review, you will need to form a Mudda Leadership team of",
                                            "While your Mudda is under review, you will need to form a Mudda Leadership team.",
                                            style: size12_M_normal(
                                                textColor: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      radius: 10.w,
                                      titleStyle: const TextStyle(fontSize:14,fontWeight:FontWeight.bold),
                                      title:  "Why do you need to invite Leaders upfront?",
                                      content:Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                                children:const [
                                                  Icon(Icons.circle,size:8),
                                                  Text("To protect you from having singled out",style:TextStyle(fontSize:12))
                                                ]
                                            ),
                                            Row(
                                                children:const [
                                                  Icon(Icons.circle,size:8),
                                                  Text("To make sure that the issue really can be vetted \n by atleast few people.",style:TextStyle(fontSize:12))
                                                ]
                                            ),
                                            Row(
                                                children:const [
                                                  Icon(Icons.circle,size:8),
                                                  Text(" To make sure that there are no rogue Mudda’s",style:TextStyle(fontSize:12))
                                                ]
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(left:42.0,right:42),
                                              child: Divider(thickness: 2,color:Colors.orange),
                                            ),
                                            const Align(
                                                alignment:Alignment.topLeft,
                                                child: Text("How many Leaders you will need?",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold))),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:const [
                                                  Text("District Level",style:TextStyle(fontSize:12)),
                                                  Text("11 members including Creator",style:TextStyle(fontSize:10))
                                                ]
                                            ),
                                            const Divider(color:Colors.black),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:const [
                                                  Text("State Level",style:TextStyle(fontSize:12)),
                                                  Text("15 members from at least 3 districts",style:TextStyle(fontSize:10))
                                                ]
                                            ),
                                            const Divider(color:Colors.black),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:const [
                                                  Text("National Level",style:TextStyle(fontSize:12)),
                                                  Text("20 members from at least 3 States",style:TextStyle(fontSize:10))
                                                ]
                                            ),
                                            const Divider(color:Colors.black),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:const [
                                                  Text("World Level",style:TextStyle(fontSize:12)),
                                                  Text("25 members from at least 5 Countries",style:TextStyle(fontSize:10))
                                                ]
                                            ),
                                          ],
                                        ),
                                      ),

                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Know More ",
                                        style: size12_M_normal(
                                            textColor: buttonBlue),
                                      ),
                                      const Icon(
                                        Icons.help_outline,
                                        color: buttonBlue,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        muddaNewsController.muddaPost.value.isVerify == 1
                            ? const SizedBox()
                            : getSizedBox(h: 20),
                        Obx(() => Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            leaderBoardApprovalController.tabIndex.value ==
                                0
                                ? Obx(
                                  () => GestureDetector(
                                onTap: (){
                                  leaderBoardApprovalController
                                      .isInvitedTab.value = false;
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: leaderBoardApprovalController
                                                  .tabIndex
                                                  .value ==
                                                  0 &&
                                                  leaderBoardApprovalController
                                                      .isInvitedTab
                                                      .value ==
                                                      false
                                                  ? black
                                                  : white,
                                              width: 1))),
                                  child: Text(
                                    "Members",
                                    style: leaderBoardApprovalController
                                        .tabIndex.value ==
                                        0 &&
                                        leaderBoardApprovalController
                                            .isInvitedTab
                                            .value ==
                                            false
                                        ? size14_M_bold(
                                      textColor: Colors.black,
                                    )
                                        : size14_M_normal(
                                      textColor: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            )
                                : const SizedBox(),
                            leaderBoardApprovalController.tabIndex.value ==
                                0
                                ? Obx(
                                  () => GestureDetector(
                                onTap: () {
                                  leaderBoardApprovalController
                                      .isInvitedTab.value = true;
                                  // setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color:
                                              leaderBoardApprovalController
                                                  .isInvitedTab
                                                  .value
                                                  ? black
                                                  : white,
                                              width: 1))),
                                  child: Text(
                                    "Invited (${NumberFormat.compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(muddaNewsController.muddaPost.value.inviteCount ?? 0)})",
                                    style:
                                    /*leaderBoardApprovalController.tabIndex.value == 1 &&*/ leaderBoardApprovalController
                                        .isInvitedTab
                                        .value ==
                                        true
                                        ? size14_M_bold(
                                      textColor:
                                      Colors.black,
                                    )
                                        : size14_M_normal(
                                      textColor:
                                      Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            )
                                : const SizedBox(),
                            if (widget.isFromAdmin == true)
                              if (leaderBoardApprovalController
                                  .creator.value.sId !=
                                  AppPreference().getString(
                                      PreferencesKey.userId) ||
                                  leaderBoardApprovalController
                                      .creator.value.sId !=
                                      AppPreference().getString(
                                          PreferencesKey.orgUserId))
                                InkWell(
                                  onTap: () {
                                    Api.delete.call(
                                      context,
                                      method:
                                      "request-to-user/joined-delete/${muddaNewsController.muddaPost.value.isInvolved!.sId}",
                                      param: {
                                        "_id": muddaNewsController
                                            .muddaPost.value.isInvolved!.sId
                                      },
                                      onResponseSuccess: (object) {
                                        Get.offNamed(
                                            RouteConstants.homeScreen);
                                      },
                                    );
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: grey, width: 0.5),
                                          borderRadius:
                                          BorderRadius.circular(4)),
                                      child: Text(
                                        'Leave Leadership',
                                        style: size12_M_normal(
                                            textColor: blackGray),
                                      )),
                                )
                              else
                                const SizedBox()
                            else
                              const SizedBox(),
                          ],
                        )),
                        getSizedBox(h: 15),
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
                                            if (leaderBoardApprovalController
                                                .isInvitedTab.value) {
                                              leaderBoardApprovalController
                                                  .invitedSearch.value = '';
                                              callInvitedLeaders(context);
                                            } else {
                                              searchText = text;
                                              page = 1;
                                              leaderBoardApprovalController
                                                  .favoursLeaders
                                                  .clear();
                                              Map<String, dynamic> map = {
                                                "page": page.toString(),
                                                "leaderType": "favour",
                                                "search": text,
                                                "_id": muddaNewsController
                                                    .muddaPost.value.sId,
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
                                                          .dataMudda.value =
                                                      result.dataMudda!;
                                                      leaderBoardApprovalController
                                                          .favoursLeaders
                                                          .addAll(result.data!);
                                                    } else {
                                                      page = page > 1
                                                          ? page - 1
                                                          : page;
                                                    }
                                                  });
                                            }
                                          }
                                        },
                                        onFieldSubmitted: (text) {
                                          if (leaderBoardApprovalController
                                              .isInvitedTab.value) {
                                            leaderBoardApprovalController
                                                .invitedSearch.value = text;
                                            callInvitedLeaders(context);
                                          } else {
                                            searchText = text;
                                            page = 1;
                                            leaderBoardApprovalController
                                                .favoursLeaders
                                                .clear();
                                            Map<String, dynamic> map = {
                                              "page": page.toString(),
                                              "leaderType": "favour",
                                              "search": text,
                                              "_id": muddaNewsController
                                                  .muddaPost.value.sId,
                                            };
                                            Api.get.call(context,
                                                method:
                                                "mudda/leaders-in-mudda",
                                                param: map,
                                                isLoading: false,
                                                onResponseSuccess:
                                                    (Map object) {
                                                  setState(() {});
                                                  var result =
                                                  LeadersDataModel.fromJson(
                                                      object);
                                                  if (result.data!.isNotEmpty) {
                                                    path = result.path!;
                                                    leaderBoardApprovalController
                                                        .dataMudda
                                                        .value = result.dataMudda!;
                                                    leaderBoardApprovalController
                                                        .favoursLeaders
                                                        .addAll(result.data!);
                                                  } else {
                                                    page =
                                                    page > 1 ? page - 1 : page;
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
                        getSizedBox(h: 15),
                        if (leaderBoardApprovalController.isInvitedTab.value !=
                            true || widget.isFromAdmin == true)
                          if (leaderBoardApprovalController
                              .creator.value.sId !=
                              AppPreference().getString(
                                  PreferencesKey.userId) ||
                              leaderBoardApprovalController
                                  .creator.value.sId !=
                                  AppPreference().getString(
                                      PreferencesKey.orgUserId))
                            Row(
                              children: [
                                Text(
                                  'Places: ',
                                  style: size12_M_bold(textColor: black),
                                ),
                                if(muddaNewsController
                                    .muddaPost.value.uniquePlaces==null) const Text('') else Text(
                                  muddaNewsController
                                      .muddaPost.value.uniquePlaces!
                                      .join(', '),
                                  // muddaNewsController!.muddaPost.value.country!,
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: ScreenUtil().setSp(12),
                                      color: buttonBlue),
                                ),
                                if(muddaNewsController
                                    .muddaPost.value.initialScope ==
                                    "district" && widget.isFromAdmin==false)    Text(
                                  " (0 places required)",
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(12),
                                      fontStyle: FontStyle.italic,
                                      color: black),
                                ) else
                                  Visibility(
                                    visible: muddaNewsController
                                        .muddaPost.value.initialScope ==
                                        "country"
                                        ? (muddaNewsController
                                        .muddaPost.value.uniqueState! <
                                        3)
                                        : muddaNewsController
                                        .muddaPost.value.initialScope ==
                                        "state"
                                        ? (muddaNewsController
                                        .muddaPost.value.uniqueCity! <
                                        3)
                                        : (muddaNewsController.muddaPost.value
                                        .uniqueCountry! <
                                        5) && widget.isFromAdmin==false,
                                    child: Text(
                                      " (${muddaNewsController.muddaPost.value.initialScope == "country" ? (3 - muddaNewsController.muddaPost.value.uniqueState!) : muddaNewsController.muddaPost.value.initialScope == "state" ? (3 - muddaNewsController.muddaPost.value.uniqueCity!) : (5 - muddaNewsController.muddaPost.value.uniqueCountry!)} more places required)",
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenUtil().setSp(12),
                                          fontStyle: FontStyle.italic,
                                          color: black),
                                    ),
                                  ),
                              ],
                            ),
                        getSizedBox(h: 20),
                        // if (leaderBoardApprovalController.isInvitedTab.value !=
                        //     true)
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         leaderBoardApprovalController.tabIndex.value ==
                        //             0
                        //             ? "Founding Members -"
                        //             : leaderBoardApprovalController
                        //             .tabIndex.value ==
                        //             1
                        //             ? "Members -"
                        //             : "",
                        //         style: size12_M_bold(textColor: black),
                        //       ),
                        //     ],
                        //   ),
                        // getSizedBox(h: 10),
                        Obx(() => Expanded(
                          child: leaderBoardApprovalController
                              .isInvitedTab.value
                              ? Obx(() => RefreshIndicator(
                            onRefresh: () {
                              invitedPage = 1;
                              leaderBoardApprovalController
                                  .invitedLeaderList
                                  .clear();
                              return callInvitedLeaders(context);
                            },
                            child: ListView.builder(
                                physics:
                                const AlwaysScrollableScrollPhysics(),
                                controller: invitedScrollController,
                                itemCount: leaderBoardApprovalController
                                    .invitedLeaderList.length,
                                itemBuilder: (followersContext, index) {
                                  JoinLeader joinLeader =
                                  leaderBoardApprovalController
                                      .invitedLeaderList
                                      .elementAt(index);
                                  return InkWell(
                                    onTap: () {
                                      muddaNewsController
                                          .acceptUserDetail
                                          .value = joinLeader.user!;
                                      if (joinLeader.user!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.userId)) {
                                        Get.toNamed(RouteConstants
                                            .profileScreen);
                                      } else {
                                        Map<String, String>?
                                        parameters = {
                                          "userDetail": jsonEncode(
                                              joinLeader.user!)
                                        };
                                        Get.toNamed(
                                            RouteConstants
                                                .otherUserProfileScreen,
                                            parameters: parameters);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    joinLeader.user!
                                                        .profile !=
                                                        null
                                                        ? CachedNetworkImage(
                                                      imageUrl:
                                                      "${leaderBoardApprovalController.profilePath.value}${joinLeader.user!.profile}",
                                                      imageBuilder:
                                                          (context,
                                                          imageProvider) =>
                                                          Container(
                                                            width: ScreenUtil()
                                                                .setSp(
                                                                40),
                                                            height: ScreenUtil()
                                                                .setSp(
                                                                40),
                                                            decoration:
                                                            BoxDecoration(
                                                              color:
                                                              colorWhite,
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
                                                              ),
                                                              image: DecorationImage(
                                                                  image:
                                                                  imageProvider,
                                                                  fit:
                                                                  BoxFit.cover),
                                                            ),
                                                          ),
                                                      placeholder:
                                                          (context,
                                                          url) =>
                                                          CircleAvatar(
                                                            backgroundColor:
                                                            lightGray,
                                                            radius: ScreenUtil()
                                                                .setSp(
                                                                20),
                                                          ),
                                                      errorWidget: (context,
                                                          url,
                                                          error) =>
                                                          CircleAvatar(
                                                            backgroundColor:
                                                            lightGray,
                                                            radius: ScreenUtil()
                                                                .setSp(
                                                                20),
                                                          ),
                                                    )
                                                        : Container(
                                                      height: ScreenUtil()
                                                          .setSp(
                                                          40),
                                                      width: ScreenUtil()
                                                          .setSp(
                                                          40),
                                                      decoration:
                                                      BoxDecoration(
                                                        border:
                                                        Border
                                                            .all(
                                                          color:
                                                          darkGray,
                                                        ),
                                                        shape: BoxShape
                                                            .circle,
                                                      ),
                                                      child:
                                                      Center(
                                                        child: Text(
                                                            joinLeader
                                                                .user!
                                                                .fullname![0].toUpperCase(),
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: ScreenUtil().setSp(20),
                                                                color: black)),
                                                      ),
                                                    ),
                                                    getSizedBox(w: 8),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text.rich(TextSpan(
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                    text:
                                                                    "${joinLeader.user!.fullname},",
                                                                    style:
                                                                    size12_M_bold(textColor: Colors.black)),
                                                                TextSpan(
                                                                    text:
                                                                    " ${joinLeader.user!.country??''}",
                                                                    style:
                                                                    size12_M_bold(textColor: buttonBlue)),
                                                                TextSpan(
                                                                    text:
                                                                    "  ${convertToAgo(DateTime.parse(joinLeader.createdAt!))}",
                                                                    style:
                                                                    size10_M_regular300(textColor: blackGray)),
                                                              ])),
                                                          getSizedBox(
                                                              h: 2),
                                                          Text(
                                                            joinLeader
                                                                .user!
                                                                .profession ??
                                                                '',
                                                            style: size12_M_normal(
                                                                textColor:
                                                                colorGrey),
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
                                                onResponseSuccess:
                                                    (object) {
                                                  print(
                                                      "Abhishek $object");
                                                  MuddaPost muddaPost =
                                                      muddaNewsController
                                                          .muddaPost
                                                          .value;
                                                  muddaPost
                                                      .inviteCount =
                                                      muddaPost
                                                          .inviteCount! -
                                                          1;
                                                  muddaNewsController
                                                      .muddaPost
                                                      .value =
                                                      MuddaPost();
                                                  muddaNewsController
                                                      .muddaPost
                                                      .value =
                                                      muddaPost;
                                                  leaderBoardApprovalController
                                                      .invitedLeaderList
                                                      .removeAt(index);
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  8.0),
                                              child: Text(
                                                "Cancel",
                                                style: size12_M_normal(
                                                    textColor:
                                                    colorGrey),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ))
                              : leaderBoardApprovalController
                              .favoursLeaders.isEmpty
                              ? const Center(child: Text('No Members Found'))
                              : RefreshIndicator(
                            onRefresh: () {
                              favourPage = 1;
                              leaderBoardApprovalController
                                  .favoursLeaders
                                  .clear();
                              return onFavourCall();
                            },
                                child: ListView.builder(
                                controller: favourScrollController,
                                // physics: const AlwaysScrollableScrollPhysics(),
                                physics:
                                const AlwaysScrollableScrollPhysics(),
                                itemCount: leaderBoardApprovalController
                                    .favoursLeaders.length,
                                itemBuilder: (followersContext, index) {
                                  Leaders leaders =
                                  leaderBoardApprovalController
                                      .favoursLeaders
                                      .elementAt(index);

                                  return InkWell(
                                    onTap: () {
                                      if (leaders.userIdentity == 1) {
                                        if (leaders
                                            .acceptUserDetail!.sId ==
                                            AppPreference().getString(
                                                PreferencesKey.userId)) {
                                          Get.toNamed(RouteConstants
                                              .profileScreen);
                                        } else {
                                          Map<String, String>?
                                          parameters = {
                                            "userDetail": jsonEncode(
                                                leaders.acceptUserDetail!)
                                          };
                                          Get.toNamed(
                                              RouteConstants
                                                  .otherUserProfileScreen,
                                              parameters: parameters);
                                        }
                                      } else {
                                        anynymousDialogBox(context);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    leaders.acceptUserDetail!
                                                        .profile !=
                                                        null
                                                        ? CachedNetworkImage(
                                                      imageUrl:
                                                      "$path${leaders.acceptUserDetail!.profile}",
                                                      imageBuilder:
                                                          (context,
                                                          imageProvider) =>
                                                          Container(
                                                            width: ScreenUtil()
                                                                .setSp(
                                                                40),
                                                            height: ScreenUtil()
                                                                .setSp(
                                                                40),
                                                            decoration:
                                                            BoxDecoration(
                                                              color:
                                                              colorWhite,
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
                                                              ),
                                                              image: DecorationImage(
                                                                  image:
                                                                  imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                      placeholder: (context,
                                                          url) =>
                                                          CircleAvatar(
                                                            backgroundColor:
                                                            lightGray,
                                                            radius: ScreenUtil()
                                                                .setSp(
                                                                20),
                                                          ),
                                                      errorWidget: (context,
                                                          url,
                                                          error) =>
                                                          CircleAvatar(
                                                            backgroundColor:
                                                            lightGray,
                                                            radius: ScreenUtil()
                                                                .setSp(
                                                                20),
                                                          ),
                                                    )
                                                        : Container(
                                                      height:
                                                      ScreenUtil()
                                                          .setSp(
                                                          40),
                                                      width: ScreenUtil()
                                                          .setSp(
                                                          40),
                                                      decoration:
                                                      BoxDecoration(
                                                        border:
                                                        Border
                                                            .all(
                                                          color:
                                                          darkGray,
                                                        ),
                                                        shape: BoxShape
                                                            .circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                            leaders
                                                                .acceptUserDetail!
                                                                .fullname![
                                                            0]
                                                                .toUpperCase(),
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: ScreenUtil().setSp(20),
                                                                color: black)),
                                                      ),
                                                    ),
                                                    getSizedBox(w: 8),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text.rich(TextSpan(
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: leaders.userIdentity == 1
                                                                        ? "${leaders.acceptUserDetail!.fullname!},"
                                                                        : "Anonymous,",
                                                                    style:
                                                                    size12_M_bold(textColor: Colors.black)),
                                                                TextSpan(
                                                                    text: leaders.acceptUserDetail!.country == null
                                                                        ? "-"
                                                                        : leaders
                                                                        .acceptUserDetail!.country!,
                                                                    style:
                                                                    size12_M_bold(textColor: buttonBlue)),
                                                                if (widget
                                                                    .isFromAdmin ==
                                                                    true)
                                                                  TextSpan(
                                                                      text: leaders.muddaRole?.role == null
                                                                          ? ""
                                                                          : ",${leaders.muddaRole?.role}",
                                                                      style:
                                                                      size12_M_bold(textColor: Colors.red)),
                                                              ])),
                                                          getSizedBox(
                                                              h: 2),
                                                          Text(
                                                            leaders.acceptUserDetail!
                                                                .profession ==
                                                                null
                                                                ? "-"
                                                                : "${leaders.acceptUserDetail!.profession}",
                                                            style: size12_M_normal(
                                                                textColor:
                                                                colorGrey),
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
                                          if (widget.isFromAdmin ==
                                              true &&
                                              leaders.acceptUserDetail!
                                                  .sId !=
                                                  AppPreference()
                                                      .getString(
                                                      PreferencesKey
                                                          .userId))
                                            InkWell(
                                              onTap: () {
                                                // TODO: ADD EDIT DIALOG
                                                shoeEditDialog(
                                                    context,
                                                    leaders
                                                        .acceptUserDetail!,
                                                    '${leaders.sId}',
                                                    index);
                                                log('-=-=- fav id -=- ${leaders.sId}');
                                                // Api.delete.call(
                                                //   context,
                                                //   // method: "mudda/remove-joiner/${userDetails['_id']}",
                                                //   method:
                                                //   "mudda/remove-joiner/${userData[index]['_id']}",
                                                //   param: {},
                                                //   onResponseSuccess:
                                                //       (object) {
                                                //     log("favour -=-=- $object");
                                                //     leaderBoardApprovalController
                                                //         .joinLeaderList
                                                //         .removeAt(
                                                //         index);
                                                //     leaderBoardApprovalController
                                                //         .joinLeaderList
                                                //         .refresh();
                                                //     onFavourCall();
                                                //   },
                                                // );
                                              },
                                              child: Container(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: white,
                                                      width: 0.5),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(5),
                                                ),
                                                child: Text(
                                                  "Edit",
                                                  style: size12_M_normal(
                                                      textColor:
                                                      colorGrey),
                                                ),
                                              ),
                                            ),
                                          if (widget.isFromAdmin == false)
                                            InkWell(
                                              onTap: () {
                                                log('-=-=- fav id -=- ${leaders.sId}');
                                                Api.delete.call(
                                                  context,
                                                  // method: "mudda/remove-joiner/${userDetails['_id']}",
                                                  method:
                                                  "mudda/remove-joiner/${leaders.sId}",
                                                  param: {},
                                                  onResponseSuccess:
                                                      (object) {
                                                    log("favour -=-=- $object");
                                                    leaderBoardApprovalController
                                                        .favoursLeaders
                                                        .removeAt(index);
                                                    leaderBoardApprovalController
                                                        .favoursLeaders
                                                        .refresh();
                                                    onFavourCall();
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(
                                                    8.0),
                                                child: Text(
                                                  "Remove",
                                                  style: size12_M_normal(
                                                      textColor:
                                                      colorGrey),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                        )),
                      ],
                    ),

                    //TODO: Opposition Tab
                    Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        muddaNewsController.muddaPost.value.isVerify == 1
                            ? Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (leaderBoardApprovalController
                                      .creator.value.sId ==
                                      AppPreference().getString(
                                          PreferencesKey.userId) ||
                                      leaderBoardApprovalController
                                          .creator.value.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.orgUserId)) {
                                    Get.toNamed(
                                        RouteConstants.profileScreen);
                                  } else if (leaderBoardApprovalController
                                      .creator.value.userType ==
                                      "user") {
                                    Map<String, String>? parameters = {
                                      "userDetail": jsonEncode(
                                          leaderBoardApprovalController
                                              .creator.value)
                                    };
                                    Get.toNamed(
                                        RouteConstants
                                            .otherUserProfileScreen,
                                        parameters: parameters);
                                  } else {
                                    Map<String, String>? parameters = {
                                      "userDetail": jsonEncode(
                                          leaderBoardApprovalController
                                              .creator.value)
                                    };
                                    Get.toNamed(
                                        RouteConstants
                                            .otherOrgProfileScreen,
                                        parameters: parameters);
                                  }
                                },
                                child: Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        leaderBoardApprovalController
                                            .creator
                                            .value
                                            .profile !=
                                            null &&
                                            leaderBoardApprovalController
                                                .creator
                                                .value
                                                .profile !=
                                                null
                                            ? CachedNetworkImage(
                                          imageUrl:
                                          "$path${leaderBoardApprovalController.creator.value.profile}",
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
                                                    .creator
                                                    .value
                                                    .fullname !=
                                                    null
                                                    ? leaderBoardApprovalController
                                                    .creator
                                                    .value
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
                                        Visibility(
                                          visible: leaderBoardApprovalController
                                              .creator
                                              .value
                                              .isProfileVerified !=
                                              null
                                              ? leaderBoardApprovalController
                                              .creator
                                              .value
                                              .isProfileVerified ==
                                              1
                                              : false,
                                          child: Positioned(
                                            bottom: 0,
                                            right: -5,
                                            child: CircleAvatar(
                                                child: Image.asset(
                                                  AppIcons
                                                      .verifyProfileIcon2,
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
                                      leaderBoardApprovalController
                                          .creator
                                          .value
                                          .fullname !=
                                          null
                                          ? leaderBoardApprovalController
                                          .creator.value.fullname!
                                          : "",
                                      style: size12_M_bold(
                                          textColor: Colors.black),
                                    ),
                                    Text(
                                      "Mudda Creator",
                                      style: size12_M_normal(
                                        textColor: Colors.blue,
                                      ),
                                    ),
                                    leaderBoardApprovalController.creator.value
                                        .sId !=
                                        null &&
                                        leaderBoardApprovalController
                                            .creator.value.sId !=
                                            AppPreference().getString(
                                                PreferencesKey
                                                    .interactUserId) &&
                                        leaderBoardApprovalController
                                            .creator.value.sId !=
                                            AppPreference().getString(
                                                PreferencesKey.userId)
                                        ? followButton(
                                        context,
                                        leaderBoardApprovalController
                                            .creator.value.sId!,
                                        leaderBoardApprovalController
                                            .creator
                                            .value
                                            .amIFollowing!,
                                        -1,
                                        "favour")
                                        : Container()
                                  ],
                                ),
                              ),
                            if(leaderBoardApprovalController.oppositionMuddebaaz.length!=0)  Obx(() => InkWell(
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
                                            .oppositionMuddebaaz[0].user!.profile !=
                                            null
                                            ? CachedNetworkImage(
                                          imageUrl:
                                          "$path${leaderBoardApprovalController
                                              .oppositionMuddebaaz[0].user!.profile}",
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
                                                    width:
                                                    ScreenUtil()
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
                                                      fit: BoxFit
                                                          .cover),
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
                                          decoration:
                                          BoxDecoration(
                                            border: Border.all(
                                              color: darkGray,
                                            ),
                                            shape:
                                            BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                                leaderBoardApprovalController
                                                    .oppositionMuddebaaz[0].user!.fullname !=
                                                    null
                                                    ? leaderBoardApprovalController
                                                    .oppositionMuddebaaz[0].user!.fullname![
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
                                          .oppositionMuddebaaz[0].user!
                                          .fullname !=
                                          null
                                          ? leaderBoardApprovalController
                                          .oppositionMuddebaaz[0].user!.fullname!
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
                        )
                            : const SizedBox(),
                        const SizedBox(
                          height: 15,
                        ),
                        muddaNewsController.muddaPost.value.isVerify != 1
                            ? Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                "Invite Leadership: ",
                                style: size14_M_bold(
                                    textColor: Colors.black),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                      RouteConstants
                                          .invitedSearchScreen,
                                      arguments: muddaNewsController
                                          .muddaPost.value.sId!)!
                                      .then((value) {
                                    if (value) {
                                      invitedPage = 1;
                                      leaderBoardApprovalController
                                          .invitedLeaderList
                                          .clear();
                                      return callInvitedLeaders(context);
                                    }
                                  });
                                },
                                child: Image.asset(
                                  AppIcons.iconInviteNew,
                                  height: ScreenUtil().setSp(20),
                                  width: ScreenUtil().setSp(20),
                                ),
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Share.share(
                                    '${Const.shareUrl}mudda/${muddaNewsController.muddaPost.value.sId!}',
                                  );
                                },
                                child: SvgPicture.asset(
                                  "assets/svg/share.svg",
                                  height: ScreenUtil().setSp(20),
                                  width: ScreenUtil().setSp(20),
                                ),
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     Share.share(
                              //       '${Const.shareUrl}mudda/${muddaNewsController!.muddaPost.value.sId!}',
                              //     );
                              //   },
                              //   icon: SvgPicture.asset("assets/svg/share.svg"),
                              // ),
                            ],
                          ),
                        )
                            : Container(),
                        const SizedBox(
                          height: 8,
                        ),
                        muddaNewsController.muddaPost.value.isVerify == 1
                            ? const SizedBox()
                            : Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          child:  Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text.rich(
                                          TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: "Minimum",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    color: black,
                                                    fontSize: ScreenUtil()
                                                        .setSp(12))),
                                            TextSpan(
                                                text:
                                                " (${muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "district" ? "11" :muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "state" ? "15" :muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "country" ? "20" : "25"}",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    fontSize: ScreenUtil()
                                                        .setSp(12),
                                                    color: black)),
                                          ])),
                                      muddaNewsController.muddaPost.value.initialScope!.toLowerCase() !=
                                          "district"
                                          ? Text.rich(TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: "From",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    color: black,
                                                    fontSize:
                                                    ScreenUtil()
                                                        .setSp(
                                                        12))),
                                            TextSpan(
                                                text:
                                                "${muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "country" ? "3 states" : muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "state" ? "3 districts" : "5 countries"})",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    fontSize:
                                                    ScreenUtil()
                                                        .setSp(
                                                        12),
                                                    color: black)),
                                          ]))
                                          : Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: "From",
                                            style: GoogleFonts
                                                .nunitoSans(
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                color: black,
                                                fontSize:
                                                ScreenUtil()
                                                    .setSp(
                                                    12))),
                                        TextSpan(
                                            text: " 0 district)",
                                            style: GoogleFonts
                                                .nunitoSans(
                                                fontWeight:
                                                FontWeight
                                                    .w700,
                                                fontSize:
                                                ScreenUtil()
                                                    .setSp(
                                                    12),
                                                color: black))
                                      ])),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                            // "While your Mudda is under review, you will need to form a Mudda Leadership team of",
                                            "While your Mudda is under review, you will need to form a Mudda Leadership team.",
                                            style: size12_M_normal(
                                                textColor: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      radius: 10.w,
                                      titleStyle: const TextStyle(fontSize:14,fontWeight:FontWeight.bold),
                                      title:  "Why do you need to invite Leaders upfront?",
                                      content:Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                                children:const [
                                                  Icon(Icons.circle,size:8),
                                                  Text("To protect you from having singled out",style:TextStyle(fontSize:12))
                                                ]
                                            ),
                                            Row(
                                                children:const [
                                                  Icon(Icons.circle,size:8),
                                                  Text("To make sure that the issue really can be vetted \n by atleast few people.",style:TextStyle(fontSize:12))
                                                ]
                                            ),
                                            Row(
                                                children:const [
                                                  Icon(Icons.circle,size:8),
                                                  Text(" To make sure that there are no rogue Mudda’s",style:TextStyle(fontSize:12))
                                                ]
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(left:42.0,right:42),
                                              child: Divider(thickness: 2,color:Colors.orange),
                                            ),
                                            const Align(
                                                alignment:Alignment.topLeft,
                                                child: Text("How many Leaders you will need?",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold))),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:const [
                                                  Text("District Level",style:TextStyle(fontSize:12)),
                                                  Text("11 members including Creator",style:TextStyle(fontSize:10))
                                                ]
                                            ),
                                            const Divider(color:Colors.black),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:const [
                                                  Text("State Level",style:TextStyle(fontSize:12)),
                                                  Text("15 members from at least 3 districts",style:TextStyle(fontSize:10))
                                                ]
                                            ),
                                            const Divider(color:Colors.black),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:const [
                                                  Text("National Level",style:TextStyle(fontSize:12)),
                                                  Text("20 members from at least 3 States",style:TextStyle(fontSize:10))
                                                ]
                                            ),
                                            const Divider(color:Colors.black),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:const [
                                                  Text("World Level",style:TextStyle(fontSize:12)),
                                                  Text("25 members from at least 5 Countries",style:TextStyle(fontSize:10))
                                                ]
                                            ),
                                          ],
                                        ),
                                      ),

                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Know More ",
                                        style: size12_M_normal(
                                            textColor: buttonBlue),
                                      ),
                                      const Icon(
                                        Icons.help_outline,
                                        color: buttonBlue,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        muddaNewsController.muddaPost.value.isVerify == 1
                            ? const SizedBox()
                            : getSizedBox(h: 20),
                        Obx(() => Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            leaderBoardApprovalController.tabIndex.value ==
                                1
                                ? Obx(
                                  () => GestureDetector(
                                onTap: (){
                                  leaderBoardApprovalController
                                      .isOppositionInvitedTab
                                      .value =
                                  false;
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: leaderBoardApprovalController
                                                  .tabIndex
                                                  .value ==
                                                  1 &&
                                                  leaderBoardApprovalController
                                                      .isOppositionInvitedTab
                                                      .value ==
                                                      false
                                                  ? black
                                                  : white,
                                              width: 1))),
                                  child: Text(
                                    "Members",
                                    style: leaderBoardApprovalController
                                        .tabIndex.value ==
                                        1 &&
                                        leaderBoardApprovalController
                                            .isOppositionInvitedTab
                                            .value ==
                                            false
                                        ? size14_M_bold(
                                      textColor: Colors.black,
                                    )
                                        : size14_M_normal(
                                      textColor: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            )
                                : const SizedBox(),
                            // leaderBoardApprovalController.tabIndex.value ==
                            //     1
                            //     ? Obx(
                            //       () => GestureDetector(
                            //     onTap: () {
                            //       leaderBoardApprovalController
                            //           .isOppositionInvitedTab.value = true;
                            //       // setState(() {});
                            //     },
                            //     child: Container(
                            //       padding: EdgeInsets.only(bottom: 2),
                            //       decoration: BoxDecoration(
                            //           border: Border(
                            //               bottom: BorderSide(
                            //                   color:
                            //                   leaderBoardApprovalController
                            //                       .isOppositionInvitedTab
                            //                       .value
                            //                       ? black
                            //                       : white,
                            //                   width: 1))),
                            //       child: Text(
                            //         "Invited (${NumberFormat.compactCurrency(
                            //           decimalDigits: 0,
                            //           symbol:
                            //           '', // if you want to add currency symbol then pass that in this else leave it empty.
                            //         ).format(muddaNewsController.muddaPost.value.inviteCount ?? 0)})",
                            //         style:
                            //         leaderBoardApprovalController.tabIndex.value == 1 && leaderBoardApprovalController
                            //             .isOppositionInvitedTab
                            //             .value ==
                            //             true
                            //             ? size14_M_bold(
                            //           textColor:
                            //           Colors.black,
                            //         )
                            //             : size14_M_normal(
                            //           textColor:
                            //           Colors.grey,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // )
                            //     : SizedBox(),
                            if (widget.isFromAdmin == true)
                              if (leaderBoardApprovalController
                                  .creator.value.sId !=
                                  AppPreference().getString(
                                      PreferencesKey.userId) ||
                                  leaderBoardApprovalController
                                      .creator.value.sId !=
                                      AppPreference().getString(
                                          PreferencesKey.orgUserId))
                                InkWell(
                                  onTap: () {
                                    Api.delete.call(
                                      context,
                                      method:
                                      "request-to-user/joined-delete/${muddaNewsController.muddaPost.value.isInvolved!.sId}",
                                      param: {
                                        "_id": muddaNewsController
                                            .muddaPost.value.isInvolved!.sId
                                      },
                                      onResponseSuccess: (object) {
                                        Get.offNamed(
                                            RouteConstants.homeScreen);
                                      },
                                    );
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: grey, width: 0.5),
                                          borderRadius:
                                          BorderRadius.circular(4)),
                                      child: Text(
                                        'Leave Leadership',
                                        style: size12_M_normal(
                                            textColor: blackGray),
                                      )),
                                )
                              else
                                const SizedBox()
                            else
                              const SizedBox(),
                          ],
                        )),
                        getSizedBox(h: 15),
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
                                            if (leaderBoardApprovalController
                                                .isOppositionInvitedTab.value) {
                                              leaderBoardApprovalController
                                                  .invitedSearch.value = '';
                                              callInvitedLeaders(context);
                                            } else {
                                              searchText = text;
                                              page = 1;
                                              leaderBoardApprovalController
                                                  .oppositionLeaders
                                                  .clear();
                                              Map<String, dynamic> map = {
                                                "page": page.toString(),
                                                "leaderType": "opposition",
                                                "search": text,
                                                "_id": muddaNewsController
                                                    .muddaPost.value.sId,
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
                                                          .dataMudda.value =
                                                      result.dataMudda!;
                                                      leaderBoardApprovalController
                                                          .oppositionLeaders
                                                          .addAll(result.data!);
                                                    } else {
                                                      page = page > 1
                                                          ? page - 1
                                                          : page;
                                                    }
                                                  });
                                            }
                                          }
                                        },
                                        onFieldSubmitted: (text) {
                                          if (leaderBoardApprovalController
                                              .isOppositionInvitedTab.value) {
                                            leaderBoardApprovalController
                                                .invitedSearch.value = text;
                                            callInvitedLeaders(context);
                                          } else {
                                            searchText = text;
                                            page = 1;
                                            leaderBoardApprovalController
                                                .oppositionLeaders
                                                .clear();
                                            Map<String, dynamic> map = {
                                              "page": page.toString(),
                                              "leaderType": "opposition",
                                              "search": text,
                                              "_id": muddaNewsController
                                                  .muddaPost.value.sId,
                                            };
                                            Api.get.call(context,
                                                method:
                                                "mudda/leaders-in-mudda",
                                                param: map,
                                                isLoading: false,
                                                onResponseSuccess:
                                                    (Map object) {
                                                  setState(() {});
                                                  var result =
                                                  LeadersDataModel.fromJson(
                                                      object);
                                                  if (result.data!.isNotEmpty) {
                                                    path = result.path!;
                                                    leaderBoardApprovalController
                                                        .dataMudda
                                                        .value = result.dataMudda!;
                                                    leaderBoardApprovalController
                                                        .oppositionLeaders
                                                        .addAll(result.data!);
                                                  } else {
                                                    page =
                                                    page > 1 ? page - 1 : page;
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
                        getSizedBox(h: 15),
                        if (leaderBoardApprovalController
                            .isOppositionInvitedTab.value !=
                            true)
                          Row(
                            children: [
                              Text(
                                'Places: ',
                                style: size12_M_bold(textColor: black),
                              ),
                              if(muddaNewsController
                                  .muddaPost.value.uniquePlaces==null) const Text('') else Text(
                                muddaNewsController
                                    .muddaPost.value.uniquePlaces!
                                    .join(', '),
                                // muddaNewsController!.muddaPost.value.country!,
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: ScreenUtil().setSp(12),
                                    color: buttonBlue),
                              ),
                              Visibility(
                                visible: muddaNewsController
                                    .muddaPost.value.initialScope ==
                                    "district" && widget.isFromAdmin==false,
                                child: Text(
                                  " (0 places required)",
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(12),
                                      fontStyle: FontStyle.italic,
                                      color: black),
                                ),
                              ),
                              if(muddaNewsController
                                  .muddaPost.value.initialScope !=null) Visibility(
                                visible: muddaNewsController
                                    .muddaPost.value.initialScope ==
                                    "country"
                                    ? (muddaNewsController
                                    .muddaPost.value.uniqueState! <
                                    3)
                                    : muddaNewsController
                                    .muddaPost.value.initialScope ==
                                    "state"
                                    ? (muddaNewsController
                                    .muddaPost.value.uniqueCity! <
                                    3)
                                    : (muddaNewsController.muddaPost.value
                                    .uniqueCountry! <
                                    5) && widget.isFromAdmin==false,
                                child: Text(
                                  " (${muddaNewsController.muddaPost.value.initialScope == "country" ? (3 - muddaNewsController.muddaPost.value.uniqueState!) : muddaNewsController.muddaPost.value.initialScope == "state" ? (3 - muddaNewsController.muddaPost.value.uniqueCity!) : (5 - muddaNewsController.muddaPost.value.uniqueCountry!)} more places required)",
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(12),
                                      fontStyle: FontStyle.italic,
                                      color: black),
                                ),
                              ),
                            ],
                          ),
                        getSizedBox(h: 20),
                        // if (leaderBoardApprovalController
                        //     .isOppositionInvitedTab.value !=
                        //     true)
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         leaderBoardApprovalController.tabIndex.value ==
                        //             0
                        //             ? "Founding Members -"
                        //             : leaderBoardApprovalController
                        //             .tabIndex.value ==
                        //             1
                        //             ? "Members -"
                        //             : "",
                        //         style: size12_M_bold(textColor: black),
                        //       ),
                        //     ],
                        //   ),
                        // getSizedBox(h: 10),
                        Obx(()=>Expanded(
                          child: leaderBoardApprovalController
                              .isOppositionInvitedTab.value
                              ? Obx(() => RefreshIndicator(
                            onRefresh: () {
                              invitedPage = 1;
                              leaderBoardApprovalController
                                  .invitedLeaderList
                                  .clear();
                              return callInvitedLeaders(context);
                            },
                            child: ListView.builder(
                                physics:
                                const AlwaysScrollableScrollPhysics(),
                                controller: invitedScrollController,
                                itemCount: leaderBoardApprovalController
                                    .invitedLeaderList.length,
                                itemBuilder: (followersContext, index) {
                                  JoinLeader joinLeader =
                                  leaderBoardApprovalController
                                      .invitedLeaderList
                                      .elementAt(index);
                                  return InkWell(
                                    onTap: () {
                                      muddaNewsController
                                          .acceptUserDetail
                                          .value = joinLeader.user!;
                                      if (joinLeader.user!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.userId)) {
                                        Get.toNamed(RouteConstants
                                            .profileScreen);
                                      } else {
                                        Map<String, String>?
                                        parameters = {
                                          "userDetail": jsonEncode(
                                              joinLeader.user!)
                                        };
                                        Get.toNamed(
                                            RouteConstants
                                                .otherUserProfileScreen,
                                            parameters: parameters);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    joinLeader.user!
                                                        .profile !=
                                                        null
                                                        ? CachedNetworkImage(
                                                      imageUrl:
                                                      "${leaderBoardApprovalController.profilePath.value}${joinLeader.user!.profile}",
                                                      imageBuilder:
                                                          (context,
                                                          imageProvider) =>
                                                          Container(
                                                            width: ScreenUtil()
                                                                .setSp(
                                                                40),
                                                            height: ScreenUtil()
                                                                .setSp(
                                                                40),
                                                            decoration:
                                                            BoxDecoration(
                                                              color:
                                                              colorWhite,
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
                                                              ),
                                                              image: DecorationImage(
                                                                  image:
                                                                  imageProvider,
                                                                  fit:
                                                                  BoxFit.cover),
                                                            ),
                                                          ),
                                                      placeholder:
                                                          (context,
                                                          url) =>
                                                          CircleAvatar(
                                                            backgroundColor:
                                                            lightGray,
                                                            radius: ScreenUtil()
                                                                .setSp(
                                                                20),
                                                          ),
                                                      errorWidget: (context,
                                                          url,
                                                          error) =>
                                                          CircleAvatar(
                                                            backgroundColor:
                                                            lightGray,
                                                            radius: ScreenUtil()
                                                                .setSp(
                                                                20),
                                                          ),
                                                    )
                                                        : Container(
                                                      height: ScreenUtil()
                                                          .setSp(
                                                          40),
                                                      width: ScreenUtil()
                                                          .setSp(
                                                          40),
                                                      decoration:
                                                      BoxDecoration(
                                                        border:
                                                        Border
                                                            .all(
                                                          color:
                                                          darkGray,
                                                        ),
                                                        shape: BoxShape
                                                            .circle,
                                                      ),
                                                      child:
                                                      Center(
                                                        child: Text(
                                                            joinLeader
                                                                .user!
                                                                .fullname![
                                                            0]
                                                                .toUpperCase(),
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: ScreenUtil().setSp(20),
                                                                color: black)),
                                                      ),
                                                    ),
                                                    getSizedBox(w: 8),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text.rich(TextSpan(
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text:
                                                                    joinLeader.user!.fullname ?? '',
                                                                    style:
                                                                    size12_M_bold(textColor: Colors.black)),
                                                                TextSpan(
                                                                    text:
                                                                    " ${joinLeader.user!.country ??''}",
                                                                    style:
                                                                    size12_M_bold(textColor: buttonBlue)),
                                                                if(joinLeader.createdAt != null) TextSpan(
                                                                    text:
                                                                    "  ${convertToAgo(DateTime.parse(joinLeader.createdAt!))}",
                                                                    style: size10_M_regular300(textColor: blackGray)),
                                                              ])),
                                                          getSizedBox(
                                                              h: 2),
                                                          Text(
                                                            joinLeader
                                                                .user!
                                                                .profession ??
                                                                '',
                                                            style: size12_M_normal(
                                                                textColor:
                                                                colorGrey),
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
                                                onResponseSuccess:
                                                    (object) {
                                                  print(
                                                      "Abhishek $object");
                                                  MuddaPost muddaPost =
                                                      muddaNewsController
                                                          .muddaPost
                                                          .value;
                                                  muddaPost
                                                      .inviteCount =
                                                      muddaPost
                                                          .inviteCount! -
                                                          1;
                                                  muddaNewsController
                                                      .muddaPost
                                                      .value =
                                                      MuddaPost();
                                                  muddaNewsController
                                                      .muddaPost
                                                      .value =
                                                      muddaPost;
                                                  leaderBoardApprovalController
                                                      .invitedLeaderList
                                                      .removeAt(index);
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  8.0),
                                              child: Text(
                                                "Cancel",
                                                style: size12_M_normal(
                                                    textColor:
                                                    colorGrey),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ))
                              : leaderBoardApprovalController
                              .oppositionLeaders.isEmpty
                              ? const Center(child: Text('No Members Found'))
                              : RefreshIndicator(
                            onRefresh: () {
                              favourPage = 1;
                              leaderBoardApprovalController
                                  .oppositionLeaders
                                  .clear();
                              return onOppositionCall();
                            },
                                child: ListView.builder(
                                controller: oppositionScrollController,
                                // physics: const AlwaysScrollableScrollPhysics(),
                                physics:
                                const AlwaysScrollableScrollPhysics(),
                                itemCount: leaderBoardApprovalController
                                    .oppositionLeaders.length,
                                itemBuilder: (followersContext, index) {
                                  Leaders leaders =
                                  leaderBoardApprovalController
                                      .oppositionLeaders
                                      .elementAt(index);

                                  return InkWell(
                                    onTap: () {
                                      if (leaders.userIdentity == 1) {
                                        if (leaders
                                            .acceptUserDetail!.sId ==
                                            AppPreference().getString(
                                                PreferencesKey.userId)) {
                                          Get.toNamed(RouteConstants
                                              .profileScreen);
                                        } else {
                                          Map<String, String>?
                                          parameters = {
                                            "userDetail": jsonEncode(
                                                leaders.acceptUserDetail!)
                                          };
                                          Get.toNamed(
                                              RouteConstants
                                                  .otherUserProfileScreen,
                                              parameters: parameters);
                                        }
                                      } else {
                                        anynymousDialogBox(context);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    leaders.acceptUserDetail!
                                                        .profile !=
                                                        null
                                                        ? CachedNetworkImage(
                                                      imageUrl:
                                                      "$path${leaders.acceptUserDetail!.profile}",
                                                      imageBuilder:
                                                          (context,
                                                          imageProvider) =>
                                                          Container(
                                                            width: ScreenUtil()
                                                                .setSp(
                                                                40),
                                                            height: ScreenUtil()
                                                                .setSp(
                                                                40),
                                                            decoration:
                                                            BoxDecoration(
                                                              color:
                                                              colorWhite,
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
                                                              ),
                                                              image: DecorationImage(
                                                                  image:
                                                                  imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                      placeholder: (context,
                                                          url) =>
                                                          CircleAvatar(
                                                            backgroundColor:
                                                            lightGray,
                                                            radius: ScreenUtil()
                                                                .setSp(
                                                                20),
                                                          ),
                                                      errorWidget: (context,
                                                          url,
                                                          error) =>
                                                          CircleAvatar(
                                                            backgroundColor:
                                                            lightGray,
                                                            radius: ScreenUtil()
                                                                .setSp(
                                                                20),
                                                          ),
                                                    )
                                                        : Container(
                                                      height:
                                                      ScreenUtil()
                                                          .setSp(
                                                          40),
                                                      width: ScreenUtil()
                                                          .setSp(
                                                          40),
                                                      decoration:
                                                      BoxDecoration(
                                                        border:
                                                        Border
                                                            .all(
                                                          color:
                                                          darkGray,
                                                        ),
                                                        shape: BoxShape
                                                            .circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                            leaders
                                                                .acceptUserDetail!
                                                                .fullname![
                                                            0]
                                                                .toUpperCase(),
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: ScreenUtil().setSp(20),
                                                                color: black)),
                                                      ),
                                                    ),
                                                    getSizedBox(w: 8),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text.rich(TextSpan(
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: leaders.userIdentity == 1
                                                                        ? "${leaders.acceptUserDetail!.fullname ?? ''},"
                                                                        : "Anonymous,",
                                                                    style:
                                                                    size12_M_bold(textColor: Colors.black)),
                                                                TextSpan(
                                                                    text: leaders.acceptUserDetail!.country == null
                                                                        ? "-"
                                                                        : leaders
                                                                        .acceptUserDetail!.country!,
                                                                    style:
                                                                    size12_M_bold(textColor: buttonBlue)),
                                                                if (widget
                                                                    .isFromAdmin ==
                                                                    true)
                                                                  TextSpan(
                                                                      text: leaders.muddaRole?.role == null
                                                                          ? ""
                                                                          : ",${leaders.muddaRole?.role}",
                                                                      style:
                                                                      size12_M_bold(textColor: Colors.red)),
                                                              ])),
                                                          getSizedBox(
                                                              h: 2),
                                                          Text(
                                                            leaders.acceptUserDetail!
                                                                .profession ==
                                                                null
                                                                ? "-"
                                                                : "${leaders.acceptUserDetail!.profession}",
                                                            style: size12_M_normal(
                                                                textColor:
                                                                colorGrey),
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
                                          // TODO: Role For Opposition
                                          // if (widget.isFromAdmin ==
                                          //     true &&
                                          //     leaders.acceptUserDetail!
                                          //         .sId !=
                                          //         AppPreference()
                                          //             .getString(
                                          //             PreferencesKey
                                          //                 .userId))
                                          //   InkWell(
                                          //     onTap: () {
                                          //       // TODO: ADD EDIT DIALOG
                                          //       shoeEditDialog(
                                          //           context,
                                          //           leaders
                                          //               .acceptUserDetail!,
                                          //           '${leaders.sId}',
                                          //           index);
                                          //       log('-=-=- fav id -=- ${leaders.sId}');
                                          //       // Api.delete.call(
                                          //       //   context,
                                          //       //   // method: "mudda/remove-joiner/${userDetails['_id']}",
                                          //       //   method:
                                          //       //   "mudda/remove-joiner/${userData[index]['_id']}",
                                          //       //   param: {},
                                          //       //   onResponseSuccess:
                                          //       //       (object) {
                                          //       //     log("favour -=-=- $object");
                                          //       //     leaderBoardApprovalController
                                          //       //         .joinLeaderList
                                          //       //         .removeAt(
                                          //       //         index);
                                          //       //     leaderBoardApprovalController
                                          //       //         .joinLeaderList
                                          //       //         .refresh();
                                          //       //     onFavourCall();
                                          //       //   },
                                          //       // );
                                          //     },
                                          //     child: Container(
                                          //       padding:
                                          //       const EdgeInsets.symmetric(
                                          //           horizontal: 8,
                                          //           vertical: 4),
                                          //       decoration: BoxDecoration(
                                          //         border: Border.all(
                                          //             color: white,
                                          //             width: 0.5),
                                          //         borderRadius:
                                          //         BorderRadius
                                          //             .circular(5),
                                          //       ),
                                          //       child: Text(
                                          //         "Edit",
                                          //         style: size12_M_normal(
                                          //             textColor:
                                          //             colorGrey),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // if (widget.isFromAdmin == false)
                                            InkWell(
                                              onTap: () {
                                                log('-=-=- fav id -=- ${leaders.sId}');
                                                Api.delete.call(
                                                  context,
                                                  // method: "mudda/remove-joiner/${userDetails['_id']}",
                                                  method:
                                                  "mudda/remove-joiner/${leaders.sId}",
                                                  param: {},
                                                  onResponseSuccess:
                                                      (object) {
                                                    log("favour -=-=- $object");
                                                    leaderBoardApprovalController
                                                        .oppositionLeaders
                                                        .removeAt(index);
                                                    leaderBoardApprovalController
                                                        .oppositionLeaders
                                                        .refresh();
                                                    onFavourCall();
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(
                                                    8.0),
                                                child: Text(
                                                  "Remove",
                                                  style: size12_M_normal(
                                                      textColor:
                                                      colorGrey),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                        )),
                      ],
                    ),

                    //TODO: Requests Tab
                    leaderBoardApprovalController.requestsList.isEmpty
                        ? const Center(child: Text('No Requests Found')) :RefreshIndicator(
                      onRefresh: () {
                        requestPage = 1;
                        leaderBoardApprovalController.requestsList
                            .clear();
                        return callRequests(context);
                      },
                      child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: leaderBoardApprovalController
                              .requestsList.length,
                          controller: requestScrollController,
                          itemBuilder: (followersContext, index) {
                            JoinLeader joinLeader =
                            leaderBoardApprovalController.requestsList
                                .elementAt(index);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      joinLeader.user!.profile != null
                                          ? CircleAvatar(
                                        radius: 24,
                                        backgroundColor:
                                        Colors.transparent,
                                        backgroundImage: NetworkImage(
                                            "${leaderBoardApprovalController.profilePath.value}${joinLeader.user!.profile}"),
                                      )
                                          : CircleAvatar(
                                          radius: 24,
                                          backgroundColor:
                                          Colors.white,
                                          child: Text(joinLeader.user!.fullname![0],style: size16_M_normal(
                                              textColor:
                                              Colors.black),
                                          )
                                      ),
                                      getSizedBox(w: 8),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${joinLeader.user!.fullname ?? ''}, ${joinLeader.user!.country ?? ''}",
                                              style: size12_M_bold(
                                                  textColor:
                                                  Colors.black),
                                            ),
                                            getSizedBox(h: 2),
                                            Text.rich(TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                      "${NumberFormat.compactCurrency(
                                                        decimalDigits: 0,
                                                        symbol:
                                                        '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                      ).format(0)} Followers, ",
                                                      style: size12_M_bold(
                                                          textColor:
                                                          blackGray)),
                                                  TextSpan(
                                                      text:
                                                      "${joinLeader.user!.city ?? ''}, ${joinLeader.user!.state ?? ''}",
                                                      style: size12_M_regular(
                                                          textColor:
                                                          blackGray)),
                                                ])),
                                          ],
                                        ),
                                      ),
                                      getSizedBox(w: 12),
                                      InkWell(
                                          onTap: () {
                                            Api.delete.call(
                                              context,
                                              method:
                                              "request-to-user/delete/${joinLeader.sId}",
                                              param: {},
                                              onResponseSuccess:
                                                  (object) {
                                                log("-=-=-= Abhishek $object");
                                                leaderBoardApprovalController
                                                    .requestsList
                                                    .removeAt(index);
                                              },
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              "assets/svg/cancel.svg")),
                                      getSizedBox(w: 25),
                                      InkWell(
                                          onTap: () {
                                            log("=-=-=-=-=-= Accept -=-=-=-=-=-");
                                            log("=-=- sId -=- ${joinLeader.sId} -=-=-=-=-=-");
                                            Api.post.call(
                                              context,
                                              method:
                                              "request-to-user/update",
                                              param: {
                                                "_id": joinLeader.sId,
                                                "action": "request",
                                              },
                                              onResponseSuccess:
                                                  (object) {
                                                log("=-=-=-=-=- Abhishek $object");
                                                leaderBoardApprovalController
                                                    .requestsList
                                                    .removeAt(index);
                                              },
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              "assets/svg/approve.svg")),
                                    ],
                                  ),
                                  getSizedBox(h: 5),
                                  Container(
                                    height: 1,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                  controller: leaderBoardApprovalController.controller!,
                ))),
            // Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const SizedBox(
            //         height: 15,
            //       ),
            //       muddaNewsController.muddaPost.value.isVerify != 1 ?    Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20),
            //         child: Row(
            //           children: [
            //             Text(
            //               "Invite Leadership: ",
            //               style: size14_M_bold(textColor: Colors.black),
            //             ),
            //             const Spacer(),
            //             GestureDetector(
            //               onTap: () {
            //                 Get.toNamed(RouteConstants.invitedSearchScreen,
            //                     arguments: muddaNewsController
            //                         .muddaPost.value.sId!)!
            //                     .then((value) {
            //                   if (value) {
            //                     invitedPage = 1;
            //                     leaderBoardApprovalController.invitedLeaderList
            //                         .clear();
            //                     return callInvitedLeaders(context);
            //                   }
            //                 });
            //               },
            //               child: Image.asset(
            //                 AppIcons.iconInviteNew,
            //                 height: ScreenUtil().setSp(20),
            //                 width: ScreenUtil().setSp(20),
            //               ),
            //             ),
            //             const SizedBox(
            //               width: 32,
            //             ),
            //             GestureDetector(
            //               onTap: () {
            //                 Share.share(
            //                   '${Const.shareUrl}mudda/${muddaNewsController.muddaPost.value.sId!}',
            //                 );
            //               },
            //               child: SvgPicture.asset(
            //                 "assets/svg/share.svg",
            //                 height: ScreenUtil().setSp(20),
            //                 width: ScreenUtil().setSp(20),
            //               ),
            //             ),
            //             // IconButton(
            //             //   onPressed: () {
            //             //     Share.share(
            //             //       '${Const.shareUrl}mudda/${muddaNewsController!.muddaPost.value.sId!}',
            //             //     );
            //             //   },
            //             //   icon: SvgPicture.asset("assets/svg/share.svg"),
            //             // ),
            //           ],
            //         ),
            //       ):Container(),
            //       const SizedBox(
            //         height: 8,
            //       ),
            //       muddaNewsController.muddaPost.value.isVerify == 1 ? const SizedBox() : Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20),
            //         child: Stack(
            //           alignment: Alignment.bottomRight,
            //           children: [
            //             Container(
            //               margin: const EdgeInsets.only(bottom: 16),
            //               child: RichText(
            //                 text: TextSpan(
            //                   children: [
            //                     TextSpan(
            //                       text: "(Minimum ",
            //                       style: size12_M_normal(textColor: Colors.black),
            //                     ),
            //                     TextSpan(
            //                       text:
            //                       "${muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "district" ? "11" : muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "state" ? "15" : muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "country" ? "20" : "25"} Members",
            //                       style: size12_M_bold(textColor: Colors.black),
            //                     ),
            //                     TextSpan(
            //                       text: " from ",
            //                       style: size12_M_normal(textColor: Colors.black),
            //                     ),
            //                     TextSpan(
            //                       text:
            //                       "${muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "district" ? "3" : muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "state" ? "3" : muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "country" ? "3" : "5"} ",
            //                       style: size12_M_bold(textColor: Colors.black),
            //                     ),
            //                     TextSpan(
            //                       text:
            //                       "${muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "district" ? "District" : muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "state" ? "State" : muddaNewsController.muddaPost.value.initialScope!.toLowerCase() == "country" ? "Country" : ""}",
            //                       style: size12_M_bold(textColor: Colors.black),
            //                     ),
            //                     TextSpan(
            //                       text:
            //                       // "While your Mudda is under review, you will need to form a Mudda Leadership team of",
            //                       ") While your Mudda is under review, you will need to form a Mudda Leadership team.",
            //                       style: size12_M_normal(textColor: Colors.black),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             Container(
            //               child: TextButton(
            //                 onPressed: () {
            //                   Get.defaultDialog(
            //                     radius: 10.w,
            //                     content: Image.asset(AppIcons.dialogAlert),
            //                     titlePadding: EdgeInsets.only(top: 5.h),
            //                     title: "",
            //                     titleStyle: TextStyle(
            //                       fontSize: 1.sp,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                     contentPadding: EdgeInsets.zero,
            //                   );
            //                 },
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.end,
            //                   children: [
            //                     Text("Know More ", style: size12_M_normal(textColor: buttonBlue),),
            //                     const Icon(Icons.help_outline, color: buttonBlue, size: 18,),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       muddaNewsController.muddaPost.value.isVerify == 1 ? const SizedBox() : getSizedBox(h: 20),
            //       Container(
            //         height: 1,
            //         color: Colors.white,
            //       ),
            //       getSizedBox(h: 10),
            //       // Obx(() => Visibility(
            //       //     visible:
            //       //         leaderBoardApprovalController.tabIndex.value == 0 &&
            //       //             muddaNewsController
            //       //                 .muddaPost.value.uniquePlaces!.isNotEmpty,
            //       //     child: Padding(
            //       //       padding: const EdgeInsets.only(bottom: 10),
            //       //       child: Wrap(
            //       //         children: [
            //       //           Text("Places: ",
            //       //               style: GoogleFonts.nunitoSans(
            //       //                   fontWeight: FontWeight.w700,
            //       //                   fontSize: ScreenUtil().setSp(12),
            //       //                   color: black)),
            //       //           Text(
            //       //               muddaNewsController
            //       //                   .muddaPost.value.uniquePlaces!
            //       //                   .join(', '),
            //       //               style: GoogleFonts.nunitoSans(
            //       //                   fontWeight: FontWeight.w700,
            //       //                   fontSize: ScreenUtil().setSp(12),
            //       //                   color: buttonBlue)),
            //       //           Visibility(
            //       //             visible: muddaNewsController
            //       //                         .muddaPost.value.initialScope ==
            //       //                     "country"
            //       //                 ? (muddaNewsController
            //       //                         .muddaPost.value.uniqueState! <
            //       //                     3)
            //       //                 : muddaNewsController
            //       //                             .muddaPost.value.initialScope ==
            //       //                         "state"
            //       //                     ? (muddaNewsController
            //       //                             .muddaPost.value.uniqueCity! <
            //       //                         3)
            //       //                     : (muddaNewsController
            //       //                             .muddaPost.value.uniqueCountry! <
            //       //                         5),
            //       //             child: Text(
            //       //                 " (${muddaNewsController.muddaPost.value.initialScope == "country" ? (3 - muddaNewsController.muddaPost.value.uniqueState!) : muddaNewsController.muddaPost.value.initialScope == "state" ? (3 - muddaNewsController.muddaPost.value.uniqueCity!) : (5 - muddaNewsController.muddaPost.value.uniqueCountry!)} more places required)",
            //       //                 style: GoogleFonts.nunitoSans(
            //       //                     fontWeight: FontWeight.w400,
            //       //                     fontSize: ScreenUtil().setSp(12),
            //       //                     fontStyle: FontStyle.italic,
            //       //                     color: black)),
            //       //           ),
            //       //         ],
            //       //       ),
            //       //     ))),
            //       /*Obx(() => Visibility(
            //           visible:
            //               leaderBoardApprovalController.tabIndex.value != 0,
            //           child: Text(
            //               leaderBoardApprovalController.tabIndex.value == 1
            //                   ? ""
            //                   : "Join Requests",
            //               style: GoogleFonts.nunitoSans(
            //                   fontWeight: FontWeight.w700,
            //                   fontSize: ScreenUtil().setSp(18),
            //                   color: black)))),*/
            //       Obx(
            //             () => Visibility(
            //           visible:
            //           leaderBoardApprovalController.tabIndex.value != 2,
            //           child: Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 20),
            //             child: AppTextField(
            //                 hintText: "Search",
            //                 suffixIcon:
            //                 Image.asset(AppIcons.searchIcon, scale: 2),
            //                 textInputAction: TextInputAction.search,
            //                 borderColor: grey,
            //                 onFieldSubmitted: (text) {
            //                   if (leaderBoardApprovalController
            //                       .controller!.index ==
            //                       0) {
            //                     leaderBoardApprovalController.search.value =
            //                     text!;
            //                     page = 1;
            //                     leaderBoardApprovalController.joinLeaderList
            //                         .clear();
            //                     callJoinLeaders(context);
            //                   } else if (leaderBoardApprovalController
            //                       .controller!.index ==
            //                       1) {
            //                     leaderBoardApprovalController
            //                         .invitedSearch.value = text!;
            //                     invitedPage = 1;
            //                     leaderBoardApprovalController.invitedLeaderList
            //                         .clear();
            //                     callInvitedLeaders(context);
            //                   } else {
            //                     requestPage = 1;
            //                     leaderBoardApprovalController.requestsList
            //                         .clear();
            //                     callRequests(context);
            //                   }
            //                 },
            //                 onChange: (text) {
            //                   if (text.isEmpty) {
            //                     if (leaderBoardApprovalController
            //                         .controller!.index ==
            //                         0) {
            //                       leaderBoardApprovalController.search.value =
            //                       "";
            //                       page = 1;
            //                       leaderBoardApprovalController.joinLeaderList
            //                           .clear();
            //                       callJoinLeaders(context);
            //                     } else if (leaderBoardApprovalController
            //                         .controller!.index ==
            //                         1) {
            //                       leaderBoardApprovalController
            //                           .invitedSearch.value = "";
            //                       invitedPage = 1;
            //                       leaderBoardApprovalController
            //                           .invitedLeaderList
            //                           .clear();
            //                       callInvitedLeaders(context);
            //                     } else {
            //                       requestPage = 1;
            //                       leaderBoardApprovalController.requestsList
            //                           .clear();
            //                       callRequests(context);
            //                     }
            //                   }
            //                 }),
            //           ),
            //         ),
            //       ),
            //       Row(
            //         children: [
            //           Text(
            //             'Places: ',
            //             style: size12_M_bold(textColor: black),
            //           ),
            //           Text(
            //             muddaNewsController.muddaPost.value.uniquePlaces!
            //                 .join(', '),
            //             // muddaNewsController!.muddaPost.value.country!,
            //             style: GoogleFonts.nunitoSans(
            //                 fontWeight: FontWeight.w700,
            //                 fontSize: ScreenUtil().setSp(12),
            //                 color: buttonBlue),
            //           ),
            //           Visibility(
            //             visible:
            //             muddaNewsController.muddaPost.value.initialScope ==
            //                 "country"
            //                 ? (muddaNewsController
            //                 .muddaPost.value.uniqueState! <
            //                 3)
            //                 : muddaNewsController
            //                 .muddaPost.value.initialScope ==
            //                 "state"
            //                 ? (muddaNewsController
            //                 .muddaPost.value.uniqueCity! <
            //                 3)
            //                 : (muddaNewsController
            //                 .muddaPost.value.uniqueCountry! <
            //                 5),
            //             child: Text(
            //               " (${muddaNewsController.muddaPost.value.initialScope == "country" ? (3 - muddaNewsController.muddaPost.value.uniqueState!) : muddaNewsController.muddaPost.value.initialScope == "state" ? (3 - muddaNewsController.muddaPost.value.uniqueCity!) : (5 - muddaNewsController.muddaPost.value.uniqueCountry!)} more places required)",
            //               style: GoogleFonts.nunitoSans(
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: ScreenUtil().setSp(12),
            //                   fontStyle: FontStyle.italic,
            //                   color: black),
            //             ),
            //           ),
            //         ],
            //       ),
            //       getSizedBox(h: 10),
            //
            //       getSizedBox(h: 20),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             leaderBoardApprovalController.tabIndex.value == 0
            //                 ? "Founding Members"
            //                 : leaderBoardApprovalController.tabIndex.value == 1
            //                 ? "Members"
            //                 : "",
            //             style: size12_M_bold(textColor: black),
            //           ),
            //           leaderBoardApprovalController.tabIndex.value == 0
            //               ? Obx(
            //                 () => GestureDetector(
            //               onTap: () {
            //                 leaderBoardApprovalController
            //                     .isInvitedTab.value =
            //                 !leaderBoardApprovalController
            //                     .isInvitedTab.value;
            //                 // setState(() {});
            //               },
            //               child: Text(
            //                 "Invited (${NumberFormat.compactCurrency(
            //                   decimalDigits: 0,
            //                   symbol:
            //                   '', // if you want to add currency symbol then pass that in this else leave it empty.
            //                 ).format(muddaNewsController.muddaPost.value.inviteCount ?? 0)})",
            //                 style:
            //                 /*leaderBoardApprovalController.tabIndex.value == 1 &&*/ leaderBoardApprovalController
            //                     .isInvitedTab.value ==
            //                     true
            //                     ? size14_M_bold(
            //                   textColor: Colors.black,
            //                 )
            //                     : size14_M_normal(
            //                   textColor: Colors.grey,
            //                 ),
            //               ),
            //             ),
            //           )
            //               : SizedBox(),
            //         ],
            //       ),
            //       getSizedBox(h: 10),
            //       Expanded(
            //         child: Obx(
            //               () => TabBarView(
            //             physics: const NeverScrollableScrollPhysics(),
            //             children: [
            //               leaderBoardApprovalController.isInvitedTab.value
            //                   ? RefreshIndicator(
            //                       onRefresh: () {
            //                       invitedPage = 1;
            //                       leaderBoardApprovalController
            //                       .invitedLeaderList
            //                       .clear();
            //                       return callInvitedLeaders(context);
            //                       },
            //                     child: ListView.builder(
            //                     physics:
            //                     const AlwaysScrollableScrollPhysics(),
            //                     controller: invitedScrollController,
            //                     itemCount: leaderBoardApprovalController
            //                         .invitedLeaderList.length,
            //                     itemBuilder: (followersContext, index) {
            //                       JoinLeader joinLeader =
            //                       leaderBoardApprovalController
            //                           .invitedLeaderList
            //                           .elementAt(index);
            //                       return InkWell(
            //                         onTap: () {
            //                           muddaNewsController
            //                               .acceptUserDetail
            //                               .value = joinLeader.user!;
            //                           if (joinLeader.user!.sId ==
            //                               AppPreference().getString(
            //                                   PreferencesKey.userId)) {
            //                             Get.toNamed(
            //                                 RouteConstants.profileScreen);
            //                           } else {
            //                             Map<String, String>? parameters =
            //                             {
            //                               "userDetail":
            //                               jsonEncode(joinLeader.user!)
            //                             };
            //                             Get.toNamed(
            //                                 RouteConstants
            //                                     .otherUserProfileScreen,
            //                                 parameters: parameters);
            //                           }
            //                         },
            //                         child: Padding(
            //                           padding: const EdgeInsets.only(
            //                               bottom: 10),
            //                           child: Row(
            //                             children: [
            //                               Expanded(
            //                                 child: Column(
            //                                   children: [
            //                                     Row(
            //                                       children: [
            //                                         joinLeader.user!
            //                                             .profile !=
            //                                             null
            //                                             ? CachedNetworkImage(
            //                                           imageUrl:
            //                                           "${leaderBoardApprovalController.profilePath.value}${joinLeader.user!.profile}",
            //                                           imageBuilder:
            //                                               (context,
            //                                               imageProvider) =>
            //                                               Container(
            //                                                 width: ScreenUtil()
            //                                                     .setSp(
            //                                                     40),
            //                                                 height: ScreenUtil()
            //                                                     .setSp(
            //                                                     40),
            //                                                 decoration:
            //                                                 BoxDecoration(
            //                                                   color:
            //                                                   colorWhite,
            //                                                   borderRadius:
            //                                                   BorderRadius.all(
            //                                                       Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
            //                                                   ),
            //                                                   image: DecorationImage(
            //                                                       image:
            //                                                       imageProvider,
            //                                                       fit: BoxFit
            //                                                           .cover),
            //                                                 ),
            //                                               ),
            //                                           placeholder: (context,
            //                                               url) =>
            //                                               CircleAvatar(
            //                                                 backgroundColor:
            //                                                 lightGray,
            //                                                 radius: ScreenUtil()
            //                                                     .setSp(
            //                                                     20),
            //                                               ),
            //                                           errorWidget: (context,
            //                                               url,
            //                                               error) =>
            //                                               CircleAvatar(
            //                                                 backgroundColor:
            //                                                 lightGray,
            //                                                 radius: ScreenUtil()
            //                                                     .setSp(
            //                                                     20),
            //                                               ),
            //                                         )
            //                                             : Container(
            //                                           height:
            //                                           ScreenUtil()
            //                                               .setSp(
            //                                               40),
            //                                           width: ScreenUtil()
            //                                               .setSp(
            //                                               40),
            //                                           decoration:
            //                                           BoxDecoration(
            //                                             border:
            //                                             Border
            //                                                 .all(
            //                                               color:
            //                                               darkGray,
            //                                             ),
            //                                             shape: BoxShape
            //                                                 .circle,
            //                                           ),
            //                                           child: Center(
            //                                             child: Text(
            //                                                 joinLeader
            //                                                     .user!
            //                                                     .fullname![
            //                                                 0]
            //                                                     .toUpperCase(),
            //                                                 style: GoogleFonts.nunitoSans(
            //                                                     fontWeight:
            //                                                     FontWeight.w400,
            //                                                     fontSize: ScreenUtil().setSp(20),
            //                                                     color: black)),
            //                                           ),
            //                                         ),
            //                                         getSizedBox(w: 8),
            //                                         Expanded(
            //                                           child: Column(
            //                                             mainAxisAlignment:
            //                                             MainAxisAlignment
            //                                                 .start,
            //                                             crossAxisAlignment:
            //                                             CrossAxisAlignment
            //                                                 .start,
            //                                             children: [
            //                                               Text.rich(TextSpan(
            //                                                   children: <
            //                                                       TextSpan>[
            //                                                     TextSpan(
            //                                                         text:
            //                                                         "${joinLeader.user!.fullname},",
            //                                                         style:
            //                                                         size12_M_bold(textColor: Colors.black)),
            //                                                     TextSpan(
            //                                                         text:
            //                                                         " ${joinLeader.user!.country}",
            //                                                         style:
            //                                                         size12_M_bold(textColor: buttonBlue)),
            //                                                     TextSpan(
            //                                                         text:
            //                                                         "  ${convertToAgo(DateTime.parse(joinLeader.createdAt!))}",
            //                                                         style:
            //                                                         size10_M_regular300(textColor: blackGray)),
            //                                                   ])),
            //                                               getSizedBox(
            //                                                   h: 2),
            //                                               Text(
            //                                                 joinLeader
            //                                                     .user!
            //                                                     .profession ??
            //                                                     '',
            //                                                 style: size12_M_normal(
            //                                                     textColor:
            //                                                     colorGrey),
            //                                               )
            //                                             ],
            //                                           ),
            //                                         )
            //                                       ],
            //                                     ),
            //                                     getSizedBox(h: 5),
            //                                     Container(
            //                                       height: 1,
            //                                       color: Colors.white,
            //                                     )
            //                                   ],
            //                                 ),
            //                               ),
            //                               InkWell(
            //                                 onTap: () {
            //                                   Api.delete.call(
            //                                     context,
            //                                     method:
            //                                     "request-to-user/delete/${joinLeader.sId}",
            //                                     param: {},
            //                                     onResponseSuccess:
            //                                         (object) {
            //                                       print(
            //                                           "Abhishek $object");
            //                                       MuddaPost muddaPost =
            //                                           muddaNewsController
            //                                               .muddaPost
            //                                               .value;
            //                                       muddaPost.inviteCount =
            //                                           muddaPost
            //                                               .inviteCount! -
            //                                               1;
            //                                       muddaNewsController
            //                                           .muddaPost
            //                                           .value =
            //                                           MuddaPost();
            //                                       muddaNewsController
            //                                           .muddaPost
            //                                           .value = muddaPost;
            //                                       leaderBoardApprovalController
            //                                           .invitedLeaderList
            //                                           .removeAt(index);
            //                                     },
            //                                   );
            //                                 },
            //                                 child: Padding(
            //                                   padding:
            //                                   const EdgeInsets.all(
            //                                       8.0),
            //                                   child: Text(
            //                                     "Cancel",
            //                                     style: size12_M_normal(
            //                                         textColor: colorGrey),
            //                                   ),
            //                                 ),
            //                               )
            //                             ],
            //                           ),
            //                         ),
            //                       );
            //                     }),
            //               )
            //                   : userData == null
            //                   ? const Center(child: Text('No Favour'))
            //                   : Column(
            //                 children: [
            //                   Row(
            //                     children: [
            //                       Expanded(
            //                         child: Column(
            //                           children: [
            //                             Row(
            //                               children: [
            //                                 dataMudda['creator'] !=
            //                                     null
            //                                     ? CachedNetworkImage(
            //                                   imageUrl:
            //                                   "${leaderBoardApprovalController.profilePath.value}${dataMudda['creator']['userDetail']['profile']}",
            //                                   imageBuilder:
            //                                       (context,
            //                                       imageProvider) =>
            //                                       Container(
            //                                         width:
            //                                         ScreenUtil()
            //                                             .setSp(
            //                                             40),
            //                                         height:
            //                                         ScreenUtil()
            //                                             .setSp(
            //                                             40),
            //                                         decoration:
            //                                         BoxDecoration(
            //                                           color:
            //                                           colorWhite,
            //                                           borderRadius:
            //                                           BorderRadius.all(
            //                                               Radius.circular(
            //                                                   ScreenUtil().setSp(20)) //                 <--- border radius here
            //                                           ),
            //                                           image: DecorationImage(
            //                                               image:
            //                                               imageProvider,
            //                                               fit: BoxFit
            //                                                   .cover),
            //                                         ),
            //                                       ),
            //                                   placeholder: (context,
            //                                       url) =>
            //                                       CircleAvatar(
            //                                         backgroundColor:
            //                                         lightGray,
            //                                         radius:
            //                                         ScreenUtil()
            //                                             .setSp(
            //                                             20),
            //                                       ),
            //                                   errorWidget: (context,
            //                                       url,
            //                                       error) =>
            //                                       CircleAvatar(
            //                                         backgroundColor:
            //                                         lightGray,
            //                                         radius:
            //                                         ScreenUtil()
            //                                             .setSp(
            //                                             20),
            //                                       ),
            //                                 )
            //                                     : Container(
            //                                   height:
            //                                   ScreenUtil()
            //                                       .setSp(
            //                                       40),
            //                                   width:
            //                                   ScreenUtil()
            //                                       .setSp(
            //                                       40),
            //                                   decoration:
            //                                   BoxDecoration(
            //                                     border:
            //                                     Border.all(
            //                                       color:
            //                                       darkGray,
            //                                     ),
            //                                     shape: BoxShape
            //                                         .circle,
            //                                   ),
            //                                   child: Center(
            //                                     child: Text(
            //                                         dataMudda['creator']['userDetail']['fullname']
            //                                         [0]
            //                                             .toUpperCase(),
            //                                         style: GoogleFonts.nunitoSans(
            //                                             fontWeight:
            //                                             FontWeight
            //                                                 .w400,
            //                                             fontSize:
            //                                             ScreenUtil().setSp(
            //                                                 20),
            //                                             color:
            //                                             black)),
            //                                   ),
            //                                 ),
            //                                 getSizedBox(w: 8),
            //                                 Expanded(
            //                                   child: Column(
            //                                     mainAxisAlignment:
            //                                     MainAxisAlignment
            //                                         .start,
            //                                     crossAxisAlignment:
            //                                     CrossAxisAlignment
            //                                         .start,
            //                                     children: [
            //                                       Text.rich(TextSpan(
            //                                           children: <
            //                                               TextSpan>[
            //                                             TextSpan(
            //                                                 text: dataMudda['creator']['userDetail']['fullname'] ==
            //                                                     null
            //                                                     ? "-"
            //                                                     : "${dataMudda['creator']['userDetail']['fullname']},",
            //                                                 style: size12_M_bold(
            //                                                     textColor:
            //                                                     Colors.black)),
            //                                             TextSpan(
            //                                                 text: dataMudda['creator']['userDetail']['country'] ==
            //                                                     null
            //                                                     ? "-"
            //                                                     : " ${dataMudda['creator']['userDetail']['country']}",
            //                                                 style: size12_M_bold(
            //                                                     textColor:
            //                                                     buttonBlue)),
            //                                           ])),
            //                                       getSizedBox(h: 2),
            //                                       Text(
            //                                         dataMudda['creator']
            //                                         [
            //                                         'userDetail']
            //                                         [
            //                                         'profession'] ==
            //                                             null
            //                                             ? "-"
            //                                             : "${dataMudda['creator']['userDetail']['profession']}",
            //                                         style: size12_M_normal(
            //                                             textColor:
            //                                             colorGrey),
            //                                       )
            //                                     ],
            //                                   ),
            //                                 )
            //                               ],
            //                             ),
            //                             getSizedBox(h: 5),
            //                             Container(
            //                               height: 1,
            //                               color: Colors.white,
            //                             ),
            //                             getSizedBox(h: 8),
            //                           ],
            //                         ),
            //                       ),
            //                       Container(
            //                         margin: const EdgeInsets.only(
            //                             right: 8),
            //                         child: Text(
            //                           'Mudda Creator',
            //                           style: size12_M_bold(
            //                               textColor: color0060FF),
            //                         ),
            //                       ),
            //                       /*InkWell(
            //                                 onTap: () {
            //                                   Api.delete.call(
            //                                     context,
            //                                     method:
            //                                     "mudda/remove-joiner/${userDetails['sId']}",
            //                                     param: {},
            //                                     onResponseSuccess:
            //                                         (object) {
            //                                       print(
            //                                           "Abhishek $object");
            //                                       leaderBoardApprovalController
            //                                           .joinLeaderList
            //                                           .removeAt(index);
            //                                     },
            //                                   );
            //                                 },
            //                                 child: Padding(
            //                                   padding:
            //                                   const EdgeInsets.all(
            //                                       8.0),
            //                                   child: Text(
            //                                     "Remove",
            //                                     style: size12_M_normal(
            //                                         textColor: colorGrey),
            //                                   ),
            //                                 ),
            //                               )*/
            //                     ],
            //                   ),
            //                   Expanded(
            //                     child: ListView.builder(
            //                         controller:
            //                         favourScrollController,
            //                         // physics: const AlwaysScrollableScrollPhysics(),
            //                         physics:
            //                         const AlwaysScrollableScrollPhysics(),
            //                         itemCount: userData.length,
            //                         itemBuilder:
            //                             (followersContext, index) {
            //                           var userDetails =
            //                           userData[index]['user'];
            //                           var role =userData[index];
            //                           return InkWell(
            //                             onTap: () {
            //                               if (userDetails['_id'] ==
            //                                   AppPreference()
            //                                       .getString(
            //                                       PreferencesKey
            //                                           .userId)) {
            //                                 Get.toNamed(RouteConstants
            //                                     .profileScreen);
            //                               } else {
            //                                 Map<String, String>?
            //                                 parameters = {
            //                                   "userDetail":
            //                                   jsonEncode(userDetails)
            //                                 };
            //                                 Get.toNamed(
            //                                     RouteConstants
            //                                         .otherUserProfileScreen,
            //                                     parameters:
            //                                     parameters);
            //                               }
            //                             },
            //                             child: Padding(
            //                               padding:
            //                               const EdgeInsets.only(
            //                                   bottom: 10),
            //                               child: Row(
            //                                 children: [
            //                                   Expanded(
            //                                     child: Column(
            //                                       children: [
            //                                         Row(
            //                                           children: [
            //                                             userDetails['profile'] !=
            //                                                 null
            //                                                 ? CachedNetworkImage(
            //                                               imageUrl:
            //                                               "${leaderBoardApprovalController.profilePath.value}${userDetails['profile']}",
            //                                               imageBuilder: (context, imageProvider) =>
            //                                                   Container(
            //                                                     width:
            //                                                     ScreenUtil().setSp(40),
            //                                                     height:
            //                                                     ScreenUtil().setSp(40),
            //                                                     decoration:
            //                                                     BoxDecoration(
            //                                                       color: colorWhite,
            //                                                       borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
            //                                                       ),
            //                                                       image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            //                                                     ),
            //                                                   ),
            //                                               placeholder: (context, url) =>
            //                                                   CircleAvatar(
            //                                                     backgroundColor:
            //                                                     lightGray,
            //                                                     radius:
            //                                                     ScreenUtil().setSp(20),
            //                                                   ),
            //                                               errorWidget: (context, url, error) =>
            //                                                   CircleAvatar(
            //                                                     backgroundColor:
            //                                                     lightGray,
            //                                                     radius:
            //                                                     ScreenUtil().setSp(20),
            //                                                   ),
            //                                             )
            //                                                 : Container(
            //                                               height:
            //                                               ScreenUtil().setSp(40),
            //                                               width:
            //                                               ScreenUtil().setSp(40),
            //                                               decoration:
            //                                               BoxDecoration(
            //                                                 border:
            //                                                 Border.all(
            //                                                   color: darkGray,
            //                                                 ),
            //                                                 shape:
            //                                                 BoxShape.circle,
            //                                               ),
            //                                               child:
            //                                               Center(
            //                                                 child:
            //                                                 Text(userDetails['fullname'][0].toUpperCase(), style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w400, fontSize: ScreenUtil().setSp(20), color: black)),
            //                                               ),
            //                                             ),
            //                                             getSizedBox(
            //                                                 w: 8),
            //                                             Expanded(
            //                                               child:
            //                                               Column(
            //                                                 mainAxisAlignment:
            //                                                 MainAxisAlignment
            //                                                     .start,
            //                                                 crossAxisAlignment:
            //                                                 CrossAxisAlignment
            //                                                     .start,
            //                                                 children: [
            //                                                   Text.rich(TextSpan(
            //                                                       children: <TextSpan>[
            //                                                         TextSpan(text: userDetails['fullname'] == null ? "-" : "${userDetails['fullname']},", style: size12_M_bold(textColor: Colors.black)),
            //                                                         TextSpan(text: userDetails['country'] == null ? "-" : " ${userDetails['country']}", style: size12_M_bold(textColor: buttonBlue)),
            //                                                         if(widget.isFromAdmin==true)  TextSpan(text: role['muddaRole'] == null ? "" : ",${role['muddaRole']['role']}", style: size12_M_bold(textColor: Colors.red)),
            //                                                       ])),
            //                                                   getSizedBox(
            //                                                       h: 2),
            //                                                   Text(
            //                                                     userDetails['profession'] == null
            //                                                         ? "-"
            //                                                         : "${userDetails['profession']}",
            //                                                     style:
            //                                                     size12_M_normal(textColor: colorGrey),
            //                                                   )
            //                                                 ],
            //                                               ),
            //                                             )
            //                                           ],
            //                                         ),
            //                                         getSizedBox(h: 5),
            //                                         Container(
            //                                           height: 1,
            //                                           color: Colors
            //                                               .white,
            //                                         )
            //                                       ],
            //                                     ),
            //                                   ),
            //                                   if(widget.isFromAdmin==true &&userDetails['_id'] !=
            //                                       AppPreference()
            //                                           .getString(
            //                                           PreferencesKey
            //                                               .userId)) InkWell(
            //                                     onTap: () {
            //                                       // TODO: ADD EDIT DIALOG
            //                                       shoeEditDialog(context,userData[index]['user'],'${role['_id']}',index);
            //                                       log('-=-=- fav id -=- ${role['_id']}');
            //                                       // Api.delete.call(
            //                                       //   context,
            //                                       //   // method: "mudda/remove-joiner/${userDetails['_id']}",
            //                                       //   method:
            //                                       //   "mudda/remove-joiner/${userData[index]['_id']}",
            //                                       //   param: {},
            //                                       //   onResponseSuccess:
            //                                       //       (object) {
            //                                       //     log("favour -=-=- $object");
            //                                       //     leaderBoardApprovalController
            //                                       //         .joinLeaderList
            //                                       //         .removeAt(
            //                                       //         index);
            //                                       //     leaderBoardApprovalController
            //                                       //         .joinLeaderList
            //                                       //         .refresh();
            //                                       //     onFavourCall();
            //                                       //   },
            //                                       // );
            //                                     },
            //                                     child: Container(
            //                                       padding:EdgeInsets.symmetric(horizontal: 8,vertical: 4),
            //                                       decoration: BoxDecoration(
            //                                         border: Border.all(color: white,width: 0.5),
            //                                         borderRadius: BorderRadius.circular(5),
            //                                       ),
            //                                       child: Text(
            //                                         "Edit",
            //                                         style: size12_M_normal(
            //                                             textColor:
            //                                             colorGrey),
            //                                       ),
            //                                     ),
            //                                   ),
            //                                   if(widget.isFromAdmin==false) InkWell(
            //                                     onTap: () {
            //                                       log('-=-=- fav id -=- ${userData[index]['_id']}');
            //                                       Api.delete.call(
            //                                         context,
            //                                         // method: "mudda/remove-joiner/${userDetails['_id']}",
            //                                         method:
            //                                         "mudda/remove-joiner/${userData[index]['_id']}",
            //                                         param: {},
            //                                         onResponseSuccess:
            //                                             (object) {
            //                                           log("favour -=-=- $object");
            //                                           leaderBoardApprovalController
            //                                               .joinLeaderList
            //                                               .removeAt(
            //                                               index);
            //                                           leaderBoardApprovalController
            //                                               .joinLeaderList
            //                                               .refresh();
            //                                           onFavourCall();
            //                                         },
            //                                       );
            //                                     },
            //                                     child: Padding(
            //                                       padding:
            //                                       const EdgeInsets
            //                                           .all(8.0),
            //                                       child: Text(
            //                                         "Remove",
            //                                         style: size12_M_normal(
            //                                             textColor:
            //                                             colorGrey),
            //                                       ),
            //                                     ),
            //                                   )
            //                                 ],
            //                               ),
            //                             ),
            //                           );
            //                         }),
            //                   ),
            //                 ],
            //               ),
            //               /* RefreshIndicator(
            //                 onRefresh: () {
            //                   page = 1;
            //                   leaderBoardApprovalController.joinLeaderList
            //                       .clear();
            //                   return callJoinLeaders(context);
            //                 },
            //                 child: ListView.builder(
            //                     controller: scrollController,
            //                     physics: const AlwaysScrollableScrollPhysics(),
            //                     itemCount: leaderBoardApprovalController
            //                         .joinLeaderList.length,
            //                     itemBuilder: (followersContext, index) {
            //                       JoinLeader joinLeader =
            //                           leaderBoardApprovalController
            //                               .joinLeaderList
            //                               .elementAt(index);
            //                       return InkWell(
            //                         onTap: () {
            //                           muddaNewsController!.acceptUserDetail
            //                               .value = joinLeader.user!;
            //                           if (joinLeader.user!.sId ==
            //                               AppPreference().getString(
            //                                   PreferencesKey.userId)) {
            //                             Get.toNamed(
            //                                 RouteConstants.profileScreen);
            //                           } else {
            //                             Map<String, String>? parameters = {
            //                               "userDetail":
            //                                   jsonEncode(joinLeader.user!)
            //                             };
            //                             Get.toNamed(
            //                                 RouteConstants
            //                                     .otherUserProfileScreen,
            //                                 parameters: parameters);
            //                           }
            //                         },
            //                         child: Padding(
            //                           padding: const EdgeInsets.only(bottom: 10),
            //                           child: Row(
            //                             children: [
            //                               Expanded(
            //                                 child: Column(
            //                                   children: [
            //                                     Row(
            //                                       children: [
            //                                         joinLeader.user!.profile !=
            //                                                 null
            //                                             ? CachedNetworkImage(
            //                                                 imageUrl:
            //                                                     "${leaderBoardApprovalController.profilePath.value}${joinLeader.user!.profile}",
            //                                                 imageBuilder: (context,
            //                                                         imageProvider) =>
            //                                                     Container(
            //                                                   width:
            //                                                       ScreenUtil()
            //                                                           .setSp(
            //                                                               40),
            //                                                   height:
            //                                                       ScreenUtil()
            //                                                           .setSp(
            //                                                               40),
            //                                                   decoration:
            //                                                       BoxDecoration(
            //                                                     color:
            //                                                         colorWhite,
            //                                                     borderRadius: BorderRadius.all(
            //                                                         Radius.circular(
            //                                                             ScreenUtil()
            //                                                                 .setSp(20)) //                 <--- border radius here
            //                                                         ),
            //                                                     image: DecorationImage(
            //                                                         image:
            //                                                             imageProvider,
            //                                                         fit: BoxFit
            //                                                             .cover),
            //                                                   ),
            //                                                 ),
            //                                                 placeholder:
            //                                                     (context,
            //                                                             url) =>
            //                                                         CircleAvatar(
            //                                                   backgroundColor:
            //                                                       lightGray,
            //                                                   radius:
            //                                                       ScreenUtil()
            //                                                           .setSp(
            //                                                               20),
            //                                                 ),
            //                                                 errorWidget: (context,
            //                                                         url,
            //                                                         error) =>
            //                                                     CircleAvatar(
            //                                                   backgroundColor:
            //                                                       lightGray,
            //                                                   radius:
            //                                                       ScreenUtil()
            //                                                           .setSp(
            //                                                               20),
            //                                                 ),
            //                                               )
            //                                             : Container(
            //                                                 height: ScreenUtil()
            //                                                     .setSp(40),
            //                                                 width: ScreenUtil()
            //                                                     .setSp(40),
            //                                                 decoration:
            //                                                     BoxDecoration(
            //                                                   border:
            //                                                       Border.all(
            //                                                     color: darkGray,
            //                                                   ),
            //                                                   shape: BoxShape
            //                                                       .circle,
            //                                                 ),
            //                                                 child: Center(
            //                                                   child: Text(
            //                                                       joinLeader
            //                                                           .user!
            //                                                           .fullname![
            //                                                               0]
            //                                                           .toUpperCase(),
            //                                                       style: GoogleFonts.nunitoSans(
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .w400,
            //                                                           fontSize: ScreenUtil()
            //                                                               .setSp(
            //                                                                   20),
            //                                                           color:
            //                                                               black)),
            //                                                 ),
            //                                               ),
            //                                         getSizedBox(w: 8),
            //                                         Expanded(
            //                                           child: Column(
            //                                             mainAxisAlignment:
            //                                                 MainAxisAlignment
            //                                                     .start,
            //                                             crossAxisAlignment:
            //                                                 CrossAxisAlignment
            //                                                     .start,
            //                                             children: [
            //                                               Text.rich(TextSpan(
            //                                                   children: <
            //                                                       TextSpan>[
            //                                                     TextSpan(
            //                                                         text:
            //                                                         joinLeader.user!.fullname == null ? "-" : "${joinLeader.user!.fullname},",
            //                                                         style: size12_M_bold(
            //                                                             textColor:
            //                                                                 Colors.black)),
            //                                                     TextSpan(
            //                                                         text:
            //                                                         joinLeader.user!.country == null ? "-" : " ${joinLeader.user!.country}",
            //                                                         style: size12_M_bold(
            //                                                             textColor:
            //                                                                 buttonBlue)),
            //                                                   ])),
            //                                               getSizedBox(h: 2),
            //                                               Text(
            //                                                 joinLeader.user!.profession == null ? "-" : "${joinLeader.user!.profession}",
            //                                                 style: size12_M_normal(
            //                                                     textColor:
            //                                                         colorGrey),
            //                                               )
            //                                             ],
            //                                           ),
            //                                         )
            //                                       ],
            //                                     ),
            //                                     getSizedBox(h: 5),
            //                                     Container(
            //                                       height: 1,
            //                                       color: Colors.white,
            //                                     )
            //                                   ],
            //                                 ),
            //                               ),
            //                               InkWell(
            //                                 onTap: () {
            //                                   Api.delete.call(
            //                                     context,
            //                                     method:
            //                                         "mudda/remove-joiner/${joinLeader.sId}",
            //                                     param: {},
            //                                     onResponseSuccess: (object) {
            //                                       print("Abhishek $object");
            //                                       leaderBoardApprovalController
            //                                           .joinLeaderList
            //                                           .removeAt(index);
            //                                     },
            //                                   );
            //                                 },
            //                                 child: Padding(
            //                                   padding:
            //                                       const EdgeInsets.all(8.0),
            //                                   child: Text(
            //                                     "Remove",
            //                                     style: size12_M_normal(
            //                                         textColor: colorGrey),
            //                                   ),
            //                                 ),
            //                               )
            //                             ],
            //                           ),
            //                         ),
            //                       );
            //                     }),
            //               ),*/
            //               leaderBoardApprovalController.isInvitedTab.value
            //                   ? RefreshIndicator(
            //                 onRefresh: () {
            //                   invitedPage = 1;
            //                   leaderBoardApprovalController
            //                       .invitedLeaderList
            //                       .clear();
            //                   return callInvitedLeaders(context);
            //                 },
            //                 child: ListView.builder(
            //                     physics:
            //                     const AlwaysScrollableScrollPhysics(),
            //                     controller: invitedScrollController,
            //                     itemCount: leaderBoardApprovalController
            //                         .invitedLeaderList.length,
            //                     itemBuilder: (followersContext, index) {
            //                       JoinLeader joinLeader =
            //                       leaderBoardApprovalController
            //                           .invitedLeaderList
            //                           .elementAt(index);
            //                       return InkWell(
            //                         onTap: () {
            //                           muddaNewsController
            //                               .acceptUserDetail
            //                               .value = joinLeader.user!;
            //                           if (joinLeader.user!.sId ==
            //                               AppPreference().getString(
            //                                   PreferencesKey.userId)) {
            //                             Get.toNamed(
            //                                 RouteConstants.profileScreen);
            //                           } else {
            //                             Map<String, String>? parameters =
            //                             {
            //                               "userDetail":
            //                               jsonEncode(joinLeader.user!)
            //                             };
            //                             Get.toNamed(
            //                                 RouteConstants
            //                                     .otherUserProfileScreen,
            //                                 parameters: parameters);
            //                           }
            //                         },
            //                         child: Padding(
            //                           padding: const EdgeInsets.only(
            //                               bottom: 10),
            //                           child: Row(
            //                             children: [
            //                               Expanded(
            //                                 child: Column(
            //                                   children: [
            //                                     Row(
            //                                       children: [
            //                                         joinLeader.user!
            //                                             .profile !=
            //                                             null
            //                                             ? CachedNetworkImage(
            //                                           imageUrl:
            //                                           "${leaderBoardApprovalController.profilePath.value}${joinLeader.user!.profile}",
            //                                           imageBuilder:
            //                                               (context,
            //                                               imageProvider) =>
            //                                               Container(
            //                                                 width: ScreenUtil()
            //                                                     .setSp(
            //                                                     40),
            //                                                 height: ScreenUtil()
            //                                                     .setSp(
            //                                                     40),
            //                                                 decoration:
            //                                                 BoxDecoration(
            //                                                   color:
            //                                                   colorWhite,
            //                                                   borderRadius:
            //                                                   BorderRadius.all(
            //                                                       Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
            //                                                   ),
            //                                                   image: DecorationImage(
            //                                                       image:
            //                                                       imageProvider,
            //                                                       fit: BoxFit
            //                                                           .cover),
            //                                                 ),
            //                                               ),
            //                                           placeholder: (context,
            //                                               url) =>
            //                                               CircleAvatar(
            //                                                 backgroundColor:
            //                                                 lightGray,
            //                                                 radius: ScreenUtil()
            //                                                     .setSp(
            //                                                     20),
            //                                               ),
            //                                           errorWidget: (context,
            //                                               url,
            //                                               error) =>
            //                                               CircleAvatar(
            //                                                 backgroundColor:
            //                                                 lightGray,
            //                                                 radius: ScreenUtil()
            //                                                     .setSp(
            //                                                     20),
            //                                               ),
            //                                         )
            //                                             : Container(
            //                                           height:
            //                                           ScreenUtil()
            //                                               .setSp(
            //                                               40),
            //                                           width: ScreenUtil()
            //                                               .setSp(
            //                                               40),
            //                                           decoration:
            //                                           BoxDecoration(
            //                                             border:
            //                                             Border
            //                                                 .all(
            //                                               color:
            //                                               darkGray,
            //                                             ),
            //                                             shape: BoxShape
            //                                                 .circle,
            //                                           ),
            //                                           child: Center(
            //                                             child: Text(
            //                                                 joinLeader
            //                                                     .user!
            //                                                     .fullname![
            //                                                 0]
            //                                                     .toUpperCase(),
            //                                                 style: GoogleFonts.nunitoSans(
            //                                                     fontWeight:
            //                                                     FontWeight.w400,
            //                                                     fontSize: ScreenUtil().setSp(20),
            //                                                     color: black)),
            //                                           ),
            //                                         ),
            //                                         getSizedBox(w: 8),
            //                                         Expanded(
            //                                           child: Column(
            //                                             mainAxisAlignment:
            //                                             MainAxisAlignment
            //                                                 .start,
            //                                             crossAxisAlignment:
            //                                             CrossAxisAlignment
            //                                                 .start,
            //                                             children: [
            //                                               Text.rich(TextSpan(
            //                                                   children: <
            //                                                       TextSpan>[
            //                                                     TextSpan(
            //                                                         text:
            //                                                         "${joinLeader.user!.fullname},",
            //                                                         style:
            //                                                         size12_M_bold(textColor: Colors.black)),
            //                                                     TextSpan(
            //                                                         text:
            //                                                         " ${joinLeader.user!.country}",
            //                                                         style:
            //                                                         size12_M_bold(textColor: buttonBlue)),
            //                                                     TextSpan(
            //                                                         text:
            //                                                         "  ${convertToAgo(DateTime.parse(joinLeader.createdAt!))}",
            //                                                         style:
            //                                                         size10_M_regular300(textColor: blackGray)),
            //                                                   ])),
            //                                               getSizedBox(
            //                                                   h: 2),
            //                                               Text(
            //                                                 joinLeader
            //                                                     .user!
            //                                                     .profession ??
            //                                                     '',
            //                                                 style: size12_M_normal(
            //                                                     textColor:
            //                                                     colorGrey),
            //                                               )
            //                                             ],
            //                                           ),
            //                                         )
            //                                       ],
            //                                     ),
            //                                     getSizedBox(h: 5),
            //                                     Container(
            //                                       height: 1,
            //                                       color: Colors.white,
            //                                     )
            //                                   ],
            //                                 ),
            //                               ),
            //                               InkWell(
            //                                 onTap: () {
            //                                   Api.delete.call(
            //                                     context,
            //                                     method:
            //                                     "request-to-user/delete/${joinLeader.sId}",
            //                                     param: {},
            //                                     onResponseSuccess:
            //                                         (object) {
            //                                       print(
            //                                           "Abhishek $object");
            //                                       MuddaPost muddaPost =
            //                                           muddaNewsController
            //                                               .muddaPost
            //                                               .value;
            //                                       muddaPost.inviteCount =
            //                                           muddaPost
            //                                               .inviteCount! -
            //                                               1;
            //                                       muddaNewsController
            //                                           .muddaPost
            //                                           .value =
            //                                           MuddaPost();
            //                                       muddaNewsController
            //                                           .muddaPost
            //                                           .value = muddaPost;
            //                                       leaderBoardApprovalController
            //                                           .invitedLeaderList
            //                                           .removeAt(index);
            //                                     },
            //                                   );
            //                                 },
            //                                 child: Padding(
            //                                   padding:
            //                                   const EdgeInsets.all(
            //                                       8.0),
            //                                   child: Text(
            //                                     "Cancel",
            //                                     style: size12_M_normal(
            //                                         textColor: colorGrey),
            //                                   ),
            //                                 ),
            //                               )
            //                             ],
            //                           ),
            //                         ),
            //                       );
            //                     }),
            //               )
            //                   : userDataOpposition == null
            //                   ? const Center(child: Text('No Opposition'))
            //                   : Column(
            //                 children: [
            //                   // Row(
            //                   //   children: [
            //                   //     Expanded(
            //                   //       child: Column(
            //                   //         children: [
            //                   //           Row(
            //                   //             children: [
            //                   //               dataMuddaOpposition['creator'] !=
            //                   //                   null
            //                   //                   ? CachedNetworkImage(
            //                   //                 imageUrl:
            //                   //                 "${leaderBoardApprovalController.profilePath.value}${dataMuddaOpposition['creator']['userDetail']['profile']}",
            //                   //                 imageBuilder:
            //                   //                     (context,
            //                   //                     imageProvider) =>
            //                   //                     Container(
            //                   //                       width:
            //                   //                       ScreenUtil()
            //                   //                           .setSp(
            //                   //                           40),
            //                   //                       height:
            //                   //                       ScreenUtil()
            //                   //                           .setSp(
            //                   //                           40),
            //                   //                       decoration:
            //                   //                       BoxDecoration(
            //                   //                         color:
            //                   //                         colorWhite,
            //                   //                         borderRadius:
            //                   //                         BorderRadius.all(
            //                   //                             Radius.circular(
            //                   //                                 ScreenUtil().setSp(20)) //                 <--- border radius here
            //                   //                         ),
            //                   //                         image: DecorationImage(
            //                   //                             image:
            //                   //                             imageProvider,
            //                   //                             fit: BoxFit
            //                   //                                 .cover),
            //                   //                       ),
            //                   //                     ),
            //                   //                 placeholder: (context,
            //                   //                     url) =>
            //                   //                     CircleAvatar(
            //                   //                       backgroundColor:
            //                   //                       lightGray,
            //                   //                       radius:
            //                   //                       ScreenUtil()
            //                   //                           .setSp(
            //                   //                           20),
            //                   //                     ),
            //                   //                 errorWidget: (context,
            //                   //                     url,
            //                   //                     error) =>
            //                   //                     CircleAvatar(
            //                   //                       backgroundColor:
            //                   //                       lightGray,
            //                   //                       radius:
            //                   //                       ScreenUtil()
            //                   //                           .setSp(
            //                   //                           20),
            //                   //                     ),
            //                   //               )
            //                   //                   : Container(
            //                   //                 height:
            //                   //                 ScreenUtil()
            //                   //                     .setSp(
            //                   //                     40),
            //                   //                 width:
            //                   //                 ScreenUtil()
            //                   //                     .setSp(
            //                   //                     40),
            //                   //                 decoration:
            //                   //                 BoxDecoration(
            //                   //                   border:
            //                   //                   Border.all(
            //                   //                     color:
            //                   //                     darkGray,
            //                   //                   ),
            //                   //                   shape: BoxShape
            //                   //                       .circle,
            //                   //                 ),
            //                   //                 child: Center(
            //                   //                   child: Text(
            //                   //                       dataMuddaOpposition['creator']['userDetail']['fullname']
            //                   //                       [0]
            //                   //                           .toUpperCase(),
            //                   //                       style: GoogleFonts.nunitoSans(
            //                   //                           fontWeight:
            //                   //                           FontWeight
            //                   //                               .w400,
            //                   //                           fontSize:
            //                   //                           ScreenUtil().setSp(
            //                   //                               20),
            //                   //                           color:
            //                   //                           black)),
            //                   //                 ),
            //                   //               ),
            //                   //               getSizedBox(w: 8),
            //                   //               Expanded(
            //                   //                 child: Column(
            //                   //                   mainAxisAlignment:
            //                   //                   MainAxisAlignment
            //                   //                       .start,
            //                   //                   crossAxisAlignment:
            //                   //                   CrossAxisAlignment
            //                   //                       .start,
            //                   //                   children: [
            //                   //                     Text.rich(TextSpan(
            //                   //                         children: <
            //                   //                             TextSpan>[
            //                   //                           TextSpan(
            //                   //                               text: dataMuddaOpposition['creator']['userDetail']['fullname'] ==
            //                   //                                   null
            //                   //                                   ? "-"
            //                   //                                   : "${dataMuddaOpposition['creator']['userDetail']['fullname']},",
            //                   //                               style: size12_M_bold(
            //                   //                                   textColor:
            //                   //                                   Colors.black)),
            //                   //                           TextSpan(
            //                   //                               text: dataMuddaOpposition['creator']['userDetail']['country'] ==
            //                   //                                   null
            //                   //                                   ? "-"
            //                   //                                   : " ${dataMuddaOpposition['creator']['userDetail']['country']}",
            //                   //                               style: size12_M_bold(
            //                   //                                   textColor:
            //                   //                                   buttonBlue)),
            //                   //                         ])),
            //                   //                     getSizedBox(h: 2),
            //                   //                     Text(
            //                   //                       dataMuddaOpposition['creator']
            //                   //                       [
            //                   //                       'userDetail']
            //                   //                       [
            //                   //                       'profession'] ==
            //                   //                           null
            //                   //                           ? "-"
            //                   //                           : "${dataMuddaOpposition['creator']['userDetail']['profession']}",
            //                   //                       style: size12_M_normal(
            //                   //                           textColor:
            //                   //                           colorGrey),
            //                   //                     )
            //                   //                   ],
            //                   //                 ),
            //                   //               )
            //                   //             ],
            //                   //           ),
            //                   //           getSizedBox(h: 5),
            //                   //           Container(
            //                   //             height: 1,
            //                   //             color: Colors.white,
            //                   //           ),
            //                   //           getSizedBox(h: 8),
            //                   //         ],
            //                   //       ),
            //                   //     ),
            //                   //     Container(
            //                   //       margin: const EdgeInsets.only(right: 8),
            //                   //       child: Text(
            //                   //         'Muddebaaz',
            //                   //         style: size12_M_bold(
            //                   //             textColor: Color(0xFFF1B008)),
            //                   //       ),
            //                   //     ),
            //                   //     /*InkWell(
            //                   //               onTap: () {
            //                   //                 Api.delete.call(
            //                   //                   context,
            //                   //                   method:
            //                   //                   "mudda/remove-joiner/${userDetails['sId']}",
            //                   //                   param: {},
            //                   //                   onResponseSuccess:
            //                   //                       (object) {
            //                   //                     print(
            //                   //                         "Abhishek $object");
            //                   //                     leaderBoardApprovalController
            //                   //                         .joinLeaderList
            //                   //                         .removeAt(index);
            //                   //                   },
            //                   //                 );
            //                   //               },
            //                   //               child: Padding(
            //                   //                 padding:
            //                   //                 const EdgeInsets.all(
            //                   //                     8.0),
            //                   //                 child: Text(
            //                   //                   "Remove",
            //                   //                   style: size12_M_normal(
            //                   //                       textColor: colorGrey),
            //                   //                 ),
            //                   //               ),
            //                   //             )*/
            //                   //   ],
            //                   // ),
            //                   Expanded(
            //                     child: ListView.builder(
            //                         controller:
            //                         oppositionScrollController,
            //                         physics:
            //                         const AlwaysScrollableScrollPhysics(),
            //                         // physics: const NeverScrollableScrollPhysics(),
            //                         itemCount:
            //                         userDataOpposition.length,
            //                         itemBuilder:
            //                             (followersContext, index) {
            //                           var userDetails =
            //                           userDataOpposition[index]
            //                           ['user'];
            //                           return InkWell(
            //                             onTap: () {
            //                               if (userDetails['_id'] ==
            //                                   AppPreference()
            //                                       .getString(
            //                                       PreferencesKey
            //                                           .userId)) {
            //                                 Get.toNamed(RouteConstants
            //                                     .profileScreen);
            //                               } else {
            //                                 Map<String, String>?
            //                                 parameters = {
            //                                   "userDetail":
            //                                   jsonEncode(
            //                                       userDetails[
            //                                       'user'])
            //                                 };
            //                                 Get.toNamed(
            //                                     RouteConstants
            //                                         .otherUserProfileScreen,
            //                                     parameters:
            //                                     parameters);
            //                               }
            //                             },
            //                             child: Padding(
            //                               padding:
            //                               const EdgeInsets.only(
            //                                   bottom: 10),
            //                               child: Row(
            //                                 children: [
            //                                   Expanded(
            //                                     child: Column(
            //                                       children: [
            //                                         Row(
            //                                           children: [
            //                                             userDetails['profile'] !=
            //                                                 null
            //                                                 ? CachedNetworkImage(
            //                                               imageUrl:
            //                                               "${leaderBoardApprovalController.profilePath.value}${userDetails['profile']}",
            //                                               imageBuilder: (context, imageProvider) =>
            //                                                   Container(
            //                                                     width:
            //                                                     ScreenUtil().setSp(40),
            //                                                     height:
            //                                                     ScreenUtil().setSp(40),
            //                                                     decoration:
            //                                                     BoxDecoration(
            //                                                       color: colorWhite,
            //                                                       borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
            //                                                       ),
            //                                                       image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            //                                                     ),
            //                                                   ),
            //                                               placeholder: (context, url) =>
            //                                                   CircleAvatar(
            //                                                     backgroundColor:
            //                                                     lightGray,
            //                                                     radius:
            //                                                     ScreenUtil().setSp(20),
            //                                                   ),
            //                                               errorWidget: (context, url, error) =>
            //                                                   CircleAvatar(
            //                                                     backgroundColor:
            //                                                     lightGray,
            //                                                     radius:
            //                                                     ScreenUtil().setSp(20),
            //                                                   ),
            //                                             )
            //                                                 : Container(
            //                                               height:
            //                                               ScreenUtil().setSp(40),
            //                                               width:
            //                                               ScreenUtil().setSp(40),
            //                                               decoration:
            //                                               BoxDecoration(
            //                                                 border:
            //                                                 Border.all(
            //                                                   color: darkGray,
            //                                                 ),
            //                                                 shape:
            //                                                 BoxShape.circle,
            //                                               ),
            //                                               child:
            //                                               Center(
            //                                                 child:
            //                                                 Text(userDetails['fullname'][0].toUpperCase(), style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w400, fontSize: ScreenUtil().setSp(20), color: black)),
            //                                               ),
            //                                             ),
            //                                             getSizedBox(
            //                                                 w: 8),
            //                                             Expanded(
            //                                               child:
            //                                               Column(
            //                                                 mainAxisAlignment:
            //                                                 MainAxisAlignment
            //                                                     .start,
            //                                                 crossAxisAlignment:
            //                                                 CrossAxisAlignment
            //                                                     .start,
            //                                                 children: [
            //                                                   Text.rich(TextSpan(
            //                                                       children: <TextSpan>[
            //                                                         TextSpan(text: userDetails['fullname'] == null ? "-" : "${userDetails['fullname']},", style: size12_M_bold(textColor: Colors.black)),
            //                                                         TextSpan(text: userDetails['country'] == null ? "-" : " ${userDetails['country']}", style: size12_M_bold(textColor: buttonBlue)),
            //                                                       ])),
            //                                                   getSizedBox(
            //                                                       h: 2),
            //                                                   Text(
            //                                                     userDetails['profession'] == null
            //                                                         ? "-"
            //                                                         : "${userDetails['profession']}",
            //                                                     style:
            //                                                     size12_M_normal(textColor: colorGrey),
            //                                                   )
            //                                                 ],
            //                                               ),
            //                                             )
            //                                           ],
            //                                         ),
            //                                         getSizedBox(h: 5),
            //                                         Container(
            //                                           height: 1,
            //                                           color: Colors
            //                                               .white,
            //                                         )
            //                                       ],
            //                                     ),
            //                                   ),
            //                                   InkWell(
            //                                     onTap: () {
            //                                       log('-=-= opp id -=- ${userDataOpposition[index]['_id']}');
            //                                       Api.delete.call(
            //                                         context,
            //                                         // method: "mudda/remove-joiner/${userDetails['_id']}",
            //                                         method:
            //                                         "mudda/remove-joiner/${userDataOpposition[index]['_id']}",
            //                                         param: {},
            //                                         onResponseSuccess:
            //                                             (object) {
            //                                           log("remove opposition -=-=-  $object");
            //                                           leaderBoardApprovalController
            //                                               .joinLeaderList
            //                                               .removeAt(
            //                                               index);
            //                                           leaderBoardApprovalController
            //                                               .joinLeaderList
            //                                               .refresh();
            //                                           onOppositionCall();
            //                                         },
            //                                       );
            //                                     },
            //                                     child: Padding(
            //                                       padding:
            //                                       const EdgeInsets
            //                                           .all(8.0),
            //                                       child: Text(
            //                                         "Remove",
            //                                         style: size12_M_normal(
            //                                             textColor:
            //                                             colorGrey),
            //                                       ),
            //                                     ),
            //                                   )
            //                                 ],
            //                               ),
            //                             ),
            //                           );
            //                         }),
            //                   ),
            //                 ],
            //               ),
            //               leaderBoardApprovalController.isInvitedTab.value
            //                   ? RefreshIndicator(
            //                 onRefresh: () {
            //                   invitedPage = 1;
            //                   leaderBoardApprovalController
            //                       .invitedLeaderList
            //                       .clear();
            //                   return callInvitedLeaders(context);
            //                 },
            //                 child: ListView.builder(
            //                     physics:
            //                     const AlwaysScrollableScrollPhysics(),
            //                     controller: invitedScrollController,
            //                     itemCount: leaderBoardApprovalController
            //                         .invitedLeaderList.length,
            //                     itemBuilder: (followersContext, index) {
            //                       JoinLeader joinLeader =
            //                       leaderBoardApprovalController
            //                           .invitedLeaderList
            //                           .elementAt(index);
            //                       return InkWell(
            //                         onTap: () {
            //                           muddaNewsController
            //                               .acceptUserDetail
            //                               .value = joinLeader.user!;
            //                           if (joinLeader.user!.sId ==
            //                               AppPreference().getString(
            //                                   PreferencesKey.userId)) {
            //                             Get.toNamed(
            //                                 RouteConstants.profileScreen);
            //                           } else {
            //                             Map<String, String>? parameters =
            //                             {
            //                               "userDetail":
            //                               jsonEncode(joinLeader.user!)
            //                             };
            //                             Get.toNamed(
            //                                 RouteConstants
            //                                     .otherUserProfileScreen,
            //                                 parameters: parameters);
            //                           }
            //                         },
            //                         child: Padding(
            //                           padding: const EdgeInsets.only(
            //                               bottom: 10),
            //                           child: Row(
            //                             children: [
            //                               Expanded(
            //                                 child: Column(
            //                                   children: [
            //                                     Row(
            //                                       children: [
            //                                         joinLeader.user!
            //                                             .profile !=
            //                                             null
            //                                             ? CachedNetworkImage(
            //                                           imageUrl:
            //                                           "${leaderBoardApprovalController.profilePath.value}${joinLeader.user!.profile}",
            //                                           imageBuilder:
            //                                               (context,
            //                                               imageProvider) =>
            //                                               Container(
            //                                                 width: ScreenUtil()
            //                                                     .setSp(
            //                                                     40),
            //                                                 height: ScreenUtil()
            //                                                     .setSp(
            //                                                     40),
            //                                                 decoration:
            //                                                 BoxDecoration(
            //                                                   color:
            //                                                   colorWhite,
            //                                                   borderRadius:
            //                                                   BorderRadius.all(
            //                                                       Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
            //                                                   ),
            //                                                   image: DecorationImage(
            //                                                       image:
            //                                                       imageProvider,
            //                                                       fit: BoxFit
            //                                                           .cover),
            //                                                 ),
            //                                               ),
            //                                           placeholder: (context,
            //                                               url) =>
            //                                               CircleAvatar(
            //                                                 backgroundColor:
            //                                                 lightGray,
            //                                                 radius: ScreenUtil()
            //                                                     .setSp(
            //                                                     20),
            //                                               ),
            //                                           errorWidget: (context,
            //                                               url,
            //                                               error) =>
            //                                               CircleAvatar(
            //                                                 backgroundColor:
            //                                                 lightGray,
            //                                                 radius: ScreenUtil()
            //                                                     .setSp(
            //                                                     20),
            //                                               ),
            //                                         )
            //                                             : Container(
            //                                           height:
            //                                           ScreenUtil()
            //                                               .setSp(
            //                                               40),
            //                                           width: ScreenUtil()
            //                                               .setSp(
            //                                               40),
            //                                           decoration:
            //                                           BoxDecoration(
            //                                             border:
            //                                             Border
            //                                                 .all(
            //                                               color:
            //                                               darkGray,
            //                                             ),
            //                                             shape: BoxShape
            //                                                 .circle,
            //                                           ),
            //                                           child: Center(
            //                                             child: Text(
            //                                                 joinLeader
            //                                                     .user!
            //                                                     .fullname![
            //                                                 0]
            //                                                     .toUpperCase(),
            //                                                 style: GoogleFonts.nunitoSans(
            //                                                     fontWeight:
            //                                                     FontWeight.w400,
            //                                                     fontSize: ScreenUtil().setSp(20),
            //                                                     color: black)),
            //                                           ),
            //                                         ),
            //                                         getSizedBox(w: 8),
            //                                         Expanded(
            //                                           child: Column(
            //                                             mainAxisAlignment:
            //                                             MainAxisAlignment
            //                                                 .start,
            //                                             crossAxisAlignment:
            //                                             CrossAxisAlignment
            //                                                 .start,
            //                                             children: [
            //                                               Text.rich(TextSpan(
            //                                                   children: <
            //                                                       TextSpan>[
            //                                                     TextSpan(
            //                                                         text:
            //                                                         "${joinLeader.user!.fullname},",
            //                                                         style:
            //                                                         size12_M_bold(textColor: Colors.black)),
            //                                                     TextSpan(
            //                                                         text:
            //                                                         " ${joinLeader.user!.country}",
            //                                                         style:
            //                                                         size12_M_bold(textColor: buttonBlue)),
            //                                                     TextSpan(
            //                                                         text:
            //                                                         "  ${convertToAgo(DateTime.parse(joinLeader.createdAt!))}",
            //                                                         style:
            //                                                         size10_M_regular300(textColor: blackGray)),
            //                                                   ])),
            //                                               getSizedBox(
            //                                                   h: 2),
            //                                               Text(
            //                                                 joinLeader
            //                                                     .user!
            //                                                     .profession ??
            //                                                     '',
            //                                                 style: size12_M_normal(
            //                                                     textColor:
            //                                                     colorGrey),
            //                                               )
            //                                             ],
            //                                           ),
            //                                         )
            //                                       ],
            //                                     ),
            //                                     getSizedBox(h: 5),
            //                                     Container(
            //                                       height: 1,
            //                                       color: Colors.white,
            //                                     )
            //                                   ],
            //                                 ),
            //                               ),
            //                               InkWell(
            //                                 onTap: () {
            //                                   Api.delete.call(
            //                                     context,
            //                                     method:
            //                                     "request-to-user/delete/${joinLeader.sId}",
            //                                     param: {},
            //                                     onResponseSuccess:
            //                                         (object) {
            //                                       print(
            //                                           "Abhishek $object");
            //                                       MuddaPost muddaPost =
            //                                           muddaNewsController
            //                                               .muddaPost
            //                                               .value;
            //                                       muddaPost.inviteCount =
            //                                           muddaPost
            //                                               .inviteCount! -
            //                                               1;
            //                                       muddaNewsController
            //                                           .muddaPost
            //                                           .value =
            //                                           MuddaPost();
            //                                       muddaNewsController
            //                                           .muddaPost
            //                                           .value = muddaPost;
            //                                       leaderBoardApprovalController
            //                                           .invitedLeaderList
            //                                           .removeAt(index);
            //                                     },
            //                                   );
            //                                 },
            //                                 child: Padding(
            //                                   padding:
            //                                   const EdgeInsets.all(
            //                                       8.0),
            //                                   child: Text(
            //                                     "Cancel",
            //                                     style: size12_M_normal(
            //                                         textColor: colorGrey),
            //                                   ),
            //                                 ),
            //                               )
            //                             ],
            //                           ),
            //                         ),
            //                       );
            //                     }),
            //               )
            //                   : RefreshIndicator(
            //                 onRefresh: () {
            //                   requestPage = 1;
            //                   leaderBoardApprovalController.requestsList
            //                       .clear();
            //                   return callRequests(context);
            //                 },
            //                 child: ListView.builder(
            //                     physics:
            //                     const AlwaysScrollableScrollPhysics(),
            //                     itemCount: leaderBoardApprovalController
            //                         .requestsList.length,
            //                     controller: requestScrollController,
            //                     itemBuilder: (followersContext, index) {
            //                       JoinLeader joinLeader =
            //                       leaderBoardApprovalController
            //                           .requestsList
            //                           .elementAt(index);
            //                       return Padding(
            //                         padding:
            //                         const EdgeInsets.only(bottom: 10),
            //                         child: Column(
            //                           children: [
            //                             Row(
            //                               children: [
            //                                 joinLeader.user!.profile !=
            //                                     null
            //                                     ? CircleAvatar(
            //                                   radius: 24,
            //                                   backgroundColor:
            //                                   Colors
            //                                       .transparent,
            //                                   backgroundImage:
            //                                   NetworkImage(
            //                                       "${leaderBoardApprovalController.profilePath.value}${joinLeader.user!.profile}"),
            //                                 )
            //                                     : CircleAvatar(
            //                                   radius: 24,
            //                                   backgroundColor:
            //                                   Colors
            //                                       .transparent,
            //                                   backgroundImage:
            //                                   AssetImage(AppIcons
            //                                       .dummyImage),
            //                                 ),
            //                                 getSizedBox(w: 8),
            //                                 Expanded(
            //                                   child: Column(
            //                                     mainAxisAlignment:
            //                                     MainAxisAlignment
            //                                         .start,
            //                                     crossAxisAlignment:
            //                                     CrossAxisAlignment
            //                                         .start,
            //                                     children: [
            //                                       Text(
            //                                         "${joinLeader.user!.fullname}, ${joinLeader.user!.country}",
            //                                         style: size12_M_bold(
            //                                             textColor:
            //                                             Colors.black),
            //                                       ),
            //                                       getSizedBox(h: 2),
            //                                       Text.rich(TextSpan(
            //                                           children: <
            //                                               TextSpan>[
            //                                             TextSpan(
            //                                                 text:
            //                                                 "${NumberFormat.compactCurrency(
            //                                                   decimalDigits:
            //                                                   0,
            //                                                   symbol:
            //                                                   '', // if you want to add currency symbol then pass that in this else leave it empty.
            //                                                 ).format(0)} Followers, ",
            //                                                 style: size12_M_bold(
            //                                                     textColor:
            //                                                     blackGray)),
            //                                             TextSpan(
            //                                                 text:
            //                                                 "${joinLeader.user!.city}, ${joinLeader.user!.state}",
            //                                                 style: size12_M_regular(
            //                                                     textColor:
            //                                                     blackGray)),
            //                                           ])),
            //                                     ],
            //                                   ),
            //                                 ),
            //                                 getSizedBox(w: 12),
            //                                 InkWell(
            //                                     onTap: () {
            //                                       Api.delete.call(
            //                                         context,
            //                                         method:
            //                                         "request-to-user/delete/${joinLeader.sId}",
            //                                         param: {},
            //                                         onResponseSuccess:
            //                                             (object) {
            //                                           log("-=-=-= Abhishek $object");
            //                                           leaderBoardApprovalController
            //                                               .requestsList
            //                                               .removeAt(
            //                                               index);
            //                                         },
            //                                       );
            //                                     },
            //                                     child: SvgPicture.asset(
            //                                         "assets/svg/cancel.svg")),
            //                                 getSizedBox(w: 25),
            //                                 InkWell(
            //                                     onTap: () {
            //                                       log("=-=-=-=-=-= Accept -=-=-=-=-=-");
            //                                       log("=-=- sId -=- ${joinLeader.sId} -=-=-=-=-=-");
            //                                       Api.post.call(
            //                                         context,
            //                                         method:
            //                                         "request-to-user/update",
            //                                         param: {
            //                                           "_id":
            //                                           joinLeader.sId,
            //                                           "action": "request",
            //                                         },
            //                                         onResponseSuccess:
            //                                             (object) {
            //                                           log("=-=-=-=-=- Abhishek $object");
            //                                           leaderBoardApprovalController
            //                                               .requestsList
            //                                               .removeAt(
            //                                               index);
            //                                         },
            //                                       );
            //                                     },
            //                                     child: SvgPicture.asset(
            //                                         "assets/svg/approve.svg")),
            //                               ],
            //                             ),
            //                             getSizedBox(h: 5),
            //                             Container(
            //                               height: 1,
            //                               color: Colors.white,
            //                             )
            //                           ],
            //                         ),
            //                       );
            //                     }),
            //               ),
            //             ],
            //             controller: leaderBoardApprovalController.controller!,
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  shoeEditDialog(BuildContext context, AcceptUserDetail userDetail,
      String joingId, int index) {
    // TODO: Dialog code
    return showDialog(
      context: Get.context as BuildContext,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          userDetail.profile != null
                              ? CachedNetworkImage(
                            imageUrl:
                            "${leaderBoardApprovalController.profilePath.value}${userDetail.profile}",
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  width: ScreenUtil().setSp(40),
                                  height: ScreenUtil().setSp(40),
                                  decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(ScreenUtil().setSp(
                                            20)) //                 <--- border radius here
                                    ),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                            placeholder: (context, url) => CircleAvatar(
                              backgroundColor: lightGray,
                              radius: ScreenUtil().setSp(20),
                            ),
                            errorWidget: (context, url, error) =>
                                CircleAvatar(
                                  backgroundColor: lightGray,
                                  radius: ScreenUtil().setSp(20),
                                ),
                          )
                              : Container(
                            height: ScreenUtil().setSp(40),
                            width: ScreenUtil().setSp(40),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: darkGray,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                  userDetail.fullname![0].toUpperCase(),
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(20),
                                      color: black)),
                            ),
                          ),
                          getSizedBox(w: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: userDetail.fullname == null
                                          ? "-"
                                          : "${userDetail.fullname}",
                                      style: size12_M_bold(
                                          textColor: Colors.black)),
                                ])),
                                getSizedBox(h: 2),
                                Text(
                                  userDetail.profession == null
                                      ? "-"
                                      : "${userDetail.profession}",
                                  style: size12_M_normal(textColor: colorGrey),
                                ),
                                Text.rich(TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: userDetail.city == null
                                          ? "-"
                                          : "${userDetail.city},",
                                      style: size12_M_regular(textColor: grey)),
                                  TextSpan(
                                      text: userDetail.state == null
                                          ? "-"
                                          : "${userDetail.state}",
                                      style: size12_M_regular(textColor: grey)),
                                ])),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // TODO: ADD REMOVE

                        Api.delete.call(
                          context,
                          // method: "mudda/remove-joiner/${userDetails['_id']}",
                          method: "mudda/remove-joiner/$joingId",
                          param: {},
                          onResponseSuccess: (object) {
                            log("favour -=-=- $object");
                            leaderBoardApprovalController.joinLeaderList
                                .removeAt(index);
                            leaderBoardApprovalController.joinLeaderList
                                .refresh();
                            onFavourCall();
                            onOppositionCall();
                            Get.back();
                          },
                        );
                      },
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: grey, width: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Remove",
                          style: size12_M_normal(textColor: colorGrey),
                        ),
                      ),
                    ),
                  ],
                ),
                getSizedBox(h: 32),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Assign Role: '),
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
                          Text(
                            "Admin",
                            style: size14_M_medium(textColor: black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
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
                          Text(
                            "Member",
                            style: size14_M_medium(textColor: black),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
                getSizedBox(h: 12),
                Text(
                  'Admins can Approve Leader Join Requests & Approve Posts',
                  style: GoogleFonts.nunitoSans(
                      color: const Color(0xff2176FF),
                      fontSize: 10.sp,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 12),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            // TODO: ADD DONE

                            Api.post.call(
                              context,
                              method: "mudda/role",
                              param: {
                                'joiningToId': joingId,
                                'userId': "${userDetail.sId}",
                                'role': muddaNewsController.isSelectRole == 0
                                    ? 'admin'
                                    : 'member'
                              },
                              onResponseSuccess: (object) {
                                leaderBoardApprovalController.joinLeaderList
                                    .refresh();
                                onFavourCall();
                                Get.back();
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: blackGray, width: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Done",
                              style: size12_M_normal(textColor: colorGrey),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // TODO: ADD CANCEL
                            Get.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: blackGray, width: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Cancel",
                              style: size12_M_normal(textColor: colorGrey),
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
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
              leaderBoardApprovalController.creator.value.amIFollowing =
              leaderBoardApprovalController.creator.value.amIFollowing == 0
                  ? 1
                  : 0;
            } else if (index == -2) {
              leaderBoardApprovalController.oppositionLeader.value
                  .amIFollowing = leaderBoardApprovalController
                  .oppositionLeader.value.amIFollowing ==
                  0
                  ? 1
                  : 0;
            }
            setState(() {});
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: status == 0 ? Colors.transparent : const Color(0xff606060),
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

  callJoinLeaders(BuildContext context) async {
    Api.get.call(context,
        method: "mudda/joined-in-mudda",
        param: {
          "page": page.toString(),
          "search": leaderBoardApprovalController.search.value,
          "_id": muddaNewsController.muddaPost.value.sId,
          // "_id": muddaNewsController?.muddaPost.value.sId,
        },
        isLoading: false, onResponseSuccess: (Map object) {
          print(object);
          var result = UserJoinLeadersModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            leaderBoardApprovalController.profilePath.value = result.path!;
            leaderBoardApprovalController.joinLeaderList.addAll(result.data!);
          } else {
            page = page > 1 ? page - 1 : page;
          }
        });
  }

  callInvitedLeaders(BuildContext context) async {
    Api.get.call(context,
        method: "mudda/invited-in-mudda",
        param: {
          "page": invitedPage.toString(),
          "search": leaderBoardApprovalController.invitedSearch.value,
          "_id": muddaNewsController.muddaPost.value.sId,
          // "_id": muddaNewsController?.muddaPost.value.sId,
          "user_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
          print(object);
          var result = UserJoinLeadersModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            leaderBoardApprovalController.invitedLeaderList.clear();
            leaderBoardApprovalController.profilePath.value = result.path!;
            leaderBoardApprovalController.invitedLeaderList.addAll(result.data!);
          } else {
            invitedPage = invitedPage > 1 ? invitedPage - 1 : invitedPage;
          }
        });
  }
  paginateInvitedLeaders(BuildContext context) async {
    Api.get.call(context,
        method: "mudda/invited-in-mudda",
        param: {
          "page": invitedPage.toString(),
          "search": leaderBoardApprovalController.invitedSearch.value,
          "_id": muddaNewsController.muddaPost.value.sId,
          // "_id": muddaNewsController?.muddaPost.value.sId,
          "user_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
          print(object);
          var result = UserJoinLeadersModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            leaderBoardApprovalController.profilePath.value = result.path!;
            leaderBoardApprovalController.invitedLeaderList.addAll(result.data!);
          } else {
            invitedPage = invitedPage > 1 ? invitedPage - 1 : invitedPage;
          }
        });
  }

  callRequests(BuildContext context) async {
    Api.get.call(context,
        method: "mudda/requested-in-mudda",
        param: {
          "page": requestPage.toString(),
          "_id": muddaNewsController.muddaPost.value.sId,
          // "_id": muddaNewsController?.muddaPost.value.sId,
          "user_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
          print(object);
          var result = UserJoinLeadersModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            leaderBoardApprovalController.profilePath.value = result.path!;
            leaderBoardApprovalController.requestsList.addAll(result.data!);
          } else {
            requestPage = requestPage > 1 ? requestPage - 1 : requestPage;
          }
        });
  }
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