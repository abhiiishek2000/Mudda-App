import 'dart:ui';

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
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/FollowerUser.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserSuggestionsModel.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';

class FollowerInfoScreen extends StatefulWidget {
  const FollowerInfoScreen({Key? key}) : super(key: key);


  @override
  _FollowerInfoScreenState createState() => _FollowerInfoScreenState();
}

class _FollowerInfoScreenState extends State<FollowerInfoScreen> with TickerProviderStateMixin{
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  UserProfileUpdateController userProfileUpdateController = Get.find<UserProfileUpdateController>();
  List<Data> myFollowersResult = [];

  List mySuggestionsResult = [];
  List mySuggestionsCityResult = [];
  List mySuggestionsStateResult = [];
  List mySuggestionsCountryResult = [];

  List myFollowingResult = [];

  int followersPage = 1;
  int followingPage = 1;
  int suggestionsPage = 1;
  int suggestionsCityPage = 1;
  int suggestionsStatePage = 1;
  int suggestionsCountryPage = 1;
  ScrollController followersScrollController = ScrollController();
  ScrollController followingScrollController = ScrollController();
  ScrollController suggestionsScrollController = ScrollController();
  ScrollController suggestionsCityScrollController = ScrollController();
  ScrollController suggestionsStateScrollController = ScrollController();
  ScrollController suggestionsCountryScrollController = ScrollController();

  TabController? tabController;
  TabController? suggestionTabController;

  String userPath = "";

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController!.addListener(() {
      if(tabController!.index == 0 && myFollowersResult.isEmpty){
        myFollowersResult.clear();
        _followers();
      }
      if(tabController!.index == 1 && myFollowingResult.isEmpty){
        myFollowingResult.clear();
        _following();
      }
      if(tabController!.index == 2 && mySuggestionsResult.isEmpty){
        mySuggestionsResult.clear();
        _suggestions();
      }
    });
    suggestionTabController = TabController(length: AppPreference().getString(PreferencesKey.city).isEmpty?2:5, vsync: this);
    suggestionTabController!.addListener(() {
      if(suggestionTabController!.index == 0 && mySuggestionsResult.isEmpty){
        mySuggestionsResult.clear();
        _suggestions();
      }
      if(suggestionTabController!.index == 1 && mySuggestionsCityResult.isEmpty){
        mySuggestionsCityResult.clear();
      _suggestionsCity();
      }
      if(suggestionTabController!.index == 2 && mySuggestionsStateResult.isEmpty){
        mySuggestionsStateResult.clear();
        _suggestionsState();
      }
      if(suggestionTabController!.index == 3 && mySuggestionsCountryResult.isEmpty){
        mySuggestionsCountryResult.clear();
        _suggestionsCountry();
      }
      if(suggestionTabController!.index == (AppPreference().getString(PreferencesKey.city).isEmpty?1:4) && mySuggestionsResult.isEmpty){
        mySuggestionsResult.clear();
        _suggestions();
      }
    });
    if(muddaNewsController.followerIndex.value == 1){
      setState(() {
        tabController!.index = 1;
      });
    }else{
      _followers();
    }
    followersScrollController.addListener(() {
      if (followersScrollController.position.maxScrollExtent ==
          followersScrollController.position.pixels) {
        followersPage++;
        _followers();
      }
    });
    followingScrollController.addListener(() {
      if (followingScrollController.position.maxScrollExtent ==
          followingScrollController.position.pixels) {
        followingPage++;
        _following();
      }
    });
    suggestionsScrollController.addListener(() {
      if (suggestionsScrollController.position.maxScrollExtent ==
          suggestionsScrollController.position.pixels) {
        suggestionsPage++;
        _suggestions();
      }
    });
    suggestionsCityScrollController.addListener(() {
      if (suggestionsCityScrollController.position.maxScrollExtent ==
          suggestionsCityScrollController.position.pixels) {
        suggestionsCityPage++;
        _suggestionsCity();
      }
    });
    suggestionsStateScrollController.addListener(() {
      if (suggestionsStateScrollController.position.maxScrollExtent ==
          suggestionsStateScrollController.position.pixels) {
        suggestionsStatePage++;
        _suggestionsState();
      }
    });
    suggestionsCountryScrollController.addListener(() {
      if (suggestionsCountryScrollController.position.maxScrollExtent ==
          suggestionsCountryScrollController.position.pixels) {
        suggestionsCountryPage++;
        _suggestionsCountry();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButton: CustomFab(),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: colorAppBackground,
        iconTheme: const IconThemeData(color: colorBlack),
        leading:  GestureDetector(
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
          IconButton(onPressed: (){}, icon: Image.asset(AppIcons.searchIcon,
              height: 20, width: 20)),
         IconButton(onPressed: (){}, icon:  Image.asset(AppIcons.filterIcon,
             height: 20, width: 20)),
          IconButton(onPressed: (){}, icon: Image.asset(AppIcons.filterIcon2,
              height: 20, width: 20))

        ],
      ),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      color: colorAppBackground,
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TabBar(
              tabs: [
                Tab(
                  text: "Followers(${NumberFormat
                      .compactCurrency(
                    decimalDigits: 0,
                    symbol:
                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                  ).format(userProfileUpdateController.userProfile.value.countFollowers??0)})",
                ),
                Tab(text: "Following(${NumberFormat
                    .compactCurrency(
                  decimalDigits: 0,
                  symbol:
                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                ).format(userProfileUpdateController.userProfile.value.countFollowing??0)})"),
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
              controller: tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  Container(
                    child: myFollowersResult.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            controller: followersScrollController,
                            itemCount: myFollowersResult.length,
                            itemBuilder: (followersContext, index) {
                              Data userModel = myFollowersResult.elementAt(index);
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
                                        muddaNewsController.acceptUserDetail.value = userModel.user!;
                                        if(userModel.user!.sId == AppPreference().getString(PreferencesKey.userId)){
                                          Get.toNamed(
                                              RouteConstants.profileScreen);
                                        }else {
                                          Get.toNamed(
                                              RouteConstants.otherUserProfileScreen);
                                        }
                                      },
                                      child: userModel
                                                  .user!.profile !=
                                              null
                                          ? CircleAvatar(
                                              backgroundColor: grey,
                                              radius: ScreenUtil().radius(17),
                                              backgroundImage: NetworkImage(
                                                  "$userPath${userModel
                                                      .user!.profile}"),
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
                                          muddaNewsController.acceptUserDetail.value = userModel.user!;
                                          if(userModel.user!.sId == AppPreference().getString(PreferencesKey.userId)){
                                            Get.toNamed(
                                                RouteConstants.profileScreen);
                                          }else {
                                            Get.toNamed(
                                                RouteConstants.otherUserProfileScreen);
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${userModel.user!.fullname}',
                                                    style: GoogleFonts.nunitoSans(
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontSize: ScreenUtil()
                                                            .setSp(14),
                                                        color: black)),
                                                SizedBox(
                                                  width: ScreenUtil()
                                                      .setSp(5),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      userModel.user!.username !=
                                                          null
                                                          ? '${userModel.user!.username}'
                                                          : "",
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.nunitoSans(
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          fontSize: ScreenUtil()
                                                              .setSp(14),
                                                          color: darkGray)),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      userModel.user!.city !=
                                                          null
                                                          ? '${userModel.user!.city}, ${userModel.user!.country}'
                                                          : "",
                                                      style: GoogleFonts.nunitoSans(
                                                          fontWeight:
                                                          FontWeight.w300,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          color: lightGray)),
                                                ),
                                                Visibility(
                                                  visible: userModel.iAmFollowing == 0 &&
                                                      userModel.user!.sId != AppPreference().getString(PreferencesKey.userId) && AppPreference().getBool(PreferencesKey.isGuest)==false,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Api.post.call(
                                                        context,
                                                        method: "request-to-user/store",
                                                        param: {
                                                          "user_id":AppPreference().getString(PreferencesKey.userId),
                                                          "request_to_user_id":userModel.user!.sId,
                                                          "request_type":"follow",
                                                        },
                                                        onResponseSuccess: (object) {
                                                          myFollowersResult[index].iAmFollowing = 1;
                                                          if(muddaNewsController.acceptUserDetail.value.sId ==  AppPreference().getString(PreferencesKey.userId)) {
                                                            myFollowingResult.add(myFollowersResult[index]);
                                                          }
                                                          setState(() {});
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      'Follow Back',
                                                      style: GoogleFonts.nunitoSans(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize:
                                                          ScreenUtil().setSp(12),
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
                                      visible: (userModel.iAmFollowing == 1 || muddaNewsController.acceptUserDetail.value.sId == AppPreference().getString(PreferencesKey.userId)) && userModel.user!.sId != AppPreference().getString(PreferencesKey.userId),
                                      child: SizedBox(
                                        height: ScreenUtil().setHeight(30),
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
                                                method: "request-to-user/store",
                                                param: {
                                                  "user_id":userModel.user!.sId,
                                                  "request_to_user_id":AppPreference().getString(PreferencesKey.userId),
                                                  "request_type":"follow",
                                                },
                                                onResponseSuccess: (object) {
                                                  print(object);
                                                  myFollowersResult.elementAt(index).iAmFollowing = 0;
                                                  if(muddaNewsController.acceptUserDetail.value.sId ==  AppPreference().getString(PreferencesKey.userId)) {
                                                    myFollowersResult.removeAt(index);
                                                  }
                                                  setState(() {});
                                                },
                                              );
                                            },
                                            child: Text(
                                              'Remove',
                                              style: GoogleFonts.nunitoSans(
                                                  color: lightGray,
                                                  fontSize:
                                                      ScreenUtil().setSp(12),
                                                  fontWeight:
                                                      FontWeight.w400),
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
                  Container(
                    child: myFollowingResult.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            controller: followingScrollController,
                            itemCount: myFollowingResult.length,
                            itemBuilder: (followersContext, index) {
                              Data userModel = myFollowingResult.elementAt(index);
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
                                        muddaNewsController.acceptUserDetail.value = userModel.user!;
                                        if(userModel.user!.sId == AppPreference().getString(PreferencesKey.userId)){
                                          Get.toNamed(
                                              RouteConstants.profileScreen);
                                        }else {
                                          Get.toNamed(
                                              RouteConstants.otherUserProfileScreen);
                                        }
                                      },
                                      child: userModel.user!.profile !=
                                              null
                                          ? CircleAvatar(
                                        backgroundColor: lightGray,
                                              radius: ScreenUtil().radius(17),
                                              backgroundImage: NetworkImage(
                                                  "$userPath${userModel
                                                      .user!.profile}"),
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
                                          muddaNewsController.acceptUserDetail.value = userModel.user!;
                                          if(userModel.user!.sId == AppPreference().getString(PreferencesKey.userId)){
                                            Get.toNamed(
                                                RouteConstants.profileScreen);
                                          }else {
                                            Get.toNamed(
                                                RouteConstants.otherUserProfileScreen);
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${userModel.user!.fullname}',
                                                    style: GoogleFonts.nunitoSans(
                                                        fontSize: ScreenUtil()
                                                            .setSp(14),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: black)),
                                                SizedBox(
                                                  width: ScreenUtil().setSp(3),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      userModel.user!.username !=
                                                          null
                                                          ? '${userModel.user!.username} '
                                                          : "",
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.nunitoSans(
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          fontStyle: FontStyle.italic,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          color: darkGray)),
                                                ),
                                              ],
                                            ),
                                            Text(
                                                userModel.user!.city !=
                                                    null
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
                                      visible: userModel.followMe == 1 && userModel.user!.sId != AppPreference().getString(PreferencesKey.userId),
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
                                                method: "request-to-user/store",
                                                param: {
                                                  "user_id":AppPreference().getString(PreferencesKey.userId),
                                                  "request_to_user_id":userModel.user!.sId,
                                                  "request_type":"follow",
                                                },
                                                onResponseSuccess: (object) {
                                                  print(object);
                                                  myFollowingResult[index].followMe = 0;
                                                  if(muddaNewsController.acceptUserDetail.value.sId == AppPreference().getString(PreferencesKey.userId)) {
                                                    myFollowingResult
                                                        .removeAt(index);
                                                  }
                                                  setState(() {});
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
                                      visible: userModel.followMe == 0 && userModel.user!.sId != AppPreference().getString(PreferencesKey.userId)&& AppPreference().getBool(PreferencesKey.isGuest)==false,
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
                                                  myFollowingResult[index].followMe = 1;
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
                  Column(
                    children: [
                      TabBar(
                        tabs: [
                          const Tab(
                            text: "Recommended",
                          ),
                          Tab(text: AppPreference().getString(PreferencesKey.city)),
                          Tab(text: AppPreference().getString(PreferencesKey.state)),
                          Tab(text: AppPreference().getString(PreferencesKey.country)),
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
                        controller: suggestionTabController,
                      ),
                      Expanded(
                        child: AppPreference().getString(PreferencesKey.city).isNotEmpty ?TabBarView(
                          controller: suggestionTabController,
                          children: [
                            Container(
                              child: mySuggestionsResult.isNotEmpty
                                  ? ListView.builder(
                                  shrinkWrap: true,
                                  controller: suggestionsScrollController,
                                  itemCount: mySuggestionsResult.length,
                                  itemBuilder: (followersContext, index) {
                                    AcceptUserDetail user = mySuggestionsResult.elementAt(index);
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
                                              muddaNewsController.acceptUserDetail.value = user;
                                              if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                Get.toNamed(
                                                    RouteConstants.profileScreen);
                                              }else {
                                                Get.toNamed(
                                                    RouteConstants.otherUserProfileScreen);
                                              }
                                            },
                                            child: user.profile !=
                                                null
                                                ? CircleAvatar(
                                              backgroundColor: lightGray,
                                              radius: ScreenUtil().radius(17),
                                              backgroundImage: NetworkImage(
                                                  "$userPath${user.profile}"),
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
                                                muddaNewsController.acceptUserDetail.value = user;
                                                if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                  Get.toNamed(
                                                      RouteConstants.profileScreen);
                                                }else {
                                                  Get.toNamed(
                                                      RouteConstants.otherUserProfileScreen);
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          '${user.fullname}',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              fontSize: ScreenUtil()
                                                                  .setSp(14),
                                                              color: black)),
                                                      SizedBox(
                                                        width: ScreenUtil().setSp(3),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            user.username !=
                                                                null
                                                                ? '${user.username}'
                                                                : "",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: ScreenUtil()
                                                                    .setSp(12),
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
                                                          fontWeight:
                                                          FontWeight.w300,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          color: lightGray)),
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Visibility(
                                            visible:AppPreference().getBool(PreferencesKey.isGuest)==false,
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
                                                        "request_to_user_id":user.sId,
                                                        "request_type":"follow",
                                                      },
                                                      onResponseSuccess: (object) {
                                                        print(object);
                                                        if(muddaNewsController.acceptUserDetail.value.sId == AppPreference().getString(PreferencesKey.userId)) {
                                                          Data user = Data();
                                                          user.user = mySuggestionsResult[index];
                                                          user.followMe = 1;
                                                          myFollowingResult.insert(0, user);
                                                        }
                                                        mySuggestionsResult.removeAt(index);
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
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  : Center(
                                child: Text("No Suggestions Found",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            Container(
                              child: mySuggestionsCityResult.isNotEmpty
                                  ? ListView.builder(
                                  shrinkWrap: true,
                                  controller: suggestionsCityScrollController,
                                  itemCount: mySuggestionsCityResult.length,
                                  itemBuilder: (followersContext, index) {
                                    AcceptUserDetail user = mySuggestionsCityResult.elementAt(index);
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
                                              muddaNewsController.acceptUserDetail.value = user;
                                              if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                Get.toNamed(
                                                    RouteConstants.profileScreen);
                                              }else {
                                                Get.toNamed(
                                                    RouteConstants.otherUserProfileScreen);
                                              }
                                            },
                                            child: user.profile !=
                                                null
                                                ? CircleAvatar(
                                              backgroundColor: lightGray,
                                              radius: ScreenUtil().radius(17),
                                              backgroundImage: NetworkImage(
                                                  "$userPath${user.profile}"),
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
                                                muddaNewsController.acceptUserDetail.value = user;
                                                if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                  Get.toNamed(
                                                      RouteConstants.profileScreen);
                                                }else {
                                                  Get.toNamed(
                                                      RouteConstants.otherUserProfileScreen);
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          '${user.fullname}',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              fontSize: ScreenUtil()
                                                                  .setSp(14),
                                                              color: black)),
                                                      SizedBox(
                                                        width: ScreenUtil().setSp(3),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            user.username !=
                                                                null
                                                                ? '${user.username}'
                                                                : "",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: ScreenUtil()
                                                                    .setSp(12),
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
                                                          fontWeight:
                                                          FontWeight.w300,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          color: lightGray)),
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
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
                                                      "request_to_user_id":user.sId,
                                                      "request_type":"follow",
                                                    },
                                                    onResponseSuccess: (object) {
                                                      print(object);
                                                      if(muddaNewsController.acceptUserDetail.value.sId == AppPreference().getString(PreferencesKey.userId)) {
                                                        Data user = Data();
                                                        user.user = mySuggestionsCityResult[index];
                                                        user.followMe = 1;
                                                        myFollowingResult.insert(0, user);
                                                      }
                                                      mySuggestionsCityResult.removeAt(index);
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
                                        ],
                                      ),
                                    );
                                  })
                                  : Center(
                                child: Text("No Suggestions Found",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            Container(
                              child: mySuggestionsStateResult.isNotEmpty
                                  ? ListView.builder(
                                  shrinkWrap: true,
                                  controller: suggestionsStateScrollController,
                                  itemCount: mySuggestionsStateResult.length,
                                  itemBuilder: (followersContext, index) {
                                    AcceptUserDetail user = mySuggestionsStateResult.elementAt(index);
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
                                              muddaNewsController.acceptUserDetail.value = user;
                                              if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                Get.toNamed(
                                                    RouteConstants.profileScreen);
                                              }else {
                                                Get.toNamed(
                                                    RouteConstants.otherUserProfileScreen);
                                              }
                                            },
                                            child: user.profile !=
                                                null
                                                ? CircleAvatar(
                                              backgroundColor: lightGray,
                                              radius: ScreenUtil().radius(17),
                                              backgroundImage: NetworkImage(
                                                  "$userPath${user.profile}"),
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
                                                muddaNewsController.acceptUserDetail.value = user;
                                                if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                  Get.toNamed(
                                                      RouteConstants.profileScreen);
                                                }else {
                                                  Get.toNamed(
                                                      RouteConstants.otherUserProfileScreen);
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          '${user.fullname}',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              fontSize: ScreenUtil()
                                                                  .setSp(14),
                                                              color: black)),
                                                      SizedBox(
                                                        width: ScreenUtil().setSp(3),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            user.username !=
                                                                null
                                                                ? '${user.username}'
                                                                : "",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: ScreenUtil()
                                                                    .setSp(12),
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
                                                          fontWeight:
                                                          FontWeight.w300,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          color: lightGray)),
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
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
                                                      "request_to_user_id":user.sId,
                                                      "request_type":"follow",
                                                    },
                                                    onResponseSuccess: (object) {
                                                      print(object);
                                                      if(muddaNewsController.acceptUserDetail.value.sId == AppPreference().getString(PreferencesKey.userId)) {
                                                        Data user = Data();
                                                        user.user = mySuggestionsStateResult[index];
                                                        user.followMe = 1;
                                                        myFollowingResult.insert(0, user);
                                                      }
                                                      mySuggestionsStateResult.removeAt(index);
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
                                        ],
                                      ),
                                    );
                                  })
                                  : Center(
                                child: Text("No Suggestions Found",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            Container(
                              child: mySuggestionsCountryResult.isNotEmpty
                                  ? ListView.builder(
                                  shrinkWrap: true,
                                  controller: suggestionsCountryScrollController,
                                  itemCount: mySuggestionsCountryResult.length,
                                  itemBuilder: (followersContext, index) {
                                    AcceptUserDetail user = mySuggestionsCountryResult.elementAt(index);
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
                                              muddaNewsController.acceptUserDetail.value = user;
                                              if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                Get.toNamed(
                                                    RouteConstants.profileScreen);
                                              }else {
                                                Get.toNamed(
                                                    RouteConstants.otherUserProfileScreen);
                                              }
                                            },
                                            child: user.profile !=
                                                null
                                                ? CircleAvatar(
                                              backgroundColor: lightGray,
                                              radius: ScreenUtil().radius(17),
                                              backgroundImage: NetworkImage(
                                                  "$userPath${user.profile}"),
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
                                                muddaNewsController.acceptUserDetail.value = user;
                                                if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                  Get.toNamed(
                                                      RouteConstants.profileScreen);
                                                }else {
                                                  Get.toNamed(
                                                      RouteConstants.otherUserProfileScreen);
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          '${user.fullname}',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              fontSize: ScreenUtil()
                                                                  .setSp(14),
                                                              color: black)),
                                                      SizedBox(
                                                        width: ScreenUtil().setSp(3),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            user.username !=
                                                                null
                                                                ? '${user.username}'
                                                                : "",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: ScreenUtil()
                                                                    .setSp(12),
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
                                                          fontWeight:
                                                          FontWeight.w300,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          color: lightGray)),
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
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
                                                      "request_to_user_id":user.sId,
                                                      "request_type":"follow",
                                                    },
                                                    onResponseSuccess: (object) {
                                                      print(object);
                                                      if(muddaNewsController.acceptUserDetail.value.sId == AppPreference().getString(PreferencesKey.userId)) {
                                                        Data user = Data();
                                                        user.user = mySuggestionsCountryResult[index];
                                                        user.followMe = 1;
                                                        myFollowingResult.insert(0, user);
                                                      }
                                                      mySuggestionsCountryResult.removeAt(index);
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
                                        ],
                                      ),
                                    );
                                  })
                                  : Center(
                                child: Text("No Suggestions Found",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            Container(
                              child: mySuggestionsResult.isNotEmpty
                                  ? ListView.builder(
                                  shrinkWrap: true,
                                  controller: suggestionsScrollController,
                                  itemCount: mySuggestionsResult.length,
                                  itemBuilder: (followersContext, index) {
                                    AcceptUserDetail user = mySuggestionsResult.elementAt(index);
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
                                              muddaNewsController.acceptUserDetail.value = user;
                                              if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                Get.toNamed(
                                                    RouteConstants.profileScreen);
                                              }else {
                                                Get.toNamed(
                                                    RouteConstants.otherUserProfileScreen);
                                              }
                                            },
                                            child: user.profile !=
                                                null
                                                ? CircleAvatar(
                                              backgroundColor: lightGray,
                                              radius: ScreenUtil().radius(17),
                                              backgroundImage: NetworkImage(
                                                  "$userPath${user.profile}"),
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
                                                muddaNewsController.acceptUserDetail.value = user;
                                                if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                  Get.toNamed(
                                                      RouteConstants.profileScreen);
                                                }else {
                                                  Get.toNamed(
                                                      RouteConstants.otherUserProfileScreen);
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          '${user.fullname}',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              fontSize: ScreenUtil()
                                                                  .setSp(14),
                                                              color: black)),
                                                      SizedBox(
                                                        width: ScreenUtil().setSp(3),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            user.username !=
                                                                null
                                                                ? '${user.username}'
                                                                : "",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: ScreenUtil()
                                                                    .setSp(12),
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
                                                          fontWeight:
                                                          FontWeight.w300,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          color: lightGray)),
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Visibility(
                                            visible:AppPreference().getBool(PreferencesKey.isGuest)==false,
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
                                                        "request_to_user_id":user.sId,
                                                        "request_type":"follow",
                                                      },
                                                      onResponseSuccess: (object) {
                                                        print(object);
                                                        if(muddaNewsController.acceptUserDetail.value.sId == AppPreference().getString(PreferencesKey.userId)) {
                                                          Data user = Data();
                                                          user.user = mySuggestionsResult[index];
                                                          user.followMe = 1;
                                                          myFollowingResult.insert(0, user);
                                                        }
                                                        mySuggestionsResult.removeAt(index);
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
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  : Center(
                                child: Text("No Suggestions Found",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ],
                          physics: ScrollPhysics(),
                        ):TabBarView(
                          controller: suggestionTabController,
                          children: [
                            Container(
                              child: mySuggestionsResult.isNotEmpty
                                  ? ListView.builder(
                                  shrinkWrap: true,
                                  controller: suggestionsScrollController,
                                  itemCount: mySuggestionsResult.length,
                                  itemBuilder: (followersContext, index) {
                                    AcceptUserDetail user = mySuggestionsResult.elementAt(index);
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
                                              muddaNewsController.acceptUserDetail.value = user;
                                              if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                Get.toNamed(
                                                    RouteConstants.profileScreen);
                                              }else {
                                                Get.toNamed(
                                                    RouteConstants.otherUserProfileScreen);
                                              }
                                            },
                                            child: user.profile !=
                                                null
                                                ? CircleAvatar(
                                              backgroundColor: lightGray,
                                              radius: ScreenUtil().radius(17),
                                              backgroundImage: NetworkImage(
                                                  "$userPath${user.profile}"),
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
                                                muddaNewsController.acceptUserDetail.value = user;
                                                if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                  Get.toNamed(
                                                      RouteConstants.profileScreen);
                                                }else {
                                                  Get.toNamed(
                                                      RouteConstants.otherUserProfileScreen);
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          '${user.fullname}',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              fontSize: ScreenUtil()
                                                                  .setSp(14),
                                                              color: black)),
                                                      SizedBox(
                                                        width: ScreenUtil().setSp(3),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            user.username !=
                                                                null
                                                                ? '${user.username}'
                                                                : "",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: ScreenUtil()
                                                                    .setSp(12),
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
                                                          fontWeight:
                                                          FontWeight.w300,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          color: lightGray)),
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Visibility(
                                            visible:AppPreference().getBool(PreferencesKey.isGuest)==false,
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
                                                        "request_to_user_id":user.sId,
                                                        "request_type":"follow",
                                                      },
                                                      onResponseSuccess: (object) {
                                                        print(object);
                                                        if(muddaNewsController.acceptUserDetail.value.sId == AppPreference().getString(PreferencesKey.userId)) {
                                                          Data user = Data();
                                                          user.user = mySuggestionsResult[index];
                                                          user.followMe = 1;
                                                          myFollowingResult.insert(0, user);
                                                        }
                                                        mySuggestionsResult.removeAt(index);
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
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  : Center(
                                child: Text("No Suggestions Found",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            Container(
                              child: mySuggestionsResult.isNotEmpty
                                  ? ListView.builder(
                                  shrinkWrap: true,
                                  controller: suggestionsScrollController,
                                  itemCount: mySuggestionsResult.length,
                                  itemBuilder: (followersContext, index) {
                                    AcceptUserDetail user = mySuggestionsResult.elementAt(index);
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
                                              muddaNewsController.acceptUserDetail.value = user;
                                              if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                Get.toNamed(
                                                    RouteConstants.profileScreen);
                                              }else {
                                                Get.toNamed(
                                                    RouteConstants.otherUserProfileScreen);
                                              }
                                            },
                                            child: user.profile !=
                                                null
                                                ? CircleAvatar(
                                              backgroundColor: lightGray,
                                              radius: ScreenUtil().radius(17),
                                              backgroundImage: NetworkImage(
                                                  "$userPath${user.profile}"),
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
                                                muddaNewsController.acceptUserDetail.value = user;
                                                if(user.sId == AppPreference().getString(PreferencesKey.userId)){
                                                  Get.toNamed(
                                                      RouteConstants.profileScreen);
                                                }else {
                                                  Get.toNamed(
                                                      RouteConstants.otherUserProfileScreen);
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          '${user.fullname}',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              fontSize: ScreenUtil()
                                                                  .setSp(14),
                                                              color: black)),
                                                      SizedBox(
                                                        width: ScreenUtil().setSp(3),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            user.username !=
                                                                null
                                                                ? '${user.username}'
                                                                : "",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: ScreenUtil()
                                                                    .setSp(12),
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
                                                          fontWeight:
                                                          FontWeight.w300,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          color: lightGray)),
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Visibility(
                                            visible:AppPreference().getBool(PreferencesKey.isGuest)==false,
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
                                                        "request_to_user_id":user.sId,
                                                        "request_type":"follow",
                                                      },
                                                      onResponseSuccess: (object) {
                                                        print(object);
                                                        if(muddaNewsController.acceptUserDetail.value.sId == AppPreference().getString(PreferencesKey.userId)) {
                                                          Data user = Data();
                                                          user.user = mySuggestionsResult[index];
                                                          user.followMe = 1;
                                                          myFollowingResult.insert(0, user);
                                                        }
                                                        mySuggestionsResult.removeAt(index);
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
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  : Center(
                                child: Text("No Suggestions Found",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ],
                          physics: ScrollPhysics(),
                        ),
                      ),
                    ],
                  )
                ],
                physics: ScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _followers() async {
    Map<String, dynamic> param = {
      "page" : followersPage.toString(),
      "user_id":muddaNewsController.acceptUserDetail.value.sId,
    };
    Api.get.call(context,
        method:
        "connection/follower",
        param: param,
        isLoading: false,
        onResponseSuccess: (Map object) {
          var result = FollowerUser.fromJson(object);
          if (result.data!.isNotEmpty) {
            userPath = result.path!;
            myFollowersResult.addAll(result.data!);
            setState(() {});
          } else {
            followersPage = followersPage > 1 ? followersPage--:followersPage;
          }
        });
  }

  void _following() async {
    Map<String, dynamic> param = {
      "page" : followingPage.toString(),
      "user_id":muddaNewsController.acceptUserDetail.value.sId,
    };
    Api.get.call(context,
        method:
        "connection/following",
        param: param,
        isLoading: false,
        onResponseSuccess: (Map object) {
          var result = FollowerUser.fromJson(object);
          if (result.data!.isNotEmpty) {
            userPath = result.path!;
            setState(() {
              myFollowingResult.addAll(result.data!);
            });
          } else {
            followingPage = followingPage > 1 ? followingPage--:followingPage;
          }
        });
  }

  void _suggestions() async {
    Map<String, dynamic> param = {
      "page" : suggestionsPage.toString(),
      "search" : "",
      "user_id":AppPreference().getString(PreferencesKey.userId),
    };
    Api.get.call(context,
        method:
        "user/user-suggestion",
        param: param,
        isLoading: false,
        onResponseSuccess: (Map object) {
          var result = UserSuggestionsModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            userPath = result.path!;
            mySuggestionsResult.addAll(result.data!);
            setState(() {});
          } else {
            suggestionsPage = suggestionsPage > 1 ? suggestionsPage--:suggestionsPage;
          }
        });
  }
  void _suggestionsCity() async {
    Map<String, dynamic> param = {
      "page" : suggestionsCityPage.toString(),
      "search" : "",
      "filter_type" : "city",
      "filter_type_value":AppPreference().getString(PreferencesKey.city),
      "user_id":AppPreference().getString(PreferencesKey.userId),
    };
    Api.get.call(context,
        method:
        "user/user-suggestion",
        param: param,
        isLoading: false,
        onResponseSuccess: (Map object) {
          var result = UserSuggestionsModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            userPath = result.path!;
            mySuggestionsCityResult.addAll(result.data!);
            setState(() {});
          } else {
            suggestionsCityPage = suggestionsCityPage > 1 ? suggestionsCityPage--:suggestionsCityPage;
          }
        });
  }
  void _suggestionsState() async {
    Map<String, dynamic> param = {
      "page" : suggestionsStatePage.toString(),
      "search" : "",
      "filter_type" : "state",
      "filter_type_value":AppPreference().getString(PreferencesKey.state),
      "user_id":AppPreference().getString(PreferencesKey.userId),
    };
    Api.get.call(context,
        method:
        "user/user-suggestion",
        param: param,
        isLoading: false,
        onResponseSuccess: (Map object) {
          var result = UserSuggestionsModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            userPath = result.path!;
            mySuggestionsStateResult.addAll(result.data!);
            setState(() {});
          } else {
            suggestionsStatePage = suggestionsStatePage > 1 ? suggestionsStatePage--:suggestionsStatePage;
          }
        });
  }
  void _suggestionsCountry() async {
    Map<String, dynamic> param = {
      "page" : suggestionsCountryPage.toString(),
      "search" : "",
      "filter_type" : "country",
      "filter_type_value":AppPreference().getString(PreferencesKey.country),
      "user_id":AppPreference().getString(PreferencesKey.userId),
    };
    Api.get.call(context,
        method:
        "user/user-suggestion",
        param: param,
        isLoading: false,
        onResponseSuccess: (Map object) {
          var result = UserSuggestionsModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            userPath = result.path!;
            mySuggestionsCountryResult.addAll(result.data!);
            setState(() {});
          } else {
            suggestionsCountryPage = suggestionsCountryPage > 1 ? suggestionsCountryPage--:suggestionsCountryPage;
          }
        });
  }
}
