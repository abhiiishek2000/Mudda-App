import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:mudda/model/UserJoinLeadersModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/leader_board/controller/LeaderBoardApprovalController.dart';
import 'package:mudda/ui/screens/profile_screen/widget/invite_bottom_sheet.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';

class NewRequestScreen extends GetView {
  NewRequestScreen({Key? key}) : super(key: key);
  bool isJoinLeaderShip = true;
  MuddaNewsController? muddaNewsController;
  LeaderBoardApprovalController leaderBoardApprovalController = Get.put(LeaderBoardApprovalController());
  ScrollController requestScrollController = ScrollController();
  int requestPage = 1;
  String orgID = AppPreference().getString(PreferencesKey.orgUserId);

  @override
  Widget build(BuildContext context) {
    leaderBoardApprovalController.requestsList.clear();
    callRequests(context);
    if (Get.parameters['id'] != null) {
      orgID = jsonDecode(Get.parameters['id']!);
    }
    requestScrollController.addListener(() {
      if (requestScrollController.position.maxScrollExtent ==
          requestScrollController.position.pixels) {
        requestPage = requestPage++;
        callRequests(context);
      }
    });
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Join Requests",
                      style: size18_M_bold(textColor: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body:Obx(
        ()=> RefreshIndicator(
          onRefresh: () {
            leaderBoardApprovalController.requestsList.clear();
            requestPage = 1;
            return callRequests(context);
          },
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: leaderBoardApprovalController.requestsList.length,
              controller: requestScrollController,
              padding: EdgeInsets.all(ScreenUtil().setSp(15)),
              itemBuilder: (followersContext, index) {
                JoinLeader joinLeader = leaderBoardApprovalController.requestsList.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (joinLeader.user!.sId ==
                              AppPreference().getString(PreferencesKey.userId) || joinLeader.user!.sId ==
                              AppPreference().getString(PreferencesKey.orgUserId)) {
                            Get.toNamed(RouteConstants.profileScreen,
                                arguments: joinLeader.user!);
                          } else if (joinLeader.user!.userType ==
                              "user") {
                            Map<String, String>? parameters = {
                              "userDetail":
                              jsonEncode(joinLeader.user!)
                            };
                            Get.toNamed(RouteConstants.otherUserProfileScreen,
                                parameters: parameters);
                          } else {
                            Map<String, String>? parameters = {
                              "userDetail":
                              jsonEncode(joinLeader.user!)
                            };
                            Get.toNamed(RouteConstants.otherOrgProfileScreen,
                                parameters: parameters);
                          }
                        },
                        child: Row(
                          children: [
                            joinLeader.user!.profile != null ?CachedNetworkImage(
                              imageUrl: "${leaderBoardApprovalController.profilePath.value}${joinLeader.user!.profile}",
                              imageBuilder: (context, imageProvider) => Container(
                                width: ScreenUtil().setSp(48),
                                height: ScreenUtil().setSp(48),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ScreenUtil().setSp(24)) //                 <--- border radius here
                                  ),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => CircleAvatar(
                                backgroundColor: lightGray,
                                radius: ScreenUtil().setSp(24),
                              ),
                              errorWidget: (context, url, error) => CircleAvatar(
                                backgroundColor: lightGray,
                                radius: ScreenUtil().setSp(24),
                              ),
                            ):Container(
                              height: ScreenUtil().setSp(48),
                              width: ScreenUtil().setSp(48),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: darkGray,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(joinLeader.user!.fullname![0].toUpperCase(),
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(20),
                                        color: black)),
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
                                  Text(
                                    "${joinLeader.user!.fullname}, ${joinLeader.user!.country}",
                                    style: size12_M_bold(
                                        textColor: Colors.black),
                                  ),
                                  getSizedBox(h: 2),
                                  Text.rich(TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text:
                                        "${NumberFormat
                                            .compactCurrency(
                                          decimalDigits: 0,
                                          symbol:
                                          '', // if you want to add currency symbol then pass that in this else leave it empty.
                                        ).format(0)} Followers, ",
                                        style: size12_M_bold(
                                            textColor: blackGray)),
                                    TextSpan(
                                        text: "${joinLeader.user!.city}, ${joinLeader.user!.state}",
                                        style: size12_M_regular(
                                            textColor: blackGray)),
                                  ])),
                                ],
                              ),
                            ),
                            getSizedBox(w: 12),
                            InkWell(onTap:(){
                              Api.delete.call(
                                context,
                                method: "request-to-user/delete/${joinLeader.sId}",
                                param: {
                                },
                                onResponseSuccess: (object) {
                                  print("Abhishek $object");
                                  leaderBoardApprovalController.requestsList.removeAt(index);
                                },
                              );
                            },child: SvgPicture.asset("assets/svg/cancel.svg")),
                            getSizedBox(w: 25),
                            InkWell(onTap:(){
                              Api.post.call(
                                context,
                                method: "request-to-user/update",
                                param: {
                                  "_id":joinLeader.sId
                                },
                                onResponseSuccess: (object) {
                                  print("Abhishek $object");
                                  leaderBoardApprovalController.requestsList.removeAt(index);
                                },
                              );
                            },child: SvgPicture.asset("assets/svg/approve.svg")),
                          ],
                        ),
                      ),
                      getSizedBox(h: 5),
                      Container(
                        height: 1,
                        color: Colors.white,
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
  followButton() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(3))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: Text(
          "Follow",
          style: size10_M_normal(textColor: colorGrey),
        ),
      ),
    );
  }


  callRequests(BuildContext context) async{
    Api.get.call(context,
        method: "request-to-user/organization-incoming-request",
        param: {
          "page":requestPage.toString(),
          "user_id": AppPreference().getString(PreferencesKey.orgUserId),
        },
        isLoading: false,
        onResponseSuccess: (
            Map object) {
          print(object);
          var result = UserJoinLeadersModel.fromJson(object);
          if(result.data!.isNotEmpty) {
            leaderBoardApprovalController.profilePath.value = result.path!;
            leaderBoardApprovalController.requestsList.addAll(result.data!);
          }
        });
  }
}