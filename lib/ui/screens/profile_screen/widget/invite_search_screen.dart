/*
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
import 'package:mudda/model/UserSuggestionsModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/raising_mudda/controller/CreateMuddaController.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';

class InvitedSearchScreen extends StatefulWidget {
  InvitedSearchScreen({Key? key}) : super(key: key);

  @override
  State<InvitedSearchScreen> createState() => _InvitedSearchScreenState();
}

class _InvitedSearchScreenState extends State<InvitedSearchScreen> {
  CreateMuddaController? createMuddaController;

  bool? invited = false;

  // MuddaNewsController? muddaNewsController = Get.find<MuddaNewsController>();
  MuddaNewsController? muddaNewsController;

  ScrollController muddaScrollController = ScrollController();

  int page = 1;
  String? muddaOpposition;
  String? muddaCreator;

  @override
  void initState() {
    super.initState();
    muddaOpposition = Get.arguments['opposition'];
    muddaCreator = Get.arguments['creator'];
    log('-=- mudda details -=- ${muddaOpposition}');
    log('-=- mudda details -=- ${muddaCreator}');

    page = 1;
    createMuddaController = Get.find<CreateMuddaController>();
    muddaNewsController = Get.find<MuddaNewsController>();
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        _getUsers(context);
      }
    });
    createMuddaController!.userList.clear();
    _getUsers(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, invited);
        return false;
      },
      child: Scaffold(
        backgroundColor: colorAppBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, invited);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            getSizedBox(h: 20),
            AppTextField(
                hintText: "Search",
                suffixIcon: Image.asset(AppIcons.searchIcon, scale: 2),
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (text) {
                  createMuddaController!.search.value = text!;
                  createMuddaController!.userList.clear();
                  page = 1;
                  Api.get.call(context,
                      method: "user/mudda-suggestion",
                      param: {
                        "page": page.toString(),
                        "search": createMuddaController!.search.value,
                        "mudda_id": muddaNewsController!.muddaPost.value.sId ??
                            Get.arguments['sId'],
                        // "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments,
                        "user_id":
                            AppPreference().getString(PreferencesKey.userId),
                      },
                      isLoading: false, onResponseSuccess: (Map object) {
                    print(object);
                    var result = UserSuggestionsModel.fromJson(object);
                    if (result.data!.isNotEmpty) {
                      createMuddaController!.profilePath.value = result.path!;
                      createMuddaController!.userList.clear();
                      createMuddaController!.userList.addAll(result.data!);
                    } else {
                      page = page > 1 ? page - 1 : page;
                    }
                  });
                },
                onChange: (text) {
                  if (text.isEmpty) {
                    createMuddaController!.search.value = "";
                    createMuddaController!.userList.clear();
                    page = 1;
                    Api.get.call(context,
                        method: "user/mudda-suggestion",
                        param: {
                          "page": page.toString(),
                          "search": createMuddaController!.search.value,
                          "mudda_id":
                              muddaNewsController!.muddaPost.value.sId ?? Get.arguments['sId'],
                          // "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments,
                          "user_id":
                              AppPreference().getString(PreferencesKey.userId),
                        },
                        isLoading: false, onResponseSuccess: (Map object) {
                      print(object);
                      var result = UserSuggestionsModel.fromJson(object);
                      if (result.data!.isNotEmpty) {
                        createMuddaController!.profilePath.value = result.path!;
                        createMuddaController!.userList.clear();
                        createMuddaController!.userList.addAll(result.data!);
                      } else {
                        page = page > 1 ? page - 1 : page;
                      }
                    });
                  }
                }),
            getSizedBox(h: 20),
            Row(
              children: [
                Text(
                  "Profiles",
                  style: size12_M_normal(textColor: colorGrey),
                ),
              ],
            ),
            getSizedBox(h: 20),
            Expanded(
              child: Obx(() => ListView.builder(
                  shrinkWrap: true,
                  controller: muddaScrollController,
                  itemCount: createMuddaController!.userList.length,
                  itemBuilder: (followersContext, index) {
                    AcceptUserDetail userModel =
                        createMuddaController!.userList[index];
                    return InkWell(
                      onTap: () {
                        if (userModel.sId ==
                            AppPreference().getString(PreferencesKey.userId)) {
                          Get.toNamed(RouteConstants.profileScreen,
                              arguments: userModel);
                        } else {
                          Map<String, String>? parameters = {
                            "userDetail": jsonEncode(userModel)
                          };
                          Get.toNamed(RouteConstants.otherUserProfileScreen,
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
                                      createMuddaController!
                                                  .userList[index].profile !=
                                              null
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  "${createMuddaController!.profilePath.value}${createMuddaController!.userList[index].profile}",
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: ScreenUtil().setSp(40),
                                                height: ScreenUtil().setSp(40),
                                                decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          ScreenUtil().setSp(
                                                              20)) //                 <--- border radius here
                                                      ),
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                backgroundColor: lightGray,
                                                radius: ScreenUtil().setSp(20),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
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
                                                    createMuddaController!
                                                                    .userList[
                                                                        index]
                                                                    .fullname !=
                                                                null &&
                                                            createMuddaController!
                                                                .userList[index]
                                                                .fullname!
                                                                .isNotEmpty
                                                        ? createMuddaController!
                                                            .userList[index]
                                                            .fullname![0]
                                                            .toUpperCase()
                                                        : "",
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(20),
                                                            color: black)),
                                              ),
                                            ),
                                      getSizedBox(w: 5),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            createMuddaController!
                                                .userList[index].fullname!,
                                            style: size12_M_bold(
                                                textColor: Colors.black),
                                          ),
                                          getSizedBox(h: 2),
                                          Text(
                                            createMuddaController!
                                                        .userList[index]
                                                        .profession !=
                                                    null
                                                ? "${createMuddaController!.userList[index].profession != null ? createMuddaController!.userList[index].profession! : ""} ${createMuddaController!.userList[index].state != null ? "/ ${createMuddaController!.userList[index].state != null ? createMuddaController!.userList[index].state! : ""}, ${createMuddaController!.userList[index].country != null ? createMuddaController!.userList[index].country! : ""}" : ""}"
                                                : createMuddaController!
                                                            .userList[index]
                                                            .state !=
                                                        null
                                                    ? "${createMuddaController!.userList[index].state != null ? createMuddaController!.userList[index].state! : ""}, ${createMuddaController!.userList[index].country != null ? createMuddaController!.userList[index].country! : ""}"
                                                    : "",
                                            style: size12_M_normal(
                                                textColor: colorGrey),
                                          )
                                        ],
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
                                log('-=-= userId -=- ${AppPreference().getString(PreferencesKey.userId)}');
                                log('-=-= request to userId -=- ${createMuddaController!.userList[index].sId}');
                                if (createMuddaController!
                                        .userList[index].amIFollowing ==
                                    0) {
                                  AcceptUserDetail user =
                                      createMuddaController!.userList[index];
                                  user.amIFollowing = 1;
                                  int sunIndex = index;
                                  createMuddaController!.userList
                                      .removeAt(index);
                                  createMuddaController!.userList
                                      .insert(sunIndex, user);
                                  Api.post.call(
                                    context,
                                    method: "request-to-user/store",
                                    param: {
                                      "user_id": AppPreference().getString(PreferencesKey.userId),
                                      "request_to_user_id": createMuddaController!.userList[index].sId,
                                      // "joining_content_id": muddaNewsController!.muddaPost.value.sId,
                                      "joining_content_id": muddaNewsController!.muddaPost.value.sId ?? Get.arguments['sId'],
                                      "requestModalPath": muddaNewsController!.muddaProfilePath.value,
                                      "requestModal": "RealMudda",
                                      // "request_type": "initial_leader",
                                      "request_type": Get.arguments['opposition'] != ""
                                          ? Get.arguments['opposition']
                                          : "leader",
                                    },
                                    onResponseSuccess: (object) {
                                      log("Invite -=-=-  $object");
                                      createMuddaController!.userList[index]
                                          .inviteId = object['data']['_id'];
                                      MuddaPost muddaPost =
                                          muddaNewsController!.muddaPost.value;
                                      muddaPost.inviteCount =
                                          muddaPost.inviteCount! + 1;
                                      muddaNewsController!.muddaPost.value =
                                          MuddaPost();
                                      muddaNewsController!.muddaPost.value =
                                          muddaPost;
                                      invited = true;
                                    },
                                  );
                                } else if (createMuddaController!
                                        .userList[index].inviteId !=
                                    null) {
                                  AcceptUserDetail user =
                                      createMuddaController!.userList[index];
                                  user.amIFollowing = 0;
                                  int sunIndex = index;
                                  createMuddaController!.userList
                                      .removeAt(index);
                                  createMuddaController!.userList
                                      .insert(sunIndex, user);
                                  Api.delete.call(
                                    context,
                                    method:
                                        "request-to-user/delete/${createMuddaController!.userList[index].inviteId}",
                                    param: {},
                                    onResponseSuccess: (object) {
                                      log("remove invite -=-=- $object");
                                      MuddaPost muddaPost =
                                          muddaNewsController!.muddaPost.value;
                                      muddaPost.inviteCount =
                                          muddaPost.inviteCount! - 1;
                                      muddaNewsController!.muddaPost.value =
                                          MuddaPost();
                                      muddaNewsController!.muddaPost.value =
                                          muddaPost;
                                      invited = true;
                                    },
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  createMuddaController!
                                              .userList[index].amIFollowing ==
                                          0
                                      ? "Invite"
                                      : "Invited",
                                  style: size12_M_normal(
                                      textColor: createMuddaController!
                                                  .userList[index]
                                                  .amIFollowing ==
                                              0
                                          ? colorGrey
                                          : colorA0A0A0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })),
            ),
          ]),
        ),
      ),
    );
  }

  _getUsers(BuildContext context) async {
    Api.get.call(context,
        method: "user/mudda-suggestion",
        param: {
          "page": page.toString(),
          "search": createMuddaController!.search.value,
          "mudda_id":
              muddaNewsController!.muddaPost.value.sId ?? Get.arguments['sId'],
          // "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments,
          "user_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
      print(object);
      var result = UserSuggestionsModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        createMuddaController!.profilePath.value = result.path!;
        createMuddaController!.userList.addAll(result.data!);
      } else {
        page = page > 1 ? page - 1 : page;
      }
    });
  }
}
*/
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
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserSuggestionsModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/raising_mudda/controller/CreateMuddaController.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';

class InvitedSearchScreen extends StatefulWidget {

  InvitedSearchScreen({Key? key}) : super(key: key);

  @override
  State<InvitedSearchScreen> createState() => _InvitedSearchScreenState();
}

class _InvitedSearchScreenState extends State<InvitedSearchScreen> {
  CreateMuddaController? createMuddaController;

  bool? invited = false;

  MuddaNewsController? muddaNewsController;

  ScrollController muddaScrollController = ScrollController();

  int page = 1;




  @override
  void dispose() {
    muddaNewsController!.inviteType.value ='';
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    page = 1;
    muddaNewsController = Get.find<MuddaNewsController>();
    createMuddaController = Get.find<CreateMuddaController>();
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        _getUsers(context);
      }
    });
    createMuddaController!.userList.clear();
    _getUsers(context);
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context,invited);
        return false;
      },
      child: Scaffold(
        backgroundColor: colorAppBackground,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context,invited);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 25,
            ),
          ),
          title: Obx(()=>Text('Invited (${NumberFormat.compactCurrency(
            decimalDigits: 0,
            symbol:
            '', // if you want to add currency symbol then pass that in this else leave it empty.
          ).format(createMuddaController!.inviteCount.value)})',style: size14_M_bold(textColor: black),),),
          centerTitle: true,
          backgroundColor: colorAppBackground,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            getSizedBox(h: 20),
            AppTextField(
                hintText: "Search",
                suffixIcon: Image.asset(AppIcons.searchIcon, scale: 2),
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (text) {
                  createMuddaController!.search.value = text!;
                  createMuddaController!.userList.clear();
                  page = 1;
                  Api.get.call(context,
                      method: "user/mudda-suggestion",
                      param: {
                        "page": page.toString(),
                        "search": createMuddaController!.search.value,
                        "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments['sId'],
                        // "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments,
                        "user_id":
                        AppPreference().getString(PreferencesKey.userId),
                      },
                      isLoading: false, onResponseSuccess: (Map object) {
                        print(object);
                        var result = UserSuggestionsModel.fromJson(object);
                        if (result.data!.isNotEmpty) {
                          createMuddaController!.profilePath.value = result.path!;
                          createMuddaController!.userList.clear();
                          createMuddaController!.userList.addAll(result.data!);
                        } else {
                          page = page > 1 ? page-1 : page;
                        }
                      });
                },onChange: (text){
              if(text.isEmpty){
                createMuddaController!.search.value = "";
                createMuddaController!.userList.clear();
                page = 1;
                Api.get.call(context,
                    method: "user/mudda-suggestion",
                    param: {
                      "page": page.toString(),
                      "search": createMuddaController!.search.value,
                      "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments['sId'],
                      // "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments,
                      "user_id":
                      AppPreference().getString(PreferencesKey.userId),
                    },
                    isLoading: false, onResponseSuccess: (Map object) {
                      print(object);
                      var result = UserSuggestionsModel.fromJson(object);
                      if (result.data!.isNotEmpty) {
                        createMuddaController!.profilePath.value = result.path!;
                        createMuddaController!.userList.clear();
                        createMuddaController!.userList.addAll(result.data!);
                      } else {
                        page = page > 1 ? page-1 : page;
                      }
                    });
              }
            }),
            getSizedBox(h: 20),
            Row(
              children: [
                Text(
                  "Profiles",
                  style: size12_M_normal(textColor: colorGrey),
                ),
              ],
            ),
            getSizedBox(h: 20),
            Expanded(
              child: Obx(() => ListView.builder(
                  shrinkWrap: true,
                  controller: muddaScrollController,
                  itemCount: createMuddaController!.userList.length,
                  itemBuilder: (followersContext, index) {
                    AcceptUserDetail userModel = createMuddaController!.userList[index];
                    return InkWell(
                      onTap: () {
                        if(userModel.sId == AppPreference().getString(PreferencesKey.userId)){
                          Get.toNamed(
                              RouteConstants.profileScreen,arguments: userModel);
                        }else {
                          Map<String, String>? parameters = {
                            "userDetail":jsonEncode(userModel)
                          };
                          Get.toNamed(RouteConstants.otherUserProfileScreen,parameters: parameters);
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
                                      createMuddaController!.userList[index].profile != null ? CachedNetworkImage(
                                        imageUrl: "${createMuddaController!.profilePath.value}${createMuddaController!.userList[index].profile}",
                                        imageBuilder: (context, imageProvider) => Container(
                                          width: ScreenUtil().setSp(40),
                                          height: ScreenUtil().setSp(40),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
                                            ),
                                            image: DecorationImage(
                                                image: imageProvider, fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) => CircleAvatar(
                                          backgroundColor: lightGray,
                                          radius: ScreenUtil().setSp(20),
                                        ),
                                        errorWidget: (context, url, error) => CircleAvatar(
                                          backgroundColor: lightGray,
                                          radius: ScreenUtil().setSp(20),
                                        ),
                                      ):Container(
                                        height: ScreenUtil().setSp(40),
                                        width: ScreenUtil().setSp(40),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: darkGray,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(createMuddaController!.userList[index].fullname != null && createMuddaController!.userList[index].fullname!.isNotEmpty ?createMuddaController!.userList[index].fullname![0].toUpperCase():"",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: ScreenUtil().setSp(20),
                                                  color: black)),
                                        ),
                                      ),
                                      getSizedBox(w: 5),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            createMuddaController!
                                                .userList[index].fullname ?? '',
                                            style: size12_M_bold(
                                                textColor: Colors.black),
                                          ),
                                          getSizedBox(h: 2),
                                          Text(
                                            createMuddaController!.userList[index]
                                                .profession !=
                                                null
                                                ? "${createMuddaController!.userList[index].profession != null ? createMuddaController!.userList[index].profession! : ""} ${createMuddaController!.userList[index].state != null ? "/ ${createMuddaController!.userList[index].state != null ? createMuddaController!.userList[index].state! : ""}, ${createMuddaController!.userList[index].country != null ? createMuddaController!.userList[index].country! : ""}" : ""}"
                                                : createMuddaController!
                                                .userList[index]
                                                .state !=
                                                null
                                                ? "${createMuddaController!.userList[index].state != null ? createMuddaController!.userList[index].state! : ""}, ${createMuddaController!.userList[index].country != null ? createMuddaController!.userList[index].country! : ""}"
                                                : "",
                                            style: size12_M_normal(
                                                textColor: colorGrey),
                                          )
                                        ],
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
                                if (createMuddaController!.userList[index].invitedStatus == false) {

                                  Api.post.call(
                                    context,
                                    method: "request-to-user/store",
                                    param: {
                                      "user_id": AppPreference()
                                          .getString(PreferencesKey.userId),
                                      "request_to_user_id": createMuddaController!
                                          .userList[index].sId,
                                      "joining_content_id":
                                      muddaNewsController!.muddaPost.value.sId,
                                      "requestModalPath": muddaNewsController!
                                          .muddaProfilePath.value,
                                      "requestModal": "RealMudda",
                                      "request_type": muddaNewsController!.inviteType.value != ''?'opposition_leader': "initial_leader",
                                      // "request_type": Get.arguments['opposition'] != ""
                                      //     ? Get.arguments['opposition']
                                      //     : "leader",
                                    },
                                    isLoading: false,
                                    onResponseSuccess: (object) {
                                      log("Invite -=-=-  $object");
                                      createMuddaController!.inviteCount.value =  createMuddaController!.inviteCount.value + 1;
                                      AcceptUserDetail user =
                                      createMuddaController!.userList[index];
                                      user.invitedStatus = true;
                                      int sunIndex = index;
                                      createMuddaController!.userList.removeAt(index);
                                      createMuddaController!.userList
                                          .insert(sunIndex, user);
                                      // MuddaPost muddaPost = muddaNewsController!.muddaPost.value;
                                      // muddaPost.inviteCount = muddaPost.inviteCount! + 1;
                                      // muddaNewsController!.muddaPost.value =  MuddaPost();
                                      // muddaNewsController!.muddaPost.value = muddaPost;
                                      invited = true;
                                    },
                                  );
                                }else if(createMuddaController!
                                    .userList[index].invitedStatus == true){
                                  AcceptUserDetail user =
                                  createMuddaController!.userList[index];
                                  user.invitedStatus = false;
                                  int sunIndex = index;
                                  createMuddaController!.userList.removeAt(index);
                                  createMuddaController!.userList
                                      .insert(sunIndex, user);
                                  Api.delete.call(
                                    context,
                                    method: "request-to-user/delete/${createMuddaController!
                                        .userList[index].invitedId}",
                                    param: {
                                    },
                                    onResponseSuccess: (object) {
                                      log("remove invite -=-=- $object");
                                      // MuddaPost muddaPost = muddaNewsController!.muddaPost.value;
                                      // muddaPost.inviteCount = muddaPost.inviteCount! - 1;
                                      // muddaNewsController!.muddaPost.value =  MuddaPost();
                                      // muddaNewsController!.muddaPost.value = muddaPost;

                                      invited = true;
                                    },
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  createMuddaController!.userList[index].invitedStatus !=true ? "Invite":"Invited",
                                  style: size12_M_normal(textColor:  createMuddaController!.userList[index].invitedStatus !=true  ? colorGrey:buttonBlue),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })),
            ),
          ]),
        ),
      ),
    );

  }

  _getUsers(BuildContext context) async {
    Api.get.call(context,
        method: "user/mudda-suggestion",
        param: {
          "page": page.toString(),
          "search": createMuddaController!.search.value,
          "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments['sId'],
          // "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments,
          "user_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
          print(object);
          var result = UserSuggestionsModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            createMuddaController!.profilePath.value = result.path!;
            createMuddaController!.inviteCount.value = result.inviteCount!;
            createMuddaController!.userList.addAll(result.data!);
          } else {
            page = page > 1 ? page-1 : page;
          }
        });
  }
}