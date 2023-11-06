import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/const/const.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/InitialSurveyPostModel.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/QuotePostModel.dart';
import 'package:mudda/model/UserProfileModel.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/other_user_profile/controller/ChatController.dart';
import 'package:mudda/ui/screens/profile_screen/controller/profile_controller.dart';
import 'package:mudda/ui/screens/profile_screen/view/profile_screen.dart';
import 'package:mudda/ui/screens/profile_screen/widget/leaderBoard_loading_view.dart';
import 'package:mudda/ui/screens/profile_screen/widget/profile_mudda_loading_view.dart';
import 'package:mudda/ui/screens/profile_screen/widget/user_profile_tab.dart';
import 'package:mudda/ui/screens/quotes_list/view/quotes_list.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import '../../home_screen/widget/component/hot_mudda_post.dart';

class OtherOrgProfileScreen extends GetView<UserProfileUpdateController> {
  AcceptUserDetail? userDetail;

  OtherOrgProfileScreen({Key? key}) : super(key: key);

  UserProfileUpdateController? userProfileUpdateController;
  MuddaNewsController? muddaNewsController;
  ProfileController? profileController;
  ScrollController muddaScrollController = ScrollController();
  ScrollController memberOfScrollController = ScrollController();
  ChatController? _chatController;
  int muddaPage = 1;
  int quotePage = 1;
  int activityPage = 1;
  int surveyPage = 1;
  int memberPage = 1;
  String postAs = "user";

  @override
  Widget build(BuildContext context) {
    _chatController = Get.find<ChatController>();
    muddaNewsController = Get.find<MuddaNewsController>();
    if (Get.parameters['id'] == null) {
      userDetail =
          AcceptUserDetail.fromJson(jsonDecode(Get.parameters['userDetail']!));
    } else if (Get.parameters['id'] != null &&
        Get.parameters['id'] ==
            AppPreference().getString(PreferencesKey.orgUserId)) {
      Get.toNamed(RouteConstants.profileScreen, arguments: {'page': 1});
    }
    if (Get.parameters['postAs'] != null) {
      postAs = Get.parameters['postAs']!;
    } else {
      postAs = "user";
    }
    muddaPage = 1;
    quotePage = 1;
    activityPage = 1;
    surveyPage = 1;
    profileController = Get.put(ProfileController(),
        tag: Get.parameters['id'] ?? userDetail!.sId);
    userProfileUpdateController = Get.put(UserProfileUpdateController(),
        tag: Get.parameters['id'] ?? userDetail!.sId);

    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        if (profileController!.isTabSelected.value == 0) {
          muddaPage++;
          _getMuddaPost(context);
        } else if (profileController!.isTabSelected.value == 1) {
          quotePage++;
          _getQuotePost(context);
        } else if (profileController!.isTabSelected.value == 2) {
          activityPage++;
          _getActivityPost(context);
        } else if (profileController!.isTabSelected.value == 3) {
          surveyPage++;
          _getSurveyPost(context);
        }
      }
    });
    memberOfScrollController.addListener(() {
      if (memberOfScrollController.position.maxScrollExtent ==
          memberOfScrollController.position.pixels) {
        memberPage++;
        _getMember(context);
      }
    });
    _getProfile(context);
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: black),
          leading: IconButton(
              onPressed: () async {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios, color: black)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () async {
                  Share.share(
                    '${Const.shareUrl}profile/${userDetail!.sId}',
                  );
                },
                icon: SvgPicture.asset("assets/svg/share.svg"))
          ]),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () {
            return _getProfile(context);
          },
          child: SingleChildScrollView(
            controller: muddaScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            postAs == "anynymous"
                                ? Container(
                                    height: 95,
                                    width: 95,
                                    child: Center(
                                      child: Text("A",
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(30),
                                              color: black)),
                                    ),
                                    decoration: BoxDecoration(
                                      color: white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(.2),
                                            blurRadius: 5.0,
                                            offset: const Offset(0, 5))
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(ScreenUtil().setSp(
                                              24)) //                 <--- border radius here
                                          ),
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      showFullProfileDialog(context);
                                    },
                                    child: userProfileUpdateController!
                                                .userProfile.value.profile !=
                                            null
                                        ? SizedBox(
                                            width: ScreenUtil().setSp(95),
                                            height: ScreenUtil().setSp(95),
                                            child: Stack(children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    "${userProfileUpdateController!.userProfilePath}${userProfileUpdateController!.userProfile.value.profile}",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: ScreenUtil().setSp(95),
                                                  height:
                                                      ScreenUtil().setSp(95),
                                                  decoration: BoxDecoration(
                                                    color: colorWhite,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(.2),
                                                          blurRadius: 5.0,
                                                          offset: const Offset(
                                                              0, 5))
                                                    ],
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 2),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            ScreenUtil().setSp(
                                                                47.5)) //                 <--- border radius here
                                                        ),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                              Positioned(
                                                bottom: 5,
                                                right: 10,
                                                child: Visibility(
                                                  visible:
                                                      userProfileUpdateController!
                                                              .userProfile
                                                              .value
                                                              .isProfileVerified ==
                                                          1,
                                                  child: Image.asset(
                                                    AppIcons.icVerified,
                                                    width: 18,
                                                    height: 22,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          )
                                        : Container(
                                            width: ScreenUtil().setSp(95),
                                            height: ScreenUtil().setSp(95),
                                            child: Stack(children: [
                                              Center(
                                                child: Text(
                                                    userProfileUpdateController!
                                                                .userProfile
                                                                .value
                                                                .fullname !=
                                                            null
                                                        ? userProfileUpdateController!
                                                            .userProfile
                                                            .value
                                                            .fullname![0]
                                                            .toUpperCase()
                                                        : "",
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(30),
                                                            color: black)),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 10,
                                                child: Visibility(
                                                  visible:
                                                      userProfileUpdateController!
                                                              .userProfile
                                                              .value
                                                              .isProfileVerified ==
                                                          1,
                                                  child: Image.asset(
                                                    AppIcons.icVerified,
                                                    width: 18,
                                                    height: 22,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            decoration: BoxDecoration(
                                              color: white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(.2),
                                                    blurRadius: 5.0,
                                                    offset: const Offset(0, 5))
                                              ],
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                          ),
                                  ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              userProfileUpdateController!
                                      .userProfile.value.fullname ??
                                  "",
                              style: size14_M_semibold(
                                textColor: colorBlack,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "@${userProfileUpdateController!.userProfile.value.username ?? ''}",
                              style: size13_M_medium(
                                textColor: const Color(0xFFefa627),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "${userProfileUpdateController!.userProfile.value.organizationType}(${userProfileUpdateController!.userProfile.value.category != null ? userProfileUpdateController!.userProfile.value.category!.join(", ") : ""})" ??
                                  "",
                              style: size13_M_medium(
                                textColor: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Wrap(
                              children: [
                                Image.asset(
                                  AppIcons.locationIcon,
                                  height: 15,
                                  width: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "${userProfileUpdateController!.userProfile.value.city ?? ""},${userProfileUpdateController!.userProfile.value.state ?? ""},${userProfileUpdateController!.userProfile.value.country ?? ""}",
                                    style: size11_M_medium(
                                      textColor: darkGray,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Leader Board",
                            style: size15_M_semibold(
                              textColor: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(() => userProfileUpdateController!.isLoading.value
                              ? Row(
                                  children: const [
                                    LeaderBoardLoadingView(),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    LeaderBoardLoadingView(),
                                  ],
                                )
                              : Row(
                                  children: [
                                    leaderBox(
                                        value: NumberFormat.compactCurrency(
                                          decimalDigits: 0,
                                          symbol:
                                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                                        ).format(userProfileUpdateController!
                                                .userProfile
                                                .value
                                                .countNetwork ??
                                            0),
                                        title: "Network",
                                        onTap: () {
                                          // Get.toNamed(RouteConstants.followerScreen);
                                        }),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    leaderBox(
                                        value: NumberFormat.compactCurrency(
                                          decimalDigits: 0,
                                          symbol:
                                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                                        ).format(userProfileUpdateController!
                                                .userProfile.value.muddaCount ??
                                            0),
                                        title: "Mudda",
                                        onTap: () {
                                          profileController!
                                              .isTabSelected.value = 0;
                                          Future.delayed(
                                              const Duration(milliseconds: 500),
                                              () {
                                            muddaScrollController.jumpTo(
                                                muddaScrollController
                                                    .position.maxScrollExtent);
                                          });
                                          // Get.toNamed(RouteConstants.followerScreen);
                                        }),
                                  ],
                                )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 1,
                            width: 150,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(() => userProfileUpdateController!.isLoading.value
                              ? Row(
                                  children: const [
                                    LeaderBoardLoadingView(),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    LeaderBoardLoadingView(),
                                  ],
                                )
                              : Row(
                                  children: [
                                    leaderBox(
                                      value: NumberFormat.compactCurrency(
                                        decimalDigits: 0,
                                        symbol:
                                            '', // if you want to add currency symbol then pass that in this else leave it empty.
                                      ).format(userProfileUpdateController!
                                              .userProfile
                                              .value
                                              .countFollowers ??
                                          0),
                                      title: "Followers",
                                      onTap: () {
                                        AcceptUserDetail user =
                                            userProfileUpdateController!
                                                .userProfile.value;
                                        user.followerIndex = 0;
                                        Map<String, String>? parameters = {
                                          "user": jsonEncode(user)
                                        };
                                        Get.toNamed(
                                            RouteConstants.followerInfoScreen,
                                            parameters: parameters);
                                      },
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    leaderBox(
                                      value: NumberFormat.compactCurrency(
                                        decimalDigits: 0,
                                        symbol:
                                            '', // if you want to add currency symbol then pass that in this else leave it empty.
                                      ).format(userProfileUpdateController!
                                              .userProfile
                                              .value
                                              .organizationMemberCount ??
                                          0),
                                      title: "Members",
                                      onTap: () {
                                        Get.toNamed(
                                            RouteConstants.otherOrgMembers,
                                            arguments:
                                                userProfileUpdateController!
                                                    .userProfile.value);
                                      },
                                    ),
                                  ],
                                ))
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                whiteDivider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    userProfileUpdateController!.userProfile.value.amIJoined !=
                                null &&
                            (userProfileUpdateController!
                                        .userProfile.value.amIJoined!.role
                                        ?.toLowerCase() ==
                                    'co-founder' ||
                                userProfileUpdateController!
                                        .userProfile.value.amIJoined!.role
                                        ?.toLowerCase() ==
                                    'full' ||
                                userProfileUpdateController!
                                        .userProfile.value.amIJoined!.role
                                        ?.toLowerCase() ==
                                    'admin')
                        ? GestureDetector(
                            onTap: () {
                              Map<String, String>? parameters = {
                                "id": jsonEncode(userProfileUpdateController!
                                    .userProfile.value.sId)
                              };
                              Get.toNamed(RouteConstants.newRequestScreen,
                                  parameters: parameters);
                            },
                            child: Stack(
                              alignment: Alignment.topRight,
                              clipBehavior: Clip.none,
                              children: [
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 26, bottom: 3.5, top: 3.5),
                                          child: Text(
                                            "Requests",
                                            style: size14_M_normal(
                                                textColor: colorGrey),
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: colorGrey),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: -5,
                                      child: Container(
                                        height: 34,
                                        width: 34,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 32,
                                              width: 32,
                                              child: Center(
                                                child: Image.asset(
                                                  AppIcons.requestIcon,
                                                  height: 18,
                                                  width: 18,
                                                  color: colorGrey,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: colorGrey),
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                          ],
                                        ),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 3,
                                  top: -10,
                                  child: Container(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 1,
                                            bottom: 1),
                                        child: Text(
                                          NumberFormat.compactCurrency(
                                            decimalDigits: 0,
                                            symbol:
                                                '', // if you want to add currency symbol then pass that in this else leave it empty.
                                          ).format(userProfileUpdateController!
                                                  .orgUserProfile
                                                  .value
                                                  .countRequests ??
                                              0),
                                          style: size10_M_normal(
                                              textColor: buttonBlue),
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: buttonBlue),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : userProfileUpdateController!
                                    .userProfile.value.amIJoined !=
                                null
                            ? orgBox(
                                title: "Message",
                                icon: AppIcons.rightSizeArrow,
                                onTap: () {
                                  _chatController?.userId = Get.parameters['id'] ?? userDetail!.sId;
                                  _chatController?.chatId = userProfileUpdateController!
                                      .userProfile.value.chatId ??
                                      "";
                                  _chatController?.userName = userProfileUpdateController!
                                      .userProfile.value.fullname ??
                                      "";
                                  _chatController?.profile = userProfileUpdateController!.userProfile.value.profile;
                                  _chatController?.isUserBlock.value = userProfileUpdateController!
                                      .userProfile.value.isUserBlocked ??
                                      false;
                                  _chatController
                                      ?.index
                                      .value = 0;
                                  Get.toNamed(
                                      RouteConstants
                                          .orgChatPage,
                                      arguments: {
                                        'members':
                                        userProfileUpdateController!.userProfile.value.organizationMemberCount ?? 0
                                      });
                                })
                            : const SizedBox(),
                    /*const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 20,
                      width: 20,
                      child: const Center(child: Text("?")),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colorGrey)),
                    ),*/
                    Obx(
                      () => orgBox(
                          title: userProfileUpdateController!
                                          .userProfile.value.amIJoined ==
                                      null &&
                                  userProfileUpdateController!
                                          .userProfile.value.amIRequested ==
                                      0
                              ? "Join"
                              : userProfileUpdateController!
                                          .userProfile.value.amIJoined !=
                                      null
                                  ? "Leave"
                                  : "Req Sent",
                          icon: AppIcons.requestIcon,
                          onTap: () {
                            if (userProfileUpdateController!
                                        .userProfile.value.amIJoined ==
                                    null &&
                                userProfileUpdateController!
                                        .userProfile.value.amIRequested ==
                                    0) {
                              AcceptUserDetail user =
                                  userProfileUpdateController!
                                      .userProfile.value;
                              user.amIRequested = 1;
                              userProfileUpdateController!.userProfile.value =
                                  user;
                              Api.post.call(
                                context,
                                method: "request-to-user/store",
                                param: {
                                  "user_id": AppPreference()
                                      .getString(PreferencesKey.userId),
                                  "request_to_user_id": userDetail!.sId,
                                  "request_type": "join",
                                  "requestModalPath":
                                      userProfileUpdateController!
                                          .userProfilePath.value,
                                  "requestModal": "Users",
                                },
                                onResponseSuccess: (object) {
                                  _getProfile(context);
                                },
                              );
                            } else if (userProfileUpdateController!
                                    .userProfile.value.amIJoined !=
                                null) {
                              Api.delete.call(
                                context,
                                method:
                                    "organization-member/delete/${userProfileUpdateController!.userProfile.value.amIJoined!.sId}",
                                param: {},
                                onResponseSuccess: (object) {
                                  _getProfile(context);
                                },
                              );
                            }
                          }),
                    ),
                    userProfileUpdateController!.userProfile.value.amIJoined !=
                                null &&
                            (userProfileUpdateController!
                                        .userProfile.value.amIJoined!.role
                                        ?.toLowerCase() ==
                                    'co-founder' ||
                                userProfileUpdateController!
                                        .userProfile.value.amIJoined!.role
                                        ?.toLowerCase() ==
                                    'full' ||
                                userProfileUpdateController!
                                        .userProfile.value.amIJoined!.role
                                        ?.toLowerCase() ==
                                    'admin')
                        ? orgBox(
                            title: "Invite",
                            icon: AppIcons.inviteIcon,
                            onTap: () {
                              Map<String, String>? parameters = {
                                "id": jsonEncode(userProfileUpdateController!
                                    .userProfile.value.sId)
                              };
                              Get.toNamed(RouteConstants.invitedOrgSearchScreen,
                                  parameters: parameters);
                            })
                        : GestureDetector(
                            onTap: () {
                              if (AppPreference()
                                  .getBool(PreferencesKey.isGuest)) {
                                updateProfileDialog(context);
                              } else {
                                Api.post.call(
                                  context,
                                  method: "request-to-user/store",
                                  param: {
                                    "user_id": AppPreference()
                                        .getString(PreferencesKey.userId),
                                    "request_to_user_id": userDetail!.sId,
                                    "request_type": "follow",
                                  },
                                  onResponseSuccess: (object) {
                                    print(object);
                                  },
                                );
                                AcceptUserDetail user =
                                    userProfileUpdateController!
                                        .userProfile.value;
                                user.amIFollowing =
                                    user.amIFollowing == 0 ? 1 : 0;
                                user.countFollowers = user.amIFollowing == 0
                                    ? (user.countFollowers! - 1)
                                    : (user.countFollowers! + 1);
                                userProfileUpdateController!.userProfile.value =
                                    user;
                                userProfileUpdateController!
                                    .updateProfile.value = user.amIFollowing!;
                                // userProfileUpdateController!.updateFollowStatus(user);
                              }
                            },
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 24,
                                  width: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Text(
                                        userProfileUpdateController!
                                                        .updateProfile ==
                                                    0 &&
                                                userProfileUpdateController!
                                                        .userProfile
                                                        .value
                                                        .amIFollowing ==
                                                    0
                                            ? "Follow"
                                            : "UnFollow",
                                        style: size12_M_normal(
                                            textColor: colorGrey),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: colorGrey),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: -5,
                                  child: Container(
                                    height: 34,
                                    width: 34,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 32,
                                          width: 32,
                                          child: Center(
                                            child: Image.asset(
                                              AppIcons.followersIcon,
                                              height: 18,
                                              width: 18,
                                              color: colorGrey,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: colorGrey),
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      ],
                                    ),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                whiteDivider(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ReadMoreText(
                    userProfileUpdateController!
                            .userProfile.value.description ??
                        "",
                    trimLines: 3,
                    style: size14_M_normal(textColor: Colors.black),
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'more',
                    trimExpandedText: 'less',
                    moreStyle: size14_M_normal(textColor: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(
                        "Members:",
                        style: size14_M_semibold(
                          textColor: colorBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: memberOfScrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 4),
                    child: Row(
                      children: List.generate(
                          userProfileUpdateController!
                                      .userProfile.value.organizationMember !=
                                  null
                              ? userProfileUpdateController!
                                  .userProfile.value.organizationMember!.length
                              : 0, (index) {
                        return InkWell(
                          onTap: () {
                            if (userProfileUpdateController!
                                        .userProfile.value.organizationMember!
                                        .elementAt(index)
                                        .userDetail!
                                        .sId ==
                                    AppPreference()
                                        .getString(PreferencesKey.userId) ||
                                userProfileUpdateController!
                                        .userProfile.value.organizationMember!
                                        .elementAt(index)
                                        .userDetail!
                                        .sId ==
                                    AppPreference()
                                        .getString(PreferencesKey.orgUserId)) {
                              Get.toNamed(RouteConstants.profileScreen);
                            } else if (userProfileUpdateController!
                                    .userProfile.value.organizationMember!
                                    .elementAt(index)
                                    .userDetail!
                                    .userType ==
                                "user") {
                              Map<String, String>? parameters = {
                                "userDetail": jsonEncode(
                                    userProfileUpdateController!
                                        .userProfile.value.organizationMember!
                                        .elementAt(index)
                                        .userDetail!)
                              };
                              Get.toNamed(RouteConstants.otherUserProfileScreen,
                                  parameters: parameters);
                            } else {
                              Map<String, String>? parameters = {
                                "userDetail": jsonEncode(
                                    userProfileUpdateController!
                                        .userProfile.value.organizationMember!
                                        .elementAt(index)
                                        .userDetail!)
                              };
                              Get.toNamed(RouteConstants.otherOrgProfileScreen,
                                  parameters: parameters);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: userProfileUpdateController!
                                        .userProfile.value.organizationMember!
                                        .elementAt(index)
                                        .userDetail!
                                        .profile !=
                                    null
                                ? SizedBox(
                                    width: ScreenUtil().setSp(40),
                                    height: ScreenUtil().setSp(40),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${userProfileUpdateController!.userProfilePath}${userProfileUpdateController!.userProfile.value.organizationMember!.elementAt(index).userDetail!.profile}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: ScreenUtil().setSp(40),
                                        height: ScreenUtil().setSp(40),
                                        decoration: BoxDecoration(
                                          color: colorWhite,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.5),
                                              blurRadius: 2.0,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                          border: Border.all(
                                              color: userProfileUpdateController!
                                                          .userProfile
                                                          .value
                                                          .organizationMember!
                                                          .elementAt(index)
                                                          .role
                                                          ?.toLowerCase() ==
                                                      'speaker'
                                                  ? colorF1B008
                                                  : userProfileUpdateController!
                                                              .userProfile
                                                              .value
                                                              .organizationMember!
                                                              .elementAt(index)
                                                              .role
                                                              ?.toLowerCase() ==
                                                          "admin"
                                                      ? color606060
                                                      : userProfileUpdateController!
                                                                  .userProfile
                                                                  .value
                                                                  .organizationMember!
                                                                  .elementAt(
                                                                      index)
                                                                  .role
                                                                  ?.toLowerCase() ==
                                                              "creator"
                                                          ? color0060FF
                                                          : userProfileUpdateController!
                                                                      .userProfile
                                                                      .value
                                                                      .organizationMember!
                                                                      .elementAt(
                                                                          index)
                                                                      .role
                                                                      ?.toLowerCase() ==
                                                                  "co-founder"
                                                              ? color35bedc
                                                              : Colors
                                                                  .transparent,
                                              width: 2),
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  )
                                : Container(
                                    height: ScreenUtil().setSp(40),
                                    width: ScreenUtil().setSp(40),
                                    decoration: BoxDecoration(
                                      color: colorAppBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.5),
                                          blurRadius: 2.0,
                                          offset: const Offset(0, 2),
                                        )
                                      ],
                                      border: Border.all(
                                          color: userProfileUpdateController!
                                                      .userProfile
                                                      .value
                                                      .organizationMember!
                                                      .elementAt(index)
                                                      .role ==
                                                  'Speaker'
                                              ? colorF1B008
                                              : userProfileUpdateController!
                                                          .userProfile
                                                          .value
                                                          .organizationMember!
                                                          .elementAt(index)
                                                          .role ==
                                                      "Admin"
                                                  ? color606060
                                                  : userProfileUpdateController!
                                                              .userProfile
                                                              .value
                                                              .organizationMember!
                                                              .elementAt(index)
                                                              .role ==
                                                          "creator"
                                                      ? color0060FF
                                                      : userProfileUpdateController!
                                                                  .userProfile
                                                                  .value
                                                                  .organizationMember!
                                                                  .elementAt(
                                                                      index)
                                                                  .role ==
                                                              "Full"
                                                          ? color35bedc
                                                          : Colors.transparent,
                                          width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                          userProfileUpdateController!
                                              .userProfile
                                              .value
                                              .organizationMember!
                                              .elementAt(index)
                                              .userDetail!
                                              .fullname![0]
                                              .toUpperCase(),
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(20),
                                              color: black)),
                                    ),
                                  ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx(() => Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: InkWell(
                              onTap: () {
                                print("fdfdsf");
                                profileController!.isTabSelected.value = index;
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    profileController!.tabList[index],
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 2,
                                    width: 25,
                                    color: profileController!
                                                .isTabSelected.value ==
                                            index
                                        ? Colors.black
                                        : Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => profileController!.isTabSelected.value == 0
                    ? profileController!.isProfileMuddaLoading.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: List.generate(
                                4,
                                (index) {
                                  return const ProfileMuddaLoadingView();
                                },
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: List.generate(
                                profileController!.muddaPostList.length,
                                (index) {
                                  String status = "Under Approval";
                                  String created = "";
                                  MuddaPost muddaPost = profileController!
                                      .muddaPostList
                                      .elementAt(index);
                                  if (AppPreference()
                                          .getString(PreferencesKey.userId) !=
                                      muddaPost.leaders!
                                          .elementAt(0)
                                          .acceptUserDetail!
                                          .sId) {
                                    created =
                                        "Created By - ${muddaPost.leaders!.elementAt(0).acceptUserDetail!.fullname}";
                                  } else {
                                    created = "Created By - You";
                                  }
                                  if (muddaPost.initialScope!.toLowerCase() ==
                                      "district") {
                                    if (muddaPost.leadersCount! >= 10) {
                                      status = "Approved";
                                    } else {
                                      status = "Under Approval";
                                    }
                                  } else if (muddaPost.initialScope!
                                          .toLowerCase() ==
                                      "state") {
                                    if (muddaPost.leadersCount! >= 15 &&
                                        muddaPost.uniqueCity! >= 3) {
                                      status = "Approved";
                                    } else {
                                      status = "Under Approval";
                                    }
                                  } else if (muddaPost.initialScope!
                                          .toLowerCase() ==
                                      "country") {
                                    if (muddaPost.leadersCount! >= 20 &&
                                        muddaPost.uniqueState! >= 3) {
                                      status = "Approved";
                                    } else {
                                      status = "Under Approval";
                                    }
                                  } else if (muddaPost.initialScope!
                                          .toLowerCase() ==
                                      "world") {
                                    if (muddaPost.leadersCount! >= 25 &&
                                        muddaPost.uniqueCountry! >= 5) {
                                      status = "Approved";
                                    } else {
                                      status = "Under Approval";
                                    }
                                  }
                                  return InkWell(
                                    onTap: () {
                                      // Map<String, String>? parameters = {
                                      //   "muddaId": muddaPost.sId!
                                      // };
                                      // Get.toNamed(RouteConstants.shareMuddaScreen,
                                      //     parameters: parameters);
                                      if (muddaPost.isVerify == 1) {
                                        muddaNewsController!.muddaPost.value =
                                            muddaPost;
                                        Get.toNamed(
                                            RouteConstants.muddaDetailsScreen);
                                      } else if (muddaPost.isVerify == 0 &&
                                          AppPreference().getString(
                                                  PreferencesKey.userId) ==
                                              muddaPost.leaders!
                                                  .elementAt(0)
                                                  .acceptUserDetail!
                                                  .sId) {
                                        muddaNewsController!
                                            .tabController.index = 2;
                                        Get.back();
                                      } else {
                                        // Fluttertoast.showToast(msg: "It is an unapproved mudda");
                                        muddaNewsController!
                                            .tabController.index = 2;
                                        muddaNewsController!
                                            .isFromOtherProfile.value = true;
                                        muddaNewsController!
                                            .fetchUnapproveMudda(
                                                context, muddaPost.sId!);
                                        // Get.offAllNamed(RouteConstants.homeScreen);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil().setSp(8)),
                                              child: SizedBox(
                                                height: ScreenUtil().setSp(70),
                                                width: ScreenUtil().setSp(70),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${profileController!.muddaProfilePath.value}${muddaPost.thumbnail}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setSp(10),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(muddaPost.title!,
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          12),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: black)),
                                                  SizedBox(
                                                    height:
                                                        ScreenUtil().setSp(10),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                              muddaPost.initialScope!
                                                                          .toLowerCase() ==
                                                                      "district"
                                                                  ? muddaPost
                                                                      .city!
                                                                  : muddaPost
                                                                              .initialScope!
                                                                              .toLowerCase() ==
                                                                          "state"
                                                                      ? muddaPost
                                                                          .state!
                                                                      : muddaPost.initialScope!.toLowerCase() ==
                                                                              "country"
                                                                          ? muddaPost
                                                                              .country!
                                                                          : muddaPost
                                                                              .initialScope!,
                                                              style: GoogleFonts.nunitoSans(
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              12),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      black)),
                                                          Text(status,
                                                              style: GoogleFonts.nunitoSans(
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              12),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      buttonYellow)),
                                                        ],
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              created,
                                                              style: GoogleFonts.nunitoSans(
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              12),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      buttonBlue),
                                                              textAlign:
                                                                  TextAlign.end,
                                                            ),
                                                            Text(
                                                                "Joined by: ${NumberFormat.compactCurrency(
                                                                  decimalDigits:
                                                                      0,
                                                                  symbol:
                                                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                                ).format(muddaPost.joinersCount)} members",
                                                                style: GoogleFonts.nunitoSans(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color:
                                                                        black),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end),
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setSp(8),
                                        ),
                                        Visibility(
                                          visible: status != "Under Approval",
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${NumberFormat.compactCurrency(
                                                    decimalDigits: 0,
                                                    symbol:
                                                        '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                  ).format(muddaPost.totalVote)} Interactions",
                                                  style: GoogleFonts.nunitoSans(
                                                      fontSize: ScreenUtil()
                                                          .setSp(12),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: black),
                                                ),
                                              ),
                                              SizedBox(
                                                width: ScreenUtil().setSp(15),
                                              ),
                                              Text(
                                                "${muddaPost.support != 0 ? ((muddaPost.support! * 100) / muddaPost.totalVote!).toStringAsFixed(2) : 0}% / ${NumberFormat.compactCurrency(
                                                  decimalDigits: 0,
                                                  symbol:
                                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                ).format(muddaPost.support)}",
                                                style: GoogleFonts.nunitoSans(
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    fontWeight: FontWeight.w400,
                                                    color: black),
                                              ),
                                              Image.asset(
                                                AppIcons.handIcon,
                                                height: 20,
                                                width: 20,
                                              ),
                                              const Spacer(),
                                              Text(
                                                "${muddaPost.support != 0 ? ((muddaPost.support! * 100) / muddaPost.totalVote!).toStringAsFixed(2) : 0}%",
                                                style: size09_M_bold(
                                                    textColor: Colors.red),
                                              ),
                                              const Icon(
                                                Icons.arrow_downward_outlined,
                                                color: Colors.red,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: ScreenUtil().setSp(18),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setSp(8),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  muddaPost.hashtags!.join(','),
                                                  style: size10_M_normal(
                                                      textColor:
                                                          colorDarkBlack)),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setSp(10),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              colorDarkBlack),
                                                ),
                                                SizedBox(
                                                  width: ScreenUtil().setSp(5),
                                                ),
                                                Text(
                                                    "${muddaPost.city ?? ""}, ${muddaPost.state ?? ""}, ${muddaPost.country ?? ""}",
                                                    style: size12_M_normal(
                                                        textColor:
                                                            colorDarkBlack)),
                                              ],
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setSp(10),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: colorDarkBlack),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setSp(5),
                                            ),
                                            Text(
                                                convertToAgo(DateTime.parse(
                                                    muddaPost.createdAt!)),
                                                style: size10_M_normal(
                                                    textColor: colorDarkBlack)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setSp(4),
                                        ),
                                        Container(
                                          height: ScreenUtil().setSp(1),
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                    : profileController!.isTabSelected.value == 2
                        ? PostGrid(profileController!)
                        : QuotesList(profileController!))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getMember(BuildContext context) async {
    Api.get.call(context,
        method: "user/${Get.parameters['id'] ?? userDetail!.sId}",
        param: {
          "_id": Get.parameters['id'] ?? userDetail!.sId,
        },
        isLoading: false, onResponseSuccess: (Map object) {
      print(object);
      var result = UserProfileModel.fromJson(object);
      userProfileUpdateController!.userProfilePath.value = result.path!;
      if (result.data!.organizationMember!.isNotEmpty) {
        userProfileUpdateController!.userProfile.value = result.data!;
      } else {
        memberPage = memberPage > 1 ? memberPage - 1 : memberPage;
      }
    });
  }

  _getMuddaPost(BuildContext context) async {
    Api.get.call(context,
        method: "mudda/my-engagement",
        param: {
          "page": muddaPage.toString(),
          "user_id": Get.parameters['id'] ?? userDetail!.sId
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = MuddaPostModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        profileController!.muddaProfilePath.value = result.path!;
        profileController!.muddaPostList.addAll(result.data!);
      } else {
        muddaPage = muddaPage > 1 ? muddaPage - 1 : muddaPage;
      }
    });
  }

  _getQuotePost(BuildContext context) async {
    Api.get.call(context,
        method: "quote-or-activity/index",
        param: {"page": quotePage.toString(), "post_of": "quote"},
        isLoading: false, onResponseSuccess: (Map object) {
      var result = QuotePostModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        profileController!.quotePostPath.value = result.path!;
        profileController!.quoteProfilePath.value = result.userpath!;
        profileController!.quotePostListForProfile.addAll(result.data!);
      } else {
        quotePage = quotePage > 1 ? quotePage - 1 : quotePage;
      }
    });
  }

  _getActivityPost(BuildContext context) async {
    Api.get.call(context,
        method: "quote-or-activity/index",
        param: {"page": activityPage.toString(), "post_of": "activity"},
        isLoading: false, onResponseSuccess: (Map object) {
      var result = QuotePostModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        profileController!.quotePostPath.value = result.path!;
        profileController!.quoteProfilePath.value = result.userpath!;
        profileController!.activityPostList.addAll(result.data!);
      } else {
        activityPage = activityPage > 1 ? activityPage - 1 : activityPage;
      }
    });
  }

  _getSurveyPost(BuildContext context) async {
    Api.get.call(context,
        method: "initiate-survey/index",
        param: {"page": surveyPage.toString()},
        isLoading: false, onResponseSuccess: (Map object) {
      var result = InitialSurveyPostModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        profileController!.initialSurveyPostList.addAll(result.data!);
      } else {
        surveyPage = surveyPage > 1 ? surveyPage - 1 : surveyPage;
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

  void showFullProfileDialog(BuildContext buildContext) {
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.only(
                  top: ScreenUtil().setSp((ScreenUtil().screenHeight / 3) / 2),
                  bottom:
                      ScreenUtil().setSp((ScreenUtil().screenHeight / 3) / 2),
                  left: ScreenUtil().setWidth(26),
                  right: ScreenUtil().setWidth(26)),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStates) {
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setSp(25)),
                      child: userProfileUpdateController!
                                  .userProfile.value.profile !=
                              null
                          ? CachedNetworkImage(
                              imageUrl:
                                  "${userProfileUpdateController!.userProfilePath}${userProfileUpdateController!.userProfile.value.profile}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.2),
                                        blurRadius: 5.0,
                                        offset: const Offset(0, 5))
                                  ],
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ScreenUtil().setSp(
                                          10)) //                 <--- border radius here
                                      ),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : userProfileUpdateController!
                                  .userProfileImage.value.isNotEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setSp(10))),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 4),
                                          color: black25,
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(File(
                                              userProfileUpdateController!
                                                  .userProfileImage.value)))))
                              : Container(
                                  child: Center(
                                    child: Text(
                                        userProfileUpdateController!.userProfile
                                                    .value.fullname !=
                                                null
                                            ? userProfileUpdateController!
                                                .userProfile.value.fullname![0]
                                                .toUpperCase()
                                            : "",
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(30),
                                            color: black)),
                                  ),
                                  decoration: BoxDecoration(
                                    color: white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(.2),
                                          blurRadius: 5.0,
                                          offset: const Offset(0, 5))
                                    ],
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setSp(10))),
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                ),
                    ),
                  ],
                );
              }));
        });
  }

  _getProfile(BuildContext context) async {
    userProfileUpdateController!.isLoading.value = true;
    Api.get.call(context,
        method: "user/${Get.parameters['id'] ?? userDetail!.sId}",
        param: {
          "_id": Get.parameters['id'] ?? userDetail!.sId,
        },
        isLoading: false, onResponseSuccess: (Map object) {
      userProfileUpdateController!.isLoading.value = false;
      print(object);
      var result = UserProfileModel.fromJson(object);
      userProfileUpdateController!.userProfilePath.value = result.path!;
      userProfileUpdateController!.userProfile.value = result.data!;
      userProfileUpdateController!.userProfile.value.amIFollowing!;
      profileController!.isProfileMuddaLoading.value = true;
      Api.get.call(context,
          method: "mudda/my-engagement",
          param: {"user_id": Get.parameters['id'] ?? userDetail!.sId},
          isLoading: false, onResponseSuccess: (Map object) {
        profileController!.isProfileMuddaLoading.value = false;
        var result = MuddaPostModel.fromJson(object);
        if (result.data!.isNotEmpty) {
          profileController!.muddaProfilePath.value = result.path!;
          profileController!.muddaPostList.clear();
          profileController!.muddaPostList.addAll(result.data!);
        }
      });
      profileController!.quotePostListForProfile.clear();
      Api.get.call(context,
          method: "quote-or-activity/index",
          param: {"page": "1", "post_of": "quote"},
          isLoading: false, onResponseSuccess: (Map object) {
        var result = QuotePostModel.fromJson(object);
        if (result.data!.isNotEmpty) {
          profileController!.quotePostPath.value = result.path!;
          profileController!.quoteProfilePath.value = result.userpath!;
          profileController!.quotePostListForProfile.addAll(result.data!);
        }
        profileController!.activityPostList.clear();
        Api.get.call(context,
            method: "quote-or-activity/index",
            param: {"page": "1", "post_of": "activity"},
            isLoading: false, onResponseSuccess: (Map object) {
          var result = QuotePostModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            profileController!.quotePostPath.value = result.path!;
            profileController!.quoteProfilePath.value = result.userpath!;
            profileController!.activityPostList.addAll(result.data!);
          }
          Api.get.call(context,
              method: "initiate-survey/index",
              param: {"page": "1"},
              isLoading: false, onResponseSuccess: (Map object) {
            var result = InitialSurveyPostModel.fromJson(object);
            if (result.data!.isNotEmpty) {
              profileController!.initialSurveyPostList.clear();
              profileController!.initialSurveyPostList.addAll(result.data!);
            }
          });
        });
      });
    });
  }
}
