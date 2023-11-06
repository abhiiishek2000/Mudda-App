import 'dart:convert';
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

class FollowSearchScreen extends StatelessWidget {
  CreateMuddaController? createMuddaController;

  FollowSearchScreen({Key? key}) : super(key: key);

  bool isFollowed = false;
  ScrollController muddaScrollController = ScrollController();
  int page = 1;

  @override
  Widget build(BuildContext context) {
    page = 1;
    isFollowed = false;
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

    return Scaffold(
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
                    Get.back(result: isFollowed);
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
      body: WillPopScope(
        onWillPop: () async {
          Get.back(result: isFollowed);
          return true;
        },
        child: Padding(
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
                      method: "user/user-suggestion",
                      param: {
                        "page": page.toString(),
                        "search": createMuddaController!.search.value,
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
                        method: "user/user-suggestion",
                        param: {
                          "page": page.toString(),
                          "search": createMuddaController!.search.value,
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
                                          Container(
                                            width: Get.width *0.6,
                                            child: Text(
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
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: size12_M_normal(
                                                  textColor: colorGrey),
                                            ),
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
                            Visibility(
                              visible: AppPreference()
                                      .getBool(PreferencesKey.isGuest) ==
                                  false,
                              child: SizedBox(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                createMuddaController!
                                                            .userList[index]
                                                            .amIFollowing ==
                                                        0
                                                    ? appBackgroundColor
                                                    : blackGray),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                ),
                                                side:
                                                    BorderSide(color: grey)))),
                                    onPressed: () async {
                                      Api.post.call(
                                        context,
                                        method: "request-to-user/store",
                                        param: {
                                          "user_id": AppPreference()
                                              .getString(PreferencesKey.userId),
                                          "request_to_user_id":
                                              createMuddaController!
                                                  .userList[index].sId,
                                          "request_type": "follow",
                                        },
                                        onResponseSuccess: (object) {
                                          print(object);
                                          int index2 = index;
                                          createMuddaController!
                                              .userList[index].amIFollowing = 1;
                                          createMuddaController!.userList
                                              .removeAt(index);
                                          isFollowed = true;
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Follow',
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenUtil().setSp(12),
                                          color: createMuddaController!
                                                      .userList[index]
                                                      .amIFollowing ==
                                                  0
                                              ? grey
                                              : white),
                                    )),
                                height: ScreenUtil().setHeight(30),
                              ),
                            ),
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
        method: "user/user-suggestion",
        param: {
          "page": page.toString(),
          "search": createMuddaController!.search.value,
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
