import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/ui/screens/home_screen/widget/component/hot_mudda_post.dart';
import 'package:mudda/ui/shared/flip_car_widget.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../const/const.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_icons.dart';
import '../../../../../core/constant/route_constants.dart';
import '../../../../../core/preferences/preference_manager.dart';
import '../../../../../core/preferences/preferences_key.dart';
import '../../../../../core/utils/color.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../../dio/api/api.dart';
import '../../../../../model/MuddaPostModel.dart';
import '../../../../../model/PostForMuddaModel.dart';
import '../../../../shared/ReadMoreText.dart';
import '../../../../shared/VideoPlayerScreen.dart';
import '../../../../shared/report_post_dialog_box.dart';
import '../../../../shared/spacing_widget.dart';
import '../../../leader_board/controller/LeaderBoardApprovalController.dart';
import '../../../leader_board/view/leader_board_approval_screen.dart';
import '../../../mudda/view/mudda_details_screen.dart';
import '../../controller/mudda_fire_news_controller.dart';
import '../show_case_widget.dart';

class HotMuddaPostWishShowcase extends StatefulWidget {
  HotMuddaPostWishShowcase({
    Key? key,
    required this.muddaPost,
    required int index,
    required this.globaleKey,
    this.muddaCreator = 0,
    this.muddaLeader = 0,
    this.muddaInitialLeader = 0,
    this.muddaOpposition = 0,
  }) : super(key: key);
  MuddaPost muddaPost;
  int index = 0;
  final GlobalKey globaleKey;
  int muddaCreator = 0;
  int muddaLeader = 0;
  int muddaInitialLeader = 0;
  int muddaOpposition = 0;

  @override
  State<HotMuddaPostWishShowcase> createState() =>
      _HotMuddaPostWishShowcaseState();
}

class _HotMuddaPostWishShowcaseState extends State<HotMuddaPostWishShowcase> {
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  LeaderBoardApprovalController leaderBoardApprovalController =
      Get.put(LeaderBoardApprovalController());

  VideoController videoController = VideoController();
  bool isOnPageHorizontalTurning = false;

  @override
  Widget build(BuildContext context) {
    return FlipCardWidget(
      index: widget.index,
      frontWidget: buildMuddaCardFrontSide(context),
      backWidget: buildMuddaCardBackSide(),
    );
  }

  Widget buildMuddaCardBackSide() {
    return widget.muddaPost.gallery!.length == 1
        ? buildBackCardWithSingleMedia()
        : buildBackCardWithMultipleMedia();
  }

  Widget buildMuddaCardFrontSide(BuildContext context) {
    return GestureDetector(
      onTap: () {
        muddaNewsController.muddaPost.value = widget.muddaPost;
        muddaNewsController.muddaActionIndex.value = widget.index;
        Get.toNamed(RouteConstants.muddaDetailsScreen);
      },
      child: Container(
        // alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 4 * 2,
        margin: EdgeInsets.only(
          left: ScreenUtil().setSp(10),
          right: ScreenUtil().setSp(10),
          bottom: ScreenUtil().setSp(32),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(10),
          vertical: ScreenUtil().setSp(4),
        ),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
          boxShadow: [
            BoxShadow(
              color: colorBlack.withOpacity(0.25),
              offset: const Offset(
                0.0,
                4.0,
              ),
              blurRadius: 4,
              spreadRadius: 0.8,
            ), //BoxShadow//BoxShadow
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    widget.muddaPost.thumbnail != null
                        ? GestureDetector(
                            onTap: () {
                              print("muddaPost.gallery 3");
                              print(widget.muddaPost.thumbnail);
                              print(widget.muddaPost.gallery?.length);
                              List<Gallery> list = <Gallery>[];

                              list.add(
                                  Gallery(file: widget.muddaPost.thumbnail));
                              list.addAll(widget.muddaPost.gallery!);
                              print(list.length);
                              widget.muddaPost.gallery != null
                                  ? muddaGalleryDialog(
                                      context,
                                      list,
                                      muddaNewsController
                                          .muddaProfilePath.value,
                                      0)
                                  : null;
                            },
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(ScreenUtil().setSp(8)),
                              child: SizedBox(
                                height: ScreenUtil().setSp(80),
                                width: ScreenUtil().setSp(80),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${muddaNewsController.muddaProfilePath.value}${widget.muddaPost.thumbnail}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setSp(8)),
                            child: Container(
                              color: white,
                              height: ScreenUtil().setSp(80),
                              width: ScreenUtil().setSp(80),
                              child: Text(
                                  widget.muddaPost.title![0].toUpperCase(),
                                  style:
                                      size12_M_normal(textColor: Colors.black)),
                            ),
                          ),
                    /*Container(
                                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: colorWhite),
                                              borderRadius: BorderRadius.circular(5)),
                                          child: const Icon(
                                            Icons.play_arrow_outlined,
                                            color: colorWhite,
                                          ),
                                        )*/
                  ],
                ),
                SizedBox(
                  width: ScreenUtil().setSp(8),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.muddaPost.title ?? "Mudda Title",
                        style: GoogleFonts.nunitoSans(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.w700,
                            color: black),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.muddaPost.initialScope != null)
                            Wrap(
                              children: [
                                Text(
                                  widget.muddaPost.initialScope!
                                              .toLowerCase() ==
                                          "district"
                                      ? "[ ${widget.muddaPost.city!.capitalize!} ]"
                                      : widget.muddaPost.initialScope!
                                                  .toLowerCase() ==
                                              "state"
                                          ? "[ ${widget.muddaPost.state!.capitalize!} ]"
                                          : widget.muddaPost.initialScope!
                                                      .toLowerCase() ==
                                                  "country"
                                              ? "[ ${widget.muddaPost.country!.capitalize!} ]"
                                              : "[ ${widget.muddaPost.initialScope!.capitalize!} ]",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: ScreenUtil().setSp(12),
                                      fontWeight: FontWeight.w700,
                                      color: black),
                                ),
                              ],
                            ),
                          if (widget.muddaPost.support != null)
                            Row(
                              children: [
                                Text(
                                    "${widget.muddaPost.support != 0 ? ((widget.muddaPost.support! * 100) / widget.muddaPost.totalVote!).toStringAsFixed(2) : 0}% / ${NumberFormat.compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                          '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(widget.muddaPost.support)}",
                                    style: size12_M_bold(textColor: color0060FF)
                                        .copyWith(height: 1.8)),
                                const Hs(
                                  width: 4,
                                ),
                                Image.asset(
                                  AppIcons.bluehandsheck,
                                  height: 12,
                                  width: 20,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Vs(height: 24),
            GestureDetector(
              onTap: () {
                if (widget.muddaPost.leaders![0].acceptUserDetail!.sId ==
                        AppPreference().getString(PreferencesKey.userId) ||
                    widget.muddaPost.leaders![0].acceptUserDetail!.sId ==
                        AppPreference().getString(PreferencesKey.orgUserId)) {
                  muddaNewsController.muddaPost.value = widget.muddaPost;
                  muddaNewsController.leaderBoardIndex.value = 0;
                  // log('-=- log -=-=-= ${muddaPost.sId}');
                  Get.toNamed(RouteConstants.leaderBoardApproval,
                      arguments: widget.muddaPost);
                } else {
                  Get.toNamed(RouteConstants.leaderBoard,
                      arguments: widget.muddaPost);
                }
              },
              child: Container(
                height: ScreenUtil().setSp(78),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: ShowCaseView(
                      globalKey: widget.globaleKey,
                      title:
                          'Every Mudda has a Leadership team. To see who is in Favour or Opposition',
                      description: 'Click on Leaders ->',
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, int index) {
                            if (index == 4) {
                              return InkWell(
                                onTap: () {
                                  if (widget.muddaPost.leaders![0]
                                              .acceptUserDetail!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.userId) ||
                                      widget.muddaPost.leaders![0]
                                              .acceptUserDetail!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.orgUserId)) {
                                    muddaNewsController.muddaPost.value =
                                        widget.muddaPost;
                                    muddaNewsController.leaderBoardIndex.value =
                                        0;
                                    Get.toNamed(
                                        RouteConstants.leaderBoardApproval,
                                        arguments: widget.muddaPost);
                                  } else {
                                    Get.toNamed(RouteConstants.leaderBoard,
                                        arguments: widget.muddaPost);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.add, size: 15.sp),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.muddaPost.leaders != null
                                              // ? "${muddaPost.leadersCount! - 4}"
                                              ? widget.muddaPost.leaders!
                                                          .length <
                                                      4
                                                  ? "0 Leaders"
                                                  : "${widget.muddaPost.leadersCount != null && (widget.muddaPost.leadersCount)! >= 4 ? widget.muddaPost.leadersCount! - 4 : 0} Leaders"
                                              : "",
                                          style: size12_M_bold(
                                              textColor: colorDarkBlack),
                                        ),
                                        Vs(
                                          height: 10.h,
                                        ),
                                        Image.asset(
                                          AppIcons.nextLongArrow,
                                          height: 8.h,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            } else if (widget.muddaPost.leaders!.length ==
                                index) {
                              return InkWell(
                                onTap: () {
                                  if (widget.muddaPost.leaders![0]
                                              .acceptUserDetail!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.userId) ||
                                      widget.muddaPost.leaders![0]
                                              .acceptUserDetail!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.orgUserId)) {
                                    muddaNewsController.muddaPost.value =
                                        widget.muddaPost;
                                    muddaNewsController.leaderBoardIndex.value =
                                        0;
                                    Get.toNamed(
                                        RouteConstants.leaderBoardApproval,
                                        arguments: widget.muddaPost);
                                  } else {
                                    Get.toNamed(RouteConstants.leaderBoard,
                                        arguments: widget.muddaPost);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.add, size: 15.sp),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.muddaPost.leaders != null
                                              // ? "${muddaPost.leadersCount! - 4}"
                                              ? widget.muddaPost.leaders!
                                                          .length <
                                                      4
                                                  ? "0 Leaders"
                                                  : "${widget.muddaPost.leadersCount != null && (widget.muddaPost.leadersCount)! >= 4 ? widget.muddaPost.leadersCount! - 4 : 0} Leaders"
                                              : "",
                                          style: size12_M_bold(
                                              textColor: colorDarkBlack),
                                        ),
                                        Vs(
                                          height: 10.h,
                                        ),
                                        Image.asset(
                                          AppIcons.nextLongArrow,
                                          height: 8.h,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            } else {
                              String path =
                                  "${muddaNewsController.muddaUserProfilePath.value}${widget.muddaPost.leaders![index].acceptUserDetail!.profile ?? ""}";
                              return GestureDetector(
                                onTap: () {
                                  if (widget.muddaPost.leaders![index]
                                          .userIdentity ==
                                      1) {
                                    muddaNewsController.acceptUserDetail.value =
                                        widget.muddaPost.leaders![index]
                                            .acceptUserDetail!;
                                    if (widget.muddaPost.leaders![index]
                                            .acceptUserDetail!.sId ==
                                        AppPreference()
                                            .getString(PreferencesKey.userId)) {
                                      Get.toNamed(RouteConstants.profileScreen);
                                    } else {
                                      Map<String, String>? parameters = {
                                        "userDetail": jsonEncode(widget
                                            .muddaPost
                                            .leaders![index]
                                            .acceptUserDetail!)
                                      };
                                      Get.toNamed(
                                          RouteConstants.otherUserProfileScreen,
                                          parameters: parameters);
                                    }
                                  } else {
                                    anynymousDialogBox(context);
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    widget.muddaPost.leaders![index]
                                                .userIdentity ==
                                            0
                                        ? Container(
                                            height: ScreenUtil().setSp(40),
                                            width: ScreenUtil().setSp(40),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: darkGray,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text("A",
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(20),
                                                      color: black)),
                                            ),
                                          )
                                        : widget
                                                    .muddaPost
                                                    .leaders![index]
                                                    .acceptUserDetail!
                                                    .profile !=
                                                null
                                            ? Stack(children: [
                                                CachedNetworkImage(
                                                  imageUrl: path,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width:
                                                        ScreenUtil().setSp(40),
                                                    height:
                                                        ScreenUtil().setSp(40),
                                                    decoration: BoxDecoration(
                                                      color: colorWhite,
                                                      border: Border.all(
                                                        width: ScreenUtil()
                                                            .setSp(1),
                                                        color: widget
                                                                    .muddaPost
                                                                    .leaders![
                                                                        index]
                                                                    .joinerType! ==
                                                                "creator"
                                                            ? buttonBlue
                                                            : widget
                                                                        .muddaPost
                                                                        .leaders![
                                                                            index]
                                                                        .joinerType! ==
                                                                    "opposition"
                                                                ? buttonYellow
                                                                : white,
                                                      ),
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
                                                    radius:
                                                        ScreenUtil().setSp(20),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          CircleAvatar(
                                                    backgroundColor: lightGray,
                                                    radius:
                                                        ScreenUtil().setSp(20),
                                                  ),
                                                ),
                                                // Positioned(
                                                //   bottom: 0,
                                                //   right: 0,
                                                //   child: Visibility(
                                                //     visible: muddaPost
                                                //         .leaders![
                                                //     index]
                                                //         .acceptUserDetail!
                                                //         .isProfileVerified==1,
                                                //     child: Image.asset(
                                                //       AppIcons.verifyProfile,
                                                //       width: 18,
                                                //       height: 18,
                                                //       color: Colors.white,
                                                //     ),
                                                //   ),
                                                // ),
                                              ])
                                            : Container(
                                                height: ScreenUtil().setSp(40),
                                                width: ScreenUtil().setSp(40),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: darkGray,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Stack(children: [
                                                  Center(
                                                    child: Text(
                                                        widget
                                                            .muddaPost
                                                            .leaders![index]
                                                            .acceptUserDetail!
                                                            .fullname![0]
                                                            .toUpperCase(),
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
                                                  // Positioned(
                                                  //   bottom: 0,
                                                  //   right: 0,
                                                  //   child: Visibility(
                                                  //     visible: muddaPost
                                                  //         .leaders![
                                                  //     index]
                                                  //         .acceptUserDetail!
                                                  //         .isProfileVerified==1,
                                                  //     child: Image.asset(
                                                  //       AppIcons.verifyProfile,
                                                  //       width: 15,
                                                  //       height: 15,
                                                  //       color: color606060,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ]),
                                              ),
                                    Vs(height: 5.h),
                                    Container(
                                      width: ScreenUtil().setSp(55),
                                      child: Text(
                                        widget.muddaPost.leaders![index]
                                                    .userIdentity ==
                                                1
                                            ? "${widget.muddaPost.leaders![index].acceptUserDetail!.fullname}"
                                            : "Anonymous",
                                        maxLines: 2,
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(12),
                                            color: black),
                                        // size10_M_regular300(
                                        //                 letterSpacing: 0.0,
                                        //                 textColor: colorDarkBlack),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          separatorBuilder: (context, int index) {
                            return SizedBox(width: 12);
                          },
                          itemCount: widget.muddaPost.leaders != null
                              ? widget.muddaPost.leaders!.length >= 4
                                  ? 5
                                  : widget.muddaPost.leaders!.length + 1
                              : 0),
                    ))
                  ],
                ),
              ),
            ),
            const Vs(height: 24),
            Container(
              width: double.infinity,
              height: 1,
              color: colorF2F2F2,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              height: ScreenUtil().setHeight(66),
              child: Obx(
                () => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Visibility(
                            visible: muddaNewsController.muddaAction.value ||
                                widget.index !=
                                    muddaNewsController.muddaActionIndex.value,
                            child: widget.muddaPost.mySupport == null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (AppPreference().getBool(
                                              PreferencesKey.isGuest)) {
                                            updateProfileDialog(context);
                                          } else {
                                            Api.post.call(
                                              context,
                                              method: "mudda/support",
                                              param: {
                                                "muddaId": widget.muddaPost.sId,
                                                "support": true,
                                              },
                                              onResponseSuccess: (object) {
                                                print(object);
                                                widget.muddaPost.afterMe =
                                                    object['data'] != null
                                                        ? AfterMe.fromJson(
                                                            object['data'])
                                                        : null;
                                                if (widget
                                                        .muddaPost.mySupport ==
                                                    true) {
                                                  widget.muddaPost.mySupport =
                                                      null;
                                                  widget.muddaPost.support =
                                                      widget.muddaPost
                                                              .support! -
                                                          1;
                                                  widget.muddaPost.totalVote! -
                                                      1;
                                                } else {
                                                  widget.muddaPost.support =
                                                      widget.muddaPost
                                                              .support! +
                                                          1;
                                                  widget.muddaPost.totalVote! +
                                                      1;
                                                  widget.muddaPost.mySupport =
                                                      true;
                                                }
                                                muddaNewsController
                                                            .muddaPostList[
                                                        widget.index] =
                                                    widget.muddaPost;
                                                muddaNewsController
                                                    .muddaActionIndex
                                                    .value = widget.index;
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
                                              margin: EdgeInsets.only(left: 25),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: colorA0A0A0),
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
                                                border: Border.all(
                                                    color: colorA0A0A0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Hs(width: 10),
                                      InkWell(
                                        onTap: () {
                                          if (AppPreference().getBool(
                                              PreferencesKey.isGuest)) {
                                            updateProfileDialog(context);
                                          } else {
                                            Api.post.call(
                                              context,
                                              method: "mudda/support",
                                              param: {
                                                "muddaId": widget.muddaPost.sId,
                                                "support": false,
                                              },
                                              onResponseSuccess: (object) {
                                                widget.muddaPost.afterMe =
                                                    object['data'] != null
                                                        ? AfterMe.fromJson(
                                                            object['data'])
                                                        : null;

                                                if (widget
                                                        .muddaPost.mySupport ==
                                                    false) {
                                                  widget.muddaPost.mySupport =
                                                      null;
                                                  widget.muddaPost.totalVote! -
                                                      1;
                                                } else {
                                                  widget.muddaPost.totalVote! +
                                                      1;

                                                  widget.muddaPost.mySupport =
                                                      false;
                                                }
                                                muddaNewsController
                                                            .muddaPostList[
                                                        widget.index] =
                                                    widget.muddaPost;
                                                muddaNewsController
                                                    .muddaActionIndex
                                                    .value = widget.index;
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
                                              margin: EdgeInsets.only(left: 25),
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: colorA0A0A0),
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
                                                  child: Image.asset(
                                                      AppIcons.dislike)),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: colorA0A0A0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      // Hs(width: 17),
                                      Expanded(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Recent Updates:",
                                                  style: GoogleFonts.nunitoSans(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(12),
                                                      color: black)),
                                              Container(
                                                height: ScreenUtil().setSp(50),
                                                width: ScreenUtil().setSp(190),
                                                child:
                                                    // GridView.count(
                                                    //   padding:
                                                    //       EdgeInsets.only(top: 4),
                                                    //   crossAxisCount: 2,
                                                    //   scrollDirection:
                                                    //       Axis.vertical,
                                                    //   crossAxisSpacing: 4,
                                                    //   mainAxisSpacing: 4,
                                                    //   childAspectRatio: 5,
                                                    //   physics:
                                                    //       const NeverScrollableScrollPhysics(),
                                                    //   shrinkWrap: true,
                                                    Wrap(
                                                  children: [
                                                    Container(
                                                        margin: const EdgeInsets
                                                            .all(5),
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 4,
                                                                right: 2),
                                                        color: const Color(
                                                                0xff2176FF)
                                                            .withOpacity(0.1),
                                                        child: Text.rich(
                                                          TextSpan(
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text:
                                                                        "Support: ",
                                                                    style: size11_M_regular(
                                                                        textColor:
                                                                            Color(0xff2176FF))),
                                                                TextSpan(
                                                                    text:
                                                                        "${widget.muddaPost.support} (${widget.muddaPost.supportDiff != null && widget.muddaPost.supportDiff!.isNaN == false ? widget.muddaPost.supportDiff!.toStringAsFixed(0) : 0}%)",
                                                                    style: size11_M_bold(
                                                                        textColor: widget.muddaPost.supportDiff != null &&
                                                                                widget.muddaPost.supportDiff!.isNegative
                                                                            ? Colors.red
                                                                            : Color(0xff2176FF)))
                                                              ]),
                                                        )),
                                                    Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 4,
                                                                right: 2),
                                                        color: const Color(
                                                                0xff2176FF)
                                                            .withOpacity(0.1),
                                                        child: Text.rich(
                                                            TextSpan(children: <
                                                                TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "New Leaders: ",
                                                              style: size11_M_regular(
                                                                  textColor: Color(
                                                                      0xff2176FF))),
                                                          TextSpan(
                                                              text:
                                                                  "${widget.muddaPost.newLeaderDiff ?? widget.muddaPost.leadersCount}",
                                                              style: size11_M_bold(
                                                                  textColor: widget.muddaPost.newLeaderDiff !=
                                                                              null &&
                                                                          widget
                                                                              .muddaPost
                                                                              .newLeaderDiff!
                                                                              .isNegative
                                                                      ? Colors
                                                                          .red
                                                                      : Color(
                                                                          0xff2176FF)))
                                                        ]))),
                                                    Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 4,
                                                                right: 2),
                                                        color: const Color(
                                                                0xff2176FF)
                                                            .withOpacity(0.1),
                                                        child: Text.rich(
                                                            TextSpan(children: <
                                                                TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "New Posts: ",
                                                              style: size11_M_regular(
                                                                  textColor: Color(
                                                                      0xff2176FF))),
                                                          TextSpan(
                                                              text:
                                                                  "${widget.muddaPost.newPostDiff ?? widget.muddaPost.totalPost}",
                                                              style: size11_M_bold(
                                                                  textColor: widget.muddaPost.newPostDiff !=
                                                                              null &&
                                                                          widget
                                                                              .muddaPost
                                                                              .newPostDiff!
                                                                              .isNegative
                                                                      ? Colors
                                                                          .red
                                                                      : Color(
                                                                          0xff2176FF)))
                                                        ]))),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                      // Hs(width: 17),
                                      const Spacer(flex: 1),
                                      Expanded(
                                        flex: 3,
                                        child: (widget.muddaPost.isInvolved !=
                                                            null &&
                                                        widget
                                                                .muddaPost
                                                                .isInvolved!
                                                                .joinerType ==
                                                            'creator' ||
                                                    widget.muddaPost
                                                                .isInvolved !=
                                                            null &&
                                                        widget
                                                                .muddaPost
                                                                .isInvolved!
                                                                .joinerType ==
                                                            'initial_leader' ||
                                                    widget.muddaPost
                                                                .isInvolved !=
                                                            null &&
                                                        widget
                                                                .muddaPost
                                                                .isInvolved!
                                                                .joinerType ==
                                                            'leader' ||
                                                    widget.muddaPost
                                                                .isInvolved !=
                                                            null &&
                                                        widget
                                                                .muddaPost
                                                                .isInvolved!
                                                                .joinerType ==
                                                            'opposition') &&
                                                (widget.muddaCreator > 0 ||
                                                    widget.muddaLeader > 0 ||
                                                    widget.muddaInitialLeader >
                                                        0 ||
                                                    widget.muddaOpposition > 0)
                                            ? Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      muddaNewsController
                                                              .muddaPost.value =
                                                          widget.muddaPost;
                                                      Get.back();
                                                      Share.share(
                                                        '${Const.shareUrl}mudda/${muddaNewsController.muddaPost.value.sId}',
                                                      );
                                                    },
                                                    child: Image.asset(
                                                      AppIcons.iconShareRound,
                                                      height: 40,
                                                      width: 40,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  GestureDetector(
                                                    onTap: () {
                                                      log('-=- muddaId - 1 -=- ${widget.muddaPost.sId!}');
                                                      log('-=- muddaOpposition - 1 -=- ${widget.muddaOpposition > 0}');
                                                      // Get.toNamed(RouteConstants.invitedSearchScreen, arguments: muddaPost.sId!)!
                                                      muddaNewsController
                                                              .muddaPost.value =
                                                          widget.muddaPost;
                                                      // int? pIndex = widget.muddaPost.leaders?.indexOf(Leaders(
                                                      //     acceptUserDetail: AcceptUserDetail(sId: AppPreference().getString(PreferencesKey.userId))
                                                      // ));
                                                      // log('-=- index$pIndex');
                                                      String? joineerType =
                                                          widget
                                                              .muddaPost
                                                              .isInvolved!
                                                              .joinerType;
                                                      log('-=- type$joineerType');
                                                      muddaNewsController
                                                              .inviteType
                                                              .value =
                                                          joineerType ==
                                                                  'opposition'
                                                              ? 'opposition'
                                                              : '';
                                                      Get.toNamed(RouteConstants
                                                          .invitedSupportScreen);
                                                    },
                                                    child: Image.asset(
                                                      AppIcons
                                                          .iconInviteSupportRound,
                                                      height: 40,
                                                      width: 40,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      if (AppPreference()
                                                          .getBool(
                                                              PreferencesKey
                                                                  .isGuest)) {
                                                        updateProfileDialog(
                                                            context);
                                                      } else {
                                                        Api.post.call(
                                                          context,
                                                          method:
                                                              "mudda/support",
                                                          param: {
                                                            "muddaId": widget
                                                                .muddaPost.sId,
                                                            "support": true,
                                                          },
                                                          onResponseSuccess:
                                                              (object) {
                                                            print(object);
                                                            widget.muddaPost
                                                                .afterMe = object[
                                                                        'data'] !=
                                                                    null
                                                                ? AfterMe.fromJson(
                                                                    object[
                                                                        'data'])
                                                                : null;
                                                            if (widget.muddaPost
                                                                    .mySupport ==
                                                                true) {
                                                              widget.muddaPost
                                                                      .mySupport =
                                                                  null;
                                                              widget.muddaPost
                                                                  .support = widget
                                                                      .muddaPost
                                                                      .support! -
                                                                  1;
                                                              widget.muddaPost
                                                                      .totalVote! -
                                                                  1;
                                                            } else {
                                                              widget.muddaPost
                                                                  .support = widget
                                                                      .muddaPost
                                                                      .support! +
                                                                  1;
                                                              widget.muddaPost
                                                                      .totalVote! +
                                                                  1;
                                                              widget.muddaPost
                                                                      .mySupport =
                                                                  true;
                                                            }
                                                            muddaNewsController
                                                                    .muddaPostList[
                                                                widget
                                                                    .index] = widget
                                                                .muddaPost;
                                                            muddaNewsController
                                                                    .muddaActionIndex
                                                                    .value =
                                                                widget.index;
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      child: SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child: Image.asset(
                                                              AppIcons
                                                                  .shakeHandIcon,
                                                              color: widget
                                                                          .muddaPost
                                                                          .mySupport ==
                                                                      true
                                                                  ? Colors.white
                                                                  : blackGray)),
                                                      decoration: BoxDecoration(
                                                        color: widget.muddaPost
                                                                    .mySupport !=
                                                                true
                                                            ? Colors.white
                                                            : blackGray,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: blackGray),
                                                      ),
                                                    ),
                                                  ),
                                                  Hs(width: 18),
                                                  InkWell(
                                                    onTap: () {
                                                      if (AppPreference()
                                                          .getBool(
                                                              PreferencesKey
                                                                  .isGuest)) {
                                                        updateProfileDialog(
                                                            context);
                                                      } else {
                                                        Api.post.call(
                                                          context,
                                                          method:
                                                              "mudda/support",
                                                          param: {
                                                            "muddaId": widget
                                                                .muddaPost.sId,
                                                            "support": false,
                                                          },
                                                          onResponseSuccess:
                                                              (object) {
                                                            widget.muddaPost
                                                                .afterMe = object[
                                                                        'data'] !=
                                                                    null
                                                                ? AfterMe.fromJson(
                                                                    object[
                                                                        'data'])
                                                                : null;

                                                            if (widget.muddaPost
                                                                    .mySupport ==
                                                                false) {
                                                              widget.muddaPost
                                                                      .mySupport =
                                                                  null;
                                                              widget.muddaPost
                                                                      .totalVote! -
                                                                  1;
                                                              widget.muddaPost
                                                                          .support !=
                                                                      0
                                                                  ? widget.muddaPost
                                                                          .support! -
                                                                      1
                                                                  : 0;
                                                            } else {
                                                              widget.muddaPost
                                                                      .totalVote! +
                                                                  1;
                                                              widget.muddaPost
                                                                      .support =
                                                                  widget
                                                                      .muddaPost
                                                                      .support;
                                                              widget.muddaPost
                                                                  .support = widget
                                                                      .muddaPost
                                                                      .support! -
                                                                  1;

                                                              widget.muddaPost
                                                                      .mySupport =
                                                                  false;
                                                            }

                                                            muddaNewsController
                                                                    .muddaPostList[
                                                                widget
                                                                    .index] = widget
                                                                .muddaPost;
                                                            muddaNewsController
                                                                    .muddaActionIndex
                                                                    .value =
                                                                widget.index;
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      child: SizedBox(
                                                          height: 15,
                                                          width: 15,
                                                          child: Image.asset(
                                                              AppIcons.dislike,
                                                              color: widget
                                                                          .muddaPost
                                                                          .mySupport ==
                                                                      false
                                                                  ? Colors.white
                                                                  : blackGray)),
                                                      decoration: BoxDecoration(
                                                        color: widget.muddaPost
                                                                    .mySupport !=
                                                                false
                                                            ? Colors.white
                                                            : blackGray,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: blackGray),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                          ),
                          Visibility(
                            visible: muddaNewsController
                                    .muddaDescripation.value &&
                                widget.index ==
                                    muddaNewsController.muddaActionIndex.value,
                            child: widget.muddaPost.muddaDescription!
                                        .isNotEmpty &&
                                    widget.muddaPost.muddaDescription!.length >
                                        3
                                ? ReadMoreText(
                                    'Description: ${widget.muddaPost.muddaDescription}',
                                    trimLines: 3,
                                    trimMode: TrimMode.Line,
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: ScreenUtil().setSp(12),
                                        fontWeight: FontWeight.w400,
                                        color: black),
                                  )
                                : widget.muddaPost.muddaDescription!.isNotEmpty
                                    ? Text(
                                        "Description: ${widget.muddaPost.muddaDescription}",
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                            color: black))
                                    : Text("Description:",
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                            color: black)),
                          ),
                        ],
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         widget.muddaPost.muddaDescripation = true;
                    //         widget.muddaPost.muddaAction = false;
                    //         muddaNewsController.muddaAction.value = false;
                    //         muddaNewsController.muddaDescripation.value = true;
                    //         muddaNewsController.muddaActionIndex.value =
                    //             widget.index;
                    //       },
                    //       child: muddaNewsController.muddaDescripation.value &&
                    //               widget.index ==
                    //                   muddaNewsController.muddaActionIndex.value
                    //           ? Container(
                    //               decoration: const BoxDecoration(
                    //                 color: blackGray,
                    //                 borderRadius: BorderRadius.only(
                    //                     topRight: Radius.circular(0),
                    //                     bottomRight: Radius.circular(0),
                    //                     topLeft: Radius.circular(8),
                    //                     bottomLeft: Radius.circular(8)),
                    //               ),
                    //               padding: const EdgeInsets.only(
                    //                   top: 12, bottom: 12, left: 5, right: 5),
                    //               child: SvgPicture.asset(
                    //                   "assets/svg/description.svg",
                    //                   color: white),
                    //             )
                    //           : Container(
                    //               decoration: const BoxDecoration(
                    //                 color: gray,
                    //                 borderRadius: BorderRadius.only(
                    //                     topRight: Radius.circular(0),
                    //                     bottomRight: Radius.circular(0),
                    //                     topLeft: Radius.circular(8),
                    //                     bottomLeft: Radius.circular(8)),
                    //               ),
                    //               padding: const EdgeInsets.only(
                    //                   top: 12, bottom: 12, left: 5, right: 5),
                    //               child: SvgPicture.asset(
                    //                   "assets/svg/description.svg",
                    //                   color: blackGray),
                    //             ),
                    //     ),

                    //     InkWell(
                    //       onTap: () {
                    //         widget.muddaPost.muddaAction = true;
                    //         widget.muddaPost.muddaDescripation = false;
                    //         muddaNewsController.muddaDescripation.value = false;
                    //         muddaNewsController.muddaAction.value = true;
                    //         muddaNewsController.muddaActionIndex.value =
                    //             widget.index;
                    //       },
                    //       child: muddaNewsController.muddaAction.value ||
                    //               widget.index !=
                    //                   muddaNewsController.muddaActionIndex.value
                    //           ? Container(
                    //               decoration: const BoxDecoration(
                    //                 color: blackGray,
                    //                 borderRadius: BorderRadius.only(
                    //                     topRight: Radius.circular(0),
                    //                     bottomRight: Radius.circular(0),
                    //                     topLeft: Radius.circular(8),
                    //                     bottomLeft: Radius.circular(8)),
                    //               ),
                    //               padding: const EdgeInsets.only(
                    //                   top: 12, bottom: 12, left: 5, right: 5),
                    //               child: SvgPicture.asset(
                    //                   "assets/svg/action.svg",
                    //                   color: white),
                    //             )
                    //           : Container(
                    //               decoration: const BoxDecoration(
                    //                 color: gray,
                    //                 borderRadius: BorderRadius.only(
                    //                     topRight: Radius.circular(0),
                    //                     bottomRight: Radius.circular(0),
                    //                     topLeft: Radius.circular(8),
                    //                     bottomLeft: Radius.circular(8)),
                    //               ),
                    //               padding: const EdgeInsets.only(
                    //                   top: 12, bottom: 12, left: 5, right: 5),
                    //               child: SvgPicture.asset(
                    //                   "assets/svg/action.svg",
                    //                   color: blackGray),
                    //             ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: colorF2F2F2,
            ),
            const Vs(
              height: 8,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.icLocation,
                          width: 9, height: 12),
                      const Hs(width: 4),
                      Text(
                          "${widget.muddaPost.city ?? ""}, ${widget.muddaPost.state ?? ""}, ${widget.muddaPost.country ?? ""}",
                          style: size12_M_normal(textColor: colorDarkBlack)),
                    ],
                  ),
                ),
                SvgPicture.asset(AppIcons.flipCard, width: 10, height: 10),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: colorDarkBlack),
                      ),
                      const Hs(width: 4),
                      Text(
                          convertToAgo(
                              DateTime.parse(widget.muddaPost.createdAt!)),
                          style: size10_M_normal(textColor: colorDarkBlack)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBackCardWithMultipleMedia() {
    return Container(
      height: MediaQuery.of(context).size.height / 4 * 2,
      margin: EdgeInsets.only(
        left: ScreenUtil().setSp(10),
        right: ScreenUtil().setSp(10),
        bottom: ScreenUtil().setSp(32),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(10),
        vertical: ScreenUtil().setSp(12),
      ),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.25),
            offset: const Offset(
              0.0,
              4.0,
            ),
            blurRadius: 4,
            spreadRadius: 0.8,
          ), //BoxShadow//BoxShadow
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.muddaPost.hashtags != null
                ? Wrap(
                    children: widget.muddaPost.hashtags!
                        .map<Widget>((e) => Text(
                              '#$e, ',
                              style: const TextStyle(fontSize: 10),
                            ))
                        .toList(),
                  )
                : const SizedBox.shrink(),
            InkWell(
              onTap: () {
                if (AppPreference().getBool(PreferencesKey.isGuest)) {
                  updateProfileDialog(context);
                } else {
                  Api.post.call(
                    context,
                    method: "mudda/reaction-on-mudda",
                    param: {
                      "user_id": AppPreference()
                          .getString(PreferencesKey.interactUserId),
                      "joining_content_id": widget.muddaPost.sId,
                      "action_type": "follow",
                    },
                    onResponseSuccess: (object) {
                      widget.muddaPost.afterMe = object['data'] != null
                          ? AfterMe.fromJson(object['data'])
                          : null;
                      widget.muddaPost.amIfollowing =
                          widget.muddaPost.amIfollowing == 1 ? 0 : 1;
                      muddaNewsController.muddaPostList[widget.index] =
                          widget.muddaPost;
                      muddaNewsController.muddaActionIndex.value = widget.index;
                    },
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFf2f2f2),
                    borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                    widget.muddaPost.amIfollowing == 0 ? "Follow" : "Following",
                    style: size12_M_normal(textColor: colorDarkBlack)),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: colorDarkBlack),
                ),
                const Hs(width: 4),
                widget.muddaPost.audienceAge != null
                    ? Text(widget.muddaPost.audienceAge!,
                        style: size10_M_normal(textColor: colorDarkBlack))
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
        const Vs(height: 10),
        widget.muddaPost.gallery!.isEmpty
            ? Text(
                'Description: ${widget.muddaPost.muddaDescription.toString().trim()}',
                style: GoogleFonts.nunitoSans(
                    fontSize: ScreenUtil().setSp(12),
                    fontWeight: FontWeight.w400,
                    color: black),
              )
            : ReadMoreText(
                'Description: ${widget.muddaPost.muddaDescription}',
                trimLines: 6,
                trimMode: TrimMode.Line,
                style: GoogleFonts.nunitoSans(
                    fontSize: ScreenUtil().setSp(12),
                    fontWeight: FontWeight.w400,
                    color: black),
              ),
        // RichText(
        //   text: TextSpan(
        //     style: const TextStyle(color: colorDarkBlack, fontSize: 13),
        //     children: <TextSpan>[
        //       Text('Description: ', style: GoogleFonts.nunitoSans(
        //           fontSize: ScreenUtil().setSp(12),
        //           fontWeight: FontWeight.bold,
        //           color: black),),
        //       TextSpan(
        //         text: 'Description: ',
        //         style: GoogleFonts.nunitoSans(
        //           fontWeight: FontWeight.w700,
        //           fontSize: ScreenUtil().setSp(13),
        //         ), // TextStyle(fontWeight: FontWeight.bold),
        //       ), ReadMoreText(
        //         ' ${widget.muddaPost.muddaDescription}',
        //         trimLines: 5,
        //         trimMode: TrimMode.Line,
        //         style: GoogleFonts.nunitoSans(
        //             fontSize: ScreenUtil().setSp(12),
        //             fontWeight: FontWeight.w400,
        //             color: black),
        //       ),
        //
        //       TextSpan(
        //         text: widget.muddaPost.muddaDescription!,
        //         style: GoogleFonts.nunitoSans(
        //           // fontWeight: FontWeight.w700,
        //           fontSize: ScreenUtil().setSp(13),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        const Vs(height: 12),
        widget.muddaPost.gallery!.isEmpty
            ? const SizedBox.shrink()
            : Text(
                'Photo / Video',
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w700,
                  fontSize: ScreenUtil().setSp(12),
                ),
              ),
        widget.muddaPost.gallery!.isEmpty
            ? const SizedBox.shrink()
            : const Divider(),
        widget.muddaPost.gallery!.isEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                height: 120,
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.muddaPost.gallery!.length,
                  itemBuilder: (context, index) {
                    Gallery mediaModelData = widget.muddaPost.gallery![index];

                    return GestureDetector(
                      onTap: () {
                        print("muddaPost.gallery ");
                        print(widget.muddaPost.thumbnail);
                        print(widget.muddaPost.gallery?.length);
                        List<Gallery> list = <Gallery>[];

                        list.add(Gallery(file: widget.muddaPost.thumbnail));
                        list.addAll(widget.muddaPost.gallery!);
                        print(list.length);
                        widget.muddaPost.gallery != null
                            ? muddaGalleryDialog(context, list,
                                muddaNewsController.muddaProfilePath.value, 0)
                            : null;
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Container(
                          height: 100,
                          width: 100,
                          // color: Colors.grey,
                          child: !mediaModelData.file!.contains(".mp4")
                              ? CachedNetworkImage(
                                  // imageBuilder: (context, imageProvider) =>
                                  //     Container(
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.all(
                                  //         Radius.circular(
                                  //             ScreenUtil().setSp(8))),
                                  //     image: DecorationImage(
                                  //         image: imageProvider,
                                  //         fit: BoxFit.cover),
                                  //   ),
                                  // ),
                                  imageUrl:
                                      '${muddaNewsController.muddaProfilePath.value}${mediaModelData.file!}',
                                  fit: BoxFit.cover)
                              : GestureDetector(
                                  onTap: () {
                                    /*setStates(() {
                                      isDialOpen.value = false;
                                      if (visibilityTag) {
                                        visibilityTag = false;
                                      }
                                      hideShowTag = !hideShowTag;
                                    });*/
                                  },
                                  child: VideoPlayerScreen(
                                      mediaModelData.file!,
                                      muddaNewsController
                                          .muddaProfilePath.value,
                                      index,
                                      index,
                                      0,
                                      0,
                                      true,
                                      videoController,
                                      isOnPageHorizontalTurning),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        const Divider(),
        const Spacer(),
        Center(
          child: GestureDetector(
            onTap: () {
              //_switchCard();
            },
            child: SvgPicture.asset(AppIcons.flipCard, width: 10, height: 10),
          ),
        ),
      ]),
    );
  }

  Widget buildBackCardWithSingleMedia() {
    return Container(
      height: MediaQuery.of(context).size.height / 4 * 2,
      margin: EdgeInsets.only(
          left: ScreenUtil().setSp(5),
          right: ScreenUtil().setSp(5),
          bottom: ScreenUtil().setSp(32)),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(10),
      ),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.25),
            offset: const Offset(
              0.0,
              4.0,
            ),
            blurRadius: 4,
            spreadRadius: 0.8,
          ), //BoxShadow//BoxShadow
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Vs(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Photo / Video',
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w700,
                fontSize: ScreenUtil().setSp(10),
              ),
            ),
            InkWell(
              onTap: () {
                if (AppPreference().getBool(PreferencesKey.isGuest)) {
                  updateProfileDialog(context);
                } else {
                  Api.post.call(
                    context,
                    method: "mudda/reaction-on-mudda",
                    param: {
                      "user_id": AppPreference()
                          .getString(PreferencesKey.interactUserId),
                      "joining_content_id": widget.muddaPost.sId,
                      "action_type": "follow",
                    },
                    onResponseSuccess: (object) {
                      widget.muddaPost.afterMe = object['data'] != null
                          ? AfterMe.fromJson(object['data'])
                          : null;
                      widget.muddaPost.amIfollowing =
                          widget.muddaPost.amIfollowing == 1 ? 0 : 1;
                      muddaNewsController.muddaPostList[widget.index] =
                          widget.muddaPost;
                      muddaNewsController.muddaActionIndex.value = widget.index;
                    },
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFf2f2f2),
                    borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                    widget.muddaPost.amIfollowing == 0 ? "Follow" : "Following",
                    style: size12_M_normal(textColor: colorDarkBlack)),
              ),
            ),
          ],
        ),
        const Divider(),
        SizedBox(
            height: 120,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                print("muddaPost.gallery ");
                print(widget.muddaPost.thumbnail);
                print(widget.muddaPost.gallery?.length);
                List<Gallery> list = <Gallery>[];

                list.add(Gallery(file: widget.muddaPost.thumbnail));
                list.addAll(widget.muddaPost.gallery!);
                print(list.length);
                widget.muddaPost.gallery != null
                    ? muddaGalleryDialog(context, list,
                        muddaNewsController.muddaProfilePath.value, 0)
                    : null;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey,
                  child: !widget.muddaPost.gallery![0].file!.contains(".mp4")
                      ? CachedNetworkImage(
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setSp(8))),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fitWidth),
                            ),
                          ),
                          imageUrl:
                              '${muddaNewsController.muddaProfilePath.value}${widget.muddaPost.gallery![0].file!}',
                        )
                      : VideoPlayerScreen(
                          widget.muddaPost.gallery![0].file!,
                          muddaNewsController.muddaProfilePath.value,
                          0,
                          0,
                          0,
                          0,
                          true,
                          videoController,
                          isOnPageHorizontalTurning),
                ),
              ),
            )),
        const Vs(height: 6),
        ReadMoreText(
          'Description: ${widget.muddaPost.muddaDescription}',
          trimLines: 7,
          trimMode: TrimMode.Line,
          style: GoogleFonts.nunitoSans(
              fontSize: ScreenUtil().setSp(12),
              fontWeight: FontWeight.w400,
              color: black),
        ),
        const Spacer(),
        Center(
          child: GestureDetector(
            onTap: () {
              //_switchCard();
            },
            child: SvgPicture.asset(AppIcons.flipCard, width: 10, height: 10),
          ),
        ),
        const Vs(height: 10),
      ]),
    );
  }
}
