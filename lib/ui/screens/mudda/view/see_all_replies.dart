import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/local/DatabaseProvider.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/PostForMuddaModel.dart';
import 'package:mudda/model/UserRolesModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/mudda/view/replies_view.dart';
import 'package:mudda/ui/shared/AdHelper.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import '../../../../model/RepliesResponseModel.dart';
import '../../../shared/Mudda_Containier_Ad.dart';
import '../widget/favour_view.dart';
import '../widget/mudda_post_comment.dart';
import '../widget/oppotion_view.dart';
import '../widget/reply_widget.dart';
import 'mudda_details_screen.dart';


class VideoController {
  void Function(bool b)? onPause;
  void Function()? onPlayCheck;
  bool Function()? onIsPlaying;
  void Function(bool b)? onMute;
}

class SeeAllRepliesScreen extends StatefulWidget {
  SeeAllRepliesScreen({Key? key}) : super(key: key);


  @override
  State<SeeAllRepliesScreen> createState() => _SeeAllRepliesScreenState();
}

class _SeeAllRepliesScreenState extends State<SeeAllRepliesScreen> {
  MuddaNewsController? muddaNewsController;
  ScrollController muddaScrollController = ScrollController();
  int topPage = 1;
  int downPage = 1;
  int page=1;
  int rolePage = 1;
  ScrollController roleController = ScrollController();




  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {});
      }
    });
    muddaScrollController.addListener(() {
      if (muddaScrollController.offset >= muddaScrollController.position.maxScrollExtent &&
          !muddaScrollController.position.outOfRange) {
        //bottom
        pagination(lastReadReply: "${muddaNewsController!.seeAllRepliesList.last.sId}", type: 'next');
        downPage++;
      }
      if (muddaScrollController.offset <= muddaScrollController.position.minScrollExtent &&
          !muddaScrollController.position.outOfRange) {
        //top

        pagination(lastReadReply: "${muddaNewsController!.seeAllRepliesList.first.sId}", type: 'prev');
        topPage++;
      }
    });
    muddaNewsController = Get.find<MuddaNewsController>();
    muddaNewsController!.seeAllRepliesList.clear();
    fetchRecentPost();

    roleController.addListener(() {
      if (roleController.position.maxScrollExtent ==
          roleController.position.pixels) {
        rolePage++;
        _getRoles(context);
      }

    });
  }

  fetchRecentPost() async{
    Api.get.call(context,
        method: "post-for-mudda/replies",
        param: {
          "muddaId": muddaNewsController!.muddaPost.value.sId,
          "parentId": muddaNewsController!.postForMudda.value.sId,
          "page" : '1',
          "sort": '1'
        },
        isLoading: false, onResponseSuccess: (Map object) {
          var result = RepliesResponseModel.fromJson(object);
          if (result.result!.isNotEmpty) {
            muddaNewsController!.seeAllRepliesList.clear();
            muddaNewsController!.seeAllRepliesList.addAll(result.result!);
          }
        });
  }

  pagination({required String lastReadReply,required String type}){
    Api.get.call(context,
        method: "post-for-mudda/replies",
        param: {
          "muddaId": muddaNewsController!.muddaPost.value.sId,
          "parentId":  muddaNewsController!.postForMudda.value.sId,
          "lastReadReply":lastReadReply,
          "posts": type,
          "page": type=='prev'? topPage.toString() : downPage.toString()
        },
        isLoading: false, onResponseSuccess: (Map object) {
          var result = RepliesResponseModel.fromJson(object);
          if (result.result!.isNotEmpty) {
            result.result!.forEach((element) {
              PostForMudda responseModelResult = element;
              muddaNewsController!.seeAllRepliesList.add(responseModelResult);
            });
            if (mounted) {
              setState(() {});
            }
          }else{
            topPage = topPage > 1 ? topPage - 1 : topPage;
            downPage = downPage > 1 ? downPage - 1 : downPage;
          }
        });
  }


  @override
  void dispose() {
    muddaNewsController?.isRepliesShowInSeeAll.value =false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body:Obx(() => muddaNewsController?.seeAllRepliesList.length==0? Center(child: Text('No Replies Found')): Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Obx(
                      () => RefreshIndicator(
                    onRefresh: () {
                      muddaNewsController!.seeAllRepliesList.clear();
                      page = 1;
                      return fetchRecentPost();
                    },
                    child: ListView.builder(
                        controller: muddaScrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: muddaNewsController!.seeAllRepliesList.length,
                        padding: EdgeInsets.only(
                            bottom: ScreenUtil().setSp(100), top: 8),
                        // reverse: true,
                        itemBuilder: (followersContext, index) {
                          PostForMudda postForMudda =
                          muddaNewsController!.seeAllRepliesList[index];
                          if (index != 0 && index % 7 == 0) {
                            return Obx(() => Column(
                              children: [
                                MuddaContainerAD(),
                                postForMudda.postIn == "favour"
                                    ? Column(
                                  children: [
                                    getSizedBox(
                                        h: ScreenUtil().setSp(20)),
                                    MuddaVideoBox(
                                        postForMudda,
                                        muddaNewsController!
                                            .postForMuddaPath.value,
                                        index,
                                        muddaNewsController!
                                            .muddaUserProfilePath
                                            .value),
                                    //TODO: favour -FIXED
                                    // Container(
                                    //   margin: const EdgeInsets.only(
                                    //       left: 40, right: 16),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       InkWell(
                                    //         onTap: () {
                                    //           muddaNewsController!
                                    //               .isRepliesShow.value =
                                    //           !muddaNewsController!
                                    //               .isRepliesShow.value;
                                    //           muddaNewsController!.height.value = Get.height * 0.4;
                                    //           muddaNewsController!.width.value = Get.width;
                                    //           muddaNewsController!.currentIndex.value = index;
                                    //           setState(() {});
                                    //         },
                                    //         child: Column(
                                    //           children: [
                                    //             Row(
                                    //               children: [
                                    //                 SvgPicture.asset(
                                    //                   AppIcons.icReply,
                                    //                 ),
                                    //                 SizedBox(width: 5),
                                    //                 Text(
                                    //                   postForMudda.replies ==
                                    //                       null
                                    //                       ? "-"
                                    //                       : "${postForMudda.replies}",
                                    //                   style:
                                    //                   size12_M_regular(
                                    //                       textColor:
                                    //                       black),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //             Visibility(
                                    //               child:
                                    //               SvgPicture.asset(
                                    //                 AppIcons.icArrowDown,
                                    //                 color: grey,
                                    //               ),
                                    //               visible: muddaNewsController!
                                    //                   .isRepliesShow.value &&
                                    //                   muddaNewsController!.currentIndex.value == index,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           muddaNewsController!.postForMudda.value = postForMudda;
                                    //           showModalBottomSheet(
                                    //               context: context,
                                    //               builder: (context) {
                                    //                 return CommentsPost();
                                    //               });
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //               // AppIcons.replyIcon,
                                    //               AppIcons.iconComments,
                                    //               height: 16,
                                    //               width: 16,
                                    //             ),
                                    //             const SizedBox(width: 5),
                                    //             Text(
                                    //                 NumberFormat
                                    //                     .compactCurrency(
                                    //                   decimalDigits: 0,
                                    //                   symbol:
                                    //                   '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //                 ).format(postForMudda
                                    //                     .commentorsCount),
                                    //                 style: GoogleFonts
                                    //                     .nunitoSans(
                                    //                     fontWeight:
                                    //                     FontWeight
                                    //                         .w400,
                                    //                     fontSize:
                                    //                     ScreenUtil()
                                    //                         .setSp(
                                    //                         12),
                                    //                     color:
                                    //                     blackGray)),
                                    //
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       InkWell(
                                    //         onTap: () {
                                    //           if (AppPreference().getBool(
                                    //               PreferencesKey.isGuest)) {
                                    //             Get.toNamed(RouteConstants
                                    //                 .userProfileEdit);
                                    //           } else {
                                    //             Api.post.call(
                                    //               context,
                                    //               method: "like/store",
                                    //               isLoading: false,
                                    //               param: {
                                    //                 "user_id": AppPreference()
                                    //                     .getString(
                                    //                     PreferencesKey
                                    //                         .interactUserId),
                                    //                 "relative_id":
                                    //                 postForMudda.sId,
                                    //                 "relative_type":
                                    //                 "PostForMudda",
                                    //                 "status": false
                                    //               },
                                    //               onResponseSuccess:
                                    //                   (object) {
                                    //                 print(
                                    //                     "Abhishek $object");
                                    //               },
                                    //             );
                                    //             if (postForMudda
                                    //                 .agreeStatus ==
                                    //                 false) {
                                    //               postForMudda.agreeStatus =
                                    //               null;
                                    //               postForMudda
                                    //                   .dislikersCount =
                                    //                   postForMudda
                                    //                       .dislikersCount! -
                                    //                       1;
                                    //             } else {
                                    //               postForMudda
                                    //                   .dislikersCount =
                                    //                   postForMudda
                                    //                       .dislikersCount! +
                                    //                       1;
                                    //               postForMudda
                                    //                   .likersCount = postForMudda
                                    //                   .likersCount ==
                                    //                   0
                                    //                   ? postForMudda
                                    //                   .likersCount
                                    //                   : postForMudda
                                    //                   .likersCount! -
                                    //                   1;
                                    //               postForMudda.agreeStatus =
                                    //               false;
                                    //             }
                                    //             int pIndex = index;
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .removeAt(index);
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .insert(pIndex, postForMudda);
                                    //           }
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //                 postForMudda.agreeStatus ==
                                    //                     false
                                    //                     ? AppIcons
                                    //                     .dislikeFill
                                    //                     : AppIcons.dislike,
                                    //                 height: 16,
                                    //                 width: 16,
                                    //                 color: postForMudda
                                    //                     .agreeStatus ==
                                    //                     false
                                    //                     ?  colorF1B008
                                    //                     : blackGray),
                                    //             const SizedBox(width: 5),
                                    //             postForMudda.agreeStatus ==
                                    //                 false
                                    //                 ? Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.dislikersCount)} Disagree",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ?
                                    //                   colorF1B008
                                    //                       : blackGray),
                                    //             )
                                    //                 : Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.dislikersCount)}",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ?
                                    //                   colorF1B008
                                    //                       : blackGray),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       InkWell(
                                    //         onTap: () {
                                    //           if (AppPreference().getBool(
                                    //               PreferencesKey.isGuest)) {
                                    //             Get.toNamed(RouteConstants
                                    //                 .userProfileEdit);
                                    //           } else {
                                    //             Api.post.call(
                                    //               context,
                                    //               method: "like/store",
                                    //               isLoading: false,
                                    //               param: {
                                    //                 "user_id": AppPreference()
                                    //                     .getString(
                                    //                     PreferencesKey
                                    //                         .interactUserId),
                                    //                 "relative_id":
                                    //                 postForMudda.sId,
                                    //                 "relative_type":
                                    //                 "PostForMudda",
                                    //                 "status": true
                                    //               },
                                    //               onResponseSuccess:
                                    //                   (object) {},
                                    //             );
                                    //             if (postForMudda
                                    //                 .agreeStatus ==
                                    //                 true) {
                                    //               postForMudda.agreeStatus =
                                    //               null;
                                    //               postForMudda.likersCount =
                                    //                   postForMudda
                                    //                       .likersCount! -
                                    //                       1;
                                    //             } else {
                                    //               postForMudda.likersCount =
                                    //                   postForMudda
                                    //                       .likersCount! +
                                    //                       1;
                                    //               postForMudda
                                    //                   .dislikersCount = postForMudda
                                    //                   .dislikersCount ==
                                    //                   0
                                    //                   ? postForMudda
                                    //                   .dislikersCount
                                    //                   : postForMudda
                                    //                   .dislikersCount! -
                                    //                   1;
                                    //
                                    //               postForMudda.agreeStatus =
                                    //               true;
                                    //             }
                                    //             int pIndex = index;
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .removeAt(index);
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .insert(pIndex,
                                    //                 postForMudda);
                                    //           }
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //                 postForMudda.agreeStatus ==
                                    //                     true
                                    //                     ? AppIcons
                                    //                     .handIconFill
                                    //                     : AppIcons.handIcon,
                                    //                 height: 16,
                                    //                 width: 16,
                                    //                 color: postForMudda
                                    //                     .agreeStatus ==
                                    //                     true
                                    //                     ?  color0060FF
                                    //                     : blackGray),
                                    //             const SizedBox(width: 5),
                                    //             postForMudda.agreeStatus ==
                                    //                 true
                                    //                 ? Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.likersCount)} Agree",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? color0060FF
                                    //                       : blackGray),
                                    //             )
                                    //                 : Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.likersCount)}",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ?  color0060FF
                                    //                       : blackGray),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    getSizedBox(
                                        h: ScreenUtil().setSp(12)),
                                    Obx(() => Visibility(
                                      child: ReplyWidget(
                                        postForMudda:
                                        postForMudda,
                                        index: index,
                                      ),
                                      visible: muddaNewsController!
                                          .isRepliesShow
                                          .value &&
                                          muddaNewsController!
                                              .currentIndex
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
                                    getSizedBox(
                                        h: ScreenUtil().setSp(20)),
                                    MuddaOppositionVideoBox(
                                        postForMudda,
                                        muddaNewsController!
                                            .postForMuddaPath.value,
                                        index,
                                        muddaNewsController!
                                            .muddaUserProfilePath
                                            .value),
                                    // TODO: Opposition - FIXED
                                    // Container(
                                    //   // padding: EdgeInsets.only(
                                    //   //     left: ScreenUtil().setSp(64),
                                    //   //     right: ScreenUtil().setSp(19)),
                                    //   padding: const EdgeInsets.only(
                                    //       right: 16, left: 16),
                                    //   margin: const EdgeInsets.only(
                                    //       left: 0, right: 40),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       InkWell(
                                    //         onTap: () {
                                    //           muddaNewsController!
                                    //               .isRepliesShow.value =
                                    //           !muddaNewsController!
                                    //               .isRepliesShow.value;
                                    //           muddaNewsController!.height.value = Get.height * 0.4;
                                    //           muddaNewsController!.width.value = Get.width;
                                    //           muddaNewsController!.currentIndex.value = index;
                                    //           setState(() {});
                                    //         },
                                    //         child: Column(
                                    //           children: [
                                    //             Row(
                                    //               children: [
                                    //                 SvgPicture.asset(
                                    //                   AppIcons.icReply,
                                    //                 ),
                                    //                 SizedBox(width: 5),
                                    //                 Text(
                                    //                   postForMudda.replies ==
                                    //                       null
                                    //                       ? "-"
                                    //                       : "${postForMudda.replies}",
                                    //                   style:
                                    //                   size12_M_regular(
                                    //                       textColor:
                                    //                       black),
                                    //                 ),
                                    //
                                    //               ],
                                    //             ),
                                    //             Visibility(
                                    //               child:
                                    //               SvgPicture.asset(
                                    //                 AppIcons.icArrowDown,
                                    //                 color: grey,
                                    //               ),
                                    //               visible: muddaNewsController!
                                    //                   .isRepliesShow.value &&
                                    //                   muddaNewsController!.currentIndex.value == index,
                                    //             ),
                                    //
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           muddaNewsController!.postForMudda.value = postForMudda;
                                    //           showModalBottomSheet(
                                    //               context: context,
                                    //               builder: (context) {
                                    //                 return CommentsPost();
                                    //               });
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //               // AppIcons.replyIcon,
                                    //               AppIcons.iconComments,
                                    //               height: 16,
                                    //               width: 16,
                                    //             ),
                                    //             const SizedBox(width: 5),
                                    //             Text(
                                    //                 NumberFormat
                                    //                     .compactCurrency(
                                    //                   decimalDigits: 0,
                                    //                   symbol:
                                    //                   '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //                 ).format(postForMudda
                                    //                     .commentorsCount),
                                    //                 style: GoogleFonts
                                    //                     .nunitoSans(
                                    //                     fontWeight:
                                    //                     FontWeight
                                    //                         .w400,
                                    //                     fontSize:
                                    //                     ScreenUtil()
                                    //                         .setSp(
                                    //                         12),
                                    //                     color:
                                    //                     blackGray)),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       InkWell(
                                    //         onTap: () {
                                    //           if (AppPreference().getBool(
                                    //               PreferencesKey.isGuest)) {
                                    //             Get.toNamed(RouteConstants
                                    //                 .userProfileEdit);
                                    //           } else {
                                    //             Api.post.call(
                                    //               context,
                                    //               method: "like/store",
                                    //               isLoading: false,
                                    //               param: {
                                    //                 "user_id": AppPreference()
                                    //                     .getString(
                                    //                     PreferencesKey
                                    //                         .interactUserId),
                                    //                 "relative_id":
                                    //                 postForMudda.sId,
                                    //                 "relative_type":
                                    //                 "PostForMudda",
                                    //                 "status": false,
                                    //               },
                                    //               onResponseSuccess:
                                    //                   (object) {
                                    //                 print(
                                    //                     "Abhishek $object");
                                    //               },
                                    //             );
                                    //             if (postForMudda
                                    //                 .agreeStatus ==
                                    //                 false) {
                                    //               postForMudda.agreeStatus =
                                    //               null;
                                    //               postForMudda
                                    //                   .dislikersCount =
                                    //                   postForMudda
                                    //                       .dislikersCount! -
                                    //                       1;
                                    //             } else {
                                    //               postForMudda
                                    //                   .dislikersCount =
                                    //                   postForMudda
                                    //                       .dislikersCount! +
                                    //                       1;
                                    //               postForMudda
                                    //                   .likersCount = postForMudda
                                    //                   .likersCount ==
                                    //                   0
                                    //                   ? postForMudda
                                    //                   .likersCount
                                    //                   : postForMudda
                                    //                   .likersCount! -
                                    //                   1;
                                    //               ;
                                    //               postForMudda.agreeStatus =
                                    //               false;
                                    //             }
                                    //             int pIndex = index;
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .removeAt(index);
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .insert(pIndex,
                                    //                 postForMudda);
                                    //           }
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //                 postForMudda.agreeStatus ==
                                    //                     false
                                    //                     ? AppIcons
                                    //                     .dislikeFill
                                    //                     : AppIcons.dislike,
                                    //                 height: 16,
                                    //                 width: 16,
                                    //                 color: postForMudda
                                    //                     .agreeStatus ==
                                    //                     false
                                    //                     ? const Color(
                                    //                     0xFFF1B008)
                                    //                     : blackGray),
                                    //             const SizedBox(width: 5),
                                    //             postForMudda.agreeStatus ==
                                    //                 false
                                    //                 ? Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.dislikersCount)} Disagree",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? const Color(
                                    //                       0xFFF1B008)
                                    //                       : blackGray),
                                    //             )
                                    //                 : Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.dislikersCount)}",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? const Color(
                                    //                       0xFFF1B008)
                                    //                       : blackGray),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       InkWell(
                                    //         onTap: () {
                                    //           if (AppPreference().getBool(
                                    //               PreferencesKey.isGuest)) {
                                    //             Get.toNamed(RouteConstants
                                    //                 .userProfileEdit);
                                    //           } else {
                                    //             Api.post.call(
                                    //               context,
                                    //               method: "like/store",
                                    //               isLoading: false,
                                    //               param: {
                                    //                 "user_id": AppPreference()
                                    //                     .getString(
                                    //                     PreferencesKey
                                    //                         .interactUserId),
                                    //                 "relative_id":
                                    //                 postForMudda.sId,
                                    //                 "relative_type":
                                    //                 "PostForMudda",
                                    //                 "status": true
                                    //               },
                                    //               onResponseSuccess:
                                    //                   (object) {},
                                    //             );
                                    //             if (postForMudda
                                    //                 .agreeStatus ==
                                    //                 true) {
                                    //               postForMudda.agreeStatus =
                                    //               null;
                                    //               postForMudda.likersCount =
                                    //                   postForMudda
                                    //                       .likersCount! -
                                    //                       1;
                                    //             } else {
                                    //               postForMudda.likersCount =
                                    //                   postForMudda
                                    //                       .likersCount! +
                                    //                       1;
                                    //               postForMudda
                                    //                   .dislikersCount = postForMudda
                                    //                   .dislikersCount ==
                                    //                   0
                                    //                   ? postForMudda
                                    //                   .dislikersCount
                                    //                   : postForMudda
                                    //                   .dislikersCount! -
                                    //                   1;
                                    //
                                    //               postForMudda.agreeStatus =
                                    //               true;
                                    //             }
                                    //             int pIndex = index;
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .removeAt(index);
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .insert(pIndex,
                                    //                 postForMudda);
                                    //           }
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //                 postForMudda.agreeStatus ==
                                    //                     true
                                    //                     ? AppIcons
                                    //                     .handIconFill
                                    //                     : AppIcons.handIcon,
                                    //                 height: 16,
                                    //                 width: 16,
                                    //                 color: postForMudda
                                    //                     .agreeStatus ==
                                    //                     true
                                    //                     ? const Color(
                                    //                     0xFF0060FF)
                                    //                     : blackGray),
                                    //             const SizedBox(width: 5),
                                    //             postForMudda.agreeStatus ==
                                    //                 true
                                    //                 ? Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.likersCount)} Agree",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? const Color(
                                    //                       0xFF0060FF)
                                    //                       : blackGray),
                                    //             )
                                    //                 : Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.likersCount)}",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? const Color(
                                    //                       0xFF0060FF)
                                    //                       : blackGray),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    getSizedBox(
                                        h: ScreenUtil().setSp(12)),
                                    Obx(() => Visibility(
                                      child: ReplyWidget(
                                          postForMudda:
                                          postForMudda,
                                          index: index),
                                      visible: muddaNewsController!
                                          .isRepliesShow
                                          .value &&
                                          muddaNewsController!
                                              .currentIndex
                                              .value ==
                                              index,
                                    )),
                                  ],
                                )
                              ],
                            ));
                          } else {
                            return Obx(() => Column(
                              children: [
                                postForMudda.postIn == "favour"
                                    ? Column(
                                  children: [
                                    getSizedBox(
                                        h: ScreenUtil().setSp(20)),
                                    MuddaVideoBox(
                                        postForMudda,
                                        muddaNewsController!
                                            .postForMuddaPath.value,
                                        index,
                                        muddaNewsController!
                                            .muddaUserProfilePath
                                            .value),
                                    //TODO: favour -FIXED
                                    // Container(
                                    //   margin: const EdgeInsets.only(
                                    //       left: 40, right: 16),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       InkWell(
                                    //         onTap: () {
                                    //           muddaNewsController!
                                    //               .isRepliesShow.value =
                                    //           !muddaNewsController!
                                    //               .isRepliesShow.value;
                                    //           muddaNewsController!.height.value = Get.height * 0.4;
                                    //           muddaNewsController!.width.value = Get.width;
                                    //           muddaNewsController!.currentIndex.value = index;
                                    //           setState(() {});
                                    //         },
                                    //         child: Column(
                                    //           children: [
                                    //             Row(
                                    //               children: [
                                    //                 SvgPicture.asset(
                                    //                   AppIcons.icReply,
                                    //                 ),
                                    //                 SizedBox(width: 5),
                                    //                 Text(
                                    //                   postForMudda.replies ==
                                    //                       null
                                    //                       ? "-"
                                    //                       : "${postForMudda.replies}",
                                    //                   style:
                                    //                   size12_M_regular(
                                    //                       textColor:
                                    //                       black),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //             Visibility(
                                    //               child:
                                    //               SvgPicture.asset(
                                    //                 AppIcons.icArrowDown,
                                    //                 color: grey,
                                    //               ),
                                    //               visible: muddaNewsController!
                                    //                   .isRepliesShow.value &&
                                    //                   muddaNewsController!.currentIndex.value == index,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           muddaNewsController!.postForMudda.value = postForMudda;
                                    //           showModalBottomSheet(
                                    //               context: context,
                                    //               builder: (context) {
                                    //                 return CommentsPost();
                                    //               });
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //               // AppIcons.replyIcon,
                                    //               AppIcons.iconComments,
                                    //               height: 16,
                                    //               width: 16,
                                    //             ),
                                    //             const SizedBox(width: 5),
                                    //             Text(
                                    //                 NumberFormat
                                    //                     .compactCurrency(
                                    //                   decimalDigits: 0,
                                    //                   symbol:
                                    //                   '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //                 ).format(postForMudda
                                    //                     .commentorsCount),
                                    //                 style: GoogleFonts
                                    //                     .nunitoSans(
                                    //                     fontWeight:
                                    //                     FontWeight
                                    //                         .w400,
                                    //                     fontSize:
                                    //                     ScreenUtil()
                                    //                         .setSp(
                                    //                         12),
                                    //                     color:
                                    //                     blackGray)),
                                    //
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       InkWell(
                                    //         onTap: () {
                                    //           if (AppPreference().getBool(
                                    //               PreferencesKey.isGuest)) {
                                    //             Get.toNamed(RouteConstants
                                    //                 .userProfileEdit);
                                    //           } else {
                                    //             Api.post.call(
                                    //               context,
                                    //               method: "like/store",
                                    //               isLoading: false,
                                    //               param: {
                                    //                 "user_id": AppPreference()
                                    //                     .getString(
                                    //                     PreferencesKey
                                    //                         .interactUserId),
                                    //                 "relative_id":
                                    //                 postForMudda.sId,
                                    //                 "relative_type":
                                    //                 "PostForMudda",
                                    //                 "status": false
                                    //               },
                                    //               onResponseSuccess:
                                    //                   (object) {
                                    //                 print(
                                    //                     "Abhishek $object");
                                    //               },
                                    //             );
                                    //             if (postForMudda
                                    //                 .agreeStatus ==
                                    //                 false) {
                                    //               postForMudda.agreeStatus =
                                    //               null;
                                    //               postForMudda
                                    //                   .dislikersCount =
                                    //                   postForMudda
                                    //                       .dislikersCount! -
                                    //                       1;
                                    //             } else {
                                    //               postForMudda
                                    //                   .dislikersCount =
                                    //                   postForMudda
                                    //                       .dislikersCount! +
                                    //                       1;
                                    //               postForMudda
                                    //                   .likersCount = postForMudda
                                    //                   .likersCount ==
                                    //                   0
                                    //                   ? postForMudda
                                    //                   .likersCount
                                    //                   : postForMudda
                                    //                   .likersCount! -
                                    //                   1;
                                    //               postForMudda.agreeStatus =
                                    //               false;
                                    //             }
                                    //             int pIndex = index;
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .removeAt(index);
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .insert(pIndex, postForMudda);
                                    //           }
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //                 postForMudda.agreeStatus ==
                                    //                     false
                                    //                     ? AppIcons
                                    //                     .dislikeFill
                                    //                     : AppIcons.dislike,
                                    //                 height: 16,
                                    //                 width: 16,
                                    //                 color: postForMudda
                                    //                     .agreeStatus ==
                                    //                     false
                                    //                     ?  colorF1B008
                                    //                     : blackGray),
                                    //             const SizedBox(width: 5),
                                    //             postForMudda.agreeStatus ==
                                    //                 false
                                    //                 ? Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.dislikersCount)} Disagree",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ?
                                    //                   colorF1B008
                                    //                       : blackGray),
                                    //             )
                                    //                 : Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.dislikersCount)}",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ?
                                    //                   colorF1B008
                                    //                       : blackGray),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       InkWell(
                                    //         onTap: () {
                                    //           if (AppPreference().getBool(
                                    //               PreferencesKey.isGuest)) {
                                    //             Get.toNamed(RouteConstants
                                    //                 .userProfileEdit);
                                    //           } else {
                                    //             Api.post.call(
                                    //               context,
                                    //               method: "like/store",
                                    //               isLoading: false,
                                    //               param: {
                                    //                 "user_id": AppPreference()
                                    //                     .getString(
                                    //                     PreferencesKey
                                    //                         .interactUserId),
                                    //                 "relative_id":
                                    //                 postForMudda.sId,
                                    //                 "relative_type":
                                    //                 "PostForMudda",
                                    //                 "status": true
                                    //               },
                                    //               onResponseSuccess:
                                    //                   (object) {},
                                    //             );
                                    //             if (postForMudda
                                    //                 .agreeStatus ==
                                    //                 true) {
                                    //               postForMudda.agreeStatus =
                                    //               null;
                                    //               postForMudda.likersCount =
                                    //                   postForMudda
                                    //                       .likersCount! -
                                    //                       1;
                                    //             } else {
                                    //               postForMudda.likersCount =
                                    //                   postForMudda
                                    //                       .likersCount! +
                                    //                       1;
                                    //               postForMudda
                                    //                   .dislikersCount = postForMudda
                                    //                   .dislikersCount ==
                                    //                   0
                                    //                   ? postForMudda
                                    //                   .dislikersCount
                                    //                   : postForMudda
                                    //                   .dislikersCount! -
                                    //                   1;
                                    //
                                    //               postForMudda.agreeStatus =
                                    //               true;
                                    //             }
                                    //             int pIndex = index;
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .removeAt(index);
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .insert(pIndex,
                                    //                 postForMudda);
                                    //           }
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //                 postForMudda.agreeStatus ==
                                    //                     true
                                    //                     ? AppIcons
                                    //                     .handIconFill
                                    //                     : AppIcons.handIcon,
                                    //                 height: 16,
                                    //                 width: 16,
                                    //                 color: postForMudda
                                    //                     .agreeStatus ==
                                    //                     true
                                    //                     ?  color0060FF
                                    //                     : blackGray),
                                    //             const SizedBox(width: 5),
                                    //             postForMudda.agreeStatus ==
                                    //                 true
                                    //                 ? Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.likersCount)} Agree",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? color0060FF
                                    //                       : blackGray),
                                    //             )
                                    //                 : Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.likersCount)}",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ?  color0060FF
                                    //                       : blackGray),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    getSizedBox(
                                        h: ScreenUtil().setSp(12)),
                                    Obx(() => Visibility(
                                      child: ReplyWidget(
                                        postForMudda:
                                        postForMudda,
                                        index: index,
                                      ),
                                      visible: muddaNewsController!
                                          .isRepliesShow
                                          .value &&
                                          muddaNewsController!
                                              .currentIndex
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
                                    getSizedBox(
                                        h: ScreenUtil().setSp(20)),
                                    MuddaOppositionVideoBox(
                                        postForMudda,
                                        muddaNewsController!
                                            .postForMuddaPath.value,
                                        index,
                                        muddaNewsController!
                                            .muddaUserProfilePath
                                            .value),
                                    // TODO: Opposition - FIXED
                                    // Container(
                                    //   // padding: EdgeInsets.only(
                                    //   //     left: ScreenUtil().setSp(64),
                                    //   //     right: ScreenUtil().setSp(19)),
                                    //   padding: const EdgeInsets.only(
                                    //       right: 16, left: 16),
                                    //   margin: const EdgeInsets.only(
                                    //       left: 0, right: 40),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       InkWell(
                                    //         onTap: () {
                                    //           muddaNewsController!
                                    //               .isRepliesShow.value =
                                    //           !muddaNewsController!
                                    //               .isRepliesShow.value;
                                    //           muddaNewsController!.height.value = Get.height * 0.4;
                                    //           muddaNewsController!.width.value = Get.width;
                                    //           muddaNewsController!.currentIndex.value = index;
                                    //           setState(() {});
                                    //         },
                                    //         child: Column(
                                    //           children: [
                                    //             Row(
                                    //               children: [
                                    //                 SvgPicture.asset(
                                    //                   AppIcons.icReply,
                                    //                 ),
                                    //                 SizedBox(width: 5),
                                    //                 Text(
                                    //                   postForMudda.replies ==
                                    //                       null
                                    //                       ? "-"
                                    //                       : "${postForMudda.replies}",
                                    //                   style:
                                    //                   size12_M_regular(
                                    //                       textColor:
                                    //                       black),
                                    //                 ),
                                    //
                                    //               ],
                                    //             ),
                                    //             Visibility(
                                    //               child:
                                    //               SvgPicture.asset(
                                    //                 AppIcons.icArrowDown,
                                    //                 color: grey,
                                    //               ),
                                    //               visible: muddaNewsController!
                                    //                   .isRepliesShow.value &&
                                    //                   muddaNewsController!.currentIndex.value == index,
                                    //             ),
                                    //
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           muddaNewsController!.postForMudda.value = postForMudda;
                                    //           showModalBottomSheet(
                                    //               context: context,
                                    //               builder: (context) {
                                    //                 return CommentsPost();
                                    //               });
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //               // AppIcons.replyIcon,
                                    //               AppIcons.iconComments,
                                    //               height: 16,
                                    //               width: 16,
                                    //             ),
                                    //             const SizedBox(width: 5),
                                    //             Text(
                                    //                 NumberFormat
                                    //                     .compactCurrency(
                                    //                   decimalDigits: 0,
                                    //                   symbol:
                                    //                   '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //                 ).format(postForMudda
                                    //                     .commentorsCount),
                                    //                 style: GoogleFonts
                                    //                     .nunitoSans(
                                    //                     fontWeight:
                                    //                     FontWeight
                                    //                         .w400,
                                    //                     fontSize:
                                    //                     ScreenUtil()
                                    //                         .setSp(
                                    //                         12),
                                    //                     color:
                                    //                     blackGray)),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       InkWell(
                                    //         onTap: () {
                                    //           if (AppPreference().getBool(
                                    //               PreferencesKey.isGuest)) {
                                    //             Get.toNamed(RouteConstants
                                    //                 .userProfileEdit);
                                    //           } else {
                                    //             Api.post.call(
                                    //               context,
                                    //               method: "like/store",
                                    //               isLoading: false,
                                    //               param: {
                                    //                 "user_id": AppPreference()
                                    //                     .getString(
                                    //                     PreferencesKey
                                    //                         .interactUserId),
                                    //                 "relative_id":
                                    //                 postForMudda.sId,
                                    //                 "relative_type":
                                    //                 "PostForMudda",
                                    //                 "status": false,
                                    //               },
                                    //               onResponseSuccess:
                                    //                   (object) {
                                    //                 print(
                                    //                     "Abhishek $object");
                                    //               },
                                    //             );
                                    //             if (postForMudda
                                    //                 .agreeStatus ==
                                    //                 false) {
                                    //               postForMudda.agreeStatus =
                                    //               null;
                                    //               postForMudda
                                    //                   .dislikersCount =
                                    //                   postForMudda
                                    //                       .dislikersCount! -
                                    //                       1;
                                    //             } else {
                                    //               postForMudda
                                    //                   .dislikersCount =
                                    //                   postForMudda
                                    //                       .dislikersCount! +
                                    //                       1;
                                    //               postForMudda
                                    //                   .likersCount = postForMudda
                                    //                   .likersCount ==
                                    //                   0
                                    //                   ? postForMudda
                                    //                   .likersCount
                                    //                   : postForMudda
                                    //                   .likersCount! -
                                    //                   1;
                                    //               ;
                                    //               postForMudda.agreeStatus =
                                    //               false;
                                    //             }
                                    //             int pIndex = index;
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .removeAt(index);
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .insert(pIndex,
                                    //                 postForMudda);
                                    //           }
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //                 postForMudda.agreeStatus ==
                                    //                     false
                                    //                     ? AppIcons
                                    //                     .dislikeFill
                                    //                     : AppIcons.dislike,
                                    //                 height: 16,
                                    //                 width: 16,
                                    //                 color: postForMudda
                                    //                     .agreeStatus ==
                                    //                     false
                                    //                     ? const Color(
                                    //                     0xFFF1B008)
                                    //                     : blackGray),
                                    //             const SizedBox(width: 5),
                                    //             postForMudda.agreeStatus ==
                                    //                 false
                                    //                 ? Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.dislikersCount)} Disagree",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? const Color(
                                    //                       0xFFF1B008)
                                    //                       : blackGray),
                                    //             )
                                    //                 : Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.dislikersCount)}",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       false
                                    //                       ? const Color(
                                    //                       0xFFF1B008)
                                    //                       : blackGray),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       InkWell(
                                    //         onTap: () {
                                    //           if (AppPreference().getBool(
                                    //               PreferencesKey.isGuest)) {
                                    //             Get.toNamed(RouteConstants
                                    //                 .userProfileEdit);
                                    //           } else {
                                    //             Api.post.call(
                                    //               context,
                                    //               method: "like/store",
                                    //               isLoading: false,
                                    //               param: {
                                    //                 "user_id": AppPreference()
                                    //                     .getString(
                                    //                     PreferencesKey
                                    //                         .interactUserId),
                                    //                 "relative_id":
                                    //                 postForMudda.sId,
                                    //                 "relative_type":
                                    //                 "PostForMudda",
                                    //                 "status": true
                                    //               },
                                    //               onResponseSuccess:
                                    //                   (object) {},
                                    //             );
                                    //             if (postForMudda
                                    //                 .agreeStatus ==
                                    //                 true) {
                                    //               postForMudda.agreeStatus =
                                    //               null;
                                    //               postForMudda.likersCount =
                                    //                   postForMudda
                                    //                       .likersCount! -
                                    //                       1;
                                    //             } else {
                                    //               postForMudda.likersCount =
                                    //                   postForMudda
                                    //                       .likersCount! +
                                    //                       1;
                                    //               postForMudda
                                    //                   .dislikersCount = postForMudda
                                    //                   .dislikersCount ==
                                    //                   0
                                    //                   ? postForMudda
                                    //                   .dislikersCount
                                    //                   : postForMudda
                                    //                   .dislikersCount! -
                                    //                   1;
                                    //
                                    //               postForMudda.agreeStatus =
                                    //               true;
                                    //             }
                                    //             int pIndex = index;
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .removeAt(index);
                                    //             muddaNewsController!
                                    //                 .postForMuddaList
                                    //                 .insert(pIndex,
                                    //                 postForMudda);
                                    //           }
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //                 postForMudda.agreeStatus ==
                                    //                     true
                                    //                     ? AppIcons
                                    //                     .handIconFill
                                    //                     : AppIcons.handIcon,
                                    //                 height: 16,
                                    //                 width: 16,
                                    //                 color: postForMudda
                                    //                     .agreeStatus ==
                                    //                     true
                                    //                     ? const Color(
                                    //                     0xFF0060FF)
                                    //                     : blackGray),
                                    //             const SizedBox(width: 5),
                                    //             postForMudda.agreeStatus ==
                                    //                 true
                                    //                 ? Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.likersCount)} Agree",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? const Color(
                                    //                       0xFF0060FF)
                                    //                       : blackGray),
                                    //             )
                                    //                 : Text(
                                    //               "${NumberFormat.compactCurrency(
                                    //                 decimalDigits: 0,
                                    //                 symbol:
                                    //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    //               ).format(postForMudda.likersCount)}",
                                    //               style: GoogleFonts.nunitoSans(
                                    //                   fontWeight: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? FontWeight
                                    //                       .w700
                                    //                       : FontWeight
                                    //                       .w400,
                                    //                   fontSize:
                                    //                   ScreenUtil()
                                    //                       .setSp(
                                    //                       12),
                                    //                   color: postForMudda
                                    //                       .agreeStatus ==
                                    //                       true
                                    //                       ? const Color(
                                    //                       0xFF0060FF)
                                    //                       : blackGray),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    getSizedBox(
                                        h: ScreenUtil().setSp(12)),
                                    Obx(() => Visibility(
                                      child: ReplyWidget(
                                          postForMudda:
                                          postForMudda,
                                          index: index),
                                      visible: muddaNewsController!
                                          .isRepliesShow
                                          .value &&
                                          muddaNewsController!
                                              .currentIndex
                                              .value ==
                                              index,
                                    )),
                                  ],
                                )
                              ],
                            ));
                          }
                        }),
                  ),
                ),
                Visibility(
                  visible: muddaNewsController!.roleList.isNotEmpty,
                  child: Positioned(
                    bottom: ScreenUtil().setSp(90),
                    child: Column(
                      children: [
                        Obx(
                              () => InkWell(
                            onTap: () {
                              showRolesDialog(context);
                            },
                            child: muddaNewsController!
                                .selectedRole.value.user !=
                                null
                                ? muddaNewsController!
                                .selectedRole.value.user!.profile !=
                                null
                                ? CachedNetworkImage(
                              imageUrl:
                              "${muddaNewsController!.roleProfilePath.value}${muddaNewsController!.selectedRole.value.user!.profile}",
                              imageBuilder:
                                  (context, imageProvider) =>
                                  Container(
                                    width: ScreenUtil().setSp(42),
                                    height: ScreenUtil().setSp(42),
                                    decoration: BoxDecoration(
                                      color: colorWhite,
                                      border: Border.all(
                                        width: ScreenUtil().setSp(1),
                                        color: buttonBlue,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(ScreenUtil().setSp(
                                              21)) //                 <--- border radius here
                                      ),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                              placeholder: (context, url) =>
                                  CircleAvatar(
                                    backgroundColor: lightGray,
                                    radius: ScreenUtil().setSp(21),
                                  ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                    backgroundColor: lightGray,
                                    radius: ScreenUtil().setSp(21),
                                  ),
                            )
                                : Container(
                              height: ScreenUtil().setSp(42),
                              width: ScreenUtil().setSp(42),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: darkGray,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                    muddaNewsController!.selectedRole
                                        .value.user!.fullname![0]
                                        .toUpperCase(),
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                        ScreenUtil().setSp(16),
                                        color: black)),
                              ),
                            )
                                : AppPreference()
                                .getString(
                                PreferencesKey.interactProfile)
                                .isNotEmpty
                                ? CachedNetworkImage(
                              imageUrl:
                              "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.interactProfile)}",
                              imageBuilder:
                                  (context, imageProvider) =>
                                  Container(
                                    width: ScreenUtil().setSp(42),
                                    height: ScreenUtil().setSp(42),
                                    decoration: BoxDecoration(
                                      color: colorWhite,
                                      border: Border.all(
                                        width: ScreenUtil().setSp(1),
                                        color: buttonBlue,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(ScreenUtil().setSp(
                                              21)) //                 <--- border radius here
                                      ),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                              placeholder: (context, url) =>
                                  CircleAvatar(
                                    backgroundColor: lightGray,
                                    radius: ScreenUtil().setSp(21),
                                  ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                    backgroundColor: lightGray,
                                    radius: ScreenUtil().setSp(21),
                                  ),
                            )
                                : Container(
                              height: ScreenUtil().setSp(42),
                              width: ScreenUtil().setSp(42),
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
                            ),
                          ),
                        ),
                        getSizedBox(h: 5),
                        Text("Interacting as",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                fontSize: ScreenUtil().setSp(10),
                                color: Colors.red,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  _getRoles(BuildContext context) async {
    Api.get.call(context,
        method: "user/my-roles",
        param: {
          "page": rolePage.toString(),
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "interactModal": "CommentPost"
        },
        isLoading: false, onResponseSuccess: (Map object) {
          var result = UserRolesModel.fromJson(object);
          if (rolePage == 1) {
            muddaNewsController!.roleList.clear();
          }
          if (result.data!.isNotEmpty) {
            muddaNewsController!.roleProfilePath.value = result.path!;
            muddaNewsController!.roleList.addAll(result.data!);
            Role role = Role();
            role.user = User();
            role.user!.profile = AppPreference().getString(PreferencesKey.profile);
            role.user!.fullname = "Self";
            role.user!.sId = AppPreference().getString(PreferencesKey.userId);
            muddaNewsController!.roleList.add(role);
          } else {
            rolePage = rolePage > 1 ? rolePage - 1 : rolePage;
          }
        });
  }

  showRolesDialog(BuildContext context) {
    return showDialog(
      context: Get.context as BuildContext,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(16))),
            padding: EdgeInsets.only(
                top: ScreenUtil().setSp(24),
                left: ScreenUtil().setSp(24),
                right: ScreenUtil().setSp(24),
                bottom: ScreenUtil().setSp(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Interact as",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(13),
                        color: black,
                        decoration: TextDecoration.underline,
                        decorationColor: black)),
                ListView.builder(
                    shrinkWrap: true,
                    controller: roleController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                    itemCount: muddaNewsController!.roleList.length,
                    itemBuilder: (followersContext, index) {
                      Role role = muddaNewsController!.roleList[index];
                      return InkWell(
                        onTap: () {
                          muddaNewsController!.selectedRole.value = role;
                          AppPreference().setString(
                              PreferencesKey.interactUserId, role.user!.sId!);
                          AppPreference().setString(
                              PreferencesKey.interactProfile,
                              role.user!.profile!);
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(role.user!.fullname!,
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenUtil().setSp(13),
                                          color: black))),
                              SizedBox(
                                width: ScreenUtil().setSp(14),
                              ),
                              role.user!.profile != null
                                  ? SizedBox(
                                width: ScreenUtil().setSp(30),
                                height: ScreenUtil().setSp(30),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "${muddaNewsController!.roleProfilePath}${role.user!.profile}",
                                  imageBuilder:
                                      (context, imageProvider) =>
                                      Container(
                                        width: ScreenUtil().setSp(30),
                                        height: ScreenUtil().setSp(30),
                                        decoration: BoxDecoration(
                                          color: colorWhite,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                blurRadius: 5.0,
                                                offset: const Offset(0, 5))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(ScreenUtil().setSp(
                                                  4)) //                 <--- border radius here
                                          ),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                                ),
                              )
                                  : Container(
                                height: ScreenUtil().setSp(30),
                                width: ScreenUtil().setSp(30),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: darkGray,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ScreenUtil().setSp(
                                          4)) //                 <--- border radius here
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                      role.user!.fullname![0]
                                          .toUpperCase(),
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                          ScreenUtil().setSp(20),
                                          color: black)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        );
      },
    );
  }


}