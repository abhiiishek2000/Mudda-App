// import 'dart:convert';
// import 'dart:math';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:swipe_to/swipe_to.dart';
// import '../../../../core/constant/app_colors.dart';
// import '../../../../core/constant/app_icons.dart';
// import '../../../../core/constant/route_constants.dart';
// import '../../../../core/preferences/preference_manager.dart';
// import '../../../../core/preferences/preferences_key.dart';
// import '../../../../core/utils/color.dart';
// import '../../../../core/utils/size_config.dart';
// import '../../../../core/utils/text_style.dart';
// import '../../../../core/utils/time_convert.dart';
// import '../../../../dio/api/api.dart';
// import '../../../../model/PostForMuddaModel.dart';
// import '../../../shared/report_post_dialog_box.dart';
// import '../../home_screen/controller/mudda_fire_news_controller.dart';
// import '../view/mudda_details_screen.dart';
// import 'media_box.dart';
//
// class MuddaOppositionVideoBox extends StatefulWidget {
//   PostForMudda postForMudda;
//   String muddaPath;
//   int index;
//   String muddaUserProfilePath;
//
//   MuddaOppositionVideoBox(
//       this.postForMudda,
//       this.muddaPath,
//       this.index,
//       this.muddaUserProfilePath, {
//         Key? key,
//       }) : super(key: key);
//
//   @override
//   State<MuddaOppositionVideoBox> createState() =>
//       _MuddaOppositionVideoBoxState();
// }
//
// class _MuddaOppositionVideoBoxState extends State<MuddaOppositionVideoBox>
//     with SingleTickerProviderStateMixin {
//   MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
//   late AnimationController _controller;
//   late Animation<double> animation;
//   bool isLoad = false;
//
//   fetchFilteredData({required String filterUserId}) {
//     Api.get.call(context,
//         method: "post-for-mudda/index",
//         param: {
//           "mudda_id": muddaNewsController.muddaPost.value.sId,
//           "user_id": AppPreference().getString(PreferencesKey.userId),
//           "page": '1',
//           "filterUserId": filterUserId
//         },
//         isLoading: true, onResponseSuccess: (Map object) {
//           var result = PostForMuddaModel.fromJson(object);
//           if (result.data!.isNotEmpty) {
//             muddaNewsController.isPaginate.value = false;
//             muddaNewsController.postForMuddaPath.value = result.path!;
//             //
//             muddaNewsController.postForMuddaUserPath.value = result.userpath!;
//             muddaNewsController.postForMuddaTotalUsers = result.totalUsers!;
//             muddaNewsController.postForMuddaContainerUsers = result.containerUsers!;
//             muddaNewsController.postForMuddaSupportPercentage =
//             result.supportPercentage!;
//             muddaNewsController.postForMuddaMuddaThumbnail = result.muddaThumbnail!;
//             muddaNewsController.postForMuddaMuddaOwner = result.muddaOwner!;
//             //
//             muddaNewsController.postForMuddaMuddaFavour = result.favour!;
//             muddaNewsController.postForMuddaMuddaOpposition = result.opposition!;
//             muddaNewsController.postForMuddaJoinRequestsAdmin =
//             result.joinRequests!;
//             muddaNewsController.postForMuddapostApprovalsAdmin =
//             result.postApprovals!;
//             muddaNewsController.postForMuddapostTotalNewPost =
//             result.totalNewPosts!;
//             //
//             muddaNewsController.postForMuddaList.clear();
//             muddaNewsController.postForMuddaList.addAll(result.data!);
//
//             muddaNewsController.calAgreeDisAgreePercentage();
//             // muddaNewsController!.postForMuddaMuddaThumbnail.refresh();
//             if (mounted) {
//               setState(() {});
//             }
//           }
//         });
//   }
//
//   void update() {
//     isLoad
//         ? fetchFilteredData(filterUserId: widget.postForMudda.userDetail!.sId!)
//         : FetchData().fetchRecentPost(isLoading: true, context: context);
//   }
//
//   @override
//   void initState() {
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     animation = Tween<double>(begin: 0, end: 90 * pi / 90).animate(_controller);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         muddaNewsController.postForMuddaIndex.value = widget.index;
//         muddaNewsController.postForMudda.value = widget.postForMudda;
//         Get.toNamed(RouteConstants.muddaPostCommentsScreen);
//       },
//       child: SwipeTo(
//           onRightSwipe: () {
//             Map<String, String>? parameters = {
//               "postForMudda": jsonEncode(widget.postForMudda)
//             };
//
//             if (AppPreference().getBool(PreferencesKey.isGuest)) {
//               Get.toNamed(RouteConstants.userProfileEdit);
//             } else {
//               Get.toNamed(RouteConstants.uploadReplyScreen,
//                   parameters: parameters);
//             }
//
//         },
//         child: Stack(
//           children: [
//             Container(
//               // margin: EdgeInsets.all(ScreenUtil().setSp(4)),
//               margin:
//               const EdgeInsets.only(bottom: 5, top: 20, right: 40, left: 8),
//               padding: const EdgeInsets.all(2),
//               // height: ScreenUtil().setSp(161),
//               width: ScreenUtil().screenWidth,
//               decoration: BoxDecoration(
//                 color: Color(0xFFFFFFFF),
//                 border: widget.postForMudda.hotSpot! > 0
//                     ? Border.all(width: 1, color: Color(0xFFF1B008))
//                     : null,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(16),
//                   topRight: Radius.circular(16),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   if (widget.postForMudda.parentPost != null) ...[
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Color(0xFFF2F2F2),
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(16),
//                           topRight: Radius.circular(16),
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                             left: 32, bottom: 2, right: 0, top: 4),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             SvgPicture.asset(
//                               AppIcons.replyNewIcon,
//                             ),
//                             Column(
//                               mainAxisSize: MainAxisSize.max,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Container(
//                                     width: Get.width / 1.6,
//                                     child: Text(
//                                       widget.postForMudda.parentPost!
//                                           .muddaDescription!,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: size12_M_bold(
//                                         textColor: black,
//                                       ),
//                                     )),
//                                 getSizedBox(h: ScreenUtil().setSp(6)),
//                                 Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       TimeConvert.Dtime(widget
//                                           .postForMudda.parentPost!.createdAt!),
//                                       style: size12_M_normal(
//                                         textColor: black,
//                                       ),
//                                     ),
//                                     getSizedBox(w: ScreenUtil().setSp(30)),
//                                     Text(
//                                       "- ${widget.postForMudda.parentPost!.user!.fullname!}",
//                                       style: size15_M_bold(textColor: Colors.black),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Column(
//                       //   children: [
//                       //     AnimatedBuilder(
//                       //       animation: _controller,
//                       //       child: InkWell(
//                       //           onTap: () {
//                       //             setState(() {
//                       //               isLoad = !isLoad;
//                       //             });
//                       //             isLoad
//                       //                 ? _controller.forward()
//                       //                 : _controller.reverse();
//                       //             update();
//                       //           },
//                       //           child: Padding(
//                       //             padding:
//                       //             const EdgeInsets.symmetric(vertical: 16),
//                       //             child: Image.asset(
//                       //               AppIcons.iconUpDown,
//                       //               height: 16,
//                       //               width: 16,
//                       //             ),
//                       //           )),
//                       //       builder: (context, child) {
//                       //         return Container(
//                       //           child: Transform.rotate(
//                       //             angle: animation.value,
//                       //             child: child,
//                       //           ),
//                       //         );
//                       //       },
//                       //     ),
//                       //   ],
//                       // ),
//                       Expanded(
//                         child: Container(
//                           margin: const EdgeInsets.only(left: 24,top: 12),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     padding:
//                                     const EdgeInsets.only(bottom: 8, left: 8),
//                                     child: Wrap(
//                                       children: [
//                                         Text(
//                                           widget.postForMudda.muddaDescription!,
//                                           style: GoogleFonts.nunitoSans(
//                                               fontWeight: FontWeight.w400,
//                                               fontSize: ScreenUtil().setSp(14),
//                                               color: Color(0xff202020)),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: MuddaVideo(
//                       // height: ScreenUtil().setSp(138),
//                       height: 100,
//                       width: 100,
//                       list: widget.postForMudda.gallery!,
//                       basePath: widget.muddaPath,
//                       // width: ScreenUtil().screenWidth / 2,
//                     ),
//                   ),
//                   // Container(
//                   //   margin: const EdgeInsets.only(top: 10, bottom: 2),
//                   //   child: Row(
//                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //     children: [
//                   //       InkWell(
//                   //         onTap: () {
//                   //           Map<String, String>? parameters = {
//                   //             "postForMudda": jsonEncode(widget.postForMudda)
//                   //           };
//                   //
//                   //           if (AppPreference().getBool(PreferencesKey.isGuest)) {
//                   //             Get.toNamed(RouteConstants.userProfileEdit);
//                   //           } else {
//                   //             Get.toNamed(RouteConstants.uploadReplyScreen,
//                   //                 parameters: parameters);
//                   //           }
//                   //         },
//                   //         child: Text(
//                   //           "Reply",
//                   //           style: size12_M_regular(textColor: blackGray),
//                   //         ),
//                   //       ),
//                   //       InkWell(
//                   //         onTap: () {
//                   //           Map<String, String>? parameters = {
//                   //             "post": jsonEncode(widget.postForMudda),
//                   //             "reply": jsonEncode(widget.postForMudda.replies)
//                   //           };
//                   //           if (AppPreference().getBool(PreferencesKey.isGuest)) {
//                   //             Get.toNamed(RouteConstants.userProfileEdit);
//                   //           } else {
//                   //             Get.toNamed(RouteConstants.seeAllRepliesScreen,
//                   //                 parameters: parameters);
//                   //           }
//                   //         },
//                   //         child: Text(
//                   //           "see all replies",
//                   //           style: size12_M_regular(textColor: blackGray),
//                   //         ),
//                   //       ),
//                   //       GestureDetector(
//                   //         onTap: () {
//                   //           showModalBottomSheet(
//                   //               context: context,
//                   //               builder: (context) {
//                   //                 return CommentsScreen();
//                   //               });
//                   //         },
//                   //         child: Row(
//                   //           children: [
//                   //             Text(
//                   //                 NumberFormat.compactCurrency(
//                   //                   decimalDigits: 0,
//                   //                   symbol:
//                   //                       '', // if you want to add currency symbol then pass that in this else leave it empty.
//                   //                 ).format(widget.postForMudda.commentorsCount),
//                   //                 style: GoogleFonts.nunitoSans(
//                   //                     fontWeight: FontWeight.w400,
//                   //                     fontSize: ScreenUtil().setSp(12),
//                   //                     color: blackGray)),
//                   //             const SizedBox(width: 5),
//                   //             Image.asset(
//                   //               // AppIcons.replyIcon,
//                   //               AppIcons.iconComments,
//                   //               height: 20,
//                   //               width: 20,
//                   //             )
//                   //           ],
//                   //         ),
//                   //       ),
//                   //       // Row(
//                   //       //   children: [
//                   //       //     Text(
//                   //       //       "20.1k",
//                   //       //       style: size12_M_regular(textColor: black),
//                   //       //     ),
//                   //       //     SizedBox(width: 5),
//                   //       //     Image.asset(
//                   //       //       AppIcons.iconComments,
//                   //       //       height: 16,
//                   //       //       width: 16,
//                   //       //     ),
//                   //       //   ],
//                   //       // ),
//                   //     ],
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.only(right: 40, left: 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       muddaNewsController.acceptUserDetail.value =
//                       widget.postForMudda.userDetail!;
//                       if (widget.postForMudda.userDetail!.sId ==
//                           AppPreference().getString(PreferencesKey.userId)) {
//                         Get.toNamed(RouteConstants.profileScreen);
//                       } else if (widget.postForMudda.postAs == "user") {
//                         Map<String, String>? parameters = {
//                           "userDetail":
//                           jsonEncode(widget.postForMudda.userDetail!),
//                           "postAs": widget.postForMudda.postAs!
//                         };
//                         Get.toNamed(RouteConstants.otherUserProfileScreen,
//                             parameters: parameters);
//                       } else {
//                         anynymousDialogBox(context);
//                       }
//                     },
//                     child: Padding(
//                         padding: EdgeInsets.only(left: ScreenUtil().setSp(10)),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             widget.postForMudda.postAs == "user"
//                                 ? widget.postForMudda.userDetail!.profile != null
//                                 ? CachedNetworkImage(
//                               imageUrl:
//                               "${widget.muddaUserProfilePath}${widget.postForMudda.userDetail!.profile!}",
//                               imageBuilder: (context, imageProvider) =>
//                                   Container(
//                                     width: ScreenUtil().setSp(40),
//                                     height: ScreenUtil().setSp(40),
//                                     decoration: BoxDecoration(
//                                       color: colorWhite,
//                                       shape: BoxShape.circle,
//                                       image: DecorationImage(
//                                           image: imageProvider,
//                                           fit: BoxFit.cover),
//                                     ),
//                                   ),
//                               errorWidget: (context, url, error) =>
//                               const Icon(Icons.error),
//                             )
//                                 : Container(
//                               height: 40,
//                               width: 40,
//                               decoration: BoxDecoration(
//                                 color: colorWhite,
//                                 border: Border.all(
//                                   color: darkGray,
//                                 ),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                     widget.postForMudda.userDetail!
//                                         .fullname![0]
//                                         .toUpperCase(),
//                                     style: GoogleFonts.nunitoSans(
//                                         fontWeight: FontWeight.w400,
//                                         fontSize:
//                                         ScreenUtil().setSp(20),
//                                         color: black)),
//                               ),
//                             )
//                                 : Container(
//                               height: 40,
//                               width: 40,
//                               decoration: BoxDecoration(
//                                 color: colorWhite,
//                                 border: Border.all(
//                                   color: darkGray,
//                                 ),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Text("A",
//                                     style: GoogleFonts.nunitoSans(
//                                         fontWeight: FontWeight.w400,
//                                         fontSize: ScreenUtil().setSp(20),
//                                         color: black)),
//                               ),
//                             ),
//                             // SizedBox(
//                             //   width: ScreenUtil().setSp(8),
//                             // ),
//                             // Row(
//                             //   children: [
//                             //     Text(
//                             //       postForMudda.postAs == "user"
//                             //           ? postForMudda.userDetail!.fullname!
//                             //           : "Anynymous",
//                             //       style: GoogleFonts.nunitoSans(
//                             //           fontWeight: FontWeight.w700,
//                             //           fontSize: ScreenUtil().setSp(12),
//                             //           color: black),
//                             //     ),
//                             //     timeText(
//                             //       convertToAgo(
//                             //         DateTime.parse(postForMudda.createdAt!),
//                             //       ),
//                             //     ),
//                             //   ],
//                             // ),
//                           ],
//                         )),
//                   ),
//                   const SizedBox(width: 5),
//                   InkWell(
//                     onTap: () {
//                       muddaNewsController.acceptUserDetail.value =
//                       widget.postForMudda.userDetail!;
//                       if (widget.postForMudda.userDetail!.sId ==
//                           AppPreference().getString(PreferencesKey.userId)) {
//                         Get.toNamed(RouteConstants.profileScreen);
//                       } else if (widget.postForMudda.postAs == "user") {
//                         Map<String, String>? parameters = {
//                           "userDetail":
//                           jsonEncode(widget.postForMudda.userDetail!),
//                           "postAs": widget.postForMudda.postAs!
//                         };
//                         Get.toNamed(RouteConstants.otherUserProfileScreen,
//                             parameters: parameters);
//                       } else {
//                         anynymousDialogBox(context);
//                       }
//                     },
//                     child: Text(
//                       widget.postForMudda.postAs == "user"
//                           ? widget.postForMudda.userDetail!.fullname!
//                           : "Anynymous",
//                       style: GoogleFonts.nunitoSans(
//                           fontWeight: FontWeight.w700,
//                           fontSize: ScreenUtil().setSp(12),
//                           color: black),
//                     ),
//                   ),
//
//                   if (widget.postForMudda.followStatus == true)...[
//                     const SizedBox(width: 5),
//                     SvgPicture.asset(AppIcons.follower),
//                   ],
//                   const Spacer(),
//                   if (widget.postForMudda.hotSpot! > 0 ||
//                       widget.postForMudda.hotSpot! <= 3)
//                     for (var x = 1; x <= widget.postForMudda.hotSpot!; x++) ...[
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 2),
//                         child: SvgPicture.asset(
//                           AppIcons.hot,
//                           color: Color(0xFFF1B008),
//                         ),
//                       )
//                     ],
//                   if (widget.postForMudda.hotSpot! > 3)
//                     for (var x = 1; x <= 3; x++) ...[
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 2),
//                         child: SvgPicture.asset(
//                           AppIcons.hot,
//                           color: Color(0xFFF1B008),
//                         ),
//                       )
//                     ],
//                   timeText(
//                     convertToAgo(
//                       DateTime.parse(widget.postForMudda.createdAt!)
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       reportPostDialogBox(context, widget.postForMudda.sId!);
//                     },
//                     child: const Icon(
//                       Icons.more_horiz,
//                       color: color606060,
//                       size: 22,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   timeText(String text) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         getSizedBox(w: 10),
//         Text("$text, ", style: size12_M_normal(textColor: Colors.grey)),
//         getSizedBox(w: 10),
//       ],
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
// }

import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/ui/screens/home_screen/widget/component/hot_mudda_post.dart';
import 'package:mudda/ui/screens/mudda/widget/full_parent_post.dart';
import 'package:mudda/ui/screens/mudda/widget/mudda_post_comment.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/route_constants.dart';
import '../../../../core/preferences/preference_manager.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../../core/utils/color.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/time_convert.dart';
import '../../../../dio/api/api.dart';
import '../../../../model/PostForMuddaModel.dart';
import '../../../shared/report_post_dialog_box.dart';
import '../../home_screen/controller/mudda_fire_news_controller.dart';
import 'media_box.dart';

class MuddaOppositionVideoBox extends StatefulWidget {
  PostForMudda postForMudda;
  String muddaPath;
  int index;
  String muddaUserProfilePath;

  MuddaOppositionVideoBox(
    this.postForMudda,
    this.muddaPath,
    this.index,
    this.muddaUserProfilePath, {
    Key? key,
  }) : super(key: key);

  @override
  State<MuddaOppositionVideoBox> createState() =>
      _MuddaOppositionVideoBoxState();
}

class _MuddaOppositionVideoBoxState extends State<MuddaOppositionVideoBox>
    with TickerProviderStateMixin {
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  late AnimationController _controller;
  late Animation<double> animation;
  late AnimationController controller;
  late Animation<Offset> offset;
  bool isLoad = false;
  bool isFullPostShow = false;

  fetchFilteredData({required String filterUserId}) {
    Api.get.call(context,
        method: "post-for-mudda/index",
        param: {
          "mudda_id": muddaNewsController.muddaPost.value.sId,
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "page": '1',
          "filterUserId": filterUserId
        },
        isLoading: true, onResponseSuccess: (Map object) {
      var result = PostForMuddaModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        muddaNewsController.isPaginate.value = false;
        muddaNewsController.postForMuddaPath.value = result.path!;
        //
        muddaNewsController.postForMuddaUserPath.value = result.userpath!;
        muddaNewsController.postForMuddaTotalUsers = result.totalUsers!;
        muddaNewsController.postForMuddaContainerUsers = result.containerUsers!;
        // muddaNewsController.postForMuddaSupportPercentage =
        // result.supportPercentage!;
        muddaNewsController.postForMuddaMuddaThumbnail = result.muddaThumbnail!;
        muddaNewsController.postForMuddaMuddaOwner = result.muddaOwner!;
        //
        muddaNewsController.postForMuddaMuddaFavour = result.favour!;
        muddaNewsController.postForMuddaMuddaOpposition = result.opposition!;
        muddaNewsController.postForMuddaJoinRequestsAdmin =
            result.joinRequests!;
        muddaNewsController.postForMuddapostApprovalsAdmin =
            result.postApprovals!;
        muddaNewsController.postForMuddapostTotalNewPost =
            result.totalNewPosts!;
        muddaNewsController.postForMuddaList.clear();
        muddaNewsController.postForMuddaList.addAll(result.data!);
        muddaNewsController.calAgreeDisAgreePercentage();
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 90 * pi / 90).animate(_controller);
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    offset = Tween(begin: const Offset(0.0, 0.1), end: const Offset(0.0, 0.0))
        .animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    return widget.postForMudda.isUploading == true
        ? Container(
            width: ScreenUtil().screenWidth,
            height: Get.height * 0.3,
            margin:
                const EdgeInsets.only(top: 0, bottom: 4, right: 52, left: 28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 5),
                Text('Uploading....')
              ],
            ),
          )
        : InkWell(
            onTap: () {
              muddaNewsController.postForMuddaIndex.value = widget.index;
              muddaNewsController.postForMudda.value = widget.postForMudda;
              Get.toNamed(RouteConstants.muddaContainerReplies);
            },
            child: SwipeTo(
              onRightSwipe: () {
                Map<String, String>? parameters = {
                  "postForMudda": jsonEncode(widget.postForMudda)
                };

                if (AppPreference().getBool(PreferencesKey.isGuest)) {
                  updateProfileDialog(context);
                } else {
                  muddaNewsController.repliedPost();
                  Get.toNamed(RouteConstants.uploadReplyScreen,
                      parameters: parameters);
                }
              },
              child: Stack(
                children: [
                  Container(
                    width: ScreenUtil().screenWidth,
                    margin: const EdgeInsets.only(
                        top: 0, bottom: 8, right: 28, left: 8),
                    // decoration: BoxDecoration(
                    //   color: Colors.transparent,
                    //   borderRadius: BorderRadius.only(
                    //     topRight: Radius.circular(10),
                    //     bottomRight: Radius.circular(10),
                    //   ),
                    //   border: widget.postForMudda.parentPost != null
                    //       ? Border.all(
                    //       color: Color(0xffA0A0A0).withOpacity(0.50), width: 0.5)
                    //       : null,
                    // ),
                    child: Column(
                      children: [
                        if (isFullPostShow)
                          const Divider(height: 2, thickness: 1, color: white),
                        if (widget.postForMudda.parentPost != null) ...[
                          isFullPostShow
                              ? SlideTransition(
                                  position: offset,
                                  child: AnimatedOpacity(
                                      duration: duration,
                                      opacity: isFullPostShow == true ? 1 : 0,
                                      child: FullParentPost(
                                          widget.postForMudda.parentPost!,
                                          widget.muddaPath,
                                          widget.muddaUserProfilePath)))
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 64, top: 8, right: 0, bottom: 8),
                                  child: InkWell(
                                    onTap: () {
                                      isFullPostShow = true;
                                      setState(() {});
                                      controller.forward();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: white, width: 1),
                                        // borderRadius: BorderRadius.circular(4),
                                      ),
                                      // ClipRRect(
                                      //  borderRadius: BorderRadius.circular(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 0.5),
                                            border: Border(
                                              right: BorderSide(
                                                  color: widget
                                                              .postForMudda
                                                              .parentPost!
                                                              .postIn ==
                                                          'opposition'
                                                      ? colorF1B008
                                                          .withOpacity(0.25)
                                                      : color0060FF
                                                          .withOpacity(0.25),
                                                  width: 4),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12,
                                              bottom: 2,
                                              right: 4,
                                              top: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              // SvgPicture.asset(
                                              //   AppIcons.icParentReply,
                                              // ),
                                              Column(
                                                mainAxisSize:
                                                    MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: Get.width / 1.6,
                                                      child: Text(
                                                        widget
                                                            .postForMudda
                                                            .parentPost!
                                                            .muddaDescription!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            size12_M_normal(
                                                          textColor:
                                                              const Color(
                                                                  0xff31393C),
                                                        ),
                                                      )),
                                                  getSizedBox(
                                                      h: ScreenUtil()
                                                          .setSp(6)),
                                                  Container(
                                                    width: Get.width / 1.6,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          TimeConvert.Dtime(
                                                              widget
                                                                  .postForMudda
                                                                  .parentPost!
                                                                  .createdAt!),
                                                          style:
                                                              size10_M_normal(
                                                            textColor:
                                                                const Color(
                                                                    0xff31393C),
                                                          ),
                                                        ),
                                                        Text(
                                                          "- ${widget.postForMudda.parentPost!.postAs == "user" ? widget.postForMudda.parentPost!.user!.fullname! : "Anonymous"}",
                                                          style: size10_M_normal(
                                                              textColor:
                                                                  const Color(
                                                                      0xff31393C)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 6),
                                                    width: Get.width / 1.6,
                                                    height: 0.5,
                                                    color: widget
                                                                .postForMudda
                                                                .parentPost!
                                                                .postIn ==
                                                            'opposition'
                                                        ? colorF1B008
                                                            .withOpacity(0.25)
                                                        : color0060FF
                                                            .withOpacity(
                                                                0.25),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                        ],
                        Stack(children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 0, right: 0, left: 44),
                            // borderRadius:  widget.postForMudda.parentPost == null? const BorderRadius.only(
                            //   bottomRight: Radius.circular(10),
                            //   topRight: Radius.circular(10),
                            // ): const BorderRadius.only(
                            //   topRight: Radius.circular(10),
                            //   bottomRight: Radius.circular(10),
                            // ),
                            //                           ClipRRect(
                            // borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: ScreenUtil().screenWidth,
                              decoration: BoxDecoration(
                                color: white,
                                border: widget.postForMudda.hotPost! > 0
                                    ? const Border(
                                        right: BorderSide(
                                            width: 0.5, color: colorF1B008),
                                        bottom: BorderSide(
                                            width: 0.5, color: colorF1B008),
                                        top: BorderSide(
                                            width: 0.5, color: colorF1B008),
                                        left: BorderSide(
                                            width: 4, color: colorF1B008),
                                      )
                                    : Border(
                                        right: BorderSide(
                                            width: 0.5,
                                            color: colorF1B008
                                                .withOpacity(0.25)),
                                        bottom: BorderSide(
                                            width: 0.5,
                                            color: colorF1B008
                                                .withOpacity(0.25)),
                                        top: BorderSide(
                                            width: 0.5,
                                            color: colorF1B008
                                                .withOpacity(0.25)),
                                        left: BorderSide(
                                            width: 4,
                                            color: colorF1B008
                                                .withOpacity(0.25)),
                                      ),
                              ),
                              child: Column(
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 8,left: 46),
                                  //   child: Row(
                                  //     children: [
                                  //       InkWell(
                                  //         onTap: () {
                                  //           muddaNewsController.acceptUserDetail.value =
                                  //           widget.postForMudda.userDetail!;
                                  //           if (widget.postForMudda.userDetail!.sId ==
                                  //               AppPreference()
                                  //                   .getString(PreferencesKey.userId)) {
                                  //             Get.toNamed(RouteConstants.profileScreen);
                                  //           } else if (widget.postForMudda.postAs ==
                                  //               "user") {
                                  //             Map<String, String>? parameters = {
                                  //               "userDetail": jsonEncode(
                                  //                   widget.postForMudda.userDetail!),
                                  //               "postAs": widget.postForMudda.postAs!
                                  //             };
                                  //             Get.toNamed(
                                  //                 RouteConstants.otherUserProfileScreen,
                                  //                 parameters: parameters);
                                  //           } else {
                                  //             anynymousDialogBox(context);
                                  //           }
                                  //         },
                                  //         child: Text(
                                  //             widget.postForMudda.postAs == "user"
                                  //                 ? widget.postForMudda.userDetail!.fullname!
                                  //                 : "Anynymous",
                                  //             style:  GoogleFonts.nunitoSans(
                                  //                 fontWeight: FontWeight.w700,
                                  //                 fontSize: ScreenUtil().setSp(13),
                                  //                 color: Color(0xff31393C))
                                  //         ),
                                  //       ),
                                  //       timeText(
                                  //         convertToAgo(
                                  //           DateTime.parse(widget.postForMudda.createdAt!),
                                  //         ),
                                  //       ),
                                  //       const Spacer(),
                                  //       InkWell(
                                  //         onTap: () {
                                  //           reportPostDialogBox(
                                  //               context, widget.postForMudda.sId!);
                                  //         },
                                  //         child: const Icon(
                                  //           Icons.more_horiz,
                                  //           color: color606060,
                                  //           size: 22,
                                  //         ),
                                  //       ),
                                  //
                                  //     ],
                                  //   ),
                                  // ),
                                  if (widget.postForMudda.muddaDescription !=
                                          null &&
                                      widget.postForMudda.muddaDescription !=
                                          '')
                                    Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 8,
                                                top: 8,
                                                right: 8,
                                                bottom: widget.postForMudda
                                                                .gallery !=
                                                            null &&
                                                        widget
                                                                .postForMudda
                                                                .gallery!
                                                                .length >
                                                            0
                                                    ? 0
                                                    : 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    widget.postForMudda
                                                        .muddaDescription!,
                                                    textAlign:
                                                        TextAlign.start,
                                                    style: GoogleFonts
                                                        .nunitoSans(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                        15),
                                                            color: const Color(
                                                                0xff000000)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Column(
                                        //   mainAxisAlignment: MainAxisAlignment.center,
                                        //   crossAxisAlignment: CrossAxisAlignment.center,
                                        //   children: [
                                        //     // AnimatedBuilder(
                                        //     //   animation: _controller,
                                        //     //   child: InkWell(
                                        //     //       onTap: () {
                                        //     //         setState(() {
                                        //     //           isLoad = !isLoad;
                                        //     //         });
                                        //     //
                                        //     //         isLoad
                                        //     //             ? _controller.forward()
                                        //     //             : _controller.reverse();
                                        //     //         update();
                                        //     //       },
                                        //     //       child: Padding(
                                        //     //         padding:
                                        //     //         const EdgeInsets.symmetric(vertical: 16),
                                        //     //         child: Image.asset(
                                        //     //           AppIcons.iconUpDown,
                                        //     //           height: 16,
                                        //     //           width: 16,
                                        //     //         ),
                                        //     //       )),
                                        //     //   builder: (context, child) {
                                        //     //     return Container(
                                        //     //       child: Transform.rotate(
                                        //     //         angle: animation.value,
                                        //     //         child: child,
                                        //     //       ),
                                        //     //     );
                                        //     //   },
                                        //     // ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  // JournalImageMatrix(
                                  //   imageArr: ,
                                  // ),
                                  if (widget.postForMudda.gallery != null &&
                                      widget.postForMudda.gallery!.length > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          left: 8,
                                          bottom: 8,
                                          right: 8),
                                      child: MuddaVideo(
                                        list: widget.postForMudda.gallery!,
                                        basePath: widget.muddaPath,
                                        width: ScreenUtil().setSp(242),
                                      ),
                                    ),
                                  Container(
                                    height: 1,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    color: const Color(0xffF2F2F2),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // muddaNewsController
                                            //     .isRepliesShow.value =
                                            // !muddaNewsController!
                                            //     .isRepliesShow.value;
                                            // muddaNewsController!.height.value = Get.height * 0.4;
                                            // muddaNewsController!.width.value = Get.width;
                                            // muddaNewsController!.currentIndex.value = widget.index;
                                            // setState(() {});
                                            muddaNewsController
                                                .postForMuddaIndex
                                                .value = widget.index;
                                            muddaNewsController.postForMudda
                                                .value = widget.postForMudda;
                                            Get.toNamed(RouteConstants
                                                .muddaContainerReplies);
                                          },
                                          child: Container(
                                            height: Get.height * 0.045,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      AppIcons.icReply,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      widget.postForMudda
                                                                  .replies ==
                                                              null
                                                          ? "-"
                                                          : "${widget.postForMudda.replies}",
                                                      style: size12_M_regular(
                                                          textColor: black),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  child: SvgPicture.asset(
                                                    AppIcons.icArrowDown,
                                                    color: grey,
                                                  ),
                                                  visible: muddaNewsController
                                                          .isRepliesShow
                                                          .value &&
                                                      muddaNewsController
                                                              .currentIndex
                                                              .value ==
                                                          widget.index,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            muddaNewsController.postForMudda
                                                .value = widget.postForMudda;
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return const CommentsPost();
                                                });
                                          },
                                          child: Container(
                                            height: Get.height * 0.045,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    // AppIcons.replyIcon,
                                                    AppIcons.iconComments,
                                                    height: 16,
                                                    width: 16),
                                                const SizedBox(width: 5),
                                                Text(
                                                    NumberFormat
                                                        .compactCurrency(
                                                      decimalDigits: 0,
                                                      symbol:
                                                          '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                    ).format(
                                                        widget.postForMudda
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
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (AppPreference().getBool(
                                                PreferencesKey.isGuest)) {
                                              updateProfileDialog(context);
                                            } else {
                                              muddaNewsController.agreeDisagreePost();
                                              Api.post.call(
                                                context,
                                                method: "like/store",
                                                isLoading: false,
                                                param: {
                                                  "user_id": AppPreference()
                                                      .getString(PreferencesKey
                                                          .interactUserId),
                                                  "relative_id":
                                                      widget.postForMudda.sId,
                                                  "relative_type":
                                                      "PostForMudda",
                                                  "status": false
                                                },
                                                onResponseSuccess: (object) {
                                                  print("Abhishek $object");
                                                },
                                              );
                                              if (widget.postForMudda
                                                      .agreeStatus ==
                                                  false) {
                                                widget.postForMudda
                                                    .agreeStatus = null;
                                                widget.postForMudda
                                                    .dislikersCount = widget
                                                        .postForMudda
                                                        .dislikersCount! -
                                                    1;
                                              } else if (widget.postForMudda
                                                      .agreeStatus ==
                                                  true) {
                                                widget.postForMudda
                                                    .dislikersCount = widget
                                                        .postForMudda
                                                        .dislikersCount! +
                                                    1;
                                                widget.postForMudda
                                                    .likersCount = widget
                                                            .postForMudda
                                                            .likersCount ==
                                                        0
                                                    ? widget.postForMudda
                                                        .likersCount
                                                    : widget.postForMudda
                                                            .likersCount! -
                                                        1;
                                                widget.postForMudda
                                                    .agreeStatus = false;
                                              } else {
                                                widget.postForMudda
                                                    .dislikersCount = widget
                                                        .postForMudda
                                                        .dislikersCount! +
                                                    1;
                                                widget.postForMudda
                                                    .agreeStatus = false;
                                              }

                                              muddaNewsController.pIndex
                                                  .value = widget.index;
                                              muddaNewsController
                                                  .postForMuddaList
                                                  .removeAt(widget.index);
                                              muddaNewsController
                                                  .postForMuddaList
                                                  .insert(
                                                      muddaNewsController
                                                          .pIndex.value,
                                                      widget.postForMudda);
                                              // int pIndex = widget.index;
                                              // muddaNewsController!
                                              //     .postForMuddaList
                                              //     .removeAt(widget.index);
                                              // muddaNewsController!
                                              //     .postForMuddaList
                                              //     .insert(widget.index, widget.postForMudda);
                                            }
                                          },
                                          child: Container(
                                            height: Get.height * 0.045,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    widget.postForMudda
                                                                .agreeStatus ==
                                                            false
                                                        ? AppIcons.dislikeFill
                                                        : AppIcons.dislike,
                                                    height: 16,
                                                    width: 16,
                                                    color: widget.postForMudda
                                                                .agreeStatus ==
                                                            false
                                                        ? colorF1B008
                                                        : blackGray),
                                                const SizedBox(width: 5),
                                                widget.postForMudda
                                                            .agreeStatus ==
                                                        false
                                                    ? Text(
                                                        "${NumberFormat.compactCurrency(
                                                          decimalDigits: 0,
                                                          symbol:
                                                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                        ).format(widget.postForMudda.dislikersCount)} Disagree",
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight: widget
                                                                        .postForMudda
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
                                                            color: widget
                                                                        .postForMudda
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
                                                        ).format(widget.postForMudda.dislikersCount)}",
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight: widget
                                                                        .postForMudda
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
                                                            color: widget
                                                                        .postForMudda
                                                                        .agreeStatus ==
                                                                    false
                                                                ? colorF1B008
                                                                : blackGray),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (AppPreference().getBool(
                                                PreferencesKey.isGuest)) {
                                              updateProfileDialog(context);
                                            } else {
                                              muddaNewsController.agreeDisagreePost();
                                              Api.post.call(
                                                context,
                                                method: "like/store",
                                                isLoading: false,
                                                param: {
                                                  "user_id": AppPreference()
                                                      .getString(PreferencesKey
                                                          .interactUserId),
                                                  "relative_id":
                                                      widget.postForMudda.sId,
                                                  "relative_type":
                                                      "PostForMudda",
                                                  "status": true
                                                },
                                                onResponseSuccess:
                                                    (object) {},
                                              );
                                              if (widget.postForMudda
                                                      .agreeStatus ==
                                                  true) {
                                                widget.postForMudda
                                                    .agreeStatus = null;
                                                widget.postForMudda
                                                    .likersCount = widget
                                                        .postForMudda
                                                        .likersCount! -
                                                    1;
                                              } else if (widget.postForMudda
                                                      .agreeStatus ==
                                                  false) {
                                                widget.postForMudda
                                                    .likersCount = widget
                                                        .postForMudda
                                                        .likersCount! +
                                                    1;
                                                widget.postForMudda
                                                    .dislikersCount = widget
                                                            .postForMudda
                                                            .dislikersCount ==
                                                        0
                                                    ? widget.postForMudda
                                                        .dislikersCount
                                                    : widget.postForMudda
                                                            .dislikersCount! -
                                                        1;

                                                widget.postForMudda
                                                    .agreeStatus = true;
                                              } else {
                                                widget.postForMudda
                                                    .likersCount = widget
                                                        .postForMudda
                                                        .likersCount! +
                                                    1;

                                                widget.postForMudda
                                                    .agreeStatus = true;
                                              }

                                              muddaNewsController.pIndex
                                                  .value = widget.index;
                                              muddaNewsController
                                                  .postForMuddaList
                                                  .removeAt(widget.index);
                                              muddaNewsController
                                                  .postForMuddaList
                                                  .insert(
                                                      muddaNewsController
                                                          .pIndex.value,
                                                      widget.postForMudda);
                                              //int pIndex = widget.index;
                                              // muddaNewsController!
                                              //     .postForMuddaList
                                              //     .removeAt(widget.index);
                                              // muddaNewsController!
                                              //     .postForMuddaList
                                              //     .insert(widget.index,
                                              //     widget.postForMudda);
                                            }
                                          },
                                          child: Container(
                                            height: Get.height * 0.045,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    widget.postForMudda
                                                                .agreeStatus ==
                                                            true
                                                        ? AppIcons
                                                            .handIconFill
                                                        : AppIcons.handIcon,
                                                    height: 16,
                                                    width: 16,
                                                    color: widget.postForMudda
                                                                .agreeStatus ==
                                                            true
                                                        ? color0060FF
                                                        : blackGray),
                                                const SizedBox(width: 5),
                                                widget.postForMudda
                                                            .agreeStatus ==
                                                        true
                                                    ? Text(
                                                        "${NumberFormat.compactCurrency(
                                                          decimalDigits: 0,
                                                          symbol:
                                                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                        ).format(widget.postForMudda.likersCount)} Agree",
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight: widget
                                                                        .postForMudda
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
                                                            color: widget
                                                                        .postForMudda
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
                                                        ).format(widget.postForMudda.likersCount)}",
                                                        style: GoogleFonts.nunitoSans(
                                                            fontWeight: widget
                                                                        .postForMudda
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
                                                            color: widget
                                                                        .postForMudda
                                                                        .agreeStatus ==
                                                                    true
                                                                ? color0060FF
                                                                : blackGray),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: InkWell(
                                    onTap: () {
                                      muddaNewsController
                                              .acceptUserDetail.value =
                                          widget.postForMudda.userDetail!;
                                      if (widget.postForMudda.userDetail!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.userId)) {
                                        Get.toNamed(
                                            RouteConstants.profileScreen);
                                      } else if (widget.postForMudda.postAs ==
                                          "user") {
                                        Map<String, String>? parameters = {
                                          "userDetail": jsonEncode(
                                              widget.postForMudda.userDetail!),
                                          "postAs": widget.postForMudda.postAs!
                                        };
                                        Get.toNamed(
                                            RouteConstants
                                                .otherUserProfileScreen,
                                            parameters: parameters);
                                      } else {
                                        anynymousDialogBox(context);
                                      }
                                    },
                                    child: widget.postForMudda.postAs == "user"
                                        ? widget.postForMudda.userDetail!
                                                    .profile !=
                                                null
                                            ? Stack(children: [
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      "${widget.muddaUserProfilePath}${widget.postForMudda.userDetail!.profile!}",
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width:
                                                        ScreenUtil().setSp(40),
                                                    height:
                                                        ScreenUtil().setSp(40),
                                                    decoration: BoxDecoration(
                                                      color: colorWhite,
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ])
                                            : Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  border: Border.all(
                                                    color: darkGray,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Stack(children: [
                                                  Center(
                                                    child: Text(
                                                        widget
                                                            .postForMudda
                                                            .userDetail!
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
                                                ]),
                                              )
                                        : Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: colorWhite,
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
                                          ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 0, left: 8),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            muddaNewsController
                                                    .acceptUserDetail.value =
                                                widget.postForMudda.userDetail!;
                                            if (widget.postForMudda.userDetail!
                                                    .sId ==
                                                AppPreference().getString(
                                                    PreferencesKey.userId)) {
                                              Get.toNamed(
                                                  RouteConstants.profileScreen);
                                            } else if (widget
                                                    .postForMudda.postAs ==
                                                "user") {
                                              Map<String, String>? parameters =
                                                  {
                                                "userDetail": jsonEncode(widget
                                                    .postForMudda.userDetail!),
                                                "postAs":
                                                    widget.postForMudda.postAs!
                                              };
                                              Get.toNamed(
                                                  RouteConstants
                                                      .otherUserProfileScreen,
                                                  parameters: parameters);
                                            } else {
                                              anynymousDialogBox(context);
                                            }
                                          },
                                          child: Text(
                                            widget.postForMudda.postAs == "user"
                                                ? widget.postForMudda
                                                    .userDetail!.fullname!
                                                : "Anonymous",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    ScreenUtil().setSp(13),
                                                color: const Color(0xff31393C)),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        if (widget.postForMudda.followStatus ==
                                            true) ...[
                                          Text('- following',
                                              style: GoogleFonts.nunitoSans(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize:
                                                      ScreenUtil().setSp(10),
                                                  color: black)),
                                        ],
                                        const Spacer(),
                                        if (widget.postForMudda.hotPost! > 0 ||
                                            widget.postForMudda.hotPost! <= 3)
                                          for (var x = 1;
                                              x <= widget.postForMudda.hotPost!;
                                              x++) ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              child: SvgPicture.asset(
                                                AppIcons.hot,
                                                color: const Color(0xFFF1B008),
                                              ),
                                            )
                                          ],
                                        if (widget.postForMudda.hotPost! > 3)
                                          for (var x = 1; x <= 3; x++) ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              child: SvgPicture.asset(
                                                AppIcons.hot,
                                                color: const Color(0xFFF1B008),
                                              ),
                                            )
                                          ],
                                        InkWell(
                                          onTap: () {
                                            if (widget.postForMudda.userDetail!
                                                    .sId ==
                                                AppPreference().getString(
                                                    PreferencesKey.userId)) {
                                              reportPostDeleteDialogBox(context,
                                                      widget.postForMudda.sId!)
                                                  .then((value) {
                                                if (value == true) {
                                                  muddaNewsController
                                                      .postForMuddaList
                                                      .removeAt(widget.index);
                                                }
                                              });
                                            } else {
                                              muddaNewsController
                                                  .postForMudda.value =
                                                  widget.postForMudda;
                                              reportPostDialogBox(
                                                  context,
                                                  widget.postForMudda.sId
                                                      .toString());
                                            }
                                          },
                                          child: const Icon(
                                            Icons.more_horiz,
                                            color: color606060,
                                            size: 22,
                                          ),
                                        ),
                                        timeText(
                                          convertToAgo(
                                            DateTime.parse(
                                                widget.postForMudda.createdAt!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  timeText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getSizedBox(w: 10),
        Text("$text, ",
            style: GoogleFonts.nunitoSans(
                fontStyle: FontStyle.italic,
                fontSize: ScreenUtil().setSp(10),
                color: const Color(0xff31393C))),
        getSizedBox(w: 10),
      ],
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
}
