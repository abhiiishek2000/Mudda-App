import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserSuggestionsModel.dart';
import 'package:mudda/model/invited_org_model.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/leader_board/controller/LeaderBoardApprovalController.dart';
import 'package:mudda/ui/screens/raising_mudda/controller/CreateMuddaController.dart';

import '../../../../core/utils/color.dart';
import '../../../../core/utils/size_config.dart';

class InvitedDetailsOrg extends StatefulWidget {
  String? orgId;

  InvitedDetailsOrg({Key? key, this.orgId}) : super(key: key);

  @override
  State<InvitedDetailsOrg> createState() => _InvitedDetailsOrgState();
}

class _InvitedDetailsOrgState extends State<InvitedDetailsOrg> {
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  ScrollController invitedScrollController = ScrollController();
  LeaderBoardApprovalController leaderBoardApprovalController =
      Get.put(LeaderBoardApprovalController());

  dynamic inviteOrgData;
  ScrollController inviteOrgController = ScrollController();
  CreateMuddaController? createMuddaController;

  @override
  void initState() {
    super.initState();
    createMuddaController = Get.put(CreateMuddaController(), tag: "org");
    getData(context);
  }

  // getData() {
  //   log("");
  //   Api.get.call(context,
  //       method: "user/invited-in-org",
  //       param: {
  //         "_id": widget.orgId,
  //         "user_id": AppPreference().getString(PreferencesKey.userId),
  //       },
  //       isLoading: false, onResponseSuccess: (Map object) {
  //     log("-=-=- $object");
  //     // inviteOrgData = object['data'];
  //     if (object['data'] != null) {
  //       inviteOrgData = object['data'];
  //     }
  //   });
  // }

  getData(BuildContext context) async {
    Api.get.call(context,
        method: "user/invited-in-org",
        param: {
          "_id": widget.orgId,
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
        method: "user/mudda-suggestion",
        param: {
          "page": "1",
          "search": createMuddaController!.search.value,
          "mudda_id":muddaNewsController.muddaPost.value.sId ?? Get.arguments['sId'],
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
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Obx(() => createMuddaController!.userListInviteOrg.isEmpty
            ? Center(
                child: Text(
                "No Invite",
                style: size14_M_bold(textColor: colorGrey),
              ))
            : ListView.builder(
                shrinkWrap: true,
                controller: invitedScrollController,
                itemCount: createMuddaController!.userListInviteOrg.length,
                itemBuilder: (followersContext, index) {
                  InvitedOrg userModel =
                      createMuddaController!.userListInviteOrg[index];
                  return InkWell(
                    onTap: () {
                      if (userModel.user!.id ==
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
                                                .userListInviteOrg[index]
                                                .user!
                                                .profile !=
                                            null
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                "${createMuddaController!.profilePath.value}${createMuddaController!.userListInviteOrg[index].user!.profile}",
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: ScreenUtil().setSp(48),
                                              height: ScreenUtil().setSp(48),
                                              decoration: BoxDecoration(
                                                color: colorWhite,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(ScreenUtil()
                                                        .setSp(
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
                                              radius: ScreenUtil().setSp(24),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    CircleAvatar(
                                              backgroundColor: lightGray,
                                              radius: ScreenUtil().setSp(24),
                                            ),
                                          )
                                        : Container(
                                            height: ScreenUtil().setSp(48),
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
                                                                  .userListInviteOrg[
                                                                      index]
                                                                  .user!
                                                                  .fullname !=
                                                              null &&
                                                          createMuddaController!
                                                              .userListInviteOrg[
                                                                  index]
                                                              .user!
                                                              .fullname!
                                                              .isNotEmpty
                                                      ? createMuddaController!
                                                          .userListInviteOrg[
                                                              index]
                                                          .user!
                                                          .fullname![0]
                                                          .toUpperCase()
                                                      : "",
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: ScreenUtil()
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
                                                  .userListInviteOrg[index]
                                                  .user!
                                                  .fullname ??
                                              "",
                                          style: size12_M_bold(
                                              textColor: Colors.black),
                                        ),
                                        getSizedBox(h: 2),
                                        Text(
                                          createMuddaController!
                                                      .userListInviteOrg[index]
                                                      .user!
                                                      .profession !=
                                                  null
                                              ? "${createMuddaController!.userListInviteOrg[index].user!.profession != null ? createMuddaController!.userListInviteOrg[index].user!.profession! : ""} ${createMuddaController!.userListInviteOrg[index].user!.state != null ? "/ ${createMuddaController!.userListInviteOrg[index].user!.state != null ? createMuddaController!.userListInviteOrg[index].user!.state! : ""}, ${createMuddaController!.userListInviteOrg[index].user!.country != null ? createMuddaController!.userListInviteOrg[index].user!.country! : ""}" : ""}"
                                              : createMuddaController!
                                                          .userListInviteOrg[
                                                              index]
                                                          .user!
                                                          .state !=
                                                      null
                                                  ? "${createMuddaController!.userListInviteOrg[index].user!.state != null ? createMuddaController!.userListInviteOrg[index].user!.state! : ""}, ${createMuddaController!.userListInviteOrg[index].user!.country != null ? createMuddaController!.userListInviteOrg[index].user!.country! : ""}"
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
                              Api.delete.call(
                                  context,
                                  method:
                                  "request-to-user/delete/${userModel.id}",
                                  param: {},
                                  onResponseSuccess:
                                      (object) {
                                    print(
                                        "Abhishek $object");
                                    // MuddaPost muddaPost =
                                    //     muddaNewsController
                                    //         .muddaPost
                                    //         .value;
                                    // muddaPost.inviteCount =
                                    //     muddaPost
                                    //         .inviteCount! -
                                    //         1;
                                    // muddaNewsController
                                    //     .muddaPost
                                    //     .value =
                                    //     MuddaPost();
                                    // muddaNewsController
                                    //     .muddaPost
                                    //     .value = muddaPost;
                                    createMuddaController!.inviteCount.value = createMuddaController!.inviteCount.value -1;
                                    createMuddaController!.userListInviteOrg
                                        .removeAt(index);
                                    getData(context);
                                    _getUsers(context);
                                  },
                                );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Cancel",
                                style: size12_M_normal(textColor: colorGrey),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })),
      ),
    );
  }
}
