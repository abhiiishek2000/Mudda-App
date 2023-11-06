
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/route_constants.dart';
import '../../../../core/preferences/preference_manager.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../../core/utils/color.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../model/PostForMuddaModel.dart';
import '../../../shared/report_post_dialog_box.dart';
import '../../home_screen/controller/mudda_fire_news_controller.dart';
import 'media_box.dart';

class FullParentPost extends StatefulWidget {
  
  PostForMuddaModelDataParentPost postForMudda;
  String muddaPath;
  String muddaUserProfilePath;
  FullParentPost(
      this.postForMudda,this.muddaPath,this.muddaUserProfilePath,
     {Key? key}) : super(key: key);

  @override
  State<FullParentPost> createState() => _FullParentPostState();
}

class _FullParentPostState extends State<FullParentPost> {
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  @override
  Widget build(BuildContext context) {
    return widget.postForMudda.postIn == 'favour' ? Stack(
      children: [
        Container(
          width: ScreenUtil().screenWidth,
          margin: EdgeInsets.only(bottom: 12,left: 24),
          child: Column(
            children: [
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 0, right: 44, left: 0),
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                      color: white,
                      border: Border(
                        left: BorderSide(
                            width: 0.5,
                            color: color0060FF.withOpacity(0.25)),
                        bottom: BorderSide(
                            width: 0.5,
                            color:color0060FF.withOpacity(0.25)),
                        top: BorderSide(
                            width: 0.5,
                            color: color0060FF.withOpacity(0.25)),
                        right:  BorderSide(
                            width: 2, color: color0060FF.withOpacity(0.25)),
                      ),
                    ),
                    child: Column(
                      children: [
                        if(widget.postForMudda.muddaDescription != null && widget.postForMudda.muddaDescription != '') Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin:  EdgeInsets.only(
                                    left: 8, top: 8,bottom: widget.postForMudda.gallery != null && widget.postForMudda.gallery!.length >0? 0: 8),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.postForMudda
                                            .muddaDescription!,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(15),
                                            color: const Color(0xff000000)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // JournalImageMatrix(
                        //   imageArr: ,
                        // ),
                        if(widget.postForMudda.gallery != null && widget.postForMudda.gallery!.length>0) Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 8, bottom: 8, right: 8),
                          child: MuddaVideo(
                            list: widget.postForMudda.gallery!,
                            basePath: widget.muddaPath,

                            width: ScreenUtil().setSp(242),
                          ),
                        ),
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: const Color(0xffF2F2F2),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 8, right: 8,bottom: 12),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppIcons.icReply,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        widget.postForMudda.replies ==
                                            null
                                            ? "-"
                                            : "${widget.postForMudda.replies}",
                                        style:
                                        size12_M_regular(
                                            textColor:
                                            black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
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
                                      ).format(widget.postForMudda
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
                              Row(
                                children: [
                                  Image.asset(
                                      widget.postForMudda.agreeStatus ==
                                          false
                                          ? AppIcons
                                          .dislikeFill
                                          : AppIcons.dislike,
                                      height: 16,
                                      width: 16,
                                      color: widget.postForMudda
                                          .agreeStatus ==
                                          false
                                          ?  colorF1B008
                                          : blackGray),
                                  const SizedBox(width: 5),
                                  widget.postForMudda.agreeStatus ==
                                      false
                                      ? Text(
                                    "${NumberFormat.compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(widget.postForMudda.dislikersCount)} Disagree",
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: widget.postForMudda
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
                                        color: widget.postForMudda
                                            .agreeStatus ==
                                            false
                                            ?
                                        colorF1B008
                                            : blackGray),
                                  )
                                      : Text(
                                    "${NumberFormat.compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(widget.postForMudda.dislikersCount)}",
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: widget.postForMudda
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
                                        color: widget.postForMudda
                                            .agreeStatus ==
                                            false
                                            ?
                                        colorF1B008
                                            : blackGray),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                      widget.postForMudda.agreeStatus ==
                                          true
                                          ? AppIcons
                                          .handIconFill
                                          : AppIcons.handIcon,
                                      height: 16,
                                      width: 16,
                                      color: widget.postForMudda
                                          .agreeStatus ==
                                          true
                                          ?  color0060FF
                                          : blackGray),
                                  const SizedBox(width: 5),
                                  widget.postForMudda.agreeStatus ==
                                      true
                                      ? Text(
                                    "${NumberFormat.compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(widget.postForMudda.likersCount)} Agree",
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: widget.postForMudda
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
                                        color: widget.postForMudda
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
                                        fontWeight: widget.postForMudda
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
                                        color: widget.postForMudda
                                            .agreeStatus ==
                                            true
                                            ?  color0060FF
                                            : blackGray),
                                  ),
                                ],
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
                      Expanded(
                        child: Row(
                          children: [
                            timeText(
                              convertToAgo(
                                DateTime.parse(
                                    widget.postForMudda.createdAt!),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                reportPostDialogBox(
                                    context, widget.postForMudda.Id!);
                              },
                              child: const Icon(
                                Icons.more_horiz,
                                color: color606060,
                                size: 22,
                              ),
                            ),
                         
                            const Spacer(),
                            if (widget.postForMudda.followStatus ==
                                true) ...[
                              Text('following -',
                                  style: GoogleFonts.nunitoSans(
                                      fontStyle: FontStyle.italic,
                                      fontSize: ScreenUtil().setSp(10),
                                      color: const Color(0xff31393C))),
                              const SizedBox(width: 10),
                            ],
                            InkWell(
                              onTap: () {
                                muddaNewsController
                                    .acceptUserDetail.value =
                                widget.postForMudda.user!;
                                if (widget
                                    .postForMudda.user!.sId ==
                                    AppPreference().getString(
                                        PreferencesKey.userId)) {
                                  Get.toNamed(
                                      RouteConstants.profileScreen);
                                } else if (widget.postForMudda.postAs == "user")
                                {
                                  Map<String, String>? parameters = {
                                    "userDetail": jsonEncode(widget
                                        .postForMudda.user!),
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
                                    ? widget.postForMudda.user!
                                    .fullname!
                                    : "Anonymous",
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: ScreenUtil().setSp(13),
                                    color: const Color(0xff31393C)),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: InkWell(
                          onTap: () {
                            muddaNewsController.acceptUserDetail.value =
                            widget.postForMudda.user!;
                            if (widget.postForMudda.user!.sId ==
                                AppPreference()
                                    .getString(PreferencesKey.userId)) {
                              Get.toNamed(RouteConstants.profileScreen);
                            } else if (widget.postForMudda.postAs == "user") {
                              Map<String, String>? parameters = {
                                "userDetail": jsonEncode(
                                    widget.postForMudda.user!),
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
                              ? widget.postForMudda.user!.profile !=
                              null
                              ? Stack(
                              children:
                              [
                                CachedNetworkImage(
                                  imageUrl:
                                  "${widget.muddaUserProfilePath}${widget.postForMudda.user!.profile!}",
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
                            child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                        widget.postForMudda.user!
                                            .fullname![0]
                                            .toUpperCase(),
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                            ScreenUtil().setSp(20),
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
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(20),
                                      color: black)),
                            ),
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
    ) :  Stack(
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

              Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 0, right: 0, left: 44),
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                      color: white,
                      border:  Border(
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
                            width: 2,
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
                                              FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(15),
                                              color: const Color(0xff000000)),
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
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 12),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppIcons.icReply,
                                      ),
                                      SizedBox(width: 5),
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
                                          .value

                                  ),
                                ],
                              ),
                              Row(
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
                                      ).format(widget.postForMudda
                                          .commentorsCount),
                                      style:
                                      GoogleFonts.nunitoSans(
                                          fontWeight:
                                          FontWeight.w400,
                                          fontSize:
                                          ScreenUtil()
                                              .setSp(12),
                                          color: blackGray)),
                                ],
                              ),
                              Row(
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
                                            .setSp(12),
                                        color: widget
                                            .postForMudda
                                            .agreeStatus ==
                                            false
                                            ? colorF1B008
                                            : blackGray),
                                  )
                                      : Text(
                                    NumberFormat
                                        .compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(widget
                                        .postForMudda
                                        .dislikersCount),
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
                                            .setSp(12),
                                        color: widget
                                            .postForMudda
                                            .agreeStatus ==
                                            false
                                            ? colorF1B008
                                            : blackGray),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                      widget.postForMudda
                                          .agreeStatus ==
                                          true
                                          ? AppIcons.handIconFill
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
                                            .setSp(12),
                                        color: widget
                                            .postForMudda
                                            .agreeStatus ==
                                            true
                                            ? color0060FF
                                            : blackGray),
                                  )
                                      : Text(
                                    NumberFormat
                                        .compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(widget
                                        .postForMudda
                                        .likersCount),
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
                                            .setSp(12),
                                        color: widget
                                            .postForMudda
                                            .agreeStatus ==
                                            true
                                            ? color0060FF
                                            : blackGray),
                                  ),
                                ],
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
                            widget.postForMudda.user!;
                            if (widget.postForMudda.user!.sId ==
                                AppPreference().getString(
                                    PreferencesKey.userId)) {
                              Get.toNamed(
                                  RouteConstants.profileScreen);
                            } else if (widget.postForMudda.postAs ==
                                "user") {
                              Map<String, String>? parameters = {
                                "userDetail": jsonEncode(
                                    widget.postForMudda.user!),
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
                              ? widget.postForMudda.user!
                              .profile !=
                              null
                              ? Stack(children: [
                            CachedNetworkImage(
                              imageUrl:
                              "${widget.muddaUserProfilePath}${widget.postForMudda.user!.profile!}",
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
                                        .user!
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
                                  widget.postForMudda.user!;
                                  if (widget.postForMudda.user!
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
                                          .postForMudda.user!),
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
                                      .user!.fullname!
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

                              InkWell(
                                onTap: () {
                                  reportPostDialogBox(context,
                                      widget.postForMudda.Id!);
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
    );
  }
  timeText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getSizedBox(w: 10),
        Text("$text, ", style: GoogleFonts.nunitoSans(
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



