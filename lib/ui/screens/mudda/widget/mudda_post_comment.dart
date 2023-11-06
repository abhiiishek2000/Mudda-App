import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/PostCommentModel.dart';
import 'package:mudda/model/PostForMuddaModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/home_screen/widget/component/hot_mudda_post.dart';

import 'package:mudda/ui/screens/mudda/view/mudda_details_screen.dart';
import 'package:mudda/ui/shared/keyboard_visibility.dart';
import 'package:mudda/core/constant/app_colors.dart';

import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/shared/report_post_dialog_box.dart';

class MuddaPostCommentsScreen extends GetView {
  MuddaPostCommentsScreen({Key? key}) : super(key: key);
  MuddaNewsController? muddaNewsController;
  ScrollController muddaScrollController = ScrollController();
  int page = 1;

  // int isSelect = 0;

  @override
  Widget build(BuildContext context) {
    muddaNewsController = Get.find<MuddaNewsController>();
    if(Get.arguments !=null){
      muddaNewsController!.quotesOrActivity.value = Get.arguments;
    }
    muddaNewsController!.postForMuddaCommentsList.clear();
    if(Get.arguments !=null){
      muddaNewsController!.quotesOrActivity.value = Get.arguments;
      _getComments(context,muddaNewsController!.quotesOrActivity.value.sId);
    }else{
      _getComments(context,muddaNewsController!.postForMudda.value.sId);
    }

    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        if(Get.arguments !=null){
          muddaNewsController!.quotesOrActivity.value = Get.arguments;
          _getComments(context,muddaNewsController!.quotesOrActivity.value.sId);
        }else{
          _getComments(context,muddaNewsController!.postForMudda.value.sId);
        }
      }
    });
    return Scaffold(
      backgroundColor: colorAppBackground,
      resizeToAvoidBottomInset: true,
      appBar: Get.arguments!=null? PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Text(
                  "Comments (${NumberFormat
                      .compactCurrency(
                    decimalDigits: 0,
                    symbol:
                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                  ).format(muddaNewsController!.quotesOrActivity.value.commentorsCount)})",
                  style: GoogleFonts.nunitoSans(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w700,
                      color: black),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.transparent,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ): null,
      body: KeyboardVisibilityBuilder(
        builder: (context, child, isKeyboardVisible) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Obx(() => ListView.builder(
                          controller: muddaScrollController,
                          itemCount: muddaNewsController!
                              .postForMuddaCommentsList.length,
                          padding:
                              EdgeInsets.only(bottom: ScreenUtil().setSp(80)),
                          itemBuilder: (followersContext, index) {
                            Comments comments = muddaNewsController!
                                .postForMuddaCommentsList[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Wrap(
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            if (comments
                                                                    .userIdentity ==
                                                                0) {
                                                              anynymousDialogBox(
                                                                  context);
                                                            } else {
                                                              if (comments.user!
                                                                      .sId ==
                                                                  AppPreference()
                                                                      .getString(
                                                                          PreferencesKey
                                                                              .userId)) {
                                                                Get.toNamed(
                                                                    RouteConstants
                                                                        .profileScreen,
                                                                    arguments:
                                                                        comments
                                                                            .user!);
                                                              } else {
                                                                Map<String,
                                                                        String>?
                                                                    parameters =
                                                                    {
                                                                  "userDetail":
                                                                      jsonEncode(
                                                                          comments
                                                                              .user!)
                                                                };
                                                                Get.toNamed(
                                                                    RouteConstants
                                                                        .otherUserProfileScreen,
                                                                    parameters:
                                                                        parameters);
                                                              }
                                                            }
                                                          },
                                                    text:
                                                        "${comments.userIdentity == 0 ? "Anonymous" : comments.user!.fullname}:",
                                                    style: size12_M_extraBold(
                                                        textColor:
                                                            Colors.black),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " ${comments.commentText}",
                                                    style: size12_M_normal(
                                                        textColor:
                                                            Colors.black),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " ${convertToAgo(DateTime.parse(comments.createdAt!))}",
                                                    style: size12_M_normal(
                                                        textColor: Colors.grey),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            print(AppPreference().getString(
                                                PreferencesKey.userId));
                                            print("asddf" +
                                                comments.user!.sId.toString());
                                            if (comments.user!.sId ==
                                                AppPreference().getString(
                                                    PreferencesKey.userId)) {
                                              reportPostCommentWithDeleteDialogBox(
                                                      context,
                                                      comments.sId!,
                                                      muddaNewsController!
                                                          .quotesOrActivity
                                                          .value
                                                          .sId!)
                                                  .then((value) {
                                                if (value == true) {
                                                  muddaNewsController!
                                                      .postForMuddaCommentsList
                                                      .removeAt(index);
                                                }
                                              });
                                            } else {
                                              muddaNewsController!.commentDetails.value = comments;
                                              reportPostCommentDialogBox(
                                                  context,
                                                  comments.sId!,
                                                  muddaNewsController!
                                                      .quotesOrActivity.value.sId!);
                                            }
                                          },
                                          child: const Icon(
                                              Icons.more_vert_outlined,
                                              color: Color(0xff606060),
                                              size: 20))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          if (AppPreference().getBool(
                                              PreferencesKey.isGuest)) {
                                            updateProfileDialog(context);
                                          } else {
                                            Api.post.call(
                                              context,
                                              method: "like/store",
                                              isLoading: false,
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(PreferencesKey
                                                        .interactUserId),
                                                "relative_id": comments.sId,
                                                "relative_type": "Comments",
                                                "status": false,
                                              },
                                              onResponseSuccess: (object) {
                                                print("Abhishek $object");
                                              },
                                            );
                                            if (comments.agreeStatus == false) {
                                              comments.agreeStatus = null;
                                              comments.dislikersCount =
                                                  comments.dislikersCount! - 1;
                                            } else {
                                              comments.dislikersCount =
                                                  comments.dislikersCount! + 1;
                                              comments.likersCount =
                                                  comments.likersCount == 0
                                                      ? comments.likersCount
                                                      : comments.likersCount! -
                                                          1;
                                              comments.agreeStatus = false;
                                            }
                                            int pIndex = index;
                                            muddaNewsController!
                                                .postForMuddaCommentsList
                                                .removeAt(index);
                                            muddaNewsController!
                                                .postForMuddaCommentsList
                                                .insert(pIndex, comments);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              NumberFormat.compactCurrency(
                                                decimalDigits: 0,
                                                symbol:
                                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                                              ).format(
                                                  comments.dislikersCount ?? 0),
                                              style: size12_M_normal(
                                                  textColor: Colors.black),
                                            ),
                                            getSizedBox(w: 5),
                                            Image.asset(
                                              AppIcons.disLikeThumb,
                                              height: 16,
                                              width: 16,
                                              color:
                                                  comments.agreeStatus == false
                                                      ? color0060FF
                                                      : const Color(0xffA0A0A0),
                                            )
                                          ],
                                        ),
                                      ),
                                      getSizedBox(w: 15),
                                      InkWell(
                                        onTap: () {
                                          if (AppPreference().getBool(
                                              PreferencesKey.isGuest)) {
                                            updateProfileDialog(context);
                                          } else {
                                            Api.post.call(
                                              context,
                                              method: "like/store",
                                              isLoading: false,
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(PreferencesKey
                                                        .interactUserId),
                                                "relative_id": comments.sId,
                                                "relative_type": "Comments",
                                                "status": true
                                              },
                                              onResponseSuccess: (object) {
                                                print("Abhishek $object");
                                              },
                                            );
                                            if (comments.agreeStatus == true) {
                                              comments.agreeStatus = null;
                                              comments.likersCount =
                                                  comments.likersCount! - 1;
                                            } else {
                                              comments.likersCount =
                                                  comments.likersCount! + 1;
                                              comments.dislikersCount =
                                                  comments.dislikersCount == 0
                                                      ? comments.dislikersCount
                                                      : comments
                                                              .dislikersCount! -
                                                          1;

                                              comments.agreeStatus = true;
                                            }
                                            int pIndex = index;
                                            muddaNewsController!
                                                .postForMuddaCommentsList
                                                .removeAt(index);
                                            muddaNewsController!
                                                .postForMuddaCommentsList
                                                .insert(pIndex, comments);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              NumberFormat.compactCurrency(
                                                decimalDigits: 0,
                                                symbol:
                                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                                              ).format(
                                                  comments.likersCount ?? 0),
                                              style: size12_M_normal(
                                                  textColor: Colors.black),
                                            ),
                                            getSizedBox(w: 5),
                                            Image.asset(
                                              AppIcons.likeThumb,
                                              height: 16,
                                              width: 16,
                                              color:
                                                  comments.agreeStatus == true
                                                      ? color0060FF
                                                      : const Color(0xffA0A0A0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Divider(
                                    color: white,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            );
                          }))),
                 if(Get.arguments !=null ) GestureDetector(
                    onTap: (){
                      if (AppPreference().getBool(PreferencesKey.isGuest)) {
                        updateProfileDialog(context);
                      } else {
                        textFiledFavourBottomFiled();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      width: Get.width,
                      height: 40,
                      decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: blackGray,width: 1),
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Write your comment...",style: size12_M_regular(textColor: black81)),
                          Image.asset(
                            AppIcons.rightSizeArrow,
                            color: colorGrey,
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Positioned(
              //   right: 1,
              //   bottom: 30,
              //   child: GestureDetector(
              //     onTap: () {
              //       if (AppPreference().getBool(PreferencesKey.isGuest)) {
              //         Get.toNamed(RouteConstants.userProfileEdit);
              //       } else {
              //         textFiledFavourBottomFiled();
              //       }
              //     },
              //     child: Container(
              //       height: 40,
              //       width: 50,
              //       alignment: Alignment.center,
              //       child: Image.asset(AppIcons.leftSizeArrow,
              //           height: 20, width: 20),
              //       decoration: BoxDecoration(
              //         color: color606060.withOpacity(0.75),
              //         borderRadius: const BorderRadius.only(
              //           topLeft: Radius.circular(16),
              //           bottomLeft: Radius.circular(16),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Positioned(
              //         left: 1,
              //         bottom: 30,
              //         child: GestureDetector(
              //           onTap: () {
              //             if (AppPreference().getBool(PreferencesKey.isGuest)) {
              //               Get.toNamed(RouteConstants.userProfileEdit);
              //             } else {
              //               textFiledOppositionBottomFiled();
              //             }
              //           },
              //           child: Container(
              //             height: 40,
              //             width: 50,
              //             alignment: Alignment.center,
              //             child: Image.asset(AppIcons.rightSizeArrow,
              //                 height: 20, width: 20),
              //             decoration: BoxDecoration(
              //               color: color606060.withOpacity(0.75),
              //               borderRadius: const BorderRadius.only(
              //                 topRight: Radius.circular(16),
              //                 bottomRight: Radius.circular(16),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
            ],
          );
        },
      ),
    );
  }

  _getComments(BuildContext context,String? id) async {
    Api.get.call(context,
        method: "comment/index",
        param: {
          "page": page.toString(),
          "relative_id":id,
          "filter_user_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = PostCommentModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        muddaNewsController!.postForMuddaCommentsList.addAll(result.data!);
      } else {
        page = page > 1 ? page - 1 : page;
      }
    });
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hr ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} sec ago';
    } else {
      return 'just now';
    }
  }

  textFiledFavourBottomFiled() {
    return showModalBottomSheet(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return KeyboardVisibilityBuilder(
          builder: (context, child, isKeyboardVisible) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                height: isKeyboardVisible
                    ? 100 + MediaQuery.of(context).viewInsets.bottom
                    : 100,
                width: Get.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFf7f7f7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (text) {
                          muddaNewsController!.comment.value = text;
                        },
                        style: size14_M_normal(textColor: color606060),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          hintText:
                              "Help your audience know your Vision max 30 words",
                          border: InputBorder.none,
                          hintStyle: size14_M_normal(textColor: color606060),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: isKeyboardVisible
                          ? 100 + MediaQuery.of(context).viewInsets.bottom
                          : 100,
                      child: const VerticalDivider(
                        width: 1,
                        color: darkGray,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: () {
                              Api.post.call(context,
                                  method: "comment/store",
                                  param: {
                                    "relative_id": muddaNewsController!
                                        .quotesOrActivity.value.sId,
                                    "user_id": AppPreference().getString(
                                        PreferencesKey.interactUserId),
                                    "relative_type": "QuoteOrActivity",
                                    "comment_type": "favour",
                                    "user_identity": muddaNewsController!
                                        .selectedFavourRole.value,
                                    "commentText":
                                        muddaNewsController!.comment.value,
                                  },
                                  isLoading: true,
                                  onResponseSuccess: (Map object) {
                                var result = Comments.fromJson(object['data']);
                                muddaNewsController!.postForMuddaCommentsList
                                    .insert(0, result);
                                Get.back();
                              });
                            },
                            child: Image.asset(AppIcons.rightSizeArrow,
                                color: Colors.grey, height: 18, width: 18),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setSp(13),
                        ),
                        InkWell(
                          onTap: () {
                            muddaNewsController!.selectedFavourRole.value =
                                muddaNewsController!.selectedFavourRole.value ==
                                        "1"
                                    ? "0"
                                    : "1";
                          },
                          child: Obx(
                            () => muddaNewsController!
                                        .selectedFavourRole.value ==
                                    "1"
                                ? AppPreference()
                                        .getString(PreferencesKey.profile)
                                        .isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.profile)}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: ScreenUtil().setSp(40),
                                          height: ScreenUtil().setSp(40),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(ScreenUtil().setSp(
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
                                        errorWidget: (context, url, error) =>
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
                                              AppPreference()
                                                  .getString(PreferencesKey
                                                      .fullName)[0]
                                                  .toUpperCase(),
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(16),
                                                  color: black)),
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
                                      child: Text("A",
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(16),
                                              color: black)),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    getSizedBox(w: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  textFiledOppositionBottomFiled() {
    return showModalBottomSheet(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return KeyboardVisibilityBuilder(
          builder: (context, child, isKeyboardVisible) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                height: isKeyboardVisible
                    ? 100 + MediaQuery.of(context).viewInsets.bottom
                    : 100,
                width: Get.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFf7f7f7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (text) {
                          muddaNewsController!.comment.value = text;
                        },
                        style: size14_M_normal(textColor: color606060),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          hintText:
                              "Help your audience know your Vision max 30 words",
                          border: InputBorder.none,
                          hintStyle: size14_M_normal(textColor: color606060),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: isKeyboardVisible
                          ? 100 + MediaQuery.of(context).viewInsets.bottom
                          : 100,
                      child: const VerticalDivider(
                        width: 1,
                        color: darkGray,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: () {
                              Api.post.call(context,
                                  method: "comment/store",
                                  param: {
                                    "relative_id": muddaNewsController!
                                        .quotesOrActivity.value.sId,
                                    "user_id": AppPreference().getString(
                                        PreferencesKey.interactUserId),
                                    "relative_type": "QuoteOrActivity",
                                    "comment_type": "opposition",
                                    "user_identity": muddaNewsController!
                                        .selectedOppositionRole.value,
                                    "commentText":
                                        muddaNewsController!.comment.value,
                                  },
                                  isLoading: true,
                                  onResponseSuccess: (Map object) {
                                var result = Comments.fromJson(object['data']);
                                muddaNewsController!.postForMuddaCommentsList
                                    .insert(0, result);
                                Get.back();
                              });
                            },
                            child: Image.asset(AppIcons.rightSizeArrow,
                                color: Colors.grey, height: 18, width: 18),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setSp(13),
                        ),
                        InkWell(
                          onTap: () {
                            muddaNewsController!.selectedOppositionRole.value =
                                muddaNewsController!
                                            .selectedOppositionRole.value ==
                                        "1"
                                    ? "0"
                                    : "1";
                          },
                          child: Obx(
                            () => muddaNewsController!
                                        .selectedOppositionRole.value ==
                                    "1"
                                ? AppPreference()
                                        .getString(PreferencesKey.profile)
                                        .isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.profile)}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: ScreenUtil().setSp(40),
                                          height: ScreenUtil().setSp(40),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(ScreenUtil().setSp(
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
                                        errorWidget: (context, url, error) =>
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
                                              AppPreference()
                                                  .getString(PreferencesKey
                                                      .fullName)[0]
                                                  .toUpperCase(),
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(16),
                                                  color: black)),
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
                                      child: Text("A",
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(16),
                                              color: black)),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    getSizedBox(w: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CommentsScreen extends GetView {
  CommentsScreen({Key? key}) : super(key: key);
  MuddaNewsController? muddaNewsController;
  ScrollController muddaScrollController = ScrollController();
  int page = 1;

  @override
  Widget build(BuildContext context) {
    muddaNewsController = Get.find<MuddaNewsController>();
    muddaNewsController!.postForMuddaCommentsList.clear();
    _getComments(context);
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        _getComments(context);
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Obx(() => Text(
              "Comments: (${NumberFormat.compactCurrency(
                decimalDigits: 0,
                symbol:
                    '', // if you want to add currency symbol then pass that in this else leave it empty.
              ).format(muddaNewsController!.quotesOrActivity.value.commentorsCount)})",
              style: size15_M_bold(textColor: Colors.black),
            )),
      ),
      body: KeyboardVisibilityBuilder(
        builder: (context, child, isKeyboardVisible) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Obx(() => ListView.builder(
                          controller: muddaScrollController,
                          itemCount: muddaNewsController!
                              .postForMuddaCommentsList.length,
                          padding:
                              EdgeInsets.only(bottom: ScreenUtil().setSp(80)),
                          itemBuilder: (followersContext, index) {
                            Comments comments = muddaNewsController!
                                .postForMuddaCommentsList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Wrap(
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            if (comments
                                                                    .userIdentity ==
                                                                0) {
                                                              anynymousDialogBox(
                                                                  context);
                                                            } else {
                                                              if (comments.user!
                                                                      .sId ==
                                                                  AppPreference()
                                                                      .getString(
                                                                          PreferencesKey
                                                                              .userId)) {
                                                                Get.toNamed(
                                                                    RouteConstants
                                                                        .profileScreen,
                                                                    arguments:
                                                                        comments
                                                                            .user!);
                                                              } else {
                                                                Map<String,
                                                                        String>?
                                                                    parameters =
                                                                    {
                                                                  "userDetail":
                                                                      jsonEncode(
                                                                          comments
                                                                              .user!)
                                                                };
                                                                Get.toNamed(
                                                                    RouteConstants
                                                                        .otherUserProfileScreen,
                                                                    parameters:
                                                                        parameters);
                                                              }
                                                            }
                                                          },
                                                    text:
                                                        "${comments.userIdentity == 0 ? "Anonymous" : comments.user!.fullname}:",
                                                    style: size12_M_extraBold(
                                                        textColor:
                                                            Colors.black),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " ${comments.commentText}",
                                                    style: size12_M_normal(
                                                        textColor:
                                                            Colors.black),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " ${convertToAgo(DateTime.parse(comments.createdAt!))}",
                                                    style: size12_M_normal(
                                                        textColor: Colors.grey),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {

                                            print(AppPreference().getString(
                                                PreferencesKey.userId));
                                            print("dewcdcer" +
                                                comments.user!.sId.toString());
                                            if (comments.user!.sId ==
                                                AppPreference().getString(
                                                    PreferencesKey.userId)) {
                                              reportPostCommentWithDeleteDialogBox(
                                                      context,
                                                      comments.sId!,
                                                      muddaNewsController!
                                                          .postForMudda
                                                          .value
                                                          .sId!)
                                                  .then((value) {
                                                if (value == true) {
                                                  muddaNewsController!
                                                      .postForMuddaCommentsList
                                                      .removeAt(index);
                                                }
                                              });
                                            } else {
                                              muddaNewsController!.commentDetails.value = comments;
                                              reportPostCommentDialogBox(
                                                  context,
                                                  comments.sId!,
                                                  muddaNewsController!
                                                      .quotesOrActivity.value.sId!);
                                            }
                                          },
                                          child: const Icon(
                                              Icons.more_vert_outlined,
                                              color: Color(0xff606060)))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        comments.commentType != null
                                            ? "${comments.commentType![0].toUpperCase()}${comments.commentType!.substring(1).toLowerCase()}"
                                            : "",
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(12),
                                            color: comments.commentType ==
                                                    "opposition"
                                                ? buttonYellow
                                                : Colors.blue),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          if (AppPreference().getBool(
                                              PreferencesKey.isGuest)) {
                                            updateProfileDialog(context);
                                          } else {
                                            Api.post.call(
                                              context,
                                              method: "like/store",
                                              isLoading: false,
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(PreferencesKey
                                                        .interactUserId),
                                                "relative_id": comments.sId,
                                                "relative_type": "Comments",
                                                "status": true,
                                              },
                                              onResponseSuccess: (object) {
                                                print("Abhishek $object");
                                              },
                                            );

                                            if (comments.agreeStatus == true) {
                                              comments.agreeStatus = null;
                                              comments.likersCount =
                                                  comments.likersCount! - 1;
                                            } else {
                                              comments.likersCount =
                                                  comments.likersCount! + 1;
                                              comments.dislikersCount =
                                                  comments.dislikersCount == 0
                                                      ? comments.dislikersCount
                                                      : comments
                                                              .dislikersCount! -
                                                          1;

                                              comments.agreeStatus = true;
                                            }

                                            int pIndex = index;
                                            muddaNewsController!
                                                .postForMuddaCommentsList
                                                .removeAt(index);
                                            muddaNewsController!
                                                .postForMuddaCommentsList
                                                .insert(pIndex, comments);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              NumberFormat.compactCurrency(
                                                decimalDigits: 0,
                                                symbol:
                                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                                              ).format(
                                                  comments.likersCount ?? 0),
                                              style: size12_M_normal(
                                                  textColor: Colors.black),
                                            ),
                                            getSizedBox(w: 5),
                                            Image.asset(
                                              AppIcons.likeThumb,
                                              height: 18,
                                              width: 18,
                                              color:
                                                  comments.agreeStatus == true
                                                      ? colorBlack
                                                      : color0060FF,
                                            ),
                                          ],
                                        ),
                                      ),
                                      getSizedBox(w: 15),
                                      InkWell(
                                        onTap: () {
                                          if (AppPreference().getBool(
                                              PreferencesKey.isGuest)) {
                                            updateProfileDialog(context);
                                          } else {
                                            Api.post.call(
                                              context,
                                              method: "like/store",
                                              isLoading: false,
                                              param: {
                                                "user_id": AppPreference()
                                                    .getString(PreferencesKey
                                                        .interactUserId),
                                                "relative_id": comments.sId,
                                                "relative_type": "Comments",
                                                "status": false,
                                              },
                                              onResponseSuccess: (object) {
                                                print("Abhishek $object");
                                              },
                                            );
                                            if (comments.agreeStatus == true) {
                                              comments.agreeStatus = null;
                                              comments.likersCount =
                                                  comments.likersCount! - 1;
                                            } else {
                                              comments.likersCount =
                                                  comments.likersCount! + 1;
                                              comments.dislikersCount =
                                                  comments.dislikersCount == 0
                                                      ? comments.dislikersCount
                                                      : comments
                                                              .dislikersCount! -
                                                          1;

                                              comments.agreeStatus = true;
                                            }
                                            int pIndex = index;
                                            muddaNewsController!
                                                .postForMuddaCommentsList
                                                .removeAt(index);
                                            muddaNewsController!
                                                .postForMuddaCommentsList
                                                .insert(pIndex, comments);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              NumberFormat.compactCurrency(
                                                decimalDigits: 0,
                                                symbol:
                                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                                              ).format(
                                                  comments.dislikersCount ?? 0),
                                              style: size12_M_normal(
                                                  textColor: Colors.black),
                                            ),
                                            getSizedBox(w: 5),
                                            Image.asset(
                                              AppIcons.disLikeThumb,
                                              height: 18,
                                              width: 18,
                                              color:
                                                  comments.agreeStatus == false
                                                      ? colorBlack
                                                      : color0060FF,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Divider(
                                    color: grey,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            );
                          }))),
                ],
              ),
              Positioned(
                right: 1,
                bottom: 30,
                child: GestureDetector(
                  onTap: () {
                    if (AppPreference().getBool(PreferencesKey.isGuest)) {
                      updateProfileDialog(context);
                    } else {
                      // textFiledFavourBottomFiled();
                      showModalBottomSheet(
                        context: Get.context as BuildContext,
                        builder: (BuildContext context) {
                          return const CommentsPost();
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 50,
                    alignment: Alignment.center,
                    child: Image.asset(
                      AppIcons.rightSizeArrow,
                      height: 20,
                      width: 20,
                      color: white,
                    ),
                    decoration: BoxDecoration(
                      color: color606060.withOpacity(0.75),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned(
              //         left: 1,
              //         bottom: 30,
              //         child: GestureDetector(
              //           onTap: () {
              //             if (AppPreference().getBool(PreferencesKey.isGuest)) {
              //               Get.toNamed(RouteConstants.userProfileEdit);
              //             } else {
              //               textFiledOppositionBottomFiled();
              //             }
              //           },
              //           child: Container(
              //             height: 40,
              //             width: 50,
              //             alignment: Alignment.center,
              //             child: Image.asset(AppIcons.rightSizeArrow,
              //                 height: 20, width: 20),
              //             decoration: BoxDecoration(
              //               color: color606060.withOpacity(0.75),
              //               borderRadius: const BorderRadius.only(
              //                 topRight: Radius.circular(16),
              //                 bottomRight: Radius.circular(16),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
            ],
          );
        },
      ),
    );
  }

  _getComments(BuildContext context) async {
    Api.get.call(context,
        method: "comment/index",
        param: {
          "page": page.toString(),
          "relative_id": muddaNewsController!.quotesOrActivity.value.sId,
          "filter_user_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = PostCommentModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        muddaNewsController!.postForMuddaCommentsList.clear();
        muddaNewsController!.postForMuddaCommentsList.addAll(result.data!);
      } else {
        page = page > 1 ? page - 1 : page;
      }
    });
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hr ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} sec ago';
    } else {
      return 'just now';
    }
  }

  textFiledFavourBottomFiled() {
    return showModalBottomSheet(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return KeyboardVisibilityBuilder(
          builder: (context, child, isKeyboardVisible) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                height: isKeyboardVisible
                    ? 150 + MediaQuery.of(context).viewInsets.bottom
                    : 150,
                width: Get.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFf7f7f7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            onChanged: (text) {
                              muddaNewsController!.comment.value = text;
                            },
                            style: size14_M_normal(textColor: color606060),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              hintText:
                                  "Help your audience know your Vision max 30 words",
                              border: InputBorder.none,
                              hintStyle:
                                  size14_M_normal(textColor: color606060),
                            ),
                          ),
                          const Divider(
                            color: darkGray,
                            thickness: 0.5,
                            height: 16,
                            indent: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  muddaNewsController!.isSelectComment.value =
                                      0;
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: 18,
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: black),
                                      ),
                                      child: muddaNewsController!
                                                  .isSelectComment.value ==
                                              0
                                          ? Container(
                                              margin: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                color: black,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ),
                                    Text(
                                      "Favour",
                                      style: size14_M_medium(textColor: black),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  muddaNewsController!.isSelectComment.value =
                                      1;
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: 18,
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: black),
                                      ),
                                      child: muddaNewsController!
                                                  .isSelectComment.value ==
                                              1
                                          ? Container(
                                              margin: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                color: black,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ),
                                    Text(
                                      "Opposition",
                                      style: size14_M_medium(textColor: black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: isKeyboardVisible
                          ? 130 + MediaQuery.of(context).viewInsets.bottom
                          : 130,
                      child: const VerticalDivider(
                        width: 1,
                        color: darkGray,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: () {
                              Api.post.call(context,
                                  method: "comment/store",
                                  param: {
                                    "relative_id": muddaNewsController!
                                        .quotesOrActivity.value.sId,
                                    "user_id": AppPreference().getString(
                                        PreferencesKey.interactUserId),
                                    "relative_type": "QuoteOrActivity",
                                    "user_identity": muddaNewsController!
                                        .selectedFavourRole.value,
                                    "commentText":
                                        muddaNewsController!.comment.value,
                                  },
                                  isLoading: true,
                                  onResponseSuccess: (Map object) {
                                var result = Comments.fromJson(object['data']);
                                muddaNewsController!.postForMuddaCommentsList
                                    .insert(0, result);
                                Get.back();
                              });
                            },
                            child: Image.asset(AppIcons.rightSizeArrow,
                                color: Colors.grey, height: 18, width: 18),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setSp(20),
                        ),
                        InkWell(
                          onTap: () {
                            muddaNewsController!.selectedFavourRole.value =
                                muddaNewsController!.selectedFavourRole.value ==
                                        "1"
                                    ? "0"
                                    : "1";
                          },
                          child: Obx(
                            () => muddaNewsController!
                                        .selectedFavourRole.value ==
                                    "1"
                                ? AppPreference()
                                        .getString(PreferencesKey.profile)
                                        .isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.profile)}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: ScreenUtil().setSp(40),
                                          height: ScreenUtil().setSp(40),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(ScreenUtil().setSp(
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
                                        errorWidget: (context, url, error) =>
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
                                              AppPreference()
                                                  .getString(PreferencesKey
                                                      .fullName)[0]
                                                  .toUpperCase(),
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(16),
                                                  color: black)),
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
                                      child: Text("A",
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(16),
                                              color: black)),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    getSizedBox(w: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  textFiledOppositionBottomFiled() {
    return showModalBottomSheet(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return KeyboardVisibilityBuilder(
          builder: (context, child, isKeyboardVisible) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                height: isKeyboardVisible
                    ? 100 + MediaQuery.of(context).viewInsets.bottom
                    : 100,
                width: Get.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFf7f7f7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (text) {
                          muddaNewsController!.comment.value = text;
                        },
                        style: size14_M_normal(textColor: color606060),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          hintText:
                              "Help your audience know your Vision max 30 words",
                          border: InputBorder.none,
                          hintStyle: size14_M_normal(textColor: color606060),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: isKeyboardVisible
                          ? 100 + MediaQuery.of(context).viewInsets.bottom
                          : 100,
                      child: const VerticalDivider(
                        width: 1,
                        color: darkGray,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: () {
                              Api.post.call(context,
                                  method: "comment/store",
                                  param: {
                                    "relative_id": muddaNewsController!
                                        .quotesOrActivity.value.sId,
                                    "user_id": AppPreference().getString(
                                        PreferencesKey.interactUserId),
                                    "relative_type": "QuoteOrActivity",
                                    "user_identity": muddaNewsController!
                                        .selectedOppositionRole.value,
                                    "commentText":
                                        muddaNewsController!.comment.value,
                                  },
                                  isLoading: true,
                                  onResponseSuccess: (Map object) {
                                var result = Comments.fromJson(object['data']);
                                muddaNewsController!.postForMuddaCommentsList
                                    .insert(0, result);
                                Get.back();
                              });
                            },
                            child: Image.asset(AppIcons.rightSizeArrow,
                                color: Colors.grey, height: 18, width: 18),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setSp(13),
                        ),
                        InkWell(
                          onTap: () {
                            muddaNewsController!.selectedOppositionRole.value =
                                muddaNewsController!
                                            .selectedOppositionRole.value ==
                                        "1"
                                    ? "0"
                                    : "1";
                          },
                          child: Obx(
                            () => muddaNewsController!
                                        .selectedOppositionRole.value ==
                                    "1"
                                ? AppPreference()
                                        .getString(PreferencesKey.profile)
                                        .isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.profile)}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: ScreenUtil().setSp(40),
                                          height: ScreenUtil().setSp(40),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(ScreenUtil().setSp(
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
                                        errorWidget: (context, url, error) =>
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
                                              AppPreference()
                                                  .getString(PreferencesKey
                                                      .fullName)[0]
                                                  .toUpperCase(),
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(16),
                                                  color: black)),
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
                                      child: Text("A",
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(16),
                                              color: black)),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    getSizedBox(w: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CommentsPost extends StatefulWidget {
  const CommentsPost({Key? key}) : super(key: key);

  @override
  State<CommentsPost> createState() => _CommentsPostState();
}

class _CommentsPostState extends State<CommentsPost> {
  MuddaNewsController muddaNewsController = Get.put(MuddaNewsController());

  // @override
  // void initState() {
  //   super.initState();
  //   muddaNewsController.isSelectComment.refresh();
  // }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Container(
            height: isKeyboardVisible
                ? 150 + MediaQuery.of(context).viewInsets.bottom
                : 150,
            width: Get.width,
            decoration: BoxDecoration(
                color: const Color(0xFFf7f7f7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onChanged: (text) {
                          muddaNewsController.comment.value = text;
                        },
                        style: size14_M_normal(textColor: color606060),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          hintText:
                              "Help your audience know your Vision max 30 words",
                          border: InputBorder.none,
                          hintStyle: size14_M_normal(textColor: color606060),
                        ),
                      ),
                      const Divider(
                        color: darkGray,
                        thickness: 0.3,
                        height: 16,
                        indent: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              muddaNewsController.isSelectComment.value = 0;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 18,
                                  width: 18,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: black),
                                  ),
                                  child: muddaNewsController
                                              .isSelectComment.value ==
                                          0
                                      ? Container(
                                          margin: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: black,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                                Text(
                                  "Favour",
                                  style: size14_M_medium(textColor: black),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {
                              muddaNewsController.isSelectComment.value = 1;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 18,
                                  width: 18,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: black),
                                  ),
                                  child: muddaNewsController
                                              .isSelectComment.value ==
                                          1
                                      ? Container(
                                          margin: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: black,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                                Text(
                                  "Opposition",
                                  style: size14_M_medium(textColor: black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: isKeyboardVisible
                      ? 130 + MediaQuery.of(context).viewInsets.bottom
                      : 130,
                  child: const VerticalDivider(
                    width: 1,
                    color: darkGray,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          if (muddaNewsController.isSelectComment.value == 0) {
                            Api.post.call(context,
                                method: "comment/store",
                                param: {
                                  "relative_id": muddaNewsController
                                      .postForMudda.value.sId,
                                  "user_id": AppPreference()
                                      .getString(PreferencesKey.interactUserId),
                                  "relative_type": "PostForMudda",
                                  "comment_type": "favour",
                                  "user_identity": muddaNewsController
                                      .selectedFavourRole.value,
                                  "commentText":
                                      muddaNewsController.comment.value,
                                },
                                isLoading: true,
                                onResponseSuccess: (Map object) {
                              var result = Comments.fromJson(object['data']);
                              muddaNewsController.postForMuddaCommentsList
                                  .insert(0, result);
                              Get.back();
                            });
                          } else {
                            Api.post.call(context,
                                method: "comment/store",
                                param: {
                                  "relative_id": muddaNewsController
                                      .quotesOrActivity.value.sId,
                                  "user_id": AppPreference()
                                      .getString(PreferencesKey.interactUserId),
                                  "relative_type": "PostForMudda",
                                  "comment_type": "opposition",
                                  "user_identity": muddaNewsController
                                      .selectedOppositionRole.value,
                                  "commentText":
                                      muddaNewsController.comment.value,
                                },
                                isLoading: true,
                                onResponseSuccess: (Map object) {
                              var result = Comments.fromJson(object['data']);
                              muddaNewsController.postForMuddaCommentsList
                                  .insert(0, result);
                              Get.back();
                            });
                          }
                        },
                        child: Image.asset(AppIcons.rightSizeArrow,
                            color: Colors.grey, height: 18, width: 18),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setSp(20),
                    ),
                    muddaNewsController.isSelectComment.value == 0
                        ? InkWell(
                            onTap: () {
                              muddaNewsController.selectedFavourRole.value =
                                  muddaNewsController
                                              .selectedFavourRole.value ==
                                          "1"
                                      ? "0"
                                      : "1";
                            },
                            child: Obx(
                              () => muddaNewsController
                                          .selectedFavourRole.value ==
                                      "1"
                                  ? AppPreference()
                                          .getString(PreferencesKey.profile)
                                          .isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.profile)}",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: ScreenUtil().setSp(40),
                                            height: ScreenUtil().setSp(40),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setSp(
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
                                          errorWidget: (context, url, error) =>
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
                                                AppPreference()
                                                    .getString(PreferencesKey
                                                        .fullName)[0]
                                                    .toUpperCase(),
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        ScreenUtil().setSp(16),
                                                    color: black)),
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
                                        child: Text("A",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(16),
                                                color: black)),
                                      ),
                                    ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              muddaNewsController.selectedOppositionRole.value =
                                  muddaNewsController
                                              .selectedOppositionRole.value ==
                                          "1"
                                      ? "0"
                                      : "1";
                            },
                            child: Obx(
                              () => muddaNewsController
                                          .selectedOppositionRole.value ==
                                      "1"
                                  ? AppPreference()
                                          .getString(PreferencesKey.profile)
                                          .isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.profile)}",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: ScreenUtil().setSp(40),
                                            height: ScreenUtil().setSp(40),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setSp(
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
                                          errorWidget: (context, url, error) =>
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
                                                AppPreference()
                                                    .getString(PreferencesKey
                                                        .fullName)[0]
                                                    .toUpperCase(),
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        ScreenUtil().setSp(16),
                                                    color: black)),
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
                                        child: Text("A",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(16),
                                                color: black)),
                                      ),
                                    ),
                            ),
                          ),
                  ],
                ),
                getSizedBox(w: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}



class CommentsForMuddaBazz extends StatefulWidget {
  const CommentsForMuddaBazz({Key? key, required this.commentId}) : super(key: key);
  final String commentId;

  @override
  State<CommentsForMuddaBazz> createState() => _CommentsForMuddaBazz();
}

class _CommentsForMuddaBazz extends State<CommentsForMuddaBazz> {
  MuddaNewsController muddaNewsController = Get.put(MuddaNewsController());

  // @override
  // void initState() {
  //   super.initState();
  //   muddaNewsController.isSelectComment.refresh();
  // }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Container(
            height: isKeyboardVisible
                ? 100 + MediaQuery.of(context).viewInsets.bottom
                : 100,
            width: Get.width,
            decoration: BoxDecoration(
                color: const Color(0xFFf7f7f7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (text) {
                      muddaNewsController.comment.value = text;
                    },
                    style: size14_M_normal(textColor: color606060),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      hintText:
                      "Help your audience know your Vision max 30 words",
                      border: InputBorder.none,
                      hintStyle: size14_M_normal(textColor: color606060),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: isKeyboardVisible
                      ? 100 + MediaQuery.of(context).viewInsets.bottom
                      : 100,
                  child: const VerticalDivider(
                    width: 1,
                    color: darkGray,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          Api.post.call(context,
                              method: "comment/store",
                              param: {
                                "relative_id": widget.commentId,
                                "user_id": AppPreference().getString(
                                    PreferencesKey.interactUserId),
                                "relative_type": "QuoteOrActivity",
                                "comment_type": "favour",
                                "user_identity": muddaNewsController
                                    .selectedFavourRole.value,
                                "commentText":
                                muddaNewsController.comment.value,
                              },
                              isLoading: true,
                              onResponseSuccess: (Map object) {
                                var result = Comments.fromJson(object['data']);
                                muddaNewsController.postForMuddaCommentsList
                                    .insert(0, result);
                                Get.back();
                              });
                        },
                        child: Image.asset(AppIcons.rightSizeArrow,
                            color: Colors.grey, height: 18, width: 18),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setSp(13),
                    ),
                    InkWell(
                      onTap: () {
                        muddaNewsController.selectedFavourRole.value =
                        muddaNewsController.selectedFavourRole.value ==
                            "1"
                            ? "0"
                            : "1";
                      },
                      child: Obx(
                            () => muddaNewsController
                            .selectedFavourRole.value ==
                            "1"
                            ? AppPreference()
                            .getString(PreferencesKey.profile)
                            .isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl:
                          "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.profile)}",
                          imageBuilder:
                              (context, imageProvider) =>
                              Container(
                                width: ScreenUtil().setSp(40),
                                height: ScreenUtil().setSp(40),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ScreenUtil().setSp(
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
                          errorWidget: (context, url, error) =>
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
                                AppPreference()
                                    .getString(PreferencesKey
                                    .fullName)[0]
                                    .toUpperCase(),
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                    ScreenUtil().setSp(16),
                                    color: black)),
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
                            child: Text("A",
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenUtil().setSp(16),
                                    color: black)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                getSizedBox(w: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
