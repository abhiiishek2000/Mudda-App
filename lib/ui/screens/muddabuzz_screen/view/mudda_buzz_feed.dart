import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/QuotePostModel.dart';
import 'package:mudda/model/UserProfileModel.dart' as userDetails;
import 'package:mudda/model/UserSuggestionsModel.dart' hide User;
import 'package:mudda/ui/screens/mudda/view/mudda_details_screen.dart';
import 'package:mudda/ui/screens/mudda/widget/mudda_post_comment.dart';
import 'package:mudda/ui/screens/profile_screen/controller/follower_controller.dart';
import 'package:mudda/ui/screens/profile_screen/controller/profile_controller.dart';
import 'package:mudda/ui/screens/quotes_list/view/quotes_list.dart';
import 'package:mudda/ui/shared/ReadMoreText.dart';
import 'package:mudda/ui/shared/report_post_dialog_box.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../../../const/const.dart';
import '../../../../model/CategoryListModel.dart';
import '../../../../model/PostForMuddaModel.dart';
import '../../../../model/UserRolesModel.dart';
import '../../../shared/Muddebazz_page_ad.dart';
import '../../../shared/VideoPlayerScreen.dart';
import '../../../shared/get_started_button.dart';
import '../../../shared/trimmer_view.dart';
import '../widgets/loading_view.dart';

class MuddaBuzzFeedScreen extends StatefulWidget {
  const MuddaBuzzFeedScreen({Key? key}) : super(key: key);

  @override
  State<MuddaBuzzFeedScreen> createState() => _MuddaBuzzFeedScreenState();
}

class _MuddaBuzzFeedScreenState extends State<MuddaBuzzFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  double tabIconHeight = 20;
  double tabIconWidth = 30;
  int suggestionsPage = 1;
  int suggestionsCityPage = 1;
  int suggestionsStatePage = 1;
  int suggestionsCountryPage = 1;
  FollowerController? followerController;
  ScrollController suggestionsScrollController = ScrollController();
  ScrollController suggestionsCityScrollController = ScrollController();
  ScrollController suggestionsStateScrollController = ScrollController();
  ScrollController suggestionsCountryScrollController = ScrollController();
  ProfileController profileController = Get.find<ProfileController>();
  VideoController videoController = VideoController();
  int allPage = 1;
  int quotePage = 1;
  int activityPage = 1;

  final Trimmer _trimmer = Trimmer();
  int selectedIndex = 0;
  int rolePage = 1;
  ScrollController roleController = ScrollController();

  @override
  void initState() {
    super.initState();
    profileController.allQuotesScrollController.addListener(() {
      if (profileController.allQuotesScrollController.position.maxScrollExtent ==
          profileController.allQuotesScrollController.position.pixels) {
        allPage++;
        _allPaginateQuotes(context);
      }
    });
    profileController.quotesScrollController.addListener(() {
      if (profileController.quotesScrollController.position.maxScrollExtent ==
          profileController.quotesScrollController.position.pixels) {
        quotePage++;
        _quotesPaginate(context);
      }
    });
    profileController.activityScrollController.addListener(() {
      if (profileController.activityScrollController.position.maxScrollExtent ==
          profileController.activityScrollController.position.pixels) {
        activityPage++;
        _activityPaginate(context);
      }
    });
    followerController = Get.put(FollowerController(),
        tag: (DateTime
            .now()
            .millisecondsSinceEpoch).toString());

    tabController = TabController(
      length: 3,
      vsync: this,
    );
    tabController.addListener(() {
      if (tabController.index == 1 &&
          profileController.singleQuotePostList.isEmpty) {
        _quotes(context);
      }
      else if (tabController.index == 2 &&
          profileController.singleActivityPostList.isEmpty) {
        _activity(context);
      }
    });
    if (followerController!
        .mySuggestionsResult.isEmpty) {
      _suggestions(context);
    }
    profileController.countFollowing.value =
        AppPreference().getString(PreferencesKey.countFollowing);
    AppPreference().getString(PreferencesKey.countFollowing) == "0"
        ? _suggestions(context)
        : _allQuotes(context);
    followerController!.suggestionTabController!.addListener(() {
      if (followerController!.suggestionTabController!.index == 1 &&
          followerController!.mySuggestionsCityResult.isEmpty) {
        followerController!.mySuggestionsCityResult.clear();
        _suggestionsCity(context);
      }
      if (followerController!.suggestionTabController!.index == 2 &&
          followerController!.mySuggestionsStateResult.isEmpty) {
        followerController!.mySuggestionsStateResult.clear();
        _suggestionsState(context);
      }
      if (followerController!.suggestionTabController!.index == 3 &&
          followerController!.mySuggestionsCountryResult.isEmpty) {
        followerController!.mySuggestionsCountryResult.clear();
        _suggestionsCountry(context);
      }
    });
    suggestionsScrollController.addListener(() {
      if (suggestionsScrollController.position.maxScrollExtent ==
          suggestionsScrollController.position.pixels) {
        suggestionsPage++;
        _suggestions(context);
      }
    });
    suggestionsCityScrollController.addListener(() {
      if (suggestionsCityScrollController.position.maxScrollExtent ==
          suggestionsCityScrollController.position.pixels) {
        suggestionsCityPage++;
        _suggestionsCity(context);
      }
    });
    suggestionsStateScrollController.addListener(() {
      if (suggestionsStateScrollController.position.maxScrollExtent ==
          suggestionsStateScrollController.position.pixels) {
        suggestionsStatePage++;
        _suggestionsState(context);
      }
    });
    suggestionsCountryScrollController.addListener(() {
      if (suggestionsCountryScrollController.position.maxScrollExtent ==
          suggestionsCountryScrollController.position.pixels) {
        suggestionsCountryPage++;
        _suggestionsCountry(context);
      }
    });
    _getRoles(context);
    getProfile();
  }

  getProfile() {
    Api.get.call(context,
        method: "user/${AppPreference().getString(PreferencesKey.userId)}",
        param: {
          "_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
          log("-=-=- object $object");
          var result = userDetails.UserProfileModel.fromJson(object);
          AppPreference().setString(PreferencesKey.countFollowing,
              result.data!.countFollowing.toString());
          profileController.countFollowing.value =
              result.data!.countFollowing.toString();
          if (result.data!.countFollowing == 0) {
            _suggestions(context);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      body: Stack(
        children: [
          Obx(() =>
          profileController.countFollowing.value == "0"
              ? Column(
            children: [
              Container(
                width: double.infinity,
                height: 60.h,
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                      text: "To see ",
                      style: size14_M_normal(textColor: color606060),
                      children: [
                        TextSpan(
                          text: "Activities",
                          style: size14_M_bold(textColor: colorDarkBlack),
                        ),
                        TextSpan(
                          text:
                          ", you need to\n   follow Muddebaaz or Org",
                          style: size14_M_normal(textColor: color606060),
                        ),
                      ]),
                ),
              ),
              Vs(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "    Start\nFollowing",
                          style: size12_M_regular300(textColor: color606060),
                        ),
                        Hs(
                          width: 20.w,
                        ),
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset(AppIcons.downhand)),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(RouteConstants.followSearchScreen)!
                            .then((value) {
                          print("object" + value.toString());
                          if (value) {
                            profileController.quotePostList.clear();
                            allPage = 1;
                            _allQuotes(context);
                          }
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          width: ScreenUtil().setHeight(100),
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(6)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Search...',
                                style: size12_M_regular(textColor: black81),),
                              Image.asset(
                                AppIcons.searchIcon,
                                height: 12,
                                width: 12,
                              )
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                tabs: [
                  const Tab(
                    text: "Suggestions",
                  ),
                  Tab(
                      text:
                      AppPreference().getString(PreferencesKey.city)),
                  Tab(
                      text: AppPreference()
                          .getString(PreferencesKey.state)),
                  Tab(
                      text: AppPreference()
                          .getString(PreferencesKey.country)),
                  const Tab(text: "World"),
                ],
                isScrollable: true,
                labelColor: colorBlack,
                unselectedLabelColor: colorGrey,
                indicatorColor: colorBlack,
                unselectedLabelStyle: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(14)),
                labelStyle: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w700,
                    fontSize: ScreenUtil().setSp(14)),
                controller: followerController!.suggestionTabController,
              ),
              Expanded(
                child:
                AppPreference()
                    .getString(PreferencesKey.city)
                    .isNotEmpty
                    ? TabBarView(
                  controller: followerController!
                      .suggestionTabController,
                  children: [
                    Container(
                      child: followerController!
                          .mySuggestionsResult.isNotEmpty
                          ? ListView.builder(
                          shrinkWrap: true,
                          controller:
                          suggestionsScrollController,
                          itemCount: followerController!
                              .mySuggestionsResult.length,
                          itemBuilder:
                              (followersContext, index) {
                            AcceptUserDetail user =
                            followerController!
                                .mySuggestionsResult
                                .elementAt(index);
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil()
                                      .setSp(20),
                                  right: ScreenUtil()
                                      .setSp(20),
                                  top: ScreenUtil()
                                      .setSp(15)),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (user.sId ==
                                          AppPreference().getString(
                                              PreferencesKey
                                                  .userId)) {
                                        Get.toNamed(
                                            RouteConstants
                                                .profileScreen,
                                            arguments:
                                            user);
                                      } else {
                                        Map<String, String>?
                                        parameters = {
                                          "userDetail":
                                          jsonEncode(
                                              user)
                                        };
                                        Get.toNamed(
                                            RouteConstants
                                                .otherUserProfileScreen,
                                            parameters:
                                            parameters);
                                      }
                                    },
                                    child:
                                    user.profile != null
                                        ? CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                      backgroundImage:
                                      NetworkImage(
                                          "${followerController!.userPath
                                              .value}${user.profile}"),
                                    )
                                        : CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil()
                                        .setSp(7),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (user.sId ==
                                            AppPreference()
                                                .getString(
                                                PreferencesKey
                                                    .userId)) {
                                          Get.toNamed(
                                              RouteConstants
                                                  .profileScreen,
                                              arguments:
                                              user);
                                        } else {
                                          Map<String,
                                              String>?
                                          parameters = {
                                            "userDetail":
                                            jsonEncode(
                                                user)
                                          };
                                          Get.toNamed(
                                              RouteConstants
                                                  .otherUserProfileScreen,
                                              parameters:
                                              parameters);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                  '${user.fullname}',
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(
                                                          14),
                                                      color:
                                                      black)),
                                              SizedBox(
                                                width: ScreenUtil()
                                                    .setSp(
                                                    3),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    user.username !=
                                                        null
                                                        ? '${user.username}'
                                                        : "",
                                                    maxLines:
                                                    2,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: GoogleFonts
                                                        .nunitoSans(
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontStyle: FontStyle
                                                            .italic,
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                        color: darkGray)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                              user.city !=
                                                  null
                                                  ? '${user.city}, ${user
                                                  .country}'
                                                  : "",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight:
                                                  FontWeight
                                                      .w300,
                                                  fontSize: ScreenUtil()
                                                      .setSp(
                                                      12),
                                                  color:
                                                  lightGray)),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Visibility(
                                    visible: AppPreference()
                                        .getBool(
                                        PreferencesKey
                                            .isGuest) ==
                                        false,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                          style:
                                          ButtonStyle(
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(user.amIFollowing ==
                                                  0
                                                  ? appBackgroundColor
                                                  : blackGray),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                      borderRadius: const BorderRadius
                                                          .only(
                                                        topLeft:
                                                        const Radius.circular(
                                                            5),
                                                        topRight:
                                                        Radius.circular(5),
                                                        bottomLeft:
                                                        const Radius.circular(
                                                            5),
                                                        bottomRight:
                                                        Radius.circular(5),
                                                      ),
                                                      side: const BorderSide(
                                                          color: grey)))),
                                          onPressed: () async {
                                            Api.post.call(
                                              context,
                                              method:
                                              "request-to-user/store",
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(
                                                    PreferencesKey.userId),
                                                "request_to_user_id":
                                                user.sId,
                                                "request_type":
                                                "follow",
                                              },
                                              onResponseSuccess:
                                                  (object) {
                                                print(
                                                    object);
                                                int index2 =
                                                    index;
                                                user.amIFollowing =
                                                1;
                                                followerController!
                                                    .mySuggestionsResult
                                                    .removeAt(
                                                    index);
                                                followerController!
                                                    .mySuggestionsResult
                                                    .insert(
                                                    index2,
                                                    user);
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Follow',
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                fontSize: ScreenUtil()
                                                    .setSp(
                                                    12),
                                                color: user.amIFollowing ==
                                                    0
                                                    ? grey
                                                    : white),
                                          )),
                                      height: ScreenUtil()
                                          .setHeight(30),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                          : Center(
                        child: Text(
                            "No Suggestions Found",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w500)),
                      ),
                    ),
                    Container(
                      child: followerController!
                          .mySuggestionsCityResult
                          .isNotEmpty
                          ? ListView.builder(
                          shrinkWrap: true,
                          controller:
                          suggestionsScrollController,
                          itemCount: followerController!
                              .mySuggestionsCityResult
                              .length,
                          itemBuilder:
                              (followersContext, index) {
                            AcceptUserDetail user =
                            followerController!
                                .mySuggestionsCityResult
                                .elementAt(index);
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil()
                                      .setSp(20),
                                  right: ScreenUtil()
                                      .setSp(20),
                                  top: ScreenUtil()
                                      .setSp(15)),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (user.sId ==
                                          AppPreference().getString(
                                              PreferencesKey
                                                  .userId)) {
                                        Get.toNamed(
                                            RouteConstants
                                                .profileScreen,
                                            arguments:
                                            user);
                                      } else {
                                        Map<String, String>?
                                        parameters = {
                                          "userDetail":
                                          jsonEncode(
                                              user)
                                        };
                                        Get.toNamed(
                                            RouteConstants
                                                .otherUserProfileScreen,
                                            parameters:
                                            parameters);
                                      }
                                    },
                                    child:
                                    user.profile != null
                                        ? CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                      backgroundImage:
                                      NetworkImage(
                                          "${followerController!.userPath
                                              .value}${user.profile}"),
                                    )
                                        : CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil()
                                        .setSp(7),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (user.sId ==
                                            AppPreference()
                                                .getString(
                                                PreferencesKey
                                                    .userId)) {
                                          Get.toNamed(
                                              RouteConstants
                                                  .profileScreen,
                                              arguments:
                                              user);
                                        } else {
                                          Map<String,
                                              String>?
                                          parameters = {
                                            "userDetail":
                                            jsonEncode(
                                                user)
                                          };
                                          Get.toNamed(
                                              RouteConstants
                                                  .otherUserProfileScreen,
                                              parameters:
                                              parameters);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                  '${user.fullname}',
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(
                                                          14),
                                                      color:
                                                      black)),
                                              SizedBox(
                                                width: ScreenUtil()
                                                    .setSp(
                                                    3),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    user.username !=
                                                        null
                                                        ? '${user.username}'
                                                        : "",
                                                    maxLines:
                                                    2,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: GoogleFonts
                                                        .nunitoSans(
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontStyle: FontStyle
                                                            .italic,
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                        color: darkGray)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                              user.city !=
                                                  null
                                                  ? '${user.city}, ${user
                                                  .country}'
                                                  : "",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight:
                                                  FontWeight
                                                      .w300,
                                                  fontSize: ScreenUtil()
                                                      .setSp(
                                                      12),
                                                  color:
                                                  lightGray)),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Visibility(
                                    visible: AppPreference()
                                        .getBool(
                                        PreferencesKey
                                            .isGuest) ==
                                        false,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                          style:
                                          ButtonStyle(
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(user.amIFollowing ==
                                                  0
                                                  ? appBackgroundColor
                                                  : blackGray),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .only(
                                                        topLeft:
                                                        const Radius.circular(
                                                            5),
                                                        topRight:
                                                        Radius.circular(5),
                                                        bottomLeft:
                                                        Radius.circular(5),
                                                        bottomRight:
                                                        const Radius.circular(
                                                            5),
                                                      ),
                                                      side: BorderSide(
                                                          color: grey)))),
                                          onPressed: () async {
                                            Api.post.call(
                                              context,
                                              method:
                                              "request-to-user/store",
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(
                                                    PreferencesKey.userId),
                                                "request_to_user_id":
                                                user.sId,
                                                "request_type":
                                                "follow",
                                              },
                                              onResponseSuccess:
                                                  (object) {
                                                print(
                                                    object);
                                                int index2 =
                                                    index;
                                                user.amIFollowing =
                                                1;
                                                followerController!
                                                    .mySuggestionsCityResult
                                                    .removeAt(
                                                    index);
                                                followerController!
                                                    .mySuggestionsCityResult
                                                    .insert(
                                                    index2,
                                                    user);
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Follow',
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                fontSize: ScreenUtil()
                                                    .setSp(
                                                    12),
                                                color: user.amIFollowing ==
                                                    0
                                                    ? grey
                                                    : white),
                                          )),
                                      height: ScreenUtil()
                                          .setHeight(30),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                          : Center(
                        child: Text(
                            "No Suggestions Found",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w500)),
                      ),
                    ),
                    Container(
                      child: followerController!
                          .mySuggestionsStateResult
                          .isNotEmpty
                          ? ListView.builder(
                          shrinkWrap: true,
                          controller:
                          suggestionsScrollController,
                          itemCount: followerController!
                              .mySuggestionsStateResult
                              .length,
                          itemBuilder:
                              (followersContext, index) {
                            AcceptUserDetail user =
                            followerController!
                                .mySuggestionsStateResult
                                .elementAt(index);
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil()
                                      .setSp(20),
                                  right: ScreenUtil()
                                      .setSp(20),
                                  top: ScreenUtil()
                                      .setSp(15)),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (user.sId ==
                                          AppPreference().getString(
                                              PreferencesKey
                                                  .userId)) {
                                        Get.toNamed(
                                            RouteConstants
                                                .profileScreen,
                                            arguments:
                                            user);
                                      } else {
                                        Map<String, String>?
                                        parameters = {
                                          "userDetail":
                                          jsonEncode(
                                              user)
                                        };
                                        Get.toNamed(
                                            RouteConstants
                                                .otherUserProfileScreen,
                                            parameters:
                                            parameters);
                                      }
                                    },
                                    child:
                                    user.profile != null
                                        ? CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                      backgroundImage:
                                      NetworkImage(
                                          "${followerController!.userPath
                                              .value}${user.profile}"),
                                    )
                                        : CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil()
                                        .setSp(7),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (user.sId ==
                                            AppPreference()
                                                .getString(
                                                PreferencesKey
                                                    .userId)) {
                                          Get.toNamed(
                                              RouteConstants
                                                  .profileScreen,
                                              arguments:
                                              user);
                                        } else {
                                          Map<String,
                                              String>?
                                          parameters = {
                                            "userDetail":
                                            jsonEncode(
                                                user)
                                          };
                                          Get.toNamed(
                                              RouteConstants
                                                  .otherUserProfileScreen,
                                              parameters:
                                              parameters);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                  '${user.fullname}',
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(
                                                          14),
                                                      color:
                                                      black)),
                                              SizedBox(
                                                width: ScreenUtil()
                                                    .setSp(
                                                    3),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    user.username !=
                                                        null
                                                        ? '${user.username}'
                                                        : "",
                                                    maxLines:
                                                    2,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: GoogleFonts
                                                        .nunitoSans(
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontStyle: FontStyle
                                                            .italic,
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                        color: darkGray)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                              user.city !=
                                                  null
                                                  ? '${user.city}, ${user
                                                  .country}'
                                                  : "",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight:
                                                  FontWeight
                                                      .w300,
                                                  fontSize: ScreenUtil()
                                                      .setSp(
                                                      12),
                                                  color:
                                                  lightGray)),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Visibility(
                                    visible: AppPreference()
                                        .getBool(
                                        PreferencesKey
                                            .isGuest) ==
                                        false,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                          style:
                                          ButtonStyle(
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(user.amIFollowing ==
                                                  0
                                                  ? appBackgroundColor
                                                  : blackGray),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .only(
                                                        topLeft:
                                                        const Radius.circular(
                                                            5),
                                                        topRight:
                                                        Radius.circular(5),
                                                        bottomLeft:
                                                        Radius.circular(5),
                                                        bottomRight:
                                                        const Radius.circular(
                                                            5),
                                                      ),
                                                      side: BorderSide(
                                                          color: grey)))),
                                          onPressed: () async {
                                            Api.post.call(
                                              context,
                                              method:
                                              "request-to-user/store",
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(
                                                    PreferencesKey.userId),
                                                "request_to_user_id":
                                                user.sId,
                                                "request_type":
                                                "follow",
                                              },
                                              onResponseSuccess:
                                                  (object) {
                                                print(
                                                    object);
                                                int index2 =
                                                    index;
                                                user.amIFollowing =
                                                1;
                                                followerController!
                                                    .mySuggestionsStateResult
                                                    .removeAt(
                                                    index);
                                                followerController!
                                                    .mySuggestionsStateResult
                                                    .insert(
                                                    index2,
                                                    user);
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Follow',
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                fontSize: ScreenUtil()
                                                    .setSp(
                                                    12),
                                                color: user.amIFollowing ==
                                                    0
                                                    ? grey
                                                    : white),
                                          )),
                                      height: ScreenUtil()
                                          .setHeight(30),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                          : Center(
                        child: Text(
                            "No Suggestions Found",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w500)),
                      ),
                    ),
                    Container(
                      child: followerController!
                          .mySuggestionsCountryResult
                          .isNotEmpty
                          ? ListView.builder(
                          shrinkWrap: true,
                          controller:
                          suggestionsScrollController,
                          itemCount: followerController!
                              .mySuggestionsCountryResult
                              .length,
                          itemBuilder:
                              (followersContext, index) {
                            AcceptUserDetail user =
                            followerController!
                                .mySuggestionsCountryResult
                                .elementAt(index);
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil()
                                      .setSp(20),
                                  right: ScreenUtil()
                                      .setSp(20),
                                  top: ScreenUtil()
                                      .setSp(15)),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (user.sId ==
                                          AppPreference().getString(
                                              PreferencesKey
                                                  .userId)) {
                                        Get.toNamed(
                                            RouteConstants
                                                .profileScreen,
                                            arguments:
                                            user);
                                      } else {
                                        Map<String, String>?
                                        parameters = {
                                          "userDetail":
                                          jsonEncode(
                                              user)
                                        };
                                        Get.toNamed(
                                            RouteConstants
                                                .otherUserProfileScreen,
                                            parameters:
                                            parameters);
                                      }
                                    },
                                    child:
                                    user.profile != null
                                        ? CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                      backgroundImage:
                                      NetworkImage(
                                          "${followerController!.userPath
                                              .value}${user.profile}"),
                                    )
                                        : CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil()
                                        .setSp(7),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (user.sId ==
                                            AppPreference()
                                                .getString(
                                                PreferencesKey
                                                    .userId)) {
                                          Get.toNamed(
                                              RouteConstants
                                                  .profileScreen,
                                              arguments:
                                              user);
                                        } else {
                                          Map<String,
                                              String>?
                                          parameters = {
                                            "userDetail":
                                            jsonEncode(
                                                user)
                                          };
                                          Get.toNamed(
                                              RouteConstants
                                                  .otherUserProfileScreen,
                                              parameters:
                                              parameters);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                  '${user.fullname}',
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(
                                                          14),
                                                      color:
                                                      black)),
                                              SizedBox(
                                                width: ScreenUtil()
                                                    .setSp(
                                                    3),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    user.username !=
                                                        null
                                                        ? '${user.username}'
                                                        : "",
                                                    maxLines:
                                                    2,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: GoogleFonts
                                                        .nunitoSans(
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontStyle: FontStyle
                                                            .italic,
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                        color: darkGray)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                              user.city !=
                                                  null
                                                  ? '${user.city}, ${user
                                                  .country}'
                                                  : "",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight:
                                                  FontWeight
                                                      .w300,
                                                  fontSize: ScreenUtil()
                                                      .setSp(
                                                      12),
                                                  color:
                                                  lightGray)),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Visibility(
                                    visible: AppPreference()
                                        .getBool(
                                        PreferencesKey
                                            .isGuest) ==
                                        false,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                          style:
                                          ButtonStyle(
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(user.amIFollowing ==
                                                  0
                                                  ? appBackgroundColor
                                                  : blackGray),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                      borderRadius: const BorderRadius
                                                          .only(
                                                        topLeft:
                                                        const Radius.circular(
                                                            5),
                                                        topRight:
                                                        Radius.circular(5),
                                                        bottomLeft:
                                                        const Radius.circular(
                                                            5),
                                                        bottomRight:
                                                        Radius.circular(5),
                                                      ),
                                                      side: const BorderSide(
                                                          color: grey)))),
                                          onPressed: () async {
                                            Api.post.call(
                                              context,
                                              method:
                                              "request-to-user/store",
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(
                                                    PreferencesKey.userId),
                                                "request_to_user_id":
                                                user.sId,
                                                "request_type":
                                                "follow",
                                              },
                                              onResponseSuccess:
                                                  (object) {
                                                print(
                                                    object);
                                                int index2 =
                                                    index;
                                                user.amIFollowing =
                                                1;
                                                followerController!
                                                    .mySuggestionsCountryResult
                                                    .removeAt(
                                                    index);
                                                followerController!
                                                    .mySuggestionsCountryResult
                                                    .insert(
                                                    index2,
                                                    user);
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Follow',
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                fontSize: ScreenUtil()
                                                    .setSp(
                                                    12),
                                                color: user.amIFollowing ==
                                                    0
                                                    ? grey
                                                    : white),
                                          )),
                                      height: ScreenUtil()
                                          .setHeight(30),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                          : Center(
                        child: Text(
                            "No Suggestions Found",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w500)),
                      ),
                    ),
                    Container(
                      child: followerController!
                          .mySuggestionsResult.isNotEmpty
                          ? ListView.builder(
                          shrinkWrap: true,
                          controller:
                          suggestionsScrollController,
                          itemCount: followerController!
                              .mySuggestionsResult.length,
                          itemBuilder:
                              (followersContext, index) {
                            AcceptUserDetail user =
                            followerController!
                                .mySuggestionsResult
                                .elementAt(index);
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil()
                                      .setSp(20),
                                  right: ScreenUtil()
                                      .setSp(20),
                                  top: ScreenUtil()
                                      .setSp(15)),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (user.sId ==
                                          AppPreference().getString(
                                              PreferencesKey
                                                  .userId)) {
                                        Get.toNamed(
                                            RouteConstants
                                                .profileScreen,
                                            arguments:
                                            user);
                                      } else {
                                        Map<String, String>?
                                        parameters = {
                                          "userDetail":
                                          jsonEncode(
                                              user)
                                        };
                                        Get.toNamed(
                                            RouteConstants
                                                .otherUserProfileScreen,
                                            parameters:
                                            parameters);
                                      }
                                    },
                                    child:
                                    user.profile != null
                                        ? CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                      backgroundImage:
                                      NetworkImage(
                                          "${followerController!.userPath
                                              .value}${user.profile}"),
                                    )
                                        : CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil()
                                        .setSp(7),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (user.sId ==
                                            AppPreference()
                                                .getString(
                                                PreferencesKey
                                                    .userId)) {
                                          Get.toNamed(
                                              RouteConstants
                                                  .profileScreen,
                                              arguments:
                                              user);
                                        } else {
                                          Map<String,
                                              String>?
                                          parameters = {
                                            "userDetail":
                                            jsonEncode(
                                                user)
                                          };
                                          Get.toNamed(
                                              RouteConstants
                                                  .otherUserProfileScreen,
                                              parameters:
                                              parameters);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                  '${user.fullname}',
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(
                                                          14),
                                                      color:
                                                      black)),
                                              SizedBox(
                                                width: ScreenUtil()
                                                    .setSp(
                                                    3),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    user.username !=
                                                        null
                                                        ? '${user.username}'
                                                        : "",
                                                    maxLines:
                                                    2,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: GoogleFonts
                                                        .nunitoSans(
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontStyle: FontStyle
                                                            .italic,
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                        color: darkGray)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                              user.city !=
                                                  null
                                                  ? '${user.city}, ${user
                                                  .country}'
                                                  : "",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight:
                                                  FontWeight
                                                      .w300,
                                                  fontSize: ScreenUtil()
                                                      .setSp(
                                                      12),
                                                  color:
                                                  lightGray)),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Visibility(
                                    visible: AppPreference()
                                        .getBool(
                                        PreferencesKey
                                            .isGuest) ==
                                        false,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                          style:
                                          ButtonStyle(
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(user.amIFollowing ==
                                                  0
                                                  ? appBackgroundColor
                                                  : blackGray),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .only(
                                                        topLeft:
                                                        const Radius.circular(
                                                            5),
                                                        topRight:
                                                        const Radius.circular(
                                                            5),
                                                        bottomLeft:
                                                        const Radius.circular(
                                                            5),
                                                        bottomRight:
                                                        const Radius.circular(
                                                            5),
                                                      ),
                                                      side: const BorderSide(
                                                          color: grey)))),
                                          onPressed: () async {
                                            Api.post.call(
                                              context,
                                              method:
                                              "request-to-user/store",
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(
                                                    PreferencesKey.userId),
                                                "request_to_user_id":
                                                user.sId,
                                                "request_type":
                                                "follow",
                                              },
                                              onResponseSuccess:
                                                  (object) {
                                                print(
                                                    object);
                                                int index2 =
                                                    index;
                                                user.amIFollowing =
                                                1;
                                                followerController!
                                                    .mySuggestionsResult
                                                    .removeAt(
                                                    index);
                                                followerController!
                                                    .mySuggestionsResult
                                                    .insert(
                                                    index2,
                                                    user);
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Follow',
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                fontSize: ScreenUtil()
                                                    .setSp(
                                                    12),
                                                color: user.amIFollowing ==
                                                    0
                                                    ? grey
                                                    : white),
                                          )),
                                      height: ScreenUtil()
                                          .setHeight(30),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                          : Center(
                        child: Text(
                            "No Suggestions Found",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w500)),
                      ),
                    ),
                  ],
                  physics: const ScrollPhysics(),
                )
                    : TabBarView(
                  controller: followerController!
                      .suggestionTabController,
                  children: [
                    Container(
                      child: followerController!
                          .mySuggestionsResult.isNotEmpty
                          ? ListView.builder(
                          shrinkWrap: true,
                          controller:
                          suggestionsScrollController,
                          itemCount: followerController!
                              .mySuggestionsResult.length,
                          itemBuilder:
                              (followersContext, index) {
                            AcceptUserDetail user =
                            followerController!
                                .mySuggestionsResult
                                .elementAt(index);
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil()
                                      .setSp(20),
                                  right: ScreenUtil()
                                      .setSp(20),
                                  top: ScreenUtil()
                                      .setSp(15)),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (user.sId ==
                                          AppPreference().getString(
                                              PreferencesKey
                                                  .userId)) {
                                        Get.toNamed(
                                            RouteConstants
                                                .profileScreen,
                                            arguments:
                                            user);
                                      } else {
                                        Map<String, String>?
                                        parameters = {
                                          "userDetail":
                                          jsonEncode(
                                              user)
                                        };
                                        Get.toNamed(
                                            RouteConstants
                                                .otherUserProfileScreen,
                                            parameters:
                                            parameters);
                                      }
                                    },
                                    child:
                                    user.profile != null
                                        ? CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                      backgroundImage:
                                      NetworkImage(
                                          "${followerController!.userPath
                                              .value}${user.profile}"),
                                    )
                                        : CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil()
                                        .setSp(7),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (user.sId ==
                                            AppPreference()
                                                .getString(
                                                PreferencesKey
                                                    .userId)) {
                                          Get.toNamed(
                                              RouteConstants
                                                  .profileScreen,
                                              arguments:
                                              user);
                                        } else {
                                          Map<String,
                                              String>?
                                          parameters = {
                                            "userDetail":
                                            jsonEncode(
                                                user)
                                          };
                                          Get.toNamed(
                                              RouteConstants
                                                  .otherUserProfileScreen,
                                              parameters:
                                              parameters);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                  '${user.fullname}',
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(
                                                          14),
                                                      color:
                                                      black)),
                                              SizedBox(
                                                width: ScreenUtil()
                                                    .setSp(
                                                    3),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    user.username !=
                                                        null
                                                        ? '${user.username}'
                                                        : "",
                                                    maxLines:
                                                    2,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: GoogleFonts
                                                        .nunitoSans(
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontStyle: FontStyle
                                                            .italic,
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                        color: darkGray)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                              user.city !=
                                                  null
                                                  ? '${user.city}, ${user
                                                  .country}'
                                                  : "",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight:
                                                  FontWeight
                                                      .w300,
                                                  fontSize: ScreenUtil()
                                                      .setSp(
                                                      12),
                                                  color:
                                                  lightGray)),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Visibility(
                                    visible: AppPreference()
                                        .getBool(
                                        PreferencesKey
                                            .isGuest) ==
                                        false,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                          style:
                                          ButtonStyle(
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(user.amIFollowing ==
                                                  0
                                                  ? appBackgroundColor
                                                  : blackGray),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                      borderRadius: const BorderRadius
                                                          .only(
                                                        topLeft:
                                                        const Radius.circular(
                                                            5),
                                                        topRight:
                                                        Radius.circular(5),
                                                        bottomLeft:
                                                        const Radius.circular(
                                                            5),
                                                        bottomRight:
                                                        Radius.circular(5),
                                                      ),
                                                      side: const BorderSide(
                                                          color: grey)))),
                                          onPressed: () async {
                                            Api.post.call(
                                              context,
                                              method:
                                              "request-to-user/store",
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(
                                                    PreferencesKey.userId),
                                                "request_to_user_id":
                                                user.sId,
                                                "request_type":
                                                "follow",
                                              },
                                              onResponseSuccess:
                                                  (object) {
                                                print(
                                                    object);
                                                int index2 =
                                                    index;
                                                user.amIFollowing =
                                                1;
                                                followerController!
                                                    .mySuggestionsResult
                                                    .removeAt(
                                                    index);
                                                followerController!
                                                    .mySuggestionsResult
                                                    .insert(
                                                    index2,
                                                    user);
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Follow',
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                fontSize: ScreenUtil()
                                                    .setSp(
                                                    12),
                                                color: user.amIFollowing ==
                                                    0
                                                    ? grey
                                                    : white),
                                          )),
                                      height: ScreenUtil()
                                          .setHeight(30),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                          : Center(
                        child: Text(
                            "No Suggestions Found",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w500)),
                      ),
                    ),
                    Container(
                      child: followerController!
                          .mySuggestionsResult.isNotEmpty
                          ? ListView.builder(
                          shrinkWrap: true,
                          controller:
                          suggestionsScrollController,
                          itemCount: followerController!
                              .mySuggestionsResult.length,
                          itemBuilder:
                              (followersContext, index) {
                            AcceptUserDetail user =
                            followerController!
                                .mySuggestionsResult
                                .elementAt(index);
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil()
                                      .setSp(20),
                                  right: ScreenUtil()
                                      .setSp(20),
                                  top: ScreenUtil()
                                      .setSp(15)),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (user.sId ==
                                          AppPreference().getString(
                                              PreferencesKey
                                                  .userId)) {
                                        Get.toNamed(
                                            RouteConstants
                                                .profileScreen,
                                            arguments:
                                            user);
                                      } else {
                                        Map<String, String>?
                                        parameters = {
                                          "userDetail":
                                          jsonEncode(
                                              user)
                                        };
                                        Get.toNamed(
                                            RouteConstants
                                                .otherUserProfileScreen,
                                            parameters:
                                            parameters);
                                      }
                                    },
                                    child:
                                    user.profile != null
                                        ? CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                      backgroundImage:
                                      NetworkImage(
                                          "${followerController!.userPath
                                              .value}${user.profile}"),
                                    )
                                        : CircleAvatar(
                                      backgroundColor:
                                      lightGray,
                                      radius: ScreenUtil()
                                          .radius(
                                          17),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil()
                                        .setSp(7),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (user.sId ==
                                            AppPreference()
                                                .getString(
                                                PreferencesKey
                                                    .userId)) {
                                          Get.toNamed(
                                              RouteConstants
                                                  .profileScreen,
                                              arguments:
                                              user);
                                        } else {
                                          Map<String,
                                              String>?
                                          parameters = {
                                            "userDetail":
                                            jsonEncode(
                                                user)
                                          };
                                          Get.toNamed(
                                              RouteConstants
                                                  .otherUserProfileScreen,
                                              parameters:
                                              parameters);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                  '${user.fullname}',
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(
                                                          14),
                                                      color:
                                                      black)),
                                              SizedBox(
                                                width: ScreenUtil()
                                                    .setSp(
                                                    3),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    user.username !=
                                                        null
                                                        ? '${user.username}'
                                                        : "",
                                                    maxLines:
                                                    2,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: GoogleFonts
                                                        .nunitoSans(
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontStyle: FontStyle
                                                            .italic,
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                        color: darkGray)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                              user.city !=
                                                  null
                                                  ? '${user.city}, ${user
                                                  .country}'
                                                  : "",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight:
                                                  FontWeight
                                                      .w300,
                                                  fontSize: ScreenUtil()
                                                      .setSp(
                                                      12),
                                                  color:
                                                  lightGray)),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Visibility(
                                    visible: AppPreference()
                                        .getBool(
                                        PreferencesKey
                                            .isGuest) ==
                                        false,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                          style:
                                          ButtonStyle(
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(user.amIFollowing ==
                                                  0
                                                  ? appBackgroundColor
                                                  : blackGray),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                      borderRadius: const BorderRadius
                                                          .only(
                                                        topLeft:
                                                        const Radius.circular(
                                                            5),
                                                        topRight:
                                                        const Radius.circular(
                                                            5),
                                                        bottomLeft:
                                                        const Radius.circular(
                                                            5),
                                                        bottomRight:
                                                        Radius.circular(5),
                                                      ),
                                                      side: const BorderSide(
                                                          color: grey)))),
                                          onPressed: () async {
                                            Api.post.call(
                                              context,
                                              method:
                                              "request-to-user/store",
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(
                                                    PreferencesKey.userId),
                                                "request_to_user_id":
                                                user.sId,
                                                "request_type":
                                                "follow",
                                              },
                                              onResponseSuccess:
                                                  (object) {
                                                print(
                                                    object);
                                                int index2 =
                                                    index;
                                                user.amIFollowing =
                                                1;
                                                followerController!
                                                    .mySuggestionsResult
                                                    .removeAt(
                                                    index);
                                                followerController!
                                                    .mySuggestionsResult
                                                    .insert(
                                                    index2,
                                                    user);
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Follow',
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                fontSize: ScreenUtil()
                                                    .setSp(
                                                    12),
                                                color: user.amIFollowing ==
                                                    0
                                                    ? grey
                                                    : white),
                                          )),
                                      height: ScreenUtil()
                                          .setHeight(30),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                          : Center(
                        child: Text(
                            "No Suggestions Found",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w500)),
                      ),
                    ),
                  ],
                  physics: const ScrollPhysics(),
                ),
              ),
            ],
          )
              : Obx(() => RefreshIndicator(
            onRefresh: () {
              profileController.quotePostList.clear();
              profileController.singleQuotePostList.clear();
              profileController.singleActivityPostList.clear();
              allPage = 1;
              profileController.isSelectedQoute.value = 0;
              return _allQuotes(context);
            },
            child: ListView(
              controller: profileController.singleQuotePostList.isNotEmpty
                  ? profileController.quotesScrollController
                  : profileController.singleActivityPostList.isNotEmpty
                  ? profileController.activityScrollController
                  : profileController.allQuotesScrollController,
              children: [
                Obx(
                      () =>
                  profileController.isLoading.value ?
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return const MuddeBazzLoadingView();
                      })
                      : profileController.quotePostList.isNotEmpty ?
                  // TODO: BOTH
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                          bottom: ScreenUtil().setSp(70)),
                      itemCount: profileController.quotePostList
                          .length,
                      itemBuilder: (followersContext, index) {
                        Quote quote = profileController.quotePostList
                            .elementAt(index);
                        profileController.currentHorizontal.value =
                        0;
                        if (index != 0 && index == 2) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(height:ScreenUtil().setSp(16)),
                              const MuddebazzPageAD(),
                              muddebazzCard(quote, index, context),
                            ],
                          );
                        } else if (index != 0 && (index - 2) % 5 == 0) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(height:ScreenUtil().setSp(16)),
                              const MuddebazzPageAD(),
                              muddebazzCard(quote, index, context)
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              muddebazzCard(quote, index, context)
                            ],
                          );
                        }
                      }) :
                  profileController.singleQuotePostList.isNotEmpty ?
                  // TODO: SINGLE QUOTE
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                      EdgeInsets.only(bottom: ScreenUtil().setSp(70)),
                      itemCount:
                      profileController.singleQuotePostList.length,
                      itemBuilder: (followersContext, index) {
                        Quote quote = profileController
                            .singleQuotePostList
                            .elementAt(index);
                        if (index != 0 && index == 2) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(height:ScreenUtil().setSp(16)),
                              const MuddebazzPageAD(),
                              muddaCardForSingleQoute(quote, index, context),
                            ],
                          );
                        } else if (index != 0 && (index - 2) % 5 == 0) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(height:ScreenUtil().setSp(16)),
                              const MuddebazzPageAD(),
                              muddaCardForSingleQoute(quote, index, context)
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              muddaCardForSingleQoute(quote, index, context)
                            ],
                          );
                        }
                      }) :
                  profileController.singleActivityPostList.isNotEmpty ?
                  // TODO: SINGLE ACTIVITY
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                      EdgeInsets.only(bottom: ScreenUtil().setSp(70)),
                      itemCount: profileController
                          .singleActivityPostList.length,
                      itemBuilder: (followersContext, index) {
                        Quote quote = profileController
                            .singleActivityPostList
                            .elementAt(index);
                        if (index != 0 && index == 2) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(height:ScreenUtil().setSp(16)),
                              const MuddebazzPageAD(),
                              muddebazzCardForSingleActivity(
                                  quote, index, context)
                            ],
                          );
                        } else if (index != 0 && (index - 2) % 5 == 0) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(height:ScreenUtil().setSp(16)),
                              const MuddebazzPageAD(),
                              muddebazzCardForSingleActivity(
                                  quote, index, context)
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              muddebazzCardForSingleActivity(
                                  quote, index, context)
                            ],
                          );
                        }
                      })
                      : const Center(child: Text('No data found')),
                ),
              ],
            ),
          ))
          ),
          Positioned(
            bottom: 65,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     Get.back();
                //     Get.back();
                //   },
                //   child: Container(
                //     height: 40,
                //     width: 50,
                //     alignment: Alignment.center,
                //     child: SvgPicture.asset(
                //       AppIcons.fireIcon,
                //       color: Colors.white,
                //       height: 20,
                //       width: 20,
                //     ),
                //     decoration: BoxDecoration(
                //       color: color606060.withOpacity(0.75),
                //       borderRadius: const BorderRadius.only(
                //         topRight: Radius.circular(16),
                //         bottomRight: Radius.circular(16),
                //       ),
                //     ),
                //   ),
                // ),
                const Spacer(),
                // GestureDetector(
                //   onTap: () {
                //     if (AppPreference().getBool(PreferencesKey.isGuest)) {
                //       Get.toNamed(RouteConstants.userProfileEdit);
                //     } else {
                //       Get.toNamed(RouteConstants.uploadQuoteActivityScreen);
                //     }
                //   },
                //   child: Container(
                //     alignment: Alignment.center,
                //     child: Padding(
                //       padding: const EdgeInsets.all(6),
                //       child: Image.asset(AppIcons.plusIcon),
                //     ),
                //     decoration: const BoxDecoration(
                //         color: Colors.amber,
                //         shape: BoxShape.circle,
                //         boxShadow: [
                //           BoxShadow(
                //             color: color606060,
                //             blurRadius: 2.0,
                //             spreadRadius: 0.0,
                //             offset: Offset(
                //               0.0,
                //               3.0,
                //             ),
                //           ),
                //         ]),
                //   ),
                // ),
                const Spacer(),
                Obx(() =>
                    Visibility(
                      visible: profileController.countFollowing.value == "0",
                      child: GestureDetector(
                        onTap: () {
                          profileController.countFollowing.value = '1';
                          _allQuotes(context);
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 80,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 8),
                              decoration: BoxDecoration(
                                color: colorWhite,
                                border: Border.all(color: color606060),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: Center(
                                  child: Text(
                                    "Done",
                                    style:
                                    size13_M_normal(textColor: colorDarkBlack),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 20,
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 40,
                                padding: const EdgeInsets.all(2),
                                margin: const EdgeInsets.only(
                                    right: 10, top: 4),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: colorWhite),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorWhite,
                                      border: Border.all(color: color606060)),
                                  child: const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 25,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  InkWell muddebazzCardForSingleActivity(Quote quote, int index,
      BuildContext context) {
    return InkWell(
      onTap: () {
        if (quote.postOf == "quote") {
          Get.toNamed(
              RouteConstants.commentSections,
              arguments: quote);
        } else {
          Get.toNamed(
              RouteConstants
                  .muddaPostCommentsScreen,
              arguments: quote);
        }
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: ScreenUtil().setSp(8)),
        padding: EdgeInsets.only(
            bottom: ScreenUtil().setSp(8),
            top: ScreenUtil().setSp(8)),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setSp(12)),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => profileNavigation(context, quote),
                    child: Column(
                      children: [
                        quote.user != null &&
                            quote.user!.profile !=
                                null
                            ? CachedNetworkImage(
                          imageUrl:
                          "${profileController
                              .quoteProfilePath}${quote
                              .user!.profile!}",
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
                                  borderRadius: BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          ScreenUtil()
                                              .setSp(
                                              20)) //                 <--- border radius here
                                  ),
                                  image: DecorationImage(
                                      image:
                                      imageProvider,
                                      fit:
                                      BoxFit
                                          .cover),
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
                              .setSp(45),
                          width: ScreenUtil()
                              .setSp(45),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: darkGray,
                            ),
                            shape: BoxShape
                                .circle,
                          ),
                          child: Center(
                            child: Text(
                                quote.user !=
                                    null &&
                                    quote
                                        .user!
                                        .fullname!
                                        .isNotEmpty
                                    ? quote
                                    .user!
                                    .fullname![
                                0]
                                    .toUpperCase()
                                    : "A",
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
                        getSizedBox(
                            h: ScreenUtil().setSp(
                                8)),
                        SvgPicture.asset(
                            quote.postOf ==
                                "quote"
                                ? "assets/svg/quote.svg"
                                : "assets/svg/activity.svg")
                      ],
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
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Expanded(
                              child: Wrap(
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        profileNavigation(context, quote),
                                    child: Text(
                                      quote.user !=
                                          null
                                          ? quote
                                          .user!
                                          .fullname!
                                          : "",
                                      style: size13_M_bold(
                                          textColor: Colors
                                              .black87),
                                    ),
                                  ),
                                  getSizedBox(
                                      w: 5),
                                  const CircleAvatar(
                                    radius: 2,
                                    backgroundColor:
                                    Colors.black,
                                  ),
                                  getSizedBox(
                                      w: 5),
                                  Text(
                                    quote.user !=
                                        null
                                        ? quote
                                        .user!
                                        .username!
                                        : "",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontStyle:
                                        FontStyle
                                            .italic),
                                  ),
                                ],
                                crossAxisAlignment:
                                WrapCrossAlignment
                                    .center,
                              ),
                            ),
                            iconThreeDot(quote, false, index)
                          ],
                        ),
                        quote.hashtags != null &&
                            quote.hashtags!
                                .isNotEmpty
                            ? Text(
                          quote.hashtags != null
                              ? quote.hashtags!
                              .join(",")
                              : "",
                          style: const TextStyle(
                              fontSize: 13,
                              fontStyle:
                              FontStyle.italic),
                        )
                            : Container(),
                        getSizedBox(
                            h: quote.hashtags !=
                                null &&
                                quote.hashtags!
                                    .isNotEmpty
                                ? 5
                                : 0),
                        quote.description !=
                            null &&
                            quote.description!
                                .isNotEmpty &&
                            quote.description!
                                .length >
                                6
                            ? ReadMoreText(
                          quote.description ??
                              "",
                          trimLines: 6,
                          trimMode:
                          TrimMode.Line,
                          trimCollapsedText:
                          'more',
                          trimExpandedText:
                          'less',
                          style: GoogleFonts
                              .nunitoSans(
                              fontSize:
                              ScreenUtil()
                                  .setSp(
                                  14),
                              fontWeight:
                              FontWeight
                                  .w400,
                              color: black),
                        )
                            : Text("${quote
                            .description}",
                            style: GoogleFonts
                                .nunitoSans(
                                fontSize:
                                ScreenUtil()
                                    .setSp(
                                    14),
                                fontWeight:
                                FontWeight
                                    .w400,
                                color: black)),
                        if(quote.postOf == "quote" &&
                            quote.gallery!.length == 1)
                          InkWell(
                            onTap: () {
                              muddaGalleryDialog(
                                  context,
                                  quote
                                      .gallery!,
                                  profileController
                                      .quotePostPath
                                      .value,
                                  index);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius
                                  .circular(4),
                              child:
                              CachedNetworkImage(
                                height:
                                ScreenUtil()
                                    .setSp(
                                    177),
                                width:
                                ScreenUtil()
                                    .screenWidth,
                                imageUrl:
                                "${profileController
                                    .quotePostPath
                                    .value}${quote
                                    .gallery!
                                    .elementAt(0)
                                    .file!}",
                                fit: BoxFit
                                    .cover,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  getSizedBox(w: 12)
                ],
              ),
            ),
            quote.postOf == "quote" &&
                quote.gallery!
                    .length > 1
                ? SizedBox(
              height: Get.height * 0.17,
              child: ListView.builder(
                  scrollDirection:
                  Axis.horizontal,
                  itemCount:
                  quote.gallery!
                      .length,
                  padding: EdgeInsets
                      .only(
                      top: ScreenUtil()
                          .setSp(8),
                      right: ScreenUtil()
                          .setSp(10),
                      left: ScreenUtil()
                          .setSp(60)),
                  itemBuilder:
                      (followersContext,
                      index) {
                    return Padding(
                      padding:
                      const EdgeInsets
                          .only(
                          right: 2),
                      child:
                      GestureDetector(
                        onTap: () {
                          muddaGalleryDialog(
                              context,
                              quote
                                  .gallery!,
                              profileController
                                  .quotePostPath
                                  .value,
                              index);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius
                              .circular(4),
                          child: CachedNetworkImage(
                            height: Get.height * 0.17,
                            width: Get.width * 0.3,
                            imageUrl:
                            "${profileController
                                .quotePostPath
                                .value}${quote
                                .gallery!
                                .elementAt(
                                index)
                                .file!}",
                            fit: BoxFit
                                .cover,
                          ),
                        ),
                      ),
                    );
                  }),
            )
                : Container(),
            quote.postOf == "activity" &&
                quote.gallery!.isNotEmpty
                ? Obx(
                  () =>
                  Container(
                    height:
                    ScreenUtil()
                        .setSp(
                        370),
                    width:
                    ScreenUtil()
                        .screenWidth,
                    margin: const EdgeInsets.only(
                        top: 8),
                    child: Stack(
                      children: [
                        CarouselSlider.builder(
                            carouselController: controller,
                            options: CarouselOptions(
                              initialPage: 0,
                              height: ScreenUtil()
                                  .setSp(
                                  370),
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                              onPageChanged: (index,
                                  reason) {
                                profileController
                                    .currentHorizontal
                                    .value =
                                    index;
                              },
                            ),
                            itemCount: quote
                                .gallery!.length,
                            itemBuilder: (context,
                                index2,
                                realIndex) {
                              Gallery mediaModelData = quote
                                  .gallery![index2];
                              return Stack(
                                alignment: Alignment
                                    .center,
                                children: [
                                  /* !mediaModelData.file!.contains(".mp4")
                                                        ? SizedBox(
                                                      height:
                                                      ScreenUtil()
                                                          .setSp(
                                                          370),
                                                      width:
                                                      ScreenUtil()
                                                          .screenWidth,
                                                          child: CachedNetworkImage(
                                                          imageUrl: "${profileController.quotePostPath.value}${mediaModelData.file!}",
                                                          fit: BoxFit.cover,),
                                                        )
                                                        : GestureDetector(
                                                      onLongPressUp: () {
                                                        profileController.isOnPageHorizontalTurning.value = false;
                                                      },
                                                      onLongPress: () {
                                                        profileController.isOnPageHorizontalTurning.value = true;
                                                      },
                                                      onTap: () {
                                                        */
                                  /*setStates(() {
                                                  isDialOpen.value = false;
                                                  if (visibilityTag) {
                                                    visibilityTag = false;
                                                  }
                                                  hideShowTag = !hideShowTag;
                                                });*/ /*
                                                      },
                                                      child: VideoPlayerScreen(
                                                          mediaModelData.file!,
                                                          profileController.quotePostPath.value,
                                                          index2,
                                                          profileController.currentHorizontal.value,
                                                          index,
                                                          0,
                                                          true,
                                                          videoController,
                                                          profileController.isOnPageHorizontalTurning.value),
                                                    ),*/
                                  SizedBox(
                                    height:
                                    ScreenUtil()
                                        .setSp(
                                        370),
                                    width:
                                    ScreenUtil()
                                        .screenWidth,
                                    child: CachedNetworkImage(
                                      imageUrl: "${profileController
                                          .quotePostPath
                                          .value}${mediaModelData
                                          .file!}",
                                      fit: BoxFit
                                          .cover,),
                                  )
                                ],
                              );
                            }),
                        Align(
                          alignment: Alignment
                              .bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets
                                .only(bottom: 9),
                            child: AnimatedSmoothIndicator(
                                onDotClicked: (index) {
                                  controller
                                      .animateToPage(
                                      index);
                                },
                                activeIndex: profileController
                                    .currentHorizontal
                                    .value,
                                count: quote
                                    .gallery!
                                    .length,
                                effect: CustomizableEffect(
                                  activeDotDecoration: DotDecoration(
                                    width: 12.0,
                                    height: 3.0,
                                    color: Colors
                                        .amber,
                                    // rotationAngle: 180,
                                    // verticalOffset: -10,
                                    borderRadius: BorderRadius
                                        .circular(
                                        24),
                                    dotBorder: const DotBorder(
                                      padding: 1,
                                      width: 2,
                                      color: Colors
                                          .white,
                                    ),
                                  ),
                                  dotDecoration: DotDecoration(
                                    width: 12.0,
                                    height: 3.0,
                                    // color: lightRed,
                                    dotBorder: const DotBorder(
                                      padding: 0,
                                      width: 0.5,
                                      color: Colors
                                          .white,
                                    ),
                                    // borderRadius: BorderRadius.only(
                                    //     topLeft: Radius.circular(2),
                                    //     topRight: Radius.circular(16),
                                    //     bottomLeft: Radius.circular(16),
                                    //     bottomRight: Radius.circular(2)),
                                    borderRadius: BorderRadius
                                        .circular(
                                        16),
                                    // verticalOffset: 0,
                                  ),
                                  // spacing: 6.0,
                                  // activeColorOverride: (i) => colors[i],
                                  inActiveColorOverride: (i) => white,
                                )
                              // const SlideEffect(
                              //     spacing: 10.0,
                              //     radius: 3.0,
                              //     dotWidth: 6.0,
                              //     dotHeight: 6.0,
                              //     paintStyle: PaintingStyle.stroke,
                              //     strokeWidth: 1.5,
                              //     dotColor: white,
                              //     activeDotColor: lightRed),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            )
                : Container(),
            getSizedBox(h: ScreenUtil().setSp(8)),
            Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setSp(12),
                  left: ScreenUtil().setSp(12)),
              child: const Divider(
                color: Colors.black87,
                height: 1,
              ),
            ),
            quote.postOf ==
                "quote" ? Padding(
              padding: const EdgeInsets.only(
                  left: 54, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     Share.share(
                      //       '${Const
                      //           .shareUrl}${quote
                      //           .postOf}/${quote
                      //           .sId}',
                      //     );
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets
                      //         .all(10),
                      //     child: SvgPicture.asset(
                      //       "assets/svg/share.svg",
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          if (quote.amILiked !=
                              null) {
                            quote.likersCount =
                                quote
                                    .likersCount! -
                                    1;
                            quote.amILiked = null;
                          } else {
                            quote.likersCount =
                                quote
                                    .likersCount! +
                                    1;
                            AmILiked q = AmILiked();
                            q.relativeId =
                            quote.sId!;
                            q.relativeType =
                            "QuoteOrActivity";
                            q.userId =
                                AppPreference()
                                    .getString(
                                    PreferencesKey
                                        .interactUserId);
                            quote.amILiked = q;
                          }
                          int pIndex = index;
                          profileController
                              .quotePostList
                              .removeAt(index);
                          profileController
                              .quotePostList
                              .insert(
                              pIndex, quote);
                          Api.post.call(
                            context,
                            method: "like/store",
                            isLoading: false,
                            param: {
                              "user_id": AppPreference()
                                  .getString(
                                  PreferencesKey
                                      .interactUserId),
                              "relative_id": quote
                                  .sId!,
                              "relative_type":
                              "QuoteOrActivity",
                              "status": true,
                            },
                            onResponseSuccess: (object) {
                              print(
                                  "Abhishek $object");
                            },
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/like.svg",
                              color: quote
                                  .amILiked !=
                                  null
                                  ? themeColor
                                  : blackGray,
                            ),
                            getSizedBox(w: 5),
                            Text(NumberFormat
                                .compactCurrency(
                              decimalDigits: 0,
                              symbol:
                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                            ).format(quote
                                .likersCount),
                                style: GoogleFonts
                                    .nunitoSans(
                                  fontWeight: quote
                                      .amILiked !=
                                      null
                                      ? FontWeight
                                      .w700
                                      : FontWeight
                                      .w400,
                                  fontSize: ScreenUtil()
                                      .setSp(
                                      12),
                                  color: quote
                                      .amILiked !=
                                      null
                                      ? themeColor
                                      : blackGray,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets
                            .all(10),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons
                                  .reQuoteIcon,
                            ),
                            getSizedBox(w: 5),
                            Text(NumberFormat
                                .compactCurrency(
                              decimalDigits: 0,
                              symbol:
                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                            ).format(
                                quote.reQuote),
                                style: GoogleFonts
                                    .nunitoSans(
                                  fontWeight: FontWeight
                                      .w400,
                                  fontSize: ScreenUtil()
                                      .setSp(12),
                                  color: blackGray,
                                )),
                          ],
                        ),
                      ),
                      getSizedBox(w: 5),
                      SvgPicture.asset(
                        "assets/svg/line.svg",
                      ),
                      InkWell(
                        onTap: () {
                          profileController
                              .uploadPhotoVideos
                              .value = [""];
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors
                                .transparent,
                            builder: (context) =>
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors
                                        .white,
                                    borderRadius: BorderRadius
                                        .only(
                                      topLeft: Radius
                                          .circular(
                                          16),
                                      topRight: Radius
                                          .circular(
                                          16),
                                    ),
                                  ),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment
                                        .center,
                                    alignment: WrapAlignment
                                        .center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets
                                            .only(
                                            top: 24,
                                            bottom: 32),
                                        child: Wrap(
                                          crossAxisAlignment: WrapCrossAlignment
                                              .center,
                                          children: [
                                            Text(
                                              "Create Re-Quote",
                                              style: GoogleFonts
                                                  .nunitoSans(
                                                  fontSize: ScreenUtil()
                                                      .setSp(
                                                      16),
                                                  fontWeight: FontWeight
                                                      .w700,
                                                  color: black),
                                            ),
                                            getSizedBox(
                                                w: 8),
                                            SvgPicture
                                                .asset(
                                              AppIcons
                                                  .reQuoteIcon,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets
                                            .symmetric(
                                            horizontal: ScreenUtil()
                                                .setSp(
                                                42)),
                                        child: Container(
                                          height: getHeight(
                                              160),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  8),
                                              border: Border
                                                  .all(
                                                  color: Colors
                                                      .blue)),
                                          child: TextFormField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  300),
                                            ],
                                            textInputAction: TextInputAction
                                                .newline,
                                            textCapitalization: TextCapitalization
                                                .sentences,
                                            keyboardType: TextInputType
                                                .multiline,
                                            maxLines: null,
                                            onChanged: (text) {
                                              profileController
                                                  .descriptionValue
                                                  .value =
                                                  text;
                                            },
                                            style: size14_M_normal(
                                                textColor: color606060),
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 15,
                                                  vertical: 10),
                                              hintText: "Enter Text for the Quote",
                                              border: InputBorder
                                                  .none,
                                              hintStyle: size12_M_normal(
                                                  textColor: color606060),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                            () =>
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 20,
                                                  vertical: 5),
                                              child: Row(
                                                children: [
                                                  const Spacer(),
                                                  Text(
                                                    "remain ${300 -
                                                        profileController
                                                            .descriptionValue
                                                            .value
                                                            .length} characters",
                                                    style: size10_M_normal(
                                                        textColor: colorGrey),
                                                  )
                                                ],
                                              ),
                                            ),
                                      ),
                                      Container(
                                        height: 100,
                                        margin: const EdgeInsets
                                            .only(
                                            top: 20),
                                        child: Obx(
                                              () =>
                                              ListView
                                                  .builder(
                                                  scrollDirection: Axis
                                                      .horizontal,
                                                  padding: EdgeInsets
                                                      .only(
                                                      left: ScreenUtil()
                                                          .setSp(
                                                          38)),
                                                  itemCount: profileController
                                                      .uploadPhotoVideos
                                                      .length >
                                                      5
                                                      ? 5
                                                      : profileController
                                                      .uploadPhotoVideos
                                                      .length,
                                                  itemBuilder: (
                                                      followersContext,
                                                      index) {
                                                    return Padding(
                                                      padding: EdgeInsets
                                                          .only(
                                                          left: ScreenUtil()
                                                              .setSp(
                                                              4)),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if ((profileController
                                                              .uploadPhotoVideos
                                                              .length -
                                                              index) ==
                                                              1) {
                                                            uploadPic(
                                                                context);
                                                          } else {
                                                            // muddaVideoDialog(
                                                            //     context, profileController.uploadPhotoVideos);
                                                          }
                                                        },
                                                        child: (profileController
                                                            .uploadPhotoVideos
                                                            .length -
                                                            index) ==
                                                            1
                                                            ? Container(
                                                          height: 100,
                                                          width: 100,
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons
                                                                  .camera_alt,
                                                              size: 50,
                                                              color: Colors
                                                                  .grey,
                                                            ),
                                                          ),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)),
                                                        )
                                                            : Container(
                                                          decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)),
                                                          child: profileController
                                                              .uploadPhotoVideos
                                                              .elementAt(
                                                              index)
                                                              .contains(
                                                              "Trimmer")
                                                              ? Stack(
                                                            children: [
                                                              SizedBox(
                                                                height: 100,
                                                                width: 100,
                                                                child: VideoViewer(
                                                                    trimmer: _trimmer),
                                                              )
                                                            ],
                                                          )
                                                              : Image
                                                              .file(
                                                            File(
                                                                profileController
                                                                    .uploadPhotoVideos
                                                                    .elementAt(
                                                                    index)),
                                                            height: 100,
                                                            width: 100,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                        ),
                                      ),
                                      Obx(
                                            () =>
                                            Visibility(
                                              visible: profileController
                                                  .uploadQuoteRoleList
                                                  .isNotEmpty,
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Post as: ",
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                          fontSize: ScreenUtil()
                                                              .setSp(
                                                              12),
                                                          fontWeight: FontWeight
                                                              .w400,
                                                          color: blackGray),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showRolesDialog(
                                                            context);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          profileController
                                                              .selectedRole
                                                              .value
                                                              .user !=
                                                              null
                                                              ? profileController
                                                              .selectedRole
                                                              .value
                                                              .user!
                                                              .profile !=
                                                              null
                                                              ? CachedNetworkImage(
                                                            imageUrl:
                                                            "${profileController
                                                                .roleProfilePath
                                                                .value}${profileController
                                                                .selectedRole
                                                                .value
                                                                .user!
                                                                .profile}",
                                                            imageBuilder:
                                                                (context,
                                                                imageProvider) =>
                                                                Container(
                                                                  width: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  height: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  decoration: BoxDecoration(
                                                                    color: colorWhite,
                                                                    border: Border
                                                                        .all(
                                                                      width: ScreenUtil()
                                                                          .setSp(
                                                                          1),
                                                                      color: buttonBlue,
                                                                    ),
                                                                    borderRadius: BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            ScreenUtil()
                                                                                .setSp(
                                                                                15)) //                 <--- border radius here
                                                                    ),
                                                                    image: DecorationImage(
                                                                        image: imageProvider,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                            placeholder: (
                                                                context,
                                                                url) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                            errorWidget: (
                                                                context,
                                                                url,
                                                                error) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                          )
                                                              : Container(
                                                            height: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            width: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                color: darkGray,
                                                              ),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                  profileController
                                                                      .selectedRole
                                                                      .value
                                                                      .user!
                                                                      .fullname![0]
                                                                      .toUpperCase(),
                                                                  style: GoogleFonts
                                                                      .nunitoSans(
                                                                      fontWeight: FontWeight
                                                                          .w400,
                                                                      fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                          16),
                                                                      color: black)),
                                                            ),
                                                          )
                                                              : AppPreference()
                                                              .getString(
                                                              PreferencesKey
                                                                  .profile)
                                                              .isNotEmpty
                                                              ? CachedNetworkImage(
                                                            imageUrl:
                                                            "${AppPreference()
                                                                .getString(
                                                                PreferencesKey
                                                                    .profilePath)}${AppPreference()
                                                                .getString(
                                                                PreferencesKey
                                                                    .profile)}",
                                                            imageBuilder:
                                                                (context,
                                                                imageProvider) =>
                                                                Container(
                                                                  width: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  height: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  decoration: BoxDecoration(
                                                                    color: colorWhite,
                                                                    border: Border
                                                                        .all(
                                                                      width: ScreenUtil()
                                                                          .setSp(
                                                                          1),
                                                                      color: buttonBlue,
                                                                    ),
                                                                    borderRadius: BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            ScreenUtil()
                                                                                .setSp(
                                                                                15)) //                 <--- border radius here
                                                                    ),
                                                                    image: DecorationImage(
                                                                        image: imageProvider,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                            placeholder: (
                                                                context,
                                                                url) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                            errorWidget: (
                                                                context,
                                                                url,
                                                                error) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                          )
                                                              : Container(
                                                            height: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            width: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                color: darkGray,
                                                              ),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                  AppPreference()
                                                                      .getString(
                                                                      PreferencesKey
                                                                          .fullName)[0]
                                                                      .toUpperCase(),
                                                                  style: GoogleFonts
                                                                      .nunitoSans(
                                                                      fontWeight: FontWeight
                                                                          .w400,
                                                                      fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                          16),
                                                                      color: black)),
                                                            ),
                                                          ),
                                                          getSizedBox(
                                                              w: 6),
                                                          Text(
                                                              profileController
                                                                  .selectedRole
                                                                  .value
                                                                  .user !=
                                                                  null
                                                                  ? profileController
                                                                  .selectedRole
                                                                  .value
                                                                  .user!
                                                                  .fullname!
                                                                  : "Self",
                                                              style: GoogleFonts
                                                                  .nunitoSans(
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  fontSize: ScreenUtil()
                                                                      .setSp(
                                                                      10),
                                                                  color: buttonBlue,
                                                                  fontStyle: FontStyle
                                                                      .italic)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets
                                            .only(
                                            top: 37),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            GetStartedButton(
                                              onTap: () async {
                                                AppPreference _appPreference = AppPreference();
                                                FormData formData = FormData
                                                    .fromMap(
                                                    {
                                                      "description":
                                                      profileController
                                                          .descriptionValue
                                                          .value,
                                                      "user_id": _appPreference
                                                          .getString(
                                                          PreferencesKey
                                                              .interactUserId),
                                                      "parent_id": quote
                                                          .sId!,
                                                      "post_of": "quote",
                                                    });
                                                for (int i = 0;
                                                i <
                                                    (profileController
                                                        .uploadPhotoVideos
                                                        .length ==
                                                        5
                                                        ? 5
                                                        : (profileController
                                                        .uploadPhotoVideos
                                                        .length -
                                                        1));
                                                i++) {
                                                  formData
                                                      .files
                                                      .addAll(
                                                      [
                                                        MapEntry(
                                                            "gallery",
                                                            await MultipartFile
                                                                .fromFile(
                                                                profileController
                                                                    .uploadPhotoVideos[i],
                                                                filename: profileController
                                                                    .uploadPhotoVideos[i]
                                                                    .split(
                                                                    '/')
                                                                    .last)),
                                                      ]);
                                                }
                                                Api
                                                    .uploadPost
                                                    .call(
                                                    context,
                                                    method: "quote-or-activity/store",
                                                    param: formData,
                                                    isLoading: true,
                                                    onResponseSuccess: (
                                                        Map object) {
                                                      print(
                                                          object);
                                                      var snackBar = const SnackBar(
                                                        content: Text(
                                                            'Uploaded'),
                                                      );
                                                      quote
                                                          .reQuote =
                                                          quote
                                                              .reQuote! +
                                                              1;
                                                      int pIndex = index;
                                                      profileController
                                                          .quotePostList
                                                          .removeAt(
                                                          index);
                                                      profileController
                                                          .quotePostList
                                                          .insert(
                                                          pIndex,
                                                          quote);
                                                      ScaffoldMessenger
                                                          .of(
                                                          context)
                                                          .showSnackBar(
                                                          snackBar);
                                                      // profileController.postForMuddaList.insert(0,PostForMudda.fromJson(object['data']));
                                                      Get
                                                          .back();
                                                    });
                                              },
                                              title: "Post",
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets
                              .all(10),
                          child: SvgPicture.asset(
                            "assets/svg/edit_quote.svg",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 2,
                        backgroundColor: Colors
                            .black,
                      ),
                      getSizedBox(w: 5),
                      Text(
                          convertToAgo(
                              DateTime.parse(
                                  quote
                                      .createdAt!)),
                          style:
                          GoogleFonts.nunitoSans(
                              fontWeight:
                              FontWeight.w400,
                              fontSize:
                              ScreenUtil()
                                  .setSp(12),
                              color: blackGray)),
                    ],
                  )
                ],
              ),
            ) : Padding(
              padding: const EdgeInsets.only(
                  left: 54, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (quote.amILiked !=
                          null) {
                        quote.likersCount =
                            quote
                                .likersCount! -
                                1;
                        quote.amILiked = null;
                      } else {
                        quote.likersCount =
                            quote
                                .likersCount! +
                                1;
                        AmILiked q = AmILiked();
                        q.relativeId =
                        quote.sId!;
                        q.relativeType =
                        "QuoteOrActivity";
                        q.userId =
                            AppPreference()
                                .getString(
                                PreferencesKey
                                    .interactUserId);
                        quote.amILiked = q;
                      }
                      int pIndex = index;
                      profileController
                          .singleActivityPostList
                          .removeAt(index);
                      profileController
                          .singleActivityPostList
                          .insert(
                          pIndex, quote);
                      Api.post.call(
                        context,
                        method: "like/store",
                        isLoading: false,
                        param: {
                          "user_id": AppPreference()
                              .getString(
                              PreferencesKey
                                  .interactUserId),
                          "relative_id": quote
                              .sId!,
                          "relative_type":
                          "QuoteOrActivity",
                          "status": true,
                        },
                        onResponseSuccess: (object) {
                          print(
                              "Abhishek $object");
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets
                          .all(10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/like.svg",
                            color: quote
                                .amILiked !=
                                null
                                ? themeColor
                                : blackGray,
                          ),
                          getSizedBox(w: 5),
                          Text(NumberFormat
                              .compactCurrency(
                            decimalDigits: 0,
                            symbol:
                            '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(quote
                              .likersCount),
                              style: GoogleFonts
                                  .nunitoSans(
                                fontWeight: quote
                                    .amILiked !=
                                    null
                                    ? FontWeight
                                    .w700
                                    : FontWeight
                                    .w400,
                                fontSize: ScreenUtil()
                                    .setSp(
                                    12),
                                color: quote
                                    .amILiked !=
                                    null
                                    ? themeColor
                                    : blackGray,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        AppIcons.messageIcon,
                        color: colorGrey,
                        height: 18,
                        width: 19,
                      ),
                      getSizedBox(w: 3),
                      Text(NumberFormat
                          .compactCurrency(
                        decimalDigits: 0,
                        symbol:
                        '', // if you want to add currency symbol then pass that in this else leave it empty.
                      ).format(quote
                          .commentorsCount),
                          style: GoogleFonts
                              .nunitoSans(
                            fontWeight: FontWeight
                                .w400,
                            fontSize: ScreenUtil()
                                .setSp(12),
                            color: blackGray,
                          )),
                      getSizedBox(w: 15),
                      SvgPicture.asset(
                        "assets/svg/line.svg",
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return CommentsForMuddaBazz(
                                  commentId: quote
                                      .sId!,);
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets
                              .all(10),
                          child: SvgPicture.asset(
                            "assets/svg/edit_quote.svg",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 2,
                        backgroundColor: Colors
                            .black,
                      ),
                      getSizedBox(w: 5),
                      Text(
                          convertToAgo(
                              DateTime.parse(
                                  quote
                                      .createdAt!)),
                          style:
                          GoogleFonts.nunitoSans(
                              fontWeight:
                              FontWeight.w400,
                              fontSize:
                              ScreenUtil()
                                  .setSp(12),
                              color: blackGray)),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setSp(12),
                  left: ScreenUtil().setSp(12)),
              child: const Divider(
                color: Colors.black87,
                height: 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell muddaCardForSingleQoute(Quote quote, int index,
      BuildContext context) {
    return InkWell(
      onTap: () {
        if (quote.postOf == "quote") {
          Get.toNamed(
              RouteConstants.commentSections,
              arguments: quote);
        } else {
          Get.toNamed(
              RouteConstants
                  .muddaPostCommentsScreen,
              arguments: quote);
        }
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: ScreenUtil().setSp(8)),
        padding: EdgeInsets.only(
            bottom: ScreenUtil().setSp(8),
            top: ScreenUtil().setSp(8)),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setSp(12)),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => profileNavigation(context, quote),
                    child: Column(
                      children: [
                        quote.user != null &&
                            quote.user!.profile !=
                                null
                            ? CachedNetworkImage(
                          imageUrl:
                          "${profileController
                              .quoteProfilePath}${quote
                              .user!.profile!}",
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
                                  borderRadius: BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          ScreenUtil()
                                              .setSp(
                                              20)) //                 <--- border radius here
                                  ),
                                  image: DecorationImage(
                                      image:
                                      imageProvider,
                                      fit:
                                      BoxFit
                                          .cover),
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
                              .setSp(45),
                          width: ScreenUtil()
                              .setSp(45),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: darkGray,
                            ),
                            shape: BoxShape
                                .circle,
                          ),
                          child: Center(
                            child: Text(
                                quote.user !=
                                    null &&
                                    quote
                                        .user!
                                        .fullname!
                                        .isNotEmpty
                                    ? quote
                                    .user!
                                    .fullname![
                                0]
                                    .toUpperCase()
                                    : "A",
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
                        getSizedBox(
                            h: ScreenUtil().setSp(
                                8)),
                        SvgPicture.asset(
                            quote.postOf ==
                                "quote"
                                ? "assets/svg/quote.svg"
                                : "assets/svg/activity.svg")
                      ],
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
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Expanded(
                              child: Wrap(
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        profileNavigation(context, quote),
                                    child: Text(
                                      quote.user !=
                                          null
                                          ? quote
                                          .user!
                                          .fullname!
                                          : "",
                                      style: size13_M_bold(
                                          textColor: Colors
                                              .black87),
                                    ),
                                  ),
                                  getSizedBox(
                                      w: 5),
                                  const CircleAvatar(
                                    radius: 2,
                                    backgroundColor:
                                    Colors.black,
                                  ),
                                  getSizedBox(
                                      w: 5),
                                  Text(
                                    quote.user !=
                                        null
                                        ? quote
                                        .user!
                                        .username!
                                        : "",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontStyle:
                                        FontStyle
                                            .italic),
                                  ),
                                ],
                                crossAxisAlignment:
                                WrapCrossAlignment
                                    .center,
                              ),
                            ),
                            iconThreeDot(quote, true, index)
                          ],
                        ),
                        quote.hashtags != null &&
                            quote.hashtags!
                                .isNotEmpty
                            ? Text(
                          quote.hashtags != null
                              ? quote.hashtags!
                              .join(",")
                              : "",
                          style: const TextStyle(
                              fontSize: 13,
                              fontStyle:
                              FontStyle.italic),
                        )
                            : Container(),
                        getSizedBox(
                            h: quote.hashtags !=
                                null &&
                                quote.hashtags!
                                    .isNotEmpty
                                ? 5
                                : 0),
                        quote.description !=
                            null &&
                            quote.description!
                                .isNotEmpty &&
                            quote.description!
                                .length >
                                6
                            ? ReadMoreText(
                          quote.description ??
                              "",
                          trimLines: 6,
                          trimMode:
                          TrimMode.Line,
                          trimCollapsedText:
                          'more',
                          trimExpandedText:
                          'less',
                          style: GoogleFonts
                              .nunitoSans(
                              fontSize:
                              ScreenUtil()
                                  .setSp(
                                  14),
                              fontWeight:
                              FontWeight
                                  .w400,
                              color: black),
                        )
                            : Text("${quote
                            .description}",
                            style: GoogleFonts
                                .nunitoSans(
                                fontSize:
                                ScreenUtil()
                                    .setSp(
                                    14),
                                fontWeight:
                                FontWeight
                                    .w400,
                                color: black)),
                        quote.postOf == "quote" &&
                            quote.gallery!.length == 1
                            ? const SizedBox(height: 8)
                            : const SizedBox(),
                        if(quote.postOf == "quote" &&
                            quote.gallery!.length == 1)
                          InkWell(
                            onTap: () {
                              muddaGalleryDialog(
                                  context,
                                  quote
                                      .gallery!,
                                  profileController
                                      .quotePostPath
                                      .value,
                                  index);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius
                                  .circular(4),
                              child:
                              CachedNetworkImage(
                                height:
                                ScreenUtil()
                                    .setSp(
                                    177),
                                width:
                                ScreenUtil()
                                    .screenWidth,
                                imageUrl:
                                "${profileController
                                    .quotePostPath
                                    .value}${quote
                                    .gallery!
                                    .elementAt(0)
                                    .file!}",
                                fit: BoxFit
                                    .cover,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  getSizedBox(w: 12)
                ],
              ),
            ),
            quote.postOf == "quote" &&
                quote.gallery!
                    .length > 1
                ? SizedBox(
              height: Get.height * 0.17,
              child: ListView.builder(
                  scrollDirection:
                  Axis.horizontal,
                  itemCount:
                  quote.gallery!
                      .length,
                  padding: EdgeInsets
                      .only(
                      top: ScreenUtil()
                          .setSp(8),
                      right: ScreenUtil()
                          .setSp(10),
                      left: ScreenUtil()
                          .setSp(60)),
                  itemBuilder:
                      (followersContext,
                      index) {
                    return Padding(
                      padding:
                      const EdgeInsets
                          .only(
                          right: 2),
                      child:
                      GestureDetector(
                        onTap: () {
                          muddaGalleryDialog(
                              context,
                              quote
                                  .gallery!,
                              profileController
                                  .quotePostPath
                                  .value,
                              index);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius
                              .circular(4),
                          child: CachedNetworkImage(
                            height: Get.height * 0.17,
                            width: Get.width * 0.3,
                            imageUrl:
                            "${profileController
                                .quotePostPath
                                .value}${quote
                                .gallery!
                                .elementAt(
                                index)
                                .file!}",
                            fit: BoxFit
                                .cover,
                          ),
                        ),
                      ),
                    );
                  }),
            )
                : Container(),
            quote.postOf == "activity" &&
                quote.gallery!.isNotEmpty
                ? Obx(
                  () =>
                  Container(
                    height:
                    ScreenUtil()
                        .setSp(
                        370),
                    width:
                    ScreenUtil()
                        .screenWidth,
                    margin: const EdgeInsets.only(
                        top: 8),
                    child: Stack(
                      children: [
                        CarouselSlider.builder(
                            carouselController: controller,
                            options: CarouselOptions(
                              initialPage: 0,
                              height: ScreenUtil()
                                  .setSp(
                                  370),
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                              onPageChanged: (index,
                                  reason) {
                                profileController
                                    .currentHorizontal
                                    .value =
                                    index;
                              },
                            ),
                            itemCount: quote
                                .gallery!.length,
                            itemBuilder: (context,
                                index2,
                                realIndex) {
                              Gallery mediaModelData = quote
                                  .gallery![index2];
                              return InkWell(
                                onTap: () {
                                  muddaGalleryDialog(
                                      context,
                                      quote
                                          .gallery!,
                                      profileController
                                          .quotePostPath
                                          .value,
                                      index2);
                                },
                                child: Stack(
                                  alignment: Alignment
                                      .center,
                                  children: [
                                    /* !mediaModelData.file!.contains(".mp4")
                                                          ? SizedBox(
                                                        height:
                                                        ScreenUtil()
                                                            .setSp(
                                                            370),
                                                        width:
                                                        ScreenUtil()
                                                            .screenWidth,
                                                            child: CachedNetworkImage(
                                                            imageUrl: "${profileController.quotePostPath.value}${mediaModelData.file!}",
                                                            fit: BoxFit.cover,),
                                                          )
                                                          : GestureDetector(
                                                        onLongPressUp: () {
                                                          profileController.isOnPageHorizontalTurning.value = false;
                                                        },
                                                        onLongPress: () {
                                                          profileController.isOnPageHorizontalTurning.value = true;
                                                        },
                                                        onTap: () {
                                                          */ /*setStates(() {
                                                    isDialOpen.value = false;
                                                    if (visibilityTag) {
                                                      visibilityTag = false;
                                                    }
                                                    hideShowTag = !hideShowTag;
                                                  });*/ /*
                                                        },
                                                        child: VideoPlayerScreen(
                                                            mediaModelData.file!,
                                                            profileController.quotePostPath.value,
                                                            index2,
                                                            profileController.currentHorizontal.value,
                                                            index,
                                                            0,
                                                            true,
                                                            videoController,
                                                            profileController.isOnPageHorizontalTurning.value),
                                                      ),*/
                                    SizedBox(
                                      height:
                                      ScreenUtil()
                                          .setSp(
                                          370),
                                      width:
                                      ScreenUtil()
                                          .screenWidth,
                                      child: CachedNetworkImage(
                                        imageUrl: "${profileController
                                            .quotePostPath
                                            .value}${mediaModelData
                                            .file!}",
                                        fit: BoxFit
                                            .cover,),
                                    )
                                  ],
                                ),
                              );
                            }),
                        Align(
                          alignment: Alignment
                              .bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets
                                .only(bottom: 9),
                            child: AnimatedSmoothIndicator(
                                onDotClicked: (index) {
                                  controller
                                      .animateToPage(
                                      index);
                                },
                                activeIndex: profileController
                                    .currentHorizontal
                                    .value,
                                count: quote
                                    .gallery!
                                    .length,
                                effect: CustomizableEffect(
                                  activeDotDecoration: DotDecoration(
                                    width: 12.0,
                                    height: 3.0,
                                    color: Colors
                                        .amber,
                                    // rotationAngle: 180,
                                    // verticalOffset: -10,
                                    borderRadius: BorderRadius
                                        .circular(
                                        24),
                                    dotBorder: const DotBorder(
                                      padding: 1,
                                      width: 2,
                                      color: Colors
                                          .white,
                                    ),
                                  ),
                                  dotDecoration: DotDecoration(
                                    width: 12.0,
                                    height: 3.0,
                                    // color: lightRed,
                                    dotBorder: const DotBorder(
                                      padding: 0,
                                      width: 0.5,
                                      color: Colors
                                          .white,
                                    ),
                                    // borderRadius: BorderRadius.only(
                                    //     topLeft: Radius.circular(2),
                                    //     topRight: Radius.circular(16),
                                    //     bottomLeft: Radius.circular(16),
                                    //     bottomRight: Radius.circular(2)),
                                    borderRadius: BorderRadius
                                        .circular(
                                        16),
                                    // verticalOffset: 0,
                                  ),
                                  // spacing: 6.0,
                                  // activeColorOverride: (i) => colors[i],
                                  inActiveColorOverride: (i) => white,
                                )
                              // const SlideEffect(
                              //     spacing: 10.0,
                              //     radius: 3.0,
                              //     dotWidth: 6.0,
                              //     dotHeight: 6.0,
                              //     paintStyle: PaintingStyle.stroke,
                              //     strokeWidth: 1.5,
                              //     dotColor: white,
                              //     activeDotColor: lightRed),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            )
                : Container(),
            getSizedBox(h: ScreenUtil().setSp(8)),
            Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setSp(12),
                  left: ScreenUtil().setSp(12)),
              child: const Divider(
                color: Colors.black87,
                height: 1,
              ),
            ),
            quote.postOf ==
                "quote" ? Padding(
              padding: const EdgeInsets.only(
                  left: 54, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     Share.share(
                      //       '${Const
                      //           .shareUrl}${quote
                      //           .postOf}/${quote
                      //           .sId}',
                      //     );
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets
                      //         .all(10),
                      //     child: SvgPicture.asset(
                      //       "assets/svg/share.svg",
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          if (quote.amILiked !=
                              null) {
                            quote.likersCount =
                                quote
                                    .likersCount! -
                                    1;
                            quote.amILiked = null;
                          } else {
                            quote.likersCount =
                                quote
                                    .likersCount! +
                                    1;
                            AmILiked q = AmILiked();
                            q.relativeId =
                            quote.sId!;
                            q.relativeType =
                            "QuoteOrActivity";
                            q.userId =
                                AppPreference()
                                    .getString(
                                    PreferencesKey
                                        .interactUserId);
                            quote.amILiked = q;
                          }
                          int pIndex = index;
                          profileController
                              .singleQuotePostList
                              .removeAt(index);
                          profileController
                              .singleQuotePostList
                              .insert(
                              pIndex, quote);
                          Api.post.call(
                            context,
                            method: "like/store",
                            isLoading: false,
                            param: {
                              "user_id": AppPreference()
                                  .getString(
                                  PreferencesKey
                                      .interactUserId),
                              "relative_id": quote
                                  .sId!,
                              "relative_type":
                              "QuoteOrActivity",
                              "status": true,
                            },
                            onResponseSuccess: (object) {
                              print(
                                  "Abhishek $object");
                            },
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/like.svg",
                              color: quote
                                  .amILiked !=
                                  null
                                  ? themeColor
                                  : blackGray,
                            ),
                            getSizedBox(w: 5),
                            Text(NumberFormat
                                .compactCurrency(
                              decimalDigits: 0,
                              symbol:
                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                            ).format(quote
                                .likersCount),
                                style: GoogleFonts
                                    .nunitoSans(
                                  fontWeight: quote
                                      .amILiked !=
                                      null
                                      ? FontWeight
                                      .w700
                                      : FontWeight
                                      .w400,
                                  fontSize: ScreenUtil()
                                      .setSp(
                                      12),
                                  color: quote
                                      .amILiked !=
                                      null
                                      ? themeColor
                                      : blackGray,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets
                            .all(10),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons
                                  .reQuoteIcon,
                            ),
                            getSizedBox(w: 5),
                            Text(NumberFormat
                                .compactCurrency(
                              decimalDigits: 0,
                              symbol:
                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                            ).format(
                                quote.reQuote),
                                style: GoogleFonts
                                    .nunitoSans(
                                  fontWeight: FontWeight
                                      .w400,
                                  fontSize: ScreenUtil()
                                      .setSp(12),
                                  color: blackGray,
                                )),
                          ],
                        ),
                      ),
                      getSizedBox(w: 5),
                      SvgPicture.asset(
                        "assets/svg/line.svg",
                      ),
                      InkWell(
                        onTap: () {
                          profileController
                              .uploadPhotoVideos
                              .value = [""];
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors
                                .transparent,
                            builder: (context) =>
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors
                                        .white,
                                    borderRadius: BorderRadius
                                        .only(
                                      topLeft: Radius
                                          .circular(
                                          16),
                                      topRight: Radius
                                          .circular(
                                          16),
                                    ),
                                  ),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment
                                        .center,
                                    alignment: WrapAlignment
                                        .center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets
                                            .only(
                                            top: 24,
                                            bottom: 32),
                                        child: Wrap(
                                          crossAxisAlignment: WrapCrossAlignment
                                              .center,
                                          children: [
                                            Text(
                                              "Create Re-Quote",
                                              style: GoogleFonts
                                                  .nunitoSans(
                                                  fontSize: ScreenUtil()
                                                      .setSp(
                                                      16),
                                                  fontWeight: FontWeight
                                                      .w700,
                                                  color: black),
                                            ),
                                            getSizedBox(
                                                w: 8),
                                            SvgPicture
                                                .asset(
                                              AppIcons
                                                  .reQuoteIcon,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets
                                            .symmetric(
                                            horizontal: ScreenUtil()
                                                .setSp(
                                                42)),
                                        child: Container(
                                          height: getHeight(
                                              160),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  8),
                                              border: Border
                                                  .all(
                                                  color: Colors
                                                      .blue)),
                                          child: TextFormField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  300),
                                            ],
                                            textInputAction: TextInputAction
                                                .newline,
                                            textCapitalization: TextCapitalization
                                                .sentences,
                                            keyboardType: TextInputType
                                                .multiline,
                                            maxLines: null,
                                            onChanged: (text) {
                                              profileController
                                                  .descriptionValue
                                                  .value =
                                                  text;
                                            },
                                            style: size14_M_normal(
                                                textColor: color606060),
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 15,
                                                  vertical: 10),
                                              hintText: "Enter Text for the Quote",
                                              border: InputBorder
                                                  .none,
                                              hintStyle: size12_M_normal(
                                                  textColor: color606060),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                            () =>
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 20,
                                                  vertical: 5),
                                              child: Row(
                                                children: [
                                                  const Spacer(),
                                                  Text(
                                                    "remain ${300 -
                                                        profileController
                                                            .descriptionValue
                                                            .value
                                                            .length} characters",
                                                    style: size10_M_normal(
                                                        textColor: colorGrey),
                                                  )
                                                ],
                                              ),
                                            ),
                                      ),
                                      Container(
                                        height: 100,
                                        margin: const EdgeInsets
                                            .only(
                                            top: 20),
                                        child: Obx(
                                              () =>
                                              ListView
                                                  .builder(
                                                  scrollDirection: Axis
                                                      .horizontal,
                                                  padding: EdgeInsets
                                                      .only(
                                                      left: ScreenUtil()
                                                          .setSp(
                                                          38)),
                                                  itemCount: profileController
                                                      .uploadPhotoVideos
                                                      .length >
                                                      5
                                                      ? 5
                                                      : profileController
                                                      .uploadPhotoVideos
                                                      .length,
                                                  itemBuilder: (
                                                      followersContext,
                                                      index) {
                                                    return Padding(
                                                      padding: EdgeInsets
                                                          .only(
                                                          left: ScreenUtil()
                                                              .setSp(
                                                              4)),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if ((profileController
                                                              .uploadPhotoVideos
                                                              .length -
                                                              index) ==
                                                              1) {
                                                            uploadPic(
                                                                context);
                                                          } else {
                                                            // muddaVideoDialog(
                                                            //     context, profileController.uploadPhotoVideos);
                                                          }
                                                        },
                                                        child: (profileController
                                                            .uploadPhotoVideos
                                                            .length -
                                                            index) ==
                                                            1
                                                            ? Container(
                                                          height: 100,
                                                          width: 100,
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons
                                                                  .camera_alt,
                                                              size: 50,
                                                              color: Colors
                                                                  .grey,
                                                            ),
                                                          ),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)),
                                                        )
                                                            : Container(
                                                          decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)),
                                                          child: profileController
                                                              .uploadPhotoVideos
                                                              .elementAt(
                                                              index)
                                                              .contains(
                                                              "Trimmer")
                                                              ? Stack(
                                                            children: [
                                                              SizedBox(
                                                                height: 100,
                                                                width: 100,
                                                                child: VideoViewer(
                                                                    trimmer: _trimmer),
                                                              )
                                                            ],
                                                          )
                                                              : Image
                                                              .file(
                                                            File(
                                                                profileController
                                                                    .uploadPhotoVideos
                                                                    .elementAt(
                                                                    index)),
                                                            height: 100,
                                                            width: 100,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                        ),
                                      ),
                                      Obx(
                                            () =>
                                            Visibility(
                                              visible: profileController
                                                  .uploadQuoteRoleList
                                                  .isNotEmpty,
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Post as: ",
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                          fontSize: ScreenUtil()
                                                              .setSp(
                                                              12),
                                                          fontWeight: FontWeight
                                                              .w400,
                                                          color: blackGray),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showRolesDialog(
                                                            context);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          profileController
                                                              .selectedRole
                                                              .value
                                                              .user !=
                                                              null
                                                              ? profileController
                                                              .selectedRole
                                                              .value
                                                              .user!
                                                              .profile !=
                                                              null
                                                              ? CachedNetworkImage(
                                                            imageUrl:
                                                            "${profileController
                                                                .roleProfilePath
                                                                .value}${profileController
                                                                .selectedRole
                                                                .value
                                                                .user!
                                                                .profile}",
                                                            imageBuilder:
                                                                (context,
                                                                imageProvider) =>
                                                                Container(
                                                                  width: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  height: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  decoration: BoxDecoration(
                                                                    color: colorWhite,
                                                                    border: Border
                                                                        .all(
                                                                      width: ScreenUtil()
                                                                          .setSp(
                                                                          1),
                                                                      color: buttonBlue,
                                                                    ),
                                                                    borderRadius: BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            ScreenUtil()
                                                                                .setSp(
                                                                                15)) //                 <--- border radius here
                                                                    ),
                                                                    image: DecorationImage(
                                                                        image: imageProvider,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                            placeholder: (
                                                                context,
                                                                url) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                            errorWidget: (
                                                                context,
                                                                url,
                                                                error) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                          )
                                                              : Container(
                                                            height: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            width: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                color: darkGray,
                                                              ),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                  profileController
                                                                      .selectedRole
                                                                      .value
                                                                      .user!
                                                                      .fullname![0]
                                                                      .toUpperCase(),
                                                                  style: GoogleFonts
                                                                      .nunitoSans(
                                                                      fontWeight: FontWeight
                                                                          .w400,
                                                                      fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                          16),
                                                                      color: black)),
                                                            ),
                                                          )
                                                              : AppPreference()
                                                              .getString(
                                                              PreferencesKey
                                                                  .profile)
                                                              .isNotEmpty
                                                              ? CachedNetworkImage(
                                                            imageUrl:
                                                            "${AppPreference()
                                                                .getString(
                                                                PreferencesKey
                                                                    .profilePath)}${AppPreference()
                                                                .getString(
                                                                PreferencesKey
                                                                    .profile)}",
                                                            imageBuilder:
                                                                (context,
                                                                imageProvider) =>
                                                                Container(
                                                                  width: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  height: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  decoration: BoxDecoration(
                                                                    color: colorWhite,
                                                                    border: Border
                                                                        .all(
                                                                      width: ScreenUtil()
                                                                          .setSp(
                                                                          1),
                                                                      color: buttonBlue,
                                                                    ),
                                                                    borderRadius: BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            ScreenUtil()
                                                                                .setSp(
                                                                                15)) //                 <--- border radius here
                                                                    ),
                                                                    image: DecorationImage(
                                                                        image: imageProvider,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                            placeholder: (
                                                                context,
                                                                url) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                            errorWidget: (
                                                                context,
                                                                url,
                                                                error) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                          )
                                                              : Container(
                                                            height: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            width: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                color: darkGray,
                                                              ),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                  AppPreference()
                                                                      .getString(
                                                                      PreferencesKey
                                                                          .fullName)[0]
                                                                      .toUpperCase(),
                                                                  style: GoogleFonts
                                                                      .nunitoSans(
                                                                      fontWeight: FontWeight
                                                                          .w400,
                                                                      fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                          16),
                                                                      color: black)),
                                                            ),
                                                          ),
                                                          getSizedBox(
                                                              w: 6),
                                                          Text(
                                                              profileController
                                                                  .selectedRole
                                                                  .value
                                                                  .user !=
                                                                  null
                                                                  ? profileController
                                                                  .selectedRole
                                                                  .value
                                                                  .user!
                                                                  .fullname!
                                                                  : "Self",
                                                              style: GoogleFonts
                                                                  .nunitoSans(
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  fontSize: ScreenUtil()
                                                                      .setSp(
                                                                      10),
                                                                  color: buttonBlue,
                                                                  fontStyle: FontStyle
                                                                      .italic)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets
                                            .only(
                                            top: 37),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            GetStartedButton(
                                              onTap: () async {
                                                AppPreference _appPreference = AppPreference();
                                                FormData formData = FormData
                                                    .fromMap(
                                                    {
                                                      "description":
                                                      profileController
                                                          .descriptionValue
                                                          .value,
                                                      "user_id": _appPreference
                                                          .getString(
                                                          PreferencesKey
                                                              .interactUserId),
                                                      "parent_id": quote
                                                          .sId!,
                                                      "post_of": "quote",
                                                    });
                                                for (int i = 0;
                                                i <
                                                    (profileController
                                                        .uploadPhotoVideos
                                                        .length ==
                                                        5
                                                        ? 5
                                                        : (profileController
                                                        .uploadPhotoVideos
                                                        .length -
                                                        1));
                                                i++) {
                                                  formData
                                                      .files
                                                      .addAll(
                                                      [
                                                        MapEntry(
                                                            "gallery",
                                                            await MultipartFile
                                                                .fromFile(
                                                                profileController
                                                                    .uploadPhotoVideos[i],
                                                                filename: profileController
                                                                    .uploadPhotoVideos[i]
                                                                    .split(
                                                                    '/')
                                                                    .last)),
                                                      ]);
                                                }
                                                Api
                                                    .uploadPost
                                                    .call(
                                                    context,
                                                    method: "quote-or-activity/store",
                                                    param: formData,
                                                    isLoading: true,
                                                    onResponseSuccess: (
                                                        Map object) {
                                                      print(
                                                          object);
                                                      var snackBar = const SnackBar(
                                                        content: Text(
                                                            'Uploaded'),
                                                      );
                                                      quote
                                                          .reQuote =
                                                          quote
                                                              .reQuote! +
                                                              1;
                                                      int pIndex = index;
                                                      profileController
                                                          .quotePostList
                                                          .removeAt(
                                                          index);
                                                      profileController
                                                          .quotePostList
                                                          .insert(
                                                          pIndex,
                                                          quote);
                                                      ScaffoldMessenger
                                                          .of(
                                                          context)
                                                          .showSnackBar(
                                                          snackBar);
                                                      // profileController.postForMuddaList.insert(0,PostForMudda.fromJson(object['data']));
                                                      Get
                                                          .back();
                                                    });
                                              },
                                              title: "Post",
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets
                              .all(10),
                          child: SvgPicture.asset(
                            "assets/svg/edit_quote.svg",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 2,
                        backgroundColor: Colors
                            .black,
                      ),
                      getSizedBox(w: 5),
                      Text(
                          convertToAgo(
                              DateTime.parse(
                                  quote
                                      .createdAt!)),
                          style:
                          GoogleFonts.nunitoSans(
                              fontWeight:
                              FontWeight.w400,
                              fontSize:
                              ScreenUtil()
                                  .setSp(12),
                              color: blackGray)),
                    ],
                  )
                ],
              ),
            ) : Padding(
              padding: const EdgeInsets.only(
                  left: 54, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (quote.amILiked !=
                          null) {
                        quote.likersCount =
                            quote
                                .likersCount! -
                                1;
                        quote.amILiked = null;
                      } else {
                        quote.likersCount =
                            quote
                                .likersCount! +
                                1;
                        AmILiked q = AmILiked();
                        q.relativeId =
                        quote.sId!;
                        q.relativeType =
                        "QuoteOrActivity";
                        q.userId =
                            AppPreference()
                                .getString(
                                PreferencesKey
                                    .interactUserId);
                        quote.amILiked = q;
                      }
                      int pIndex = index;
                      profileController
                          .singleQuotePostList
                          .removeAt(index);
                      profileController
                          .singleQuotePostList
                          .insert(
                          pIndex, quote);
                      Api.post.call(
                        context,
                        method: "like/store",
                        isLoading: false,
                        param: {
                          "user_id": AppPreference()
                              .getString(
                              PreferencesKey
                                  .interactUserId),
                          "relative_id": quote
                              .sId!,
                          "relative_type":
                          "QuoteOrActivity",
                          "status": quote
                              .amILiked !=
                              null,
                        },
                        onResponseSuccess: (object) {
                          print(
                              "Abhishek $object");
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets
                          .all(10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/like.svg",
                            color: quote
                                .amILiked !=
                                null
                                ? themeColor
                                : blackGray,
                          ),
                          getSizedBox(w: 5),
                          Text(NumberFormat
                              .compactCurrency(
                            decimalDigits: 0,
                            symbol:
                            '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(quote
                              .likersCount),
                              style: GoogleFonts
                                  .nunitoSans(
                                fontWeight: quote
                                    .amILiked !=
                                    null
                                    ? FontWeight
                                    .w700
                                    : FontWeight
                                    .w400,
                                fontSize: ScreenUtil()
                                    .setSp(
                                    12),
                                color: quote
                                    .amILiked !=
                                    null
                                    ? themeColor
                                    : blackGray,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        AppIcons.messageIcon,
                        color: colorGrey,
                        height: 18,
                        width: 19,
                      ),
                      getSizedBox(w: 3),
                      Text(NumberFormat
                          .compactCurrency(
                        decimalDigits: 0,
                        symbol:
                        '', // if you want to add currency symbol then pass that in this else leave it empty.
                      ).format(quote
                          .commentorsCount),
                          style: GoogleFonts
                              .nunitoSans(
                            fontWeight: FontWeight
                                .w400,
                            fontSize: ScreenUtil()
                                .setSp(12),
                            color: blackGray,
                          )),
                      getSizedBox(w: 15),
                      SvgPicture.asset(
                        "assets/svg/line.svg",
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return CommentsForMuddaBazz(
                                  commentId: quote
                                      .sId!,);
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets
                              .all(10),
                          child: SvgPicture.asset(
                            "assets/svg/edit_quote.svg",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 2,
                        backgroundColor: Colors
                            .black,
                      ),
                      getSizedBox(w: 5),
                      Text(
                          convertToAgo(
                              DateTime.parse(
                                  quote
                                      .createdAt!)),
                          style:
                          GoogleFonts.nunitoSans(
                              fontWeight:
                              FontWeight.w400,
                              fontSize:
                              ScreenUtil()
                                  .setSp(12),
                              color: blackGray)),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setSp(12),
                  left: ScreenUtil().setSp(12)),
              child: const Divider(
                color: Colors.black87,
                height: 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell muddebazzCard(Quote quote, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        if (quote.postOf == "quote") {
          Get.toNamed(
              RouteConstants.commentSections,
              arguments: quote);
        } else {
          Get.toNamed(
              RouteConstants
                  .muddaPostCommentsScreen,
              arguments: quote);
        }
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: ScreenUtil().setSp(8)),
        padding: EdgeInsets.only(
            bottom: ScreenUtil().setSp(8),
            top: ScreenUtil().setSp(8)),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setSp(12)),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      profileNavigation(context, quote);
                    },
                    child: Column(
                      children: [
                        quote.user != null &&
                            quote.user!.profile !=
                                null
                            ? CachedNetworkImage(
                          imageUrl:
                          "${profileController
                              .quoteProfilePath}${quote
                              .user!.profile!}",
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
                                  borderRadius: BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          ScreenUtil()
                                              .setSp(
                                              20)) //                 <--- border radius here
                                  ),
                                  image: DecorationImage(
                                      image:
                                      imageProvider,
                                      fit:
                                      BoxFit
                                          .cover),
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
                              .setSp(45),
                          width: ScreenUtil()
                              .setSp(45),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: darkGray,
                            ),
                            shape: BoxShape
                                .circle,
                          ),
                          child: Center(
                            child: Text(
                                quote.user !=
                                    null &&
                                    quote
                                        .user!
                                        .fullname!
                                        .isNotEmpty
                                    ? quote
                                    .user!
                                    .fullname![
                                0]
                                    .toUpperCase()
                                    : "A",
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
                        getSizedBox(
                            h: ScreenUtil().setSp(
                                8)),
                        SvgPicture.asset(
                            quote.postOf ==
                                "quote"
                                ? "assets/svg/quote.svg"
                                : "assets/svg/activity.svg")
                      ],
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
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Expanded(
                              child: Wrap(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        profileNavigation(context, quote),
                                    child: Text(
                                      quote.user !=
                                          null
                                          ? quote
                                          .user!
                                          .fullname!
                                          : "",
                                      style: size13_M_bold(
                                          textColor: Colors
                                              .black87),
                                    ),
                                  ),
                                  getSizedBox(
                                      w: 5),
                                  const CircleAvatar(
                                    radius: 2,
                                    backgroundColor:
                                    Colors.black,
                                  ),
                                  getSizedBox(
                                      w: 5),
                                  Text(
                                    quote.user !=
                                        null
                                        ? quote
                                        .user!
                                        .username!
                                        : "",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontStyle:
                                        FontStyle
                                            .italic),
                                  ),
                                ],
                                crossAxisAlignment:
                                WrapCrossAlignment
                                    .center,
                              ),
                            ),
                            iconThreeDot(quote, null, index)
                          ],
                        ),
                        quote.hashtags != null &&
                            quote.hashtags!
                                .isNotEmpty
                            ? Text(
                          quote.hashtags != null
                              ? quote.hashtags!
                              .join(",")
                              : "",
                          style: const TextStyle(
                              fontSize: 13,
                              fontStyle:
                              FontStyle.italic),
                        )
                            : Container(),
                        getSizedBox(
                            h: quote.hashtags !=
                                null &&
                                quote.hashtags!
                                    .isNotEmpty
                                ? 5
                                : 0),
                        quote.description !=
                            null &&
                            quote.description!
                                .isNotEmpty &&
                            quote.description!
                                .length >
                                6
                            ? ReadMoreText(
                          quote.description ??
                              "",
                          trimLines: 6,
                          trimMode:
                          TrimMode.Line,
                          trimCollapsedText:
                          'more',
                          trimExpandedText:
                          'less',
                          style: GoogleFonts
                              .nunitoSans(
                              fontSize:
                              ScreenUtil()
                                  .setSp(
                                  14),
                              fontWeight:
                              FontWeight
                                  .w400,
                              color: black),
                        )
                            : Text("${quote
                            .description}",
                            style: GoogleFonts
                                .nunitoSans(
                                fontSize:
                                ScreenUtil()
                                    .setSp(
                                    14),
                                fontWeight:
                                FontWeight
                                    .w400,
                                color: black)),
                        quote.postOf == "quote" &&
                            quote.gallery!.length == 1
                            ? const SizedBox(height: 4)
                            : const SizedBox(),
                        if(quote.postOf == "quote" &&
                            quote.gallery!.length == 1)
                          InkWell(
                            onTap: () {
                              muddaGalleryDialog(
                                  context,
                                  quote
                                      .gallery!,
                                  profileController
                                      .quotePostPath
                                      .value,
                                  index);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius
                                  .circular(4),
                              child:
                              CachedNetworkImage(
                                height:
                                ScreenUtil()
                                    .setSp(
                                    177),
                                width:
                                ScreenUtil()
                                    .screenWidth,
                                imageUrl:
                                "${profileController
                                    .quotePostPath
                                    .value}${quote
                                    .gallery!
                                    .elementAt(0)
                                    .file!}",
                                fit: BoxFit
                                    .cover,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  getSizedBox(w: 12)
                ],
              ),
            ),
            quote.postOf == "quote" &&
                quote.gallery!
                    .length > 1
                ? SizedBox(
              height: Get.height * 0.17,
              child: ListView.builder(
                  scrollDirection:
                  Axis.horizontal,
                  itemCount:
                  quote.gallery!
                      .length,
                  padding: EdgeInsets
                      .only(
                      top: ScreenUtil()
                          .setSp(8),
                      right: ScreenUtil()
                          .setSp(10),
                      left: ScreenUtil()
                          .setSp(60)),
                  itemBuilder:
                      (followersContext,
                      index) {
                    return Padding(
                      padding:
                      const EdgeInsets
                          .only(
                          right: 2),
                      child:
                      GestureDetector(
                        onTap: () {
                          muddaGalleryDialog(
                              context,
                              quote
                                  .gallery!,
                              profileController
                                  .quotePostPath
                                  .value,
                              index);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius
                              .circular(4),
                          child: CachedNetworkImage(
                            height: Get.height * 0.17,
                            width: Get.width * 0.3,
                            imageUrl:
                            "${profileController
                                .quotePostPath
                                .value}${quote
                                .gallery!
                                .elementAt(
                                index)
                                .file!}",
                            fit: BoxFit
                                .cover,
                          ),
                        ),
                      ),
                    );
                  }),
            )
                : Container(),
            quote.postOf == "activity" &&
                quote.gallery!.isNotEmpty
                ? Obx(
                  () =>
                  Container(
                    height:
                    ScreenUtil()
                        .setSp(
                        370),
                    width:
                    ScreenUtil()
                        .screenWidth,
                    margin: const EdgeInsets.only(
                        top: 8),
                    child: Stack(
                      children: [
                        CarouselSlider.builder(
                            carouselController: controller,
                            options: CarouselOptions(
                              initialPage: 0,
                              height: ScreenUtil()
                                  .setSp(
                                  370),
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                              onPageChanged: (index,
                                  reason) {
                                profileController
                                    .currentHorizontal
                                    .value =
                                    index;
                              },
                            ),
                            itemCount: quote
                                .gallery!.length,
                            itemBuilder: (context,
                                index2,
                                realIndex) {
                              Gallery mediaModelData = quote
                                  .gallery![index2];
                              return Stack(
                                alignment: Alignment
                                    .center,
                                children: [
                                  /* !mediaModelData.file!.contains(".mp4")
                                                        ? SizedBox(
                                                      height:
                                                      ScreenUtil()
                                                          .setSp(
                                                          370),
                                                      width:
                                                      ScreenUtil()
                                                          .screenWidth,
                                                          child: CachedNetworkImage(
                                                          imageUrl: "${profileController.quotePostPath.value}${mediaModelData.file!}",
                                                          fit: BoxFit.cover,),
                                                        )
                                                        : GestureDetector(
                                                      onLongPressUp: () {
                                                        profileController.isOnPageHorizontalTurning.value = false;
                                                      },
                                                      onLongPress: () {
                                                        profileController.isOnPageHorizontalTurning.value = true;
                                                      },
                                                      onTap: () {
                                                        */
                                  /*setStates(() {
                                                  isDialOpen.value = false;
                                                  if (visibilityTag) {
                                                    visibilityTag = false;
                                                  }
                                                  hideShowTag = !hideShowTag;
                                                });*/ /*
                                                      },
                                                      child: VideoPlayerScreen(
                                                          mediaModelData.file!,
                                                          profileController.quotePostPath.value,
                                                          index2,
                                                          profileController.currentHorizontal.value,
                                                          index,
                                                          0,
                                                          true,
                                                          videoController,
                                                          profileController.isOnPageHorizontalTurning.value),
                                                    ),*/
                                  SizedBox(
                                    height:
                                    ScreenUtil()
                                        .setSp(
                                        370),
                                    width:
                                    ScreenUtil()
                                        .screenWidth,
                                    child: CachedNetworkImage(
                                      imageUrl: "${profileController
                                          .quotePostPath
                                          .value}${mediaModelData
                                          .file!}",
                                      fit: BoxFit
                                          .cover,),
                                  )
                                ],
                              );
                            }),
                        Align(
                          alignment: Alignment
                              .bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets
                                .only(bottom: 9),
                            child: AnimatedSmoothIndicator(
                                onDotClicked: (index) {
                                  controller
                                      .animateToPage(
                                      index);
                                },
                                activeIndex: profileController
                                    .currentHorizontal
                                    .value,
                                count: quote
                                    .gallery!
                                    .length,
                                effect: CustomizableEffect(
                                  activeDotDecoration: DotDecoration(
                                    width: 12.0,
                                    height: 3.0,
                                    color: Colors
                                        .amber,
                                    // rotationAngle: 180,
                                    // verticalOffset: -10,
                                    borderRadius: BorderRadius
                                        .circular(
                                        24),
                                    dotBorder: const DotBorder(
                                      padding: 1,
                                      width: 2,
                                      color: Colors
                                          .white,
                                    ),
                                  ),
                                  dotDecoration: DotDecoration(
                                    width: 12.0,
                                    height: 3.0,
                                    // color: lightRed,
                                    dotBorder: const DotBorder(
                                      padding: 0,
                                      width: 0.5,
                                      color: Colors
                                          .white,
                                    ),
                                    // borderRadius: BorderRadius.only(
                                    //     topLeft: Radius.circular(2),
                                    //     topRight: Radius.circular(16),
                                    //     bottomLeft: Radius.circular(16),
                                    //     bottomRight: Radius.circular(2)),
                                    borderRadius: BorderRadius
                                        .circular(
                                        16),
                                    // verticalOffset: 0,
                                  ),
                                  // spacing: 6.0,
                                  // activeColorOverride: (i) => colors[i],
                                  inActiveColorOverride: (i) => white,
                                )
                              // const SlideEffect(
                              //     spacing: 10.0,
                              //     radius: 3.0,
                              //     dotWidth: 6.0,
                              //     dotHeight: 6.0,
                              //     paintStyle: PaintingStyle.stroke,
                              //     strokeWidth: 1.5,
                              //     dotColor: white,
                              //     activeDotColor: lightRed),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            )
                : Container(),
            getSizedBox(h: ScreenUtil().setSp(8)),
            Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setSp(12),
                  left: ScreenUtil().setSp(12)),
              child: const Divider(
                color: Colors.black87,
                height: 1,
              ),
            ),
            quote.postOf ==
                "quote" ? Padding(
              padding: const EdgeInsets.only(
                  left: 54, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     Share.share(
                      //       '${Const
                      //           .shareUrl}${quote
                      //           .postOf}/${quote
                      //           .sId}',
                      //     );
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets
                      //         .all(10),
                      //     child: SvgPicture.asset(
                      //       "assets/svg/share.svg",
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          if (quote.amILiked !=
                              null) {
                            quote.likersCount =
                                quote
                                    .likersCount! -
                                    1;
                            quote.amILiked = null;
                          } else {
                            quote.likersCount =
                                quote
                                    .likersCount! +
                                    1;
                            AmILiked q = AmILiked();
                            q.relativeId =
                            quote.sId!;
                            q.relativeType =
                            "QuoteOrActivity";
                            q.userId =
                                AppPreference()
                                    .getString(
                                    PreferencesKey
                                        .interactUserId);
                            quote.amILiked = q;
                          }
                          int pIndex = index;
                          profileController
                              .quotePostList
                              .removeAt(index);
                          profileController
                              .quotePostList
                              .insert(
                              pIndex, quote);
                          Api.post.call(
                            context,
                            method: "like/store",
                            isLoading: false,
                            param: {
                              "user_id": AppPreference()
                                  .getString(
                                  PreferencesKey
                                      .interactUserId),
                              "relative_id": quote
                                  .sId!,
                              "relative_type":
                              "QuoteOrActivity",
                              "status": true,
                            },
                            onResponseSuccess: (object) {
                              if (kDebugMode) {
                                print(
                                    "Abhishek $object");
                              }
                            },
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/like.svg",
                              color: quote
                                  .amILiked !=
                                  null
                                  ? themeColor
                                  : blackGray,
                            ),
                            getSizedBox(w: 5),
                            Text(NumberFormat
                                .compactCurrency(
                              decimalDigits: 0,
                              symbol:
                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                            ).format(quote
                                .likersCount),
                                style: GoogleFonts
                                    .nunitoSans(
                                  fontWeight: quote
                                      .amILiked !=
                                      null
                                      ? FontWeight
                                      .w700
                                      : FontWeight
                                      .w400,
                                  fontSize: ScreenUtil()
                                      .setSp(
                                      12),
                                  color: quote
                                      .amILiked !=
                                      null
                                      ? themeColor
                                      : blackGray,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets
                            .all(10),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons
                                  .reQuoteIcon,
                            ),
                            getSizedBox(w: 5),
                            Text(NumberFormat
                                .compactCurrency(
                              decimalDigits: 0,
                              symbol:
                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                            ).format(
                                quote.reQuote),
                                style: GoogleFonts
                                    .nunitoSans(
                                  fontWeight: FontWeight
                                      .w400,
                                  fontSize: ScreenUtil()
                                      .setSp(12),
                                  color: blackGray,
                                )),
                          ],
                        ),
                      ),
                      getSizedBox(w: 5),
                      SvgPicture.asset(
                        "assets/svg/line.svg",
                      ),
                      InkWell(
                        onTap: () {
                          profileController
                              .uploadPhotoVideos
                              .value = [""];
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors
                                .transparent,
                            builder: (context) =>
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors
                                        .white,
                                    borderRadius: BorderRadius
                                        .only(
                                      topLeft: Radius
                                          .circular(
                                          16),
                                      topRight: Radius
                                          .circular(
                                          16),
                                    ),
                                  ),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment
                                        .center,
                                    alignment: WrapAlignment
                                        .center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets
                                            .only(
                                            top: 24,
                                            bottom: 32),
                                        child: Wrap(
                                          crossAxisAlignment: WrapCrossAlignment
                                              .center,
                                          children: [
                                            Text(
                                              "Create Re-Quote",
                                              style: GoogleFonts
                                                  .nunitoSans(
                                                  fontSize: ScreenUtil()
                                                      .setSp(
                                                      16),
                                                  fontWeight: FontWeight
                                                      .w700,
                                                  color: black),
                                            ),
                                            getSizedBox(
                                                w: 8),
                                            SvgPicture
                                                .asset(
                                              AppIcons
                                                  .reQuoteIcon,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets
                                            .symmetric(
                                            horizontal: ScreenUtil()
                                                .setSp(
                                                42)),
                                        child: Container(
                                          height: getHeight(
                                              160),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  8),
                                              border: Border
                                                  .all(
                                                  color: Colors
                                                      .blue)),
                                          child: TextFormField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  300),
                                            ],
                                            textInputAction: TextInputAction
                                                .newline,
                                            textCapitalization: TextCapitalization
                                                .sentences,
                                            keyboardType: TextInputType
                                                .multiline,
                                            maxLines: null,
                                            onChanged: (text) {
                                              profileController
                                                  .descriptionValue
                                                  .value =
                                                  text;
                                            },
                                            style: size14_M_normal(
                                                textColor: color606060),
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 15,
                                                  vertical: 10),
                                              hintText: "Enter Text for the Quote",
                                              border: InputBorder
                                                  .none,
                                              hintStyle: size12_M_normal(
                                                  textColor: color606060),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                            () =>
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 20,
                                                  vertical: 5),
                                              child: Row(
                                                children: [
                                                  const Spacer(),
                                                  Text(
                                                    "remain ${300 -
                                                        profileController
                                                            .descriptionValue
                                                            .value
                                                            .length} characters",
                                                    style: size10_M_normal(
                                                        textColor: colorGrey),
                                                  )
                                                ],
                                              ),
                                            ),
                                      ),
                                      Container(
                                        height: 100,
                                        margin: const EdgeInsets
                                            .only(
                                            top: 20),
                                        child: Obx(
                                              () =>
                                              ListView
                                                  .builder(
                                                  scrollDirection: Axis
                                                      .horizontal,
                                                  padding: EdgeInsets
                                                      .only(
                                                      left: ScreenUtil()
                                                          .setSp(
                                                          38)),
                                                  itemCount: profileController
                                                      .uploadPhotoVideos
                                                      .length >
                                                      5
                                                      ? 5
                                                      : profileController
                                                      .uploadPhotoVideos
                                                      .length,
                                                  itemBuilder: (
                                                      followersContext,
                                                      index) {
                                                    return Padding(
                                                      padding: EdgeInsets
                                                          .only(
                                                          left: ScreenUtil()
                                                              .setSp(
                                                              4)),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if ((profileController
                                                              .uploadPhotoVideos
                                                              .length -
                                                              index) ==
                                                              1) {
                                                            uploadPic(
                                                                context);
                                                          } else {
                                                            // muddaVideoDialog(
                                                            //     context, profileController.uploadPhotoVideos);
                                                          }
                                                        },
                                                        child: (profileController
                                                            .uploadPhotoVideos
                                                            .length -
                                                            index) ==
                                                            1
                                                            ? Container(
                                                          height: 100,
                                                          width: 100,
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons
                                                                  .camera_alt,
                                                              size: 50,
                                                              color: Colors
                                                                  .grey,
                                                            ),
                                                          ),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)),
                                                        )
                                                            : Container(
                                                          decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey)),
                                                          child: profileController
                                                              .uploadPhotoVideos
                                                              .elementAt(
                                                              index)
                                                              .contains(
                                                              "Trimmer")
                                                              ? Stack(
                                                            children: [
                                                              SizedBox(
                                                                height: 100,
                                                                width: 100,
                                                                child: VideoViewer(
                                                                    trimmer: _trimmer),
                                                              )
                                                            ],
                                                          )
                                                              : Image
                                                              .file(
                                                            File(
                                                                profileController
                                                                    .uploadPhotoVideos
                                                                    .elementAt(
                                                                    index)),
                                                            height: 100,
                                                            width: 100,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                        ),
                                      ),
                                      Obx(
                                            () =>
                                            Visibility(
                                              visible: profileController
                                                  .uploadQuoteRoleList
                                                  .isNotEmpty,
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Post as: ",
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                          fontSize: ScreenUtil()
                                                              .setSp(
                                                              12),
                                                          fontWeight: FontWeight
                                                              .w400,
                                                          color: blackGray),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showRolesDialog(
                                                            context);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          profileController
                                                              .selectedRole
                                                              .value
                                                              .user !=
                                                              null
                                                              ? profileController
                                                              .selectedRole
                                                              .value
                                                              .user!
                                                              .profile !=
                                                              null
                                                              ? CachedNetworkImage(
                                                            imageUrl:
                                                            "${profileController
                                                                .roleProfilePath
                                                                .value}${profileController
                                                                .selectedRole
                                                                .value
                                                                .user!
                                                                .profile}",
                                                            imageBuilder:
                                                                (context,
                                                                imageProvider) =>
                                                                Container(
                                                                  width: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  height: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  decoration: BoxDecoration(
                                                                    color: colorWhite,
                                                                    border: Border
                                                                        .all(
                                                                      width: ScreenUtil()
                                                                          .setSp(
                                                                          1),
                                                                      color: buttonBlue,
                                                                    ),
                                                                    borderRadius: BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            ScreenUtil()
                                                                                .setSp(
                                                                                15)) //                 <--- border radius here
                                                                    ),
                                                                    image: DecorationImage(
                                                                        image: imageProvider,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                            placeholder: (
                                                                context,
                                                                url) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                            errorWidget: (
                                                                context,
                                                                url,
                                                                error) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                          )
                                                              : Container(
                                                            height: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            width: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                color: darkGray,
                                                              ),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                  profileController
                                                                      .selectedRole
                                                                      .value
                                                                      .user!
                                                                      .fullname![0]
                                                                      .toUpperCase(),
                                                                  style: GoogleFonts
                                                                      .nunitoSans(
                                                                      fontWeight: FontWeight
                                                                          .w400,
                                                                      fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                          16),
                                                                      color: black)),
                                                            ),
                                                          )
                                                              : AppPreference()
                                                              .getString(
                                                              PreferencesKey
                                                                  .profile)
                                                              .isNotEmpty
                                                              ? CachedNetworkImage(
                                                            imageUrl:
                                                            "${AppPreference()
                                                                .getString(
                                                                PreferencesKey
                                                                    .profilePath)}${AppPreference()
                                                                .getString(
                                                                PreferencesKey
                                                                    .profile)}",
                                                            imageBuilder:
                                                                (context,
                                                                imageProvider) =>
                                                                Container(
                                                                  width: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  height: ScreenUtil()
                                                                      .setSp(
                                                                      30),
                                                                  decoration: BoxDecoration(
                                                                    color: colorWhite,
                                                                    border: Border
                                                                        .all(
                                                                      width: ScreenUtil()
                                                                          .setSp(
                                                                          1),
                                                                      color: buttonBlue,
                                                                    ),
                                                                    borderRadius: BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            ScreenUtil()
                                                                                .setSp(
                                                                                15)) //                 <--- border radius here
                                                                    ),
                                                                    image: DecorationImage(
                                                                        image: imageProvider,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                            placeholder: (
                                                                context,
                                                                url) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                            errorWidget: (
                                                                context,
                                                                url,
                                                                error) =>
                                                                CircleAvatar(
                                                                  backgroundColor: lightGray,
                                                                  radius: ScreenUtil()
                                                                      .setSp(
                                                                      15),
                                                                ),
                                                          )
                                                              : Container(
                                                            height: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            width: ScreenUtil()
                                                                .setSp(
                                                                30),
                                                            decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                color: darkGray,
                                                              ),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                  AppPreference()
                                                                      .getString(
                                                                      PreferencesKey
                                                                          .fullName)[0]
                                                                      .toUpperCase(),
                                                                  style: GoogleFonts
                                                                      .nunitoSans(
                                                                      fontWeight: FontWeight
                                                                          .w400,
                                                                      fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                          16),
                                                                      color: black)),
                                                            ),
                                                          ),
                                                          getSizedBox(
                                                              w: 6),
                                                          Text(
                                                              profileController
                                                                  .selectedRole
                                                                  .value
                                                                  .user !=
                                                                  null
                                                                  ? profileController
                                                                  .selectedRole
                                                                  .value
                                                                  .user!
                                                                  .fullname!
                                                                  : "Self",
                                                              style: GoogleFonts
                                                                  .nunitoSans(
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  fontSize: ScreenUtil()
                                                                      .setSp(
                                                                      10),
                                                                  color: buttonBlue,
                                                                  fontStyle: FontStyle
                                                                      .italic)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets
                                            .only(
                                            top: 37),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            GetStartedButton(
                                              onTap: () async {
                                                AppPreference _appPreference = AppPreference();
                                                FormData formData = FormData
                                                    .fromMap(
                                                    {
                                                      "description":
                                                      profileController
                                                          .descriptionValue
                                                          .value,
                                                      "user_id": _appPreference
                                                          .getString(
                                                          PreferencesKey
                                                              .interactUserId),
                                                      "parent_id": quote
                                                          .sId!,
                                                      "post_of": "quote",
                                                    });
                                                for (int i = 0;
                                                i <
                                                    (profileController
                                                        .uploadPhotoVideos
                                                        .length ==
                                                        5
                                                        ? 5
                                                        : (profileController
                                                        .uploadPhotoVideos
                                                        .length -
                                                        1));
                                                i++) {
                                                  formData
                                                      .files
                                                      .addAll(
                                                      [
                                                        MapEntry(
                                                            "gallery",
                                                            await MultipartFile
                                                                .fromFile(
                                                                profileController
                                                                    .uploadPhotoVideos[i],
                                                                filename: profileController
                                                                    .uploadPhotoVideos[i]
                                                                    .split(
                                                                    '/')
                                                                    .last)),
                                                      ]);
                                                }
                                                Api
                                                    .uploadPost
                                                    .call(
                                                    context,
                                                    method: "quote-or-activity/store",
                                                    param: formData,
                                                    isLoading: true,
                                                    onResponseSuccess: (
                                                        Map object) {
                                                      print(
                                                          object);
                                                      var snackBar = const SnackBar(
                                                        content: Text(
                                                            'Uploaded'),
                                                      );
                                                      quote
                                                          .reQuote =
                                                          quote
                                                              .reQuote! +
                                                              1;
                                                      int pIndex = index;
                                                      profileController
                                                          .quotePostList
                                                          .removeAt(
                                                          index);
                                                      profileController
                                                          .quotePostList
                                                          .insert(
                                                          pIndex,
                                                          quote);
                                                      ScaffoldMessenger
                                                          .of(
                                                          context)
                                                          .showSnackBar(
                                                          snackBar);
                                                      // profileController.postForMuddaList.insert(0,PostForMudda.fromJson(object['data']));
                                                      Get
                                                          .back();
                                                    });
                                              },
                                              title: "Post",
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets
                              .all(10),
                          child: SvgPicture.asset(
                            "assets/svg/edit_quote.svg",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 2,
                        backgroundColor: Colors
                            .black,
                      ),
                      getSizedBox(w: 5),
                      Text(
                          convertToAgo(
                              DateTime.parse(
                                  quote
                                      .createdAt!)),
                          style:
                          GoogleFonts.nunitoSans(
                              fontWeight:
                              FontWeight.w400,
                              fontSize:
                              ScreenUtil()
                                  .setSp(12),
                              color: blackGray)),
                    ],
                  )
                ],
              ),
            ) : Padding(
              padding: const EdgeInsets.only(
                  left: 54, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (quote.amILiked !=
                          null) {
                        quote.likersCount =
                            quote
                                .likersCount! -
                                1;
                        quote.amILiked = null;
                      } else {
                        quote.likersCount =
                            quote
                                .likersCount! +
                                1;
                        AmILiked q = AmILiked();
                        q.relativeId =
                        quote.sId!;
                        q.relativeType =
                        "QuoteOrActivity";
                        q.userId =
                            AppPreference()
                                .getString(
                                PreferencesKey
                                    .interactUserId);
                        quote.amILiked = q;
                      }
                      int pIndex = index;
                      profileController
                          .quotePostList
                          .removeAt(index);
                      profileController
                          .quotePostList
                          .insert(
                          pIndex, quote);
                      Api.post.call(
                        context,
                        method: "like/store",
                        isLoading: false,
                        param: {
                          "user_id": AppPreference()
                              .getString(
                              PreferencesKey
                                  .interactUserId),
                          "relative_id": quote
                              .sId!,
                          "relative_type":
                          "QuoteOrActivity",
                          "status": true,
                        },
                        onResponseSuccess: (object) {
                          print(
                              "Abhishek $object");
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets
                          .all(10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/like.svg",
                            color: quote
                                .amILiked !=
                                null
                                ? themeColor
                                : blackGray,
                          ),
                          getSizedBox(w: 5),
                          Text(NumberFormat
                              .compactCurrency(
                            decimalDigits: 0,
                            symbol:
                            '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(quote
                              .likersCount),
                              style: GoogleFonts
                                  .nunitoSans(
                                fontWeight: quote
                                    .amILiked !=
                                    null
                                    ? FontWeight
                                    .w700
                                    : FontWeight
                                    .w400,
                                fontSize: ScreenUtil()
                                    .setSp(
                                    12),
                                color: quote
                                    .amILiked !=
                                    null
                                    ? themeColor
                                    : blackGray,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        AppIcons.messageIcon,
                        color: colorGrey,
                        height: 18,
                        width: 19,
                      ),
                      getSizedBox(w: 3),
                      Text(NumberFormat
                          .compactCurrency(
                        decimalDigits: 0,
                        symbol:
                        '', // if you want to add currency symbol then pass that in this else leave it empty.
                      ).format(quote
                          .commentorsCount),
                          style: GoogleFonts
                              .nunitoSans(
                            fontWeight: FontWeight
                                .w400,
                            fontSize: ScreenUtil()
                                .setSp(12),
                            color: blackGray,
                          )),
                      getSizedBox(w: 15),
                      SvgPicture.asset(
                        "assets/svg/line.svg",
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return CommentsForMuddaBazz(
                                  commentId: quote
                                      .sId!,);
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets
                              .all(10),
                          child: SvgPicture.asset(
                            "assets/svg/edit_quote.svg",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 2,
                        backgroundColor: Colors
                            .black,
                      ),
                      getSizedBox(w: 5),
                      Text(
                          convertToAgo(
                              DateTime.parse(
                                  quote
                                      .createdAt!)),
                          style:
                          GoogleFonts.nunitoSans(
                              fontWeight:
                              FontWeight.w400,
                              fontSize:
                              ScreenUtil()
                                  .setSp(12),
                              color: blackGray)),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setSp(12),
                  left: ScreenUtil().setSp(12)),
              child: const Divider(
                color: Colors.black87,
                height: 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector iconThreeDot(Quote quote, bool? isFrom, int index) {
    return GestureDetector(
        onTap: () {
          if (quote.user!
              .sId ==
              AppPreference().getString(
                  PreferencesKey.userId)) {
            reportQuotePostDeleteDialogBox(context, quote)
                .then((value) {
              if (value == true) {
                if (isFrom == null) {
                  profileController.quotePostList.removeAt(index);
                } else if (isFrom == true) {
                  profileController.singleQuotePostList.removeAt(index);
                } else {
                  profileController.singleActivityPostList.removeAt(index);
                }
              }
            });
          } else {
            reportQuotePostDialogBox(
                context, quote);
          }
        },
        child: const Icon(
            Icons
                .more_vert_outlined));
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

  _allQuotes(BuildContext context) async {
    profileController.isLoading.value = true;
    getProfile();
    Api.get.call(context,
        method: "quote-or-activity/index",
        param: {"page": allPage.toString()},
        isLoading: false, onResponseSuccess: (Map object) {
          profileController.isLoading.value = false;
          var result = QuotePostModel.fromJson(object);
          if (allPage == 1) {
            profileController.quotePostList.clear();
          }
          if (result.data!.isNotEmpty) {
            profileController.quotePostPath.value = result.path!;
            profileController.quoteProfilePath.value = result.userpath!;
            profileController.quotePostList.addAll(result.data!);
          } else {
            allPage = allPage > 1 ? allPage - 1 : allPage;
          }
        });
  }

  _allPaginateQuotes(BuildContext context) async {
    getProfile();
    Api.get.call(context,
        method: "quote-or-activity/index",
        param: {"page": allPage.toString()},
        isLoading: false, onResponseSuccess: (Map object) {
          var result = QuotePostModel.fromJson(object);
          if (allPage == 1) {
            profileController.quotePostList.clear();
          }
          if (result.data!.isNotEmpty) {
            profileController.quotePostPath.value = result.path!;
            profileController.quoteProfilePath.value = result.userpath!;
            profileController.quotePostList.addAll(result.data!);
          } else {
            allPage = allPage > 1 ? allPage - 1 : allPage;
          }
        });
  }

  void profileNavigation(BuildContext context, Quote quote) {
    if (quote.user!.sId ==
        AppPreference()
            .getString(
            PreferencesKey
                .userId)) {
      Get.toNamed(
          RouteConstants
              .profileScreen);
    } else {
      Map<String,
          String>? parameters = {
        "userDetail": jsonEncode(
            quote.user!)
      };
      Get.toNamed(
          RouteConstants
              .otherUserProfileScreen,
          parameters: parameters);
    }
  }

  _quotes(BuildContext context) async {
    profileController.isLoading.value = true;
    Api.get.call(context,
        method: "quote-or-activity/index",
        param: {"page": quotePage.toString(), "post_of": "quote"},
        isLoading: true, onResponseSuccess: (Map object) {
          profileController.isLoading.value = false;
          var result = QuotePostModel.fromJson(object);
          if (quotePage == 1) {
            profileController.singleQuotePostList.clear();
          }
          if (result.data!.isNotEmpty) {
            profileController.quotePostPath.value = result.path!;
            profileController.quoteProfilePath.value = result.userpath!;
            profileController.singleQuotePostList.addAll(result.data!);
          } else {
            quotePage = quotePage > 1 ? quotePage - 1 : quotePage;
          }
        });
  }

  _quotesPaginate(BuildContext context) async {
    Api.get.call(context,
        method: "quote-or-activity/index",
        param: {"page": quotePage.toString(), "post_of": "quote"},
        isLoading: true, onResponseSuccess: (Map object) {
          var result = QuotePostModel.fromJson(object);
          if (quotePage == 1) {
            profileController.singleQuotePostList.clear();
          }
          if (result.data!.isNotEmpty) {
            profileController.quotePostPath.value = result.path!;
            profileController.quoteProfilePath.value = result.userpath!;
            profileController.singleQuotePostList.addAll(result.data!);
          } else {
            quotePage = quotePage > 1 ? quotePage - 1 : quotePage;
          }
        });
  }

  _activity(BuildContext context) async {
    profileController.isLoading.value = true;
    Api.get.call(context,
        method: "quote-or-activity/index",
        param: {"page": activityPage.toString(), "post_of": "activity"},
        isLoading: true, onResponseSuccess: (Map object) {
          var result = QuotePostModel.fromJson(object);
          profileController.isLoading.value = false;
          if (activityPage == 1) {
            profileController.singleActivityPostList.clear();
          }
          if (result.data!.isNotEmpty) {
            profileController.quotePostPath.value = result.path!;
            profileController.quoteProfilePath.value = result.userpath!;
            profileController.singleActivityPostList.addAll(result.data!);
          } else {
            activityPage = activityPage > 1 ? activityPage - 1 : activityPage;
          }
        });
  }

  _activityPaginate(BuildContext context) async {
    Api.get.call(context,
        method: "quote-or-activity/index",
        param: {"page": activityPage.toString(), "post_of": "activity"},
        isLoading: true, onResponseSuccess: (Map object) {
          var result = QuotePostModel.fromJson(object);
          if (activityPage == 1) {
            profileController.singleActivityPostList.clear();
          }
          if (result.data!.isNotEmpty) {
            profileController.quotePostPath.value = result.path!;
            profileController.quoteProfilePath.value = result.userpath!;
            profileController.singleActivityPostList.addAll(result.data!);
          } else {
            activityPage = activityPage > 1 ? activityPage - 1 : activityPage;
          }
        });
  }

  void _suggestions(BuildContext context) async {
    Map<String, dynamic> param = {
      "page": suggestionsPage.toString(),
      "search": "",
      "user_id": AppPreference().getString(PreferencesKey.userId),
    };
    Api.get.call(context,
        method: "user/user-suggestion",
        param: param,
        isLoading: false, onResponseSuccess: (Map object) {
          var result = UserSuggestionsModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            followerController!.userPath.value = result.path!;
            if (suggestionsPage == 1) {
              followerController!.mySuggestionsResult.clear();
            }
            followerController!.mySuggestionsResult.addAll(result.data!);
          } else {
            if (suggestionsPage == 1) {
              followerController!.mySuggestionsResult.clear();
            }
            suggestionsPage =
            suggestionsPage > 1 ? suggestionsPage-- : suggestionsPage;
          }
        });
  }

  void _suggestionsCity(BuildContext context) async {
    Map<String, dynamic> param = {
      "page": suggestionsCityPage.toString(),
      "search": "",
      "filter_type": "city",
      "filter_type_value": AppPreference().getString(PreferencesKey.city),
      "user_id": AppPreference().getString(PreferencesKey.userId),
    };
    Api.get.call(context,
        method: "user/user-suggestion",
        param: param,
        isLoading: false, onResponseSuccess: (Map object) {
          var result = UserSuggestionsModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            followerController!.userPath.value = result.path!;
            if (suggestionsCityPage == 1) {
              followerController!.mySuggestionsCityResult.clear();
            }
            followerController!.mySuggestionsCityResult.addAll(result.data!);
          } else {
            if (suggestionsCityPage == 1) {
              followerController!.mySuggestionsCityResult.clear();
            }
            suggestionsCityPage = suggestionsCityPage > 1
                ? suggestionsCityPage--
                : suggestionsCityPage;
          }
        });
  }

  void _suggestionsState(BuildContext context) async {
    Map<String, dynamic> param = {
      "page": suggestionsStatePage.toString(),
      "search": "",
      "filter_type": "state",
      "filter_type_value": AppPreference().getString(PreferencesKey.state),
      "user_id": AppPreference().getString(PreferencesKey.userId),
    };
    Api.get.call(context,
        method: "user/user-suggestion",
        param: param,
        isLoading: false, onResponseSuccess: (Map object) {
          var result = UserSuggestionsModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            followerController!.userPath.value = result.path!;
            if (suggestionsStatePage == 1) {
              followerController!.mySuggestionsStateResult.clear();
            }
            followerController!.mySuggestionsStateResult.addAll(result.data!);
          } else {
            if (suggestionsStatePage == 1) {
              followerController!.mySuggestionsStateResult.clear();
            }
            suggestionsStatePage = suggestionsStatePage > 1
                ? suggestionsStatePage--
                : suggestionsStatePage;
          }
        });
  }

  void _suggestionsCountry(BuildContext context) async {
    Map<String, dynamic> param = {
      "page": suggestionsCountryPage.toString(),
      "search": "",
      "filter_type": "country",
      "filter_type_value": AppPreference().getString(PreferencesKey.country),
      "user_id": AppPreference().getString(PreferencesKey.userId),
    };
    Api.get.call(context,
        method: "user/user-suggestion",
        param: param,
        isLoading: false, onResponseSuccess: (Map object) {
          var result = UserSuggestionsModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            followerController!.userPath.value = result.path!;
            if (suggestionsCountryPage == 1) {
              followerController!.mySuggestionsCountryResult.clear();
            }
            followerController!.mySuggestionsCountryResult.addAll(result.data!);
          } else {
            if (suggestionsCountryPage == 1) {
              followerController!.mySuggestionsCountryResult.clear();
            }
            suggestionsCountryPage = suggestionsCountryPage > 1
                ? suggestionsCountryPage--
                : suggestionsCountryPage;
          }
        });
  }

  _getRoles(BuildContext context) async {
    Api.get.call(context,
        method: "user/my-roles",
        param: {
          "page": rolePage.toString(),
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "interactModal": "QuoteOrActivity"
        },
        isLoading: false, onResponseSuccess: (Map object) {
          var result = UserRolesModel.fromJson(object);
          if (rolePage == 1) {
            profileController.uploadQuoteRoleList.clear();
          }
          if (result.data!.isNotEmpty) {
            profileController.roleProfilePath.value = result.path!;
            profileController.uploadQuoteRoleList.addAll(result.data!);
            Role role = Role();
            role.user = User();
            role.user!.profile =
                AppPreference().getString(PreferencesKey.profile);
            role.user!.fullname = "Self";
            role.user!.sId = AppPreference().getString(PreferencesKey.userId);
            profileController.uploadQuoteRoleList.add(role);
          } else {
            rolePage = rolePage > 1 ? rolePage - 1 : rolePage;
          }
        });
  }

  showRolesDialog(BuildContext context) {
    return showDialog(
      context: Get.context as BuildContext,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(16))),
            padding: EdgeInsets.only(
                top: ScreenUtil().setSp(24),
                left: ScreenUtil().setSp(24),
                right: ScreenUtil().setSp(24),
                bottom: ScreenUtil().setSp(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Interact as",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(13),
                        color: black,
                        decoration: TextDecoration.underline,
                        decorationColor: black)),
                ListView.builder(
                    shrinkWrap: true,
                    controller: roleController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                    itemCount: profileController.uploadQuoteRoleList.length,
                    itemBuilder: (followersContext, index) {
                      Role role =
                      profileController.uploadQuoteRoleList[index];
                      return InkWell(
                        onTap: () {
                          profileController.selectedRole.value = role;
                          AppPreference().setString(
                              PreferencesKey.interactUserId, role.user!.sId!);
                          AppPreference().setString(
                              PreferencesKey.interactProfile,
                              role.user!.profile!);
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(role.user!.fullname!,
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenUtil().setSp(13),
                                          color: black))),
                              SizedBox(
                                width: ScreenUtil().setSp(14),
                              ),
                              role.user!.profile != null
                                  ? SizedBox(
                                width: ScreenUtil().setSp(30),
                                height: ScreenUtil().setSp(30),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "${profileController.roleProfilePath}${role
                                      .user!.profile}",
                                  imageBuilder:
                                      (context, imageProvider) =>
                                      Container(
                                        width: ScreenUtil().setSp(30),
                                        height: ScreenUtil().setSp(30),
                                        decoration: BoxDecoration(
                                          color: colorWhite,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                blurRadius: 5.0,
                                                offset: const Offset(0, 5))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setSp(
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
                                height: ScreenUtil().setSp(30),
                                width: ScreenUtil().setSp(30),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: darkGray,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ScreenUtil().setSp(
                                          4)) //                 <--- border radius here
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                      role.user!.fullname![0]
                                          .toUpperCase(),
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                          ScreenUtil().setSp(20),
                                          color: black)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  Future uploadPic(BuildContext context) async {
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
                          profileController.uploadPhotoVideos.insert(
                              profileController.uploadPhotoVideos.length - 1,
                              value.path);
                        });
                      }
                      ;
                    } on PlatformException catch (e) {
                      print('FAILED $e');
                    }
                    Navigator.of(context).pop();
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
                        profileController.uploadPhotoVideos.insert(
                            profileController.uploadPhotoVideos.length - 1,
                            value.path);
                      });
                    }
                  } on PlatformException catch (e) {
                    print('FAILED $e');
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Video Library'),
                  onTap: () async {
                    try {
                      Navigator.of(context).pop();
                      var result = await ImagePicker()
                          .pickVideo(source: ImageSource.gallery);
                      if (result != null) {
                        File file = File(result.path);
                        // print("ORG:::${_getVideoSize(file: file)}");
                        print(file.path);
                        var filePath = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrimmerView(file)));
                        if (filePath != null) {
                          File videoFile = File(filePath);
                          _trimmer.loadVideo(videoFile: videoFile);
                          profileController.uploadPhotoVideos.insert(
                              profileController.uploadPhotoVideos.length - 1,
                              filePath);
                          /*final MediaInfo? info =
                          await VideoCompress.compressVideo(
                            videoFile.path,
                            quality: VideoQuality.MediumQuality,
                            deleteOrigin: false,
                            includeAudio: true,
                          );
                          print(info!.path);
                          _trimmer.loadVideo(videoFile: File(info.path!));
                          profileController.uploadPhotoVideos.add(info.path!);*/
                        }
                      }
                    } on PlatformException catch (e) {
                      print('FAILED $e');
                    }
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Video Camera'),
                onTap: () async {
                  try {
                    final video = await ImagePicker()
                        .pickVideo(source: ImageSource.camera);
                    if (video == null) return;
                    if (video != null) {
                      File file = File(video.path);
                      // print("ORG:::${_getVideoSize(file: file)}");
                      print(file.path);
                      var filePath = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrimmerView(file)));
                      if (filePath != null) {
                        var videoFile = File(filePath);
                        // print("TRIMM:::${_getVideoSize(file: videoFile)}");
                        // String  _desFile = await _destinationFile;
                        // print("DEST:::${_desFile}");
                        final MediaInfo? info =
                        await VideoCompress.compressVideo(
                          videoFile.path,
                          quality: VideoQuality.MediumQuality,
                          deleteOrigin: false,
                          includeAudio: true,
                        );
                        print(info!.path);
                        _trimmer.loadVideo(videoFile: videoFile);
                        profileController.uploadPhotoVideos.insert(
                            profileController.uploadPhotoVideos.length - 1,
                            info.path!);
                      }
                    }
                  } on PlatformException catch (e) {
                    print('FAILED $e');
                  }
                  Navigator.of(context).pop();
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

  postAnynymousDialogBox(String text) {
    return showDialog(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Text(text),
          ],
        );
      },
    );
  }
}
