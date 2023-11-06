import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/core/utils/time_convert.dart';
import 'package:mudda/ui/screens/mudda/view/journal_image_matrix.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/route_constants.dart';
import '../../../../core/preferences/preference_manager.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../../core/utils/color.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../model/PostForMuddaModel.dart';
import '../../../../model/RepliesResponseModel.dart';
import '../../../shared/report_post_dialog_box.dart';
import '../../home_screen/controller/mudda_fire_news_controller.dart';
import '../widget/media_box.dart';
import 'mudda_details_screen.dart';

// class RepliesView extends StatelessWidget {
//   PostForMudda repliesResponseModelResult;
//   String muddaPath;
//   int index;
//   String muddaUserProfilePath;
//   MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
//
//   RepliesView(
//     this.repliesResponseModelResult,
//     this.muddaPath,
//     this.index,
//     this.muddaUserProfilePath, {
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           // margin: EdgeInsets.all(ScreenUtil().setSp(4)),
//           margin: const EdgeInsets.only(bottom: 5, top: 20, right: 40, left: 8),
//           padding: const EdgeInsets.all(8),
//           // height: ScreenUtil().setSp(161),
//           width: ScreenUtil().screenWidth,
//           decoration: BoxDecoration(
//             color: Colors.transparent,
//             border: Border.all(color: grey, width: 1),
//             // border: Border.all(color: grey),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16),
//               topRight: Radius.circular(16),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Column(
//                   //   children: [
//                   //     Container(
//                   //       margin: const EdgeInsets.only(top: 32, right: 5),
//                   //       height: 16,
//                   //       width: 16,
//                   //       child: Image.asset(AppIcons.iconUpDown),
//                   //     ),
//                   //   ],
//                   // ),
//                   Expanded(
//                     child: Container(
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   padding: const EdgeInsets.only(
//                                       bottom: 8, left: 40),
//                                   child: Wrap(
//                                     children: [
//                                       Text(
//                                         repliesResponseModelResult
//                                             .muddaDescription!,
//                                         style: GoogleFonts.nunitoSans(
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: ScreenUtil().setSp(12),
//                                             color: black),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 40),
//                 child: RepliesVideo(
//                   // height: ScreenUtil().setSp(138),
//                   height: 100,
//                   width: 100,
//                   list: repliesResponseModelResult.gallery!,
//                   basePath: muddaPath,
//                   // width: ScreenUtil().screenWidth / 2,
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(top: 10, bottom: 2),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Map<String, String>? parameters = {
//                           "postForMudda": jsonEncode(repliesResponseModelResult)
//                         };
//
//                         if (AppPreference().getBool(PreferencesKey.isGuest)) {
//                           Get.toNamed(RouteConstants.userProfileEdit);
//                         } else {
//                           Get.toNamed(RouteConstants.uploadChildReplyScreen,
//                               parameters: parameters);
//                         }
//                       },
//                       child: Text(
//                         "Reply",
//                         style: size12_M_regular(textColor: blackGray),
//                       ),
//                     ),
//
//                     // GestureDetector(
//                     //   onTap: () {
//                     //     muddaNewsController.postForMuddaIndex.value = index;
//                     //     muddaNewsController.repliesData.value =
//                     //         repliesResponseModelResult;
//                     //     Get.toNamed(RouteConstants.muddaPostCommentsScreen);
//                     //   },
//                     //   child: Row(
//                     //     children: [
//                     //       Text(
//                     //           NumberFormat.compactCurrency(
//                     //             decimalDigits: 0,
//                     //             symbol:
//                     //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
//                     //           ).format(
//                     //               repliesResponseModelResult.commentorsCount),
//                     //           style: GoogleFonts.nunitoSans(
//                     //               fontWeight: FontWeight.w400,
//                     //               fontSize: ScreenUtil().setSp(12),
//                     //               color: blackGray)),
//                     //       const SizedBox(width: 5),
//                     //       Image.asset(
//                     //         // AppIcons.replyIcon,
//                     //         AppIcons.iconComments,
//                     //         height: 20,
//                     //         width: 20,
//                     //       )
//                     //     ],
//                     //   ),
//                     // ),
//                     // Row(
//                     //   children: [
//                     //     Text(
//                     //       "20.1k",
//                     //       style: size12_M_regular(textColor: black),
//                     //     ),
//                     //     SizedBox(width: 5),
//                     //     Image.asset(
//                     //       AppIcons.iconComments,
//                     //       height: 16,
//                     //       width: 16,
//                     //     ),
//                     //   ],
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.only(right: 40, left: 0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               InkWell(
//                 onTap: () {
//                   muddaNewsController.acceptUserDetail.value =
//                       repliesResponseModelResult.userDetail!;
//                   if (repliesResponseModelResult.userDetail!.sId ==
//                       AppPreference().getString(PreferencesKey.userId)) {
//                     Get.toNamed(RouteConstants.profileScreen);
//                   } else if (repliesResponseModelResult.postAs == "user") {
//                     Map<String, String>? parameters = {
//                       "userDetail":
//                           jsonEncode(repliesResponseModelResult.userDetail!),
//                       "postAs": repliesResponseModelResult.postAs!
//                     };
//                     Get.toNamed(RouteConstants.otherUserProfileScreen,
//                         parameters: parameters);
//                   } else {
//                     anynymousDialogBox(context);
//                   }
//                 },
//                 child: Padding(
//                     padding: EdgeInsets.only(left: ScreenUtil().setSp(10)),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         repliesResponseModelResult.postAs == "user"
//                             ? repliesResponseModelResult.userDetail!.profile !=
//                                     null
//                                 ? CachedNetworkImage(
//                                     imageUrl:
//                                         "$muddaUserProfilePath${repliesResponseModelResult.userDetail!.profile!}",
//                                     imageBuilder: (context, imageProvider) =>
//                                         Container(
//                                       width: ScreenUtil().setSp(40),
//                                       height: ScreenUtil().setSp(40),
//                                       decoration: BoxDecoration(
//                                         color: colorWhite,
//                                         shape: BoxShape.circle,
//                                         image: DecorationImage(
//                                             image: imageProvider,
//                                             fit: BoxFit.cover),
//                                       ),
//                                     ),
//                                     errorWidget: (context, url, error) =>
//                                         const Icon(Icons.error),
//                                   )
//                                 : Container(
//                                     height: 40,
//                                     width: 40,
//                                     decoration: BoxDecoration(
//                                       color: colorWhite,
//                                       border: Border.all(
//                                         color: darkGray,
//                                       ),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                           repliesResponseModelResult
//                                               .userDetail!.fullname![0]
//                                               .toUpperCase(),
//                                           style: GoogleFonts.nunitoSans(
//                                               fontWeight: FontWeight.w400,
//                                               fontSize: ScreenUtil().setSp(20),
//                                               color: black)),
//                                     ),
//                                   )
//                             : Container(
//                                 height: 40,
//                                 width: 40,
//                                 decoration: BoxDecoration(
//                                   color: colorWhite,
//                                   border: Border.all(
//                                     color: darkGray,
//                                   ),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Text("A",
//                                       style: GoogleFonts.nunitoSans(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: ScreenUtil().setSp(20),
//                                           color: black)),
//                                 ),
//                               ),
//                         // SizedBox(
//                         //   width: ScreenUtil().setSp(8),
//                         // ),
//                         // Row(
//                         //   children: [
//                         //     Text(
//                         //       postForMudda.postAs == "user"
//                         //           ? postForMudda.userDetail!.fullname!
//                         //           : "Anynymous",
//                         //       style: GoogleFonts.nunitoSans(
//                         //           fontWeight: FontWeight.w700,
//                         //           fontSize: ScreenUtil().setSp(12),
//                         //           color: black),
//                         //     ),
//                         //     timeText(
//                         //       convertToAgo(
//                         //         DateTime.parse(postForMudda.createdAt!),
//                         //       ),
//                         //     ),
//                         //   ],
//                         // ),
//                       ],
//                     )),
//               ),
//               const SizedBox(width: 5),
//               InkWell(
//                 onTap: () {
//                   muddaNewsController.acceptUserDetail.value =
//                       repliesResponseModelResult.userDetail!;
//                   if (repliesResponseModelResult.userDetail!.sId ==
//                       AppPreference().getString(PreferencesKey.userId)) {
//                     Get.toNamed(RouteConstants.profileScreen);
//                   } else if (repliesResponseModelResult.postAs == "user") {
//                     Map<String, String>? parameters = {
//                       "userDetail":
//                           jsonEncode(repliesResponseModelResult.userDetail!),
//                       "postAs": repliesResponseModelResult.postAs!
//                     };
//                     Get.toNamed(RouteConstants.otherUserProfileScreen,
//                         parameters: parameters);
//                   } else {
//                     anynymousDialogBox(context);
//                   }
//                 },
//                 child: Text(
//                   repliesResponseModelResult.postAs == "user"
//                       ? repliesResponseModelResult.userDetail!.fullname!
//                       : "Anynymous",
//                   style: GoogleFonts.nunitoSans(
//                       fontWeight: FontWeight.w700,
//                       fontSize: ScreenUtil().setSp(12),
//                       color: black),
//                 ),
//               ),
//               timeText(
//                 convertToAgo(
//                   DateTime.parse(repliesResponseModelResult.createdAt!),
//                 ),
//               ),
//               const Spacer(),
//               InkWell(
//                 onTap: () {
//                   log("-=-=-=-=-=-=-=-");
//                   reportPostDialogBox(context, repliesResponseModelResult.sId!);
//                 },
//                 child: const Icon(
//                   Icons.more_horiz,
//                   color: color606060,
//                   size: 22,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
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
//
// class OpposionRepliesView extends StatelessWidget {
//   PostForMudda repliesResponseModelResult;
//   String muddaPath;
//   int index;
//   String muddaUserProfilePath;
//   MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
//
//   OpposionRepliesView(
//     this.repliesResponseModelResult,
//     this.muddaPath,
//     this.index,
//     this.muddaUserProfilePath, {
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           // margin: EdgeInsets.all(ScreenUtil().setSp(4)),
//           margin: const EdgeInsets.only(bottom: 5, top: 20, right: 8, left: 40),
//           padding: const EdgeInsets.all(8),
//           // height: ScreenUtil().setSp(161),
//           width: ScreenUtil().screenWidth,
//           decoration: BoxDecoration(
//             color: Colors.transparent,
//             border: Border.all(color: grey, width: 1),
//             // border: Border.all(color: grey),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16),
//               topRight: Radius.circular(16),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Column(
//                   //   children: [
//                   //     Container(
//                   //       margin: const EdgeInsets.only(top: 32, right: 5),
//                   //       height: 16,
//                   //       width: 16,
//                   //       child: Image.asset(AppIcons.iconUpDown),
//                   //     ),
//                   //   ],
//                   // ),
//                   Expanded(
//                     child: Container(
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   padding: const EdgeInsets.only(
//                                       bottom: 8, right: 40),
//                                   child: Wrap(
//                                     children: [
//                                       Text(
//                                         repliesResponseModelResult
//                                             .muddaDescription!,
//                                         style: GoogleFonts.nunitoSans(
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: ScreenUtil().setSp(12),
//                                             color: black),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 40),
//                 child: RepliesVideo(
//                   // height: ScreenUtil().setSp(138),
//                   height: 100,
//                   width: 100,
//                   list: repliesResponseModelResult.gallery!,
//                   basePath: muddaPath,
//                   // width: ScreenUtil().screenWidth / 2,
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(top: 10, bottom: 2),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Map<String, String>? parameters = {
//                           "postForMudda": jsonEncode(repliesResponseModelResult)
//                         };
//
//                         if (AppPreference().getBool(PreferencesKey.isGuest)) {
//                           Get.toNamed(RouteConstants.userProfileEdit);
//                         } else {
//                           Get.toNamed(RouteConstants.uploadChildReplyScreen,
//                               parameters: parameters);
//                         }
//                       },
//                       child: Text(
//                         "Reply",
//                         style: size12_M_regular(textColor: blackGray),
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.only(right: 8, left: 40),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(width: 5),
//               InkWell(
//                 onTap: () {
//                   log("-=-=-=-=-=-=-=-");
//                   reportPostDialogBox(context, repliesResponseModelResult.sId!);
//                 },
//                 child: const Icon(
//                   Icons.more_horiz,
//                   color: color606060,
//                   size: 22,
//                 ),
//               ),
//               const Spacer(),
//               timeText(
//                 convertToAgo(
//                   DateTime.parse(repliesResponseModelResult.createdAt!),
//                 ),
//               ),
//               const SizedBox(width: 5),
//               InkWell(
//                 onTap: () {
//                   muddaNewsController.acceptUserDetail.value =
//                       repliesResponseModelResult.userDetail!;
//                   if (repliesResponseModelResult.userDetail!.sId ==
//                       AppPreference().getString(PreferencesKey.userId)) {
//                     Get.toNamed(RouteConstants.profileScreen);
//                   } else if (repliesResponseModelResult.postAs == "user") {
//                     Map<String, String>? parameters = {
//                       "userDetail":
//                           jsonEncode(repliesResponseModelResult.userDetail!),
//                       "postAs": repliesResponseModelResult.postAs!
//                     };
//                     Get.toNamed(RouteConstants.otherUserProfileScreen,
//                         parameters: parameters);
//                   } else {
//                     anynymousDialogBox(context);
//                   }
//                 },
//                 child: Text(
//                   repliesResponseModelResult.postAs == "user"
//                       ? repliesResponseModelResult.userDetail!.fullname!
//                       : "Anynymous",
//                   style: GoogleFonts.nunitoSans(
//                       fontWeight: FontWeight.w700,
//                       fontSize: ScreenUtil().setSp(12),
//                       color: black),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   muddaNewsController.acceptUserDetail.value =
//                       repliesResponseModelResult.userDetail!;
//                   if (repliesResponseModelResult.userDetail!.sId ==
//                       AppPreference().getString(PreferencesKey.userId)) {
//                     Get.toNamed(RouteConstants.profileScreen);
//                   } else if (repliesResponseModelResult.postAs == "user") {
//                     Map<String, String>? parameters = {
//                       "userDetail":
//                           jsonEncode(repliesResponseModelResult.userDetail!),
//                       "postAs": repliesResponseModelResult.postAs!
//                     };
//                     Get.toNamed(RouteConstants.otherUserProfileScreen,
//                         parameters: parameters);
//                   } else {
//                     anynymousDialogBox(context);
//                   }
//                 },
//                 child: Padding(
//                     padding: EdgeInsets.only(left: ScreenUtil().setSp(10)),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         repliesResponseModelResult.postAs == "user"
//                             ? repliesResponseModelResult.userDetail!.profile !=
//                                     null
//                                 ? CachedNetworkImage(
//                                     imageUrl:
//                                         "$muddaUserProfilePath${repliesResponseModelResult.userDetail!.profile!}",
//                                     imageBuilder: (context, imageProvider) =>
//                                         Container(
//                                       width: ScreenUtil().setSp(40),
//                                       height: ScreenUtil().setSp(40),
//                                       decoration: BoxDecoration(
//                                         color: colorWhite,
//                                         shape: BoxShape.circle,
//                                         image: DecorationImage(
//                                             image: imageProvider,
//                                             fit: BoxFit.cover),
//                                       ),
//                                     ),
//                                     errorWidget: (context, url, error) =>
//                                         const Icon(Icons.error),
//                                   )
//                                 : Container(
//                                     height: 40,
//                                     width: 40,
//                                     decoration: BoxDecoration(
//                                       color: colorWhite,
//                                       border: Border.all(
//                                         color: darkGray,
//                                       ),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                           repliesResponseModelResult
//                                               .userDetail!.fullname![0]
//                                               .toUpperCase(),
//                                           style: GoogleFonts.nunitoSans(
//                                               fontWeight: FontWeight.w400,
//                                               fontSize: ScreenUtil().setSp(20),
//                                               color: black)),
//                                     ),
//                                   )
//                             : Container(
//                                 height: 40,
//                                 width: 40,
//                                 decoration: BoxDecoration(
//                                   color: colorWhite,
//                                   border: Border.all(
//                                     color: darkGray,
//                                   ),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Text("A",
//                                       style: GoogleFonts.nunitoSans(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: ScreenUtil().setSp(20),
//                                           color: black)),
//                                 ),
//                               ),
//                         // SizedBox(
//                         //   width: ScreenUtil().setSp(8),
//                         // ),
//                         // Row(
//                         //   children: [
//                         //     Text(
//                         //       postForMudda.postAs == "user"
//                         //           ? postForMudda.userDetail!.fullname!
//                         //           : "Anynymous",
//                         //       style: GoogleFonts.nunitoSans(
//                         //           fontWeight: FontWeight.w700,
//                         //           fontSize: ScreenUtil().setSp(12),
//                         //           color: black),
//                         //     ),
//                         //     timeText(
//                         //       convertToAgo(
//                         //         DateTime.parse(postForMudda.createdAt!),
//                         //       ),
//                         //     ),
//                         //   ],
//                         // ),
//                       ],
//                     )),
//               ),
//             ],
//           ),
//         ),
//       ],
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
//
// class RepliesVideo extends StatefulWidget {
//   final double height;
//   final double width;
//   final String basePath;
//   final List<Gallery> list;
//
//   const RepliesVideo({
//     Key? key,
//     required this.height,
//     required this.list,
//     required this.basePath,
//     required this.width,
//   }) : super(key: key);
//
//   @override
//   State<RepliesVideo> createState() => _RepliesVideoState();
// }
//
// class _RepliesVideoState extends State<RepliesVideo> {
//   int selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.bottomCenter,
//       children: [
//         // CarouselSlider(
//         //   options: CarouselOptions(
//         //     height: widget.height,
//         //     enableInfiniteScroll: false,
//         //     onPageChanged: (int, CarouselPageChangedReason) {
//         //       selectedIndex = int;
//         //       setState(() {});
//         //     },
//         //     viewportFraction: 1.0,
//         //     enlargeCenterPage: false,
//         //     // autoPlay: false,
//         //   ),
//         //   items: List.generate(
//         //     widget.list.length,
//         //     (index) => GestureDetector(
//         //       onTap: () {
//         //         muddaGalleryDialog(
//         //             context, widget.list, widget.basePath, index);
//         //       },
//         //       child: Container(
//         //         decoration: BoxDecoration(
//         //             color: colorAppBackground,
//         //             borderRadius: BorderRadius.only(
//         //                 topLeft: Radius.circular(ScreenUtil().setSp(8)),
//         //                 bottomLeft: Radius.circular(ScreenUtil().setSp(8)))),
//         //         child: Stack(
//         //           alignment: Alignment.center,
//         //           children: [
//         //             Container(
//         //               width: widget.width,
//         //               height: widget.height,
//         //               decoration: BoxDecoration(
//         //                   color: colorAppBackground,
//         //                   borderRadius: BorderRadius.only(
//         //                       topLeft: Radius.circular(ScreenUtil().setSp(8)),
//         //                       bottomLeft:
//         //                           Radius.circular(ScreenUtil().setSp(8)))),
//         //               child: CachedNetworkImage(
//         //                 imageUrl:
//         //                     "${widget.basePath}${widget.list.elementAt(index).file!}",
//         //                 fit: BoxFit.cover,
//         //               ),
//         //             )
//         //           ],
//         //         ),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//
//         widget.list.isEmpty
//             ? const SizedBox()
//             : GestureDetector(
//                 onTap: () {
//                   muddaGalleryDialog(
//                     context,
//                     widget.list,
//                     widget.basePath,
//                     0,
//                   );
//                 },
//                 child: JournalImageMatrix(
//                   imageArr: widget.list,
//                   mediaFor: widget.basePath,
//                 ),
//               ),
//         // Positioned(
//         //   bottom: 5,
//         //   left: 50,
//         //   right: 50,
//         //   child: SingleChildScrollView(
//         //     scrollDirection: Axis.horizontal,
//         //     child: Row(
//         //       children: List.generate(
//         //         widget.list.length,
//         //         (index) => Padding(
//         //           padding: const EdgeInsets.only(right: 10),
//         //           child: selectedIndex != index
//         //               ? Container(
//         //                   height: 5,
//         //                   width: 20,
//         //                   decoration: const BoxDecoration(
//         //                     color: Colors.white,
//         //                     borderRadius: BorderRadius.all(
//         //                       Radius.circular(20),
//         //                     ),
//         //                   ),
//         //                 )
//         //               : Container(
//         //                   height: 5,
//         //                   width: 20,
//         //                   decoration: const BoxDecoration(
//         //                     color: Colors.white,
//         //                     borderRadius: BorderRadius.all(
//         //                       Radius.circular(20),
//         //                     ),
//         //                   ),
//         //                   child: Column(
//         //                     mainAxisAlignment: MainAxisAlignment.center,
//         //                     children: [
//         //                       Center(
//         //                         child: Container(
//         //                           height: 3,
//         //                           width: 18,
//         //                           decoration: const BoxDecoration(
//         //                             color: Colors.amber,
//         //                             borderRadius: BorderRadius.all(
//         //                               Radius.circular(20),
//         //                             ),
//         //                           ),
//         //                         ),
//         //                       )
//         //                     ],
//         //                   ),
//         //                 ),
//         //         ),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
// }
//
// class ReplyFavourView extends StatelessWidget {
//   PostForMudda repliesResponseModelResult;
//   String muddaPath;
//   int index;
//   String muddaUserProfilePath;
//   MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
//
//   ReplyFavourView(
//     this.repliesResponseModelResult,
//     this.muddaPath,
//     this.index,
//     this.muddaUserProfilePath, {
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: ScreenUtil().setSp(200),
//       width: Get.width,
//       child: Stack(
//         children: [
//           Container(
//             // margin: EdgeInsets.all(ScreenUtil().setSp(4)),
//             margin:
//                 const EdgeInsets.only(bottom: 5, top: 20, right: 40, left: 8),
//             padding: const EdgeInsets.all(8),
//             // height: ScreenUtil().setSp(161),
//             width: ScreenUtil().screenWidth,
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               border: Border.all(color: grey, width: 1),
//               // border: Border.all(color: grey),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.only(top: 32, right: 5),
//                           height: 16,
//                           width: 16,
//                           child: Image.asset(AppIcons.iconUpDown),
//                         ),
//                       ],
//                     ),
//                     Expanded(
//                       child: Container(
//                         margin: const EdgeInsets.only(left: 8),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   padding:
//                                       const EdgeInsets.only(bottom: 8, left: 8),
//                                   child: Wrap(
//                                     children: [
//                                       Text(
//                                         repliesResponseModelResult
//                                             .muddaDescription!,
//                                         style: GoogleFonts.nunitoSans(
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: ScreenUtil().setSp(12),
//                                             color: black),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 RepliesVideo(
//                   // height: ScreenUtil().setSp(138),
//                   height: 100,
//                   width: 100,
//                   list: repliesResponseModelResult.gallery!,
//                   basePath: muddaPath,
//                   // width: ScreenUtil().screenWidth / 2,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 10, bottom: 2),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Reply",
//                         style: size12_M_regular(textColor: blackGray),
//                       ),
//
//                       GestureDetector(
//                         onTap: () {
//                           muddaNewsController.postForMuddaIndex.value = index;
//                           muddaNewsController.repliesData.value =
//                               repliesResponseModelResult;
//                           Get.toNamed(RouteConstants.muddaPostCommentsScreen);
//                         },
//                         child: Row(
//                           children: [
//                             Text(
//                                 NumberFormat.compactCurrency(
//                                   decimalDigits: 0,
//                                   symbol:
//                                       '', // if you want to add currency symbol then pass that in this else leave it empty.
//                                 ).format(
//                                     repliesResponseModelResult.commentorsCount),
//                                 style: GoogleFonts.nunitoSans(
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: ScreenUtil().setSp(12),
//                                     color: blackGray)),
//                             const SizedBox(width: 5),
//                             Image.asset(
//                               // AppIcons.replyIcon,
//                               AppIcons.iconComments,
//                               height: 20,
//                               width: 20,
//                             )
//                           ],
//                         ),
//                       ),
//                       // Row(
//                       //   children: [
//                       //     Text(
//                       //       "20.1k",
//                       //       style: size12_M_regular(textColor: black),
//                       //     ),
//                       //     SizedBox(width: 5),
//                       //     Image.asset(
//                       //       AppIcons.iconComments,
//                       //       height: 16,
//                       //       width: 16,
//                       //     ),
//                       //   ],
//                       // ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.only(right: 40, left: 0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     muddaNewsController.acceptUserDetail.value =
//                         repliesResponseModelResult.userDetail!;
//                     if (repliesResponseModelResult.userDetail!.sId ==
//                         AppPreference().getString(PreferencesKey.userId)) {
//                       Get.toNamed(RouteConstants.profileScreen);
//                     } else if (repliesResponseModelResult.postAs == "user") {
//                       Map<String, String>? parameters = {
//                         "userDetail":
//                             jsonEncode(repliesResponseModelResult.userDetail!),
//                         "postAs": repliesResponseModelResult.postAs!
//                       };
//                       Get.toNamed(RouteConstants.otherUserProfileScreen,
//                           parameters: parameters);
//                     } else {
//                       anynymousDialogBox(context);
//                     }
//                   },
//                   child: Padding(
//                       padding: EdgeInsets.only(left: ScreenUtil().setSp(10)),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           repliesResponseModelResult.postAs == "user"
//                               ? repliesResponseModelResult
//                                           .userDetail!.profile !=
//                                       null
//                                   ? CachedNetworkImage(
//                                       imageUrl:
//                                           "$muddaUserProfilePath${repliesResponseModelResult.userDetail!.profile!}",
//                                       imageBuilder: (context, imageProvider) =>
//                                           Container(
//                                         width: ScreenUtil().setSp(40),
//                                         height: ScreenUtil().setSp(40),
//                                         decoration: BoxDecoration(
//                                           color: colorWhite,
//                                           shape: BoxShape.circle,
//                                           image: DecorationImage(
//                                               image: imageProvider,
//                                               fit: BoxFit.cover),
//                                         ),
//                                       ),
//                                       errorWidget: (context, url, error) =>
//                                           const Icon(Icons.error),
//                                     )
//                                   : Container(
//                                       height: 40,
//                                       width: 40,
//                                       decoration: BoxDecoration(
//                                         color: colorWhite,
//                                         border: Border.all(
//                                           color: darkGray,
//                                         ),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                             repliesResponseModelResult
//                                                 .userDetail!.fullname![0]
//                                                 .toUpperCase(),
//                                             style: GoogleFonts.nunitoSans(
//                                                 fontWeight: FontWeight.w400,
//                                                 fontSize:
//                                                     ScreenUtil().setSp(20),
//                                                 color: black)),
//                                       ),
//                                     )
//                               : Container(
//                                   height: 40,
//                                   width: 40,
//                                   decoration: BoxDecoration(
//                                     color: colorWhite,
//                                     border: Border.all(
//                                       color: darkGray,
//                                     ),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Center(
//                                     child: Text("A",
//                                         style: GoogleFonts.nunitoSans(
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: ScreenUtil().setSp(20),
//                                             color: black)),
//                                   ),
//                                 ),
//                           // SizedBox(
//                           //   width: ScreenUtil().setSp(8),
//                           // ),
//                           // Row(
//                           //   children: [
//                           //     Text(
//                           //       postForMudda.postAs == "user"
//                           //           ? postForMudda.userDetail!.fullname!
//                           //           : "Anynymous",
//                           //       style: GoogleFonts.nunitoSans(
//                           //           fontWeight: FontWeight.w700,
//                           //           fontSize: ScreenUtil().setSp(12),
//                           //           color: black),
//                           //     ),
//                           //     timeText(
//                           //       convertToAgo(
//                           //         DateTime.parse(postForMudda.createdAt!),
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),
//                         ],
//                       )),
//                 ),
//                 const SizedBox(width: 5),
//                 InkWell(
//                   onTap: () {
//                     muddaNewsController.acceptUserDetail.value =
//                         repliesResponseModelResult.userDetail!;
//                     if (repliesResponseModelResult.userDetail!.sId ==
//                         AppPreference().getString(PreferencesKey.userId)) {
//                       Get.toNamed(RouteConstants.profileScreen);
//                     } else if (repliesResponseModelResult.postAs == "user") {
//                       Map<String, String>? parameters = {
//                         "userDetail":
//                             jsonEncode(repliesResponseModelResult.userDetail!),
//                         "postAs": repliesResponseModelResult.postAs!
//                       };
//                       Get.toNamed(RouteConstants.otherUserProfileScreen,
//                           parameters: parameters);
//                     } else {
//                       anynymousDialogBox(context);
//                     }
//                   },
//                   child: Text(
//                     repliesResponseModelResult.postAs == "user"
//                         ? repliesResponseModelResult.userDetail!.fullname!
//                         : "Anynymous",
//                     style: GoogleFonts.nunitoSans(
//                         fontWeight: FontWeight.w700,
//                         fontSize: ScreenUtil().setSp(12),
//                         color: black),
//                   ),
//                 ),
//                 timeText(
//                   convertToAgo(
//                     DateTime.parse(repliesResponseModelResult.createdAt!),
//                   ),
//                 ),
//                 const Spacer(),
//                 InkWell(
//                   onTap: () {
//                     log("-=-=-=-=-=-=-=-");
//                     reportPostDialogBox(
//                         context, repliesResponseModelResult.sId!);
//                   },
//                   child: const Icon(
//                     Icons.more_horiz,
//                     color: color606060,
//                     size: 22,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
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

class RecentRepliesView extends StatefulWidget {
  PostForMudda postForMudda;
  String muddaPath;
  int index;
  String muddaUserProfilePath;

  RecentRepliesView(
    this.postForMudda,
    this.muddaPath,
    this.index,
    this.muddaUserProfilePath, {
    Key? key,
  }) : super(key: key);

  @override
  State<RecentRepliesView> createState() => _RecentRepliesViewState();
}

class _RecentRepliesViewState extends State<RecentRepliesView> {
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();

  @override
  Widget build(BuildContext context) {
    return widget.postForMudda.postIn =='favour'? InkWell(
      onTap: () {
        muddaNewsController.postForMuddaIndex.value = widget.index;
        muddaNewsController.postForMudda.value = widget.postForMudda;
        Get.toNamed(RouteConstants.muddaContainerReplies);
      },
      child: Stack(
        children: [
          Container(
            width: ScreenUtil().screenWidth,
            margin:
            const EdgeInsets.only(top: 0, bottom: 4, right: 8, left: 40),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              border: widget.postForMudda.parentPost != null
                  ? Border.all(
                  color: Color(0xffA0A0A0).withOpacity(0.50), width: 0.5)
                  : null,
            ),
            child: Column(
              children: [
                if (widget.postForMudda.parentPost != null) ...[
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 4, top: 8, bottom: 4,right: 46),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: white,width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              border: Border(
                                left: BorderSide(
                                    color: widget.postForMudda.parentPost!
                                        .postIn ==
                                        'favour'
                                        ? color0060FF
                                        : colorF1B008,
                                    width: 4),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, bottom: 2, right: 0, top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // SvgPicture.asset(
                                //   AppIcons.icParentReply,
                                // ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: Get.width / 1.6,
                                        child: Text(
                                          widget.postForMudda.parentPost!
                                              .muddaDescription!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: size12_M_normal(
                                            textColor: Color(0xff31393C),
                                          ),
                                        )),
                                    getSizedBox(h: ScreenUtil().setSp(6)),
                                    Container(
                                      width: Get.width / 1.56,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            TimeConvert.Dtime(widget.postForMudda
                                                .parentPost!.createdAt!),
                                            style: size10_M_normal(
                                              textColor: Color(0xff31393C),
                                            ),
                                          ),
                                          Text(
                                            "- ${widget.postForMudda.parentPost!.user!.fullname!}",
                                            style: size10_M_normal(
                                                textColor: Color(0xff31393C)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 6),
                                      height: 0.5,
                                      width: Get.width / 1.56,
                                      color: widget.postForMudda.parentPost!
                                          .postIn ==
                                          'favour'
                                          ? color0060FF
                                          : colorF1B008,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 0, right: 0, left: 0),
                    child: ClipRRect(
                      borderRadius: widget.postForMudda.parentPost == null
                          ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      )
                          : BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: Container(
                        width: ScreenUtil().screenWidth,
                        decoration: BoxDecoration(
                          color: white,
                          border: widget.postForMudda.hotPost! > 0
                              ? const Border(
                            left:
                            BorderSide(width: 1, color: colorF1B008),
                            bottom:
                            BorderSide(width: 1, color: colorF1B008),
                            top: BorderSide(width: 1, color: colorF1B008),
                            right: BorderSide(
                                width: 4, color: color0060FF),
                          )
                              : Border(
                            left: BorderSide(
                                width: 0.5,
                                color: Color(0xffA0A0A0)
                                    .withOpacity(0.50)),
                            bottom: BorderSide(
                                width: 0.5,
                                color: Color(0xffA0A0A0)
                                    .withOpacity(0.50)),
                            top: BorderSide(
                                width: 0.5,
                                color: Color(0xffA0A0A0)
                                    .withOpacity(0.50)),
                            right: BorderSide(
                                width: 4, color: color0060FF),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(right: 46, left: 8),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      reportPostDialogBox(
                                          context, widget.postForMudda.sId!);
                                    },
                                    child: const Icon(
                                      Icons.more_horiz,
                                      color: color606060,
                                      size: 22,
                                    ),
                                  ),
                                  const Spacer(),
                                  timeText(
                                    convertToAgo(
                                      DateTime.parse(
                                          widget.postForMudda.createdAt!),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      muddaNewsController
                                          .acceptUserDetail.value =
                                      widget.postForMudda.userDetail!;
                                      if (widget
                                          .postForMudda.userDetail!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.userId)) {
                                        Get.toNamed(
                                            RouteConstants.profileScreen);
                                      } else if (widget.postForMudda.postAs ==
                                          "user") {
                                        Map<String, String>? parameters = {
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
                                          ? widget.postForMudda.userDetail!
                                          .fullname!
                                          : "Anonymous",
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: ScreenUtil().setSp(13),
                                          color: Color(0xff31393C)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(widget.postForMudda.muddaDescription != null && widget.postForMudda.muddaDescription != '') Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:  EdgeInsets.only(
                                      left: 8, top: 8,bottom: widget.postForMudda.gallery != null && widget.postForMudda.gallery!.length >0? 0: 8, right: 46),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.postForMudda
                                            .muddaDescription!,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                            ScreenUtil().setSp(14),
                                            color: Color(0xff31393C)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if(widget.postForMudda.gallery != null && widget.postForMudda.gallery!.length>0) Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, bottom: 8, right: 46),
                              child: MuddaVideo(
                                list: widget.postForMudda.gallery!,
                                basePath: widget.muddaPath,
                                width: ScreenUtil().setSp(242),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 40, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4, left: 8),
                            child: Row(
                              children: [
                                if (widget.postForMudda.hotPost! > 0 ||
                                    widget.postForMudda.hotPost! <= 3)
                                  for (var x = 1;
                                  x <= widget.postForMudda.hotPost!;
                                  x++) ...[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: SvgPicture.asset(
                                        AppIcons.hot,
                                        color: Color(0xFFF1B008),
                                      ),
                                    )
                                  ],
                                if (widget.postForMudda.hotPost! > 3)
                                  for (var x = 1; x <= 3; x++) ...[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: SvgPicture.asset(
                                        AppIcons.hot,
                                        color: Color(0xFFF1B008),
                                      ),
                                    )
                                  ],
                                const Spacer(),
                                if (widget.postForMudda.followStatus ==
                                    true) ...[
                                  Text('following',
                                      style: GoogleFonts.nunitoSans(
                                          fontStyle: FontStyle.italic,
                                          fontSize: ScreenUtil().setSp(10),
                                          color: Color(0xff31393C))),
                                  SizedBox(width: 10),
                                ],
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            muddaNewsController.acceptUserDetail.value =
                            widget.postForMudda.userDetail!;
                            if (widget.postForMudda.userDetail!.sId ==
                                AppPreference()
                                    .getString(PreferencesKey.userId)) {
                              Get.toNamed(RouteConstants.profileScreen);
                            } else if (widget.postForMudda.postAs == "user") {
                              Map<String, String>? parameters = {
                                "userDetail": jsonEncode(
                                    widget.postForMudda.userDetail!),
                                "postAs": widget.postForMudda.postAs!
                              };
                              Get.toNamed(
                                  RouteConstants.otherUserProfileScreen,
                                  parameters: parameters);
                            } else {
                              anynymousDialogBox(context);
                            }
                          },
                          child: widget.postForMudda.postAs == "user"
                              ? widget.postForMudda.userDetail!.profile !=
                              null
                              ? CachedNetworkImage(
                            imageUrl:
                            "${widget.muddaUserProfilePath}${widget.postForMudda.userDetail!.profile!}",
                            imageBuilder:
                                (context, imageProvider) =>
                                Container(
                                  width: ScreenUtil().setSp(40),
                                  height: ScreenUtil().setSp(40),
                                  decoration: BoxDecoration(
                                    color: colorWhite,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
                              child: Text(
                                  widget.postForMudda.userDetail!
                                      .fullname![0]
                                      .toUpperCase(),
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                      ScreenUtil().setSp(20),
                                      color: black)),
                            ),
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
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(20),
                                      color: black)),
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
    )


        :InkWell(
      onTap: () {
        muddaNewsController.postForMuddaIndex.value = widget.index;
        muddaNewsController.postForMudda.value = widget.postForMudda;
        Get.toNamed(RouteConstants.muddaContainerReplies);
      },
      child: Stack(
        children: [
          Container(
            width: ScreenUtil().screenWidth,
            margin:
            const EdgeInsets.only(top: 0, bottom: 12, right: 40, left: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              border: widget.postForMudda.parentPost != null
                  ? Border.all(
                  color: Color(0xffA0A0A0).withOpacity(0.50), width: 0.5)
                  : null,
            ),
            child: Column(
              children: [
                if (widget.postForMudda.parentPost != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 46,top: 8,right: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: white,width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          decoration:  BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              border: Border(
                                left: BorderSide(color:widget.postForMudda.parentPost!.postIn == 'opposition'? colorF1B008: color0060FF,width:4),
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, bottom: 2, right: 0, top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // SvgPicture.asset(
                                //   AppIcons.icParentReply,
                                // ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: Get.width / 1.6,
                                        child: Text(
                                          widget.postForMudda.parentPost!
                                              .muddaDescription!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:size12_M_normal(
                                            textColor: Color(0xff31393C),
                                          ),
                                        )),
                                    getSizedBox(h: ScreenUtil().setSp(6)),
                                    Container(
                                      width: Get.width / 1.56,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            TimeConvert.Dtime(widget.postForMudda
                                                .parentPost!.createdAt!),
                                            style: size10_M_normal(
                                              textColor: Color(0xff31393C),
                                            ),
                                          ),
                                          Text(
                                            "- ${widget.postForMudda.parentPost!.user!.fullname!}",
                                            style: size10_M_normal(
                                                textColor: Color(0xff31393C)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(margin: EdgeInsets.only(top: 6),width: Get.width / 1.56,height:0.5,color: widget.postForMudda.parentPost!.postIn == 'opposition'? colorF1B008: color0060FF,)
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

                Stack(
                    children:[
                      Padding(
                        padding:  const EdgeInsets.only(top: 20, bottom: 0, right: 0, left: 0),
                        child: ClipRRect(
                          borderRadius:  widget.postForMudda.parentPost == null? const BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ): const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: Container(
                            width: ScreenUtil().screenWidth,
                            decoration: BoxDecoration(
                              color: white,
                              border:  widget.postForMudda.hotPost! > 0
                                  ? const Border(
                                right:
                                BorderSide(width: 1, color: colorF1B008),
                                bottom:
                                BorderSide(width: 1, color: colorF1B008),
                                top: BorderSide(width: 1, color: colorF1B008),
                                left: BorderSide(
                                    width: 4, color: colorF1B008),
                              )
                                  : Border(
                                right: BorderSide(
                                    width: 0.5,
                                    color: Color(0xffA0A0A0)
                                        .withOpacity(0.50)),
                                bottom: BorderSide(
                                    width: 0.5,
                                    color: Color(0xffA0A0A0)
                                        .withOpacity(0.50)),
                                top: BorderSide(
                                    width: 0.5,
                                    color: Color(0xffA0A0A0)
                                        .withOpacity(0.50)),
                                left: BorderSide(
                                    width: 4, color: colorF1B008),
                              ),
                            ),
                            child: Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(right: 8,left: 46),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          muddaNewsController.acceptUserDetail.value =
                                          widget.postForMudda.userDetail!;
                                          if (widget.postForMudda.userDetail!.sId ==
                                              AppPreference()
                                                  .getString(PreferencesKey.userId)) {
                                            Get.toNamed(RouteConstants.profileScreen);
                                          } else if (widget.postForMudda.postAs ==
                                              "user") {
                                            Map<String, String>? parameters = {
                                              "userDetail": jsonEncode(
                                                  widget.postForMudda.userDetail!),
                                              "postAs": widget.postForMudda.postAs!
                                            };
                                            Get.toNamed(
                                                RouteConstants.otherUserProfileScreen,
                                                parameters: parameters);
                                          } else {
                                            anynymousDialogBox(context);
                                          }
                                        },
                                        child: Text(
                                            widget.postForMudda.postAs == "user"
                                                ? widget.postForMudda.userDetail!.fullname!
                                                : "Anynymous",
                                            style:  GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w700,
                                                fontSize: ScreenUtil().setSp(13),
                                                color: Color(0xff31393C))
                                        ),
                                      ),
                                      timeText(
                                        convertToAgo(
                                          DateTime.parse(widget.postForMudda.createdAt!),
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          reportPostDialogBox(
                                              context, widget.postForMudda.sId!);
                                        },
                                        child: const Icon(
                                          Icons.more_horiz,
                                          color: color606060,
                                          size: 22,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                if(widget.postForMudda.muddaDescription != null && widget.postForMudda.muddaDescription != '')  Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 46, top: 8,right: 8,bottom: widget.postForMudda.gallery != null && widget.postForMudda.gallery!.length >0? 0:8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                widget.postForMudda.muddaDescription!,
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                    ScreenUtil().setSp(14),
                                                    color: Color(0xff31393C)),
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
                                if(widget.postForMudda.gallery != null && widget.postForMudda.gallery!.length>0)   Padding(
                                  padding: const EdgeInsets.only(top: 0,left: 46,bottom: 8,right: 8),
                                  child: MuddaVideo(
                                    list: widget.postForMudda.gallery!,
                                    basePath: widget.muddaPath,
                                    width: ScreenUtil().setSp(242),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 0, right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                muddaNewsController.acceptUserDetail.value =
                                widget.postForMudda.userDetail!;
                                if (widget.postForMudda.userDetail!.sId ==
                                    AppPreference().getString(PreferencesKey.userId)) {
                                  Get.toNamed(RouteConstants.profileScreen);
                                } else if (widget.postForMudda.postAs == "user") {
                                  Map<String, String>? parameters = {
                                    "userDetail":
                                    jsonEncode(widget.postForMudda.userDetail!),
                                    "postAs": widget.postForMudda.postAs!
                                  };
                                  Get.toNamed(RouteConstants.otherUserProfileScreen,
                                      parameters: parameters);
                                } else {
                                  anynymousDialogBox(context);
                                }
                              },
                              child: widget.postForMudda.postAs == "user"
                                  ? widget.postForMudda.userDetail!.profile != null
                                  ? CachedNetworkImage(
                                imageUrl:
                                "${widget.muddaUserProfilePath}${widget.postForMudda.userDetail!.profile!}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: ScreenUtil().setSp(40),
                                      height: ScreenUtil().setSp(40),
                                      decoration: BoxDecoration(
                                        color: colorWhite,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
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
                                  child: Text(
                                      widget.postForMudda.userDetail!
                                          .fullname![0]
                                          .toUpperCase(),
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenUtil().setSp(20),
                                          color: black)),
                                ),
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
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenUtil().setSp(20),
                                          color: black)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4,left: 8),
                                child: Row(
                                  children: [

                                    if (widget.postForMudda.followStatus == true)...[
                                      Text('following',style: GoogleFonts.nunitoSans(
                                          fontStyle: FontStyle.italic,
                                          fontSize: ScreenUtil().setSp(10),
                                          color: black)),
                                      const Spacer(),
                                      if (widget.postForMudda.hotPost! > 0 ||
                                          widget.postForMudda.hotPost! <= 3)
                                        for (var x = 1;
                                        x <= widget.postForMudda.hotPost!;
                                        x++) ...[
                                          Padding(
                                            padding:
                                            const EdgeInsets.symmetric(horizontal: 2),
                                            child: SvgPicture.asset(
                                              AppIcons.hot,
                                              color: Color(0xFFF1B008),
                                            ),
                                          )
                                        ],
                                      if (widget.postForMudda.hotPost! > 3)
                                        for (var x = 1; x <= 3; x++) ...[
                                          Padding(
                                            padding:
                                            const EdgeInsets.symmetric(horizontal: 2),
                                            child: SvgPicture.asset(
                                              AppIcons.hot,
                                              color: Color(0xFFF1B008),
                                            ),
                                          )
                                        ],
                                    ],
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
    );
  }

  timeText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getSizedBox(w: 10),
        Text("$text, ", style: size12_M_normal(textColor: Colors.grey)),
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
