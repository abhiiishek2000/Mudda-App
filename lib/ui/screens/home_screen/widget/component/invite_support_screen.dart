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

class InvitedSupportScreen extends StatefulWidget {
  const InvitedSupportScreen({Key? key}) : super(key: key);

  @override
  State<InvitedSupportScreen> createState() => _InvitedSupportScreenState();
}

class _InvitedSupportScreenState extends State<InvitedSupportScreen> {
  CreateMuddaController? createMuddaController;
  bool? invited = false;
  MuddaNewsController? muddaNewsController;
  ScrollController muddaScrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
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
    super.initState();
  }

  @override
  void dispose() {
    muddaNewsController!.inviteType.value = '';
    super.dispose();
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
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, invited);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 25,
            ),
          ),
          title: Text(
            'Invite Support',
            style: size14_M_bold(textColor: black),
          ),
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
                      method: "user/Invite-suggestion",
                      param: {
                        "page": page.toString(),
                        "search": createMuddaController!.search.value,
                        "mudda_id": muddaNewsController!.muddaPost.value.sId ??
                            Get.arguments['sId'],
                        // "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments,
                        "user_id":
                            AppPreference().getString(PreferencesKey.userId),
                        "support": muddaNewsController!.inviteType.value != ''
                            ? false.toString()
                            : true.toString()
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
                        method: "user/Invite-suggestion",
                        param: {
                          "page": page.toString(),
                          "search": createMuddaController!.search.value,
                          "mudda_id":
                              muddaNewsController!.muddaPost.value.sId ??
                                  Get.arguments['sId'],
                          // "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments,
                          "user_id":
                              AppPreference().getString(PreferencesKey.userId),
                          "support": muddaNewsController!.inviteType.value != ''
                              ? false.toString()
                              : true.toString()
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
                                                    .userList[index].fullname ??
                                                '',
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
                            if (muddaNewsController!.inviteType.value != '')
                              InkWell(
                                onTap: () {
                                  if (createMuddaController!
                                          .userList[index].supportStatus ==
                                      false) {
                                    Api.post.call(
                                      context,
                                      method: "request-to-user/store",
                                      param: {
                                        "user_id": AppPreference()
                                            .getString(PreferencesKey.userId),
                                        "request_to_user_id":
                                            createMuddaController!
                                                .userList[index].sId,
                                        "joining_content_id":
                                            muddaNewsController!
                                                .muddaPost.value.sId,
                                        "requestModalPath": muddaNewsController!
                                            .muddaProfilePath.value,
                                        "requestModal": "RealMudda",
                                        "request_type": muddaNewsController!
                                                    .inviteType.value !=
                                                ''
                                            ? 'invite_notSupport'
                                            : "invite_support",

                                        // "request_type": Get.arguments['opposition'] != ""
                                        //     ? Get.arguments['opposition']
                                        //     : "leader",
                                      },
                                      onResponseSuccess: (object) {
                                        log("Invite -=-=-  $object");

                                        AcceptUserDetail user =
                                            createMuddaController!
                                                .userList[index];
                                        user.supportStatus = true;
                                        int sunIndex = index;
                                        createMuddaController!.userList
                                            .removeAt(index);
                                        createMuddaController!.userList
                                            .insert(sunIndex, user);
                                        // MuddaPost muddaPost = muddaNewsController!.muddaPost.value;
                                        // muddaPost.inviteCount = muddaPost.inviteCount! + 1;
                                        // muddaNewsController!.muddaPost.value =  MuddaPost();
                                        // muddaNewsController!.muddaPost.value = muddaPost;
                                        invited = true;
                                      },
                                    );
                                  } else if (createMuddaController!
                                          .userList[index].supportStatus ==
                                      true) {
                                    Api.delete.call(
                                      context,
                                      method:
                                          "request-to-user/delete/${createMuddaController!.userList[index].invitedId}",
                                      param: {},
                                      onResponseSuccess: (object) {
                                        log("remove invite -=-=- $object");
                                        // MuddaPost muddaPost = muddaNewsController!.muddaPost.value;
                                        // muddaPost.inviteCount = muddaPost.inviteCount! - 1;
                                        // muddaNewsController!.muddaPost.value =  MuddaPost();
                                        // muddaNewsController!.muddaPost.value = muddaPost;
                                        AcceptUserDetail user =
                                            createMuddaController!
                                                .userList[index];
                                        user.supportStatus = false;
                                        int sunIndex = index;
                                        createMuddaController!.userList
                                            .removeAt(index);
                                        createMuddaController!.userList
                                            .insert(sunIndex, user);
                                      },
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    createMuddaController!.userList[index]
                                                .supportStatus !=
                                            true
                                        ? "Invite"
                                        : "Invited",
                                    style: size12_M_normal(
                                        textColor: createMuddaController!
                                                    .userList[index]
                                                    .supportStatus !=
                                                true
                                            ? colorGrey
                                            : buttonBlue),
                                  ),
                                ),
                              )
                            else
                              InkWell(
                                onTap: () {
                                  if (createMuddaController!
                                          .userList[index].supportStatus ==
                                      false) {
                                    Api.post.call(
                                      context,
                                      method: "request-to-user/store",
                                      param: {
                                        "user_id": AppPreference()
                                            .getString(PreferencesKey.userId),
                                        "request_to_user_id":
                                            createMuddaController!
                                                .userList[index].sId,
                                        "joining_content_id":
                                            muddaNewsController!
                                                .muddaPost.value.sId,
                                        "requestModalPath": muddaNewsController!
                                            .muddaProfilePath.value,
                                        "requestModal": "RealMudda",
                                        "request_type": muddaNewsController!
                                                    .inviteType.value !=
                                                ''
                                            ? 'invite_notSupport'
                                            : "invite_support",

                                        // "request_type": Get.arguments['opposition'] != ""
                                        //     ? Get.arguments['opposition']
                                        //     : "leader",
                                      },
                                      onResponseSuccess: (object) {
                                        AcceptUserDetail user =
                                            createMuddaController!
                                                .userList[index];
                                        user.supportStatus = true;
                                        int sunIndex = index;
                                        createMuddaController!.userList
                                            .removeAt(index);
                                        createMuddaController!.userList
                                            .insert(sunIndex, user);
                                      },
                                    );
                                  }
                                  // else if(createMuddaController!
                                  //     .userList[index].supportStatus == true){
                                  //
                                  //   Api.delete.call(
                                  //     context,
                                  //     method: "request-to-user/delete/${createMuddaController!
                                  //         .userList[index].invitedId}",
                                  //     param: {
                                  //     },
                                  //     onResponseSuccess: (object) {
                                  //       AcceptUserDetail user =
                                  //       createMuddaController!.userList[index];
                                  //       user.supportStatus = false;
                                  //       int sunIndex = index;
                                  //       createMuddaController!.userList.removeAt(index);
                                  //       createMuddaController!.userList
                                  //           .insert(sunIndex, user);
                                  //     },
                                  //   );
                                  // }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    createMuddaController!.userList[index]
                                                .supportStatus !=
                                            true
                                        ? "Invite"
                                        : "Invited",
                                    style: size12_M_normal(
                                        textColor: createMuddaController!
                                                    .userList[index]
                                                    .supportStatus !=
                                                true
                                            ? colorGrey
                                            : buttonBlue),
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
        method: "user/Invite-suggestion",
        param: {
          "page": page.toString(),
          "search": createMuddaController!.search.value,
          "mudda_id":
              muddaNewsController!.muddaPost.value.sId ?? Get.arguments['sId'],
          // "mudda_id":muddaNewsController!.muddaPost.value.sId ?? Get.arguments,
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "support": muddaNewsController!.inviteType.value != ''
              ? false.toString()
              : true.toString()
        },
        isLoading: false, onResponseSuccess: (Map object) {
      print(object);
      var result = UserSuggestionsModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        createMuddaController!.profilePath.value = result.path!;
        // createMuddaController!.inviteCount.value = result.inviteCount!;
        createMuddaController!.userList.addAll(result.data!);
      } else {
        page = page > 1 ? page - 1 : page;
      }
    });
  }
}
