import 'dart:developer';
import 'package:flutter/cupertino.dart';
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
import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/home_screen/widget/component/hot_mudda_post.dart';
import 'package:mudda/ui/shared/report_post_dialog_box.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../const/const.dart';
import '../../../../core/utils/count_number.dart';
import '../../../../core/utils/size_config.dart';
import '../view/mudda_details_screen.dart';

class MuddaInfoDialogBox extends StatefulWidget {
  final Function(bool)? callBack;
  final String muddaShareLink;

  const MuddaInfoDialogBox({Key? key, this.callBack,required this.muddaShareLink}) : super(key: key);

  @override
  State<MuddaInfoDialogBox> createState() => _MuddaInfoDialogBoxState();
}

class _MuddaInfoDialogBoxState extends State<MuddaInfoDialogBox> {
  MuddaNewsController? muddaNewsController;

  @override
  void initState() {
    muddaNewsController = Get.find<MuddaNewsController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setSp(80)),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            width: Get.width,
            color: Colors.white,
            child: Material(
              color: Colors.white,
              child: Center(
                child: Obx(() => Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              muddaNewsController?.muddaPost.value.isInvolved !=
                                          null &&
                                      (muddaNewsController?.muddaPost
                                                  .value.isInvolved!.joinerType ==
                                              "creator" ||
                                          muddaNewsController?.muddaPost.value
                                                  .isInvolved!.joinerType ==
                                              "leader" ||
                                          muddaNewsController?.muddaPost.value
                                                  .isInvolved!.joinerType ==
                                              "initial_leader")
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                child: Image.asset(
                                                    AppIcons.shakeHandIcon),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  // muddaNewsController!.inviteType.value = 'leader';
                                                  Get.toNamed(RouteConstants
                                                      .invitedSupportScreen);
                                                },
                                                child: Text(
                                                  "Invite Support",
                                                  style: size12_M_regular(
                                                      textColor: color202020),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : muddaNewsController?.muddaPost.value
                                                  .isInvolved !=
                                              null &&
                                          muddaNewsController?.muddaPost.value
                                                  .isInvolved!.joinerType ==
                                              "opposition"
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              child:
                                                  Image.asset(AppIcons.dislike),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                muddaNewsController!.inviteType
                                                    .value = 'opposition';
                                                Get.toNamed(RouteConstants
                                                    .invitedSearchScreen);
                                              },
                                              child: Text(
                                                "Invite Support",
                                                style: size12_M_regular(
                                                    textColor: color202020),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(left: 20)),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                  reportDialogBox(
                                      context,
                                      "${muddaNewsController!.muddaPost.value.sId}",
                                      false,
                                      false,
                                      false);
                                },
                                child: Text(
                                  "Report",
                                  style:
                                      size12_M_regular(textColor: color202020),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                  Share.share("$shareMessage${widget.muddaShareLink}");
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
                                      style: size12_M_regular(
                                          textColor: color202020),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: grey,
                          thickness: 0.2,
                          height: 24,
                        ),
                        /* muddaNewsController.muddaPost.value.isInvolved != null
                        // muddaNewsController.muddaPost.value.isInvolved!.joinerType == "creator" ||
                        // muddaNewsController.muddaPost.value.isInvolved!.joinerType == "leader" ||
                        // muddaNewsController.muddaPost.value.isInvolved!.joinerType == "initial_leader"
                        ? Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Image.asset(AppIcons.shakeHandIcon),
                                ),
                                Text(
                                  "Invite Support",
                                  style:
                                      size12_M_regular(textColor: color202020),
                                ),
                              ],
                            ),
                          )
                        : muddaNewsController.muddaPost.value.isInvolved !=
                                    null &&
                                muddaNewsController.muddaPost.value.isInvolved!
                                        .joinerType ==
                                    "opposition"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    margin: const EdgeInsets.only(right: 5),
                                    child: Image.asset(AppIcons.dislike),
                                  ),
                                  Text(
                                    "Invite NotSupport",
                                    style: size12_M_regular(
                                        textColor: color202020),
                                  ),
                                ],
                              )
                            : */
                        if (muddaNewsController?.postMudda.value.favourInvite !=
                                null ||
                            muddaNewsController
                                    ?.postMudda.value.oppositionInvite !=
                                null)
                          Column(
                            children: [
                              Text(
                                'Join Leadership: ',
                                style: size12_M_regular(
                                    textColor: const Color(0xff31393C)),
                              ),
                              getSizedBox(h: ScreenUtil().setSp(8)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() => muddaNewsController
                                              ?.postMudda.value.favourInvite !=
                                          null
                                      ? GestureDetector(
                                          onTap: () {
                                            Api.post.call(
                                              context,
                                              method: "request-to-user/update",
                                              param: {
                                                "_id": muddaNewsController
                                                    ?.postMudda
                                                    .value
                                                    .favourInvite!
                                                    .Id
                                              },
                                              onResponseSuccess: (object) {
                                                muddaNewsController?.postMudda
                                                    .value.favourInvite = null;
                                                log('$object');
                                                MyReaction newData =
                                                    MyReaction();
                                                newData.sId =
                                                    object['data']['_id'];
                                                newData.joinerType =
                                                    object['data']
                                                        ['request_type'];
                                                newData.joiningContentId =
                                                    object['data']
                                                        ['joining_content_id'];
                                                newData.requestToUserId =
                                                    object['data']
                                                        ['request_to_user_id'];
                                                newData.userId =
                                                    object['data']['user_id'];
                                                muddaNewsController?.muddaPost
                                                    .value.isInvolved = newData;
                                                Get.back();
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: ScreenUtil().setSp(20),
                                            width: ScreenUtil().setSp(93),
                                            decoration: BoxDecoration(
                                              color: white,
                                              border: Border.all(
                                                  color: grey, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'Accept',
                                              style: size12_M_regular(
                                                  textColor: buttonBlue),
                                            )),
                                          ),
                                        )
                                      : const SizedBox()),
                                  getSizedBox(w: ScreenUtil().setSp(15)),
                                  Obx(() => muddaNewsController?.postMudda.value
                                              .oppositionInvite !=
                                          null
                                      ? GestureDetector(
                                          onTap: () {
                                            Api.post.call(
                                              context,
                                              method: "request-to-user/update",
                                              param: {
                                                "_id": muddaNewsController
                                                    ?.postMudda
                                                    .value
                                                    .oppositionInvite!
                                                    .Id
                                              },
                                              onResponseSuccess: (object) {
                                                muddaNewsController
                                                    ?.postMudda
                                                    .value
                                                    .oppositionInvite = null;
                                                log('message');
                                                MyReaction newData =
                                                    MyReaction();
                                                newData.sId =
                                                    object['data']['_id'];
                                                newData.joinerType =
                                                    object['data']
                                                        ['request_type'];
                                                newData.joiningContentId =
                                                    object['data']
                                                        ['joining_content_id'];
                                                newData.requestToUserId =
                                                    object['data']
                                                        ['request_to_user_id'];
                                                newData.userId =
                                                    object['data']['user_id'];
                                                muddaNewsController?.muddaPost
                                                    .value.isInvolved = newData;
                                                Get.back();
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: ScreenUtil().setSp(20),
                                            width: ScreenUtil().setSp(93),
                                            decoration: BoxDecoration(
                                              color: white,
                                              border: Border.all(
                                                  color: grey, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'Accept',
                                              style: size12_M_regular(
                                                  textColor: buttonYellow),
                                            )),
                                          ),
                                        )
                                      : const SizedBox()),
                                  getSizedBox(w: ScreenUtil().setSp(15)),
                                ],
                              )
                            ],
                          )
                        else
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => muddaNewsController
                                            ?.muddaPost.value.amIRequested !=
                                        null
                                    ? const SizedBox()
                                    : muddaNewsController
                                                ?.muddaPost.value.isInvolved !=
                                            null
                                        ? GestureDetector(
                                            onTap: () {
                                              if (muddaNewsController?.muddaPost
                                                      .value.isInvolved !=
                                                  null) {
                                                Api.delete.call(
                                                  context,
                                                  method:
                                                      "request-to-user/joined-delete/${muddaNewsController!.muddaPost.value.isInvolved!.sId}",
                                                  param: {
                                                    "_id": muddaNewsController!
                                                        .muddaPost
                                                        .value
                                                        .isInvolved!
                                                        .sId
                                                  },
                                                  onResponseSuccess: (object) {
                                                    MuddaPost muddaPost =
                                                        muddaNewsController!
                                                            .muddaPost.value;
                                                    muddaPost.isInvolved = null;
                                                    muddaNewsController!
                                                        .muddaPost
                                                        .value = MuddaPost();
                                                    muddaNewsController!
                                                        .muddaPost
                                                        .value = muddaPost;
                                                    Get.back();
                                                  },
                                                );
                                              } else {
                                                // showJoinDialog(context);
                                              }
                                            },
                                            child: Text(
                                              // "Leadership",
                                              muddaNewsController?.muddaPost
                                                          .value.isInvolved !=
                                                      null
                                                  ? "Leave Leadership"
                                                  : "",
                                              style: size12_M_regular(
                                                  textColor: color202020),
                                            ),
                                          )
                                        : Text(
                                            muddaNewsController?.muddaPost.value
                                                        .amIRequested !=
                                                    null
                                                ? ''
                                                : "",
                                            style: size12_M_regular(
                                                textColor: color202020),
                                          ),
                              ),
                              // muddaNewsController.muddaPost.value.amIRequested != null && muddaNewsController.muddaPost.value.amIUnSupport == 1 ? commonJoinOpposition(context) : SizedBox(),
                              // muddaNewsController.muddaPost.value.isInvolved != null && muddaNewsController.muddaPost.value.amISupport == 1 ? commonJoinFavour(context) : SizedBox(),

                              Obx(() => muddaNewsController
                                              ?.muddaPost.value.amIRequested !=
                                          null ||
                                      muddaNewsController
                                              ?.muddaPost.value.isInvolved !=
                                          null
                                  ? const SizedBox()
                                  : Column(
                                      children: [
                                        Text(
                                          'Join Leadership: ',
                                          style: size12_M_regular(
                                              textColor:
                                                  const Color(0xff31393C)),
                                        ),
                                        getSizedBox(h: ScreenUtil().setSp(8)),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => showJoinDialog(
                                                  context,
                                                  isFromFav: true),
                                              child: Container(
                                                height: ScreenUtil().setSp(20),
                                                width: ScreenUtil().setSp(93),
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  border: Border.all(
                                                      color: grey, width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  'Favour',
                                                  style: size12_M_regular(
                                                      textColor: buttonBlue),
                                                )),
                                              ),
                                            ),
                                            getSizedBox(
                                                w: ScreenUtil().setSp(15)),
                                            GestureDetector(
                                              onTap: () => showJoinDialog(
                                                  context,
                                                  isFromFav: false),
                                              child: Container(
                                                height: ScreenUtil().setSp(20),
                                                width: ScreenUtil().setSp(93),
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  border: Border.all(
                                                      color: grey, width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  'Opposition',
                                                  style: size12_M_regular(
                                                      textColor: buttonYellow),
                                                )),
                                              ),
                                            ),
                                            getSizedBox(
                                                w: ScreenUtil().setSp(15)),
                                          ],
                                        )
                                      ],
                                    )),

                              Obx(
                                () => muddaNewsController
                                            ?.muddaPost.value.amIRequested !=
                                        null
                                    ? GestureDetector(
                                        onTap: () {
                                          Api.delete.call(
                                            context,
                                            method:
                                                "request-to-user/delete/${muddaNewsController!.muddaPost.value.amIRequested!.sId}",
                                            param: {
                                              "_id": muddaNewsController!
                                                  .muddaPost
                                                  .value
                                                  .amIRequested!
                                                  .sId
                                            },
                                            onResponseSuccess: (object) {
                                              MuddaPost muddaPost =
                                                  muddaNewsController!
                                                      .muddaPost.value;
                                              muddaPost.amIRequested = null;
                                              muddaNewsController!.muddaPost
                                                  .value = MuddaPost();
                                              muddaNewsController!
                                                  .muddaPost.value = muddaPost;

                                              Get.back();
                                            },
                                          );
                                        },
                                        child: Text(
                                          // "Leadership","Cancel Request"
                                          "Cancel Request",
                                          style: size12_M_regular(
                                              textColor: color202020),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        muddaNewsController!.muddaPost.value.mySupport == null
                            ? const SizedBox()
                            : const Divider(
                                color: grey,
                                thickness: 0.2,
                                height: 24,
                              ),
                        muddaNewsController!.muddaPost.value.mySupport == null
                            ? SizedBox(height: ScreenUtil().setSp(16))
                            : SizedBox(
                                height: ScreenUtil().setSp(5),
                              ),
                        //
                        muddaNewsController!.muddaPost.value.mySupport == null
                            ? Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                              "muddaId": muddaNewsController!
                                                  .muddaPost.value.sId,
                                              "support": false,
                                            },
                                            onResponseSuccess: (object) {
                                              muddaNewsController!.support();
                                              muddaNewsController!
                                                      .muddaPost.value.afterMe =
                                                  object['data'] != null
                                                      ? AfterMe.fromJson(
                                                          object['data'])
                                                      : null;

                                              if (muddaNewsController!.muddaPost
                                                      .value.mySupport ==
                                                  false) {
                                                muddaNewsController!.muddaPost
                                                    .value.mySupport = null;
                                                muddaNewsController!.muddaPost
                                                        .value.totalVote! -
                                                    1;
                                              } else {
                                                muddaNewsController!.muddaPost
                                                        .value.totalVote! +
                                                    1;

                                                muddaNewsController!.muddaPost
                                                    .value.mySupport = false;
                                              }

                                              // muddaNewsController
                                              //     .muddaPostList[
                                              // index] = muddaPost;
                                              // muddaNewsController
                                              //     .muddaActionIndex
                                              //     .value = index;
                                              //
                                              // isSupportAfterJoin = null;
                                              // isSupport = "isNotSupport";
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
                                            margin:
                                                const EdgeInsets.only(left: 25),
                                            alignment: Alignment.center,
                                            padding:
                                                const EdgeInsets.only(left: 10),
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
                                    const Hs(width: 10),
                                    InkWell(
                                      onTap: () async {
                                        if (AppPreference()
                                            .getBool(PreferencesKey.isGuest)) {
                                          updateProfileDialog(context);
                                        } else {
                                          Api.post.call(
                                            context,
                                            method: "mudda/support",
                                            isLoading: false,
                                            param: {
                                              "muddaId": muddaNewsController!
                                                  .muddaPost.value.sId,
                                              "support": true,
                                            },
                                            onResponseSuccess: (object) {
                                              muddaNewsController!.support();
                                              print(object);
                                              muddaNewsController!
                                                      .muddaPost.value.afterMe =
                                                  object['data'] != null
                                                      ? AfterMe.fromJson(
                                                          object['data'])
                                                      : null;
                                              if (muddaNewsController!.muddaPost
                                                      .value.mySupport ==
                                                  true) {
                                                muddaNewsController!.muddaPost
                                                    .value.mySupport = null;
                                                muddaNewsController!.muddaPost
                                                        .value.support =
                                                    muddaNewsController!
                                                            .muddaPost
                                                            .value
                                                            .support! -
                                                        1;
                                                muddaNewsController!.muddaPost
                                                        .value.totalVote! -
                                                    1;
                                              } else {
                                                muddaNewsController!.muddaPost
                                                        .value.support =
                                                    muddaNewsController!
                                                            .muddaPost
                                                            .value
                                                            .support! +
                                                        1;
                                                muddaNewsController!.muddaPost
                                                        .value.totalVote! +
                                                    1;
                                                muddaNewsController!.muddaPost
                                                    .value.mySupport = true;
                                              }

                                              // widget.muddaNewsController!
                                              //     .muddaPostList[index] = widget.muddaNewsController!
                                              //     .muddaPost
                                              //     .value;
                                              // widget.muddaNewsController!
                                              //     .muddaActionIndex
                                              //     .value = index;
                                              //
                                              // isSupportAfterJoin = "support";
                                              // isSupportAfterJoin = null;
                                              // isSupport = "isSupport";

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
                                            margin:
                                                const EdgeInsets.only(left: 25),
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
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        muddaNewsController!.muddaPost.value.mySupport == null
                            ? const Divider(
                                color: grey,
                                thickness: 0.2,
                                height: 24,
                              )
                            : const SizedBox(),
                        //
                        muddaNewsController!.muddaPost.value.mySupport == null
                            ? SizedBox(
                                height: ScreenUtil().setSp(5),
                              )
                            : const SizedBox(),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          // muddaNewsController?.muddaPost.value
                                          //     .isInvolved !=
                                          //     null &&
                                          //     muddaNewsController?.muddaPost
                                          //         .value
                                          //         .isInvolved!
                                          //         .joinerType ==
                                          //         "opposition" && muddaNewsController?.muddaPost.value.amIUnSupport == 1
                                          //     ? GestureDetector(
                                          //   onTap: () {
                                          //     Api.delete.call(
                                          //       context,
                                          //       method:
                                          //       "request-to-user/joined-delete/${muddaNewsController!.muddaPost.value.isInvolved!.sId}",
                                          //       param: {
                                          //         "_id": muddaNewsController!
                                          //             .muddaPost
                                          //             .value
                                          //             .isInvolved!
                                          //             .sId
                                          //       },
                                          //       onResponseSuccess: (object) {
                                          //         MuddaPost muddaPost = muddaNewsController!
                                          //             .muddaPost
                                          //             .value;
                                          //         muddaPost.isInvolved = null;
                                          //         muddaNewsController!
                                          //             .muddaPost
                                          //             .value = MuddaPost();
                                          //         muddaNewsController!
                                          //             .muddaPost
                                          //             .value = muddaPost;
                                          //         Get.back();
                                          //       },
                                          //     );
                                          //   },
                                          //   child: Text(
                                          //     "Leave - ",
                                          //     style: GoogleFonts.nunitoSans(
                                          //         fontWeight: FontWeight.w700,
                                          //         fontSize:
                                          //         ScreenUtil().setSp(12),
                                          //         color: grey),
                                          //   ),
                                          // )
                                          //     : const SizedBox(),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Opposition",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                color: buttonYellow),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          muddaNewsController!.muddaPost.value
                                                      .mySupport ==
                                                  null
                                              ? const SizedBox()
                                              : InkWell(
                                                  onTap: () {
                                                    if (AppPreference().getBool(
                                                        PreferencesKey
                                                            .isGuest)) {
                                                      updateProfileDialog(
                                                          context);
                                                    } else {
                                                      Api.post.call(
                                                        context,
                                                        method: "mudda/support",
                                                        isLoading: false,
                                                        param: {
                                                          "muddaId":
                                                              muddaNewsController!
                                                                  .muddaPost
                                                                  .value
                                                                  .sId,
                                                          "support": false,
                                                        },
                                                        onResponseSuccess:
                                                            (object) {
                                                          muddaNewsController!
                                                              .muddaPost
                                                              .value
                                                              .afterMe = object[
                                                                      'data'] !=
                                                                  null
                                                              ? AfterMe.fromJson(
                                                                  object[
                                                                      'data'])
                                                              : null;

                                                          if (muddaNewsController!
                                                                  .muddaPost
                                                                  .value
                                                                  .mySupport ==
                                                              false) {
                                                            muddaNewsController!
                                                                    .muddaPost
                                                                    .value
                                                                    .mySupport =
                                                                null;
                                                            muddaNewsController!
                                                                    .muddaPost
                                                                    .value
                                                                    .totalVote! -
                                                                1;
                                                          } else {
                                                            muddaNewsController!
                                                                    .muddaPost
                                                                    .value
                                                                    .totalVote! +
                                                                1;

                                                            muddaNewsController!
                                                                    .muddaPost
                                                                    .value
                                                                    .mySupport =
                                                                false;
                                                          }
                                                          // muddaNewsController
                                                          //     .muddaPostList[
                                                          // index] = muddaPost;
                                                          // muddaNewsController
                                                          //     .muddaActionIndex
                                                          //     .value = index;
                                                          // isSupportAfterJoin = null;
                                                          // isSupport = null;
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
                                                        height: 15,
                                                        width: 15,
                                                        child: Image.asset(
                                                            AppIcons.dislike,
                                                            color: muddaNewsController!
                                                                        .muddaPost
                                                                        .value
                                                                        .mySupport ==
                                                                    false
                                                                ? Colors.white
                                                                : blackGray)),
                                                    decoration: BoxDecoration(
                                                      color: muddaNewsController!
                                                                  .muddaPost
                                                                  .value
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
                                      SizedBox(
                                        height: muddaNewsController!.muddaPost
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
                                              muddaNewsController!
                                                  .postForMuddaMuddaOpposition[
                                                      "totalPosts"]
                                                  .toString(),
                                              // countNumber(double.parse(muddaNewsController!
                                              //     .postForMuddaMuddaOpposition["totalPosts"]
                                              //     .toString())),
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(12),
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
                                              muddaNewsController!
                                                          .postForMuddaMuddaOpposition ==
                                                      null
                                                  ? ""
                                                  : "Agree ${muddaNewsController!.oppositionPercentage.toStringAsFixed(2)}%",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(12),
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
                              muddaNewsController!.muddaPost.value.mySupport ==
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        muddaNewsController!.muddaPost.value
                                                    .mySupport ==
                                                null
                                            ? const SizedBox()
                                            : InkWell(
                                                onTap: () {
                                                  if (AppPreference().getBool(
                                                      PreferencesKey.isGuest)) {
                                                    updateProfileDialog(
                                                        context);
                                                  } else {
                                                    Api.post.call(
                                                      context,
                                                      method: "mudda/support",
                                                      isLoading: false,
                                                      param: {
                                                        "muddaId":
                                                            muddaNewsController!
                                                                .muddaPost
                                                                .value
                                                                .sId,
                                                        "support": true,
                                                      },
                                                      onResponseSuccess:
                                                          (object) {
                                                        print(object);
                                                        muddaNewsController!
                                                            .muddaPost
                                                            .value
                                                            .afterMe = object[
                                                                    'data'] !=
                                                                null
                                                            ? AfterMe.fromJson(
                                                                object['data'])
                                                            : null;
                                                        if (muddaNewsController!
                                                                .muddaPost
                                                                .value
                                                                .mySupport ==
                                                            true) {
                                                          muddaNewsController!
                                                              .muddaPost
                                                              .value
                                                              .mySupport = null;
                                                          muddaNewsController!
                                                                  .muddaPost
                                                                  .value
                                                                  .support =
                                                              muddaNewsController!
                                                                      .muddaPost
                                                                      .value
                                                                      .support! -
                                                                  1;
                                                          muddaNewsController!
                                                                  .muddaPost
                                                                  .value
                                                                  .totalVote! -
                                                              1;
                                                        } else {
                                                          muddaNewsController!
                                                                  .muddaPost
                                                                  .value
                                                                  .support =
                                                              muddaNewsController!
                                                                      .muddaPost
                                                                      .value
                                                                      .support! +
                                                                  1;
                                                          muddaNewsController!
                                                                  .muddaPost
                                                                  .value
                                                                  .totalVote! +
                                                              1;
                                                          muddaNewsController!
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
                                                        // isSupportAfterJoin = null;
                                                        // isSupport = null;
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
                                                          AppIcons
                                                              .shakeHandIcon,
                                                          color: muddaNewsController!
                                                                      .muddaPost
                                                                      .value
                                                                      .mySupport ==
                                                                  true
                                                              ? Colors.white
                                                              : blackGray)),
                                                  decoration: BoxDecoration(
                                                    color: muddaNewsController!
                                                                .muddaPost
                                                                .value
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
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        // muddaNewsController?.muddaPost.value.isInvolved !=
                                        //     null &&
                                        //     (muddaNewsController?.muddaPost.value.isInvolved!.joinerType ==
                                        //         "creator" ||
                                        //         muddaNewsController?.muddaPost.value.isInvolved!.joinerType ==
                                        //             "leader" ||
                                        //         muddaNewsController?.muddaPost.value.isInvolved!.joinerType ==
                                        //             "initial_leader") && muddaNewsController?.muddaPost.value.amISupport ==
                                        //     1
                                        //     ? GestureDetector(
                                        //   onTap: () {
                                        //     Api.delete.call(
                                        //       context,
                                        //       method:
                                        //       "request-to-user/joined-delete/${muddaNewsController!.muddaPost.value.isInvolved!.sId}",
                                        //       param: {
                                        //         "_id": muddaNewsController!
                                        //             .muddaPost
                                        //             .value
                                        //             .isInvolved!
                                        //             .sId
                                        //       },
                                        //       onResponseSuccess: (object) {
                                        //         MuddaPost muddaPost = muddaNewsController!
                                        //             .muddaPost
                                        //             .value;
                                        //         muddaPost.isInvolved = null;
                                        //         muddaNewsController!
                                        //             .muddaPost
                                        //             .value = MuddaPost();
                                        //        muddaNewsController!
                                        //             .muddaPost
                                        //             .value = muddaPost;
                                        //         Get.back();
                                        //       },
                                        //     );
                                        //   },
                                        //   child: Text(
                                        //     "Leave - ",
                                        //     style: GoogleFonts.nunitoSans(
                                        //         fontWeight: FontWeight.w700,
                                        //         fontSize:
                                        //         ScreenUtil().setSp(12),
                                        //         color: grey),
                                        //   ),
                                        // )
                                        //     : const SizedBox(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: muddaNewsController!
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
                                            muddaNewsController!
                                                .postForMuddaMuddaFavour[
                                                    "totalPosts"]
                                                .toString(),
                                            // countNumber(double.parse(muddaNewsController!
                                            //     .postForMuddaMuddaFavour[
                                            // "totalPosts"]
                                            //     .toString())),
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
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
                                            muddaNewsController!
                                                        .postForMuddaMuddaFavour ==
                                                    null
                                                ? ""
                                                : "Agree ${muddaNewsController!.favourPercentage.toStringAsFixed(2)}%",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
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
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget commonJoinOpposition(BuildContext context) {
    return Container(
      width: (ScreenUtil().screenWidth / 2.5) - ScreenUtil().setSp(35),
      height: ScreenUtil().setSp(25),
      margin: const EdgeInsets.only(left: 8, right: 16),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: 0, horizontal: ScreenUtil().setSp(8)),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: grey)),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: grey)),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: grey),
            )),
        hint: Text("Join Opposition",
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w400,
                fontSize: ScreenUtil().setSp(12),
                color: buttonYellow)),
        style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtil().setSp(12),
            color: buttonYellow),
        items: <String>[
          "Join Normal",
          "Join Anonymous",
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(12),
                    color: black)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (AppPreference().getBool(PreferencesKey.isGuest)) {
            updateProfileDialog(context);
          } else {
            muddaNewsController!.selectJoinFavour.value = newValue!;
            Api.post.call(
              context,
              method: "request-to-user/store",
              param: {
                "user_id": AppPreference().getString(PreferencesKey.userId),
                "request_to_user_id":
                    muddaNewsController!.muddaPost.value.leaders![0].userId,
                "joining_content_id": muddaNewsController!.muddaPost.value.sId,
                "requestModalPath": muddaNewsController!.muddaProfilePath.value,
                "requestModal": "RealMudda",
                "request_type": "opposition",
                "user_identity": newValue == "Join Normal" ? "1" : "0",
              },
              onResponseSuccess: (object) {
                log("JOIN:::-=-=-=-=-= $object");
                MuddaPost muddaPost = muddaNewsController!.muddaPost.value;
                muddaPost.isInvolved = MyReaction.fromJson(object['data']);
                muddaNewsController!.muddaPost.value = MuddaPost();
                muddaNewsController!.muddaPost.value = muddaPost;
                Get.back();
              },
            );
          }
        },
      ),
    );
  }

  Widget commonJoinFavour(BuildContext context) {
    return Container(
      width: (ScreenUtil().screenWidth / 2.5) - ScreenUtil().setSp(35),
      height: ScreenUtil().setSp(25),
      // margin: const EdgeInsets.only(left: 8, right: 16),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: 0, horizontal: ScreenUtil().setSp(8)),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: grey)),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: grey)),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: grey),
            )),
        hint: Text("Join Favour",
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w400,
                fontSize: ScreenUtil().setSp(12),
                color: buttonBlue)),
        style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtil().setSp(12),
            color: buttonBlue),
        items: <String>[
          "Join Normal",
          "Join Anonymous",
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(12),
                    color: black)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (AppPreference().getBool(PreferencesKey.isGuest)) {
            updateProfileDialog(context);
          } else {
            muddaNewsController!.selectJoinFavour.value = newValue!;
            Api.post.call(
              context,
              method: "request-to-user/store",
              param: {
                "user_id": AppPreference().getString(PreferencesKey.userId),
                "request_to_user_id":
                    muddaNewsController!.muddaPost.value.leaders![0].userId,
                "joining_content_id": muddaNewsController!.muddaPost.value.sId,
                "requestModalPath": muddaNewsController!.muddaProfilePath.value,
                "requestModal": "RealMudda",
                "request_type": "leader",
                "user_identity": newValue == "Join Normal" ? "1" : "0",
              },
              onResponseSuccess: (object) {
                log("JOIN:::-=-=-=- $object");
                MuddaPost muddaPost = muddaNewsController!.muddaPost.value;
                muddaPost.amIRequested = MyReaction.fromJson(object['data']);
                muddaNewsController!.muddaPost.value = MuddaPost();
                muddaNewsController!.muddaPost.value = muddaPost;
                Get.back();
              },
            );
          }
        },
      ),
    );
  }

  showJoinDialog(BuildContext context, {required bool isFromFav}) {
    // TODO: Dialog code
    return showDialog(
      context: Get.context as BuildContext,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: white,
                border: Border.all(color: grey, width: 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: ScreenUtil().setSp(54),
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xff606060),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Join Mudda Leadership as-',
                          style: size16_M_bold(textColor: white))
                    ],
                  ),
                ),
                getSizedBox(h: ScreenUtil().setSp(16)),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            muddaNewsController!.isSelectRole.value = 0;
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
                                child:
                                    muddaNewsController!.isSelectRole.value == 0
                                        ? Container(
                                            margin: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: black,
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        : const SizedBox(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Normal",
                                    style: muddaNewsController!
                                                .isSelectRole.value ==
                                            0
                                        ? size14_M_bold(textColor: black)
                                        : size14_M_normal(textColor: black),
                                  ),
                                  Text(
                                    "(Public Profile)",
                                    style: GoogleFonts.nunitoSans(
                                        color: grey,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        GestureDetector(
                          onTap: () {
                            muddaNewsController!.isSelectRole.value = 1;
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
                                child:
                                    muddaNewsController!.isSelectRole.value == 1
                                        ? Container(
                                            margin: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: black,
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        : const SizedBox(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Anonymous",
                                    style: muddaNewsController!
                                                .isSelectRole.value ==
                                            1
                                        ? size14_M_bold(textColor: black)
                                        : size14_M_normal(textColor: black),
                                  ),
                                  Text(
                                    "(Hidden from Public)",
                                    style: GoogleFonts.nunitoSans(
                                        color: grey,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                getSizedBox(h: ScreenUtil().setSp(32)),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (isFromFav) {
                            if (AppPreference()
                                .getBool(PreferencesKey.isGuest)) {
                              updateProfileDialog(context);
                            } else {
                              // muddaNewsController!.selectJoinFavour
                              //     .value = newValue!;
                              Api.post.call(
                                context,
                                method: "request-to-user/store",
                                param: {
                                  "user_id": AppPreference()
                                      .getString(PreferencesKey.userId),
                                  "request_to_user_id": muddaNewsController!
                                      .muddaPost.value.leaders![0].userId,
                                  "joining_content_id":
                                      muddaNewsController!.muddaPost.value.sId,
                                  "requestModalPath": muddaNewsController!
                                      .muddaProfilePath.value,
                                  "requestModal": "RealMudda",
                                  "request_type": "leader",
                                  "user_identity":
                                      muddaNewsController!.isSelectRole.value ==
                                              1
                                          ? "0"
                                          : "1",
                                },
                                onResponseSuccess: (object) {
                                  log("JOIN:::-=-=-=- $object");
                                  MuddaPost muddaPost =
                                      muddaNewsController!.muddaPost.value;
                                  muddaPost.amIRequested =
                                      MyReaction.fromJson(object['data']);
                                  muddaNewsController!.muddaPost.value =
                                      MuddaPost();
                                  muddaNewsController!.muddaPost.value =
                                      muddaPost;
                                  Get.back();
                                },
                              );
                            }
                          } else {
                            if (AppPreference()
                                .getBool(PreferencesKey.isGuest)) {
                              Get.toNamed(RouteConstants.userProfileEdit);
                            } else {
                              // muddaNewsController!.selectJoinFavour
                              //     .value = newValue!;
                              Api.post.call(
                                context,
                                method: "request-to-user/store",
                                param: {
                                  "user_id": AppPreference()
                                      .getString(PreferencesKey.userId),
                                  "request_to_user_id": muddaNewsController!
                                      .muddaPost.value.leaders![0].userId,
                                  "joining_content_id":
                                      muddaNewsController!.muddaPost.value.sId,
                                  "requestModalPath": muddaNewsController!
                                      .muddaProfilePath.value,
                                  "requestModal": "RealMudda",
                                  "request_type": "opposition",
                                  "user_identity":
                                      muddaNewsController!.isSelectRole.value ==
                                              1
                                          ? "0"
                                          : "1",
                                },
                                onResponseSuccess: (object) {
                                  log("JOIN:::-=-=-=-=-= $object");
                                  MuddaPost muddaPost =
                                      muddaNewsController!.muddaPost.value;
                                  muddaPost.isInvolved =
                                      MyReaction.fromJson(object['data']);
                                  muddaNewsController!.muddaPost.value =
                                      MuddaPost();
                                  muddaNewsController!.muddaPost.value =
                                      muddaPost;
                                  Get.back();
                                },
                              );
                            }
                          }
                        },
                        child: const Text('Join')),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancel'))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
