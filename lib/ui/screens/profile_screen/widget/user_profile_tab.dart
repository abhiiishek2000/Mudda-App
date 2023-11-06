import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/InitialSurveyPostModel.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/PostForMuddaModel.dart';
import 'package:mudda/model/QuotePostModel.dart';
import 'package:mudda/model/UserProfileModel.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/mudda/view/mudda_details_screen.dart';
import 'package:mudda/ui/screens/profile_screen/controller/profile_controller.dart';
import 'package:mudda/ui/screens/profile_screen/widget/leaderBoard_loading_view.dart';
import 'package:mudda/ui/screens/profile_screen/widget/profile_mudda_loading_view.dart';
import 'package:mudda/ui/screens/quotes_list/view/quotes_list.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../../../shared/image_compression.dart';
import '../view/profile_screen.dart';

class UserProfileTab extends GetView {
  String? userId;

  UserProfileTab({Key? key, this.userId}) : super(key: key);
  UserProfileUpdateController? userProfileUpdateController;
  ProfileController? profileController;
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  ScrollController muddaScrollController = ScrollController();
  ScrollController memberOfScrollController = ScrollController();
  int memberPage = 1;
  int muddaPage = 1;
  int quotePage = 1;
  int activityPage = 1;
  int surveyPage = 1;
  bool isVerifiedProfie = false;
  static LocalStorage storage = LocalStorage('user-profile');

  @override
  Widget build(BuildContext context) {
    profileController = Get.find<ProfileController>();
    userProfileUpdateController = Get.find<UserProfileUpdateController>();
    memberPage = 1;
    muddaPage = 1;
    quotePage = 1;
    activityPage = 1;
    surveyPage = 1;

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

    getProfileFromCache(context).then((value) {
      if(value !=null){
        userProfileUpdateController!.userProfile.value=value;
      }else{
        _getProfile(context,userId);
      }
    });
    _getProfile(context,userId);
    log('-=- isBlock -=- ${userProfileUpdateController!.startTime.value}');
    log('-=- isBlock -=- ${userProfileUpdateController!.isBlock.value}');

    return Obx(
      () => RefreshIndicator(
        onRefresh: () {
          return _getProfile(context, userId);
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
                          InkWell(
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
                                          height: ScreenUtil().setSp(95),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(.2),
                                                  blurRadius: 5.0,
                                                  offset: const Offset(0, 5))
                                            ],
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(ScreenUtil().setSp(
                                                    47.5)) //                 <--- border radius here
                                                ),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        right: 10,
                                        child: Visibility(
                                          visible: userProfileUpdateController!
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
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(30),
                                                color: black)),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 10,
                                        child: Visibility(
                                          visible: userProfileUpdateController!
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
                                            color: Colors.black.withOpacity(.2),
                                            blurRadius: 5.0,
                                            offset: const Offset(0, 5))
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 2),
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
                            userProfileUpdateController!
                                    .userProfile.value.profession ??
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
                                              .userProfile.value.countNetwork ??
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
                                        profileController!.isTabSelected.value =
                                            0;
                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () {
                                          muddaScrollController.jumpTo(
                                              muddaScrollController
                                                  .position.maxScrollExtent);
                                        });
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
                                            .userProfile.value.countFollowers ??
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
                                            .userProfile.value.countFollowing ??
                                        0),
                                    title: "Following",
                                    onTap: () {
                                      AcceptUserDetail user =
                                          userProfileUpdateController!
                                              .userProfile.value;
                                      user.followerIndex = 1;
                                      Map<String, String>? parameters = {
                                        "user": jsonEncode(user)
                                      };
                                      Get.toNamed(
                                          RouteConstants.followerInfoScreen,
                                          parameters: parameters);
                                    },
                                  ),
                                ],
                              )),
                      ],
                    )
                  ],
                ),
              ),
              // userProfileUpdateController!.userProfile.value.isBlocked == true
              Obx(
                () => userProfileUpdateController!.isBlock.value == true
                    ? Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Your Profile is blocked for ${intToTimeLeft(userProfileUpdateController!.startTime.value)}",
                          // "${intToTimeLeft(userProfileUpdateController!.startTime.value)}",
                          style: size14_M_semiBold(
                            textColor: Colors.red,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              const SizedBox(
                height: 20,
              ),
              whiteDivider(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*Visibility(child: Row(
                      children: [
                        orgBox(
                            title: "Create Org",
                            icon: AppIcons.followersIcon,
                            onTap: () {
                              Get.toNamed(RouteConstants.orgBuilder);
                            }),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          child: const Center(child: Text("?")),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: colorGrey)),
                        ),
                      ],
                    ),visible: AppPreference().getString(PreferencesKey.orgUserId).isEmpty),

                    const Spacer(),*/
                    orgBox(
                        title: "Edit Profile",
                        icon: AppIcons.editProfile,
                        onTap: () {
                          Get.toNamed(RouteConstants.userProfileEdit);
                        }),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ReadMoreText(
                  userProfileUpdateController!.userProfile.value.description ??
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
              if (userProfileUpdateController!
                          .userProfile.value.memberOfOrganization !=
                      null &&
                  userProfileUpdateController!
                          .userProfile.value.memberOfOrganization!.length >
                      0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(
                        "Members of:",
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
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: List.generate(
                        userProfileUpdateController!
                                    .userProfile.value.memberOfOrganization !=
                                null
                            ? userProfileUpdateController!
                                .userProfile.value.memberOfOrganization!.length
                            : 0, (index) {
                      return InkWell(
                        onTap: () {
                          if (userProfileUpdateController!
                                      .userProfile.value.memberOfOrganization!
                                      .elementAt(index)
                                      .organizationDetail!
                                      .sId ==
                                  AppPreference()
                                      .getString(PreferencesKey.userId) ||
                              userProfileUpdateController!
                                      .userProfile.value.memberOfOrganization!
                                      .elementAt(index)
                                      .organizationDetail!
                                      .sId ==
                                  AppPreference()
                                      .getString(PreferencesKey.orgUserId)) {
                            Get.toNamed(RouteConstants.profileScreen);
                          } else if (userProfileUpdateController!
                                  .userProfile.value.memberOfOrganization!
                                  .elementAt(index)
                                  .organizationDetail!
                                  .userType ==
                              "user") {
                            Map<String, String>? parameters = {
                              "userDetail": jsonEncode(
                                  userProfileUpdateController!
                                      .userProfile.value.memberOfOrganization!
                                      .elementAt(index)
                                      .organizationDetail!)
                            };
                            Get.toNamed(RouteConstants.otherUserProfileScreen,
                                parameters: parameters);
                          } else {
                            Map<String, String>? parameters = {
                              "userDetail": jsonEncode(
                                  userProfileUpdateController!
                                      .userProfile.value.memberOfOrganization!
                                      .elementAt(index)
                                      .organizationDetail!)
                            };
                            Get.toNamed(RouteConstants.otherOrgProfileScreen,
                                parameters: parameters);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: userProfileUpdateController!.userProfile.value
                                          .memberOfOrganization!
                                          .elementAt(index)
                                          .organizationDetail !=
                                      null &&
                                  userProfileUpdateController!.userProfile.value
                                          .memberOfOrganization!
                                          .elementAt(index)
                                          .organizationDetail!
                                          .profile !=
                                      null
                              ? SizedBox(
                                  width: ScreenUtil().setSp(40),
                                  height: ScreenUtil().setSp(40),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${userProfileUpdateController!.userProfilePath}${userProfileUpdateController!.userProfile.value.memberOfOrganization!.elementAt(index).organizationDetail!.profile}",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: ScreenUtil().setSp(40),
                                      height: ScreenUtil().setSp(40),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: userProfileUpdateController!
                                                      .userProfile
                                                      .value
                                                      .memberOfOrganization!
                                                      .elementAt(index)
                                                      .role
                                                      ?.toLowerCase() ==
                                                  'creator'
                                              ? color0060FF
                                              : userProfileUpdateController!
                                                          .userProfile
                                                          .value
                                                          .memberOfOrganization!
                                                          .elementAt(index)
                                                          .role
                                                          ?.toLowerCase() ==
                                                      'co-founder'
                                                  ? color35bedc
                                                  : userProfileUpdateController!
                                                              .userProfile
                                                              .value
                                                              .memberOfOrganization!
                                                              .elementAt(index)
                                                              .role
                                                              ?.toLowerCase() ==
                                                          'speaker'
                                                      ? colorF1B008
                                                      : userProfileUpdateController!
                                                                  .userProfile
                                                                  .value
                                                                  .memberOfOrganization!
                                                                  .elementAt(
                                                                      index)
                                                                  .role
                                                                  ?.toLowerCase() ==
                                                              'admin'
                                                          ? color606060
                                                          : colorWhite,
                                        ),
                                        color: colorWhite,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.2),
                                              blurRadius: 5.0,
                                              offset: const Offset(0, 5))
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(ScreenUtil().setSp(
                                                4)) //                 <--- border radius here
                                            ),
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
                                    border: Border.all(
                                      width: 2,
                                      color: userProfileUpdateController!
                                                  .userProfile
                                                  .value
                                                  .memberOfOrganization!
                                                  .elementAt(index)
                                                  .role
                                                  ?.toLowerCase() ==
                                              'creator'
                                          ? color0060FF
                                          : userProfileUpdateController!
                                                      .userProfile
                                                      .value
                                                      .memberOfOrganization!
                                                      .elementAt(index)
                                                      .role
                                                      ?.toLowerCase() ==
                                                  'co-founder'
                                              ? color35bedc
                                              : userProfileUpdateController!
                                                          .userProfile
                                                          .value
                                                          .memberOfOrganization!
                                                          .elementAt(index)
                                                          .role
                                                          ?.toLowerCase() ==
                                                      'speaker'
                                                  ? colorF1B008
                                                  : userProfileUpdateController!
                                                              .userProfile
                                                              .value
                                                              .memberOfOrganization!
                                                              .elementAt(index)
                                                              .role
                                                              ?.toLowerCase() ==
                                                          'admin'
                                                      ? color606060
                                                      : colorWhite,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(ScreenUtil().setSp(
                                            4)) //                 <--- border radius here
                                        ),
                                  ),
                                  child: Center(
                                    child: Text(
                                        userProfileUpdateController!.userProfile
                                                    .value.memberOfOrganization!
                                                    .elementAt(index)
                                                    .organizationDetail !=
                                                null
                                            ? userProfileUpdateController!
                                                .userProfile
                                                .value
                                                .memberOfOrganization!
                                                .elementAt(index)
                                                .organizationDetail!
                                                .fullname![0]
                                                .toUpperCase()
                                            : "",
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
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: InkWell(
                            onTap: () {
                              debugPrint("isTabSelected");
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
                                  color:
                                      profileController!.isTabSelected.value ==
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
                                if (muddaPost.leaders != null &&
                                    muddaPost.leaders!.isNotEmpty) {
                                  if (AppPreference()
                                          .getString(PreferencesKey.userId) !=
                                      muddaPost.leaders!
                                          .elementAt(0)
                                          .acceptUserDetail!
                                          .sId) {
                                    created =
                                        "Created By - ${muddaPost.leaders!.elementAt(0).acceptUserDetail!.fullname}";
                                  }
                                } else if (muddaPost.leaders!.length == 0) {
                                  created = "Created By - You";
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
                                    /*if((muddaPost.initialScope!.toLowerCase() == "district" && muddaPost.leadersCount! >= 10) ||
                                    (muddaPost.initialScope!.toLowerCase() == "state" && muddaPost.leadersCount! >= 15 && muddaPost.uniqueCity! >= 3) ||
                                    (muddaPost.initialScope!.toLowerCase() == "country" && muddaPost.leadersCount! >= 20 && muddaPost.uniqueState! >= 3) ||
                                    (muddaPost.initialScope!.toLowerCase() == "world" && muddaPost.leadersCount! >= 25 && muddaPost.uniqueCountry! >= 5)) {
                                  muddaNewsController.muddaPost.value =
                                      muddaPost;
                                  Get.toNamed(
                                      RouteConstants.muddaDetailsScreen);
                                }else{
                                  Map<String, String>? parameters = {
                                    "muddaId":muddaPost.sId!
                                  };
                                  Get.toNamed(RouteConstants.shareMuddaScreen,parameters: parameters);
                                }*/
                                    // Map<String, String>? parameters = {
                                    //   "muddaId": muddaPost.sId!
                                    // };
                                    // Get.toNamed(RouteConstants.shareMuddaScreen,
                                    //     parameters: parameters);
                                    if (muddaPost.isVerify == 1) {
                                      muddaNewsController.muddaPost.value =
                                          muddaPost;
                                      Get.toNamed(
                                          RouteConstants.muddaDetailsScreen);
                                    } else {
                                      muddaNewsController.tabController.index =
                                          2;
                                      Get.back();
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
                                            borderRadius: BorderRadius.circular(
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
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(12),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: black)),
                                                SizedBox(
                                                  height:
                                                      ScreenUtil().setSp(10),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                                color: black)),
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
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              12),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: black),
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
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    fontWeight: FontWeight.w400,
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
                                                    textColor: colorDarkBlack)),
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setSp(10),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: colorDarkBlack),
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
                      : profileController!.isTabSelected.value == 3
                          ? InitiateSurveyPostGrid(profileController!)
                          : QuotesList(profileController!))
            ],
          ),
        ),
      ),
    );
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
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding:
                            EdgeInsets.only(right: ScreenUtil().setWidth(23)),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            uploadProfilePic(buildContext);
                          },
                          child: CircleAvatar(
                            radius: ScreenUtil().setSp(25),
                            backgroundColor: lightGray,
                            child: CircleAvatar(
                              radius: ScreenUtil().setSp(24),
                              backgroundColor: white,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: lightGray,
                                size: ScreenUtil().radius(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }));
        });
  }

  void uploadPic(BuildContext context, String path) async {
    var formData = FormData.fromMap({
      "_id": AppPreference().getString(PreferencesKey.userId),
    });
    var video =
        await MultipartFile.fromFile(path, filename: path.split('/').last);
    formData.files.addAll([
      MapEntry("profile", video),
    ]);
    Api.uploadPost.call(context,
        method: "user/profile-update",
        param: formData,
        isLoading: true, onResponseSuccess: (Map object) {
      var snackBar = const SnackBar(
        content: Text('Updated'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      var result = UserProfileModel.fromJson(object);
      userProfileUpdateController!.userProfilePath.value = result.path!;
      userProfileUpdateController!.userProfile.value = result.data!;
      if (result.data!.profile != null) {
        AppPreference()
            .setString(PreferencesKey.profile, result.data!.profile!);
        AppPreference().setString(PreferencesKey.profilePath, result.path!);
      }
    });
  }

  Future uploadProfilePic(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    try {
                      final pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                          imageQuality: ImageCompression.imageQuality);
                      if (pickedFile != null) {
                        _cropImage(File(pickedFile.path)).then((value) async {
                          userProfileUpdateController!.userProfileImage.value =
                              value.path;
                          uploadPic(context, value.path);
                        });
                      }
                      ;
                    } on PlatformException catch (e) {
                      print('FAILED $e');
                    }
                    Navigator.of(bc).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  try {
                    final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        imageQuality: ImageCompression.imageQuality);
                    if (pickedFile != null) {
                      _cropImage(File(pickedFile.path)).then((value) async {
                        userProfileUpdateController!.userProfileImage.value =
                            value.path;
                        uploadPic(context, value.path);
                      });
                    }
                  } on PlatformException catch (e) {
                    print('FAILED $e');
                  }
                  Navigator.of(bc).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File> _cropImage(File profileImageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: profileImageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          )
        ]);
    return File(croppedFile!.path);
  }

  _getMuddaPost(BuildContext context) async {
    Api.get.call(context,
        method: "mudda/my-engagement",
        param: {
          "page": muddaPage.toString(),
          "user_id": AppPreference().getString(PreferencesKey.userId)
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
        param: {
          "page": quotePage.toString(),
          "post_of": "quote",
          "user_id": AppPreference().getString(PreferencesKey.userId)
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = QuotePostModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        profileController!.quoteProfilePath.value = result.userpath!;
        profileController!.quotePostPath.value = result.path!;
        profileController!.quotePostListForProfile.addAll(result.data!);
      } else {
        quotePage = quotePage > 1 ? quotePage - 1 : quotePage;
      }
    });
  }

  _getActivityPost(BuildContext context) async {
    Api.get.call(context,
        method: "quote-or-activity/index",
        param: {
          "page": activityPage.toString(),
          "post_of": "activity",
          "user_id": AppPreference().getString(PreferencesKey.userId)
        },
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
        param: {
          "page": surveyPage.toString(),
          "user_id": AppPreference().getString(PreferencesKey.userId)
        },
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

  String intToTimeLeft(int value) {
    int d, h, m;

    d = value ~/ (24 * 3600);

    h = (value - (d * 24 * 3600)) ~/ 3600;

    // h = value ~/ 3600;

    m = ((value - ((d * 24 * 3600) + (h * 3600)))) ~/ 60;

    // s = value - (h * 3600) - (m * 60);

    String result =
        "${d < 10 ? "${d}d" : "${d}d"} ${h < 10 ? "${h}h" : "${h}h"} ${m < 10 ? "${m}m" : "${m}m"}";
    // String result = "$m:$s";
    // String result = "$h:$m:$s";

    return result;
  }
  Future<AcceptUserDetail?> getProfileFromCache(BuildContext context) async {
    await storage.ready;
    Map<String, dynamic>? data = storage.getItem('user-profile');

    if (data != null) {
      AcceptUserDetail user = AcceptUserDetail.fromJson(data);
      // _getProfile(context,userId);
      return user;//to indicate post is pulled from cache

    } else {
      return null;
      // _getProfile(context,userId);
    }
  }
  _getProfile(BuildContext context, String? userId) async {
    log("-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=--=--");
    userProfileUpdateController!.isLoading.value = true;
    Api.get.call(context,
        method: "user/${AppPreference().getString(PreferencesKey.userId)}",
        param: {
          "_id": userId ?? AppPreference().getString(PreferencesKey.userId),
          "page": memberPage.toString()
        },
        isLoading: false, onResponseSuccess: (Map object) {
      userProfileUpdateController!.isLoading.value = false;
      log("-=-=- object $object");
      var result = UserProfileModel.fromJson(object);
      print(
          "=========================================Profile Data===========================================================");
      print(jsonEncode(result.data));
      if (result.data!.blockedTill != null) {
        var currentTime = DateTime.now();
        var diff = DateTime.parse(result.data!.blockedTill.toString())
            .difference(currentTime)
            .inSeconds;
        var days = currentTime
            .difference(DateTime.parse(result.data!.blockedTill.toString()))
            .inDays;
        var min = currentTime
            .difference(DateTime.parse(result.data!.blockedTill.toString()))
            .inMinutes;
        var hours = currentTime
            .difference(DateTime.parse(result.data!.blockedTill.toString()))
            .inHours;
        userProfileUpdateController!.days.value =
            "${days.toString()} ${hours.toString()} ${min.toString()}";
        userProfileUpdateController!.startTime.value = diff;
        log("-=-=- timer -=-=${days}d --=");
      }

      userProfileUpdateController!.userProfilePath.value = result.path!;
      userProfileUpdateController!.userProfile.value = result.data!;
      saveUserProfile(userProfileUpdateController!.userProfile.value);

      log("-=- isBlock abc -=-= ${result.data!.blockedTill} -=- ${result.data!.isBlocked!}");

      userProfileUpdateController!.isBlock.value = result.data!.isBlocked!;
      if (userProfileUpdateController!.timer != null) {
        userProfileUpdateController!.timer!.cancel();
        userProfileUpdateController!.timer = null;
      }
      userProfileUpdateController!.startTimer();
      AppPreference()
          .setString(PreferencesKey.fullName, result.data!.fullname!);
      if (result.data!.profile != null) {
        AppPreference()
            .setString(PreferencesKey.profile, result.data!.profile!);
        AppPreference().setString(PreferencesKey.profilePath, result.path!);
      }
      if (result.data!.city != null) {
        AppPreference().setString(PreferencesKey.city, result.data!.city!);
        AppPreference().setString(PreferencesKey.state, result.data!.state!);
        AppPreference()
            .setString(PreferencesKey.country, result.data!.country!);
      }
      AppPreference().setString(PreferencesKey.countFollowing,
          result.data!.countFollowing.toString());
      profileController!.isProfileMuddaLoading.value = true;
      Api.get.call(context,
          method: "mudda/my-engagement",
          param: {"user_id": AppPreference().getString(PreferencesKey.userId)},
          isLoading: false, onResponseSuccess: (Map object) {
        profileController!.isProfileMuddaLoading.value = false;
        var result = MuddaPostModel.fromJson(object);
        if (result.data!.isNotEmpty) {
          profileController!.muddaProfilePath.value = result.path!;
          profileController!.muddaPostList.clear();
          profileController!.muddaPostList.addAll(result.data!);
        }
        profileController!.quotePostListForProfile.clear();
        Api.get.call(context,
            method: "quote-or-activity/index",
            param: {
              "page": "1",
              "post_of": "quote",
              "user_id": AppPreference().getString(PreferencesKey.userId)
            },
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
              param: {
                "page": "1",
                "post_of": "activity",
                "user_id": AppPreference().getString(PreferencesKey.userId)
              },
              isLoading: false, onResponseSuccess: (Map object) {
            var result = QuotePostModel.fromJson(object);
            if (result.data!.isNotEmpty) {
              profileController!.quotePostPath.value = result.path!;
              profileController!.quoteProfilePath.value = result.userpath!;
              profileController!.activityPostList.addAll(result.data!);
            }
            Api.get.call(context,
                method: "initiate-survey/index",
                param: {
                  "page": "1",
                  "user_id": AppPreference().getString(PreferencesKey.userId)
                },
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
    });
  }
  void saveUserProfile(AcceptUserDetail user) async{
    await storage.setItem("user-profile", user);
  }
  _getMember(BuildContext context) async {
    Api.get.call(context,
        method: "user/${AppPreference().getString(PreferencesKey.userId)}",
        param: {
          "_id": AppPreference().getString(PreferencesKey.userId),
          "page": memberPage.toString()
        },
        isLoading: false, onResponseSuccess: (Map object) {
      print(object);
      var result = UserProfileModel.fromJson(object);
      AppPreference().setString(PreferencesKey.city, result.data!.city!);
      AppPreference().setString(PreferencesKey.state, result.data!.state!);
      AppPreference().setString(PreferencesKey.country, result.data!.country!);
      userProfileUpdateController!.userProfilePath.value = result.path!;
      if (result.data!.memberOfOrganization!.isNotEmpty) {
        userProfileUpdateController!.userProfile.value = result.data!;
      } else {
        memberPage = memberPage > 1 ? memberPage - 1 : memberPage;
      }
    });
  }
}

class PostGrid extends StatelessWidget {
  ProfileController profileController;

  PostGrid(this.profileController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
          padding: EdgeInsets.only(bottom: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: profileController.activityPostList.length,
          itemBuilder: (followersContext, index) {
            Quote quote = profileController.activityPostList.elementAt(index);
            return InkWell(
                onTap: () {
                  // muddaNewsController.muddaPost.value = muddaPost;
                  Get.toNamed(RouteConstants.singleActivityPost,
                      arguments: quote);
                },
                child: Stack(fit: StackFit.expand, children: [
                  quote.gallery != null && quote.gallery!.isNotEmpty
                      ? Container(
                          child: CachedNetworkImage(
                            imageUrl:
                                "${profileController.quotePostPath.value}${quote.gallery![0].file}",
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          child: const Center(
                              child: Text(
                            'No image',
                            style: TextStyle(color: white),
                          )),
                          color: blackGray.withOpacity(0.5),
                        ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Row(
                      children: [
                        Text(
                          NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol:
                                '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(quote.likersCount),
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w400,
                              color: white,
                              fontSize: ScreenUtil().setSp(10)),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Image.asset(AppIcons.likeHand, height: 15, width: 15),
                      ],
                    ),
                  )
                ])
                // Column(
                //   children: [
                //     GridView.count(
                //       crossAxisCount: 4,
                //       shrinkWrap: true,
                //       mainAxisSpacing: 5,
                //       crossAxisSpacing: 10,
                //       children: List.generate(
                //         quote.gallery!.length,
                //         (index) {
                //           Gallery gallery = quote.gallery!.elementAt(index);
                //           return SizedBox(
                //             height: ScreenUtil().setSp(85),
                //             child: Padding(
                //               padding:
                //                   EdgeInsets.only(bottom: ScreenUtil().setSp(11)),
                //               child: Stack(
                //                 children: [
                //                   ClipRRect(
                //                     borderRadius: BorderRadius.circular(
                //                         ScreenUtil().setSp(8)),
                //                     child: SizedBox(
                //                       height: ScreenUtil().setSp(70),
                //                       width: ScreenUtil().setSp(70),
                //                       child: CachedNetworkImage(
                //                         imageUrl:
                //                             "${profileController.quotePostPath.value}${gallery.file}",
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                   ),
                //                   Positioned(
                //                     bottom: 0,
                //                     right: 0,
                //                     child: Row(
                //                       children: [
                //                         Text(
                //                           NumberFormat.compactCurrency(
                //                             decimalDigits: 0,
                //                             symbol:
                //                                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                //                           ).format(quote.likersCount),
                //                           style: GoogleFonts.nunitoSans(
                //                               fontWeight: FontWeight.w400,
                //                               fontSize: ScreenUtil().setSp(10)),
                //                         ),
                //                         const SizedBox(
                //                           width: 5,
                //                         ),
                //                         Image.asset(AppIcons.likeHand,
                //                             height: 15, width: 15),
                //                       ],
                //                     ),
                //                   )
                //                 ],
                //               ),
                //             ),
                //           );
                //         },
                //       ),
                //       physics: const NeverScrollableScrollPhysics(),
                //     ),
                //     SizedBox(
                //       height: ScreenUtil().setSp(8),
                //     ),
                //     Row(
                //       children: [
                //         Expanded(
                //           child: Text(quote.hashtags!.join(','),
                //               style: size10_M_normal(textColor: colorDarkBlack)),
                //         ),
                //         SizedBox(
                //           width: ScreenUtil().setSp(10),
                //         ),
                //         Row(
                //           children: [
                //             Container(
                //               padding: const EdgeInsets.all(2),
                //               decoration: const BoxDecoration(
                //                   shape: BoxShape.circle, color: colorDarkBlack),
                //             ),
                //             SizedBox(
                //               width: ScreenUtil().setSp(5),
                //             ),
                //             Text(
                //                 "${quote.user!.city ?? ""}, ${quote.user!.state ?? ""}, ${quote.user!.country ?? ""}",
                //                 style:
                //                     size12_M_normal(textColor: colorDarkBlack)),
                //           ],
                //         ),
                //         SizedBox(
                //           width: ScreenUtil().setSp(10),
                //         ),
                //         Container(
                //           padding: const EdgeInsets.all(2),
                //           decoration: const BoxDecoration(
                //               shape: BoxShape.circle, color: colorDarkBlack),
                //         ),
                //         SizedBox(
                //           width: ScreenUtil().setSp(5),
                //         ),
                //         Text(convertToAgo(DateTime.parse(quote.createdAt!)),
                //             style: size10_M_normal(textColor: colorDarkBlack)),
                //       ],
                //     ),
                //     SizedBox(
                //       height: ScreenUtil().setSp(4),
                //     ),
                //     Container(
                //       height: ScreenUtil().setSp(1),
                //       color: Colors.white,
                //     ),
                //     const SizedBox(
                //       height: 5,
                //     ),
                //   ],
                // ),
                );
          }),
    );
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
}

class InitiateSurveyPostGrid extends StatelessWidget {
  ProfileController profileController;

  InitiateSurveyPostGrid(this.profileController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: profileController.initialSurveyPostList.length,
        itemBuilder: (followersContext, index) {
          InitialSurvey initialSurvey =
              profileController.initialSurveyPostList.elementAt(index);
          return InkWell(
            onTap: () {
              showDialog(
                context: Get.context as BuildContext,
                barrierColor: Colors.transparent,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setSp(16))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setSp(20),
                                left: ScreenUtil().setSp(16),
                                right: ScreenUtil().setSp(16)),
                            child: Text(initialSurvey.title!,
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: ScreenUtil().setSp(14),
                                    color: black)),
                          ),
                          RadioListTile(
                            title:
                                Text(initialSurvey.questionOption![0].option!),
                            value: "1",
                            groupValue: "1",
                            onChanged: (value) {},
                          ),
                          RadioListTile(
                            title:
                                Text(initialSurvey.questionOption![1].option!),
                            value: "1",
                            groupValue: "2",
                            onChanged: (value) {},
                          ),
                          RadioListTile(
                            title:
                                Text(initialSurvey.questionOption![2].option!),
                            value: "1",
                            groupValue: "3",
                            onChanged: (value) {},
                          ),
                          RadioListTile(
                            title:
                                Text(initialSurvey.questionOption![3].option!),
                            value: "1",
                            groupValue: "4",
                            onChanged: (value) {},
                          ),
                          RadioListTile(
                            title:
                                Text(initialSurvey.questionOption![0].option!),
                            value: "1",
                            groupValue: "5",
                            onChanged: (value) {},
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setSp(16),
                                right: ScreenUtil().setSp(16),
                                bottom: ScreenUtil().setSp(11)),
                            child: const Divider(
                              color: grey,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              color: white,
              padding: EdgeInsets.only(
                  top: ScreenUtil().setSp(11),
                  left: ScreenUtil().setSp(18),
                  right: ScreenUtil().setSp(18),
                  bottom: ScreenUtil().setSp(8)),
              margin: EdgeInsets.only(bottom: ScreenUtil().setSp(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(initialSurvey.title!,
                      style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(14),
                          color: black)),
                  SizedBox(
                    height: ScreenUtil().setSp(13),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(initialSurvey.initialScope!,
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil().setSp(12),
                              color: blackGray)),
                      Text(
                          convertToAgo(
                              DateTime.parse(initialSurvey.createdAt!)),
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil().setSp(12),
                              color: blackGray)),
                      Text(
                          "${NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol:
                                '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(initialSurvey.iV)} votes",
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil().setSp(12),
                              color: blackGray)),
                    ],
                  )
                ],
              ),
            ),
          );
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
}
