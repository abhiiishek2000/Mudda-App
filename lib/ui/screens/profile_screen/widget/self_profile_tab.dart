import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
import 'package:mudda/core/utils/size_config.dart';
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
import 'package:mudda/ui/screens/profile_screen/controller/profile_controller.dart';
import 'package:mudda/ui/screens/profile_screen/widget/profile_mudda_loading_view.dart';
import 'package:mudda/ui/screens/quotes_list/view/quotes_list.dart';
import 'package:readmore/readmore.dart';

import '../view/profile_screen.dart';
import 'leaderBoard_loading_view.dart';

class SelfProfileTab extends GetView {
  String? userId;

  SelfProfileTab({Key? key, this.userId}) : super(key: key);
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
  static LocalStorage storage = LocalStorage('org-profile');


  void saveOrgProfile(AcceptUserDetail user) async {
    await storage.setItem("org-profile", user);
  }

  @override
  Widget build(BuildContext context) {
    profileController = Get.find<ProfileController>();
    userProfileUpdateController = Get.find<UserProfileUpdateController>();
    if (AppPreference()
        .getString(PreferencesKey.orgUserId)
        .isNotEmpty) {
      getOrgProfileFromCache(context).then((value) {
        if(value !=null){
          userProfileUpdateController!.orgUserProfile.value=value;
        }else{
          userProfileUpdateController!.isLoading.value = true;
          Api.get.call(context,
              method: "user/${AppPreference().getString(PreferencesKey.orgUserId)}",
              param: {
                "_id": AppPreference().getString(PreferencesKey.orgUserId),
              },
              isLoading: false, onResponseSuccess: (Map object) {
                userProfileUpdateController!.isLoading.value = false;
                debugPrint(object.toString());
                var result = UserProfileModel.fromJson(object);
                userProfileUpdateController!.userProfilePath.value = result.path!;
                userProfileUpdateController!.orgUserProfile.value = result.data!;
                saveOrgProfile(userProfileUpdateController!.orgUserProfile.value);
                /* userProfileUpdateController!.orgUserProfile.value.organizationMember!.forEach((element) {
          if(''){}
        });*/
                profileController!.isProfileMuddaLoading.value = true;
                Api.get.call(context,
                    method: "mudda/my-engagement",
                    param: {
                      "user_id": AppPreference().getString(PreferencesKey.orgUserId)
                    },
                    isLoading: false, onResponseSuccess: (Map object) {
                      profileController!.isProfileMuddaLoading.value = true;
                      var result = MuddaPostModel.fromJson(object);
                      if (result.data!.isNotEmpty) {
                        profileController!.muddaProfilePath.value = result.path!;
                        profileController!.orgMuddaPostList.clear();
                        profileController!.orgMuddaPostList.addAll(result.data!);
                      }
                      profileController!.quotePostListForProfile.clear();
                      Api.get.call(context,
                          method: "quote-or-activity/index",
                          param: {
                            "page": "1",
                            "post_of": "quote",
                            "user_id": AppPreference().getString(
                                PreferencesKey.orgUserId)
                          },
                          isLoading: false, onResponseSuccess: (Map object) {
                            var result = QuotePostModel.fromJson(object);
                            if (result.data!.isNotEmpty) {
                              profileController!.quotePostPath.value = result.path!;
                              profileController!.quoteProfilePath.value =
                              result.userpath!;
                              profileController!.quotePostListForProfile.addAll(
                                  result.data!);
                            }
                            profileController!.activityPostList.clear();
                            Api.get.call(context,
                                method: "quote-or-activity/index",
                                param: {
                                  "page": "1",
                                  "post_of": "activity",
                                  "user_id": AppPreference().getString(
                                      PreferencesKey.orgUserId)
                                },
                                isLoading: false, onResponseSuccess: (Map object) {
                                  var result = QuotePostModel.fromJson(object);
                                  if (result.data!.isNotEmpty) {
                                    profileController!.quotePostPath.value =
                                    result.path!;
                                    profileController!.quoteProfilePath.value =
                                    result.userpath!;
                                    profileController!.activityPostList.addAll(
                                        result.data!);
                                  }
                                  Api.get.call(context,
                                      method: "initiate-survey/index",
                                      param: {
                                        "page": "1",
                                        "user_id":
                                        AppPreference().getString(
                                            PreferencesKey.orgUserId)
                                      },
                                      isLoading: false,
                                      onResponseSuccess: (Map object) {
                                        var result = InitialSurveyPostModel
                                            .fromJson(object);
                                        if (result.data!.isNotEmpty) {
                                          profileController!.initialSurveyPostList
                                              .clear();
                                          profileController!.initialSurveyPostList
                                              .addAll(result.data!);
                                        }
                                      });
                                });
                          });
                    });
              });
        }
      });
      userProfileUpdateController!.isLoading.value = true;
      Api.get.call(context,
          method: "user/${AppPreference().getString(PreferencesKey.orgUserId)}",
          param: {
            "_id": AppPreference().getString(PreferencesKey.orgUserId),
          },
          isLoading: false, onResponseSuccess: (Map object) {
            userProfileUpdateController!.isLoading.value = false;
            debugPrint(object.toString());
            var result = UserProfileModel.fromJson(object);
            userProfileUpdateController!.userProfilePath.value = result.path!;
            userProfileUpdateController!.orgUserProfile.value = result.data!;
            saveOrgProfile(userProfileUpdateController!.orgUserProfile.value);
            /* userProfileUpdateController!.orgUserProfile.value.organizationMember!.forEach((element) {
          if(''){}
        });*/
            profileController!.isProfileMuddaLoading.value = true;
            Api.get.call(context,
                method: "mudda/my-engagement",
                param: {
                  "user_id": AppPreference().getString(PreferencesKey.orgUserId)
                },
                isLoading: false, onResponseSuccess: (Map object) {
                  profileController!.isProfileMuddaLoading.value = false;
                  var result = MuddaPostModel.fromJson(object);
                  if (result.data!.isNotEmpty) {
                    profileController!.muddaProfilePath.value = result.path!;
                    profileController!.orgMuddaPostList.clear();
                    profileController!.orgMuddaPostList.addAll(result.data!);
                  }
                  profileController!.quotePostListForProfile.clear();
                  Api.get.call(context,
                      method: "quote-or-activity/index",
                      param: {
                        "page": "1",
                        "post_of": "quote",
                        "user_id": AppPreference().getString(
                            PreferencesKey.orgUserId)
                      },
                      isLoading: false, onResponseSuccess: (Map object) {
                        var result = QuotePostModel.fromJson(object);
                        if (result.data!.isNotEmpty) {
                          profileController!.quotePostPath.value = result.path!;
                          profileController!.quoteProfilePath.value =
                          result.userpath!;
                          profileController!.quotePostListForProfile.addAll(
                              result.data!);
                        }
                        profileController!.activityPostList.clear();
                        Api.get.call(context,
                            method: "quote-or-activity/index",
                            param: {
                              "page": "1",
                              "post_of": "activity",
                              "user_id": AppPreference().getString(
                                  PreferencesKey.orgUserId)
                            },
                            isLoading: false, onResponseSuccess: (Map object) {
                              var result = QuotePostModel.fromJson(object);
                              if (result.data!.isNotEmpty) {
                                profileController!.quotePostPath.value =
                                result.path!;
                                profileController!.quoteProfilePath.value =
                                result.userpath!;
                                profileController!.activityPostList.addAll(
                                    result.data!);
                              }
                              Api.get.call(context,
                                  method: "initiate-survey/index",
                                  param: {
                                    "page": "1",
                                    "user_id":
                                    AppPreference().getString(
                                        PreferencesKey.orgUserId)
                                  },
                                  isLoading: false,
                                  onResponseSuccess: (Map object) {
                                    var result = InitialSurveyPostModel
                                        .fromJson(object);
                                    if (result.data!.isNotEmpty) {
                                      profileController!.initialSurveyPostList
                                          .clear();
                                      profileController!.initialSurveyPostList
                                          .addAll(result.data!);
                                    }
                                  });
                            });
                      });
                });
          });
    }
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

    // _getProfile(context);
    return Obx(
          () =>
          RefreshIndicator(
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
                              InkWell(
                                onTap: () {
                                  showFullProfileDialog(context);
                                },
                                child: userProfileUpdateController!
                                    .orgUserProfile.value.profile !=
                                    null
                                    ? SizedBox(
                                  width: ScreenUtil().setSp(95),
                                  height: ScreenUtil().setSp(95),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    "${userProfileUpdateController!
                                        .userProfilePath}${userProfileUpdateController!
                                        .orgUserProfile.value.profile}",
                                    imageBuilder: (context, imageProvider) =>
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
                                                Radius.circular(
                                                    ScreenUtil().setSp(
                                                        24)) //                 <--- border radius here
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
                                  width: ScreenUtil().setSp(95),
                                  height: ScreenUtil().setSp(95),
                                  child: Center(
                                    child: Text(
                                        userProfileUpdateController!
                                            .orgUserProfile
                                            .value
                                            .fullname !=
                                            null
                                            ? userProfileUpdateController!
                                            .orgUserProfile
                                            .value
                                            .fullname![0]
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
                                        Radius.circular(ScreenUtil().setSp(
                                            24)) //                 <--- border radius here
                                    ),
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
                                    .orgUserProfile.value.fullname ??
                                    "",
                                style: size14_M_semibold(
                                  textColor: colorBlack,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                "@ ${userProfileUpdateController!.orgUserProfile
                                    .value.username ?? ''}",
                                style: size13_M_medium(
                                  textColor: const Color(0xFFefa627),
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                "${userProfileUpdateController!.orgUserProfile
                                    .value
                                    .organizationType}(${userProfileUpdateController!
                                    .orgUserProfile.value.category != null
                                    ? userProfileUpdateController!
                                    .orgUserProfile.value.category!.join(", ")
                                    : ""})",
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
                                      "${userProfileUpdateController!
                                          .orgUserProfile.value.city ??
                                          ""},${userProfileUpdateController!
                                          .orgUserProfile.value.state ??
                                          ""},${userProfileUpdateController!
                                          .orgUserProfile.value.country ?? ""}",
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
                            Obx(
                                  () =>
                              userProfileUpdateController!.isLoading.value
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
                                          .orgUserProfile
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
                                          .orgUserProfile
                                          .value
                                          .muddaCount ??
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
                                                      .position
                                                      .maxScrollExtent);
                                            });
                                      }),
                                ],
                              ),
                            ),
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
                            Obx(() =>
                            userProfileUpdateController!.isLoading.value
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
                                      .orgUserProfile
                                      .value
                                      .countFollowers ??
                                      0),
                                  title: "Followers",
                                  onTap: () {
                                    AcceptUserDetail user =
                                        userProfileUpdateController!
                                            .orgUserProfile.value;
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
                                      .orgUserProfile
                                      .value
                                      .organizationMemberCount ??
                                      0),
                                  title: "Members",
                                  onTap: () {
                                    Get.toNamed(RouteConstants.orgMembers,
                                        arguments:
                                        userProfileUpdateController!
                                            .orgUserProfile.value);
                                  },
                                ),
                              ],
                            )),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteConstants.newRequestScreen);
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
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 3.5,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 26, bottom: 3.5, top: 3.5),
                                        child: Text(
                                          "Requests",
                                          style:
                                          size14_M_normal(textColor: colorGrey),
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
                                          left: 5, right: 5, top: 1, bottom: 1),
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
                                        style:
                                        size10_M_normal(textColor: buttonBlue),
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
                        ),
                        orgBox(
                            title: "Edit Profile",
                            icon: AppIcons.editProfile,
                            onTap: () {
                              Get.toNamed(RouteConstants.orgProfileEdit);
                            }),
                        orgBox(
                            title: "Invite",
                            icon: AppIcons.inviteIcon,
                            onTap: () {
                              Get.toNamed(
                                  RouteConstants.invitedOrgSearchScreen);
                            }),
                        // const SizedBox(width: 8),
                        // Expanded(
                        //   child: orgBox(
                        //       title: "Invited",
                        //       icon: AppIcons.inviteIcon,
                        //       onTap: () {
                        //         log('-=-=- Org Id -=-=- ${userProfileUpdateController!.orgUserProfile.value.id}');
                        //         Get.to(()=> InvitedDetailsOrg(orgId: userProfileUpdateController!.orgUserProfile.value.id,));
                        //       }),
                        // ),
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
                      userProfileUpdateController!
                          .orgUserProfile.value.description ??
                          "",
                      trimLines: 3,
                      style: size14_M_normal(textColor: Colors.black),
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'more',
                      trimExpandedText: 'less',
                      moreStyle: size14_M_normal(textColor: Colors.grey),
                    ),
                  ),
                  Visibility(
                    visible: (userProfileUpdateController!
                        .orgUserProfile.value.organizationMemberCount ??
                        0) <
                        11,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            "Your Org is still under Approval Stage",
                            style: GoogleFonts.nunitoSans(
                                fontSize: ScreenUtil().setSp(15),
                                fontWeight: FontWeight.w700,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (userProfileUpdateController!
                      .orgUserProfile.value.organizationMember !=
                      null &&
                      userProfileUpdateController!
                          .orgUserProfile.value.organizationMember!.isNotEmpty)
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
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: List.generate(
                            userProfileUpdateController!.orgUserProfile.value
                                .organizationMember !=
                                null &&
                                userProfileUpdateController!.orgUserProfile
                                    .value.organizationMember!.isNotEmpty
                                ? userProfileUpdateController!
                                .orgUserProfile.value.organizationMember!.length
                                : 0, (index) {
                          return InkWell(
                            onTap: () {
                              if (userProfileUpdateController!
                                  .orgUserProfile.value.organizationMember!
                                  .elementAt(index)
                                  .userDetail!
                                  .sId ==
                                  AppPreference()
                                      .getString(PreferencesKey.userId) ||
                                  userProfileUpdateController!
                                      .orgUserProfile.value.organizationMember!
                                      .elementAt(index)
                                      .userDetail!
                                      .sId ==
                                      AppPreference()
                                          .getString(
                                          PreferencesKey.orgUserId)) {
                                Get.toNamed(RouteConstants.profileScreen);
                              } else if (userProfileUpdateController!
                                  .orgUserProfile.value.organizationMember!
                                  .elementAt(index)
                                  .userDetail!
                                  .userType ==
                                  "user") {
                                Map<String, String>? parameters = {
                                  "userDetail": jsonEncode(
                                      userProfileUpdateController!
                                          .orgUserProfile.value
                                          .organizationMember!
                                          .elementAt(index)
                                          .userDetail!)
                                };
                                Get.toNamed(
                                    RouteConstants.otherUserProfileScreen,
                                    parameters: parameters);
                              } else {
                                Map<String, String>? parameters = {
                                  "userDetail": jsonEncode(
                                      userProfileUpdateController!
                                          .orgUserProfile.value
                                          .organizationMember!
                                          .elementAt(index)
                                          .userDetail!)
                                };
                                Get.toNamed(
                                    RouteConstants.otherOrgProfileScreen,
                                    parameters: parameters);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, bottom: 4),
                              child: userProfileUpdateController!
                                  .orgUserProfile.value.organizationMember!
                                  .elementAt(index)
                                  .userDetail!
                                  .profile !=
                                  null
                                  ? SizedBox(
                                width: ScreenUtil().setSp(40),
                                height: ScreenUtil().setSp(40),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "${userProfileUpdateController!
                                      .userProfilePath}${userProfileUpdateController!
                                      .orgUserProfile.value.organizationMember!
                                      .elementAt(index).userDetail!.profile}",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        width: ScreenUtil().setSp(40),
                                        height: ScreenUtil().setSp(40),
                                        decoration: BoxDecoration(
                                          color: colorWhite,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  .5),
                                              blurRadius: 2.0,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                          border: Border.all(
                                              color: userProfileUpdateController!
                                                  .orgUserProfile
                                                  .value
                                                  .organizationMember!
                                                  .isNotEmpty
                                                  ? userProfileUpdateController!
                                                  .orgUserProfile
                                                  .value
                                                  .organizationMember!
                                                  .elementAt(index)
                                                  .role
                                                  ?.toLowerCase() ==
                                                  'speaker'
                                                  ? colorF1B008
                                                  : userProfileUpdateController!
                                                  .orgUserProfile
                                                  .value
                                                  .organizationMember!
                                                  .elementAt(
                                                  index)
                                                  .role
                                                  ?.toLowerCase() ==
                                                  "admin"
                                                  ? color606060
                                                  : userProfileUpdateController!
                                                  .orgUserProfile
                                                  .value
                                                  .organizationMember!
                                                  .elementAt(
                                                  index)
                                                  .role
                                                  ?.toLowerCase() ==
                                                  "creator"
                                                  ? color0060FF
                                                  : userProfileUpdateController!
                                                  .orgUserProfile
                                                  .value
                                                  .organizationMember!
                                                  .elementAt(
                                                  index)
                                                  .role
                                                  ?.toLowerCase() ==
                                                  "co-founder"
                                                  ? color35bedc
                                                  : Colors
                                                  .transparent
                                                  : Colors.transparent,
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
                                          .orgUserProfile
                                          .value
                                          .organizationMember!
                                          .isNotEmpty
                                          ? userProfileUpdateController!
                                          .orgUserProfile
                                          .value
                                          .organizationMember!
                                          .elementAt(index)
                                          .role
                                          ?.toLowerCase() ==
                                          'speaker'
                                          ? colorF1B008
                                          : userProfileUpdateController!
                                          .orgUserProfile
                                          .value
                                          .organizationMember!
                                          .elementAt(index)
                                          .role
                                          ?.toLowerCase() ==
                                          "admin"
                                          ? color606060
                                          : userProfileUpdateController!
                                          .orgUserProfile
                                          .value
                                          .organizationMember!
                                          .elementAt(
                                          index)
                                          .role
                                          ?.toLowerCase() ==
                                          "creator"
                                          ? color0060FF
                                          : userProfileUpdateController!
                                          .orgUserProfile
                                          .value
                                          .organizationMember!
                                          .elementAt(
                                          index)
                                          .role
                                          ?.toLowerCase() ==
                                          "co-founder"
                                          ? color35bedc
                                          : Colors.transparent
                                          : Colors.transparent,
                                      width: 2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                      userProfileUpdateController!
                                          .orgUserProfile
                                          .value
                                          .organizationMember!
                                          .elementAt(index)
                                          .userDetail!
                                          .fullname !=
                                          null
                                          ? userProfileUpdateController!
                                          .orgUserProfile
                                          .value
                                          .organizationMember!
                                          .elementAt(index)
                                          .userDetail!
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
                  Obx(() =>
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: List.generate(
                            4,
                                (index) =>
                                Padding(
                                  padding: const EdgeInsets.only(right: 40),
                                  child: InkWell(
                                    onTap: () {
                                      profileController!.isTabSelected.value =
                                          index;
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
                                          profileController!.isTabSelected
                                              .value ==
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
                  Obx(() =>
                  profileController!.isTabSelected.value == 0
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
                        profileController!.orgMuddaPostList.length,
                            (index) {
                          String status = "Under Approval";
                          String created = "";
                          MuddaPost muddaPost = profileController!
                              .orgMuddaPostList
                              .elementAt(index);
                          if (AppPreference()
                              .getString(PreferencesKey.userId) !=
                              muddaPost.leaders!
                                  .elementAt(0)
                                  .acceptUserDetail!
                                  .sId) {
                            created =
                            "Created By - ${muddaPost.leaders!
                                .elementAt(0)
                                .acceptUserDetail!
                                .fullname}";
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
                              if ((muddaPost.initialScope!
                                  .toLowerCase() ==
                                  "district" &&
                                  muddaPost.leadersCount! >= 10) ||
                                  (muddaPost.initialScope!
                                      .toLowerCase() ==
                                      "state" &&
                                      muddaPost.leadersCount! >= 15 &&
                                      muddaPost.uniqueCity! >= 3) ||
                                  (muddaPost.initialScope!
                                      .toLowerCase() ==
                                      "country" &&
                                      muddaPost.leadersCount! >= 20 &&
                                      muddaPost.uniqueState! >= 3) ||
                                  (muddaPost.initialScope!
                                      .toLowerCase() ==
                                      "world" &&
                                      muddaPost.leadersCount! >= 25 &&
                                      muddaPost.uniqueCountry! >= 5)) {
                                muddaNewsController.muddaPost.value =
                                    muddaPost;
                                Get.toNamed(
                                    RouteConstants.muddaDetailsScreen);
                              } else {
                                Map<String, String>? parameters = {
                                  "muddaId": muddaPost.sId!
                                };
                                Get.toNamed(
                                    RouteConstants.shareMuddaScreen,
                                    parameters: parameters);
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
                                          "${profileController!.muddaProfilePath
                                              .value}${muddaPost.thumbnail}",
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
                                                          : muddaPost
                                                          .initialScope!
                                                          .toLowerCase() ==
                                                          "country"
                                                          ? muddaPost
                                                          .country!
                                                          : muddaPost
                                                          .initialScope!,
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                          fontSize:
                                                          ScreenUtil()
                                                              .setSp(
                                                              12),
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                          color: black)),
                                                  Text(status,
                                                      style: GoogleFonts
                                                          .nunitoSans(
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
                                                      style: GoogleFonts
                                                          .nunitoSans(
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
                                                        "Joined by: ${NumberFormat
                                                            .compactCurrency(
                                                          decimalDigits:
                                                          0,
                                                          symbol:
                                                          '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                        ).format(muddaPost
                                                            .joinersCount)} members",
                                                        style: GoogleFonts
                                                            .nunitoSans(
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
                                          ).format(muddaPost
                                              .totalVote)} Interactions",
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
                                        "${muddaPost.support != 0
                                            ? ((muddaPost.support! * 100) /
                                            muddaPost.totalVote!)
                                            .toStringAsFixed(2)
                                            : 0}% / ${NumberFormat
                                            .compactCurrency(
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
                                        "${muddaPost.support != 0 ? ((muddaPost
                                            .support! * 100) /
                                            muddaPost.totalVote!)
                                            .toStringAsFixed(2) : 0}%",
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
                                            "${muddaPost.city ??
                                                ""}, ${muddaPost.state ??
                                                ""}, ${muddaPost.country ??
                                                ""}",
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

  _getMember(BuildContext context) async {
    Api.get.call(context,
        method: "user/${AppPreference().getString(PreferencesKey.orgUserId)}",
        param: {
          "_id": AppPreference().getString(PreferencesKey.orgUserId),
          "page": memberPage.toString()
        },
        isLoading: false, onResponseSuccess: (Map object) {
          debugPrint(object.toString());
          var result = UserProfileModel.fromJson(object);
          userProfileUpdateController!.userProfilePath.value = result.path!;
          if (result.data!.organizationMember!.isNotEmpty) {
            userProfileUpdateController!.orgUserProfile.value = result.data!;
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
          "user_id": AppPreference().getString(PreferencesKey.orgUserId)
        },
        isLoading: false, onResponseSuccess: (Map object) {
          var result = MuddaPostModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            profileController!.muddaProfilePath.value = result.path!;
            profileController!.orgMuddaPostList.addAll(result.data!);
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
          "user_id": AppPreference().getString(PreferencesKey.orgUserId)
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
          "user_id": AppPreference().getString(PreferencesKey.orgUserId)
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
          "user_id": AppPreference().getString(PreferencesKey.orgUserId)
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
                              .orgUserProfile.value.profile !=
                              null
                              ? CachedNetworkImage(
                            imageUrl:
                            "${userProfileUpdateController!
                                .userProfilePath}${userProfileUpdateController!
                                .orgUserProfile.value.profile}",
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
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          )
                              : userProfileUpdateController!
                              .orgUserProfileImage.value.isNotEmpty
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
                                              .orgUserProfileImage
                                              .value)))))
                              : Container(
                            child: Center(
                              child: Text(
                                  userProfileUpdateController!
                                      .orgUserProfile
                                      .value
                                      .fullname !=
                                      null
                                      ? userProfileUpdateController!
                                      .orgUserProfile
                                      .value
                                      .fullname![0]
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
      "_id": AppPreference().getString(PreferencesKey.orgUserId),
    });
    var video =
    await MultipartFile.fromFile(path, filename: path
        .split('/')
        .last);
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
          userProfileUpdateController!.orgUserProfile.value = result.data!;
          // Get.toNamed(RouteConstants.homeScreen);
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
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _cropImage(File(pickedFile.path)).then((value) async {
                          userProfileUpdateController!.userProfileImage.value =
                              value.path;
                          uploadPic(context, value.path);
                        });
                      }
                    } on PlatformException catch (e) {
                      debugPrint('FAILED $e');
                    }
                    Navigator.of(bc).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  try {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
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

  _getProfile(BuildContext context) async {
    if (AppPreference()
        .getString(PreferencesKey.orgUserId)
        .isNotEmpty) {
      userProfileUpdateController!.isLoading.value = true;
      Api.get.call(context,
          method: "user/${AppPreference().getString(PreferencesKey.orgUserId)}",
          param: {
            "_id": AppPreference().getString(PreferencesKey.orgUserId),
          },
          isLoading: false, onResponseSuccess: (Map object) {
            userProfileUpdateController!.isLoading.value = false;
            debugPrint(object.toString());
            var result = UserProfileModel.fromJson(object);
            userProfileUpdateController!.userProfilePath.value = result.path!;
            userProfileUpdateController!.orgUserProfile.value = result.data!;
            saveOrgProfile(userProfileUpdateController!.orgUserProfile.value);
            AppPreference().setString(PreferencesKey.city, result.data!.city!);
            AppPreference().setString(
                PreferencesKey.state, result.data!.state!);
            AppPreference()
                .setString(PreferencesKey.country, result.data!.country!);
            profileController!.isProfileMuddaLoading.value = true;
            Api.get.call(context,
                method: "mudda/my-engagement",
                param: {
                  "user_id": AppPreference().getString(PreferencesKey.orgUserId)
                },
                isLoading: false, onResponseSuccess: (Map object) {
                  profileController!.isProfileMuddaLoading.value = false;
                  var result = MuddaPostModel.fromJson(object);
                  if (result.data!.isNotEmpty) {
                    profileController!.muddaProfilePath.value = result.path!;
                    profileController!.orgMuddaPostList.clear();
                    profileController!.orgMuddaPostList.addAll(result.data!);
                  }
                  Api.get.call(context,
                      method: "quote-or-activity/index",
                      param: {"page": "1", "post_of": "quote"},
                      isLoading: false, onResponseSuccess: (Map object) {
                        var result = QuotePostModel.fromJson(object);
                        if (result.data!.isNotEmpty) {
                          profileController!.quotePostPath.value = result.path!;
                          profileController!.quoteProfilePath.value =
                          result.userpath!;
                          profileController!.quotePostListForProfile.clear();
                          profileController!.quotePostListForProfile.addAll(
                              result.data!);
                        }
                        Api.get.call(context,
                            method: "quote-or-activity/index",
                            param: {"page": "1", "post_of": "activity"},
                            isLoading: false, onResponseSuccess: (Map object) {
                              var result = QuotePostModel.fromJson(object);
                              if (result.data!.isNotEmpty) {
                                profileController!.quotePostPath.value =
                                result.path!;
                                profileController!.quoteProfilePath.value =
                                result.userpath!;
                                profileController!.activityPostList.clear();
                                profileController!.activityPostList.addAll(
                                    result.data!);
                              }
                              Api.get.call(context,
                                  method: "initiate-survey/index",
                                  param: {"page": "1"},
                                  isLoading: false,
                                  onResponseSuccess: (Map object) {
                                    var result = InitialSurveyPostModel
                                        .fromJson(object);
                                    if (result.data!.isNotEmpty) {
                                      profileController!.initialSurveyPostList
                                          .clear();
                                      profileController!.initialSurveyPostList
                                          .addAll(result.data!);
                                    }
                                  });
                            });
                      });
                });
          });
    } else {
      return true;
    }
  }
  Future<AcceptUserDetail?> getOrgProfileFromCache(BuildContext context) async {
    await storage.ready;
    Map<String, dynamic>? data = storage.getItem('org-profile');

    if (data != null) {
      AcceptUserDetail user = AcceptUserDetail.fromJson(data);
      // _getProfile(context,userId);
      return user;//to indicate post is pulled from cache

    } else {
      return null;
      // _getProfile(context,userId);
    }
  }
  void bottomsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: getHeight(380),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getSizedBox(h: 30),
                    Row(
                      children: [
                        Text(
                          "Invite Existing Mudda Members",
                          style: size14_M_normal(textColor: greyTextColor),
                        ),
                        getSizedBox(w: 20),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            Get.toNamed(RouteConstants.invitedOrgSearchScreen);
                          },
                          child: Image.asset(
                            AppIcons.searchIcon,
                            height: 26,
                            width: 26,
                          ),
                        )
                      ],
                    ),
                    getSizedBox(h: 5),
                    Text("or", style: size12_M_normal(textColor: colorGrey)),
                    getSizedBox(h: 5),
                    Text(
                      "Share Outside",
                      style: size14_M_normal(textColor: greyTextColor),
                    ),
                    getSizedBox(h: 10),
                    Text(
                      "Heylo, I have created my community / Org on Mudda App and would like to invite you to join my community / Org . Please download the app and click the below link to join me. See you there...",
                      style: size14_M_normal(textColor: greyTextColor),
                    ),
                    getSizedBox(h: 10),
                    Text(
                      "https://www.figma.com/proto/pYLkQgjLHNp1i2lEmIhLXl/Mudda-Redesign?node-id=127%3A196&scaling=scale-down&page-id=0%3A1&starting-point-node-id=97%3A202",
                      style: size14_M_normal(textColor: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    getSizedBox(h: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        5,
                            (index) =>
                            Container(
                              height: 40,
                              width: 40,
                              child: const Center(child: Text("App")),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: -17,
              left: 40,
              child: Container(
                height: 34,
                width: 34,
                child: Column(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      child: Center(
                          child: Image.asset(AppIcons.inviteIcon,
                              height: 18, width: 18)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: colorGrey),
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                ),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PostGrid extends StatelessWidget {
  ProfileController profileController;

  PostGrid(this.profileController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: profileController.activityPostList.length,
          itemBuilder: (followersContext, index) {
            Quote quote = profileController.activityPostList.elementAt(index);
            return InkWell(
              onTap: () {
                // muddaNewsController.muddaPost.value = muddaPost;
                // Get.toNamed(RouteConstants.muddaDetailsScreen);
              },
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 10,
                    children: List.generate(
                      quote.gallery!.length,
                          (index) {
                        Gallery gallery = quote.gallery!.elementAt(index);
                        return SizedBox(
                          height: ScreenUtil().setSp(85),
                          child: Padding(
                            padding:
                            EdgeInsets.only(bottom: ScreenUtil().setSp(11)),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setSp(8)),
                                  child: SizedBox(
                                    height: ScreenUtil().setSp(70),
                                    width: ScreenUtil().setSp(70),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      "${profileController.quotePostPath
                                          .value}${gallery.file}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
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
                                            fontSize: ScreenUtil().setSp(10)),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(AppIcons.likeHand,
                                          height: 15, width: 15),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  SizedBox(
                    height: ScreenUtil().setSp(8),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(quote.hashtags!.join(','),
                            style: size10_M_normal(textColor: colorDarkBlack)),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(10),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: colorDarkBlack),
                          ),
                          SizedBox(
                            width: ScreenUtil().setSp(5),
                          ),
                          Text(
                              "${quote.user!.city ?? ""}, ${quote.user!.state ??
                                  ""}, ${quote.user!.country ?? ""}",
                              style:
                              size12_M_normal(textColor: colorDarkBlack)),
                        ],
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(10),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: colorDarkBlack),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(5),
                      ),
                      Text(convertToAgo(DateTime.parse(quote.createdAt!)),
                          style: size10_M_normal(textColor: colorDarkBlack)),
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
              // muddaNewsController.muddaPost.value = muddaPost;
              // Get.toNamed(RouteConstants.muddaDetailsScreen);
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
