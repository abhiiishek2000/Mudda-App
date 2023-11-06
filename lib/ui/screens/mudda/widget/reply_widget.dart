import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/model/RepliesResponseModel.dart';
import 'package:mudda/ui/screens/home_screen/widget/component/hot_mudda_post.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/route_constants.dart';
import '../../../../core/preferences/preference_manager.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../../core/utils/color.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../dio/api/api.dart';
import '../../../../model/PostForMuddaModel.dart';
import '../../home_screen/controller/mudda_fire_news_controller.dart';
import '../view/replies_view.dart';
import 'favour_view.dart';
import 'mudda_post_comment.dart';
import 'oppotion_view.dart';

class ReplyWidget extends StatefulWidget {
  const ReplyWidget({Key? key, required this.postForMudda, required this.index})
      : super(key: key);
  final PostForMudda postForMudda;
  final int index;

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  MuddaNewsController? muddaNewsController;

  @override
  void initState() {
    muddaNewsController = muddaNewsController = Get.find<MuddaNewsController>();
    muddaNewsController?.isLoading.value = true;
    muddaNewsController!.repliesList.clear();
    Api.get.call(context,
        method: "post-for-mudda/replies",
        param: {
          "muddaId": muddaNewsController!.muddaPost.value.sId,
          "parentId": widget.postForMudda.sId,
          "page": "1",
        },
        isLoading: false, onResponseSuccess: (Map object) {
      muddaNewsController!.isLoading.value = false;
      var result = RepliesResponseModel.fromJson(object);
      if (result.result!.isNotEmpty) {
        muddaNewsController!.repliesList.addAll(result.result!);
      } else {}
    });

    super.initState();
  }

  @override
  void dispose() {
    muddaNewsController!.repliesList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          height: muddaNewsController!.height.value,
          width: muddaNewsController!.width.value,
          color: white,
          child: muddaNewsController!.isLoading.value == true
              ? const Center(child: CupertinoActivityIndicator())
              : muddaNewsController!.repliesList.length == 0
                  ? const Center(child: const Text('No Replies Found'))
                  : ListView.builder(
                      padding:
                          const EdgeInsets.only(bottom: 12, top: 12, right: 16),
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: muddaNewsController!.repliesList.length + 1,
                      itemBuilder: (context, int index) {
                        if (muddaNewsController!.repliesList.length == index) {
                          return Center(
                            child: TextButton(
                                onPressed: () {
                                  if (AppPreference()
                                      .getBool(PreferencesKey.isGuest)) {
                                    updateProfileDialog(context);
                                  } else {
                                    muddaNewsController!
                                        .postForMuddaIndex.value = widget.index;
                                    muddaNewsController!.postForMudda.value =
                                        widget.postForMudda;
                                    Get.toNamed(
                                        RouteConstants.muddaContainerReplies);
                                  }
                                },
                                child: const Text('See all Replies')),
                          );
                        } else {
                          PostForMudda postForMudda =
                              muddaNewsController!.repliesList[index];
                          return postForMudda.postIn == "favour"
                              ? Column(
                                  children: [
                                    getSizedBox(h: ScreenUtil().setSp(20)),
                                    MuddaVideoBox(
                                        postForMudda,
                                        muddaNewsController!
                                            .postForMuddaPath.value,
                                        0,
                                        muddaNewsController!
                                            .muddaUserProfilePath.value),
                                    //TODO: favour -FIXED
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 40, right: 16),
                                      child: Obx(() => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  muddaNewsController!
                                                          .isRecentRepliesShow
                                                          .value =
                                                      !muddaNewsController!
                                                          .isRecentRepliesShow
                                                          .value;
                                                  muddaNewsController!
                                                      .currentRecentIndex
                                                      .value = index;
                                                },
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          AppIcons.icReply,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          postForMudda.replies ==
                                                                  null
                                                              ? "-"
                                                              : "${postForMudda.replies}",
                                                          style:
                                                              size12_M_regular(
                                                                  textColor:
                                                                      black),
                                                        ),
                                                      ],
                                                    ),
                                                    Visibility(
                                                      child: SvgPicture.asset(
                                                        AppIcons.icArrowDown,
                                                        color: grey,
                                                      ),
                                                      visible: muddaNewsController!
                                                              .isRecentRepliesShow
                                                              .value &&
                                                          muddaNewsController!
                                                                  .currentRecentIndex
                                                                  .value ==
                                                              index,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  muddaNewsController!
                                                      .postForMudda
                                                      .value = postForMudda;
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return const CommentsPost();
                                                      });
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      // AppIcons.replyIcon,
                                                      AppIcons.iconComments,
                                                      height: 16,
                                                      width: 16,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                        NumberFormat
                                                            .compactCurrency(
                                                          decimalDigits: 0,
                                                          symbol:
                                                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                        ).format(postForMudda
                                                            .commentorsCount),
                                                        style: GoogleFonts
                                                            .nunitoSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                color:
                                                                    blackGray)),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (AppPreference().getBool(
                                                      PreferencesKey.isGuest)) {
                                                    updateProfileDialog(
                                                        context);
                                                  } else {
                                                    Api.post.call(
                                                      context,
                                                      method: "like/store",
                                                      isLoading: false,
                                                      param: {
                                                        "user_id": AppPreference()
                                                            .getString(
                                                                PreferencesKey
                                                                    .interactUserId),
                                                        "relative_id":
                                                            postForMudda.sId,
                                                        "relative_type":
                                                            "PostForMudda",
                                                        "status": false
                                                      },
                                                      onResponseSuccess:
                                                          (object) {
                                                        print(
                                                            "Abhishek $object");
                                                      },
                                                    );
                                                    if (postForMudda
                                                            .agreeStatus ==
                                                        false) {
                                                      postForMudda.agreeStatus =
                                                          null;
                                                      postForMudda
                                                              .dislikersCount =
                                                          postForMudda
                                                                  .dislikersCount! -
                                                              1;
                                                    } else {
                                                      postForMudda
                                                              .dislikersCount =
                                                          postForMudda
                                                                  .dislikersCount! +
                                                              1;
                                                      postForMudda
                                                          .likersCount = postForMudda
                                                                  .likersCount ==
                                                              0
                                                          ? postForMudda
                                                              .likersCount
                                                          : postForMudda
                                                                  .likersCount! -
                                                              1;
                                                      postForMudda.agreeStatus =
                                                          false;
                                                    }
                                                    int pIndex = index;
                                                    muddaNewsController!
                                                        .postForMuddaList
                                                        .removeAt(index);
                                                    muddaNewsController!
                                                        .postForMuddaList
                                                        .insert(pIndex,
                                                            postForMudda);
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        postForMudda.agreeStatus ==
                                                                false
                                                            ? AppIcons
                                                                .dislikeFill
                                                            : AppIcons.dislike,
                                                        height: 16,
                                                        width: 16,
                                                        color: postForMudda
                                                                    .agreeStatus ==
                                                                false
                                                            ? colorF1B008
                                                            : blackGray),
                                                    const SizedBox(width: 5),
                                                    postForMudda.agreeStatus ==
                                                            false
                                                        ? Text(
                                                            "${NumberFormat.compactCurrency(
                                                              decimalDigits: 0,
                                                              symbol:
                                                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                            ).format(postForMudda.dislikersCount)} Disagree",
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight: postForMudda
                                                                            .agreeStatus ==
                                                                        false
                                                                    ? FontWeight
                                                                        .w700
                                                                    : FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                color: postForMudda
                                                                            .agreeStatus ==
                                                                        false
                                                                    ? colorF1B008
                                                                    : blackGray),
                                                          )
                                                        : Text(
                                                            "${NumberFormat.compactCurrency(
                                                              decimalDigits: 0,
                                                              symbol:
                                                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                            ).format(postForMudda.dislikersCount)}",
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight: postForMudda
                                                                            .agreeStatus ==
                                                                        false
                                                                    ? FontWeight
                                                                        .w700
                                                                    : FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                color: postForMudda
                                                                            .agreeStatus ==
                                                                        false
                                                                    ? colorF1B008
                                                                    : blackGray),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (AppPreference().getBool(
                                                      PreferencesKey.isGuest)) {
                                                    updateProfileDialog(
                                                        context);
                                                  } else {
                                                    Api.post.call(
                                                      context,
                                                      method: "like/store",
                                                      isLoading: false,
                                                      param: {
                                                        "user_id": AppPreference()
                                                            .getString(
                                                                PreferencesKey
                                                                    .interactUserId),
                                                        "relative_id":
                                                            postForMudda.sId,
                                                        "relative_type":
                                                            "PostForMudda",
                                                        "status": true
                                                      },
                                                      onResponseSuccess:
                                                          (object) {},
                                                    );
                                                    if (postForMudda
                                                            .agreeStatus ==
                                                        true) {
                                                      postForMudda.agreeStatus =
                                                          null;
                                                      postForMudda.likersCount =
                                                          postForMudda
                                                                  .likersCount! -
                                                              1;
                                                    } else {
                                                      postForMudda.likersCount =
                                                          postForMudda
                                                                  .likersCount! +
                                                              1;
                                                      postForMudda
                                                          .dislikersCount = postForMudda
                                                                  .dislikersCount ==
                                                              0
                                                          ? postForMudda
                                                              .dislikersCount
                                                          : postForMudda
                                                                  .dislikersCount! -
                                                              1;

                                                      postForMudda.agreeStatus =
                                                          true;
                                                    }
                                                    int pIndex = index;
                                                    muddaNewsController!
                                                        .postForMuddaList
                                                        .removeAt(index);
                                                    muddaNewsController!
                                                        .postForMuddaList
                                                        .insert(pIndex,
                                                            postForMudda);
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        postForMudda.agreeStatus ==
                                                                true
                                                            ? AppIcons
                                                                .handIconFill
                                                            : AppIcons.handIcon,
                                                        height: 16,
                                                        width: 16,
                                                        color: postForMudda
                                                                    .agreeStatus ==
                                                                true
                                                            ? color0060FF
                                                            : blackGray),
                                                    const SizedBox(width: 5),
                                                    postForMudda.agreeStatus ==
                                                            true
                                                        ? Text(
                                                            "${NumberFormat.compactCurrency(
                                                              decimalDigits: 0,
                                                              symbol:
                                                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                            ).format(postForMudda.likersCount)} Agree",
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight: postForMudda
                                                                            .agreeStatus ==
                                                                        true
                                                                    ? FontWeight
                                                                        .w700
                                                                    : FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                color: postForMudda
                                                                            .agreeStatus ==
                                                                        true
                                                                    ? color0060FF
                                                                    : blackGray),
                                                          )
                                                        : Text(
                                                            "${NumberFormat.compactCurrency(
                                                              decimalDigits: 0,
                                                              symbol:
                                                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                            ).format(postForMudda.likersCount)}",
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight: postForMudda
                                                                            .agreeStatus ==
                                                                        true
                                                                    ? FontWeight
                                                                        .w700
                                                                    : FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                color: postForMudda
                                                                            .agreeStatus ==
                                                                        true
                                                                    ? color0060FF
                                                                    : blackGray),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    getSizedBox(h: ScreenUtil().setSp(30)),
                                    Obx(() => Visibility(
                                          child: ReplyWidget(
                                            postForMudda: postForMudda,
                                            index: index,
                                          ),
                                          visible: muddaNewsController!
                                                  .isRecentRepliesShow.value &&
                                              muddaNewsController!
                                                      .currentRecentIndex
                                                      .value ==
                                                  index,
                                        ))
                                    // timeText(convertToAgo(
                                    //     DateTime.parse(postForMudda.createdAt!))),
                                    // getSizedBox(h: 20),
                                  ],
                                )
                              : Column(
                                  children: [
                                    getSizedBox(h: ScreenUtil().setSp(20)),
                                    MuddaOppositionVideoBox(
                                        postForMudda,
                                        muddaNewsController!
                                            .postForMuddaPath.value,
                                        index,
                                        muddaNewsController!
                                            .muddaUserProfilePath.value),
                                    // TODO: Opposition - FIXED
                                    Container(
                                      // padding: EdgeInsets.only(
                                      //     left: ScreenUtil().setSp(64),
                                      //     right: ScreenUtil().setSp(19)),
                                      padding: const EdgeInsets.only(
                                          right: 16, left: 16),
                                      margin: const EdgeInsets.only(
                                          left: 0, right: 40),
                                      child: Obx(() => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  muddaNewsController!
                                                          .isRecentRepliesShow
                                                          .value =
                                                      !muddaNewsController!
                                                          .isRecentRepliesShow
                                                          .value;
                                                  muddaNewsController!
                                                      .currentRecentIndex
                                                      .value = index;
                                                },
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          AppIcons.icReply,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          postForMudda.replies ==
                                                                  null
                                                              ? "-"
                                                              : "${postForMudda.replies}",
                                                          style:
                                                              size12_M_regular(
                                                                  textColor:
                                                                      black),
                                                        ),
                                                      ],
                                                    ),
                                                    Visibility(
                                                      child: SvgPicture.asset(
                                                        AppIcons.icArrowDown,
                                                        color: grey,
                                                      ),
                                                      visible: muddaNewsController!
                                                              .isRecentRepliesShow
                                                              .value &&
                                                          muddaNewsController!
                                                                  .currentRecentIndex
                                                                  .value ==
                                                              index,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  muddaNewsController!
                                                      .postForMudda
                                                      .value = postForMudda;
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return const CommentsPost();
                                                      });
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      // AppIcons.replyIcon,
                                                      AppIcons.iconComments,
                                                      height: 16,
                                                      width: 16,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                        NumberFormat
                                                            .compactCurrency(
                                                          decimalDigits: 0,
                                                          symbol:
                                                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                        ).format(postForMudda
                                                            .commentorsCount),
                                                        style: GoogleFonts
                                                            .nunitoSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                color:
                                                                    blackGray)),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (AppPreference().getBool(
                                                      PreferencesKey.isGuest)) {
                                                    updateProfileDialog(
                                                        context);
                                                  } else {
                                                    Api.post.call(
                                                      context,
                                                      method: "like/store",
                                                      isLoading: false,
                                                      param: {
                                                        "user_id": AppPreference()
                                                            .getString(
                                                                PreferencesKey
                                                                    .interactUserId),
                                                        "relative_id":
                                                            postForMudda.sId,
                                                        "relative_type":
                                                            "PostForMudda",
                                                        "status": false,
                                                      },
                                                      onResponseSuccess:
                                                          (object) {
                                                        print(
                                                            "Abhishek $object");
                                                      },
                                                    );
                                                    if (postForMudda
                                                            .agreeStatus ==
                                                        false) {
                                                      postForMudda.agreeStatus =
                                                          null;
                                                      postForMudda
                                                              .dislikersCount =
                                                          postForMudda
                                                                  .dislikersCount! -
                                                              1;
                                                    } else {
                                                      postForMudda
                                                              .dislikersCount =
                                                          postForMudda
                                                                  .dislikersCount! +
                                                              1;
                                                      postForMudda
                                                          .likersCount = postForMudda
                                                                  .likersCount ==
                                                              0
                                                          ? postForMudda
                                                              .likersCount
                                                          : postForMudda
                                                                  .likersCount! -
                                                              1;
                                                      ;
                                                      postForMudda.agreeStatus =
                                                          false;
                                                    }
                                                    int pIndex = index;
                                                    muddaNewsController!
                                                        .postForMuddaList
                                                        .removeAt(index);
                                                    muddaNewsController!
                                                        .postForMuddaList
                                                        .insert(pIndex,
                                                            postForMudda);
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        postForMudda.agreeStatus ==
                                                                false
                                                            ? AppIcons
                                                                .dislikeFill
                                                            : AppIcons.dislike,
                                                        height: 16,
                                                        width: 16,
                                                        color: postForMudda
                                                                    .agreeStatus ==
                                                                false
                                                            ? const Color(
                                                                0xFFF1B008)
                                                            : blackGray),
                                                    const SizedBox(width: 5),
                                                    postForMudda.agreeStatus ==
                                                            false
                                                        ? Text(
                                                            "${NumberFormat.compactCurrency(
                                                              decimalDigits: 0,
                                                              symbol:
                                                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                            ).format(postForMudda.dislikersCount)} Disagree",
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight: postForMudda
                                                                            .agreeStatus ==
                                                                        false
                                                                    ? FontWeight
                                                                        .w700
                                                                    : FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                color: postForMudda
                                                                            .agreeStatus ==
                                                                        false
                                                                    ? const Color(
                                                                        0xFFF1B008)
                                                                    : blackGray),
                                                          )
                                                        : Text(
                                                            "${NumberFormat.compactCurrency(
                                                              decimalDigits: 0,
                                                              symbol:
                                                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                            ).format(postForMudda.dislikersCount)}",
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight: postForMudda
                                                                            .agreeStatus ==
                                                                        false
                                                                    ? FontWeight
                                                                        .w700
                                                                    : FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                color: postForMudda
                                                                            .agreeStatus ==
                                                                        false
                                                                    ? const Color(
                                                                        0xFFF1B008)
                                                                    : blackGray),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (AppPreference().getBool(
                                                      PreferencesKey.isGuest)) {
                                                    updateProfileDialog(
                                                        context);
                                                  } else {
                                                    Api.post.call(
                                                      context,
                                                      method: "like/store",
                                                      isLoading: false,
                                                      param: {
                                                        "user_id": AppPreference()
                                                            .getString(
                                                                PreferencesKey
                                                                    .interactUserId),
                                                        "relative_id":
                                                            postForMudda.sId,
                                                        "relative_type":
                                                            "PostForMudda",
                                                        "status": true
                                                      },
                                                      onResponseSuccess:
                                                          (object) {},
                                                    );
                                                    if (postForMudda
                                                            .agreeStatus ==
                                                        true) {
                                                      postForMudda.agreeStatus =
                                                          null;
                                                      postForMudda.likersCount =
                                                          postForMudda
                                                                  .likersCount! -
                                                              1;
                                                    } else {
                                                      postForMudda.likersCount =
                                                          postForMudda
                                                                  .likersCount! +
                                                              1;
                                                      postForMudda
                                                          .dislikersCount = postForMudda
                                                                  .dislikersCount ==
                                                              0
                                                          ? postForMudda
                                                              .dislikersCount
                                                          : postForMudda
                                                                  .dislikersCount! -
                                                              1;

                                                      postForMudda.agreeStatus =
                                                          true;
                                                    }
                                                    int pIndex = index;
                                                    muddaNewsController!
                                                        .postForMuddaList
                                                        .removeAt(index);
                                                    muddaNewsController!
                                                        .postForMuddaList
                                                        .insert(pIndex,
                                                            postForMudda);
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        postForMudda.agreeStatus ==
                                                                true
                                                            ? AppIcons
                                                                .handIconFill
                                                            : AppIcons.handIcon,
                                                        height: 16,
                                                        width: 16,
                                                        color: postForMudda
                                                                    .agreeStatus ==
                                                                true
                                                            ? const Color(
                                                                0xFF0060FF)
                                                            : blackGray),
                                                    const SizedBox(width: 5),
                                                    postForMudda.agreeStatus ==
                                                            true
                                                        ? Text(
                                                            "${NumberFormat.compactCurrency(
                                                              decimalDigits: 0,
                                                              symbol:
                                                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                            ).format(postForMudda.likersCount)} Agree",
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight: postForMudda
                                                                            .agreeStatus ==
                                                                        true
                                                                    ? FontWeight
                                                                        .w700
                                                                    : FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                color: postForMudda
                                                                            .agreeStatus ==
                                                                        true
                                                                    ? const Color(
                                                                        0xFF0060FF)
                                                                    : blackGray),
                                                          )
                                                        : Text(
                                                            "${NumberFormat.compactCurrency(
                                                              decimalDigits: 0,
                                                              symbol:
                                                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                            ).format(postForMudda.likersCount)}",
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight: postForMudda
                                                                            .agreeStatus ==
                                                                        true
                                                                    ? FontWeight
                                                                        .w700
                                                                    : FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                color: postForMudda
                                                                            .agreeStatus ==
                                                                        true
                                                                    ? const Color(
                                                                        0xFF0060FF)
                                                                    : blackGray),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    getSizedBox(h: ScreenUtil().setSp(30)),
                                    Obx(() => Visibility(
                                          child: ReplyWidget(
                                              postForMudda: postForMudda,
                                              index: index),
                                          visible: muddaNewsController!
                                                  .isRecentRepliesShow.value &&
                                              muddaNewsController!
                                                      .currentRecentIndex
                                                      .value ==
                                                  index,
                                        ))
                                    // timeText(convertToAgo(
                                    //     DateTime.parse(postForMudda.createdAt!))),
                                    // getSizedBox(h: 20),
                                  ],
                                );
                        }
                      },
                    ),
        ));
  }
}
