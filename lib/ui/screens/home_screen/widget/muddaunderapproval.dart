import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/const/const.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/leader_board/view/leader_board_screen.dart';
import 'package:mudda/ui/screens/mudda/view/mudda_details_screen.dart';
import 'package:mudda/ui/screens/raising_mudda/controller/CreateMuddaController.dart';
import 'package:mudda/ui/shared/ReadMoreText.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../model/support_chat.dart';
import '../../notification/controller/NotificationController.dart';
import 'component/hot_mudda_post.dart';

class MuddaUnderApproval extends StatefulWidget {
  const MuddaUnderApproval({Key? key}) : super(key: key);

  @override
  State<MuddaUnderApproval> createState() => _MuddaUnderApprovalState();
}

class _MuddaUnderApprovalState extends State<MuddaUnderApproval> {
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  NotificationController notificationController =
      Get.find<NotificationController>();
  CreateMuddaController createMuddaController =
      Get.find<CreateMuddaController>();
  ScrollController muddaScrollController = ScrollController();
  MuddaPost? muddaPost;
  int page = 1;
  late AutoScrollController controller;
  final scrollDirection = Axis.vertical;

  Future _scrollToIndex() async {
    print("hello");
    await controller.scrollToIndex(2, preferPosition: AutoScrollPosition.begin);
  }

  @override
  void initState() {
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    Future.delayed(const Duration(seconds: 1), _scrollToIndex);
    muddaPost = muddaNewsController.muddaPost.value;
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        // page2++;
        _getMuddaPost(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 5;
    final double itemHeight = itemWidth;
    return RefreshIndicator(
      onRefresh: () async {
        muddaNewsController.waitingMuddaPostList.clear();
        page = 1;
        _getMuddaPost(context);
        // if (muddaPost!.isVerify == 3) {
        //   _getMuddaPost2(context);
        // } else {
        //   _getMuddaPost(context);
        // }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setSp(16), bottom: ScreenUtil().setSp(12)),
            child: Text(
              "Under Approval",
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w700,
                  fontSize: ScreenUtil().setSp(14),
                  color: blackGray),
            ),
          ),
          Obx(() => muddaNewsController.unapproveMuddaList.isNotEmpty &&
                      muddaNewsController.isFromOtherProfile.value == true ||
                  muddaNewsController.isFromNotification.value == true
              ? Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: muddaScrollController,
                      scrollDirection: scrollDirection,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
                      itemCount: muddaNewsController.unapproveMuddaList.length,
                      itemBuilder: (followersContext, index) {
                        MuddaPost muddaPost =
                            muddaNewsController.unapproveMuddaList[index];
                        muddaNewsController.muddaPost.value = muddaPost;
                        return AutoScrollTag(
                          index: index,
                          controller: controller,
                          key: ValueKey(index),
                          child: Container(
                            margin:
                                EdgeInsets.only(bottom: ScreenUtil().setSp(24)),
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setSp(10),
                                vertical: ScreenUtil().setSp(12)),
                            decoration: BoxDecoration(
                              color: colorWhite,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            muddaGalleryDialog(
                                                context,
                                                muddaPost.gallery!,
                                                muddaNewsController
                                                    .muddaProfilePath.value,
                                                index);
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setSp(8)),
                                            child: SizedBox(
                                              height: ScreenUtil().setSp(80),
                                              width: ScreenUtil().setSp(80),
                                              child: muddaPost.thumbnail == null
                                                  ? Container(
                                                      height: ScreenUtil()
                                                          .setSp(80),
                                                      width: ScreenUtil()
                                                          .setSp(80),
                                                      color:
                                                          grey.withOpacity(0.7),
                                                      child: const Icon(
                                                        Icons.person,
                                                        color: white,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl:
                                                          "${muddaNewsController.muddaProfilePath.value}${muddaPost.thumbnail}",
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(muddaPost.title!,
                                              style: GoogleFonts.nunitoSans(
                                                  fontSize:
                                                      ScreenUtil().setSp(14),
                                                  fontWeight: FontWeight.w700,
                                                  color: black)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Wrap(
                                                  children: [
                                                    Text(
                                                        muddaPost.initialScope!
                                                                    .toLowerCase() ==
                                                                "district"
                                                            ? muddaPost.city!
                                                            : muddaPost.initialScope!
                                                                        .toLowerCase() ==
                                                                    "state"
                                                                ? muddaPost
                                                                    .state!
                                                                : muddaPost.initialScope!.toLowerCase() ==
                                                                        "country"
                                                                    ? muddaPost
                                                                        .country!
                                                                    : muddaPost
                                                                        .initialScope!,
                                                        style: GoogleFonts
                                                            .nunitoSans(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: black)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: ScreenUtil().setSp(10),
                                              ),
                                              Column(
                                                children: [
                                                  Text.rich(TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: "Joined by",
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: black,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12))),
                                                        TextSpan(
                                                            text:
                                                                " ${NumberFormat.compactCurrency(
                                                              decimalDigits: 0,
                                                              symbol:
                                                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                            ).format(muddaPost.joinersCount ?? 0)} / ${muddaPost.initialScope!.toLowerCase() == "district" ? "11" : muddaPost.initialScope!.toLowerCase() == "state" ? "15" : muddaPost.initialScope!.toLowerCase() == "country" ? "20" : "25"}",
                                                            style: GoogleFonts.nunitoSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                color: black)),
                                                      ])),
                                                  muddaPost.initialScope!
                                                              .toLowerCase() !=
                                                          "district"
                                                      ? Text.rich(TextSpan(
                                                          children: <TextSpan>[
                                                              TextSpan(
                                                                  text: "From",
                                                                  style: GoogleFonts.nunitoSans(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color:
                                                                          black,
                                                                      fontSize:
                                                                          ScreenUtil()
                                                                              .setSp(12))),
                                                              TextSpan(
                                                                  text:
                                                                      " ${muddaPost.initialScope == "country" ? muddaPost.uniqueState! : muddaPost.initialScope == "state" ? muddaPost.uniqueCity! : muddaPost.uniqueCountry!}/${muddaPost.initialScope == "country" ? "3 states" : muddaPost.initialScope == "state" ? "3 districts" : "5 countries"}",
                                                                  style: GoogleFonts.nunitoSans(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              12),
                                                                      color:
                                                                          black)),
                                                            ]))
                                                      : Text.rich(
                                                          TextSpan(children: [
                                                          TextSpan(
                                                              text: "From",
                                                              style: GoogleFonts.nunitoSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: black,
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              12))),
                                                          TextSpan(
                                                              text:
                                                                  " 0 district",
                                                              style: GoogleFonts.nunitoSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              12),
                                                                  color: black))
                                                        ])),
                                                ],
                                              ),
                                              Visibility(
                                                visible: AppPreference()
                                                        .getString(
                                                            PreferencesKey
                                                                .userId) ==
                                                    muddaPost.leaders!
                                                        .elementAt(0)
                                                        .acceptUserDetail!
                                                        .sId,
                                                child: IconButton(
                                                    onPressed: () {
                                                      muddaNewsController
                                                          .muddaPost
                                                          .value = muddaPost;
                                                      Get.toNamed(RouteConstants
                                                          .invitedSearchScreen);
                                                    },
                                                    icon: SvgPicture.asset(
                                                        "assets/svg/ic_leader.svg",
                                                        height: ScreenUtil()
                                                            .setSp(20),
                                                        width: ScreenUtil()
                                                            .setSp(21))),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    /*muddaNewsController.muddaPost.value = muddaPost;
                                            inviteBottomSheet(context,muddaPost.sId!);*/
                                                    Share.share(
                                                      '${Const.shareUrl}mudda/${muddaPost.sId!}',
                                                    );
                                                  },
                                                  icon: SvgPicture.asset(
                                                      "assets/svg/share.svg"))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Vs(height: ScreenUtil().setSp(24)),
                                if (muddaPost.oppositionInvite != null ||
                                    muddaPost.favourInvite != null)
                                  Row(
                                    children: [
                                      getSizedBox(w: getWidth(12)),
                                      Text(
                                        muddaPost.favourInvite != null
                                            ? 'by Favour'
                                            : 'by Opposition',
                                        style: size12_M_regular(
                                            textColor:
                                                muddaPost.favourInvite != null
                                                    ? buttonBlue
                                                    : buttonYellow),
                                      ),
                                      getSizedBox(w: getWidth(12)),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Api.post.call(
                                              context,
                                              method: "request-to-user/update",
                                              param: {
                                                "_id":
                                                    muddaPost.oppositionInvite !=
                                                            null
                                                        ? muddaPost
                                                            .oppositionInvite!
                                                            .Id
                                                        : muddaPost
                                                            .favourInvite!.Id
                                              },
                                              onResponseSuccess: (object) {
                                                MuddaPost muddaPost =
                                                    muddaNewsController
                                                        .muddaPost.value;
                                                muddaPost.favourInvite = null;
                                                muddaPost.oppositionInvite =
                                                    null;
                                                muddaPost.isInvolved =
                                                    MyReaction.fromJson(
                                                        object['data']);
                                                muddaNewsController.muddaPost
                                                    .value = MuddaPost();
                                                muddaNewsController.muddaPost
                                                    .value = muddaPost;
                                                notificationController
                                                    .notificationList
                                                    .removeAt(
                                                        muddaNewsController
                                                            .notificationIndex
                                                            .value);
                                                setState(() {});
                                                // MyReaction newData = MyReaction();
                                                // newData.sId = object['data']['_id'];
                                                // newData.joinerType = object['data']['request_type'];
                                                // newData.joiningContentId = object['data']['joining_content_id'];
                                                // newData.requestToUserId = object['data']['request_to_user_id'];
                                                // newData.userId = object['data']['user_id'];
                                                // muddaNewsController.muddaPost.value
                                                //     .isInvolved = newData;
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: ScreenUtil().setSp(20),
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
                                                  textColor: black),
                                            )),
                                          ),
                                        ),
                                      ),
                                      getSizedBox(w: getWidth(12)),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Api.delete.call(context,
                                                method:
                                                    "request-to-user/delete/${muddaPost.oppositionInvite != null ? muddaPost.oppositionInvite!.Id : muddaPost.favourInvite!.Id}",
                                                param: {},
                                                onResponseSuccess: (object) {
                                              MuddaPost muddaPost =
                                                  muddaNewsController
                                                      .muddaPost.value;
                                              muddaPost.favourInvite = null;
                                              muddaPost.oppositionInvite = null;
                                              muddaNewsController.muddaPost
                                                  .value = MuddaPost();
                                              muddaNewsController
                                                  .muddaPost.value = muddaPost;
                                              notificationController
                                                  .notificationList
                                                  .removeAt(muddaNewsController
                                                      .notificationIndex.value);
                                              setState(() {});
                                            });
                                          },
                                          child: Container(
                                            height: ScreenUtil().setSp(20),
                                            decoration: BoxDecoration(
                                              color: white,
                                              border: Border.all(
                                                  color: grey, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'Ignore',
                                              style: size12_M_regular(
                                                  textColor: buttonYellow),
                                            )),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                else if (muddaPost.isInvolved != null ||
                                    muddaPost.amIRequested != null)
                                  Row(
                                    children: [
                                      Obx(() => muddaNewsController
                                                  .muddaPost.value.isInvolved ==
                                              null
                                          ? Expanded(
                                              child: Container(
                                                height: ScreenUtil().setSp(30),
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  border: Border.all(
                                                      color: grey, width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  'Pending Request',
                                                  style: size12_M_regular(
                                                      textColor: buttonBlue),
                                                )),
                                              ),
                                            )
                                          : Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Api.delete.call(
                                                    context,
                                                    method:
                                                        "request-to-user/joined-delete/${muddaPost.isInvolved!.sId}",
                                                    param: {
                                                      "_id": muddaPost
                                                          .isInvolved!.sId
                                                    },
                                                    onResponseSuccess:
                                                        (object) {
                                                      muddaPost.amIRequested =
                                                          null;
                                                      muddaNewsController
                                                          .muddaPost
                                                          .value
                                                          .isInvolved = null;
                                                      setState(() {});
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  height:
                                                      ScreenUtil().setSp(30),
                                                  decoration: BoxDecoration(
                                                    color: white,
                                                    border: Border.all(
                                                        color: grey, width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    'Leave Leadership',
                                                    style: size12_M_regular(
                                                        textColor: buttonBlue),
                                                  )),
                                                ),
                                              ),
                                            ))
                                    ],
                                  )
                                else if (muddaPost.amIRequested == null)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      getSizedBox(w: ScreenUtil().setSp(15)),
                                      Text(
                                        'Join Leadership',
                                        style: size12_M_regular(
                                            textColor: const Color(0xff31393C)),
                                      ),
                                      getSizedBox(w: ScreenUtil().setSp(8)),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => showJoinDialog(context,
                                              isFromFav: true),
                                          child: Container(
                                            height: ScreenUtil().setSp(20),
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
                                      ),
                                      getSizedBox(w: ScreenUtil().setSp(15)),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => showJoinDialog(context,
                                              isFromFav: false),
                                          child: Container(
                                            height: ScreenUtil().setSp(20),
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
                                      ),
                                      getSizedBox(w: ScreenUtil().setSp(15)),
                                    ],
                                  ),
                                Vs(height: ScreenUtil().setSp(27)),
                                // TODO: CHANGES
                                if (muddaPost.leaders != null)
                                  GridView.count(
                                    crossAxisCount: 5,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    childAspectRatio: (itemWidth / itemHeight),
                                    padding: EdgeInsets.only(
                                        left: ScreenUtil().setSp(2.5),
                                        right: ScreenUtil().setSp(2.5)),
                                    children: List.generate(
                                        muddaPost.leaders!.length, (index) {
                                      String path = muddaPost.leaders![index]
                                                  .acceptUserDetail !=
                                              null
                                          ? "${muddaNewsController.muddaUserProfilePath.value}${muddaPost.leaders![index].acceptUserDetail!.profile ?? ""}"
                                          : "";
                                      return muddaPost.leaders![index]
                                                  .acceptUserDetail !=
                                              null
                                          ? GestureDetector(
                                              onTap: () {
                                                if (muddaPost.leaders![index]
                                                        .userIdentity ==
                                                    0) {
                                                  anynymousDialogBox(context);
                                                } else {
                                                  muddaNewsController
                                                          .acceptUserDetail
                                                          .value =
                                                      muddaPost.leaders![index]
                                                          .acceptUserDetail!;
                                                  if (muddaPost
                                                          .leaders![index]
                                                          .acceptUserDetail!
                                                          .sId ==
                                                      AppPreference().getString(
                                                          PreferencesKey
                                                              .userId)) {
                                                    Get.toNamed(RouteConstants
                                                        .profileScreen);
                                                  } else {
                                                    Map<String, String>?
                                                        parameters = {
                                                      "userDetail": jsonEncode(
                                                          muddaPost
                                                              .leaders![index]
                                                              .acceptUserDetail!)
                                                    };
                                                    Get.toNamed(
                                                        RouteConstants
                                                            .otherUserProfileScreen,
                                                        parameters: parameters);
                                                  }
                                                }
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  muddaPost.leaders![index]
                                                              .userIdentity ==
                                                          0
                                                      ? Container(
                                                          height: ScreenUtil()
                                                              .setSp(40),
                                                          width: ScreenUtil()
                                                              .setSp(40),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: darkGray,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Text("A",
                                                                style: GoogleFonts.nunitoSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            20),
                                                                    color:
                                                                        black)),
                                                          ),
                                                        )
                                                      : muddaPost
                                                                  .leaders![
                                                                      index]
                                                                  .acceptUserDetail!
                                                                  .profile !=
                                                              null
                                                          ? CachedNetworkImage(
                                                              imageUrl: path,
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            40),
                                                                height:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            40),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      colorWhite,
                                                                  border: Border
                                                                      .all(
                                                                    width: ScreenUtil()
                                                                        .setSp(
                                                                            1),
                                                                    color: muddaPost.leaders![index].joinerType! ==
                                                                            "creator"
                                                                        ? buttonBlue
                                                                        : muddaPost.leaders![index].joinerType! ==
                                                                                "opposition"
                                                                            ? buttonYellow
                                                                            : white,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              ScreenUtil().setSp(20)) //                 <--- border radius here
                                                                          ),
                                                                  image: DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    lightGray,
                                                                radius:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            20),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    lightGray,
                                                                radius:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            20),
                                                              ),
                                                            )
                                                          : Container(
                                                              height:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                              width:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      darkGray,
                                                                ),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                    muddaPost
                                                                        .leaders![
                                                                            index]
                                                                        .acceptUserDetail!
                                                                        .fullname![
                                                                            0]
                                                                        .toUpperCase(),
                                                                    style: GoogleFonts.nunitoSans(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            ScreenUtil().setSp(
                                                                                20),
                                                                        color:
                                                                            black)),
                                                              ),
                                                            ),
                                                  Vs(height: 5.h),
                                                  Text(
                                                    muddaPost.leaders![index]
                                                                .userIdentity ==
                                                            0
                                                        ? "Anonymous"
                                                        : "${muddaPost.leaders![index].acceptUserDetail!.fullname}",
                                                    style: size10_M_regular300(
                                                        letterSpacing: 0.0,
                                                        textColor:
                                                            colorDarkBlack),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container();
                                    }),
                                  )
                                else
                                  const Text('No leaders'),

                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: colorF2F2F2,
                                ),

                                const Vs(
                                  height: 3,
                                ),

                                Wrap(
                                  children: [
                                    Text("Description: ",
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w700,
                                            fontSize: ScreenUtil().setSp(12),
                                            color: black)),
                                    muddaPost.muddaDescription != null &&
                                            muddaPost
                                                .muddaDescription!.isNotEmpty &&
                                            muddaPost.muddaDescription!.length >
                                                6
                                        ? ReadMoreText(
                                            muddaPost.muddaDescription ?? "",
                                            trimLines: 6,
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                color: black),
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: ' ...more',
                                            trimExpandedText: ' ...less')
                                        : muddaPost.muddaDescription != null &&
                                                muddaPost.muddaDescription!
                                                    .isNotEmpty
                                            ? Text(
                                                muddaPost
                                                        .muddaDescription ??
                                                    "",
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    color: black))
                                            : const Text(""),
                                  ],
                                ),
                                const Vs(
                                  height: 8,
                                ),
                                Text("Photo / Video:",
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: ScreenUtil().setSp(10),
                                        color: black)),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: colorF2F2F2,
                                ),
                                SizedBox(
                                  height: ScreenUtil().setSp(112),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: muddaPost.gallery!.length,
                                      padding: EdgeInsets.only(
                                          top: ScreenUtil().setSp(6),
                                          bottom: ScreenUtil().setSp(6)),
                                      itemBuilder: (followersContext, index) {
                                        String? video;
                                        if (muddaPost.gallery![index].file!
                                            .contains('.mp4')) {
                                          var fileToCompressPath =
                                              muddaPost.gallery![index].file;
                                          final fileFormat = fileToCompressPath!
                                              .substring(fileToCompressPath
                                                  .lastIndexOf('.'));
                                          video =
                                              "${fileToCompressPath.replaceAll(fileFormat, '')}-lg.png";
                                        }
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              muddaGalleryDialog(
                                                  context,
                                                  muddaPost.gallery!,
                                                  muddaNewsController
                                                      .muddaProfilePath.value,
                                                  index);
                                            },
                                            child: Container(
                                              height: ScreenUtil().setSp(100),
                                              width: ScreenUtil().setSp(100),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    height:
                                                        ScreenUtil().setSp(98),
                                                    width:
                                                        ScreenUtil().setSp(98),
                                                    imageUrl:
                                                        "${muddaNewsController.muddaProfilePath.value}${video ?? muddaPost.gallery!.elementAt(index).file!}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                  if (video != null)
                                                    Positioned(
                                                        top: 0,
                                                        bottom: 0,
                                                        left: 0,
                                                        right: 0,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: 30,
                                                              width: 30,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: white,
                                                              ),
                                                              child: const Icon(
                                                                  Icons
                                                                      .play_arrow),
                                                            ),
                                                          ],
                                                        ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: colorF2F2F2,
                                ),
                                const Vs(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(muddaPost.hashtags!.join(','),
                                          style: size10_M_normal(
                                              textColor: colorDarkBlack)),
                                    ),
                                    const Hs(width: 10),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colorDarkBlack),
                                        ),
                                        const Hs(width: 5),
                                        Text(
                                            "${muddaPost.city ?? ""}, ${muddaPost.state ?? ""}, ${muddaPost.country ?? ""}",
                                            style: size12_M_normal(
                                                textColor: colorDarkBlack)),
                                      ],
                                    ),
                                    const Hs(width: 10),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colorDarkBlack),
                                        ),
                                        const Hs(width: 5),
                                        Text(
                                            convertToAgo(DateTime.parse(
                                                muddaPost.createdAt!)),
                                            style: size10_M_normal(
                                                textColor: colorDarkBlack)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : Expanded(
                  child: muddaNewsController.waitingMuddaPostList.isEmpty
                      ? const Center(
                          child: Text('You don\'t have any Mudda under Approval'))
                      : ListView.builder(
                          shrinkWrap: true,
                          controller: muddaScrollController,
                          scrollDirection: scrollDirection,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding:
                              EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
                          itemCount:
                              muddaNewsController.waitingMuddaPostList.length,
                          itemBuilder: (followersContext, index) {
                            MuddaPost muddaPost =
                                muddaNewsController.waitingMuddaPostList[index];
                            return AutoScrollTag(
                              index: index,
                              controller: controller,
                              key: ValueKey(index),
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: ScreenUtil().setSp(24)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setSp(10),
                                    vertical: ScreenUtil().setSp(12)),
                                decoration: BoxDecoration(
                                  color: colorWhite,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                muddaGalleryDialog(
                                                    context,
                                                    muddaPost.gallery!,
                                                    muddaNewsController
                                                        .muddaProfilePath.value,
                                                    index);
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil().setSp(8)),
                                                child: SizedBox(
                                                  height:
                                                      ScreenUtil().setSp(80),
                                                  width: ScreenUtil().setSp(80),
                                                  child: muddaPost.thumbnail ==
                                                          null
                                                      ? Container(
                                                          height: ScreenUtil()
                                                              .setSp(80),
                                                          width: ScreenUtil()
                                                              .setSp(80),
                                                          color: grey
                                                              .withOpacity(0.7),
                                                          child: const Icon(
                                                            Icons.person,
                                                            color: white,
                                                            size: 40,
                                                          ),
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              "${muddaNewsController.muddaProfilePath.value}${muddaPost.thumbnail}",
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(muddaPost.title!,
                                                  style: GoogleFonts.nunitoSans(
                                                      fontSize: ScreenUtil()
                                                          .setSp(14),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: black)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Wrap(
                                                      children: [
                                                        Text(
                                                            muddaPost.initialScope!
                                                                        .toLowerCase() ==
                                                                    "district"
                                                                ? muddaPost
                                                                    .city!
                                                                : muddaPost
                                                                            .initialScope!
                                                                            .toLowerCase() ==
                                                                        "state"
                                                                    ? muddaPost
                                                                        .state!
                                                                    : muddaPost.initialScope!.toLowerCase() ==
                                                                            "country"
                                                                        ? muddaPost
                                                                            .country!
                                                                        : muddaPost
                                                                            .initialScope!,
                                                            style: GoogleFonts.nunitoSans(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: black)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        ScreenUtil().setSp(10),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text.rich(TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    "Joined by",
                                                                style: GoogleFonts.nunitoSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color:
                                                                        black,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12))),
                                                            TextSpan(
                                                                text:
                                                                    " ${NumberFormat.compactCurrency(
                                                                  decimalDigits:
                                                                      0,
                                                                  symbol:
                                                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                                ).format(muddaPost.joinersCount ?? 0)} / ${muddaPost.initialScope!.toLowerCase() == "district" ? "11" : muddaPost.initialScope!.toLowerCase() == "state" ? "15" : muddaPost.initialScope!.toLowerCase() == "country" ? "20" : "25"}",
                                                                style: GoogleFonts.nunitoSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            12),
                                                                    color:
                                                                        black)),
                                                          ])),
                                                      muddaPost.initialScope!
                                                                  .toLowerCase() !=
                                                              "district"
                                                          ? Text.rich(TextSpan(
                                                              children: <
                                                                  TextSpan>[
                                                                  TextSpan(
                                                                      text:
                                                                          "From",
                                                                      style: GoogleFonts.nunitoSans(
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              black,
                                                                          fontSize:
                                                                              ScreenUtil().setSp(12))),
                                                                  TextSpan(
                                                                      text:
                                                                          " ${muddaPost.initialScope == "country" ? muddaPost.uniqueState! : muddaPost.initialScope == "state" ? muddaPost.uniqueCity! : muddaPost.uniqueCountry!}/${muddaPost.initialScope == "country" ? "3 states" : muddaPost.initialScope == "state" ? "3 districts" : "5 countries"}",
                                                                      style: GoogleFonts.nunitoSans(
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize: ScreenUtil().setSp(
                                                                              12),
                                                                          color:
                                                                              black)),
                                                                ]))
                                                          : Text.rich(TextSpan(
                                                              children: [
                                                                  TextSpan(
                                                                      text:
                                                                          "From",
                                                                      style: GoogleFonts.nunitoSans(
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              black,
                                                                          fontSize:
                                                                              ScreenUtil().setSp(12))),
                                                                  TextSpan(
                                                                      text:
                                                                          " 0 district",
                                                                      style: GoogleFonts.nunitoSans(
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize: ScreenUtil().setSp(
                                                                              12),
                                                                          color:
                                                                              black))
                                                                ])),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    visible: AppPreference()
                                                            .getString(
                                                                PreferencesKey
                                                                    .userId) ==
                                                        muddaPost.leaders!
                                                            .elementAt(0)
                                                            .acceptUserDetail!
                                                            .sId,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          muddaNewsController
                                                                  .muddaPost
                                                                  .value =
                                                              muddaPost;
                                                          Get.toNamed(RouteConstants
                                                              .invitedSearchScreen);
                                                        },
                                                        icon: SvgPicture.asset(
                                                            "assets/svg/ic_leader.svg",
                                                            height: ScreenUtil()
                                                                .setSp(20),
                                                            width: ScreenUtil()
                                                                .setSp(21))),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        /*muddaNewsController.muddaPost.value = muddaPost;
                                            inviteBottomSheet(context,muddaPost.sId!);*/
                                                        Share.share(
                                                          '${Const.shareUrl}mudda/${muddaPost.sId!}',
                                                        );
                                                      },
                                                      icon: SvgPicture.asset(
                                                          "assets/svg/share.svg"))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Vs(height: ScreenUtil().setSp(24)),
                                    AppPreference().getString(
                                                PreferencesKey.userId) ==
                                            muddaPost.leaders!
                                                .elementAt(0)
                                                .acceptUserDetail!
                                                .sId
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    muddaNewsController
                                                        .muddaPost
                                                        .value = muddaPost;
                                                    muddaPost.isVerify != 3
                                                        ? null
                                                        : Api.get.call(context,
                                                            method:
                                                                "chats/admin-messages",
                                                            param: {
                                                              "muddaId":
                                                                  muddaPost.sId,
                                                            },
                                                            isLoading: false,
                                                            onResponseSuccess:
                                                                (Map object) {
                                                            log("-=-=- object -=- $object");
                                                            var result =
                                                                SupportChat
                                                                    .fromJson(
                                                                        object);
                                                            // adminMessage = object['result'][0]['data'];
                                                            createMuddaController
                                                                    .adminMessage
                                                                    .value =
                                                                result.result!
                                                                    .where((e) =>
                                                                        AppPreference().getString(PreferencesKey
                                                                            .userId) !=
                                                                        e.data!
                                                                            .senderId)
                                                                    .toList();
                                                            // AppPreference().getString(PreferencesKey.userId) == adminMessage['senderId']
                                                            log("-=-=- adminDetails -=- ${createMuddaController.adminMessage.value}");
                                                          });
                                                    Get.toNamed(
                                                        RouteConstants
                                                            .raisingMudda,
                                                        arguments: {
                                                          "adminMessage":
                                                              createMuddaController
                                                                  .adminMessage
                                                                  .value,
                                                        });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: ScreenUtil()
                                                            .setSp(5),
                                                        bottom: ScreenUtil()
                                                            .setSp(5)),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: muddaPost
                                                                  .isVerify ==
                                                              3
                                                          ? Border.all(
                                                              color: const Color(
                                                                  0xFFF8312F))
                                                          : Border.all(
                                                              color:
                                                                  colorA0A0A0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              ScreenUtil()
                                                                  .setSp(4)),
                                                    ),
                                                    child:
                                                        muddaPost.isVerify == 3
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Edit Mudda ",
                                                                    style: GoogleFonts
                                                                        .nunitoSans(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          ScreenUtil()
                                                                              .setSp(12),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "!",
                                                                    style: GoogleFonts
                                                                        .nunitoSans(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          ScreenUtil()
                                                                              .setSp(12),
                                                                      color: const Color(
                                                                          0xFFF8312F),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Text(
                                                                "Edit Mudda",
                                                                style: GoogleFonts
                                                                    .nunitoSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              12),
                                                                ),
                                                              ),
                                                  ),
                                                ),
                                              ),
                                              Hs(width: ScreenUtil().setSp(25)),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    // muddaNewsController.muddaPost.value =
                                                    //     muddaPost;
                                                    // muddaNewsController
                                                    //     .leaderBoardIndex.value = 2;
                                                    // Get.toNamed(RouteConstants
                                                    //     .leaderBoardApproval);

                                                    _showMyDialog(context,
                                                        muddaPost.sId!, index);

                                                    // muddaNewsController.muddaPost.value =
                                                    //     muddaPost;
                                                    // muddaNewsController
                                                    //     .leaderBoardIndex.value = 2;
                                                    // Get.toNamed(RouteConstants
                                                    //     .leaderBoardApproval);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: ScreenUtil()
                                                            .setSp(5),
                                                        bottom: ScreenUtil()
                                                            .setSp(5)),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: colorA0A0A0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              ScreenUtil()
                                                                  .setSp(4)),
                                                    ),
                                                    child: Text(
                                                      "Cancel Mudda",
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          12)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Hs(width: ScreenUtil().setSp(25)),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    muddaNewsController
                                                        .muddaPost
                                                        .value = muddaPost;
                                                    muddaNewsController
                                                        .leaderBoardIndex
                                                        .value = 0;
                                                    Get.toNamed(RouteConstants
                                                        .leaderBoardApproval);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: ScreenUtil()
                                                            .setSp(5),
                                                        bottom: ScreenUtil()
                                                            .setSp(5)),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: colorA0A0A0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              ScreenUtil()
                                                                  .setSp(4)),
                                                    ),
                                                    child: Text(
                                                      "Manage Leaders",
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          12)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  log('ok');
                                                  Api.delete.call(
                                                    context,
                                                    method:
                                                        "request-to-user/joined-delete/${muddaPost.isInvolved!.sId}",
                                                    param: {
                                                      "_id": muddaPost
                                                          .isInvolved!.sId
                                                    },
                                                    onResponseSuccess:
                                                        (object) {
                                                      MuddaPost muddaPost =
                                                          muddaNewsController
                                                              .muddaPost.value;
                                                      muddaPost.isInvolved =
                                                          null;
                                                      muddaNewsController
                                                          .muddaPost
                                                          .value = MuddaPost();
                                                      muddaNewsController
                                                          .muddaPost
                                                          .value = muddaPost;
                                                      muddaNewsController
                                                          .waitingMuddaPostList
                                                          .removeAt(index);
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  "Leave Leadership",
                                                  style: size12_M_regular(
                                                      textColor: black),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Api.post.call(
                                                    context,
                                                    method:
                                                        "mudda/reaction-on-mudda",
                                                    param: {
                                                      "user_id": AppPreference()
                                                          .getString(
                                                              PreferencesKey
                                                                  .userId),
                                                      "joining_content_id":
                                                          muddaPost.sId,
                                                      "action_type": "follow",
                                                    },
                                                    onResponseSuccess:
                                                        (object) {
                                                      muddaPost
                                                          .afterMe = object[
                                                                  'data'] !=
                                                              null
                                                          ? AfterMe.fromJson(
                                                              object['data'])
                                                          : null;
                                                      muddaPost.amIfollowing =
                                                          muddaPost.amIfollowing ==
                                                                  1
                                                              ? 0
                                                              : 1;
                                                      muddaNewsController
                                                              .waitingMuddaPostList[
                                                          index] = muddaPost;
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    const Hs(width: 10),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  colorDarkBlack),
                                                    ),
                                                    const Hs(width: 5),
                                                    Text(
                                                        muddaPost.amIfollowing ==
                                                                0
                                                            ? "Follow"
                                                            : "Following",
                                                        style: size12_M_normal(
                                                            textColor:
                                                                colorDarkBlack)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                    Vs(height: ScreenUtil().setSp(27)),
                                    // TODO: CHANGES
                                    if (muddaPost.leaders != null)
                                      GridView.count(
                                        crossAxisCount: 5,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        childAspectRatio:
                                            (itemWidth / itemHeight),
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setSp(2.5),
                                            right: ScreenUtil().setSp(2.5)),
                                        children: List.generate(
                                            muddaPost.leaders!.length, (index) {
                                          String path = muddaPost
                                                      .leaders![index]
                                                      .acceptUserDetail !=
                                                  null
                                              ? "${muddaNewsController.muddaUserProfilePath.value}${muddaPost.leaders![index].acceptUserDetail!.profile ?? ""}"
                                              : "";
                                          return muddaPost.leaders![index]
                                                      .acceptUserDetail !=
                                                  null
                                              ? GestureDetector(
                                                  onTap: () {
                                                    if (muddaPost
                                                            .leaders![index]
                                                            .userIdentity ==
                                                        0) {
                                                      anynymousDialogBox(
                                                          context);
                                                    } else {
                                                      muddaNewsController
                                                              .acceptUserDetail
                                                              .value =
                                                          muddaPost
                                                              .leaders![index]
                                                              .acceptUserDetail!;
                                                      if (muddaPost
                                                              .leaders![index]
                                                              .acceptUserDetail!
                                                              .sId ==
                                                          AppPreference()
                                                              .getString(
                                                                  PreferencesKey
                                                                      .userId)) {
                                                        Get.toNamed(
                                                            RouteConstants
                                                                .profileScreen);
                                                      } else {
                                                        Map<String, String>?
                                                            parameters = {
                                                          "userDetail":
                                                              jsonEncode(muddaPost
                                                                  .leaders![
                                                                      index]
                                                                  .acceptUserDetail!)
                                                        };
                                                        Get.toNamed(
                                                            RouteConstants
                                                                .otherUserProfileScreen,
                                                            parameters:
                                                                parameters);
                                                      }
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      muddaPost.leaders![index]
                                                                  .userIdentity ==
                                                              0
                                                          ? Container(
                                                              height:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                              width:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      darkGray,
                                                                ),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Center(
                                                                child: Text("A",
                                                                    style: GoogleFonts.nunitoSans(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            ScreenUtil().setSp(
                                                                                20),
                                                                        color:
                                                                            black)),
                                                              ),
                                                            )
                                                          : muddaPost
                                                                      .leaders![
                                                                          index]
                                                                      .acceptUserDetail!
                                                                      .profile !=
                                                                  null
                                                              ? CachedNetworkImage(
                                                                  imageUrl:
                                                                      path,
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    width: ScreenUtil()
                                                                        .setSp(
                                                                            40),
                                                                    height: ScreenUtil()
                                                                        .setSp(
                                                                            40),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          colorWhite,
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        width: ScreenUtil()
                                                                            .setSp(1),
                                                                        color: muddaPost.leaders![index].joinerType! ==
                                                                                "creator"
                                                                            ? buttonBlue
                                                                            : muddaPost.leaders![index].joinerType! == "opposition"
                                                                                ? buttonYellow
                                                                                : white,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
                                                                              ),
                                                                      image: DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .cover),
                                                                    ),
                                                                  ),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      CircleAvatar(
                                                                    backgroundColor:
                                                                        lightGray,
                                                                    radius: ScreenUtil()
                                                                        .setSp(
                                                                            20),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      CircleAvatar(
                                                                    backgroundColor:
                                                                        lightGray,
                                                                    radius: ScreenUtil()
                                                                        .setSp(
                                                                            20),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  height:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              40),
                                                                  width: ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color:
                                                                          darkGray,
                                                                    ),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                        muddaPost
                                                                            .leaders![
                                                                                index]
                                                                            .acceptUserDetail!
                                                                            .fullname![
                                                                                0]
                                                                            .toUpperCase(),
                                                                        style: GoogleFonts.nunitoSans(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: ScreenUtil().setSp(20),
                                                                            color: black)),
                                                                  ),
                                                                ),
                                                      Vs(height: 5.h),
                                                      Text(
                                                        muddaPost
                                                                    .leaders![
                                                                        index]
                                                                    .userIdentity ==
                                                                0
                                                            ? "Anonymous"
                                                            : "${muddaPost.leaders![index].acceptUserDetail!.fullname}",
                                                        style: size10_M_regular300(
                                                            letterSpacing: 0.0,
                                                            textColor:
                                                                colorDarkBlack),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container();
                                        }),
                                      )
                                    else
                                      const Text('No leaders'),
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: colorF2F2F2,
                                    ),
                                    const Vs(
                                      height: 3,
                                    ),
                                    Wrap(
                                      children: [
                                        Text("Description: ",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                color: black)),
                                        muddaPost.muddaDescription != null &&
                                                muddaPost.muddaDescription!
                                                    .isNotEmpty &&
                                                muddaPost.muddaDescription!
                                                        .length >
                                                    6
                                            ? ReadMoreText(
                                                muddaPost.muddaDescription ??
                                                    "",
                                                trimLines: 6,
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                    color: black),
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: ' ...more',
                                                trimExpandedText: ' ...less')
                                            : muddaPost.muddaDescription != null &&
                                                    muddaPost.muddaDescription!
                                                        .isNotEmpty
                                                ? Text(muddaPost.muddaDescription ?? "",
                                                    style: GoogleFonts.nunitoSans(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                        color: black))
                                                : const Text(""),
                                      ],
                                    ),
                                    const Vs(
                                      height: 8,
                                    ),
                                    Text("Photo / Video:",
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w700,
                                            fontSize: ScreenUtil().setSp(10),
                                            color: black)),
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: colorF2F2F2,
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setSp(112),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: muddaPost.gallery!.length,
                                          padding: EdgeInsets.only(
                                              top: ScreenUtil().setSp(6),
                                              bottom: ScreenUtil().setSp(6)),
                                          itemBuilder:
                                              (followersContext, index) {
                                            String? video;
                                            if (muddaPost.gallery![index].file!
                                                .contains('.mp4')) {
                                              var fileToCompressPath = muddaPost
                                                  .gallery![index].file;
                                              final fileFormat =
                                                  fileToCompressPath!.substring(
                                                      fileToCompressPath
                                                          .lastIndexOf('.'));
                                              video =
                                                  "${fileToCompressPath.replaceAll(fileFormat, '')}-lg.png";
                                            }
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  muddaGalleryDialog(
                                                      context,
                                                      muddaPost.gallery!,
                                                      muddaNewsController
                                                          .muddaProfilePath
                                                          .value,
                                                      index);
                                                },
                                                child: Container(
                                                  height:
                                                      ScreenUtil().setSp(100),
                                                  width:
                                                      ScreenUtil().setSp(100),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: Stack(
                                                    children: [
                                                      CachedNetworkImage(
                                                        height: ScreenUtil()
                                                            .setSp(98),
                                                        width: ScreenUtil()
                                                            .setSp(98),
                                                        imageUrl:
                                                            "${muddaNewsController.muddaProfilePath.value}${video ?? muddaPost.gallery!.elementAt(index).file!}",
                                                        fit: BoxFit.cover,
                                                      ),
                                                      if (video != null)
                                                        Positioned(
                                                            top: 0,
                                                            bottom: 0,
                                                            left: 0,
                                                            right: 0,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color:
                                                                        white,
                                                                  ),
                                                                  child: const Icon(
                                                                      Icons
                                                                          .play_arrow),
                                                                ),
                                                              ],
                                                            ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: colorF2F2F2,
                                    ),
                                    const Vs(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              muddaPost.hashtags!.join(','),
                                              style: size10_M_normal(
                                                  textColor: colorDarkBlack)),
                                        ),
                                        const Hs(width: 10),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: colorDarkBlack),
                                            ),
                                            const Hs(width: 5),
                                            Text(
                                                "${muddaPost.city ?? ""}, ${muddaPost.state ?? ""}, ${muddaPost.country ?? ""}",
                                                style: size12_M_normal(
                                                    textColor: colorDarkBlack)),
                                          ],
                                        ),
                                        const Hs(width: 10),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: colorDarkBlack),
                                            ),
                                            const Hs(width: 5),
                                            Text(
                                                convertToAgo(DateTime.parse(
                                                    muddaPost.createdAt!)),
                                                style: size10_M_normal(
                                                    textColor: colorDarkBlack)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                )),
        ],
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
                                child:
                                    muddaNewsController.isSelectRole.value == 0
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
                                    style: muddaNewsController
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
                                child:
                                    muddaNewsController.isSelectRole.value == 1
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
                                    style: muddaNewsController
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
                              Api.post.call(
                                context,
                                method: "request-to-user/store",
                                param: {
                                  "user_id": AppPreference()
                                      .getString(PreferencesKey.userId),
                                  "request_to_user_id": muddaNewsController
                                      .muddaPost.value.leaders![0].userId,
                                  "joining_content_id":
                                      muddaNewsController.muddaPost.value.sId,
                                  "requestModalPath": muddaNewsController
                                      .muddaProfilePath.value,
                                  "requestModal": "RealMudda",
                                  "request_type": "leader",
                                  "user_identity":
                                      muddaNewsController.isSelectRole.value ==
                                              1
                                          ? "0"
                                          : "1",
                                },
                                onResponseSuccess: (object) {
                                  log("JOIN:::-=-=-=- $object");
                                  MuddaPost muddaPost =
                                      muddaNewsController.muddaPost.value;
                                  muddaPost.amIRequested =
                                      MyReaction.fromJson(object['data']);
                                  muddaNewsController.muddaPost.value =
                                      MuddaPost();
                                  muddaNewsController.muddaPost.value =
                                      muddaPost;
                                  setState(() {});
                                  Get.back();
                                },
                              );
                            }
                          } else {
                            if (AppPreference()
                                .getBool(PreferencesKey.isGuest)) {
                              updateProfileDialog(context);
                            } else {
                              Api.post.call(
                                context,
                                method: "request-to-user/store",
                                param: {
                                  "user_id": AppPreference()
                                      .getString(PreferencesKey.userId),
                                  "request_to_user_id": muddaNewsController
                                      .muddaPost.value.leaders![0].userId,
                                  "joining_content_id":
                                      muddaNewsController.muddaPost.value.sId,
                                  "requestModalPath": muddaNewsController
                                      .muddaProfilePath.value,
                                  "requestModal": "RealMudda",
                                  "request_type": "opposition",
                                  "user_identity":
                                      muddaNewsController.isSelectRole.value ==
                                              1
                                          ? "0"
                                          : "1",
                                },
                                onResponseSuccess: (object) {
                                  log("JOIN:::-=-=-=-=-= $object");
                                  MuddaPost muddaPost =
                                      muddaNewsController.muddaPost.value;
                                  muddaPost.isInvolved =
                                      MyReaction.fromJson(object['data']);
                                  muddaNewsController.muddaPost.value =
                                      MuddaPost();
                                  muddaNewsController.muddaPost.value =
                                      muddaPost;
                                  setState(() {});
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

  Future<bool?> _showMyDialog(
      BuildContext context, String muddaId, int index) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Are you sure Delete the Mudda?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Api.delete.call(
                  context,
                  method: "mudda/delete/$muddaId",
                  isLoading: true,
                  param: {},
                  onResponseSuccess: (object) {
                    Get.back();

                    muddaNewsController.waitingMuddaPostList.removeAt(index);

                    print("gdfd" + object.toString());
                  },
                );
              },
            ),
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
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

  _getMuddaPost(BuildContext context) async {
    if(muddaNewsController.unapproveMuddaList.isNotEmpty &&
        muddaNewsController.isFromOtherProfile.value == true ||
        muddaNewsController.isFromNotification.value == true)
    {
      return;
    } else {
      muddaNewsController.isFromOtherProfile.value = false;
      muddaNewsController.isFromNotification.value = false;
      Api.get.call(context,
          method: "mudda/my-engagement",
          param: {
            "page": page.toString(),
            "isVerify": "0",
            "user_id": AppPreference().getString(PreferencesKey.userId)
          },
          isLoading: false, onResponseSuccess: (Map object) {
            var result = MuddaPostModel.fromJson(object);
            if (result.data!.isNotEmpty) {
              muddaNewsController.muddaProfilePath.value = result.path!;
              muddaNewsController.muddaUserProfilePath.value = result.userpath!;
              muddaNewsController.waitingMuddaPostList.addAll(result.data!);
            } else {
              page = page > 1 ? page - 1 : page;
            }
          });
    }

  }

  _getMuddaPost2(BuildContext context) async {
    Api.get.call(context,
        method: "mudda/my-engagement",
        param: {
          "page": page.toString(),
          "isVerify": "3",
          "user_id": AppPreference().getString(PreferencesKey.userId)
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = MuddaPostModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        muddaNewsController.muddaProfilePath.value = result.path!;
        muddaNewsController.muddaUserProfilePath.value = result.userpath!;
        muddaNewsController.waitingMuddaPostList.addAll(result.data!);
        log("length==>${muddaNewsController.waitingMuddaPostList.length}");
      } else {
        page = page > 1 ? page - 1 : page;
      }
    });
  }
}

// class MuddaUnderApproval extends GetView<MuddaNewsController> {
//   MuddaUnderApproval({
//     Key? key,
//   }) : super(key: key);
//
//   MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
//   CreateMuddaController createMuddaController  = Get.find<CreateMuddaController>();
//   ScrollController muddaScrollController = ScrollController();
//   MuddaPost? muddaPost;
//   int page = 1;
//
//   // int page2 = 1;
//
//   @override
//   Widget build(BuildContext context) {
//     muddaScrollController.addListener(() {
//       if (muddaScrollController.position.maxScrollExtent ==
//           muddaScrollController.position.pixels) {
//         page++;
//         // page2++;
//         // _getMuddaPost(context);
//       }
//     });
//     _getMuddaPost2(context);
//     var size = MediaQuery.of(context).size;
//     final double itemWidth = size.width / 5;
//     final double itemHeight = itemWidth;
//     return RefreshIndicator(
//       onRefresh: () async {
//         log('-=- isVerify -=-=- ${muddaPost!.isVerify}');
//         muddaNewsController.waitingMuddaPostList.clear();
//         page = 1;
//         // page2 = 1;
//         if (muddaPost!.isVerify == 3) {
//           _getMuddaPost2(context);
//         } else {
//           _getMuddaPost(context);
//         }
//       },
//       child: Obx(
//         () => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                   left: ScreenUtil().setSp(16), bottom: ScreenUtil().setSp(12)),
//               child: Text(
//                 "Under Approval",
//                 style: GoogleFonts.nunitoSans(
//                     fontWeight: FontWeight.w700,
//                     fontSize: ScreenUtil().setSp(14),
//                     color: blackGray),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                   shrinkWrap: true,
//                   controller: muddaScrollController,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   padding: EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
//                   itemCount: muddaNewsController.waitingMuddaPostList.length,
//                   itemBuilder: (followersContext, index) {
//                     MuddaPost muddaPost =
//                         muddaNewsController.waitingMuddaPostList[index];
//                     return Container(
//                       margin: EdgeInsets.only(bottom: ScreenUtil().setSp(24)),
//                       padding: EdgeInsets.symmetric(
//                           horizontal: ScreenUtil().setSp(10),
//                           vertical: ScreenUtil().setSp(12)),
//                       decoration: BoxDecoration(
//                         color: colorWhite,
//                         boxShadow: [
//                           BoxShadow(
//                             color: colorBlack.withOpacity(0.25),
//                             offset: const Offset(
//                               0.0,
//                               4.0,
//                             ),
//                             blurRadius: 4,
//                             spreadRadius: 0.8,
//                           ), //BoxShadow//BoxShadow
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       muddaVideoDialog(
//                                           context,
//                                           muddaPost.gallery!,
//                                           muddaNewsController
//                                               .muddaProfilePath.value,
//                                           index);
//                                     },
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(
//                                           ScreenUtil().setSp(8)),
//                                       child: SizedBox(
//                                         height: ScreenUtil().setSp(80),
//                                         width: ScreenUtil().setSp(80),
//                                         child: muddaPost.thumbnail == null
//                                             ? Container(
//                                                 height: ScreenUtil().setSp(80),
//                                                 width: ScreenUtil().setSp(80),
//                                                 color: grey.withOpacity(0.7),
//                                                 child: const Icon(
//                                                   Icons.person,
//                                                   color: white,
//                                                   size: 40,
//                                                 ),
//                                               )
//                                             : CachedNetworkImage(
//                                                 imageUrl:
//                                                     "${muddaNewsController.muddaProfilePath.value}${muddaPost.thumbnail}",
//                                                 fit: BoxFit.cover,
//                                               ),
//                                       ),
//                                     ),
//                                   ),
//                                   /*Container(
//                                     padding: EdgeInsets.symmetric(horizontal: 4.w),
//                                     decoration: BoxDecoration(
//                                         border: Border.all(color: colorWhite),
//                                         borderRadius: BorderRadius.circular(5)),
//                                     child: const Icon(
//                                       Icons.play_arrow_outlined,
//                                       color: colorWhite,
//                                     ),
//                                   )*/
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: ScreenUtil().setSp(8),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(muddaPost.title!,
//                                         style: GoogleFonts.nunitoSans(
//                                             fontSize: ScreenUtil().setSp(14),
//                                             fontWeight: FontWeight.w700,
//                                             color: black)),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           child: Wrap(
//                                             children: [
//                                               Text(
//                                                   muddaPost.initialScope!
//                                                               .toLowerCase() ==
//                                                           "district"
//                                                       ? muddaPost.city!
//                                                       : muddaPost.initialScope!
//                                                                   .toLowerCase() ==
//                                                               "state"
//                                                           ? muddaPost.state!
//                                                           : muddaPost.initialScope!
//                                                                       .toLowerCase() ==
//                                                                   "country"
//                                                               ? muddaPost
//                                                                   .country!
//                                                               : muddaPost
//                                                                   .initialScope!,
//                                                   style: GoogleFonts.nunitoSans(
//                                                       fontSize: ScreenUtil()
//                                                           .setSp(12),
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                       color: black)),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: ScreenUtil().setSp(10),
//                                         ),
//                                         Column(
//                                           children: [
//                                             Text.rich(
//                                                 TextSpan(children: <TextSpan>[
//                                               TextSpan(
//                                                   text: "Joined by",
//                                                   style: GoogleFonts.nunitoSans(
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       color: black,
//                                                       fontSize: ScreenUtil()
//                                                           .setSp(12))),
//                                               TextSpan(
//                                                   text:
//                                                       " ${NumberFormat.compactCurrency(
//                                                     decimalDigits: 0,
//                                                     symbol:
//                                                         '', // if you want to add currency symbol then pass that in this else leave it empty.
//                                                   ).format(muddaPost.joinersCount! + 1 ?? 0)} / ${muddaPost.initialScope!.toLowerCase() == "district" ? "11" : muddaPost.initialScope!.toLowerCase() == "state" ? "15" : muddaPost.initialScope!.toLowerCase() == "country" ? "20" : "25"}",
//                                                   style: GoogleFonts.nunitoSans(
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                       fontSize: ScreenUtil()
//                                                           .setSp(12),
//                                                       color: black)),
//                                             ])),
//                                             muddaPost.initialScope!
//                                                         .toLowerCase() !=
//                                                     "district"
//                                                 ? Text.rich(TextSpan(
//                                                     children: <TextSpan>[
//                                                         TextSpan(
//                                                             text: "From",
//                                                             style: GoogleFonts.nunitoSans(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400,
//                                                                 color: black,
//                                                                 fontSize:
//                                                                     ScreenUtil()
//                                                                         .setSp(
//                                                                             12))),
//                                                         TextSpan(
//                                                             text:
//                                                                 " ${muddaPost.initialScope == "country" ? muddaPost.uniqueState! : muddaPost.initialScope == "state" ? muddaPost.uniqueCity! : muddaPost.uniqueCountry!}/${muddaPost.initialScope == "country" ? "3 states" : muddaPost.initialScope == "state" ? "3 districts" : "5 countries"}",
//                                                             style: GoogleFonts.nunitoSans(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700,
//                                                                 fontSize:
//                                                                     ScreenUtil()
//                                                                         .setSp(
//                                                                             12),
//                                                                 color: black)),
//                                                       ]))
//                                                 : Text.rich(TextSpan(children: [
//                                                     TextSpan(
//                                                         text: "From",
//                                                         style: GoogleFonts
//                                                             .nunitoSans(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400,
//                                                                 color: black,
//                                                                 fontSize:
//                                                                     ScreenUtil()
//                                                                         .setSp(
//                                                                             12))),
//                                                     TextSpan(
//                                                         text: " 0 district",
//                                                         style: GoogleFonts
//                                                             .nunitoSans(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700,
//                                                                 fontSize:
//                                                                     ScreenUtil()
//                                                                         .setSp(
//                                                                             12),
//                                                                 color: black))
//                                                   ])),
//                                           ],
//                                         ),
//                                         Visibility(
//                                           visible: AppPreference().getString(
//                                                   PreferencesKey.userId) ==
//                                               muddaPost.leaders!
//                                                   .elementAt(0)
//                                                   .acceptUserDetail!
//                                                   .sId,
//                                           child: IconButton(
//                                               onPressed: () {
//                                                 Get.toNamed(
//                                                         RouteConstants
//                                                             .invitedSearchScreen,
//                                                         arguments:
//                                                             muddaPost.sId!)!
//                                                     .then((value) {
//                                                   if (value) {
//                                                     muddaNewsController
//                                                         .waitingMuddaPostList
//                                                         .clear();
//                                                     page = 1;
//                                                     // page2 = 1;
//                                                     return _getMuddaPost(
//                                                         context);
//                                                   }
//                                                 });
//                                               },
//                                               icon: SvgPicture.asset(
//                                                   "assets/svg/invite.svg",
//                                                   height:
//                                                       ScreenUtil().setSp(20),
//                                                   width:
//                                                       ScreenUtil().setSp(21))),
//                                         ),
//                                         IconButton(
//                                             onPressed: () {
//                                               /*muddaNewsController.muddaPost.value = muddaPost;
//                                           inviteBottomSheet(context,muddaPost.sId!);*/
//                                               Share.share(
//                                                 '${Const.shareUrl}mudda/${muddaPost.sId!}',
//                                               );
//                                             },
//                                             icon: SvgPicture.asset(
//                                                 "assets/svg/share.svg"))
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Vs(height: ScreenUtil().setSp(24)),
//                           AppPreference().getString(PreferencesKey.userId) ==
//                                   muddaPost.leaders!
//                                       .elementAt(0)
//                                       .acceptUserDetail!
//                                       .sId
//                               ? Row(
//                                   children: [
//                                     Expanded(
//                                       child: InkWell(
//                                         onTap: () {
//                                           muddaNewsController.muddaPost.value =
//                                               muddaPost;
//                                         muddaPost.isVerify !=3 ? null:  Api.get.call(context,
//                                             method: "chats/admin-messages",
//                                             param: {
//                                               "muddaId": muddaPost.sId,
//                                             },
//                                             isLoading: false,
//                                             onResponseSuccess: (Map object) {
//                                               log("-=-=- object -=- $object");
//                                               var result = SupportChat.fromJson(object);
//                                               // adminMessage = object['result'][0]['data'];
//                                               createMuddaController.adminMessage.value = result.result!
//                                                   .where((e) =>
//                                               AppPreference().getString(
//                                                   PreferencesKey
//                                                       .userId) !=
//                                                   e.data!.senderId)
//                                                   .toList();
//                                               // AppPreference().getString(PreferencesKey.userId) == adminMessage['senderId']
//                                               log("-=-=- adminDetails -=- ${createMuddaController.adminMessage.value}");
//                                             });
//                                           Get.toNamed(
//                                               RouteConstants.raisingMudda,
//                                               arguments: {
//                                                 "adminMessage": createMuddaController.adminMessage.value,
//                                               });
//                                         },
//                                         child: Container(
//                                           padding: EdgeInsets.only(
//                                               top: ScreenUtil().setSp(5),
//                                               bottom: ScreenUtil().setSp(5)),
//                                           alignment: Alignment.center,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             border: muddaPost.isVerify == 3
//                                                 ? Border.all(
//                                                     color: Color(0xFFF8312F))
//                                                 : Border.all(
//                                                     color: colorA0A0A0),
//                                             borderRadius: BorderRadius.circular(
//                                                 ScreenUtil().setSp(4)),
//                                           ),
//                                           child: muddaPost.isVerify == 3
//                                               ? Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       "Edit Mudda ",
//                                                       style: GoogleFonts
//                                                           .nunitoSans(
//                                                         fontWeight:
//                                                             FontWeight.w400,
//                                                         fontSize: ScreenUtil()
//                                                             .setSp(12),
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       "!",
//                                                       style: GoogleFonts
//                                                           .nunitoSans(
//                                                         fontWeight:
//                                                             FontWeight.w400,
//                                                         fontSize: ScreenUtil()
//                                                             .setSp(12),
//                                                         color: const Color(
//                                                             0xFFF8312F),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 )
//                                               : Text(
//                                                   "Edit Mudda",
//                                                   style: GoogleFonts.nunitoSans(
//                                                     fontWeight: FontWeight.w400,
//                                                     fontSize:
//                                                         ScreenUtil().setSp(12),
//                                                   ),
//                                                 ),
//                                         ),
//                                       ),
//                                     ),
//                                     Hs(width: ScreenUtil().setSp(25)),
//                                     Expanded(
//                                       child: InkWell(
//                                         onTap: () {
//                                           muddaNewsController.muddaPost.value =
//                                               muddaPost;
//                                           muddaNewsController
//                                               .leaderBoardIndex.value = 2;
//                                           Get.toNamed(RouteConstants
//                                               .leaderBoardApproval);
//                                         },
//                                         child: Container(
//                                           padding: EdgeInsets.only(
//                                               top: ScreenUtil().setSp(5),
//                                               bottom: ScreenUtil().setSp(5)),
//                                           alignment: Alignment.center,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             border:
//                                                 Border.all(color: colorA0A0A0),
//                                             borderRadius: BorderRadius.circular(
//                                                 ScreenUtil().setSp(4)),
//                                           ),
//                                           child: Text(
//                                             "Join Requests",
//                                             style: GoogleFonts.nunitoSans(
//                                                 fontWeight: FontWeight.w400,
//                                                 fontSize:
//                                                     ScreenUtil().setSp(12)),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Hs(width: ScreenUtil().setSp(25)),
//                                     Expanded(
//                                       child: InkWell(
//                                         onTap: () {
//                                           muddaNewsController.muddaPost.value =
//                                               muddaPost;
//                                           muddaNewsController
//                                               .leaderBoardIndex.value = 0;
//                                           Get.toNamed(RouteConstants
//                                               .leaderBoardApproval);
//                                         },
//                                         child: Container(
//                                           padding: EdgeInsets.only(
//                                               top: ScreenUtil().setSp(5),
//                                               bottom: ScreenUtil().setSp(5)),
//                                           alignment: Alignment.center,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             border:
//                                                 Border.all(color: colorA0A0A0),
//                                             borderRadius: BorderRadius.circular(
//                                                 ScreenUtil().setSp(4)),
//                                           ),
//                                           child: Text(
//                                             "Manage Leaders",
//                                             style: GoogleFonts.nunitoSans(
//                                                 fontWeight: FontWeight.w400,
//                                                 fontSize:
//                                                     ScreenUtil().setSp(12)),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   InkWell(
//                                     onTap: (){
//                                       // Api.delete.call(
//                                       //   context,
//                                       //   method:
//                                       //   "request-to-user/joined-delete/${muddaNewsController.muddaPost.value.isInvolved!.sId}",
//                                       //   param: {
//                                       //     "_id": muddaNewsController.muddaPost
//                                       //         .value.isInvolved!.sId
//                                       //   },
//                                       //   onResponseSuccess: (object) {
//                                       //     MuddaPost muddaPost = muddaNewsController.muddaPost.value;
//                                       //     muddaPost.isInvolved = null;
//                                       //     muddaNewsController.muddaPost
//                                       //         .value = MuddaPost();
//                                       //     muddaNewsController.muddaPost
//                                       //         .value = muddaPost;
//                                       //     Get.back();
//                                       //   },
//                                       // );
//                                     },
//                                     child: Text(
//                                       "Leave Leadership",
//                                       style: size12_M_regular(textColor: black),
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       Api.post.call(
//                                         context,
//                                         method: "mudda/reaction-on-mudda",
//                                         param: {
//                                           "user_id": AppPreference()
//                                               .getString(
//                                                   PreferencesKey.userId),
//                                           "joining_content_id": muddaPost.sId,
//                                           "action_type": "follow",
//                                         },
//                                         onResponseSuccess: (object) {
//                                           muddaPost.afterMe =
//                                               object['data'] != null
//                                                   ? AfterMe.fromJson(
//                                                       object['data'])
//                                                   : null;
//                                           muddaPost.amIfollowing =
//                                               muddaPost.amIfollowing == 1
//                                                   ? 0
//                                                   : 1;
//                                           muddaNewsController
//                                                   .waitingMuddaPostList[
//                                               index] = muddaPost;
//                                         },
//                                       );
//                                     },
//                                     child: Row(
//                                       children: [
//                                         const Hs(width: 10),
//                                         Container(
//                                           padding: const EdgeInsets.all(2),
//                                           decoration: const BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: colorDarkBlack),
//                                         ),
//                                         const Hs(width: 5),
//                                         Text(
//                                             muddaPost.amIfollowing == 0
//                                                 ? "Follow"
//                                                 : "Following",
//                                             style: size12_M_normal(
//                                                 textColor: colorDarkBlack)),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                           Vs(height: ScreenUtil().setSp(27)),
//                           GridView.count(
//                             crossAxisCount: 5,
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             childAspectRatio: (itemWidth / itemHeight),
//                             padding: EdgeInsets.only(
//                                 left: ScreenUtil().setSp(2.5),
//                                 right: ScreenUtil().setSp(2.5)),
//                             children: List.generate(muddaPost.leaders!.length,
//                                 (index) {
//                               String path =
//                                   "${muddaNewsController.muddaUserProfilePath.value}${muddaPost.leaders![index].acceptUserDetail!.profile ?? ""}";
//                               return GestureDetector(
//                                 onTap: () {
//                                   if (muddaPost.leaders![index].userIdentity ==
//                                       0) {
//                                     anynymousDialogBox(context);
//                                   } else {
//                                     muddaNewsController.acceptUserDetail.value =
//                                         muddaPost
//                                             .leaders![index].acceptUserDetail!;
//                                     if (muddaPost.leaders![index]
//                                             .acceptUserDetail!.sId ==
//                                         AppPreference()
//                                             .getString(PreferencesKey.userId)) {
//                                       Get.toNamed(RouteConstants.profileScreen);
//                                     } else {
//                                       Map<String, String>? parameters = {
//                                         "userDetail": jsonEncode(muddaPost
//                                             .leaders![index].acceptUserDetail!)
//                                       };
//                                       Get.toNamed(
//                                           RouteConstants.otherUserProfileScreen,
//                                           parameters: parameters);
//                                     }
//                                   }
//                                 },
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     muddaPost.leaders![index].userIdentity == 0
//                                         ? Container(
//                                             height: ScreenUtil().setSp(40),
//                                             width: ScreenUtil().setSp(40),
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                 color: darkGray,
//                                               ),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: Center(
//                                               child: Text("A",
//                                                   style: GoogleFonts.nunitoSans(
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       fontSize: ScreenUtil()
//                                                           .setSp(20),
//                                                       color: black)),
//                                             ),
//                                           )
//                                         : muddaPost
//                                                     .leaders![index]
//                                                     .acceptUserDetail!
//                                                     .profile !=
//                                                 null
//                                             ? CachedNetworkImage(
//                                                 imageUrl: path,
//                                                 imageBuilder:
//                                                     (context, imageProvider) =>
//                                                         Container(
//                                                   width: ScreenUtil().setSp(40),
//                                                   height:
//                                                       ScreenUtil().setSp(40),
//                                                   decoration: BoxDecoration(
//                                                     color: colorWhite,
//                                                     border: Border.all(
//                                                       width:
//                                                           ScreenUtil().setSp(1),
//                                                       color: muddaPost
//                                                                   .leaders![
//                                                                       index]
//                                                                   .joinerType! ==
//                                                               "creator"
//                                                           ? buttonBlue
//                                                           : muddaPost
//                                                                       .leaders![
//                                                                           index]
//                                                                       .joinerType! ==
//                                                                   "opposition"
//                                                               ? buttonYellow
//                                                               : white,
//                                                     ),
//                                                     borderRadius: BorderRadius.all(
//                                                         Radius.circular(
//                                                             ScreenUtil().setSp(
//                                                                 20)) //                 <--- border radius here
//                                                         ),
//                                                     image: DecorationImage(
//                                                         image: imageProvider,
//                                                         fit: BoxFit.cover),
//                                                   ),
//                                                 ),
//                                                 placeholder: (context, url) =>
//                                                     CircleAvatar(
//                                                   backgroundColor: lightGray,
//                                                   radius:
//                                                       ScreenUtil().setSp(20),
//                                                 ),
//                                                 errorWidget:
//                                                     (context, url, error) =>
//                                                         CircleAvatar(
//                                                   backgroundColor: lightGray,
//                                                   radius:
//                                                       ScreenUtil().setSp(20),
//                                                 ),
//                                               )
//                                             : Container(
//                                                 height: ScreenUtil().setSp(40),
//                                                 width: ScreenUtil().setSp(40),
//                                                 decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                     color: darkGray,
//                                                   ),
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                       muddaPost
//                                                           .leaders![index]
//                                                           .acceptUserDetail!
//                                                           .fullname![0]
//                                                           .toUpperCase(),
//                                                       style: GoogleFonts
//                                                           .nunitoSans(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w400,
//                                                               fontSize:
//                                                                   ScreenUtil()
//                                                                       .setSp(
//                                                                           20),
//                                                               color: black)),
//                                                 ),
//                                               ),
//                                     Vs(height: 5.h),
//                                     Text(
//                                       muddaPost.leaders![index].userIdentity ==
//                                               0
//                                           ? "Anonymous"
//                                           : "${muddaPost.leaders![index].acceptUserDetail!.fullname}",
//                                       style: size10_M_regular300(
//                                           letterSpacing: 0.0,
//                                           textColor: colorDarkBlack),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }),
//                           ),
//                           Container(
//                             width: double.infinity,
//                             height: 1,
//                             color: colorF2F2F2,
//                           ),
//                           const Vs(
//                             height: 3,
//                           ),
//                           Wrap(
//                             children: [
//                               Text("Description: ",
//                                   style: GoogleFonts.nunitoSans(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: ScreenUtil().setSp(12),
//                                       color: black)),
//                               muddaPost.muddaDescription != null &&
//                                       muddaPost.muddaDescription!.isNotEmpty &&
//                                       muddaPost.muddaDescription!.length > 6
//                                   ? ReadMoreText(
//                                       muddaPost.muddaDescription ?? "",
//                                       trimLines: 6,
//                                       style: GoogleFonts.nunitoSans(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: ScreenUtil().setSp(12),
//                                           color: black),
//                                       trimMode: TrimMode.Line,
//                                       trimCollapsedText: ' ...more',
//                                       trimExpandedText: ' ...less')
//                                   : muddaPost.muddaDescription != null &&
//                                           muddaPost.muddaDescription!.isNotEmpty
//                                       ? Text(muddaPost.muddaDescription ?? "",
//                                           style: GoogleFonts.nunitoSans(
//                                               fontWeight: FontWeight.w400,
//                                               fontSize: ScreenUtil().setSp(12),
//                                               color: black))
//                                       : const Text(""),
//                             ],
//                           ),
//                           const Vs(
//                             height: 8,
//                           ),
//                           Text("Photo / Video:",
//                               style: GoogleFonts.nunitoSans(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: ScreenUtil().setSp(10),
//                                   color: black)),
//                           Container(
//                             width: double.infinity,
//                             height: 1,
//                             color: colorF2F2F2,
//                           ),
//                           SizedBox(
//                             height: ScreenUtil().setSp(112),
//                             child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: muddaPost.gallery!.length,
//                                 padding: EdgeInsets.only(
//                                     top: ScreenUtil().setSp(6),
//                                     bottom: ScreenUtil().setSp(6)),
//                                 itemBuilder: (followersContext, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(right: 10),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         muddaGalleryDialog(
//                                             context,
//                                             muddaPost.gallery!,
//                                             muddaNewsController
//                                                 .muddaProfilePath.value,
//                                             index);
//                                       },
//                                       child: Container(
//                                         height: ScreenUtil().setSp(100),
//                                         width: ScreenUtil().setSp(100),
//                                         decoration: BoxDecoration(
//                                             border:
//                                                 Border.all(color: Colors.grey)),
//                                         child: CachedNetworkImage(
//                                           imageUrl:
//                                               "${muddaNewsController.muddaProfilePath.value}${muddaPost.gallery!.elementAt(index).file!}",
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                           ),
//                           Container(
//                             width: double.infinity,
//                             height: 1,
//                             color: colorF2F2F2,
//                           ),
//                           const Vs(
//                             height: 4,
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(muddaPost.hashtags!.join(','),
//                                     style: size10_M_normal(
//                                         textColor: colorDarkBlack)),
//                               ),
//                               const Hs(width: 10),
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(2),
//                                     decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: colorDarkBlack),
//                                   ),
//                                   const Hs(width: 5),
//                                   Text(
//                                       "${muddaPost.city ?? ""}, ${muddaPost.state ?? ""}, ${muddaPost.country ?? ""}",
//                                       style: size12_M_normal(
//                                           textColor: colorDarkBlack)),
//                                 ],
//                               ),
//                               const Hs(width: 10),
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(2),
//                                     decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: colorDarkBlack),
//                                   ),
//                                   const Hs(width: 5),
//                                   Text(
//                                       convertToAgo(
//                                           DateTime.parse(muddaPost.createdAt!)),
//                                       style: size10_M_normal(
//                                           textColor: colorDarkBlack)),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String convertToAgo(DateTime input) {
//     Duration diff = DateTime.now().difference(input);
//
//     if (diff.inDays >= 1) {
//       return '${diff.inDays} d ago';
//     } else if (diff.inHours >= 1) {
//       return '${diff.inHours} hr ago';
//     } else if (diff.inMinutes >= 1) {
//       return '${diff.inMinutes} mins ago';
//     } else if (diff.inSeconds >= 1) {
//       return '${diff.inSeconds} sec ago';
//     } else {
//       return 'just now';
//     }
//   }
//
//   _getMuddaPost(BuildContext context) async {
//     Api.get.call(context,
//         method: "mudda/my-engagement",
//         param: {
//           "page": page.toString(),
//           "isVerify": "0",
//           "user_id": AppPreference().getString(PreferencesKey.userId)
//         },
//         isLoading: false, onResponseSuccess: (Map object) {
//
//       var result = MuddaPostModel.fromJson(object);
//       if (result.data!.isNotEmpty) {
//         muddaNewsController.muddaProfilePath.value = result.path!;
//         muddaNewsController.muddaUserProfilePath.value = result.userpath!;
//         muddaNewsController.waitingMuddaPostList.addAll(result.data!);
//       } else {
//         page = page > 1 ? page - 1 : page;
//       }
//     });
//   }
//
//   _getMuddaPost2(BuildContext context) async {
//     Api.get.call(context,
//         method: "mudda/my-engagement",
//         param: {
//           "page": page.toString(),
//           "isVerify": "3",
//           "user_id": AppPreference().getString(PreferencesKey.userId)
//         },
//         isLoading: false, onResponseSuccess: (Map object) {
//       var result = MuddaPostModel.fromJson(object);
//       if (result.data!.isNotEmpty) {
//         muddaNewsController.muddaProfilePath.value = result.path!;
//         muddaNewsController.muddaUserProfilePath.value = result.userpath!;
//         muddaNewsController.waitingMuddaPostList.addAll(result.data!);
//         log("length==>${muddaNewsController.waitingMuddaPostList.length}");
//       } else {
//         page = page > 1 ? page - 1 : page;
//       }
//     });
//   }
// }
