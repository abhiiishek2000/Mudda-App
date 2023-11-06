import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
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
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/NotificationModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/notification/controller/NotificationController.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';
import '../../../const/const.dart';
import '../../../core/utils/size_config.dart';
import '../../../core/utils/text_style.dart';
import '../profile_screen/view/profile_screen.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final dateFormat = DateFormat('dd-MM-yyyy');

  final monthFormat = DateFormat('MM');

  dynamic title;

  int page = 1;

  NotificationController? notificationController;

  MuddaNewsController? muddaNewsController;

  ScrollController muddaScrollController = ScrollController();

  @override
  void initState() {
    notificationController = Get.find<NotificationController>();
    muddaNewsController = Get.find<MuddaNewsController>();
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        _notification(context);
      }
    });
    _notification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorAppBackground,
        centerTitle: true,
        title: Text(
          "Notification",
          style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(18),
              color: black),
        ),
        elevation: 0,
        leading: GestureDetector(
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
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () {
            notificationController!.notificationList.clear();
            page = 1;
            return _notification(context);
          },
          child: ListView.builder(
              shrinkWrap: true,
              controller: muddaScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: notificationController!.notificationList.length,
              padding: EdgeInsets.only(
                  left: ScreenUtil().setSp(25), right: ScreenUtil().setSp(37)),
              itemBuilder: (listContext, index) {
                NotificationData notificationData =
                    notificationController!.notificationList.elementAt(index);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setSp(12),
                            bottom: ScreenUtil().setSp(7)),
                        child: Text(
                            notificationData.durationTime != null
                                ? notificationData.durationTime!
                                : "",
                            style: GoogleFonts.nunitoSans(
                                fontSize: ScreenUtil().setSp(14),
                                fontWeight: FontWeight.w400,
                                color: lightGray)),
                      ),
                      visible: notificationData.durationTime != null,
                    ),
                    if (notificationData.action == 'commented')
                      commented(notificationData)
                    else if (notificationData.action == 'following')
                      following(notificationData)
                    else if (notificationData.action == 'joined')
                      joined(notificationData)
                    else if (notificationData.action == 'Agree')
                      commented(notificationData)
                    else if (notificationData.action == 'approved')
                      approved(notificationData)
                    else if (notificationData.action == 'joined_mudda')
                      joinedMudda(notificationData)
                    else if (notificationData.title == 'Mudda Support' ||
                        notificationData.title == 'Mudda NotSupport')
                      Padding(
                          padding:
                              EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setSp(4)),
                                    child: SizedBox(
                                      height: ScreenUtil().setSp(40),
                                      width: ScreenUtil().setSp(40),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${notificationData.targetMediaPath}${notificationData.targetMedia}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setSp(8),
                                  ),
                                  Expanded(
                                    child: Wrap(
                                      children: [
                                        Text.rich(TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              recognizer:
                                                  new TapGestureRecognizer()
                                                    ..onTap = () {},
                                              text: notificationData.title !=
                                                      null
                                                  ? "${notificationData.title} - "
                                                  : "",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w700,
                                                  color: color0060FF,
                                                  fontSize:
                                                      ScreenUtil().setSp(14))),
                                          TextSpan(
                                              text: notificationData.source,
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      ScreenUtil().setSp(12),
                                                  color: black)),
                                          TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {},
                                              text:
                                                  " ${notificationData.data}\n",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  color: blackGray,
                                                  fontSize:
                                                      ScreenUtil().setSp(14))),
                                          TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {},
                                              text: notificationData.body !=
                                                      null
                                                  ? "\"${notificationData.body}\"\n"
                                                  : "",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w700,
                                                  color: black,
                                                  fontSize:
                                                      ScreenUtil().setSp(14))),
                                          TextSpan(
                                              text: notificationData.title ==
                                                      'Mudda Support'
                                                  ? " in Favour"
                                                  : 'in Opposition',
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(12),
                                                  color: buttonYellow)),
                                        ])),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Vs(height: 16),
                              orgBox(
                                  title:
                                      notificationData.title == 'Mudda Support'
                                          ? "Support"
                                          : 'Oppose',
                                  icon: AppIcons.editProfile,
                                  onTap: () {
                                    Api.post.call(context,
                                        method: "request-to-user/update",
                                        param: {
                                          "_id": notificationData.storeId!,
                                          "action": notificationData.action,
                                        }, onResponseSuccess: (object) {
                                      notificationController!.notificationList
                                          .removeAt(index);
                                      Get.back();
                                    });
                                  }),
                            ],
                          ))
                    else if (notificationData.title == 'Org Join Request')
                      orgJoinRequest(notificationData)
                    else if (notificationData.title == 'Mudda Join Request')
                      muddaJoinRequest(notificationData, index)
                    else if (notificationData.title == 'OrgRemove')
                      orgRemove(notificationData)
                    else
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
                        child: InkWell(
                          onTap: () {
                            if (notificationData.title == 'Mudda Invite' &&
                                notificationData.isVerify == 0) {
                              log('Mudda Invite');
                              muddaNewsController!.tabController.index = 2;
                              muddaNewsController!.isFromNotification.value =
                                  true;
                              muddaNewsController!.notificationIndex.value =
                                  index;
                              muddaNewsController!.fetchUnapproveMudda(
                                  context, notificationData.targetId!);
                              Get.offAllNamed(RouteConstants.homeScreen);
                            } else if (notificationData.title ==
                                    'Mudda Invite' &&
                                notificationData.isVerify == 1) {
                              muddaNewsController!.muddaId.value =
                                  notificationData.targetId!;
                              muddaNewsController!.muddaTitle.value =
                                  notificationData.body!;
                              muddaNewsController!.isFromNotification.value =
                                  true;
                              muddaNewsController!
                                  .fetchRecentPost(notificationData.targetId!);
                              Get.toNamed(RouteConstants.muddaDetailsScreen);
                            } else if (notificationData.title == 'Org Invite') {
                              Get.toNamed(RouteConstants.otherOrgProfileScreen,parameters: {'id':'${notificationData.sourceId}'});
                            }

                            // Get.offAllNamed(RouteConstants.homeScreen);
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(4)),
                                child: SizedBox(
                                  height: ScreenUtil().setSp(40),
                                  width: ScreenUtil().setSp(40),
                                  child: CachedNetworkImage(
                                    imageUrl: notificationData.title ==
                                            'Org Invite'
                                        ? "${notificationData.targetMediaPath}${notificationData.sourceMedia}"
                                        : "${notificationData.targetMediaPath}${notificationData.targetMedia}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setSp(8),
                              ),
                              Expanded(
                                child: Wrap(
                                  children: [
                                    Text.rich(TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: notificationData.title != null
                                              ? "${notificationData.title} - "
                                              : "",
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w700,
                                              color: color0060FF,
                                              fontSize:
                                                  ScreenUtil().setSp(14))),
                                      if (notificationData.orgName != null)
                                        TextSpan(
                                            text:
                                                "\"${notificationData.orgName}\" ",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w700,
                                                color: black,
                                                fontSize:
                                                    ScreenUtil().setSp(14))),
                                      TextSpan(
                                          text: "${notificationData.data}\n",
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              color: blackGray,
                                              fontSize:
                                                  ScreenUtil().setSp(14))),
                                      TextSpan(
                                          text: notificationData.body != null
                                              ? "\"${notificationData.body}\"\n"
                                              : "",
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w700,
                                              color: black,
                                              fontSize:
                                                  ScreenUtil().setSp(14))),
                                      // TextSpan(
                                      //     text: notificationData.title ==
                                      //         'Mudda Support'
                                      //         ? " in Favour"
                                      //         : 'in Opposition',
                                      //     style: GoogleFonts.nunitoSans(
                                      //         fontWeight: FontWeight.w400,
                                      //         fontSize:
                                      //         ScreenUtil().setSp(12),
                                      //         color: buttonYellow)),
                                      TextSpan(
                                          text: "requested by ",
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(12),
                                              color: black)),
                                      TextSpan(
                                          text: notificationData.source,
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w700,
                                              fontSize: ScreenUtil().setSp(12),
                                              color: black)),
                                    ])),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: notificationData.type ==
                                        "RequestUser" &&
                                    (notificationData.action == "invite" ||
                                        notificationData.action == "request"),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if ((notificationData.sourceType ==
                                                    "organisation" &&
                                                notificationData.action ==
                                                    "invite") ||
                                            (notificationData.type ==
                                                    "RequestUser" &&
                                                notificationData.action ==
                                                    "request")) {
                                          Api.post.call(context,
                                              method: "request-to-user/update",
                                              param: {
                                                "_id":
                                                    notificationData.storeId!,
                                                "action":
                                                    notificationData.action,
                                              }, onResponseSuccess: (object) {
                                            notificationController!
                                                .notificationList
                                                .removeAt(index);
                                            Get.back();
                                          });
                                        } else {
                                          showJoinDialog(
                                              context,
                                              index,
                                              notificationData.storeId!,
                                              notificationController!);
                                          // showAcceptDialog(
                                          //     context,
                                          //     index,
                                          //     notificationData.storeId!,
                                          //     notificationController!);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: ScreenUtil().setSp(5),
                                            bottom: ScreenUtil().setSp(6),
                                            left: ScreenUtil().setSp(8)),
                                        child: Text(
                                            notificationData.sourceType ==
                                                        "organisation" &&
                                                    notificationData.action ==
                                                        "invite"
                                                ? "Join"
                                                : "Accept",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                color: black,
                                                fontSize:
                                                    ScreenUtil().setSp(14))),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Api.delete.call(context,
                                            method:
                                                "request-to-user/delete/${notificationData.storeId!}",
                                            param: {},
                                            onResponseSuccess: (object) {
                                          notificationController!
                                              .notificationList
                                              .removeAt(index);
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: ScreenUtil().setSp(6),
                                            bottom: ScreenUtil().setSp(5),
                                            left: ScreenUtil().setSp(8)),
                                        child: Text(
                                            notificationData.sourceType ==
                                                        "organisation" &&
                                                    notificationData.action ==
                                                        "invite"
                                                ? "Ignore"
                                                : "Reject",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                color: black,
                                                fontSize:
                                                    ScreenUtil().setSp(14))),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget commented(NotificationData notificationData) {
    return Builder(builder: (BuildContext context) {
      return Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
          child: InkWell(
            onTap: (){
              Get.toNamed(RouteConstants.otherUserProfileScreen,parameters: {'id':'${notificationData.sourceId}'});
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(50)),
                  child: SizedBox(
                    height: ScreenUtil().setSp(40),
                    width: ScreenUtil().setSp(40),
                    child: CachedNetworkImage(
                      imageUrl:
                          "${notificationData.targetMediaPath}${notificationData.sourceMedia}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setSp(8),
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: notificationData.source != null
                                ? "${notificationData.source} "
                                : "",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: "${notificationData.action?.toLowerCase()} ",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: buttonBlue,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: "${notificationData.data}",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: blackGray,
                                fontSize: ScreenUtil().setSp(14))),
                      ])),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }

  Widget following(NotificationData notificationData) {
    return Builder(builder: (BuildContext context) {
      return Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
          child: InkWell(
            onTap: ()=>Get.toNamed(RouteConstants.otherUserProfileScreen,parameters: {'id':'${notificationData.sourceId}'}),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(50)),
                  child: SizedBox(
                    height: ScreenUtil().setSp(40),
                    width: ScreenUtil().setSp(40),
                    child: CachedNetworkImage(
                      imageUrl:
                          "${notificationData.targetMediaPath}${notificationData.sourceMedia}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setSp(8),
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: notificationData.source != null
                                ? "${notificationData.source} ${notificationData.data} "
                                : "",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: "following ",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: buttonBlue,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: "you",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: blackGray,
                                fontSize: ScreenUtil().setSp(14))),
                      ])),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }

  Widget joined(NotificationData notificationData) {
    return Builder(builder: (BuildContext context) {
      return Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
          child: InkWell(
            onTap: ()=>Get.toNamed(RouteConstants.otherUserProfileScreen,parameters: {'id':'${notificationData.sourceId}'}),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(50)),
                  child: SizedBox(
                    height: ScreenUtil().setSp(40),
                    width: ScreenUtil().setSp(40),
                    child: CachedNetworkImage(
                      imageUrl:
                          "${notificationData.targetMediaPath}${notificationData.sourceMedia}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setSp(8),
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: notificationData.source != null
                                ? "${notificationData.source} "
                                : "",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w700,
                                color: black,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: "recently ",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: blackGray,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: "joined ",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: buttonBlue,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: notificationData.data,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: blackGray,
                                fontSize: ScreenUtil().setSp(14))),
                      ])),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }

  Widget approved(NotificationData notificationData) {
    return Builder(builder: (BuildContext context) {
      return Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
          child: InkWell(
            onTap: (){
              Get.toNamed(RouteConstants.otherOrgProfileScreen,parameters: {'id':"${notificationData.sourceId}"});
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(50)),
                  child: SizedBox(
                    height: ScreenUtil().setSp(40),
                    width: ScreenUtil().setSp(40),
                    child: CachedNetworkImage(
                      imageUrl:
                          "${notificationData.targetMediaPath}${notificationData.sourceMedia}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setSp(8),
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: notificationData.data != null
                                ? "${notificationData.data} "
                                : "",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: "\"${notificationData.orgName}\" ",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w700,
                                color: blackGray,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            recognizer: TapGestureRecognizer()..onTap = () {},
                            text: "has been ",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: blackGray,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: "${notificationData.action ?? ''}. ",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: buttonBlue,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: "Visit Org here",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: buttonBlue,
                                fontSize: ScreenUtil().setSp(14))),
                      ])),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }

  Widget joinedMudda(NotificationData notificationData) {
    return Builder(builder: (BuildContext context) {
      return Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
          child: InkWell(
            onTap: ()=>Get.toNamed(RouteConstants.otherUserProfileScreen,parameters: {'id':'${notificationData.sourceId}'}),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(50)),
                  child: SizedBox(
                    height: ScreenUtil().setSp(40),
                    width: ScreenUtil().setSp(40),
                    child: CachedNetworkImage(
                      imageUrl:
                          "${notificationData.targetMediaPath}${notificationData.sourceMedia}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setSp(8),
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: notificationData.source != null
                                ? "${notificationData.source} "
                                : "",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w700,
                                color: black,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: "${notificationData.data ?? ''} ",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                color: blackGray,
                                fontSize: ScreenUtil().setSp(14))),
                        TextSpan(
                            text: "\"${notificationData.body}\" ",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w700,
                                color: buttonBlue,
                                fontSize: ScreenUtil().setSp(14))),
                      ])),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }

  Widget orgJoinRequest(NotificationData notificationData) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
      child: InkWell(
        onTap: ()=>Get.toNamed(RouteConstants.otherUserProfileScreen,parameters: {'id':'${notificationData.sourceId}'}),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(4)),
              child: SizedBox(
                height: ScreenUtil().setSp(40),
                width: ScreenUtil().setSp(40),
                child: CachedNetworkImage(
                  imageUrl:
                      "${notificationData.targetMediaPath}${notificationData.sourceMedia ?? ''}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: ScreenUtil().setSp(8),
            ),
            Expanded(
              child: Wrap(
                children: [
                  Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: notificationData.title != null
                            ? "${notificationData.title} - "
                            : "",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            color: color0060FF,
                            fontSize: ScreenUtil().setSp(14))),

                    TextSpan(
                        text: " ${notificationData.source}",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            color: black,
                            fontSize: ScreenUtil().setSp(14))),
                    TextSpan(
                        text: notificationData.data != null
                            ? " ${notificationData.data}"
                            : "",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w400,
                            color: black,
                            fontSize: ScreenUtil().setSp(14))),
                    // TextSpan(
                    //     text: notificationData.title ==
                    //         'Mudda Support'
                    //         ? " in Favour"
                    //         : 'in Opposition',
                    //     style: GoogleFonts.nunitoSans(
                    //         fontWeight: FontWeight.w400,
                    //         fontSize:
                    //         ScreenUtil().setSp(12),
                    //         color: buttonYellow)),
                    TextSpan(
                        text: " \"${notificationData.orgName}\"",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            fontSize: ScreenUtil().setSp(12),
                            color: black)),
                  ])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget muddaJoinRequest(NotificationData notificationData, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
      child: InkWell(
          onTap: ()=>Get.toNamed(RouteConstants.otherUserProfileScreen,parameters: {'id':'${notificationData.sourceId}'}),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(4)),
              child: SizedBox(
                height: ScreenUtil().setSp(40),
                width: ScreenUtil().setSp(40),
                child: CachedNetworkImage(
                  imageUrl: "${Const.url}user/${notificationData.sourceMedia}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: ScreenUtil().setSp(8),
            ),
            Expanded(
              child: Wrap(
                children: [
                  Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: notificationData.title != null
                            ? "${notificationData.title} - "
                            : "",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            color: color0060FF,
                            fontSize: ScreenUtil().setSp(14))),
                    if (notificationData.source != null)
                      TextSpan(
                          text: "${notificationData.source} ",
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w700,
                              color: black,
                              fontSize: ScreenUtil().setSp(14))),
                    TextSpan(
                        text: "${notificationData.data} ",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w400,
                            color: blackGray,
                            fontSize: ScreenUtil().setSp(14))),
                    TextSpan(
                        text: notificationData.body != null
                            ? "\"${notificationData.body}\""
                            : "",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            color: black,
                            fontSize: ScreenUtil().setSp(14))),
                  ])),
                ],
              ),
            ),
            Visibility(
              visible: notificationData.type == "RequestUser" &&
                  (notificationData.action == "invite" ||
                      notificationData.action == "request"),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      if ((notificationData.sourceType == "organisation" &&
                              notificationData.action == "invite") ||
                          (notificationData.type == "RequestUser" &&
                              notificationData.action == "request")) {
                        Api.post.call(context,
                            method: "request-to-user/update",
                            param: {
                              "_id": notificationData.storeId!,
                              "action": notificationData.action,
                            }, onResponseSuccess: (object) {
                          notificationController!.notificationList
                              .removeAt(index);
                          Get.back();
                        });
                      } else {
                        showJoinDialog(context, index,
                            notificationData.storeId!, notificationController!);
                        // showAcceptDialog(
                        //     context,
                        //     index,
                        //     notificationData.storeId!,
                        //     notificationController!);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setSp(5),
                          bottom: ScreenUtil().setSp(6),
                          left: ScreenUtil().setSp(8)),
                      child: Text(
                          notificationData.sourceType == "organisation" &&
                                  notificationData.action == "invite"
                              ? "Join"
                              : "Accept",
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w400,
                              color: black,
                              fontSize: ScreenUtil().setSp(14))),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Api.delete.call(context,
                          method:
                              "request-to-user/delete/${notificationData.storeId!}",
                          param: {}, onResponseSuccess: (object) {
                        notificationController!.notificationList
                            .removeAt(index);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setSp(6),
                          bottom: ScreenUtil().setSp(5),
                          left: ScreenUtil().setSp(8)),
                      child: Text(
                          notificationData.sourceType == "organisation" &&
                                  notificationData.action == "invite"
                              ? "Ignore"
                              : "Reject",
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w400,
                              color: black,
                              fontSize: ScreenUtil().setSp(14))),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget orgRemove(NotificationData notificationData) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
      child: InkWell(
        onTap: () {
          Get.toNamed(RouteConstants.otherOrgProfileScreen,parameters: {'id':'${notificationData.sourceId}'});
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(4)),
              child: SizedBox(
                height: ScreenUtil().setSp(40),
                width: ScreenUtil().setSp(40),
                child: CachedNetworkImage(
                  imageUrl: "${Const.url}user/${notificationData.sourceMedia}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: ScreenUtil().setSp(8),
            ),
            Expanded(
              child: Wrap(
                children: [
                  Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: notificationData.title != null
                            ? "${notificationData.title} - "
                            : "",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            color: color0060FF,
                            fontSize: ScreenUtil().setSp(14))),
                    if (notificationData.source != null)
                      TextSpan(
                          text: "${notificationData.source} ",
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w700,
                              color: black,
                              fontSize: ScreenUtil().setSp(14))),
                    TextSpan(
                        text: "${notificationData.data} ",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w400,
                            color: blackGray,
                            fontSize: ScreenUtil().setSp(14))),
                    TextSpan(
                        text: notificationData.orgName != null
                            ? "\"${notificationData.orgName}\""
                            : "",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            color: black,
                            fontSize: ScreenUtil().setSp(14))),
                  ])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  _notification(BuildContext context) async {
    Api.get.call(context, method: "notification/index", param: {
      "page": page.toString(),
      "userId": AppPreference().getString(PreferencesKey.userId),
    }, isLoading: false,onResponseSuccess: (Map object) {
      List<NotificationData> todayList = [];
      List<NotificationData> yesterdayList = [];
      List<NotificationData> lastWeekList = [];
      List<NotificationData> lastMonthList = [];
      var result = NotificationModel.fromJson(object);

      if (result.data!.isNotEmpty) {
        AppPreference _appPreference = AppPreference();
        NotificationData resultModel = result.data![0];

        _appPreference.setString(
            PreferencesKey.notificationId, resultModel.sId!);
        muddaNewsController?.isNotiAvailaable.value = false;
        for (int i = 0; i < result.data!.length; i++) {
          NotificationData resultModel = result.data![i];
          DateTime date = DateTime.parse(resultModel.updatedAt!);
          DateTime today = dateFormat.parse(dateFormat.format(DateTime.now()));
          DateTime yesterday = dateFormat
              .parse(dateFormat.format(DateTime.now()))
              .subtract(const Duration(days: 1));
          DateTime updatedAt = dateFormat.parse(dateFormat.format(date));
          if (updatedAt.compareTo(today) == 0) {
            if (todayList.isEmpty) {
              resultModel.durationTime = "Today";
            }
            todayList.add(resultModel);
          } else if (updatedAt.compareTo(yesterday) == 0) {
            if (yesterdayList.isEmpty) {
              resultModel.durationTime = "Yesterday";
            }
            yesterdayList.add(resultModel);
          } else if (updatedAt.month < today.month) {
            if (lastMonthList.isEmpty) {
              resultModel.durationTime = "Last Month";
            }
            lastMonthList.add(resultModel);
          } else {
            print("API_MONTH::${updatedAt.month}");
            print("TODAY_MONTH::${today.month}");
            if (lastWeekList.length == 0) {
              resultModel.durationTime = "Last Week";
            }
            lastWeekList.add(resultModel);
          }
        }
        notificationController!.notificationList.addAll(todayList);
        notificationController!.notificationList.addAll(yesterdayList);
        notificationController!.notificationList.addAll(lastWeekList);
        notificationController!.notificationList.addAll(lastMonthList);
      } else {
        page = page > 1 ? page-- : page;
      }
    });
  }
}

showAcceptDialog(BuildContext context, int index, String storeId,
    NotificationController notificationController) {
  return showDialog(
    context: Get.context as BuildContext,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          color: white,
          padding: EdgeInsets.only(
              top: ScreenUtil().setSp(24),
              left: ScreenUtil().setSp(24),
              right: ScreenUtil().setSp(24),
              bottom: ScreenUtil().setSp(24)),
          child: SizedBox(
            height: ScreenUtil().setSp(25),
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
              hint: Text("Join Mudda",
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil().setSp(12),
                      color: black)),
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil().setSp(12),
                  color: black),
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
                Api.post
                    .call(context, method: "request-to-user/update", param: {
                  "_id": storeId,
                  "user_identity": newValue == "Join Normal" ? "1" : "0",
                }, onResponseSuccess: (object) {
                  notificationController.notificationList.removeAt(index);
                  Get.back();
                });
              },
            ),
          ),
        ),
      );
    },
  );
}

showJoinDialog(BuildContext context, int index, String storeId,
    NotificationController notificationController) {
  final muddaNewsController = Get.put(MuddaNewsController());
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
                          muddaNewsController.isSelectRole.value = 0;
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
                              child: muddaNewsController.isSelectRole.value == 0
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
                                  style:
                                      muddaNewsController.isSelectRole.value ==
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
                          muddaNewsController.isSelectRole.value = 1;
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
                              child: muddaNewsController.isSelectRole.value == 1
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
                                  style:
                                      muddaNewsController.isSelectRole.value ==
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
                        Api.post.call(context,
                            method: "request-to-user/update",
                            param: {
                              "_id": storeId,
                              "user_identity":
                                  muddaNewsController.isSelectRole.value == 1
                                      ? "0"
                                      : "1",
                            }, onResponseSuccess: (object) {
                          notificationController.notificationList
                              .removeAt(index);
                          Get.back();
                        });
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
