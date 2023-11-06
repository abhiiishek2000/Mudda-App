import 'dart:convert';

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
import 'package:mudda/model/FollowerUser.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserSuggestionsModel.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/profile_screen/controller/follower_controller.dart';

class FollowerUserScreen extends GetView<FollowerController> {
  FollowerUserScreen({Key? key}) : super(key: key);
  FollowerController? followerController;
  int followersPage = 1;
  int followingPage = 1;
  int suggestionsPage = 1;
  int suggestionsCityPage = 1;
  int suggestionsStatePage = 1;
  int suggestionsCountryPage = 1;
  String sort = "";
  String searchFollowers = "";
  ScrollController followersScrollController = ScrollController();

  ScrollController suggestionsScrollController = ScrollController();
  ScrollController suggestionsCityScrollController = ScrollController();
  ScrollController suggestionsStateScrollController = ScrollController();
  ScrollController suggestionsCountryScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    followerController = Get.put(FollowerController(),
        tag: (DateTime.now().millisecondsSinceEpoch).toString());
    followerController!.followersCount.value =
        followerController!.userDetail!.countFollowers!;
    followerController!.followingCount.value =
        followerController!.userDetail!.countFollowing!;

    followerController!.followingScrollController.addListener(() {
      if (followerController!.followingScrollController.position.maxScrollExtent ==
          followerController!.followingScrollController.position.pixels) {
            followingPage++;
            _following(context);
      }
    });

    followerController!.controller!.addListener(() {
      searchFollowers = "";
      sort = "";
      if (followerController!.controller!.index == 0 &&
          followerController!.myFollowersResult.isEmpty) {
        _followers(context);
      }

      if (followerController!.controller!.index == 1 &&
          followerController!.myFollowingResult.isEmpty) {
        _following(context);
      }

      if (followerController!.controller!.index == 2 &&
          followerController!.mySuggestionsResult.isEmpty) {
        _suggestions(context);
      }
    });
    if (followerController!.userDetail!.followerIndex == 1) {
      // followerController!.controller!.index = 1;
      followerController!.myFollowingResult.clear();
      _following(context);
    } else {
      followerController!.controller!.index = 0;
      _followers(context);
    }
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
    followersScrollController.addListener(() {
      if (followersScrollController.position.maxScrollExtent ==
          followersScrollController.position.pixels) {
        followersPage++;
        _followers(context);
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: colorAppBackground,
        iconTheme: const IconThemeData(color: colorBlack),
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
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                searchBoxTextFiled();
              },
              icon: Image.asset(AppIcons.searchIcon, height: 20, width: 20)),
          /* IconButton(
              onPressed: () {},
              icon: Image.asset(AppIcons.filterIcon, height: 20, width: 20)),*/
          PopupMenuButton(
              icon: Image.asset(AppIcons.filterIcon2, height: 20, width: 20),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      onTap: () {
                        sort = "Oldest";
                        if (followerController!.controller!.index == 0) {
                          followersPage = 1;
                          followerController!.myFollowersResult.clear();
                          _followers(context);
                        } else if (followerController!.controller!.index == 1) {
                          followingPage = 1;
                          followerController!.myFollowingResult.clear();
                          _following(context);
                        } else if (followerController!.controller!.index == 2) {
                          if (followerController!.suggestionTabController!.index == 0) {
                            suggestionsPage = 1;
                            followerController!.mySuggestionsResult.clear();
                            _suggestions(context);
                          }else if (followerController!.suggestionTabController!.index == 1) {
                            if(AppPreference()
                                .getString(PreferencesKey.city)
                                .isNotEmpty){
                              suggestionsCityPage = 1;
                              followerController!.mySuggestionsCityResult
                                  .clear();
                              _suggestionsCity(context);
                            }else {
                              suggestionsPage = 1;
                              followerController!.mySuggestionsResult
                                  .clear();
                              _suggestions(context);
                            }
                          }else if (followerController!.suggestionTabController!.index == 2) {
                            suggestionsStatePage = 1;
                            followerController!.mySuggestionsStateResult
                                .clear();
                            _suggestionsState(context);
                          }else if (followerController!.suggestionTabController!.index == 3){
                            suggestionsCountryPage = 1;
                            followerController!.mySuggestionsCountryResult
                                .clear();
                            _suggestionsCountry(context);
                          }else {
                            suggestionsPage = 1;
                            followerController!.mySuggestionsResult.clear();
                            _suggestions(context);
                          }
                        }
                      },
                      child: const Text('Oldest'),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        sort = "Newest";
                        if (followerController!.controller!.index == 0) {
                          followersPage = 1;
                          followerController!.myFollowersResult.clear();
                          _followers(context);
                        } else if (followerController!.controller!.index == 1) {
                          followingPage = 1;
                          followerController!.myFollowingResult.clear();
                          _following(context);
                        } else if (followerController!.controller!.index == 2) {
                          if (followerController!.suggestionTabController!.index == 0) {
                            suggestionsPage = 1;
                            followerController!.mySuggestionsResult.clear();
                            _suggestions(context);
                          }else if (followerController!.suggestionTabController!.index == 1) {
                            if(AppPreference()
                                .getString(PreferencesKey.city)
                                .isNotEmpty){
                              suggestionsCityPage = 1;
                              followerController!.mySuggestionsCityResult
                                  .clear();
                              _suggestionsCity(context);
                            }else {
                              suggestionsPage = 1;
                              followerController!.mySuggestionsResult
                                  .clear();
                              _suggestions(context);
                            }
                          }else if (followerController!.suggestionTabController!.index == 2) {
                            suggestionsStatePage = 1;
                            followerController!.mySuggestionsStateResult
                                .clear();
                            _suggestionsState(context);
                          }else if (followerController!.suggestionTabController!.index == 3){
                            suggestionsCountryPage = 1;
                            followerController!.mySuggestionsCountryResult
                                .clear();
                            _suggestionsCountry(context);
                          }else {
                            suggestionsPage = 1;
                            followerController!.mySuggestionsResult.clear();
                            _suggestions(context);
                          }
                        }
                      },
                      child: const Text('Newest'),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        sort = "A-Z";
                        if (followerController!.controller!.index == 0) {
                          followersPage = 1;
                          followerController!.myFollowersResult.clear();
                          _followers(context);
                        } else if (followerController!.controller!.index == 1) {
                          followingPage = 1;
                          followerController!.myFollowingResult.clear();
                          _following(context);
                        } else if (followerController!.controller!.index == 2) {
                          if (followerController!.suggestionTabController!.index == 0) {
                            suggestionsPage = 1;
                            followerController!.mySuggestionsResult.clear();
                            _suggestions(context);
                          }else if (followerController!.suggestionTabController!.index == 1) {
                            if(AppPreference()
                                .getString(PreferencesKey.city)
                                .isNotEmpty){
                              suggestionsCityPage = 1;
                              followerController!.mySuggestionsCityResult
                                  .clear();
                              _suggestionsCity(context);
                            }else {
                              suggestionsPage = 1;
                              followerController!.mySuggestionsResult
                                  .clear();
                              _suggestions(context);
                            }
                          }else if (followerController!.suggestionTabController!.index == 2) {
                            suggestionsStatePage = 1;
                            followerController!.mySuggestionsStateResult
                                .clear();
                            _suggestionsState(context);
                          }else if (followerController!.suggestionTabController!.index == 3){
                            suggestionsCountryPage = 1;
                            followerController!.mySuggestionsCountryResult
                                .clear();
                            _suggestionsCountry(context);
                          }else {
                            suggestionsPage = 1;
                            followerController!.mySuggestionsResult.clear();
                            _suggestions(context);
                          }
                        }
                      },
                      child: const Text('A-Z'),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        sort = "Z-A";
                        if (followerController!.controller!.index == 0) {
                          followersPage = 1;
                          followerController!.myFollowersResult.clear();
                          _followers(context);
                        } else if (followerController!.controller!.index == 1) {
                          followingPage = 1;
                          followerController!.myFollowingResult.clear();
                          _following(context);
                        } else if (followerController!.controller!.index == 2) {
                          if (followerController!.suggestionTabController!.index == 0) {
                            suggestionsPage = 1;
                            followerController!.mySuggestionsResult.clear();
                            _suggestions(context);
                          }else if (followerController!.suggestionTabController!.index == 1) {
                            if(AppPreference()
                                .getString(PreferencesKey.city)
                                .isNotEmpty){
                              suggestionsCityPage = 1;
                              followerController!.mySuggestionsCityResult
                                  .clear();
                              _suggestionsCity(context);
                            }else {
                              suggestionsPage = 1;
                              followerController!.mySuggestionsResult
                                  .clear();
                              _suggestions(context);
                            }
                          }else if (followerController!.suggestionTabController!.index == 2) {
                            suggestionsStatePage = 1;
                            followerController!.mySuggestionsStateResult
                                .clear();
                            _suggestionsState(context);
                          }else if (followerController!.suggestionTabController!.index == 3){
                            suggestionsCountryPage = 1;
                            followerController!.mySuggestionsCountryResult
                                .clear();
                            _suggestionsCountry(context);
                          }else {
                            suggestionsPage = 1;
                            followerController!.mySuggestionsResult.clear();
                            _suggestions(context);
                          }
                        }
                      },
                      child: const Text('Z-A'),
                    ),
                  ]),
        ],
      ),
      body: Container(
        color: colorAppBackground,
        child: Column(
          children: <Widget>[
            Obx(
              () => TabBar(
                tabs: [
                  Tab(
                    text: "Followers(${NumberFormat.compactCurrency(
                      decimalDigits: 0,
                      symbol:
                          '', // if you want to add currency symbol then pass that in this else leave it empty.
                    ).format(followerController!.followersCount.toDouble())})",
                  ),
                  Tab(
                      text: "Following(${NumberFormat.compactCurrency(
                    decimalDigits: 0,
                    symbol:
                        '', // if you want to add currency symbol then pass that in this else leave it empty.
                  ).format(followerController!.followingCount.toDouble())})"),
                  const Tab(text: "Suggestions"),
                ],
                labelColor: colorBlack,
                unselectedLabelColor: colorGrey,
                indicatorColor: colorBlack,
                unselectedLabelStyle: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(14)),
                labelStyle: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w700,
                    fontSize: ScreenUtil().setSp(14)),
                physics: const AlwaysScrollableScrollPhysics(),
                controller: followerController!.controller,
              ),
            ),
            Expanded(
              child: Obx(
                ()=> TabBarView(
                  controller: followerController!.controller,
                  children: [
                    RefreshIndicator(
                      onRefresh: () {
                        searchFollowers = "";
                        sort = "";
                        followersPage = 1;
                        followerController!.myFollowersResult.clear();
                        return _followers(context);
                      },
                      child: Container(
                        child: followerController!.myFollowersResult.isNotEmpty
                            ? ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: followersScrollController,
                                itemCount: followerController!
                                    .myFollowersResult.length,
                                itemBuilder: (followersContext, index) {
                                  Data userModel = followerController!
                                      .myFollowersResult
                                      .elementAt(index);
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: ScreenUtil().setSp(20),
                                        right: ScreenUtil().setSp(20),
                                        top: ScreenUtil().setSp(15)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (userModel.user!.sId ==
                                                AppPreference().getString(
                                                    PreferencesKey.userId)) {
                                              Get.toNamed(
                                                  RouteConstants
                                                      .profileScreen,
                                                  arguments: userModel.user!);
                                            } else {
                                              Map<String, String>?
                                              parameters = {
                                                "userDetail": jsonEncode(
                                                    userModel.user!)
                                              };
                                              Get.toNamed(
                                                  RouteConstants
                                                      .otherUserProfileScreen,
                                                  parameters: parameters);
                                            }
                                          },
                                          child: userModel.user!.profile !=
                                              null
                                              ? CircleAvatar(
                                            backgroundColor: grey,
                                            radius:
                                            ScreenUtil().radius(17),
                                            backgroundImage: NetworkImage(
                                                "${followerController!.userPath.value}${userModel.user!.profile}"),
                                          )
                                              : CircleAvatar(
                                            backgroundColor: lightGray,
                                            radius:
                                            ScreenUtil().radius(17),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setSp(7),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if (userModel.user!.sId ==
                                                  AppPreference().getString(
                                                      PreferencesKey
                                                          .userId)) {
                                                Get.toNamed(
                                                    RouteConstants
                                                        .profileScreen,
                                                    arguments:
                                                    userModel.user!);
                                              } else {
                                                Map<String, String>?
                                                parameters = {
                                                  "userDetail": jsonEncode(
                                                      userModel.user!)
                                                };
                                                Get.toNamed(
                                                    RouteConstants
                                                        .otherUserProfileScreen,
                                                    parameters: parameters);
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
                                                        '${userModel.user!.fullname}',
                                                        style: GoogleFonts
                                                            .nunitoSans(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400,
                                                            fontSize:
                                                            ScreenUtil()
                                                                .setSp(
                                                                14),
                                                            color:
                                                            black)),
                                                    SizedBox(
                                                      width: ScreenUtil()
                                                          .setSp(5),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          userModel.user!
                                                              .username !=
                                                              null
                                                              ? '${userModel.user!.username}'
                                                              : "",
                                                          maxLines: 2,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                              fontSize:
                                                              ScreenUtil()
                                                                  .setSp(
                                                                  14),
                                                              color:
                                                              darkGray)),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          userModel.user!
                                                              .city !=
                                                              null
                                                              ? '${userModel.user!.city}, ${userModel.user!.country}'
                                                              : "",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w300,
                                                              fontSize:
                                                              ScreenUtil()
                                                                  .setSp(
                                                                  12),
                                                              color:
                                                              lightGray)),
                                                    ),
                                                    Visibility(
                                                      visible: userModel
                                                          .iAmFollowing ==
                                                          0 &&
                                                          userModel.user!
                                                              .sId !=
                                                              AppPreference()
                                                                  .getString(
                                                                  PreferencesKey
                                                                      .userId) &&
                                                          AppPreference().getBool(
                                                              PreferencesKey
                                                                  .isGuest) ==
                                                              false,
                                                      child: InkWell(
                                                        onTap: () async {
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
                                                              userModel
                                                                  .user!
                                                                  .sId,
                                                              "request_type":
                                                              "follow",
                                                            },
                                                            onResponseSuccess:
                                                                (object) {
                                                              if (followerController!
                                                                  .userDetail!
                                                                  .sId ==
                                                                  AppPreference()
                                                                      .getString(
                                                                      PreferencesKey.userId)) {
                                                                followerController!
                                                                    .myFollowingResult
                                                                    .add(followerController!
                                                                    .myFollowersResult[
                                                                index]);
                                                                followerController!
                                                                    .userDetail!
                                                                    .countFollowing = followerController!
                                                                    .userDetail!
                                                                    .countFollowing! +
                                                                    1;
                                                                followerController!
                                                                    .followingCount
                                                                    .value =
                                                                followerController!
                                                                    .userDetail!
                                                                    .countFollowing!;
                                                              }
                                                              int tempIndex =
                                                                  index;
                                                              Data data =
                                                              followerController!
                                                                  .myFollowersResult[
                                                              index];
                                                              data.iAmFollowing =
                                                              1;
                                                              followerController!
                                                                  .myFollowersResult
                                                                  .removeAt(
                                                                  index);
                                                              followerController!
                                                                  .myFollowersResult
                                                                  .insert(
                                                                  tempIndex,
                                                                  data);
                                                            },
                                                          );
                                                        },
                                                        child: Text(
                                                          'Follow Back',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                              fontSize:
                                                              ScreenUtil()
                                                                  .setSp(
                                                                  12),
                                                              color: black),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setSp(10),
                                        ),
                                        Visibility(
                                          visible: (userModel.iAmFollowing ==
                                              1 ||
                                              followerController!
                                                  .userDetail!.sId ==
                                                  AppPreference()
                                                      .getString(
                                                      PreferencesKey
                                                          .userId)) &&
                                              userModel.user!.sId !=
                                                  AppPreference().getString(
                                                      PreferencesKey.userId),
                                          child: SizedBox(
                                            height:
                                            ScreenUtil().setHeight(30),
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                        appBackgroundColor),
                                                    shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                  5),
                                                              topRight: Radius
                                                                  .circular(
                                                                  5),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                  5),
                                                              bottomRight:
                                                              Radius
                                                                  .circular(
                                                                  5),
                                                            ),
                                                            side: BorderSide(
                                                                color:
                                                                lightGray)))),
                                                onPressed: () async {
                                                  Api.post.call(
                                                    context,
                                                    method:
                                                    "request-to-user/store",
                                                    param: {
                                                      "user_id":
                                                      userModel.user!.sId,
                                                      "request_to_user_id":
                                                      AppPreference()
                                                          .getString(
                                                          PreferencesKey
                                                              .userId),
                                                      "request_type":
                                                      "follow",
                                                    },
                                                    onResponseSuccess:
                                                        (object) {
                                                      print(object);
                                                      int tempIndex = index;
                                                      followerController!
                                                          .userDetail!
                                                          .countFollowers =
                                                          followerController!
                                                              .userDetail!
                                                              .countFollowers! -
                                                              1;
                                                      followerController!
                                                          .followersCount
                                                          .value =
                                                      followerController!
                                                          .userDetail!
                                                          .countFollowers!;
                                                      Data data =
                                                      followerController!
                                                          .myFollowersResult[
                                                      index];
                                                      data.iAmFollowing = 0;
                                                      followerController!
                                                          .myFollowersResult
                                                          .removeAt(index);
                                                      followerController!
                                                          .myFollowersResult
                                                          .insert(tempIndex,
                                                          data);
                                                      if (followerController!
                                                          .userDetail!
                                                          .sId ==
                                                          AppPreference()
                                                              .getString(
                                                              PreferencesKey
                                                                  .userId)) {
                                                        followerController!
                                                            .myFollowersResult
                                                            .removeAt(index);
                                                      }
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  'Remove',
                                                  style:
                                                  GoogleFonts.nunitoSans(
                                                      color: lightGray,
                                                      fontSize:
                                                      ScreenUtil()
                                                          .setSp(12),
                                                      fontWeight:
                                                      FontWeight
                                                          .w400),
                                                )),
                                          ),
                                        ),
                                        /*Visibility(
                                                visible: userModel.iAmFollowing == 0 &&
                                                    userModel.user!.sId != AppPreference().getString(PreferencesKey.userId),
                                                child: SizedBox(
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                          MaterialStateProperty.all<
                                                              Color>(
                                                              appBackgroundColor),
                                                          shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.only(
                                                                    topLeft:
                                                                    Radius.circular(
                                                                        5),
                                                                    topRight:
                                                                    Radius.circular(
                                                                        5),
                                                                    bottomLeft:
                                                                    Radius.circular(
                                                                        5),
                                                                    bottomRight:
                                                                    Radius.circular(
                                                                        5),
                                                                  ),
                                                                  side: BorderSide(
                                                                      color:
                                                                      buttonBlue)))),
                                                      onPressed: () async {
                                                        Api.post.call(
                                                          context,
                                                          method: "request-to-user/store",
                                                          param: {
                                                            "user_id":AppPreference().getString(PreferencesKey.userId),
                                                            "request_to_user_id":userModel.user!.sId,
                                                            "request_type":"follow",
                                                          },
                                                          onResponseSuccess: (object) {
                                                            print(object);
                                                            myFollowersResult[index].iAmFollowing = 1;
                                                            setState(() {});
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        'Follow',
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize:
                                                            ScreenUtil().setSp(12),
                                                            color: buttonBlue),
                                                      )),
                                                  height: ScreenUtil().setHeight(30),
                                                ),
                                              ),*/
                                      ],
                                    ),
                                  );
                                })
                            : Center(
                          child: Text("No Followers Found",
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () {
                        searchFollowers = "";
                        sort = "";
                        followingPage = 1;
                        followerController!.myFollowingResult.clear();
                        return _following(context);
                      },
                      child: Container(
                        child: followerController!.myFollowingResult.isNotEmpty
                            ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: followerController!.followingScrollController,
                            itemCount:
                            followerController!.myFollowingResult.length,
                            itemBuilder: (followersContext, index) {
                              Data userModel = followerController!
                                  .myFollowingResult
                                  .elementAt(index);
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setSp(20),
                                    right: ScreenUtil().setSp(20),
                                    top: ScreenUtil().setSp(15)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (userModel.user!.sId ==
                                            AppPreference().getString(
                                                PreferencesKey.userId)) {
                                          Get.toNamed(
                                              RouteConstants.profileScreen,
                                              arguments: userModel.user!);
                                        } else {
                                          Map<String, String>? parameters = {
                                            "userDetail":
                                            jsonEncode(userModel.user!)
                                          };
                                          Get.toNamed(
                                              RouteConstants
                                                  .otherUserProfileScreen,
                                              parameters: parameters);
                                        }
                                      },
                                      child: userModel.user!.profile != null
                                          ? CircleAvatar(
                                        backgroundColor: lightGray,
                                        radius: ScreenUtil().radius(17),
                                        backgroundImage: NetworkImage(
                                            "${followerController!.userPath.value}${userModel.user!.profile}"),
                                      )
                                          : CircleAvatar(
                                        backgroundColor: lightGray,
                                        radius: ScreenUtil().radius(17),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setSp(7),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          if (userModel.user!.sId ==
                                              AppPreference().getString(
                                                  PreferencesKey.userId)) {
                                            Get.toNamed(
                                                RouteConstants.profileScreen,
                                                arguments: userModel.user!);
                                          } else {
                                            Map<String, String>? parameters =
                                            {
                                              "userDetail":
                                              jsonEncode(userModel.user!)
                                            };
                                            Get.toNamed(
                                                RouteConstants
                                                    .otherUserProfileScreen,
                                                parameters: parameters);
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${userModel.user!.fullname}',
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
                                                SizedBox(
                                                  width:
                                                  ScreenUtil().setSp(3),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      userModel.user!.username !=
                                                          null
                                                          ? '${userModel.user!.username} '
                                                          : "",
                                                      maxLines: 2,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                          fontStyle:
                                                          FontStyle
                                                              .italic,
                                                          fontSize:
                                                          ScreenUtil()
                                                              .setSp(
                                                              12),
                                                          color:
                                                          darkGray)),
                                                ),
                                              ],
                                            ),
                                            Text(
                                                userModel.user!.city != null
                                                    ? ' ${userModel.user!.city}, ${userModel.user!.country}'
                                                    : "",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight:
                                                    FontWeight.w300,
                                                    fontSize: ScreenUtil()
                                                        .setSp(12),
                                                    color: lightGray)),
                                          ],
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setSp(10),
                                    ),
                                    Visibility(
                                      visible: userModel.followMe == 1 &&
                                          userModel.user!.sId !=
                                              AppPreference().getString(
                                                  PreferencesKey.userId),
                                      child: SizedBox(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                                    appBackgroundColor),
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              5),
                                                          topRight:
                                                          Radius.circular(
                                                              5),
                                                          bottomLeft:
                                                          Radius.circular(
                                                              5),
                                                          bottomRight:
                                                          Radius.circular(
                                                              5),
                                                        ),
                                                        side: BorderSide(
                                                            color:
                                                            lightGray)))),
                                            onPressed: () async {
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
                                                  userModel.user!.sId,
                                                  "request_type": "follow",
                                                },
                                                onResponseSuccess: (object) {
                                                  print(object);
                                                  int tempIndex = index;
                                                  Data data = followerController!
                                                      .myFollowingResult[
                                                  index];
                                                  data.followMe = 0;
                                                  followerController!
                                                      .myFollowingResult
                                                      .removeAt(index);
                                                  followerController!
                                                      .myFollowingResult
                                                      .insert(
                                                      tempIndex, data);
                                                  if (followerController!
                                                      .userDetail!.sId ==
                                                      AppPreference()
                                                          .getString(
                                                          PreferencesKey
                                                              .userId)) {
                                                    followerController!
                                                        .myFollowingResult
                                                        .removeAt(index);
                                                    followerController!
                                                        .userDetail!
                                                        .countFollowing =
                                                        followerController!
                                                            .userDetail!
                                                            .countFollowing! -
                                                            1;
                                                    followerController!
                                                        .followingCount
                                                        .value =
                                                    followerController!
                                                        .userDetail!
                                                        .countFollowing!;
                                                  }
                                                },
                                              );
                                            },
                                            child: Text(
                                              'UnFollow',
                                              style: GoogleFonts.nunitoSans(
                                                  fontSize:
                                                  ScreenUtil().setSp(12),
                                                  fontWeight: FontWeight.w400,
                                                  color: lightGray),
                                            )),
                                        height: ScreenUtil().setHeight(30),
                                      ),
                                    ),
                                    Visibility(
                                      visible: userModel.followMe == 0 &&
                                          userModel.user!.sId !=
                                              AppPreference().getString(
                                                  PreferencesKey.userId) &&
                                          AppPreference().getBool(
                                              PreferencesKey.isGuest) ==
                                              false,
                                      child: SizedBox(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                                    appBackgroundColor),
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              5),
                                                          topRight:
                                                          Radius.circular(
                                                              5),
                                                          bottomLeft:
                                                          Radius.circular(
                                                              5),
                                                          bottomRight:
                                                          Radius.circular(
                                                              5),
                                                        ),
                                                        side: BorderSide(
                                                            color:
                                                            buttonBlue)))),
                                            onPressed: () async {
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
                                                  userModel.user!.sId,
                                                  "request_type": "follow",
                                                },
                                                onResponseSuccess: (object) {
                                                  print(object);
                                                  int tempIndex = index;
                                                  Data data = followerController!
                                                      .myFollowingResult[
                                                  index];
                                                  data.followMe = 1;
                                                  followerController!
                                                      .myFollowingResult
                                                      .removeAt(index);
                                                  followerController!
                                                      .myFollowingResult
                                                      .insert(
                                                      tempIndex, data);
                                                },
                                              );
                                            },
                                            child: Text(
                                              'Follow',
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                  ScreenUtil().setSp(12),
                                                  color: buttonBlue),
                                            )),
                                        height: ScreenUtil().setHeight(30),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                            : Center(
                          child: Text("No Following Found",
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        TabBar(
                          tabs: [
                            const Tab(
                              text: "Recommended",
                            ),
                            Tab(
                                text: AppPreference()
                                    .getString(PreferencesKey.city)),
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
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller:
                          followerController!.suggestionTabController,
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
                              RefreshIndicator(
                                onRefresh: () {
                                  searchFollowers = "";
                                  sort = "";
                                  suggestionsPage = 1;
                                  followerController!.mySuggestionsResult.clear();
                                  return _suggestions(context);
                                },
                                child: Container(
                                  child: followerController!
                                      .mySuggestionsResult
                                      .isNotEmpty
                                      ? ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      controller:
                                      suggestionsScrollController,
                                      itemCount: followerController!
                                          .mySuggestionsResult
                                          .length,
                                      itemBuilder:
                                          (followersContext,
                                          index) {
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
                                                    parameters =
                                                    {
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
                                                child: user.profile !=
                                                    null
                                                    ? CircleAvatar(
                                                  backgroundColor:
                                                  lightGray,
                                                  radius: ScreenUtil()
                                                      .radius(
                                                      17),
                                                  backgroundImage:
                                                  NetworkImage(
                                                      "${followerController!.userPath.value}${user.profile}"),
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
                                                            PreferencesKey.userId)) {
                                                      Get.toNamed(
                                                          RouteConstants
                                                              .profileScreen,
                                                          arguments:
                                                          user);
                                                    } else {
                                                      Map<String,
                                                          String>?
                                                      parameters =
                                                      {
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
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: ScreenUtil().setSp(14),
                                                                  color: black)),
                                                          SizedBox(
                                                            width: ScreenUtil()
                                                                .setSp(3),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                user.username != null
                                                                    ? '${user.username}'
                                                                    : "",
                                                                maxLines:
                                                                2,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: GoogleFonts.nunitoSans(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontSize: ScreenUtil().setSp(12),
                                                                    color: darkGray)),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                          user.city !=
                                                              null
                                                              ? '${user.city}, ${user.country}'
                                                              : "",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight: FontWeight
                                                                  .w300,
                                                              fontSize: ScreenUtil().setSp(
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
                                              SizedBox(
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
                                                      style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(appBackgroundColor),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft:
                                                                Radius.circular(5),
                                                                topRight:
                                                                Radius.circular(5),
                                                                bottomLeft:
                                                                Radius.circular(5),
                                                                bottomRight:
                                                                Radius.circular(5),
                                                              ),
                                                              side: BorderSide(color: buttonBlue)))),
                                                      onPressed: () async {
                                                        Api.post
                                                            .call(
                                                          context,
                                                          method:
                                                          "request-to-user/store",
                                                          param: {
                                                            "user_id":
                                                            AppPreference().getString(PreferencesKey.userId),
                                                            "request_to_user_id":
                                                            user.sId,
                                                            "request_type":
                                                            "follow",
                                                          },
                                                          onResponseSuccess:
                                                              (object) {
                                                            print(
                                                                object);
                                                            if (followerController!.userDetail!.sId ==
                                                                AppPreference().getString(PreferencesKey.userId)) {
                                                              Data
                                                              user =
                                                              Data();
                                                              user.user =
                                                              followerController!.mySuggestionsResult[index];
                                                              user.followMe =
                                                              1;
                                                              followerController!.myFollowingResult.insert(
                                                                  0,
                                                                  user);
                                                              followerController!
                                                                  .userDetail!
                                                                  .countFollowing = followerController!
                                                                  .userDetail!.countFollowing! +
                                                                  1;
                                                              followerController!
                                                                  .followingCount
                                                                  .value = followerController!.userDetail!.countFollowing!;
                                                            }
                                                            followerController!
                                                                .mySuggestionsResult
                                                                .removeAt(index);
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        'Follow',
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400,
                                                            fontSize:
                                                            ScreenUtil().setSp(
                                                                12),
                                                            color:
                                                            buttonBlue),
                                                      )),
                                                  height:
                                                  ScreenUtil()
                                                      .setHeight(
                                                      30),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                      : Center(
                                    child: Text(
                                        "No Suggestions Found",
                                        style: GoogleFonts
                                            .nunitoSans(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight
                                                .w500)),
                                  ),
                                ),
                              ),
                              RefreshIndicator(
                                onRefresh: () {
                                  searchFollowers = "";
                                  sort = "";
                                  suggestionsCityPage = 1;
                                  followerController!.mySuggestionsCityResult.clear();
                                  return _suggestionsCity(context);
                                },
                                child: Container(
                                  child: followerController!
                                      .mySuggestionsCityResult
                                      .isNotEmpty
                                      ? ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      controller:
                                      suggestionsScrollController,
                                      itemCount: followerController!
                                          .mySuggestionsCityResult
                                          .length,
                                      itemBuilder:
                                          (followersContext,
                                          index) {
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
                                                    parameters =
                                                    {
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
                                                child: user.profile !=
                                                    null
                                                    ? CircleAvatar(
                                                  backgroundColor:
                                                  lightGray,
                                                  radius: ScreenUtil()
                                                      .radius(
                                                      17),
                                                  backgroundImage:
                                                  NetworkImage(
                                                      "${followerController!.userPath.value}${user.profile}"),
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
                                                            PreferencesKey.userId)) {
                                                      Get.toNamed(
                                                          RouteConstants
                                                              .profileScreen,
                                                          arguments:
                                                          user);
                                                    } else {
                                                      Map<String,
                                                          String>?
                                                      parameters =
                                                      {
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
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: ScreenUtil().setSp(14),
                                                                  color: black)),
                                                          SizedBox(
                                                            width: ScreenUtil()
                                                                .setSp(3),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                user.username != null
                                                                    ? '${user.username}'
                                                                    : "",
                                                                maxLines:
                                                                2,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: GoogleFonts.nunitoSans(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontSize: ScreenUtil().setSp(12),
                                                                    color: darkGray)),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                          user.city !=
                                                              null
                                                              ? '${user.city}, ${user.country}'
                                                              : "",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight: FontWeight
                                                                  .w300,
                                                              fontSize: ScreenUtil().setSp(
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
                                              SizedBox(
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
                                                      style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(appBackgroundColor),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft:
                                                                Radius.circular(5),
                                                                topRight:
                                                                Radius.circular(5),
                                                                bottomLeft:
                                                                Radius.circular(5),
                                                                bottomRight:
                                                                Radius.circular(5),
                                                              ),
                                                              side: BorderSide(color: buttonBlue)))),
                                                      onPressed: () async {
                                                        Api.post
                                                            .call(
                                                          context,
                                                          method:
                                                          "request-to-user/store",
                                                          param: {
                                                            "user_id":
                                                            AppPreference().getString(PreferencesKey.userId),
                                                            "request_to_user_id":
                                                            user.sId,
                                                            "request_type":
                                                            "follow",
                                                          },
                                                          onResponseSuccess:
                                                              (object) {
                                                            print(
                                                                object);
                                                            if (followerController!.userDetail!.sId ==
                                                                AppPreference().getString(PreferencesKey.userId)) {
                                                              Data
                                                              user =
                                                              Data();
                                                              user.user =
                                                              followerController!.mySuggestionsCityResult[index];
                                                              user.followMe =
                                                              1;
                                                              followerController!.myFollowingResult.insert(
                                                                  0,
                                                                  user);
                                                              followerController!
                                                                  .userDetail!
                                                                  .countFollowing = followerController!
                                                                  .userDetail!.countFollowing! +
                                                                  1;
                                                              followerController!
                                                                  .followingCount
                                                                  .value = followerController!.userDetail!.countFollowing!;
                                                            }
                                                            followerController!
                                                                .mySuggestionsCityResult
                                                                .removeAt(index);
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        'Follow',
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400,
                                                            fontSize:
                                                            ScreenUtil().setSp(
                                                                12),
                                                            color:
                                                            buttonBlue),
                                                      )),
                                                  height:
                                                  ScreenUtil()
                                                      .setHeight(
                                                      30),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                      : Center(
                                    child: Text(
                                        "No Suggestions Found",
                                        style: GoogleFonts
                                            .nunitoSans(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight
                                                .w500)),
                                  ),
                                ),
                              ),
                              RefreshIndicator(
                                onRefresh: () {
                                  searchFollowers = "";
                                  sort = "";
                                  suggestionsStatePage = 1;
                                  followerController!.mySuggestionsStateResult.clear();
                                  return _suggestionsState(context);
                                },
                                child: Container(
                                  child: followerController!
                                      .mySuggestionsStateResult
                                      .isNotEmpty
                                      ? ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      controller:
                                      suggestionsScrollController,
                                      itemCount: followerController!
                                          .mySuggestionsStateResult
                                          .length,
                                      itemBuilder:
                                          (followersContext,
                                          index) {
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
                                                    parameters =
                                                    {
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
                                                child: user.profile !=
                                                    null
                                                    ? CircleAvatar(
                                                  backgroundColor:
                                                  lightGray,
                                                  radius: ScreenUtil()
                                                      .radius(
                                                      17),
                                                  backgroundImage:
                                                  NetworkImage(
                                                      "${followerController!.userPath.value}${user.profile}"),
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
                                                            PreferencesKey.userId)) {
                                                      Get.toNamed(
                                                          RouteConstants
                                                              .profileScreen,
                                                          arguments:
                                                          user);
                                                    } else {
                                                      Map<String,
                                                          String>?
                                                      parameters =
                                                      {
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
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: ScreenUtil().setSp(14),
                                                                  color: black)),
                                                          SizedBox(
                                                            width: ScreenUtil()
                                                                .setSp(3),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                user.username != null
                                                                    ? '${user.username}'
                                                                    : "",
                                                                maxLines:
                                                                2,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: GoogleFonts.nunitoSans(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontSize: ScreenUtil().setSp(12),
                                                                    color: darkGray)),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                          user.city !=
                                                              null
                                                              ? '${user.city}, ${user.country}'
                                                              : "",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight: FontWeight
                                                                  .w300,
                                                              fontSize: ScreenUtil().setSp(
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
                                              SizedBox(
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
                                                      style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(appBackgroundColor),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft:
                                                                Radius.circular(5),
                                                                topRight:
                                                                Radius.circular(5),
                                                                bottomLeft:
                                                                Radius.circular(5),
                                                                bottomRight:
                                                                Radius.circular(5),
                                                              ),
                                                              side: BorderSide(color: buttonBlue)))),
                                                      onPressed: () async {
                                                        Api.post
                                                            .call(
                                                          context,
                                                          method:
                                                          "request-to-user/store",
                                                          param: {
                                                            "user_id":
                                                            AppPreference().getString(PreferencesKey.userId),
                                                            "request_to_user_id":
                                                            user.sId,
                                                            "request_type":
                                                            "follow",
                                                          },
                                                          onResponseSuccess:
                                                              (object) {
                                                            print(
                                                                object);
                                                            if (followerController!.userDetail!.sId ==
                                                                AppPreference().getString(PreferencesKey.userId)) {
                                                              Data
                                                              user =
                                                              Data();
                                                              user.user =
                                                              followerController!.mySuggestionsStateResult[index];
                                                              user.followMe =
                                                              1;
                                                              followerController!.myFollowingResult.insert(
                                                                  0,
                                                                  user);
                                                              followerController!
                                                                  .userDetail!
                                                                  .countFollowing = followerController!
                                                                  .userDetail!.countFollowing! +
                                                                  1;
                                                              followerController!
                                                                  .followingCount
                                                                  .value = followerController!.userDetail!.countFollowing!;
                                                            }
                                                            followerController!
                                                                .mySuggestionsStateResult
                                                                .removeAt(index);
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        'Follow',
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400,
                                                            fontSize:
                                                            ScreenUtil().setSp(
                                                                12),
                                                            color:
                                                            buttonBlue),
                                                      )),
                                                  height:
                                                  ScreenUtil()
                                                      .setHeight(
                                                      30),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                      : Center(
                                    child: Text(
                                        "No Suggestions Found",
                                        style: GoogleFonts
                                            .nunitoSans(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight
                                                .w500)),
                                  ),
                                ),
                              ),
                              RefreshIndicator(
                                onRefresh: () {
                                  searchFollowers = "";
                                  sort = "";
                                  suggestionsCountryPage = 1;
                                  followerController!.mySuggestionsCountryResult.clear();
                                  return _suggestionsCountry(context);
                                },
                                child: Container(
                                  child: followerController!
                                      .mySuggestionsCountryResult
                                      .isNotEmpty
                                      ? ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      controller:
                                      suggestionsScrollController,
                                      itemCount: followerController!
                                          .mySuggestionsCountryResult
                                          .length,
                                      itemBuilder:
                                          (followersContext,
                                          index) {
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
                                                    parameters =
                                                    {
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
                                                child: user.profile !=
                                                    null
                                                    ? CircleAvatar(
                                                  backgroundColor:
                                                  lightGray,
                                                  radius: ScreenUtil()
                                                      .radius(
                                                      17),
                                                  backgroundImage:
                                                  NetworkImage(
                                                      "${followerController!.userPath.value}${user.profile}"),
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
                                                            PreferencesKey.userId)) {
                                                      Get.toNamed(
                                                          RouteConstants
                                                              .profileScreen,
                                                          arguments:
                                                          user);
                                                    } else {
                                                      Map<String,
                                                          String>?
                                                      parameters =
                                                      {
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
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: ScreenUtil().setSp(14),
                                                                  color: black)),
                                                          SizedBox(
                                                            width: ScreenUtil()
                                                                .setSp(3),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                user.username != null
                                                                    ? '${user.username}'
                                                                    : "",
                                                                maxLines:
                                                                2,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: GoogleFonts.nunitoSans(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontSize: ScreenUtil().setSp(12),
                                                                    color: darkGray)),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                          user.city !=
                                                              null
                                                              ? '${user.city}, ${user.country}'
                                                              : "",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight: FontWeight
                                                                  .w300,
                                                              fontSize: ScreenUtil().setSp(
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
                                              SizedBox(
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
                                                      style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(appBackgroundColor),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft:
                                                                Radius.circular(5),
                                                                topRight:
                                                                Radius.circular(5),
                                                                bottomLeft:
                                                                Radius.circular(5),
                                                                bottomRight:
                                                                Radius.circular(5),
                                                              ),
                                                              side: BorderSide(color: buttonBlue)))),
                                                      onPressed: () async {
                                                        Api.post
                                                            .call(
                                                          context,
                                                          method:
                                                          "request-to-user/store",
                                                          param: {
                                                            "user_id":
                                                            AppPreference().getString(PreferencesKey.userId),
                                                            "request_to_user_id":
                                                            user.sId,
                                                            "request_type":
                                                            "follow",
                                                          },
                                                          onResponseSuccess:
                                                              (object) {
                                                            print(
                                                                object);
                                                            if (followerController!.userDetail!.sId ==
                                                                AppPreference().getString(PreferencesKey.userId)) {
                                                              Data
                                                              user =
                                                              Data();
                                                              user.user =
                                                              followerController!.mySuggestionsCountryResult[index];
                                                              user.followMe =
                                                              1;
                                                              followerController!.myFollowingResult.insert(
                                                                  0,
                                                                  user);
                                                              followerController!
                                                                  .userDetail!
                                                                  .countFollowing = followerController!
                                                                  .userDetail!.countFollowing! +
                                                                  1;
                                                              followerController!
                                                                  .followingCount
                                                                  .value = followerController!.userDetail!.countFollowing!;
                                                            }
                                                            followerController!
                                                                .mySuggestionsCountryResult
                                                                .removeAt(index);
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        'Follow',
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400,
                                                            fontSize:
                                                            ScreenUtil().setSp(
                                                                12),
                                                            color:
                                                            buttonBlue),
                                                      )),
                                                  height:
                                                  ScreenUtil()
                                                      .setHeight(
                                                      30),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                      : Center(
                                    child: Text(
                                        "No Suggestions Found",
                                        style: GoogleFonts
                                            .nunitoSans(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight
                                                .w500)),
                                  ),
                                ),
                              ),
                              RefreshIndicator(
                                onRefresh: () {
                                  searchFollowers = "";
                                  sort = "";
                                  suggestionsPage = 1;
                                  followerController!.mySuggestionsResult.clear();
                                  return _suggestions(context);
                                },
                                child: Container(
                                  child: followerController!
                                      .mySuggestionsResult
                                      .isNotEmpty
                                      ? ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      controller:
                                      suggestionsScrollController,
                                      itemCount: followerController!
                                          .mySuggestionsResult
                                          .length,
                                      itemBuilder:
                                          (followersContext,
                                          index) {
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
                                                    parameters =
                                                    {
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
                                                child: user.profile !=
                                                    null
                                                    ? CircleAvatar(
                                                  backgroundColor:
                                                  lightGray,
                                                  radius: ScreenUtil()
                                                      .radius(
                                                      17),
                                                  backgroundImage:
                                                  NetworkImage(
                                                      "${followerController!.userPath.value}${user.profile}"),
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
                                                            PreferencesKey.userId)) {
                                                      Get.toNamed(
                                                          RouteConstants
                                                              .profileScreen,
                                                          arguments:
                                                          user);
                                                    } else {
                                                      Map<String,
                                                          String>?
                                                      parameters =
                                                      {
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
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: ScreenUtil().setSp(14),
                                                                  color: black)),
                                                          SizedBox(
                                                            width: ScreenUtil()
                                                                .setSp(3),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                user.username != null
                                                                    ? '${user.username}'
                                                                    : "",
                                                                maxLines:
                                                                2,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: GoogleFonts.nunitoSans(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontSize: ScreenUtil().setSp(12),
                                                                    color: darkGray)),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                          user.city !=
                                                              null
                                                              ? '${user.city}, ${user.country}'
                                                              : "",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight: FontWeight
                                                                  .w300,
                                                              fontSize: ScreenUtil().setSp(
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
                                              SizedBox(
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
                                                      style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(appBackgroundColor),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft:
                                                                Radius.circular(5),
                                                                topRight:
                                                                Radius.circular(5),
                                                                bottomLeft:
                                                                Radius.circular(5),
                                                                bottomRight:
                                                                Radius.circular(5),
                                                              ),
                                                              side: BorderSide(color: buttonBlue)))),
                                                      onPressed: () async {
                                                        Api.post
                                                            .call(
                                                          context,
                                                          method:
                                                          "request-to-user/store",
                                                          param: {
                                                            "user_id":
                                                            AppPreference().getString(PreferencesKey.userId),
                                                            "request_to_user_id":
                                                            user.sId,
                                                            "request_type":
                                                            "follow",
                                                          },
                                                          onResponseSuccess:
                                                              (object) {
                                                            print(
                                                                object);
                                                            if (followerController!.userDetail!.sId ==
                                                                AppPreference().getString(PreferencesKey.userId)) {
                                                              Data
                                                              user =
                                                              Data();
                                                              user.user =
                                                              followerController!.mySuggestionsResult[index];
                                                              user.followMe =
                                                              1;
                                                              followerController!.myFollowingResult.insert(
                                                                  0,
                                                                  user);
                                                              followerController!
                                                                  .userDetail!
                                                                  .countFollowing = followerController!
                                                                  .userDetail!.countFollowing! +
                                                                  1;
                                                              followerController!
                                                                  .followingCount
                                                                  .value = followerController!.userDetail!.countFollowing!;
                                                            }
                                                            followerController!
                                                                .mySuggestionsResult
                                                                .removeAt(index);
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        'Follow',
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400,
                                                            fontSize:
                                                            ScreenUtil().setSp(
                                                                12),
                                                            color:
                                                            buttonBlue),
                                                      )),
                                                  height:
                                                  ScreenUtil()
                                                      .setHeight(
                                                      30),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                      : Center(
                                    child: Text(
                                        "No Suggestions Found",
                                        style: GoogleFonts
                                            .nunitoSans(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight
                                                .w500)),
                                  ),
                                ),
                              ),
                            ],
                            physics:
                            const NeverScrollableScrollPhysics(),
                          )
                              : TabBarView(
                            controller: followerController!
                                .suggestionTabController,
                            children: [
                              RefreshIndicator(
                                onRefresh: () {
                                  searchFollowers = "";
                                  sort = "";
                                  suggestionsPage = 1;
                                  followerController!.mySuggestionsResult.clear();
                                  return _suggestions(context);
                                },
                                child: Container(
                                  child: followerController!
                                      .mySuggestionsResult
                                      .isNotEmpty
                                      ? ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      controller:
                                      suggestionsScrollController,
                                      itemCount: followerController!
                                          .mySuggestionsResult
                                          .length,
                                      itemBuilder:
                                          (followersContext,
                                          index) {
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
                                                    parameters =
                                                    {
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
                                                child: user.profile !=
                                                    null
                                                    ? CircleAvatar(
                                                  backgroundColor:
                                                  lightGray,
                                                  radius: ScreenUtil()
                                                      .radius(
                                                      17),
                                                  backgroundImage:
                                                  NetworkImage(
                                                      "${followerController!.userPath.value}${user.profile}"),
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
                                                            PreferencesKey.userId)) {
                                                      Get.toNamed(
                                                          RouteConstants
                                                              .profileScreen,
                                                          arguments:
                                                          user);
                                                    } else {
                                                      Map<String,
                                                          String>?
                                                      parameters =
                                                      {
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
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: ScreenUtil().setSp(14),
                                                                  color: black)),
                                                          SizedBox(
                                                            width: ScreenUtil()
                                                                .setSp(3),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                user.username != null
                                                                    ? '${user.username}'
                                                                    : "",
                                                                maxLines:
                                                                2,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: GoogleFonts.nunitoSans(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontSize: ScreenUtil().setSp(12),
                                                                    color: darkGray)),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                          user.city !=
                                                              null
                                                              ? '${user.city}, ${user.country}'
                                                              : "",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight: FontWeight
                                                                  .w300,
                                                              fontSize: ScreenUtil().setSp(
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
                                              SizedBox(
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
                                                      style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(appBackgroundColor),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft:
                                                                Radius.circular(5),
                                                                topRight:
                                                                Radius.circular(5),
                                                                bottomLeft:
                                                                Radius.circular(5),
                                                                bottomRight:
                                                                Radius.circular(5),
                                                              ),
                                                              side: BorderSide(color: buttonBlue)))),
                                                      onPressed: () async {
                                                        Api.post
                                                            .call(
                                                          context,
                                                          method:
                                                          "request-to-user/store",
                                                          param: {
                                                            "user_id":
                                                            AppPreference().getString(PreferencesKey.userId),
                                                            "request_to_user_id":
                                                            user.sId,
                                                            "request_type":
                                                            "follow",
                                                          },
                                                          onResponseSuccess:
                                                              (object) {
                                                            print(
                                                                object);
                                                            if (followerController!.userDetail!.sId ==
                                                                AppPreference().getString(PreferencesKey.userId)) {
                                                              Data
                                                              user =
                                                              Data();
                                                              user.user =
                                                              followerController!.mySuggestionsResult[index];
                                                              user.followMe =
                                                              1;
                                                              followerController!.myFollowingResult.insert(
                                                                  0,
                                                                  user);
                                                              followerController!
                                                                  .userDetail!
                                                                  .countFollowing = followerController!
                                                                  .userDetail!.countFollowing! +
                                                                  1;
                                                              followerController!
                                                                  .followingCount
                                                                  .value = followerController!.userDetail!.countFollowing!;
                                                            }
                                                            followerController!
                                                                .mySuggestionsResult
                                                                .removeAt(index);
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        'Follow',
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400,
                                                            fontSize:
                                                            ScreenUtil().setSp(
                                                                12),
                                                            color:
                                                            buttonBlue),
                                                      )),
                                                  height:
                                                  ScreenUtil()
                                                      .setHeight(
                                                      30),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                      : Center(
                                    child: Text(
                                        "No Suggestions Found",
                                        style: GoogleFonts
                                            .nunitoSans(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight
                                                .w500)),
                                  ),
                                ),
                              ),
                              RefreshIndicator(
                                onRefresh: () {
                                  searchFollowers = "";
                                  sort = "";
                                  suggestionsPage = 1;
                                  followerController!.mySuggestionsResult.clear();
                                  return _suggestions(context);
                                },
                                child: Container(
                                  child: followerController!
                                      .mySuggestionsResult
                                      .isNotEmpty
                                      ? ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      controller:
                                      suggestionsScrollController,
                                      itemCount: followerController!
                                          .mySuggestionsResult
                                          .length,
                                      itemBuilder:
                                          (followersContext,
                                          index) {
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
                                                    parameters =
                                                    {
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
                                                child: user.profile !=
                                                    null
                                                    ? CircleAvatar(
                                                  backgroundColor:
                                                  lightGray,
                                                  radius: ScreenUtil()
                                                      .radius(
                                                      17),
                                                  backgroundImage:
                                                  NetworkImage(
                                                      "${followerController!.userPath.value}${user.profile}"),
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
                                                            PreferencesKey.userId)) {
                                                      Get.toNamed(
                                                          RouteConstants
                                                              .profileScreen,
                                                          arguments:
                                                          user);
                                                    } else {
                                                      Map<String,
                                                          String>?
                                                      parameters =
                                                      {
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
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: ScreenUtil().setSp(14),
                                                                  color: black)),
                                                          SizedBox(
                                                            width: ScreenUtil()
                                                                .setSp(3),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                user.username != null
                                                                    ? '${user.username}'
                                                                    : "",
                                                                maxLines:
                                                                2,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: GoogleFonts.nunitoSans(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontSize: ScreenUtil().setSp(12),
                                                                    color: darkGray)),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                          user.city !=
                                                              null
                                                              ? '${user.city}, ${user.country}'
                                                              : "",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight: FontWeight
                                                                  .w300,
                                                              fontSize: ScreenUtil().setSp(
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
                                              SizedBox(
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
                                                      style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(appBackgroundColor),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft:
                                                                Radius.circular(5),
                                                                topRight:
                                                                Radius.circular(5),
                                                                bottomLeft:
                                                                Radius.circular(5),
                                                                bottomRight:
                                                                Radius.circular(5),
                                                              ),
                                                              side: BorderSide(color: buttonBlue)))),
                                                      onPressed: () async {
                                                        Api.post
                                                            .call(
                                                          context,
                                                          method:
                                                          "request-to-user/store",
                                                          param: {
                                                            "user_id":
                                                            AppPreference().getString(PreferencesKey.userId),
                                                            "request_to_user_id":
                                                            user.sId,
                                                            "request_type":
                                                            "follow",
                                                          },
                                                          onResponseSuccess:
                                                              (object) {
                                                            print(
                                                                object);
                                                            if (followerController!.userDetail!.sId ==
                                                                AppPreference().getString(PreferencesKey.userId)) {
                                                              Data
                                                              user =
                                                              Data();
                                                              user.user =
                                                              followerController!.mySuggestionsResult[index];
                                                              user.followMe =
                                                              1;
                                                              followerController!.myFollowingResult.insert(
                                                                  0,
                                                                  user);
                                                              followerController!
                                                                  .userDetail!
                                                                  .countFollowing = followerController!
                                                                  .userDetail!.countFollowing! +
                                                                  1;
                                                              followerController!
                                                                  .followingCount
                                                                  .value = followerController!.userDetail!.countFollowing!;
                                                            }
                                                            followerController!
                                                                .mySuggestionsResult
                                                                .removeAt(index);
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        'Follow',
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400,
                                                            fontSize:
                                                            ScreenUtil().setSp(
                                                                12),
                                                            color:
                                                            buttonBlue),
                                                      )),
                                                  height:
                                                  ScreenUtil()
                                                      .setHeight(
                                                      30),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                      : Center(
                                    child: Text(
                                        "No Suggestions Found",
                                        style: GoogleFonts
                                            .nunitoSans(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight
                                                .w500)),
                                  ),
                                ),
                              ),
                            ],
                            physics:
                            const NeverScrollableScrollPhysics(),
                          ),
                        ),
                      ],
                    ),
                  ],
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
            ),
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
                          initialValue: searchFollowers,
                          style: size13_M_normal(textColor: color606060),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15),
                            hintStyle: size13_M_normal(textColor: color606060),
                            hintText: "Search",
                            border: InputBorder.none,
                          ),
                          onChanged: (text) {
                            if (text.isEmpty) {
                              searchFollowers = text;
                              if (followerController!.controller!.index == 0) {
                                followersPage = 1;
                                followerController!.myFollowersResult.clear();
                                _followers(context);
                              } else if (followerController!
                                      .controller!.index ==
                                  1) {
                                followingPage = 1;
                                followerController!.myFollowingResult.clear();
                                _following(context);
                              } else if (followerController!
                                      .controller!.index ==
                                  2) {
                                if (followerController!.suggestionTabController!.index == 0) {
                                  suggestionsPage = 1;
                                  followerController!.mySuggestionsResult.clear();
                                  _suggestions(context);
                                }else if (followerController!.suggestionTabController!.index == 1) {
                                  if(AppPreference()
                                      .getString(PreferencesKey.city)
                                      .isNotEmpty){
                                    suggestionsCityPage = 1;
                                    followerController!.mySuggestionsCityResult
                                        .clear();
                                    _suggestionsCity(context);
                                  }else {
                                    suggestionsPage = 1;
                                    followerController!.mySuggestionsResult
                                        .clear();
                                    _suggestions(context);
                                  }
                                }else if (followerController!.suggestionTabController!.index == 2) {
                                  suggestionsStatePage = 1;
                                  followerController!.mySuggestionsStateResult
                                      .clear();
                                  _suggestionsState(context);
                                }else if (followerController!.suggestionTabController!.index == 3){
                                  suggestionsCountryPage = 1;
                                  followerController!.mySuggestionsCountryResult
                                      .clear();
                                  _suggestionsCountry(context);
                                }else {
                                  suggestionsPage = 1;
                                  followerController!.mySuggestionsResult.clear();
                                  _suggestions(context);
                                }
                              }
                            }
                          },
                          onFieldSubmitted: (text) {
                            searchFollowers = text;
                            if (followerController!.controller!.index == 0) {
                              followersPage = 1;
                              followerController!.myFollowersResult.clear();
                              _followers(context);
                            } else if (followerController!.controller!.index ==
                                1) {
                              followingPage = 1;
                              followerController!.myFollowingResult.clear();
                              _following(context);
                            } else if (followerController!.controller!.index ==
                                2) {
                              if (followerController!.suggestionTabController!.index == 0) {
                                suggestionsPage = 1;
                                followerController!.mySuggestionsResult.clear();
                                _suggestions(context);
                              }else if (followerController!.suggestionTabController!.index == 1) {
                                if(AppPreference()
                                    .getString(PreferencesKey.city)
                                    .isNotEmpty){
                                  suggestionsCityPage = 1;
                                  followerController!.mySuggestionsCityResult
                                      .clear();
                                  _suggestionsCity(context);
                                }else {
                                  suggestionsPage = 1;
                                  followerController!.mySuggestionsResult
                                      .clear();
                                  _suggestions(context);
                                }
                              }else if (followerController!.suggestionTabController!.index == 2) {
                                suggestionsStatePage = 1;
                                followerController!.mySuggestionsStateResult
                                    .clear();
                                _suggestionsState(context);
                              }else if (followerController!.suggestionTabController!.index == 3){
                                suggestionsCountryPage = 1;
                                followerController!.mySuggestionsCountryResult
                                    .clear();
                                _suggestionsCountry(context);
                              }else {
                                suggestionsPage = 1;
                                followerController!.mySuggestionsResult.clear();
                                _suggestions(context);
                              }
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

  _followers(BuildContext context) async {
    Map<String, dynamic> param = {
      "page": followersPage.toString(),
      "user_id": followerController!.userDetail!.sId,
      "search": searchFollowers,
      "sort": sort,
    };
    Api.get.call(context,
        method: "connection/follower",
        param: param,
        isLoading: false, onResponseSuccess: (Map object) {
      var result = FollowerUser.fromJson(object);
      if (result.data!.isNotEmpty) {
        followerController!.userPath.value = result.path!;
        if (followersPage == 1) {
          followerController!.myFollowersResult.clear();
        }
        followerController!.myFollowersResult.addAll(result.data!);
      } else {
        if (followersPage == 1) {
          followerController!.myFollowersResult.clear();
        }
        followersPage = followersPage > 1 ? followersPage - 1 : followersPage;
      }
    });
  }

  _following(BuildContext context) async {
    Map<String, dynamic> param = {
      "page": followingPage.toString(),
      "user_id": followerController!.userDetail!.sId,
      "search": searchFollowers,
      "sort": sort,
    };
    Api.get.call(context,
        method: "connection/following",
        param: param,
        isLoading: false, onResponseSuccess: (Map object) {
      var result = FollowerUser.fromJson(object);
      if (result.data!.isNotEmpty) {
        followerController!.userPath.value = result.path!;
        if (followingPage == 1) {
          followerController!.myFollowingResult.clear();
        }
        followerController!.myFollowingResult.addAll(result.data!);
      } else {
        if (followingPage == 1) {
          followerController!.myFollowingResult.clear();
        }
        followingPage = followingPage > 1 ? followingPage - 1 : followingPage;
      }
    });
  }

  _suggestions(BuildContext context) async {
    Map<String, dynamic> param = {
      "page": suggestionsPage.toString(),
      "user_id": AppPreference().getString(PreferencesKey.userId),
      "search": searchFollowers,
      "sort": sort,
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
            suggestionsPage > 1 ? suggestionsPage - 1 : suggestionsPage;
      }
    });
  }

  _suggestionsCity(BuildContext context) async {
    Map<String, dynamic> param = {
      "page": suggestionsCityPage.toString(),
      "search": searchFollowers,
      "sort": sort,
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
            ? suggestionsCityPage - 1
            : suggestionsCityPage;
      }
    });
  }

  _suggestionsState(BuildContext context) async {
    Map<String, dynamic> param = {
      "page": suggestionsStatePage.toString(),
      "search": searchFollowers,
      "sort": sort,
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
            ? suggestionsStatePage - 1
            : suggestionsStatePage;
      }
    });
  }

  _suggestionsCountry(BuildContext context) async {
    Map<String, dynamic> param = {
      "page": suggestionsCountryPage.toString(),
      "search": searchFollowers,
      "sort": sort,
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
            ? suggestionsCountryPage - 1
            : suggestionsCountryPage;
      }
    });
  }
}



