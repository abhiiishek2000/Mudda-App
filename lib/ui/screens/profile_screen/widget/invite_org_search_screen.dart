import 'dart:convert';
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
import '../../../../model/invited_org_model.dart';
import '../../edit_profile/controller/user_profile_update_controller.dart';
import 'invited_details_org_profile.dart';

class InvitedOrgSearchScreen extends StatelessWidget {
  CreateMuddaController? createMuddaController;

  InvitedOrgSearchScreen({Key? key}) : super(key: key);
  ScrollController muddaScrollController = ScrollController();
  UserProfileUpdateController? userProfileUpdateController;
  MuddaNewsController? muddaNewsController;
  int page = 1;
  String orgID = AppPreference()
      .getString(PreferencesKey.orgUserId);

  @override
  Widget build(BuildContext context) {
    userProfileUpdateController = Get.find<UserProfileUpdateController>();
    muddaNewsController = Get.find<MuddaNewsController>();
    page = 1;
    if (Get.parameters['id'] != null) {
      orgID = jsonDecode(Get.parameters['id']!);
    }
    createMuddaController = Get.put(CreateMuddaController(), tag: "org");
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        _getUsers(context);
      }
    });
    createMuddaController!.userList.clear();
    _getUsers(context);
    getData(context);

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
                    Get.back();
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
        child: Obx(() => Column(children: [
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
                        method: "organization-member/invite-suggestion",
                        param: {
                          "page": page.toString(),
                          "search": createMuddaController!.search.value,
                          "organization_id": orgID,
                        },
                        isLoading: false, onResponseSuccess: (Map object) {
                      print(object);
                      var result = UserSuggestionsModel.fromJson(object);
                      if (result.data!.isNotEmpty) {
                        createMuddaController!.profilePath.value = result.path!;
                        createMuddaController!.userList.clear();
                        createMuddaController!.userList.addAll(result.data!);
                      }
                    });
                  },
                  onChange: (text) {
                    if (text.isEmpty) {
                      createMuddaController!.search.value = "";
                      createMuddaController!.userList.clear();
                      page = 1;
                      Api.get.call(context,
                          method: "organization-member/invite-suggestion",
                          param: {
                            "page": page.toString(),
                            "search": createMuddaController!.search.value,
                            "organization_id": orgID,
                          },
                          isLoading: false, onResponseSuccess: (Map object) {
                        print(object);
                        var result = UserSuggestionsModel.fromJson(object);
                        if (result.data!.isNotEmpty) {
                          createMuddaController!.profilePath.value =
                              result.path!;
                          createMuddaController!.userList.clear();
                          createMuddaController!.userList.addAll(result.data!);
                        }
                      });
                    }
                  }),
              getSizedBox(h: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        createMuddaController!.isInvited.value = false;
                      },
                      child: Obx(() => Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: createMuddaController!
                                        .isInvited.value !=
                                        true
                                        ? black
                                        : white,
                                    width: 2))),
                        child: Obx(() => Text(
                          "Suggestions",
                          style: createMuddaController!.isInvited.value ? size14_M_normal(
                              textColor: colorGrey):
                          size16_M_medium(
                              textColor: black),
                        )),
                      )),
                    ),

                InkWell(
                  onTap: () {
                    createMuddaController!.isInvited.value =
                        !createMuddaController!.isInvited.value;
                  },
                  child: Obx(() => Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: createMuddaController!
                                                .isInvited.value ==
                                            true
                                        ? black
                                        : white,
                                    width: 2))),
                        child: Obx(() => Text(
                          "Invited (${NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol: '',
                          ).format(createMuddaController!.invitedCount.value)})",
                          style: !createMuddaController!.isInvited.value ? size14_M_normal(
                              textColor: colorGrey): size16_M_medium(
                              textColor:  black),
                        )),
                      )),
                ),
              ]),
              getSizedBox(h: 20),
              if (createMuddaController!.isInvited.value)
                InvitedDetailsOrg(
                    orgId: orgID)
              else
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
                                AppPreference()
                                    .getString(PreferencesKey.userId)) {
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
                                          createMuddaController!.userList[index]
                                                      .profile !=
                                                  null
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      "${createMuddaController!.profilePath.value}${createMuddaController!.userList[index].profile}",
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width:
                                                        ScreenUtil().setSp(48),
                                                    height:
                                                        ScreenUtil().setSp(48),
                                                    decoration: BoxDecoration(
                                                      color: colorWhite,
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
                                                  placeholder: (context, url) =>
                                                      CircleAvatar(
                                                    backgroundColor: lightGray,
                                                    radius:
                                                        ScreenUtil().setSp(24),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          CircleAvatar(
                                                    backgroundColor: lightGray,
                                                    radius:
                                                        ScreenUtil().setSp(24),
                                                  ),
                                                )
                                              : Container(
                                                  height:
                                                      ScreenUtil().setSp(48),
                                                  width: ScreenUtil().setSp(48),
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
                                                                    .userList[
                                                                        index]
                                                                    .fullname!
                                                                    .isNotEmpty
                                                            ? createMuddaController!
                                                                .userList[index]
                                                                .fullname![0]
                                                                .toUpperCase()
                                                            : "",
                                                        style: GoogleFonts
                                                            .nunitoSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            20),
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
                                    if (createMuddaController!
                                            .userList[index].amIFollowing ==
                                        0) {
                                      AcceptUserDetail user =
                                          createMuddaController!
                                              .userList[index];
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
                                          "user_id": orgID,
                                          "request_to_user_id":
                                              createMuddaController!
                                                  .userList[index].sId,
                                          "requestModalPath":
                                              createMuddaController!
                                                  .profilePath.value,
                                          "requestModal": "Users",
                                          "request_type": "invite",
                                        },
                                        onResponseSuccess: (object) {
                                          AcceptUserDetail user = userModel;

                                          user.invitedStatus = true;

                                          int sunIndex = index;
                                          createMuddaController!.userList
                                              .removeAt(index);
                                          createMuddaController!.userList
                                              .insert(sunIndex, user);

                                          getData(context);
                                        },
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      createMuddaController!.userList[index]
                                                  .invitedStatus !=
                                              true
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
            ])),
      ),
    );
  }

  getData(BuildContext context) async {
    Api.get.call(context,
        method: "user/invited-in-org",
        param: {
          "_id": orgID,
          "user_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
      print(object);
      var result = InvitedOrgModel.fromJson(object as Map<String, dynamic>);
      if (result.data!.isNotEmpty) {
        createMuddaController!.userListInviteOrg.clear();
        createMuddaController!.profilePath.value = result.path!;
        createMuddaController!.invitedCount.value = result.invitedCount!;
        createMuddaController!.userListInviteOrg.addAll(result.data!);
      }
    });
  }

  _getUsers(BuildContext context) async {
    Api.get.call(context,
        method: "organization-member/invite-suggestion",
        param: {
          "page": page.toString(),
          "search": createMuddaController!.search.value,
          "organization_id": orgID,
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
