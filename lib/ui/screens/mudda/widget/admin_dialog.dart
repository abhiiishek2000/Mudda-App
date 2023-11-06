import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/screens/home_screen/widget/component/hot_mudda_post.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../const/const.dart';
import '../../../../core/utils/constant_string.dart';
import '../../../../core/utils/count_number.dart';
import '../../../shared/create_dynamic_link.dart';
import '../../leader_board/view/leader_board_approval_screen.dart';
import '../view/mudda_details_screen.dart';


class MuddaInfoDialogAdmin extends StatefulWidget {
  final MuddaNewsController? muddaNewsController;
  final String muddaShareLink;

  const MuddaInfoDialogAdmin({Key? key, this.muddaNewsController,required this.muddaShareLink})
      : super(key: key);

  @override
  State<MuddaInfoDialogAdmin> createState() => _MuddaInfoDialogAdminState();
}

class _MuddaInfoDialogAdminState extends State<MuddaInfoDialogAdmin> {
  String? isSupport;

  // String? isSupportTrue;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setSp(80)),
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: Get.width,
            color: colorWhite,
            child: Material(
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              isSupport == "isSupport" ||
                                      widget.muddaNewsController!.muddaPost
                                              .value.mySupport ==
                                          true
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      margin: const EdgeInsets.only(right: 5),
                                      child:
                                          Image.asset(AppIcons.shakeHandIcon),
                                    )
                                  : isSupport == "isNotSupport" ||
                                          widget.muddaNewsController!.muddaPost
                                                  .value.mySupport ==
                                              false
                                      ? Container(
                                          height: 16,
                                          width: 16,
                                          margin: const EdgeInsets.only(
                                              right: 5, top: 2),
                                          child: Image.asset(AppIcons.dislike),
                                        )
                                      : const SizedBox(width: 50),
                              isSupport == "isSupport" ||
                                      widget.muddaNewsController!.muddaPost
                                              .value.mySupport ==
                                          true
                                  ? Text(
                                      "Invite Support",
                                      style: size12_M_regular(
                                          textColor: color202020),
                                    )
                                  : isSupport == "isNotSupport" ||
                                          widget.muddaNewsController!.muddaPost
                                                  .value.mySupport ==
                                              false
                                      ? Text(
                                          "Invite NotSupport",
                                          style: size12_M_regular(
                                              textColor: color202020),
                                        )
                                      : const SizedBox(width: 50)
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              Share.share("$shareMessage${widget.muddaShareLink}");
                              // Share.share(
                              //   '${Const.shareUrl}mudda/${widget.muddaNewsController!.muddaPost.value.sId}',
                              // );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  AppIcons.shareIcon,
                                  height: 16,
                                  width: 16,
                                  color: grey,
                                ),
                                Text(
                                  "  Share",
                                  style:
                                      size12_M_regular(textColor: color202020),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: color202020,
                      height: 20,
                      thickness: 0.2,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed(RouteConstants.muddaSettings);
                            },
                            child: Text(
                              "Settings",
                              style: size12_M_regular(textColor: color202020),
                            ),
                          ),
                          Container(
                            color: blackGray,
                            height: 16,
                            width: 0.5,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.muddaNewsController!.leaderBoardIndex
                                  .value = 2;
                              Get.to(
                                () => LeaderBoardApprovalScreen(
                                    muddaId: widget.muddaNewsController!
                                        .muddaPost.value.sId),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Join Requests ",
                                  style:
                                      size12_M_regular(textColor: color202020),
                                ),
                                Text(
                                  widget.muddaNewsController!
                                              .postForMuddaJoinRequestsAdmin ==
                                          null
                                      ? "null"
                                      : "(${widget.muddaNewsController!.postForMuddaJoinRequestsAdmin.toString()})",
                                  style:
                                      size12_M_regular(textColor: buttonBlue),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   color: blackGray,
                          //   height: 16,
                          //   width: 0.5,
                          // ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       "Approve Posts ",
                          //       style: size12_M_regular(textColor: color202020),
                          //     ),
                          //     Text(
                          //       widget.muddaNewsController!
                          //           .postForMuddapostApprovalsAdmin ==
                          //           null
                          //           ? "-"
                          //           : "(${widget.muddaNewsController!.postForMuddapostApprovalsAdmin.toString()})",
                          //       style: size12_M_regular(textColor: buttonBlue),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    /*widget.muddaNewsController!.muddaPost.value.amISupport ==
                                0 &&
                            widget.muddaNewsController!.muddaPost.value
                                    .amIUnSupport ==
                                0
                        ? Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (AppPreference()
                                        .getBool(PreferencesKey.isGuest)) {
                                      Get.toNamed(
                                          RouteConstants.userProfileEdit);
                                    } else {
                                      Api.post.call(
                                        context,
                                        method: "mudda/reaction-on-mudda",
                                        isLoading: false,
                                        param: {
                                          "user_id": AppPreference().getString(
                                              PreferencesKey.interactUserId),
                                          "joining_content_id": widget
                                              .muddaNewsController!
                                              .muddaPost
                                              .value
                                              .sId,
                                          "action_type": "support",
                                        },
                                        onResponseSuccess: (object) {
                                          print(object);
                                          widget.muddaNewsController!.muddaPost
                                              .value.afterMe = object['data'] !=
                                                  null
                                              ? AfterMe.fromJson(object['data'])
                                              : null;
                                          widget.muddaNewsController!.muddaPost
                                              .value.amISupport = widget
                                                      .muddaNewsController!
                                                      .muddaPost
                                                      .value
                                                      .amISupport ==
                                                  1
                                              ? 0
                                              : 1;
                                          widget.muddaNewsController!.muddaPost
                                              .value.totalVote = widget
                                                      .muddaNewsController!
                                                      .muddaPost
                                                      .value
                                                      .amIUnSupport ==
                                                  0
                                              ? widget
                                                          .muddaNewsController!
                                                          .muddaPost
                                                          .value
                                                          .amISupport ==
                                                      1
                                                  ? widget
                                                          .muddaNewsController!
                                                          .muddaPost
                                                          .value
                                                          .totalVote! +
                                                      1
                                                  : widget
                                                          .muddaNewsController!
                                                          .muddaPost
                                                          .value
                                                          .totalVote! -
                                                      1
                                              : widget.muddaNewsController!
                                                  .muddaPost.value.totalVote!;
                                          widget.muddaNewsController!.muddaPost
                                              .value.amIUnSupport = 0;
                                          widget.muddaNewsController!.muddaPost
                                              .value.support = widget
                                                      .muddaNewsController!
                                                      .muddaPost
                                                      .value
                                                      .amISupport ==
                                                  1
                                              ? widget
                                                      .muddaNewsController!
                                                      .muddaPost
                                                      .value
                                                      .support! +
                                                  1
                                              : widget
                                                      .muddaNewsController!
                                                      .muddaPost
                                                      .value
                                                      .support! -
                                                  1;

                                          // widget.muddaNewsController!
                                          //     .muddaPostList[index] = widget.muddaNewsController!
                                          //     .muddaPost
                                          //     .value;
                                          // widget.muddaNewsController!
                                          //     .muddaActionIndex
                                          //     .value = index;
                                          //
                                          // isSupport = "isSupport";
                                          isSupport = "isSupport";
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        },
                                      );
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 100,
                                        margin: const EdgeInsets.only(left: 25),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: colorA0A0A0),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "Support",
                                          style: size12_M_regular300(
                                              textColor: colorDarkBlack),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Image.asset(
                                                AppIcons.shakeHandIcon)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: colorA0A0A0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Hs(width: 10),
                                InkWell(
                                  onTap: () {
                                    if (AppPreference()
                                        .getBool(PreferencesKey.isGuest)) {
                                      Get.toNamed(
                                          RouteConstants.userProfileEdit);
                                    } else {
                                      Api.post.call(
                                        context,
                                        method: "mudda/reaction-on-mudda",
                                        isLoading: false,
                                        param: {
                                          "user_id": AppPreference().getString(
                                              PreferencesKey.interactUserId),
                                          "joining_content_id": widget
                                              .muddaNewsController!
                                              .muddaPost
                                              .value
                                              .sId,
                                          "action_type": "unsupport",
                                        },
                                        onResponseSuccess: (object) {
                                          widget.muddaNewsController!.muddaPost
                                              .value.afterMe = object['data'] !=
                                                  null
                                              ? AfterMe.fromJson(object['data'])
                                              : null;

                                          widget.muddaNewsController!.muddaPost
                                              .value.amIUnSupport = widget
                                                      .muddaNewsController!
                                                      .muddaPost
                                                      .value
                                                      .amIUnSupport ==
                                                  1
                                              ? 0
                                              : 1;
                                          widget.muddaNewsController!.muddaPost
                                              .value.totalVote = widget
                                                      .muddaNewsController!
                                                      .muddaPost
                                                      .value
                                                      .amISupport ==
                                                  0
                                              ? widget
                                                          .muddaNewsController!
                                                          .muddaPost
                                                          .value
                                                          .amIUnSupport ==
                                                      1
                                                  ? widget
                                                          .muddaNewsController!
                                                          .muddaPost
                                                          .value
                                                          .totalVote! +
                                                      1
                                                  : widget
                                                          .muddaNewsController!
                                                          .muddaPost
                                                          .value
                                                          .totalVote! -
                                                      1
                                              : widget.muddaNewsController!
                                                  .muddaPost.value.totalVote!;
                                          widget.muddaNewsController!.muddaPost
                                              .value.amISupport = 0;
                                          widget.muddaNewsController!.muddaPost
                                              .value.support = widget
                                                      .muddaNewsController!
                                                      .muddaPost
                                                      .value
                                                      .amIUnSupport ==
                                                  1
                                              ? widget
                                                          .muddaNewsController!
                                                          .muddaPost
                                                          .value
                                                          .support !=
                                                      0
                                                  ? widget
                                                          .muddaNewsController!
                                                          .muddaPost
                                                          .value
                                                          .support! -
                                                      1
                                                  : 0
                                              : widget.muddaNewsController!
                                                  .muddaPost.value.support!;
                                          // muddaNewsController
                                          //     .muddaPostList[
                                          // index] = muddaPost;
                                          // muddaNewsController
                                          //     .muddaActionIndex
                                          //     .value = index;
                                          //
                                          // isSupport = "isNotSupport";
                                          isSupport = "isNotSupport";
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        },
                                      );
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 100,
                                        margin: const EdgeInsets.only(left: 25),
                                        alignment: Alignment.center,
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: colorA0A0A0),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "Not Support",
                                          style: size12_M_regular300(
                                              textColor: colorDarkBlack),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            height: 15,
                                            width: 15,
                                            child:
                                                Image.asset(AppIcons.dislike)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: colorA0A0A0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),*/
                    //
                    widget.muddaNewsController!.muddaPost.value.mySupport ==
                            null
                        ? SizedBox(
                            height: ScreenUtil().setSp(16),
                          )
                        : SizedBox(
                            height: ScreenUtil().setSp(5),
                          ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      /*widget.muddaNewsController!.muddaPost
                                                      .value.amISupport ==
                                                  0 &&
                                              widget
                                                      .muddaNewsController!
                                                      .muddaPost
                                                      .value
                                                      .amIUnSupport ==
                                                  0
                                          ? const SizedBox()
                                          :*/
                                      Text(
                                        "Opposition",
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w700,
                                            fontSize: ScreenUtil().setSp(12),
                                            color: buttonYellow),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          /* if (AppPreference().getBool(
                                              PreferencesKey.isGuest)) {
                                            Get.toNamed(
                                                RouteConstants.userProfileEdit);
                                          } else {
                                            Api.post.call(
                                              context,
                                              method: "mudda/reaction-on-mudda",
                                              isLoading: false,
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(PreferencesKey
                                                    .interactUserId),
                                                "joining_content_id": widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .sId,
                                                "action_type": "unsupport",
                                              },
                                              onResponseSuccess: (object) {
                                                widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .afterMe =
                                                object['data'] != null
                                                    ? AfterMe.fromJson(
                                                    object['data'])
                                                    : null;

                                                widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .amIUnSupport = widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .amIUnSupport ==
                                                    1
                                                    ? 0
                                                    : 1;
                                                widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .totalVote = widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .amISupport ==
                                                    0
                                                    ? widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .amIUnSupport ==
                                                    1
                                                    ? widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .totalVote! +
                                                    1
                                                    : widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .totalVote! -
                                                    1
                                                    : widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .totalVote!;
                                                widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .amISupport = 0;
                                                widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .support = widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .amIUnSupport ==
                                                    1
                                                    ? widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .support !=
                                                    0
                                                    ? widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .support! -
                                                    1
                                                    : 0
                                                    : widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .support!;
                                                // muddaNewsController
                                                //     .muddaPostList[
                                                // index] = muddaPost;
                                                // muddaNewsController
                                                //     .muddaActionIndex
                                                //     .value = index;
                                                isSupport = null;
                                                if (mounted) {
                                                  setState(() {});
                                                }
                                              },
                                            );
                                          }*/
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: Image.asset(
                                                  AppIcons.dislike,
                                                  color: widget
                                                              .muddaNewsController!
                                                              .muddaPost
                                                              .value
                                                              .mySupport ==
                                                          false
                                                      ? Colors.white
                                                      : blackGray)),
                                          decoration: BoxDecoration(
                                            color: widget
                                                        .muddaNewsController!
                                                        .muddaPost
                                                        .value
                                                        .mySupport !=
                                                    false
                                                ? Colors.white
                                                : blackGray,
                                            shape: BoxShape.circle,
                                            border:
                                                Border.all(color: blackGray),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: widget.muddaNewsController!
                                                .muddaPost.value.mySupport ==
                                            null
                                        ? ScreenUtil().setSp(8)
                                        : ScreenUtil().setSp(16),
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          // "1.2m",
                                          widget
                                              .muddaNewsController!
                                              .postForMuddaMuddaOpposition[
                                                  "totalPosts"]
                                              .toString(),
                                          // countNumber(double.parse(widget
                                          //     .muddaNewsController!
                                          //     .postForMuddaMuddaOpposition[
                                          // "totalPosts"]
                                          //     .toString())),
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(12),
                                              color: black),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setSp(4),
                                        ),
                                        Image.asset(
                                          AppIcons.commentIcon,
                                          height: 12,
                                          width: 12,
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setSp(8),
                                        ),
                                        const VerticalDivider(
                                          width: 1,
                                          color: blackGray,
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setSp(11),
                                        ),
                                        Text(
                                          widget.muddaNewsController!
                                                      .postForMuddaMuddaOpposition ==
                                                  null
                                              ? "-"
                                              : "${widget.muddaNewsController?.oppositionPercentage.toStringAsFixed(2) ?? ''}%",
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(12),
                                              color: black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            width: ScreenUtil().setSp(10),
                          ),
                          widget.muddaNewsController!.muddaPost.value
                                      .mySupport ==
                                  null
                              ? const VerticalDivider(
                                  width: 1,
                                  thickness: 0.7,
                                  color: blackGray,
                                )
                              : const VerticalDivider(
                                  indent: 24,
                                  width: 1,
                                  thickness: 0.7,
                                  color: blackGray,
                                ),
                          SizedBox(
                            width: ScreenUtil().setSp(10),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (AppPreference()
                                            .getBool(PreferencesKey.isGuest)) {
                                          updateProfileDialog(context);
                                        } else {
                                          Api.post.call(
                                            context,
                                            method: "mudda/support",
                                            isLoading: false,
                                            param: {
                                              "muddaId": widget
                                                  .muddaNewsController!
                                                  .muddaPost
                                                  .value
                                                  .sId,
                                              "support": true,
                                            },
                                            onResponseSuccess: (object) {
                                              print(object);
                                              widget.muddaNewsController!
                                                      .muddaPost.value.afterMe =
                                                  object['data'] != null
                                                      ? AfterMe.fromJson(
                                                          object['data'])
                                                      : null;
                                              if (widget
                                                      .muddaNewsController!
                                                      .muddaPost
                                                      .value
                                                      .mySupport ==
                                                  true) {
                                                widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .mySupport = null;
                                                widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .support = widget
                                                        .muddaNewsController!
                                                        .muddaPost
                                                        .value
                                                        .support! -
                                                    1;
                                                widget
                                                        .muddaNewsController!
                                                        .muddaPost
                                                        .value
                                                        .totalVote! -
                                                    1;
                                              } else {
                                                widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .support = widget
                                                        .muddaNewsController!
                                                        .muddaPost
                                                        .value
                                                        .support! +
                                                    1;
                                                widget
                                                        .muddaNewsController!
                                                        .muddaPost
                                                        .value
                                                        .totalVote! +
                                                    1;
                                                widget
                                                    .muddaNewsController!
                                                    .muddaPost
                                                    .value
                                                    .mySupport = true;
                                              }

                                              // widget.muddaNewsController!
                                              //     .muddaPostList[index] = widget.muddaNewsController!
                                              //     .muddaPost
                                              //     .value;
                                              // widget.muddaNewsController!
                                              //     .muddaActionIndex
                                              //     .value = index;
                                              isSupport = null;
                                              if (mounted) {
                                                setState(() {});
                                              }
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Image.asset(
                                                AppIcons.shakeHandIcon,
                                                color: widget
                                                            .muddaNewsController!
                                                            .muddaPost
                                                            .value
                                                            .mySupport ==
                                                        true
                                                    ? Colors.white
                                                    : blackGray)),
                                        decoration: BoxDecoration(
                                            color: widget
                                                        .muddaNewsController!
                                                        .muddaPost
                                                        .value
                                                        .mySupport !=
                                                    true
                                                ? Colors.white
                                                : blackGray,
                                            shape: BoxShape.circle,
                                            border:
                                                Border.all(color: blackGray)),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Favour",
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: ScreenUtil().setSp(12),
                                          color: buttonBlue),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: widget.muddaNewsController!.muddaPost
                                              .value.mySupport ==
                                          null
                                      ? ScreenUtil().setSp(8)
                                      : ScreenUtil().setSp(16),
                                ),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        // "1.2m",
                                        // widget.muddaNewsController!
                                        //     .postForMuddaMuddaFavour[
                                        //         "totalPosts"]
                                        //     .toString(),
                                        widget
                                            .muddaNewsController!
                                            .postForMuddaMuddaFavour[
                                                "totalPosts"]
                                            .toString(),
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(12),
                                            color: black),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setSp(4),
                                      ),
                                      Image.asset(
                                        AppIcons.commentIcon,
                                        height: 12,
                                        width: 12,
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setSp(8),
                                      ),
                                      const VerticalDivider(
                                        width: 1,
                                        color: blackGray,
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setSp(11),
                                      ),
                                      Text(
                                        // "Agree 80.12%",
                                        widget.muddaNewsController!
                                                    .postForMuddaMuddaFavour ==
                                                null
                                            ? ""
                                            : "Agree ${widget.muddaNewsController!.favourPercentage.toStringAsFixed(2)}%",
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(12),
                                            color: black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // IntrinsicHeight(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(vertical: 3),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.end,
                    //           children: [
                    //             Text(
                    //               "Favour",
                    //               style: GoogleFonts.nunitoSans(
                    //                   fontWeight: FontWeight.w700,
                    //                   fontSize: ScreenUtil().setSp(12),
                    //                   color: buttonBlue),
                    //             ),
                    //             // SizedBox(
                    //             //   height: ScreenUtil().setSp(12),
                    //             // ),
                    //             SizedBox(
                    //               height: ScreenUtil().setSp(5),
                    //             ),
                    //             IntrinsicHeight(
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Text(
                    //                     "1.2m",
                    //                     style: GoogleFonts.nunitoSans(
                    //                         fontWeight: FontWeight.w400,
                    //                         fontSize: ScreenUtil().setSp(12),
                    //                         color: black),
                    //                   ),
                    //                   SizedBox(
                    //                     width: ScreenUtil().setSp(4),
                    //                   ),
                    //                   Image.asset(
                    //                     AppIcons.commentIcon,
                    //                     height: 12,
                    //                     width: 12,
                    //                   ),
                    //                   SizedBox(
                    //                     width: ScreenUtil().setSp(8),
                    //                   ),
                    //                   const VerticalDivider(
                    //                     width: 1,
                    //                     color: blackGray,
                    //                   ),
                    //                   SizedBox(
                    //                     width: ScreenUtil().setSp(11),
                    //                   ),
                    //                   Text(
                    //                     "Agree 80.12%",
                    //                     style: GoogleFonts.nunitoSans(
                    //                         fontWeight: FontWeight.w400,
                    //                         fontSize: ScreenUtil().setSp(12),
                    //                         color: black),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: ScreenUtil().setSp(10),
                    //       ),
                    //       const VerticalDivider(
                    //         width: 1,
                    //         color: blackGray,
                    //       ),
                    //       SizedBox(
                    //         width: ScreenUtil().setSp(10),
                    //       ),
                    //       Padding(
                    //           padding: const EdgeInsets.symmetric(vertical: 3),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text(
                    //                 "Opposition",
                    //                 style: GoogleFonts.nunitoSans(
                    //                     fontWeight: FontWeight.w700,
                    //                     fontSize: ScreenUtil().setSp(12),
                    //                     color: buttonYellow),
                    //               ),
                    //               // SizedBox(
                    //               //   height: ScreenUtil().setSp(12),
                    //               // ),
                    //               SizedBox(
                    //                 height: ScreenUtil().setSp(5),
                    //               ),
                    //               IntrinsicHeight(
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     Text(
                    //                       "1.2m",
                    //                       style: GoogleFonts.nunitoSans(
                    //                           fontWeight: FontWeight.w400,
                    //                           fontSize: ScreenUtil().setSp(12),
                    //                           color: black),
                    //                     ),
                    //                     SizedBox(
                    //                       width: ScreenUtil().setSp(4),
                    //                     ),
                    //                     Image.asset(
                    //                       AppIcons.commentIcon,
                    //                       height: 12,
                    //                       width: 12,
                    //                     ),
                    //                     SizedBox(
                    //                       width: ScreenUtil().setSp(8),
                    //                     ),
                    //                     const VerticalDivider(
                    //                       width: 1,
                    //                       color: blackGray,
                    //                     ),
                    //                     SizedBox(
                    //                       width: ScreenUtil().setSp(11),
                    //                     ),
                    //                     Text(
                    //                       "Agree 80.12%",
                    //                       style: GoogleFonts.nunitoSans(
                    //                           fontWeight: FontWeight.w400,
                    //                           fontSize: ScreenUtil().setSp(12),
                    //                           color: black),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           )),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
