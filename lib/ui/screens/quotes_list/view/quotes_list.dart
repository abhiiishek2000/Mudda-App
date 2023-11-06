import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/utils/text_style.dart';

import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/model/QuotePostModel.dart';
import 'package:mudda/ui/screens/profile_screen/controller/profile_controller.dart';
import 'package:mudda/ui/shared/ReadMoreText.dart';
import 'package:mudda/ui/shared/report_post_dialog_box.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../../../const/const.dart';
import '../../../../core/preferences/preference_manager.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../../dio/api/api.dart';
import '../../../../model/UserRolesModel.dart';
import '../../../shared/get_started_button.dart';
import '../../../shared/trimmer_view.dart';
import '../../mudda/view/mudda_details_screen.dart';

class QuotesList extends StatelessWidget {
  ProfileController? profileController;
  final Trimmer _trimmer = Trimmer();
  int selectedIndex = 0;
  int rolePage = 1;
  ScrollController roleController = ScrollController();

  QuotesList(this.profileController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        children: List.generate(
          profileController!.quotePostListForProfile.length,
              (index) {
            Quote quote = profileController!.quotePostListForProfile.elementAt(index);
            return InkWell(
              onTap: () {
                if (quote.postOf == "quote") {
                  Get.toNamed(
                      RouteConstants.commentSections,
                      arguments: quote);
                } else {
                  Get.toNamed(
                      RouteConstants
                          .muddaPostCommentsScreen,
                      arguments: quote);
                }
              },
              child: Container(
                margin: EdgeInsets.only(
                    bottom: ScreenUtil().setSp(8)),
                padding: EdgeInsets.only(
                    bottom: ScreenUtil().setSp(8),
                    top: ScreenUtil().setSp(8)),
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setSp(12)),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              if (quote.user!.sId ==
                                  AppPreference()
                                      .getString(
                                      PreferencesKey
                                          .userId)) {
                                Get.toNamed(
                                    RouteConstants
                                        .profileScreen);
                              } else {
                                Map<String,
                                    String>? parameters = {
                                  "userDetail": jsonEncode(
                                      quote.user!)
                                };
                                Get.toNamed(
                                    RouteConstants
                                        .otherUserProfileScreen,
                                    parameters: parameters);
                              }
                            },
                            child: Column(
                              children: [
                                quote.user != null &&
                                    quote.user!.profile !=
                                        null
                                    ? CachedNetworkImage(
                                  imageUrl:
                                  "${profileController
                                      !.quoteProfilePath}${quote
                                      .user!.profile!}",
                                  imageBuilder: (context,
                                      imageProvider) =>
                                      Container(
                                        width: ScreenUtil()
                                            .setSp(40),
                                        height: ScreenUtil()
                                            .setSp(40),
                                        decoration:
                                        BoxDecoration(
                                          color: colorWhite,
                                          borderRadius: BorderRadius
                                              .all(
                                              Radius
                                                  .circular(
                                                  ScreenUtil()
                                                      .setSp(
                                                      20)) //                 <--- border radius here
                                          ),
                                          image: DecorationImage(
                                              image:
                                              imageProvider,
                                              fit:
                                              BoxFit
                                                  .cover),
                                        ),
                                      ),
                                  placeholder:
                                      (context, url) =>
                                      CircleAvatar(
                                        backgroundColor:
                                        lightGray,
                                        radius: ScreenUtil()
                                            .setSp(20),
                                      ),
                                  errorWidget: (context,
                                      url, error) =>
                                      CircleAvatar(
                                        backgroundColor:
                                        lightGray,
                                        radius: ScreenUtil()
                                            .setSp(20),
                                      ),
                                )
                                    : Container(
                                  height: ScreenUtil()
                                      .setSp(45),
                                  width: ScreenUtil()
                                      .setSp(45),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: darkGray,
                                    ),
                                    shape: BoxShape
                                        .circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                        quote.user !=
                                            null &&
                                            quote
                                                .user!
                                                .fullname!
                                                .isNotEmpty
                                            ? quote
                                            .user!
                                            .fullname![
                                        0]
                                            .toUpperCase()
                                            : "A",
                                        style: GoogleFonts
                                            .nunitoSans(
                                            fontWeight:
                                            FontWeight
                                                .w400,
                                            fontSize:
                                            ScreenUtil()
                                                .setSp(
                                                22.5),
                                            color: black)),
                                  ),
                                ),
                                getSizedBox(
                                    h: ScreenUtil().setSp(
                                        8)),
                                SvgPicture.asset(
                                    quote.postOf ==
                                        "quote"
                                        ? "assets/svg/quote.svg"
                                        : "assets/svg/activity.svg")
                              ],
                            ),
                          ),
                          getSizedBox(w: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                        children: [
                                          Text(
                                            quote.user !=
                                                null
                                                ? quote
                                                .user!
                                                .fullname!
                                                : "",
                                            style: size13_M_bold(
                                                textColor: Colors
                                                    .black87),
                                          ),
                                          getSizedBox(
                                              w: 5),
                                          const CircleAvatar(
                                            radius: 2,
                                            backgroundColor:
                                            Colors.black,
                                          ),
                                          getSizedBox(
                                              w: 5),
                                          Text(
                                            quote.user !=
                                                null
                                                ? quote
                                                .user!
                                                .username!
                                                : "",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontStyle:
                                                FontStyle
                                                    .italic),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                        WrapCrossAlignment
                                            .center,
                                      ),
                                    ),
                                    iconThreeDot(context,quote,index)
                                  ],
                                ),
                                quote.hashtags != null &&
                                    quote.hashtags!
                                        .isNotEmpty
                                    ? Text(
                                  quote.hashtags != null
                                      ? quote.hashtags!
                                      .join(",")
                                      : "",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontStyle:
                                      FontStyle.italic),
                                )
                                    : Container(),
                                getSizedBox(
                                    h: quote.hashtags !=
                                        null &&
                                        quote.hashtags!
                                            .isNotEmpty
                                        ? 5
                                        : 0),
                                quote.description !=
                                    null &&
                                    quote.description!
                                        .isNotEmpty &&
                                    quote.description!
                                        .length >
                                        6
                                    ? ReadMoreText(
                                  quote.description ??
                                      "",
                                  trimLines: 6,
                                  trimMode:
                                  TrimMode.Line,
                                  trimCollapsedText:
                                  'more',
                                  trimExpandedText:
                                  'less',
                                  style: GoogleFonts
                                      .nunitoSans(
                                      fontSize:
                                      ScreenUtil()
                                          .setSp(
                                          14),
                                      fontWeight:
                                      FontWeight
                                          .w400,
                                      color: black),
                                )
                                    : Text("${quote
                                    .description}",
                                    style: GoogleFonts
                                        .nunitoSans(
                                        fontSize:
                                        ScreenUtil()
                                            .setSp(
                                            14),
                                        fontWeight:
                                        FontWeight
                                            .w400,
                                        color: black)),
                                quote.postOf == "quote" &&
                                    quote.gallery!.length == 1
                                    ? const SizedBox(height: 8)
                                    : const SizedBox(),
                                if(quote.postOf == "quote" &&
                                    quote.gallery!.length == 1)
                                  InkWell(
                                    onTap: () {
                                      muddaGalleryDialog(
                                          context,
                                          quote
                                              .gallery!,
                                          profileController
                                              !.quotePostPath
                                              .value,
                                          index);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius
                                          .circular(4),
                                      child:
                                      CachedNetworkImage(
                                        height:
                                        ScreenUtil()
                                            .setSp(
                                            177),
                                        width:
                                        ScreenUtil()
                                            .screenWidth,
                                        imageUrl:
                                        "${profileController
                                            !.quotePostPath
                                            .value}${quote
                                            .gallery!
                                            .elementAt(0)
                                            .file!}",
                                        fit: BoxFit
                                            .cover,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                          getSizedBox(w: 12)
                        ],
                      ),
                    ),
                    quote.postOf == "quote" &&
                        quote.gallery!
                            .length > 1
                        ? SizedBox(
                      height: Get.height * 0.17,
                      child: ListView.builder(
                          scrollDirection:
                          Axis.horizontal,
                          itemCount:
                          quote.gallery!
                              .length,
                          padding: EdgeInsets
                              .only(
                              top: ScreenUtil()
                                  .setSp(8),
                              right: ScreenUtil()
                                  .setSp(10),
                              left: ScreenUtil()
                                  .setSp(60)),
                          itemBuilder:
                              (followersContext,
                              index) {
                            return Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                  right: 2),
                              child:
                              GestureDetector(
                                onTap: () {
                                  muddaGalleryDialog(
                                      context,
                                      quote
                                          .gallery!,
                                      profileController
                                          !.quotePostPath
                                          .value,
                                      index);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius
                                      .circular(4),
                                  child: CachedNetworkImage(
                                    height: Get.height * 0.17,
                                    width: Get.width * 0.3,
                                    imageUrl:
                                    "${profileController
                                        !.quotePostPath
                                        .value}${quote
                                        .gallery!
                                        .elementAt(
                                        index)
                                        .file!}",
                                    fit: BoxFit
                                        .cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                        : Container(),

                    getSizedBox(h: ScreenUtil().setSp(8)),
                    Padding(
                      padding: EdgeInsets.only(
                          right: ScreenUtil().setSp(12),
                          left: ScreenUtil().setSp(12)),
                      child: const Divider(
                        color: Colors.black87,
                        height: 1,
                      ),
                    ),
                    quote.postOf ==
                        "quote" ? Padding(
                      padding: const EdgeInsets.only(
                          left: 54, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Row(
                            children: [
                              // InkWell(
                              //   onTap: () {
                              //     Share.share(
                              //       '${Const
                              //           .shareUrl}${quote
                              //           .postOf}/${quote
                              //           .sId}',
                              //     );
                              //   },
                              //   child: Padding(
                              //     padding: const EdgeInsets
                              //         .all(10),
                              //     child: SvgPicture.asset(
                              //       "assets/svg/share.svg",
                              //     ),
                              //   ),
                              // ),
                              InkWell(
                                onTap: () {
                                  if (quote.amILiked !=
                                      null) {
                                    quote.likersCount =
                                        quote
                                            .likersCount! -
                                            1;
                                    quote.amILiked = null;
                                  } else {
                                    quote.likersCount =
                                        quote
                                            .likersCount! +
                                            1;
                                    AmILiked q = AmILiked();
                                    q.relativeId =
                                    quote.sId!;
                                    q.relativeType =
                                    "QuoteOrActivity";
                                    q.userId =
                                        AppPreference()
                                            .getString(
                                            PreferencesKey
                                                .interactUserId);
                                    quote.amILiked = q;
                                  }
                                  int pIndex = index;
                                  profileController
                                      !.quotePostListForProfile
                                      .removeAt(index);
                                  profileController
                                      !.quotePostListForProfile
                                      .insert(
                                      pIndex, quote);
                                  Api.post.call(
                                    context,
                                    method: "like/store",
                                    isLoading: false,
                                    param: {
                                      "user_id": AppPreference()
                                          .getString(
                                          PreferencesKey
                                              .interactUserId),
                                      "relative_id": quote
                                          .sId!,
                                      "relative_type":
                                      "QuoteOrActivity",
                                      "status": true,
                                    },
                                    onResponseSuccess: (object) {
                                      print(
                                          "Abhishek $object");
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/like.svg",
                                      color: quote
                                          .amILiked !=
                                          null
                                          ? themeColor
                                          : blackGray,
                                    ),
                                    getSizedBox(w: 5),
                                    Text(NumberFormat
                                        .compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(quote
                                        .likersCount),
                                        style: GoogleFonts
                                            .nunitoSans(
                                          fontWeight: quote
                                              .amILiked !=
                                              null
                                              ? FontWeight
                                              .w700
                                              : FontWeight
                                              .w400,
                                          fontSize: ScreenUtil()
                                              .setSp(
                                              12),
                                          color: quote
                                              .amILiked !=
                                              null
                                              ? themeColor
                                              : blackGray,
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets
                                    .all(10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons
                                          .reQuoteIcon,
                                    ),
                                    getSizedBox(w: 5),
                                    Text(NumberFormat
                                        .compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(
                                        quote.reQuote),
                                        style: GoogleFonts
                                            .nunitoSans(
                                          fontWeight: FontWeight
                                              .w400,
                                          fontSize: ScreenUtil()
                                              .setSp(12),
                                          color: blackGray,
                                        )),
                                  ],
                                ),
                              ),
                              getSizedBox(w: 5),
                              SvgPicture.asset(
                                "assets/svg/line.svg",
                              ),
                              InkWell(
                                onTap: () {
                                  profileController
                                      !.uploadPhotoVideos
                                      .value = [""];
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors
                                        .transparent,
                                    builder: (context) =>
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors
                                                .white,
                                            borderRadius: BorderRadius
                                                .only(
                                              topLeft: Radius
                                                  .circular(
                                                  16),
                                              topRight: Radius
                                                  .circular(
                                                  16),
                                            ),
                                          ),
                                          child: Wrap(
                                            crossAxisAlignment: WrapCrossAlignment
                                                .center,
                                            alignment: WrapAlignment
                                                .center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    top: 24,
                                                    bottom: 32),
                                                child: Wrap(
                                                  crossAxisAlignment: WrapCrossAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      "Create Re-Quote",
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                          fontSize: ScreenUtil()
                                                              .setSp(
                                                              16),
                                                          fontWeight: FontWeight
                                                              .w700,
                                                          color: black),
                                                    ),
                                                    getSizedBox(
                                                        w: 8),
                                                    SvgPicture
                                                        .asset(
                                                      AppIcons
                                                          .reQuoteIcon,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets
                                                    .symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setSp(
                                                        42)),
                                                child: Container(
                                                  height: getHeight(
                                                      160),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          8),
                                                      border: Border
                                                          .all(
                                                          color: Colors
                                                              .blue)),
                                                  child: TextFormField(
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          300),
                                                    ],
                                                    textInputAction: TextInputAction
                                                        .newline,
                                                    textCapitalization: TextCapitalization
                                                        .sentences,
                                                    keyboardType: TextInputType
                                                        .multiline,
                                                    maxLines: null,
                                                    onChanged: (
                                                        text) {
                                                      profileController
                                                          !.descriptionValue
                                                          .value =
                                                          text;
                                                    },
                                                    style: size14_M_normal(
                                                        textColor: color606060),
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15,
                                                          vertical: 10),
                                                      hintText: "Enter Text for the Quote",
                                                      border: InputBorder
                                                          .none,
                                                      hintStyle: size12_M_normal(
                                                          textColor: color606060),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Obx(
                                                    () =>
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 5),
                                                      child: Row(
                                                        children: [
                                                          const Spacer(),
                                                          Text(
                                                            "remain ${300 -
                                                                profileController
                                                                    !.descriptionValue
                                                                    .value
                                                                    .length} characters",
                                                            style: size10_M_normal(
                                                                textColor: colorGrey),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                              ),
                                              Container(
                                                height: 100,
                                                margin: const EdgeInsets
                                                    .only(
                                                    top: 20),
                                                child: Obx(
                                                      () =>
                                                      ListView
                                                          .builder(
                                                          scrollDirection: Axis
                                                              .horizontal,
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: ScreenUtil()
                                                                  .setSp(
                                                                  38)),
                                                          itemCount: profileController
                                                              !.uploadPhotoVideos
                                                              .length >
                                                              5
                                                              ? 5
                                                              : profileController
                                                              !.uploadPhotoVideos
                                                              .length,
                                                          itemBuilder: (
                                                              followersContext,
                                                              index) {
                                                            return Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  left: ScreenUtil()
                                                                      .setSp(
                                                                      4)),
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  if ((profileController
                                                                      !.uploadPhotoVideos
                                                                      .length -
                                                                      index) ==
                                                                      1) {
                                                                    uploadPic(
                                                                        context);
                                                                  } else {
                                                                    // muddaVideoDialog(
                                                                    //     context, profileController.uploadPhotoVideos);
                                                                  }
                                                                },
                                                                child: (profileController
                                                                    !.uploadPhotoVideos
                                                                    .length -
                                                                    index) ==
                                                                    1
                                                                    ? Container(
                                                                  height: 100,
                                                                  width: 100,
                                                                  child: const Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .camera_alt,
                                                                      size: 50,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border
                                                                          .all(
                                                                          color: Colors
                                                                              .grey)),
                                                                )
                                                                    : Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border
                                                                          .all(
                                                                          color: Colors
                                                                              .grey)),
                                                                  child: profileController
                                                                      !.uploadPhotoVideos
                                                                      .elementAt(
                                                                      index)
                                                                      .contains(
                                                                      "Trimmer")
                                                                      ? Stack(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: 100,
                                                                        width: 100,
                                                                        child: VideoViewer(
                                                                            trimmer: _trimmer),
                                                                      )
                                                                    ],
                                                                  )
                                                                      : Image
                                                                      .file(
                                                                    File(
                                                                        profileController
                                                                            !.uploadPhotoVideos
                                                                            .elementAt(
                                                                            index)),
                                                                    height: 100,
                                                                    width: 100,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                ),
                                              ),
                                              Obx(
                                                    () =>
                                                    Visibility(
                                                      visible: profileController
                                                          !.uploadQuoteRoleList
                                                          .isNotEmpty,
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20,
                                                            vertical: 10),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Post as: ",
                                                              style: GoogleFonts
                                                                  .nunitoSans(
                                                                  fontSize: ScreenUtil()
                                                                      .setSp(
                                                                      12),
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  color: blackGray),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                showRolesDialog(
                                                                    context);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  profileController
                                                                      !.selectedRole
                                                                      .value
                                                                      .user !=
                                                                      null
                                                                      ? profileController
                                                                      !.selectedRole
                                                                      .value
                                                                      .user!
                                                                      .profile !=
                                                                      null
                                                                      ? CachedNetworkImage(
                                                                    imageUrl:
                                                                    "${profileController
                                                                        !.roleProfilePath
                                                                        .value}${profileController
                                                                        !.selectedRole
                                                                        .value
                                                                        .user!
                                                                        .profile}",
                                                                    imageBuilder:
                                                                        (
                                                                        context,
                                                                        imageProvider) =>
                                                                        Container(
                                                                          width: ScreenUtil()
                                                                              .setSp(
                                                                              30),
                                                                          height: ScreenUtil()
                                                                              .setSp(
                                                                              30),
                                                                          decoration: BoxDecoration(
                                                                            color: colorWhite,
                                                                            border: Border
                                                                                .all(
                                                                              width: ScreenUtil()
                                                                                  .setSp(
                                                                                  1),
                                                                              color: buttonBlue,
                                                                            ),
                                                                            borderRadius: BorderRadius
                                                                                .all(
                                                                                Radius
                                                                                    .circular(
                                                                                    ScreenUtil()
                                                                                        .setSp(
                                                                                        15)) //                 <--- border radius here
                                                                            ),
                                                                            image: DecorationImage(
                                                                                image: imageProvider,
                                                                                fit: BoxFit
                                                                                    .cover),
                                                                          ),
                                                                        ),
                                                                    placeholder: (
                                                                        context,
                                                                        url) =>
                                                                        CircleAvatar(
                                                                          backgroundColor: lightGray,
                                                                          radius: ScreenUtil()
                                                                              .setSp(
                                                                              15),
                                                                        ),
                                                                    errorWidget: (
                                                                        context,
                                                                        url,
                                                                        error) =>
                                                                        CircleAvatar(
                                                                          backgroundColor: lightGray,
                                                                          radius: ScreenUtil()
                                                                              .setSp(
                                                                              15),
                                                                        ),
                                                                  )
                                                                      : Container(
                                                                    height: ScreenUtil()
                                                                        .setSp(
                                                                        30),
                                                                    width: ScreenUtil()
                                                                        .setSp(
                                                                        30),
                                                                    decoration: BoxDecoration(
                                                                      border: Border
                                                                          .all(
                                                                        color: darkGray,
                                                                      ),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                          profileController
                                                                              !.selectedRole
                                                                              .value
                                                                              .user!
                                                                              .fullname![0]
                                                                              .toUpperCase(),
                                                                          style: GoogleFonts
                                                                              .nunitoSans(
                                                                              fontWeight: FontWeight
                                                                                  .w400,
                                                                              fontSize:
                                                                              ScreenUtil()
                                                                                  .setSp(
                                                                                  16),
                                                                              color: black)),
                                                                    ),
                                                                  )
                                                                      : AppPreference()
                                                                      .getString(
                                                                      PreferencesKey
                                                                          .profile)
                                                                      .isNotEmpty
                                                                      ? CachedNetworkImage(
                                                                    imageUrl:
                                                                    "${AppPreference()
                                                                        .getString(
                                                                        PreferencesKey
                                                                            .profilePath)}${AppPreference()
                                                                        .getString(
                                                                        PreferencesKey
                                                                            .profile)}",
                                                                    imageBuilder:
                                                                        (
                                                                        context,
                                                                        imageProvider) =>
                                                                        Container(
                                                                          width: ScreenUtil()
                                                                              .setSp(
                                                                              30),
                                                                          height: ScreenUtil()
                                                                              .setSp(
                                                                              30),
                                                                          decoration: BoxDecoration(
                                                                            color: colorWhite,
                                                                            border: Border
                                                                                .all(
                                                                              width: ScreenUtil()
                                                                                  .setSp(
                                                                                  1),
                                                                              color: buttonBlue,
                                                                            ),
                                                                            borderRadius: BorderRadius
                                                                                .all(
                                                                                Radius
                                                                                    .circular(
                                                                                    ScreenUtil()
                                                                                        .setSp(
                                                                                        15)) //                 <--- border radius here
                                                                            ),
                                                                            image: DecorationImage(
                                                                                image: imageProvider,
                                                                                fit: BoxFit
                                                                                    .cover),
                                                                          ),
                                                                        ),
                                                                    placeholder: (
                                                                        context,
                                                                        url) =>
                                                                        CircleAvatar(
                                                                          backgroundColor: lightGray,
                                                                          radius: ScreenUtil()
                                                                              .setSp(
                                                                              15),
                                                                        ),
                                                                    errorWidget: (
                                                                        context,
                                                                        url,
                                                                        error) =>
                                                                        CircleAvatar(
                                                                          backgroundColor: lightGray,
                                                                          radius: ScreenUtil()
                                                                              .setSp(
                                                                              15),
                                                                        ),
                                                                  )
                                                                      : Container(
                                                                    height: ScreenUtil()
                                                                        .setSp(
                                                                        30),
                                                                    width: ScreenUtil()
                                                                        .setSp(
                                                                        30),
                                                                    decoration: BoxDecoration(
                                                                      border: Border
                                                                          .all(
                                                                        color: darkGray,
                                                                      ),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                          AppPreference()
                                                                              .getString(
                                                                              PreferencesKey
                                                                                  .fullName)[0]
                                                                              .toUpperCase(),
                                                                          style: GoogleFonts
                                                                              .nunitoSans(
                                                                              fontWeight: FontWeight
                                                                                  .w400,
                                                                              fontSize:
                                                                              ScreenUtil()
                                                                                  .setSp(
                                                                                  16),
                                                                              color: black)),
                                                                    ),
                                                                  ),
                                                                  getSizedBox(
                                                                      w: 6),
                                                                  Text(
                                                                      profileController
                                                                          !.selectedRole
                                                                          .value
                                                                          .user !=
                                                                          null
                                                                          ? profileController
                                                                          !.selectedRole
                                                                          .value
                                                                          .user!
                                                                          .fullname!
                                                                          : "Self",
                                                                      style: GoogleFonts
                                                                          .nunitoSans(
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontSize: ScreenUtil()
                                                                              .setSp(
                                                                              10),
                                                                          color: buttonBlue,
                                                                          fontStyle: FontStyle
                                                                              .italic)),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    top: 37),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    GetStartedButton(
                                                      onTap: () async {
                                                        AppPreference _appPreference = AppPreference();
                                                        FormData formData = FormData
                                                            .fromMap(
                                                            {
                                                              "description":
                                                              profileController
                                                                  !.descriptionValue
                                                                  .value,
                                                              "user_id": _appPreference
                                                                  .getString(
                                                                  PreferencesKey
                                                                      .interactUserId),
                                                              "parent_id": quote
                                                                  .sId!,
                                                              "post_of": "quote",
                                                            });
                                                        for (int i = 0;
                                                        i <
                                                            (profileController
                                                                !.uploadPhotoVideos
                                                                .length ==
                                                                5
                                                                ? 5
                                                                : (profileController
                                                                !.uploadPhotoVideos
                                                                .length -
                                                                1));
                                                        i++) {
                                                          formData
                                                              .files
                                                              .addAll(
                                                              [
                                                                MapEntry(
                                                                    "gallery",
                                                                    await MultipartFile
                                                                        .fromFile(
                                                                        profileController
                                                                            !.uploadPhotoVideos[i],
                                                                        filename: profileController
                                                                            !.uploadPhotoVideos[i]
                                                                            .split(
                                                                            '/')
                                                                            .last)),
                                                              ]);
                                                        }
                                                        Api
                                                            .uploadPost
                                                            .call(
                                                            context,
                                                            method: "quote-or-activity/store",
                                                            param: formData,
                                                            isLoading: true,
                                                            onResponseSuccess: (
                                                                Map object) {
                                                              print(
                                                                  object);
                                                              var snackBar = const SnackBar(
                                                                content: Text(
                                                                    'Uploaded'),
                                                              );
                                                              quote
                                                                  .reQuote =
                                                                  quote
                                                                      .reQuote! +
                                                                      1;
                                                              int pIndex = index;
                                                              profileController
                                                                  !.quotePostListForProfile
                                                                  .removeAt(
                                                                  index);
                                                              profileController
                                                                  !.quotePostListForProfile
                                                                  .insert(
                                                                  pIndex,
                                                                  quote);
                                                              ScaffoldMessenger
                                                                  .of(
                                                                  context)
                                                                  .showSnackBar(
                                                                  snackBar);
                                                              // profileController.postForMuddaList.insert(0,PostForMudda.fromJson(object['data']));
                                                              Get
                                                                  .back();
                                                            });
                                                      },
                                                      title: "Post",
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets
                                      .all(10),
                                  child: SvgPicture.asset(
                                    "assets/svg/edit_quote.svg",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 2,
                                backgroundColor: Colors
                                    .black,
                              ),
                              getSizedBox(w: 5),
                              Text(
                                  convertToAgo(
                                      DateTime.parse(
                                          quote
                                              .createdAt!)),
                                  style:
                                  GoogleFonts.nunitoSans(
                                      fontWeight:
                                      FontWeight.w400,
                                      fontSize:
                                      ScreenUtil()
                                          .setSp(12),
                                      color: blackGray)),
                            ],
                          )
                        ],
                      ),
                    ) : Container(),
                    Padding(
                      padding: EdgeInsets.only(
                          right: ScreenUtil().setSp(12),
                          left: ScreenUtil().setSp(12)),
                      child: const Divider(
                        color: Colors.black87,
                        height: 1,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

  }
  GestureDetector iconThreeDot(BuildContext context,Quote quote,int index) {
    return GestureDetector(
        onTap: () {
          if (quote.user!
              .sId ==
              AppPreference().getString(
                  PreferencesKey.userId)) {
            reportQuotePostDeleteDialogBox(context,quote)
                .then((value) {
                  profileController!.quotePostListForProfile.removeAt(index);
            });
          }else {
            reportQuotePostDialogBox(
                context, quote);
          }
        },
        child: const Icon(
            Icons
                .more_vert_outlined));
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

  _getRoles(BuildContext context) async {
    Api.get.call(context,
        method: "user/my-roles",
        param: {
          "page": rolePage.toString(),
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "interactModal": "QuoteOrActivity"
        },
        isLoading: true, onResponseSuccess: (Map object) {
          var result = UserRolesModel.fromJson(object);
          if (rolePage == 1) {
            profileController!.uploadQuoteRoleList.clear();
          }
          if (result.data!.isNotEmpty) {
            profileController!.roleProfilePath.value = result.path!;
            profileController!.uploadQuoteRoleList.addAll(result.data!);
            Role role = Role();
            role.user = User();
            role.user!.profile = AppPreference().getString(PreferencesKey.profile);
            role.user!.fullname = "Self";
            role.user!.sId = AppPreference().getString(PreferencesKey.userId);
            profileController!.uploadQuoteRoleList.add(role);
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
                    itemCount: profileController!.uploadQuoteRoleList.length,
                    itemBuilder: (followersContext, index) {
                      Role role = profileController!.uploadQuoteRoleList[index];
                      return InkWell(
                        onTap: () {
                          profileController!.selectedRole.value = role;
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
                                  "${profileController!.roleProfilePath}${role.user!.profile}",
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

  Future uploadPic(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    try {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _cropImage(File(pickedFile.path)).then((value) async {
                          profileController!.uploadPhotoVideos.insert(
                              profileController!.uploadPhotoVideos.length - 1,
                              value.path);
                        });
                      }
                      ;
                    } on PlatformException catch (e) {
                      print('FAILED $e');
                    }
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  try {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      _cropImage(File(pickedFile.path)).then((value) async {
                        profileController!.uploadPhotoVideos.insert(
                            profileController!.uploadPhotoVideos.length - 1,
                            value.path);
                      });
                    }
                  } on PlatformException catch (e) {
                    print('FAILED $e');
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Video Library'),
                  onTap: () async {
                    try {
                      Navigator.of(context).pop();
                      var result = await ImagePicker()
                          .pickVideo(source: ImageSource.gallery);
                      if (result != null) {
                        File file = File(result.path);
                        // print("ORG:::${_getVideoSize(file: file)}");
                        print(file.path);
                        var filePath = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrimmerView(file)));
                        if (filePath != null) {
                          File videoFile = File(filePath);
                          _trimmer.loadVideo(videoFile: videoFile);
                          profileController!.uploadPhotoVideos.insert(
                              profileController!.uploadPhotoVideos.length - 1,
                              filePath);
                          /*final MediaInfo? info =
                          await VideoCompress.compressVideo(
                            videoFile.path,
                            quality: VideoQuality.MediumQuality,
                            deleteOrigin: false,
                            includeAudio: true,
                          );
                          print(info!.path);
                          _trimmer.loadVideo(videoFile: File(info.path!));
                          profileController!.uploadPhotoVideos.add(info.path!);*/
                        }
                      }
                    } on PlatformException catch (e) {
                      print('FAILED $e');
                    }
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Video Camera'),
                onTap: () async {
                  try {
                    final video = await ImagePicker()
                        .pickVideo(source: ImageSource.camera);
                    if (video == null) return;
                    if (video != null) {
                      File file = File(video.path);
                      // print("ORG:::${_getVideoSize(file: file)}");
                      print(file.path);
                      var filePath = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrimmerView(file)));
                      if (filePath != null) {
                        var videoFile = File(filePath);
                        // print("TRIMM:::${_getVideoSize(file: videoFile)}");
                        // String  _desFile = await _destinationFile;
                        // print("DEST:::${_desFile}");
                        final MediaInfo? info =
                        await VideoCompress.compressVideo(
                          videoFile.path,
                          quality: VideoQuality.MediumQuality,
                          deleteOrigin: false,
                          includeAudio: true,
                        );
                        print(info!.path);
                        _trimmer.loadVideo(videoFile: videoFile);
                        profileController!.uploadPhotoVideos.insert(
                            profileController!.uploadPhotoVideos.length - 1,
                            info.path!);
                      }
                    }
                  } on PlatformException catch (e) {
                    print('FAILED $e');
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );

  }


  Future<File> _cropImage(File profileImageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: profileImageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          )
        ]);
    return File(croppedFile!.path);
  }

  postAnynymousDialogBox(String text) {
    return showDialog(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Text(text),
          ],
        );
      },
    );
  }
}
