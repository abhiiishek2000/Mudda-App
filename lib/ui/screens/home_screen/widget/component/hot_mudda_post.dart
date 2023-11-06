import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mudda/ui/shared/create_dynamic_link.dart';
import 'package:mudda/ui/shared/flip_car_widget.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../const/const.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_icons.dart';
import '../../../../../core/constant/route_constants.dart';
import '../../../../../core/preferences/preference_manager.dart';
import '../../../../../core/preferences/preferences_key.dart';
import '../../../../../core/utils/color.dart';
import '../../../../../core/utils/constant_string.dart';
import '../../../../../core/utils/size_config.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../../dio/api/api.dart';
import '../../../../../model/MuddaPostModel.dart';
import '../../../../../model/PlaceModel.dart';
import '../../../../../model/PostForMuddaModel.dart';
import '../../../../../model/UserProfileModel.dart';
import '../../../../shared/ReadMoreText.dart';
import '../../../../shared/VideoPlayerScreen.dart';
import '../../../../shared/report_post_dialog_box.dart';
import '../../../../shared/spacing_widget.dart';
import '../../../../shared/text_field_widget.dart';
import '../../../edit_profile/controller/user_profile_update_controller.dart';
import '../../../edit_profile/view/user_profile_update_screen.dart';
import '../../../leader_board/controller/LeaderBoardApprovalController.dart';
import '../../../leader_board/view/leader_board_approval_screen.dart';
import '../../../mudda/view/mudda_details_screen.dart';
import '../../../sign_up_screen/controller/sign_up_controller.dart';
import '../../controller/mudda_fire_news_controller.dart';
import '../show_case_widget.dart';

class HotMuddaPost extends StatefulWidget {
  HotMuddaPost(
      {Key? key,
      required this.muddaPost,
      required this.index,
      this.muddaCreator = 0,
      this.muddaLeader = 0,
      this.muddaInitialLeader = 0,
      this.muddaOpposition = 0})
      : super(key: key);
  MuddaPost muddaPost;
  int index;
  int muddaCreator = 0;
  int muddaLeader = 0;
  int muddaInitialLeader = 0;
  int muddaOpposition = 0;

  @override
  State<HotMuddaPost> createState() => _HotMuddaPostState();
}

class _HotMuddaPostState extends State<HotMuddaPost> {
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  LeaderBoardApprovalController leaderBoardApprovalController =
      Get.put(LeaderBoardApprovalController());
  VideoController videoController = VideoController();
  bool isOnPageHorizontalTurning = false;
  late bool _showFrontSide;
  late bool _flipXAxis;
  final _cardColumnSizeKey = GlobalKey();

  Size? size;

  getCardColumnHeight() {
    setState(() {
      size = Size(_cardColumnSizeKey.currentContext!.size!.width,
          _cardColumnSizeKey.currentContext!.size!.height);
    });
  }

  @override
  void initState() {
    _showFrontSide = true;
    _flipXAxis = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => getCardColumnHeight());
    super.initState();
  }

  void _switchCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: math.pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget!.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder
            ? math.min(rotateAnim.value, math.pi / 2)
            : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: __transitionBuilder,
      layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
      child: _showFrontSide
          ? buildMuddaCardFrontSide(context)
          : buildMuddaCardBackSide(),
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeInBack.flipped,
    );
  }

  Widget buildMuddaCardBackSide() {
    if (size == null) {
      return Container(
        height: MediaQuery.of(context).size.height / 4 * 2,
        margin: EdgeInsets.only(
          left: ScreenUtil().setSp(10),
          right: ScreenUtil().setSp(10),
          bottom: ScreenUtil().setSp(32),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(10),
          vertical: ScreenUtil().setSp(12),
        ),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.muddaPost.hashtags != null
                  ? Wrap(
                      children: widget.muddaPost.hashtags!
                          .map<Widget>((e) => Text(
                                '#$e, ',
                                style: const TextStyle(fontSize: 10),
                              ))
                          .toList(),
                    )
                  : const SizedBox.shrink(),
              InkWell(
                onTap: () {
                  if (AppPreference().getBool(PreferencesKey.isGuest)) {
                    updateProfileDialog(context);
                  } else {
                    Api.post.call(
                      context,
                      method: "mudda/reaction-on-mudda",
                      param: {
                        "user_id": AppPreference()
                            .getString(PreferencesKey.interactUserId),
                        "joining_content_id": widget.muddaPost.sId,
                        "action_type": "follow",
                      },
                      onResponseSuccess: (object) {
                        widget.muddaPost.afterMe = object['data'] != null
                            ? AfterMe.fromJson(object['data'])
                            : null;
                        widget.muddaPost.amIfollowing =
                            widget.muddaPost.amIfollowing == 1 ? 0 : 1;
                        muddaNewsController.muddaPostList[widget.index] =
                            widget.muddaPost;
                        muddaNewsController.muddaActionIndex.value =
                            widget.index;
                      },
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFf2f2f2),
                      borderRadius: BorderRadius.circular(4)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                      widget.muddaPost.amIfollowing == 0
                          ? "Follow"
                          : "Following",
                      style: size12_M_normal(textColor: colorDarkBlack)),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: colorDarkBlack),
                  ),
                  const Hs(width: 4),
                  widget.muddaPost.audienceAge != null
                      ? Text(widget.muddaPost.audienceAge!,
                          style: size10_M_normal(textColor: colorDarkBlack))
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
          const Vs(height: 10),
          widget.muddaPost.gallery!.isEmpty
              ? Text(
                  'Description: ${widget.muddaPost.muddaDescription.toString().trim()}',
                  style: GoogleFonts.nunitoSans(
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.w400,
                      color: black),
                )
              : ReadMoreText(
                  'Description: ${widget.muddaPost.muddaDescription}',
                  trimLines: 6,
                  trimMode: TrimMode.Line,
                  style: GoogleFonts.nunitoSans(
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.w400,
                      color: black),
                ),
          // RichText(
          //   text: TextSpan(
          //     style: const TextStyle(color: colorDarkBlack, fontSize: 13),
          //     children: <TextSpan>[
          //       Text('Description: ', style: GoogleFonts.nunitoSans(
          //           fontSize: ScreenUtil().setSp(12),
          //           fontWeight: FontWeight.bold,
          //           color: black),),
          //       TextSpan(
          //         text: 'Description: ',
          //         style: GoogleFonts.nunitoSans(
          //           fontWeight: FontWeight.w700,
          //           fontSize: ScreenUtil().setSp(13),
          //         ), // TextStyle(fontWeight: FontWeight.bold),
          //       ), ReadMoreText(
          //         ' ${widget.muddaPost.muddaDescription}',
          //         trimLines: 5,
          //         trimMode: TrimMode.Line,
          //         style: GoogleFonts.nunitoSans(
          //             fontSize: ScreenUtil().setSp(12),
          //             fontWeight: FontWeight.w400,
          //             color: black),
          //       ),
          //
          //       TextSpan(
          //         text: widget.muddaPost.muddaDescription!,
          //         style: GoogleFonts.nunitoSans(
          //           // fontWeight: FontWeight.w700,
          //           fontSize: ScreenUtil().setSp(13),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          widget.muddaPost.gallery!.isEmpty
              ? const SizedBox.shrink()
              : const Divider(),
          widget.muddaPost.gallery!.isEmpty
              ? const SizedBox.shrink()
              : SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.muddaPost.gallery!.length,
                    itemBuilder: (context, index) {
                      Gallery mediaModelData = widget.muddaPost.gallery![index];

                      return GestureDetector(
                        onTap: () {
                          print("muddaPost.gallery ");
                          print(widget.muddaPost.thumbnail);
                          print(widget.muddaPost.gallery?.length);
                          List<Gallery> list = <Gallery>[];

                          list.add(Gallery(file: widget.muddaPost.thumbnail));
                          list.addAll(widget.muddaPost.gallery!);
                          print(list.length);
                          widget.muddaPost.gallery != null
                              ? muddaGalleryDialog(
                                  context,
                                  list,
                                  muddaNewsController.muddaProfilePath.value,
                                  index + 1)
                              : null;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Container(
                            height: 100,
                            width: 100,
                            // color: Colors.grey,
                            child: !mediaModelData.file!.contains(".mp4")
                                ? CachedNetworkImage(
                                    // imageBuilder: (context, imageProvider) =>
                                    //     Container(
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.all(
                                    //         Radius.circular(
                                    //             ScreenUtil().setSp(8))),
                                    //     image: DecorationImage(
                                    //         image: imageProvider,
                                    //         fit: BoxFit.cover),
                                    //   ),
                                    // ),
                                    imageUrl:
                                        '${muddaNewsController.muddaProfilePath.value}${mediaModelData.file!}',
                                    fit: BoxFit.cover)
                                : GestureDetector(
                                    onTap: () {
                                      /*setStates(() {
                                      isDialOpen.value = false;
                                      if (visibilityTag) {
                                        visibilityTag = false;
                                      }
                                      hideShowTag = !hideShowTag;
                                    });*/
                                    },
                                    child: VideoPlayerScreen(
                                        mediaModelData.file!,
                                        muddaNewsController
                                            .muddaProfilePath.value,
                                        index,
                                        index,
                                        0,
                                        0,
                                        true,
                                        videoController,
                                        isOnPageHorizontalTurning),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          const Divider(),
          const Spacer(),
          Center(
            child: InkWell(
              onTap: () {
                _switchCard();
              },
              child: SvgPicture.asset(AppIcons.flipCard, width: 10, height: 10),
            ),
          ),
        ]),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(
          left: ScreenUtil().setSp(10),
          right: ScreenUtil().setSp(10),
          bottom: ScreenUtil().setSp(32),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(10),
          vertical: ScreenUtil().setSp(12),
        ),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
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
        child: SizedBox(
          height: size!.height,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //location
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcons.icLocation, width: 9, height: 12),
                    const Hs(width: 4),
                    Text(
                        "${widget.muddaPost.city ?? ""}, ${widget.muddaPost.state ?? ""}, ${widget.muddaPost.country ?? ""}",
                        style: size12_M_normal(textColor: colorDarkBlack)),
                  ],
                ),
                InkWell(
                  onTap: () {
                    if (AppPreference().getBool(PreferencesKey.isGuest)) {
                      updateProfileDialog(context);
                    } else {
                      Api.post.call(
                        context,
                        method: "mudda/reaction-on-mudda",
                        param: {
                          "user_id": AppPreference()
                              .getString(PreferencesKey.interactUserId),
                          "joining_content_id": widget.muddaPost.sId,
                          "action_type": "follow",
                        },
                        onResponseSuccess: (object) {
                          widget.muddaPost.afterMe = object['data'] != null
                              ? AfterMe.fromJson(object['data'])
                              : null;
                          widget.muddaPost.amIfollowing =
                              widget.muddaPost.amIfollowing == 1 ? 0 : 1;
                          muddaNewsController.muddaPostList[widget.index] =
                              widget.muddaPost;
                          muddaNewsController.muddaActionIndex.value =
                              widget.index;
                        },
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFf2f2f2),
                        borderRadius: BorderRadius.circular(4)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                        widget.muddaPost.amIfollowing == 0
                            ? "Follow"
                            : "Following",
                        style: size12_M_normal(textColor: colorDarkBlack)),
                  ),
                ),
              ],
            ),
            const Vs(height: 6),
            Expanded(
              child: SingleChildScrollView(
                child: Text.rich(TextSpan(
                    text: 'Description: ',
                    style: GoogleFonts.nunitoSans(
                        fontSize: ScreenUtil().setSp(14),
                        fontWeight: FontWeight.w700,
                        color: black),
                    children: <InlineSpan>[
                      TextSpan(
                        text:
                            widget.muddaPost.muddaDescription.toString().trim(),
                        style: GoogleFonts.nunitoSans(
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.w400,
                            color: black),
                      )
                    ])),
                // Text(
                //   'Description: ${widget.muddaPost.muddaDescription.toString().trim()}',
                //   style: GoogleFonts.nunitoSans(
                //       fontSize: ScreenUtil().setSp(12),
                //       fontWeight: FontWeight.w400,
                //       color: black),
                // ),
              ),
            ),
            widget.muddaPost.gallery!.isEmpty
                ? const SizedBox.shrink()
                : const Divider(),
            widget.muddaPost.gallery!.isEmpty
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.muddaPost.gallery!.length,
                      itemBuilder: (context, index) {
                        Gallery mediaModelData =
                            widget.muddaPost.gallery![index];

                        return GestureDetector(
                          onTap: () {
                            print("muddaPost.gallery ");
                            print(widget.muddaPost.thumbnail);
                            print(widget.muddaPost.gallery?.length);
                            List<Gallery> list = <Gallery>[];

                            list.add(Gallery(file: widget.muddaPost.thumbnail));
                            list.addAll(widget.muddaPost.gallery!);
                            print(list.length);
                            widget.muddaPost.gallery != null
                                ? muddaGalleryDialog(
                                    context,
                                    list,
                                    muddaNewsController.muddaProfilePath.value,
                                    index + 1)
                                : null;
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Container(
                              height: 100,
                              width: 100,
                              // color: Colors.grey,
                              child: !mediaModelData.file!.contains(".mp4")
                                  ? CachedNetworkImage(
                                      // imageBuilder: (context, imageProvider) =>
                                      //     Container(
                                      //   decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.all(
                                      //         Radius.circular(
                                      //             ScreenUtil().setSp(8))),
                                      //     image: DecorationImage(
                                      //         image: imageProvider,
                                      //         fit: BoxFit.cover),
                                      //   ),
                                      // ),
                                      imageUrl:
                                          '${muddaNewsController.muddaProfilePath.value}${mediaModelData.file!}',
                                      fit: BoxFit.cover)
                                  : GestureDetector(
                                      onTap: () {
                                        /*setStates(() {
                                        isDialOpen.value = false;
                                        if (visibilityTag) {
                                          visibilityTag = false;
                                        }
                                        hideShowTag = !hideShowTag;
                                      });*/
                                      },
                                      child: VideoPlayerScreen(
                                          mediaModelData.file!,
                                          muddaNewsController
                                              .muddaProfilePath.value,
                                          index,
                                          index,
                                          0,
                                          0,
                                          true,
                                          videoController,
                                          isOnPageHorizontalTurning),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            widget.muddaPost.gallery!.isEmpty
                ? const SizedBox.shrink()
                : const Divider(),
            InkWell(
              onTap: () => _switchCard(),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: widget.muddaPost.hashtags != null
                        ? Wrap(
                            children: widget.muddaPost.hashtags!
                                .map<Widget>((e) => Text(
                                      '#$e, ',
                                      style: const TextStyle(fontSize: 10),
                                    ))
                                .toList(),
                          )
                        : const SizedBox.shrink(),
                  ),
                  SvgPicture.asset(AppIcons.flipCard, width: 10, height: 10),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorDarkBlack),
                        ),
                        const Hs(width: 4),
                        widget.muddaPost.audienceAge != null
                            ? Text(widget.muddaPost.audienceAge!,
                                style:
                                    size10_M_normal(textColor: colorDarkBlack))
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      );
    }
  }

  Widget buildMuddaCardFrontSide(BuildContext context) {
    return GestureDetector(
      onTap: () {
        muddaNewsController.openForm();
        muddaNewsController.muddaPost.value = widget.muddaPost;
        muddaNewsController.muddaActionIndex.value = widget.index;
        Get.toNamed(RouteConstants.muddaDetailsScreen);
      },
      child: Container(
        // alignment: Alignment.center,
        // height: MediaQuery.of(context).size.height / 4 * 2,
        margin: EdgeInsets.only(
          left: ScreenUtil().setSp(10),
          right: ScreenUtil().setSp(10),
          bottom: ScreenUtil().setSp(32),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(10),
          vertical: ScreenUtil().setSp(12),
        ),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
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
          key: _cardColumnSizeKey,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.muddaPost.thumbnail != null
                      ? GestureDetector(
                          onTap: () {
                            print("muddaPost.gallery 3");
                            print(widget.muddaPost.thumbnail);
                            print(widget.muddaPost.gallery?.length);
                            List<Gallery> list = <Gallery>[];

                            list.add(Gallery(file: widget.muddaPost.thumbnail));
                            list.addAll(widget.muddaPost.gallery!);
                            print(list.length);
                            widget.muddaPost.gallery != null
                                ? muddaGalleryDialog(
                                    context,
                                    list,
                                    muddaNewsController.muddaProfilePath.value,
                                    0)
                                : null;
                          },
                          child: Container(
                            height: ScreenUtil().setSp(80),
                            width: ScreenUtil().setSp(80),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius:
                                  BorderRadius.circular(ScreenUtil().setSp(8)),
                              border: Border.all(color: white, width: 1),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 3,
                                    offset: Offset(0, 4))
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(ScreenUtil().setSp(8)),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${muddaNewsController.muddaProfilePath.value}${widget.muddaPost.thumbnail}",
                                fit: BoxFit.cover,
                                color: Colors.black.withOpacity(0.50),
                                colorBlendMode: BlendMode.softLight,
                              ),
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setSp(8)),
                          child: Container(
                            color: white,
                            height: ScreenUtil().setSp(80),
                            width: ScreenUtil().setSp(80),
                            child: Text(
                                widget.muddaPost.title![0].toUpperCase(),
                                style:
                                    size12_M_normal(textColor: Colors.black)),
                          ),
                        ),
                  SizedBox(
                    width: ScreenUtil().setSp(8),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.muddaPost.title.toString().trim(),
                          style: GoogleFonts.nunitoSans(
                              fontSize: ScreenUtil().setSp(18),
                              fontWeight: FontWeight.w700,
                              color: black),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          // mainAxisSize: MainAxisSize.max,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.muddaPost.initialScope != null)
                              Text(
                                widget.muddaPost.initialScope!.toLowerCase() ==
                                        "district"
                                    ? "[ ${widget.muddaPost.city!.capitalize!} ]"
                                    : widget.muddaPost.initialScope!
                                                .toLowerCase() ==
                                            "state"
                                        ? "[ ${widget.muddaPost.state!.capitalize!} ]"
                                        : widget.muddaPost.initialScope!
                                                    .toLowerCase() ==
                                                "country"
                                            ? "[ ${widget.muddaPost.country!.capitalize!} ]"
                                            : "[ ${widget.muddaPost.initialScope!.capitalize!} ]",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: ScreenUtil().setSp(12),
                                    fontWeight: FontWeight.w700,
                                    color: black),
                              ),
                            const Spacer(),
                            if (widget.muddaPost.support != null)
                              Row(
                                children: [
                                  Image.asset(
                                    AppIcons.bluehandsheck,
                                    height: 12,
                                    width: 20,
                                  ),
                                  const Hs(
                                    width: 4,
                                  ),
                                  Text(
                                    "${widget.muddaPost.support != 0 ? ((widget.muddaPost.support! * 100) / widget.muddaPost.totalVote!).toStringAsFixed(2) : 0}% / ${NumberFormat.compactCurrency(
                                      decimalDigits: 0,
                                      symbol:
                                          '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(widget.muddaPost.support)}",
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: ScreenUtil().setSp(14),
                                        fontWeight: FontWeight.w700,
                                        color: color0060FF),
                                    // size12_M_bold(textColor: color0060FF)
                                    //     .copyWith(height: 1.8)
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Vs(height: 24),
            Container(
              height: ScreenUtil().setSp(78),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, int index) {
                            if (index == 4) {
                              return InkWell(
                                onTap: () {
                                  if (widget.muddaPost.leaders![0]
                                              .acceptUserDetail!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.userId) ||
                                      widget.muddaPost.leaders![0]
                                              .acceptUserDetail!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.orgUserId)) {
                                    muddaNewsController.muddaPost.value =
                                        widget.muddaPost;
                                    muddaNewsController.leaderBoardIndex.value =
                                        0;
                                    Get.toNamed(
                                        RouteConstants.leaderBoardApproval,
                                        arguments: widget.muddaPost);
                                  } else {
                                    Get.toNamed(RouteConstants.leaderBoard,
                                        arguments: widget.muddaPost);
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SvgPicture.asset(
                                          AppIcons.plusMuddaCardIcon),
                                    ),
                                    const Hs(width: 6),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        widget.muddaPost.leaders != null
                                            // ? "${muddaPost.leadersCount! - 4}"
                                            ? widget.muddaPost.leaders!.length <
                                                    4
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('0',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  colorDarkBlack)),
                                                      Text("Leaders",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          13),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  colorDarkBlack)),
                                                    ],
                                                  )
                                                : Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          '${widget.muddaPost.leadersCount != null && (widget.muddaPost.leadersCount)! >= 4 ? widget.muddaPost.leadersCount! - 4 : 0}',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  colorDarkBlack)),
                                                      Text("Leaders",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          13),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  colorDarkBlack)),
                                                    ],
                                                  )
                                            : const Text(''),
                                        Vs(
                                          height: 5.h,
                                        ),
                                        Image.asset(
                                          AppIcons.nextLongArrow,
                                          height: 7,
                                          width: 15,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            } else if (widget.muddaPost.leaders!.length ==
                                index) {
                              return InkWell(
                                onTap: () {
                                  if (widget.muddaPost.leaders![0]
                                              .acceptUserDetail!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.userId) ||
                                      widget.muddaPost.leaders![0]
                                              .acceptUserDetail!.sId ==
                                          AppPreference().getString(
                                              PreferencesKey.orgUserId)) {
                                    muddaNewsController.muddaPost.value =
                                        widget.muddaPost;
                                    muddaNewsController.leaderBoardIndex.value =
                                        0;
                                    Get.toNamed(
                                        RouteConstants.leaderBoardApproval,
                                        arguments: widget.muddaPost);
                                  } else {
                                    Get.toNamed(RouteConstants.leaderBoard,
                                        arguments: widget.muddaPost);
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SvgPicture.asset(
                                          AppIcons.plusMuddaCardIcon),
                                    ),
                                    const Hs(width: 11),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        widget.muddaPost.leaders != null
                                            // ? "${muddaPost.leadersCount! - 4}"
                                            ? widget.muddaPost.leaders!.length <
                                                    4
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('0',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  colorDarkBlack)),
                                                      Text("Leaders",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          13),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  colorDarkBlack)),
                                                    ],
                                                  )
                                                : Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          '${widget.muddaPost.leadersCount != null && (widget.muddaPost.leadersCount)! >= 4 ? widget.muddaPost.leadersCount! - 4 : 0}',
                                                          style: GoogleFonts.nunitoSans(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  colorDarkBlack)),
                                                      Text("Leaders",
                                                          style: GoogleFonts.nunitoSans(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          13),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  colorDarkBlack)),
                                                    ],
                                                  )
                                            : const Text(''),
                                        Vs(
                                          height: 5.h,
                                        ),
                                        Image.asset(
                                          AppIcons.nextLongArrow,
                                          height: 7,
                                          width: 15,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            } else {
                              String path =
                                  "${muddaNewsController.muddaUserProfilePath.value}${widget.muddaPost.leaders![index].acceptUserDetail!.profile ?? ""}";
                              return GestureDetector(
                                onTap: () {
                                  if (widget.muddaPost.leaders![index]
                                          .userIdentity ==
                                      1) {
                                    muddaNewsController.acceptUserDetail.value =
                                        widget.muddaPost.leaders![index]
                                            .acceptUserDetail!;
                                    if (widget.muddaPost.leaders![index]
                                            .acceptUserDetail!.sId ==
                                        AppPreference()
                                            .getString(PreferencesKey.userId)) {
                                      Get.toNamed(RouteConstants.profileScreen);
                                    } else {
                                      Map<String, String>? parameters = {
                                        "userDetail": jsonEncode(widget
                                            .muddaPost
                                            .leaders![index]
                                            .acceptUserDetail!)
                                      };
                                      Get.toNamed(
                                          RouteConstants.otherUserProfileScreen,
                                          parameters: parameters);
                                    }
                                  } else {
                                    anynymousDialogBox(context);
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    widget.muddaPost.leaders![index]
                                                .userIdentity ==
                                            0
                                        ? Container(
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: ScreenUtil()
                                                          .setSp(20),
                                                      color: black)),
                                            ),
                                          )
                                        : widget
                                                    .muddaPost
                                                    .leaders![index]
                                                    .acceptUserDetail!
                                                    .profile !=
                                                null
                                            ? Stack(children: [
                                                CachedNetworkImage(
                                                  imageUrl: path,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width:
                                                        ScreenUtil().setSp(40),
                                                    height:
                                                        ScreenUtil().setSp(40),
                                                    decoration: BoxDecoration(
                                                      color: colorWhite,
                                                      border: Border.all(
                                                        width: ScreenUtil()
                                                            .setSp(1),
                                                        color: widget
                                                                    .muddaPost
                                                                    .leaders![
                                                                        index]
                                                                    .joinerType! ==
                                                                "creator"
                                                            ? buttonBlue
                                                            : widget
                                                                        .muddaPost
                                                                        .leaders![
                                                                            index]
                                                                        .joinerType! ==
                                                                    "opposition"
                                                                ? buttonYellow
                                                                : white,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(
                                                              ScreenUtil().setSp(
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
                                                    radius:
                                                        ScreenUtil().setSp(20),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          CircleAvatar(
                                                    backgroundColor: lightGray,
                                                    radius:
                                                        ScreenUtil().setSp(20),
                                                  ),
                                                ),
                                                // Positioned(
                                                //   bottom: 0,
                                                //   right: 0,
                                                //   child: Visibility(
                                                //     visible: muddaPost
                                                //         .leaders![
                                                //     index]
                                                //         .acceptUserDetail!
                                                //         .isProfileVerified==1,
                                                //     child: Image.asset(
                                                //       AppIcons.verifyProfile,
                                                //       width: 18,
                                                //       height: 18,
                                                //       color: Colors.white,
                                                //     ),
                                                //   ),
                                                // ),
                                              ])
                                            : Container(
                                                height: ScreenUtil().setSp(40),
                                                width: ScreenUtil().setSp(40),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: darkGray,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Stack(children: [
                                                  Center(
                                                    child: Text(
                                                        widget
                                                            .muddaPost
                                                            .leaders![index]
                                                            .acceptUserDetail!
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
                                                  // Positioned(
                                                  //   bottom: 0,
                                                  //   right: 0,
                                                  //   child: Visibility(
                                                  //     visible: muddaPost
                                                  //         .leaders![
                                                  //     index]
                                                  //         .acceptUserDetail!
                                                  //         .isProfileVerified==1,
                                                  //     child: Image.asset(
                                                  //       AppIcons.verifyProfile,
                                                  //       width: 15,
                                                  //       height: 15,
                                                  //       color: color606060,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ]),
                                              ),
                                    Vs(height: 5.h),
                                    Container(
                                      width: ScreenUtil().setSp(55),
                                      child: Text(
                                        widget.muddaPost.leaders![index]
                                                    .userIdentity ==
                                                1
                                            ? "${widget.muddaPost.leaders![index].acceptUserDetail!.fullname}"
                                            : "Anonymous",
                                        maxLines: 2,
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(12),
                                            color: black),
                                        // size10_M_regular300(
                                        //                 letterSpacing: 0.0,
                                        //                 textColor: colorDarkBlack),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    // widget.muddaPost.leaders![index]
                                    //             .joinerType! ==
                                    //         "creator"
                                    //     ? const Text("Creator") //buttonBlue
                                    //     : widget.muddaPost.leaders![index]
                                    //                 .joinerType! ==
                                    //             "opposition"
                                    //         ? const Text(
                                    //             "Opposition") //buttonYellow
                                    //         : const SizedBox.shrink() //white,
                                  ],
                                ),
                              );
                            }
                          },
                          separatorBuilder: (context, int index) {
                            return const SizedBox(width: 12);
                          },
                          itemCount: widget.muddaPost.leaders != null
                              ? widget.muddaPost.leaders!.length >= 4
                                  ? 5
                                  : widget.muddaPost.leaders!.length + 1
                              : 0))
                  // Expanded(
                  //   child: GridView.count(
                  //     crossAxisCount: 4,ng
                  //     shrinkWrap: true,
                  //     physics:
                  //         const NeverScrollableScrollPhysics(),
                  //     children: List.generate(
                  //         muddaPost.leaders != null
                  //             ? muddaPost.leaders!
                  //                         .length >=
                  //                     4
                  //                 ? 4
                  //                 : muddaPost
                  //                     .leaders!.length
                  //             : 0, (index) {
                  //       String path =
                  //           "${muddaNewsController.muddaUserProfilePath.value}${muddaPost.leaders![index].acceptUserDetail!.profile ?? ""}";
                  //       return GestureDetector(
                  //         onTap: () {
                  //           if (muddaPost
                  //                   .leaders![index]
                  //                   .userIdentity ==
                  //               1) {
                  //             muddaNewsController
                  //                     .acceptUserDetail
                  //                     .value =
                  //                 muddaPost
                  //                     .leaders![index]
                  //                     .acceptUserDetail!;
                  //             if (muddaPost
                  //                     .leaders![index]
                  //                     .acceptUserDetail!
                  //                     .sId ==
                  //                 AppPreference()
                  //                     .getString(
                  //                         PreferencesKey
                  //                             .userId)) {
                  //               Get.toNamed(
                  //                   RouteConstants
                  //                       .profileScreen);
                  //             } else {
                  //               Map<String, String>?
                  //                   parameters = {
                  //                 "userDetail":
                  //                     jsonEncode(muddaPost
                  //                         .leaders![
                  //                             index]
                  //                         .acceptUserDetail!)
                  //               };
                  //               Get.toNamed(
                  //                   RouteConstants
                  //                       .otherUserProfileScreen,
                  //                   parameters:
                  //                       parameters);
                  //             }
                  //           } else {
                  //             anynymousDialogBox(
                  //                 context);
                  //           }
                  //         },
                  //         child: Column(
                  //           mainAxisSize:
                  //               MainAxisSize.min,
                  //           children: [
                  //             muddaPost
                  //                         .leaders![
                  //                             index]
                  //                         .userIdentity ==
                  //                     0
                  //                 ? Container(
                  //                     height:
                  //                         ScreenUtil()
                  //                             .setSp(
                  //                                 40),
                  //                     width:
                  //                         ScreenUtil()
                  //                             .setSp(
                  //                                 40),
                  //                     decoration:
                  //                         BoxDecoration(
                  //                       border: Border
                  //                           .all(
                  //                         color:
                  //                             darkGray,
                  //                       ),
                  //                       shape: BoxShape
                  //                           .circle,
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                           "A",
                  //                           style: GoogleFonts.nunitoSans(
                  //                               fontWeight: FontWeight
                  //                                   .w400,
                  //                               fontSize: ScreenUtil().setSp(
                  //                                   20),
                  //                               color:
                  //                                   black)),
                  //                     ),
                  //                   )
                  //                 : muddaPost
                  //                             .leaders![
                  //                                 index]
                  //                             .acceptUserDetail!
                  //                             .profile !=
                  //                         null
                  //                     ? CachedNetworkImage(
                  //                         imageUrl:
                  //                             path,
                  //                         imageBuilder:
                  //                             (context,
                  //                                     imageProvider) =>
                  //                                 Container(
                  //                           width: ScreenUtil()
                  //                               .setSp(
                  //                                   40),
                  //                           height: ScreenUtil()
                  //                               .setSp(
                  //                                   40),
                  //                           decoration:
                  //                               BoxDecoration(
                  //                             color:
                  //                                 colorWhite,
                  //                             border:
                  //                                 Border.all(
                  //                               width:
                  //                                   ScreenUtil().setSp(1),
                  //                               color: muddaPost.leaders![index].joinerType! == "creator"
                  //                                   ? buttonBlue
                  //                                   : muddaPost.leaders![index].joinerType! == "opposition"
                  //                                       ? buttonYellow
                  //                                       : white,
                  //                             ),
                  //                             borderRadius: BorderRadius.all(
                  //                                 Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
                  //                                 ),
                  //                             image: DecorationImage(
                  //                                 image:
                  //                                     imageProvider,
                  //                                 fit:
                  //                                     BoxFit.cover),
                  //                           ),
                  //                         ),
                  //                         placeholder:
                  //                             (context,
                  //                                     url) =>
                  //                                 CircleAvatar(
                  //                           backgroundColor:
                  //                               lightGray,
                  //                           radius: ScreenUtil()
                  //                               .setSp(
                  //                                   20),
                  //                         ),
                  //                         errorWidget: (context,
                  //                                 url,
                  //                                 error) =>
                  //                             CircleAvatar(
                  //                           backgroundColor:
                  //                               lightGray,
                  //                           radius: ScreenUtil()
                  //                               .setSp(
                  //                                   20),
                  //                         ),
                  //                       )
                  //                     : Container(
                  //                         height: ScreenUtil()
                  //                             .setSp(
                  //                                 40),
                  //                         width: ScreenUtil()
                  //                             .setSp(
                  //                                 40),
                  //                         decoration:
                  //                             BoxDecoration(
                  //                           border:
                  //                               Border
                  //                                   .all(
                  //                             color:
                  //                                 darkGray,
                  //                           ),
                  //                           shape: BoxShape
                  //                               .circle,
                  //                         ),
                  //                         child:
                  //                             Center(
                  //                           child: Text(
                  //                               muddaPost
                  //                                   .leaders![
                  //                                       index]
                  //                                   .acceptUserDetail!
                  //                                   .fullname![
                  //                                       0]
                  //                                   .toUpperCase(),
                  //                               style: GoogleFonts.nunitoSans(
                  //                                   fontWeight: FontWeight.w400,
                  //                                   fontSize: ScreenUtil().setSp(20),
                  //                                   color: black)),
                  //                         ),
                  //                       ),
                  //             Vs(height: 5.h),
                  //             Text(
                  //               muddaPost
                  //                           .leaders![
                  //                               index]
                  //                           .userIdentity ==
                  //                       1
                  //                   ? "${muddaPost.leaders![index].acceptUserDetail!.fullname}"
                  //                   : "Anonymous",
                  //               style: size10_M_regular300(
                  //                   letterSpacing:
                  //                       0.0,
                  //                   textColor:
                  //                       colorDarkBlack),
                  //               textAlign:
                  //                   TextAlign.center,
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     }),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     if (muddaPost
                  //         .leaders![0]
                  //         .acceptUserDetail!
                  //         .sId ==
                  //         AppPreference()
                  //             .getString(
                  //             PreferencesKey
                  //                 .userId) ||
                  //         muddaPost
                  //             .leaders![0]
                  //             .acceptUserDetail!
                  //             .sId ==
                  //             AppPreference().getString(
                  //                 PreferencesKey
                  //                     .orgUserId)) {
                  //       muddaNewsController.muddaPost
                  //           .value = muddaPost;
                  //       muddaNewsController
                  //           .leaderBoardIndex
                  //           .value = 0;
                  //       Get.toNamed(
                  //           RouteConstants
                  //               .leaderBoardApproval,
                  //           arguments: muddaPost);
                  //     } else {
                  //       Get.toNamed(
                  //           RouteConstants
                  //               .leaderBoard,
                  //           arguments: muddaPost);
                  //     }
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Icon(Icons.add, size: 15.sp),
                  //       Column(
                  //         mainAxisAlignment:
                  //         MainAxisAlignment
                  //             .center,
                  //         children: [
                  //           Text(
                  //             muddaPost.leaders !=
                  //                 null
                  //             // ? "${muddaPost.leadersCount! - 4}"
                  //                 ? muddaPost.leaders!
                  //                 .length <
                  //                 4
                  //                 ? "0 Leaders"
                  //                 : "${muddaPost.leadersCount! - 4} Leaders"
                  //                 : "",
                  //             style: size12_M_bold(
                  //                 textColor:
                  //                 colorDarkBlack),
                  //           ),
                  //           Vs(
                  //             height: 10.h,
                  //           ),
                  //           Image.asset(
                  //             AppIcons.nextLongArrow,
                  //             height: 8.h,
                  //           ),
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            const Vs(height: 24),
            Container(
              width: double.infinity,
              height: 1,
              color: colorF2F2F2,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              height: ScreenUtil().setHeight(66),
              child: Obx(
                () => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Visibility(
                            visible: muddaNewsController.muddaAction.value ||
                                widget.index !=
                                    muddaNewsController.muddaActionIndex.value,
                            child: widget.muddaPost.mySupport == null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (AppPreference().getBool(
                                              PreferencesKey.isGuest)) {
                                            updateProfileDialog(context);
                                          } else {
                                            Api.post.call(
                                              context,
                                              method: "mudda/support",
                                              param: {
                                                "muddaId": widget.muddaPost.sId,
                                                "support": true,
                                              },
                                              onResponseSuccess: (object) {
                                                muddaNewsController.support();
                                                print(object);
                                                widget.muddaPost.afterMe =
                                                    object['data'] != null
                                                        ? AfterMe.fromJson(
                                                            object['data'])
                                                        : null;
                                                if (widget
                                                        .muddaPost.mySupport ==
                                                    true) {
                                                  widget.muddaPost.mySupport =
                                                      null;
                                                  widget.muddaPost.support =
                                                      widget.muddaPost
                                                              .support! -
                                                          1;
                                                  widget.muddaPost.totalVote! -
                                                      1;
                                                } else {
                                                  widget.muddaPost.support =
                                                      widget.muddaPost
                                                              .support! +
                                                          1;
                                                  widget.muddaPost.totalVote! +
                                                      1;
                                                  widget.muddaPost.mySupport =
                                                      true;
                                                }
                                                muddaNewsController
                                                            .muddaPostList[
                                                        widget.index] =
                                                    widget.muddaPost;
                                                muddaNewsController
                                                    .muddaActionIndex
                                                    .value = widget.index;
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
                                              margin: const EdgeInsets.only(
                                                  left: 25),
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
                                      const Hs(width: 10),
                                      InkWell(
                                        onTap: () {
                                          if (AppPreference().getBool(
                                              PreferencesKey.isGuest)) {
                                            updateProfileDialog(context);
                                          } else {
                                            Api.post.call(
                                              context,
                                              method: "mudda/support",
                                              param: {
                                                "muddaId": widget.muddaPost.sId,
                                                "support": false,
                                              },
                                              onResponseSuccess: (object) {
                                                muddaNewsController.support();
                                                widget.muddaPost.afterMe =
                                                    object['data'] != null
                                                        ? AfterMe.fromJson(
                                                            object['data'])
                                                        : null;

                                                if (widget
                                                        .muddaPost.mySupport ==
                                                    false) {
                                                  widget.muddaPost.mySupport =
                                                      null;
                                                  widget.muddaPost.totalVote! -
                                                      1;
                                                } else {
                                                  widget.muddaPost.totalVote! +
                                                      1;

                                                  widget.muddaPost.mySupport =
                                                      false;
                                                }

                                                muddaNewsController
                                                            .muddaPostList[
                                                        widget.index] =
                                                    widget.muddaPost;
                                                muddaNewsController
                                                    .muddaActionIndex
                                                    .value = widget.index;
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
                                              margin: const EdgeInsets.only(
                                                  left: 25),
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(
                                                  left: 10),
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
                                    ],
                                  )
                                : Row(
                                    children: [
                                      // Hs(width: 17),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Recent Updates:",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(12),
                                                  color: black)),
                                          Container(
                                            height: ScreenUtil().setSp(50),
                                            width: ScreenUtil().setSp(190),
                                            child:
                                                // GridView.count(
                                                //   padding:
                                                //       EdgeInsets.only(top: 4),
                                                //   crossAxisCount: 2,
                                                //   scrollDirection:
                                                //       Axis.vertical,
                                                //   crossAxisSpacing: 4,
                                                //   mainAxisSpacing: 4,
                                                //   childAspectRatio: 5,
                                                //   physics:
                                                //       const NeverScrollableScrollPhysics(),
                                                //   shrinkWrap: true,
                                                Wrap(
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.all(2),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4, right: 2),
                                                    color:
                                                        const Color(0xff2176FF)
                                                            .withOpacity(0.1),
                                                    child: Text.rich(
                                                      TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    "Support: ",
                                                                style: size11_M_regular(
                                                                    textColor:
                                                                        const Color(
                                                                            0xff2176FF))),
                                                            TextSpan(
                                                                text:
                                                                    "${widget.muddaPost.support} (${widget.muddaPost.supportDiff != null && widget.muddaPost.supportDiff!.isNaN == false ? widget.muddaPost.supportDiff!.toStringAsFixed(0) : 0}%)",
                                                                style: size11_M_bold(
                                                                    textColor: widget.muddaPost.supportDiff !=
                                                                                null &&
                                                                            widget
                                                                                .muddaPost.supportDiff!.isNegative
                                                                        ? Colors
                                                                            .red
                                                                        : const Color(
                                                                            0xff2176FF)))
                                                          ]),
                                                    )),
                                                Container(
                                                    margin:
                                                        const EdgeInsets.all(2),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4, right: 2),
                                                    color:
                                                        const Color(0xff2176FF)
                                                            .withOpacity(0.1),
                                                    child: Text.rich(TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "New Leaders: ",
                                                              style: size11_M_regular(
                                                                  textColor:
                                                                      const Color(
                                                                          0xff2176FF))),
                                                          TextSpan(
                                                              text:
                                                                  "${widget.muddaPost.newLeaderDiff ?? widget.muddaPost.leadersCount}",
                                                              style: size11_M_bold(
                                                                  textColor: widget.muddaPost.newLeaderDiff !=
                                                                              null &&
                                                                          widget
                                                                              .muddaPost
                                                                              .newLeaderDiff!
                                                                              .isNegative
                                                                      ? Colors
                                                                          .red
                                                                      : const Color(
                                                                          0xff2176FF)))
                                                        ]))),
                                                Container(
                                                    margin:
                                                        const EdgeInsets.all(2),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4, right: 2),
                                                    color:
                                                        const Color(0xff2176FF)
                                                            .withOpacity(0.1),
                                                    child: Text.rich(TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "New Posts: ",
                                                              style: size11_M_regular(
                                                                  textColor:
                                                                      const Color(
                                                                          0xff2176FF))),
                                                          TextSpan(
                                                              text:
                                                                  "${widget.muddaPost.newPostDiff ?? widget.muddaPost.totalPost}",
                                                              style: size11_M_bold(
                                                                  textColor: widget.muddaPost.newPostDiff !=
                                                                              null &&
                                                                          widget
                                                                              .muddaPost
                                                                              .newPostDiff!
                                                                              .isNegative
                                                                      ? Colors
                                                                          .red
                                                                      : const Color(
                                                                          0xff2176FF)))
                                                        ]))),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Hs(width: 17),
                                      const Spacer(),
                                      (widget.muddaPost.isInvolved !=
                                                          null &&
                                                      widget.muddaPost.isInvolved!
                                                              .joinerType ==
                                                          'creator' ||
                                                  widget.muddaPost
                                                              .isInvolved !=
                                                          null &&
                                                      widget
                                                              .muddaPost
                                                              .isInvolved!
                                                              .joinerType ==
                                                          'initial_leader' ||
                                                  widget.muddaPost.isInvolved !=
                                                          null &&
                                                      widget
                                                              .muddaPost
                                                              .isInvolved!
                                                              .joinerType ==
                                                          'leader' ||
                                                  widget.muddaPost.isInvolved !=
                                                          null &&
                                                      widget
                                                              .muddaPost
                                                              .isInvolved!
                                                              .joinerType ==
                                                          'opposition') &&
                                              (widget.muddaCreator >
                                                      0 ||
                                                  widget.muddaLeader > 0 ||
                                                  widget.muddaInitialLeader >
                                                      0 ||
                                                  widget.muddaOpposition > 0)
                                          ? Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    muddaNewsController
                                                            .muddaPost.value =
                                                        widget.muddaPost;
                                                    Get.back();
                                                    CreateMyDynamicLinksClass()
                                                        .createDynamicLink(true,
                                                            '/muddaDetailsScreen?id=${muddaNewsController.muddaId}')
                                                        .then((value) =>
                                                            Share.share(value));
                                                  },
                                                  child: Image.asset(
                                                    AppIcons.iconShareRound,
                                                    height: 40,
                                                    width: 40,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                GestureDetector(
                                                  onTap: () {
                                                    log('-=- muddaId - 1 -=- ${widget.muddaPost.sId!}');
                                                    log('-=- muddaOpposition - 1 -=- ${widget.muddaOpposition > 0}');
                                                    // Get.toNamed(RouteConstants.invitedSearchScreen, arguments: muddaPost.sId!)!
                                                    muddaNewsController
                                                            .muddaPost.value =
                                                        widget.muddaPost;
                                                    // int? pIndex = widget.muddaPost.leaders?.indexOf(Leaders(
                                                    //     acceptUserDetail: AcceptUserDetail(sId: AppPreference().getString(PreferencesKey.userId))
                                                    // ));
                                                    // log('-=- index$pIndex');
                                                    String? joineerType = widget
                                                        .muddaPost
                                                        .isInvolved!
                                                        .joinerType;
                                                    log('-=- type$joineerType');
                                                    muddaNewsController
                                                        .inviteType
                                                        .value = joineerType ==
                                                            'opposition'
                                                        ? 'opposition'
                                                        : '';
                                                    Get.toNamed(RouteConstants
                                                        .invitedSupportScreen);
                                                  },
                                                  child: Image.asset(
                                                    AppIcons
                                                        .iconInviteSupportRound,
                                                    height: 40,
                                                    width: 40,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                InkWell(
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
                                                        param: {
                                                          "muddaId": widget
                                                              .muddaPost.sId,
                                                          "support": true,
                                                        },
                                                        onResponseSuccess:
                                                            (object) {
                                                          print(object);
                                                          widget.muddaPost
                                                              .afterMe = object[
                                                                      'data'] !=
                                                                  null
                                                              ? AfterMe.fromJson(
                                                                  object[
                                                                      'data'])
                                                              : null;
                                                          if (widget.muddaPost
                                                                  .mySupport ==
                                                              true) {
                                                            widget.muddaPost
                                                                    .mySupport =
                                                                null;
                                                            widget.muddaPost
                                                                .support = widget
                                                                    .muddaPost
                                                                    .support! -
                                                                1;
                                                            widget.muddaPost
                                                                    .totalVote! -
                                                                1;
                                                          } else {
                                                            widget.muddaPost
                                                                .support = widget
                                                                    .muddaPost
                                                                    .support! +
                                                                1;
                                                            widget.muddaPost
                                                                    .totalVote! +
                                                                1;
                                                            widget.muddaPost
                                                                    .mySupport =
                                                                true;
                                                          }
                                                          muddaNewsController
                                                                  .muddaPostList[
                                                              widget
                                                                  .index] = widget
                                                              .muddaPost;
                                                          muddaNewsController
                                                                  .muddaActionIndex
                                                                  .value =
                                                              widget.index;
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
                                                            color: widget
                                                                        .muddaPost
                                                                        .mySupport ==
                                                                    true
                                                                ? Colors.white
                                                                : blackGray)),
                                                    decoration: BoxDecoration(
                                                      color: widget.muddaPost
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
                                                const Hs(width: 18),
                                                InkWell(
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
                                                        param: {
                                                          "muddaId": widget
                                                              .muddaPost.sId,
                                                          "support": false,
                                                        },
                                                        onResponseSuccess:
                                                            (object) {
                                                          widget.muddaPost
                                                              .afterMe = object[
                                                                      'data'] !=
                                                                  null
                                                              ? AfterMe.fromJson(
                                                                  object[
                                                                      'data'])
                                                              : null;

                                                          if (widget.muddaPost
                                                                  .mySupport ==
                                                              false) {
                                                            widget.muddaPost
                                                                    .mySupport =
                                                                null;
                                                            widget.muddaPost
                                                                    .totalVote! -
                                                                1;
                                                            widget.muddaPost
                                                                        .support !=
                                                                    0
                                                                ? widget.muddaPost
                                                                        .support! -
                                                                    1
                                                                : 0;
                                                          } else {
                                                            widget.muddaPost
                                                                    .totalVote! +
                                                                1;
                                                            widget.muddaPost
                                                                    .support =
                                                                widget.muddaPost
                                                                    .support;
                                                            widget.muddaPost
                                                                .support = widget
                                                                    .muddaPost
                                                                    .support! -
                                                                1;

                                                            widget.muddaPost
                                                                    .mySupport =
                                                                false;
                                                          }

                                                          muddaNewsController
                                                                  .muddaPostList[
                                                              widget
                                                                  .index] = widget
                                                              .muddaPost;
                                                          muddaNewsController
                                                                  .muddaActionIndex
                                                                  .value =
                                                              widget.index;
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
                                                            color: widget
                                                                        .muddaPost
                                                                        .mySupport ==
                                                                    false
                                                                ? Colors.white
                                                                : blackGray)),
                                                    decoration: BoxDecoration(
                                                      color: widget.muddaPost
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
                                    ],
                                  ),
                          ),
                          Visibility(
                            visible: muddaNewsController
                                    .muddaDescripation.value &&
                                widget.index ==
                                    muddaNewsController.muddaActionIndex.value,
                            child: widget.muddaPost.muddaDescription!
                                        .isNotEmpty &&
                                    widget.muddaPost.muddaDescription!.length >
                                        3
                                ? ReadMoreText(
                                    'Description: ${widget.muddaPost.muddaDescription}',
                                    trimLines: 3,
                                    trimMode: TrimMode.Line,
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: ScreenUtil().setSp(12),
                                        fontWeight: FontWeight.w400,
                                        color: black),
                                  )
                                : widget.muddaPost.muddaDescription!.isNotEmpty
                                    ? Text(
                                        "Description: ${widget.muddaPost.muddaDescription}",
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                            color: black))
                                    : Text("Description:",
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                            color: black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: colorF2F2F2,
            ),
            const Vs(
              height: 8,
            ),
            InkWell(
              onTap: () => _switchCard(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // SvgPicture.asset(AppIcons.icLocation,
                        //     width: 9, height: 12),
                        // const Hs(width: 4),
                        if (widget.muddaPost.mySupport == null)
                          Text("You haven't voted yet",
                              style: size12_M_normal(textColor: colorDarkBlack))
                        else if (widget.muddaPost.isInvolved != null &&
                            widget.muddaPost.isInvolved!.joinerType ==
                                'opposition')
                          Text("You are an opposition leader",
                              style: size12_M_normal(textColor: colorDarkBlack))
                        else if (widget.muddaPost.isInvolved != null &&
                            widget.muddaPost.isInvolved!.joinerType ==
                                'initial_leader')
                          Text("You are a favour leader",
                              style: size12_M_normal(textColor: colorDarkBlack))
                        else if (widget.muddaPost.mySupport != null &&
                            widget.muddaPost.mySupport == true)
                          Text("You have supported",
                              style: size12_M_normal(textColor: colorDarkBlack))
                        else if (widget.muddaPost.mySupport != null &&
                            widget.muddaPost.mySupport == false)
                          Text("You have not supported",
                              style: size12_M_normal(textColor: colorDarkBlack))
                      ],
                    ),
                  ),
                  SvgPicture.asset(AppIcons.flipCard, width: 10, height: 10),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: colorDarkBlack),
                        ),
                        const Hs(width: 4),
                        Text(
                            convertToAgo(
                                DateTime.parse(widget.muddaPost.createdAt!)),
                            style: size10_M_normal(textColor: colorDarkBlack)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Place>> _getLocation(String query, BuildContext context) async {
  List<Place> matches = <Place>[];
  if (query.length >= 3 && query.length < 20) {
    var responce = await Api.get.futureCall(context,
        method: "country/location",
        param: {
          "search": query,
          "page": "1",
          "search_type": "district",
        },
        isLoading: false);
    if (responce != null) {
      final result = PlaceModel.fromJson(responce.data!);
      return result.data!;
    } else {
      return matches;
    }
  } else {
    return matches;
  }
}

Future uploadProfilePic(BuildContext context) async {
  final signUpController = Get.put(SignUpController());
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
                        signUpController.profile.value = value.path;
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
                  final pickedFile =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    _cropImage(File(pickedFile.path)).then((value) async {
                      signUpController.profile.value = value.path;
                    });
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

updateProfileDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  final signUpController = Get.put(SignUpController());
  final userProfileUpdateController = Get.put(UserProfileUpdateController());
  final locationController = TextEditingController();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.only(
                left: ScreenUtil().setWidth(26),
                right: ScreenUtil().setWidth(26)),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setStates) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(50)),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setSp(16))),
                            boxShadow: [
                              const BoxShadow(
                                offset: const Offset(0, 4),
                                color: black25,
                                blurRadius: 4.0,
                              ),
                            ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          ScreenUtil().setSp(16)),
                                      topRight: Radius.circular(
                                          ScreenUtil().setSp(16))),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [lightRedWhite, lightRed])),
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(19),
                                  bottom: ScreenUtil().setHeight(19),
                                  left: ScreenUtil().setWidth(37),
                                  right: ScreenUtil().setWidth(36)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Let’s begin...',
                                      style: GoogleFonts.kaushanScript(
                                          fontSize: ScreenUtil().setSp(24),
                                          color: white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            Container(
                              color: appBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: size16_M_normal(
                                          textColor: color606060),
                                    ),
                                    Vs(height: 6.h),
                                    CustomTextFieldWidget(
                                      keyboardType: TextInputType.name,
                                      hintText: enterName,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.trim().length < 3) {
                                          return 'Enter your full name';
                                        }
                                      },
                                      signUpController: signUpController,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-Z ]")),
                                      ],
                                    ),
                                    Vs(height: 12.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            age,
                                            style: size16_M_normal(
                                                textColor: color606060),
                                          ),
                                        ),
                                        const Hs(width: 5),
                                        Expanded(
                                          child: Obx(() => Wrap(
                                                children: List.generate(
                                                  signUpController
                                                      .ageList.length,
                                                  (index) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15, top: 10),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        signUpController
                                                            .isSelectedAge
                                                            .value = index;
                                                      },
                                                      child: Container(
                                                        width: getWidth(60),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: signUpController
                                                                            .isSelectedAge
                                                                            .value ==
                                                                        index
                                                                    ? Colors
                                                                        .transparent
                                                                    : colorA0A0A0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: signUpController
                                                                        .isSelectedAge
                                                                        .value ==
                                                                    index
                                                                ? colorBlack
                                                                : Colors
                                                                    .transparent),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                          child: Text(
                                                            signUpController
                                                                .ageList[index],
                                                            style: size12_M_normal(
                                                                textColor: signUpController
                                                                            .isSelectedAge
                                                                            .value ==
                                                                        index
                                                                    ? colorWhite
                                                                    : colorA0A0A0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        )
                                      ],
                                    ),
                                    Vs(height: 16.h),
                                    SizedBox(
                                      height: 30.h,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Text(
                                              gender,
                                              style: size16_M_normal(
                                                  textColor: color606060),
                                            ),
                                          ),
                                          const Hs(width: 5),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: signUpController
                                                .maleFemaleList.length,
                                            itemBuilder: (context, index) {
                                              return Obx(
                                                () => GestureDetector(
                                                  onTap: () {
                                                    signUpController
                                                        .isSelectedMale
                                                        .value = index;
                                                  },
                                                  child: Container(
                                                    width: 60.w,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.w),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: signUpController
                                                                        .isSelectedMale
                                                                        .value ==
                                                                    index
                                                                ? Colors
                                                                    .transparent
                                                                : colorA0A0A0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: signUpController
                                                                    .isSelectedMale
                                                                    .value ==
                                                                index
                                                            ? colorBlack
                                                            : Colors
                                                                .transparent),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      signUpController
                                                              .maleFemaleList[
                                                          index],
                                                      style: size12_M_normal(
                                                          textColor: signUpController
                                                                      .isSelectedMale
                                                                      .value ==
                                                                  index
                                                              ? colorWhite
                                                              : colorA0A0A0),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Vs(height: 10.h),
                                    Text(
                                      location,
                                      style: size12_M_normal(
                                        textColor: color606060,
                                      ),
                                    ),
                                    Vs(height: 10.h),
                                    TypeAheadFormField<Place>(
                                      direction: AxisDirection.up,
                                      getImmediateSuggestions: true,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter location';
                                        }
                                      },
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                              controller: locationController,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              minLines: 1,
                                              maxLines: 3,
                                              scrollPadding: EdgeInsets.only(
                                                  bottom: ScreenUtil()
                                                      .setHeight(150)),
                                              style: size14_M_normal(
                                                  textColor: color606060),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFf7f7f7),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                hintText:
                                                    "Enter First 3 character of your district to search",
                                                hintStyle: size12_M_normal(
                                                    textColor: color606060),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: white, width: 1),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: white, width: 1),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: white, width: 1),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: white, width: 1),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: white, width: 1),
                                                ),
                                              )),
                                      suggestionsBoxDecoration:
                                          const SuggestionsBoxDecoration(
                                        hasScrollbar: true,
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return _getLocation(pattern, context);
                                      },
                                      hideSuggestionsOnKeyboardHide: true,
                                      itemBuilder: (context, suggestion) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${suggestion.district}, ${suggestion.state}, ${suggestion.country}",
                                            style: GoogleFonts.nunitoSans(
                                                color: darkGray,
                                                fontWeight: FontWeight.w300,
                                                fontSize:
                                                    ScreenUtil().setSp(12)),
                                          ),
                                        );
                                      },
                                      transitionBuilder: (context,
                                          suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected: (suggestion) async {
                                        locationController.text =
                                            "${suggestion.district}, ${suggestion.state}, ${suggestion.country}";
                                        signUpController.city.value =
                                            suggestion.district!;
                                        signUpController.state.value =
                                            suggestion.state!;
                                        signUpController.country.value =
                                            suggestion.country!;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: ScreenUtil().setHeight(2),
                            ),

                            ///get started
                            InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  AppPreference _appPreference =
                                      AppPreference();

                                  FormData formData = FormData.fromMap({
                                    "fullname":
                                        signUpController.nameValue.value,
                                    "city": signUpController.city.value,
                                    "state": signUpController.state.value,
                                    "country": signUpController.country.value,
                                    "gender": signUpController.maleFemaleList
                                        .elementAt(signUpController
                                            .isSelectedMale.value),
                                    "age": signUpController.ageList.elementAt(
                                        signUpController.isSelectedAge.value),
                                    "_id": _appPreference
                                        .getString(PreferencesKey.userId),
                                  });
                                  if (signUpController
                                      .profile.value.isNotEmpty) {
                                    print("PROFILE:::" +
                                        signUpController.profile.value);
                                    var video = await MultipartFile.fromFile(
                                        signUpController.profile.value,
                                        filename: signUpController.profile.value
                                            .split('/')
                                            .last);
                                    formData.files.addAll([
                                      MapEntry("profile", video),
                                    ]);
                                  }

                                  Api.uploadPost.call(context,
                                      method: "user/profile-update",
                                      param: formData,
                                      isLoading: true,
                                      onResponseSuccess: (Map object) {
                                    var snackBar = const SnackBar(
                                      content: Text('Updated'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    var result =
                                        UserProfileModel.fromJson(object);
                                    userProfileUpdateController
                                        .userProfilePath.value = result.path!;
                                    userProfileUpdateController
                                        .userProfile.value = result.data!;
                                    AppPreference().setString(
                                        PreferencesKey.fullName,
                                        object['data']['fullname']);
                                    AppPreference().setString(
                                        PreferencesKey.city,
                                        signUpController.nameValue.value);
                                    AppPreference().setString(
                                        PreferencesKey.state,
                                        userProfileUpdateController
                                            .userProfile.value.state!);
                                    AppPreference().setString(
                                        PreferencesKey.country,
                                        userProfileUpdateController
                                            .userProfile.value.country!);
                                    _appPreference.setBool(
                                        PreferencesKey.isGuest, false);
                                    Get.back();
                                  });
                                  // log('${signUpController.nameValue.value} ,${signUpController.city.value}, ${signUpController.state.value},${signUpController.country.value},${signUpController.maleFemaleList.elementAt(signUpController.isSelectedMale.value)},${signUpController.ageList
                                  //     .elementAt(signUpController
                                  //     .isSelectedAge.value)}, ${signUpController.profile.value}');
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: appBackgroundColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          ScreenUtil().setSp(16)),
                                      bottomRight: Radius.circular(
                                          ScreenUtil().setSp(16))),
                                ),
                                height: ScreenUtil().setHeight(63),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Get Started',
                                      style: GoogleFonts.nunitoSans(
                                          color: black,
                                          fontSize: ScreenUtil().setSp(20),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(8),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: black,
                                      size: 29,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding:
                              EdgeInsets.only(right: ScreenUtil().setWidth(23)),
                          child: Obx(() => InkWell(
                                onTap: () {
                                  uploadProfilePic(context);
                                },
                                child: signUpController.profile.value.isEmpty
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundColor: lightGray,
                                        child: CircleAvatar(
                                          radius: 49,
                                          backgroundColor: white,
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            color: lightGray,
                                            size: ScreenUtil().radius(35),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                            color: white,
                                            shape: BoxShape.circle,
                                            border:
                                                Border.all(color: lightGray),
                                            image: new DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(File(
                                                    signUpController
                                                        .profile.value))))),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
      });
}
