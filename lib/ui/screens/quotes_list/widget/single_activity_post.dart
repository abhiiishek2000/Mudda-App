import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/model/QuotePostModel.dart';
import 'package:mudda/ui/screens/profile_screen/controller/profile_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/utils/color.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../dio/Api/Api.dart';
import '../../../../model/PostForMuddaModel.dart';
import '../../../shared/ReadMoreText.dart';
import '../../leader_board/view/leader_board_approval_screen.dart';
import '../../mudda/widget/mudda_post_comment.dart';

class SingleQouteActivityPost extends StatefulWidget {
  const SingleQouteActivityPost({Key? key}) : super(key: key);

  @override
  State<SingleQouteActivityPost> createState() =>
      _SingleQouteActivityPostState();
}

class _SingleQouteActivityPostState extends State<SingleQouteActivityPost> {
  final profileController = Get.put(ProfileController());
  final controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final Quote quote = Get.arguments;
    profileController.quotesOrActivity.value = quote;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBackgroundColor,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: black,
              )),
        ),
        body: InkWell(
          onTap: () {
            Get.toNamed(RouteConstants.muddaPostCommentsScreen,
                arguments: quote);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setSp(8)),
            padding: EdgeInsets.only(
                bottom: ScreenUtil().setSp(8), top: ScreenUtil().setSp(8)),
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setSp(12)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          if (quote.user!.sId ==
                              AppPreference()
                                  .getString(PreferencesKey.userId)) {
                            Get.toNamed(RouteConstants.profileScreen);
                          } else {
                            Map<String, String>? parameters = {
                              "userDetail": jsonEncode(quote.user!)
                            };
                            Get.toNamed(RouteConstants.otherUserProfileScreen,
                                parameters: parameters);
                          }
                        },
                        child: Column(
                          children: [
                            quote.user != null && quote.user!.profile != null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        "${profileController.quoteProfilePath}${quote.user!.profile!}",
                                    imageBuilder: (context, imageProvider) =>
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
                                    placeholder: (context, url) => CircleAvatar(
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
                                    height: ScreenUtil().setSp(45),
                                    width: ScreenUtil().setSp(45),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: darkGray,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                          quote.user != null &&
                                                  quote.user!.fullname!
                                                      .isNotEmpty
                                              ? quote.user!.fullname![0]
                                                  .toUpperCase()
                                              : "A",
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  ScreenUtil().setSp(22.5),
                                              color: black)),
                                    ),
                                  ),
                            getSizedBox(h: ScreenUtil().setSp(8)),
                            SvgPicture.asset(quote.postOf == "quote"
                                ? "assets/svg/quote.svg"
                                : "assets/svg/activity.svg")
                          ],
                        ),
                      ),
                      getSizedBox(w: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Wrap(
                                    children: [
                                      Text(
                                        quote.user != null
                                            ? quote.user!.fullname!
                                            : "",
                                        style: size13_M_bold(
                                            textColor: Colors.black87),
                                      ),
                                      getSizedBox(w: 5),
                                      const CircleAvatar(
                                        radius: 2,
                                        backgroundColor: Colors.black,
                                      ),
                                      getSizedBox(w: 5),
                                      Text(
                                        quote.user != null
                                            ? quote.user!.username!
                                            : "",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                  ),
                                ),
                              ],
                            ),
                            quote.hashtags != null && quote.hashtags!.isNotEmpty
                                ? Text(
                                    quote.hashtags != null
                                        ? quote.hashtags!.join(",")
                                        : "",
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic),
                                  )
                                : Container(),
                            getSizedBox(
                                h: quote.hashtags != null &&
                                        quote.hashtags!.isNotEmpty
                                    ? 5
                                    : 0),
                            quote.description != null &&
                                    quote.description!.isNotEmpty &&
                                    quote.description!.length > 6
                                ? ReadMoreText(
                                    quote.description ?? "",
                                    trimLines: 6,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'more',
                                    trimExpandedText: 'less',
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: ScreenUtil().setSp(14),
                                        fontWeight: FontWeight.w400,
                                        color: black),
                                  )
                                : Text("${quote.description}",
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: ScreenUtil().setSp(14),
                                        fontWeight: FontWeight.w400,
                                        color: black)),
                          ],
                        ),
                      ),
                      getSizedBox(w: 12)
                    ],
                  ),
                ),
                quote.postOf == "activity" && quote.gallery!.isNotEmpty
                    ? Obx(
                        () => Container(
                          height: ScreenUtil().setSp(370),
                          width: ScreenUtil().screenWidth,
                          margin: const EdgeInsets.only(top: 8),
                          child: Stack(
                            children: [
                              CarouselSlider.builder(
                                  carouselController: controller,
                                  options: CarouselOptions(
                                    initialPage: 0,
                                    height: ScreenUtil().setSp(370),
                                    enableInfiniteScroll: false,
                                    viewportFraction: 1,
                                    onPageChanged: (index, reason) {
                                      profileController
                                          .currentHorizontal.value = index;
                                    },
                                  ),
                                  itemCount: quote.gallery!.length,
                                  itemBuilder: (context, index2, realIndex) {
                                    Gallery mediaModelData =
                                        quote.gallery![index2];
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        /* !mediaModelData.file!.contains(".mp4")
                                                        ? SizedBox(
                                                      height:
                                                      ScreenUtil()
                                                          .setSp(
                                                          370),
                                                      width:
                                                      ScreenUtil()
                                                          .screenWidth,
                                                          child: CachedNetworkImage(
                                                          imageUrl: "${profileController.quotePostPath.value}${mediaModelData.file!}",
                                                          fit: BoxFit.cover,),
                                                        )
                                                        : GestureDetector(
                                                      onLongPressUp: () {
                                                        profileController.isOnPageHorizontalTurning.value = false;
                                                      },
                                                      onLongPress: () {
                                                        profileController.isOnPageHorizontalTurning.value = true;
                                                      },
                                                      onTap: () {
                                                        */
                                        /*setStates(() {
                                                  isDialOpen.value = false;
                                                  if (visibilityTag) {
                                                    visibilityTag = false;
                                                  }
                                                  hideShowTag = !hideShowTag;
                                                });*/ /*
                                                      },
                                                      child: VideoPlayerScreen(
                                                          mediaModelData.file!,
                                                          profileController.quotePostPath.value,
                                                          index2,
                                                          profileController.currentHorizontal.value,
                                                          index,
                                                          0,
                                                          true,
                                                          videoController,
                                                          profileController.isOnPageHorizontalTurning.value),
                                                    ),*/
                                        SizedBox(
                                          height: ScreenUtil().setSp(370),
                                          width: ScreenUtil().screenWidth,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${profileController.quotePostPath.value}${mediaModelData.file!}",
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 9),
                                  child: AnimatedSmoothIndicator(
                                      onDotClicked: (index) {
                                        controller.animateToPage(index);
                                      },
                                      activeIndex: profileController
                                          .currentHorizontal.value,
                                      count: quote.gallery!.length,
                                      effect: CustomizableEffect(
                                        activeDotDecoration: DotDecoration(
                                          width: 12.0,
                                          height: 3.0,
                                          color: Colors.amber,
                                          // rotationAngle: 180,
                                          // verticalOffset: -10,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          dotBorder: const DotBorder(
                                            padding: 1,
                                            width: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        dotDecoration: DotDecoration(
                                          width: 12.0,
                                          height: 3.0,
                                          // color: lightRed,
                                          dotBorder: const DotBorder(
                                            padding: 0,
                                            width: 0.5,
                                            color: Colors.white,
                                          ),
                                          // borderRadius: BorderRadius.only(
                                          //     topLeft: Radius.circular(2),
                                          //     topRight: Radius.circular(16),
                                          //     bottomLeft: Radius.circular(16),
                                          //     bottomRight: Radius.circular(2)),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          // verticalOffset: 0,
                                        ),
                                        // spacing: 6.0,
                                        // activeColorOverride: (i) => colors[i],
                                        inActiveColorOverride: (i) => white,
                                      )
                                      // const SlideEffect(
                                      //     spacing: 10.0,
                                      //     radius: 3.0,
                                      //     dotWidth: 6.0,
                                      //     dotHeight: 6.0,
                                      //     paintStyle: PaintingStyle.stroke,
                                      //     strokeWidth: 1.5,
                                      //     dotColor: white,
                                      //     activeDotColor: lightRed),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 54, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (quote.amILiked != null) {
                            quote.likersCount = quote.likersCount! - 1;
                            quote.amILiked = null;
                            profileController.quotesOrActivity.value = quote;
                          } else {
                            quote.likersCount = quote.likersCount! + 1;
                            AmILiked q = AmILiked();
                            q.relativeId = quote.sId!;
                            q.relativeType = "QuoteOrActivity";
                            q.userId = AppPreference()
                                .getString(PreferencesKey.interactUserId);
                            quote.amILiked = q;
                            profileController.quotesOrActivity.value = quote;
                          }
                          Api.post.call(
                            context,
                            method: "like/store",
                            isLoading: false,
                            param: {
                              "user_id": AppPreference()
                                  .getString(PreferencesKey.interactUserId),
                              "relative_id": quote.sId!,
                              "relative_type": "QuoteOrActivity",
                              "status": true,
                            },
                            onResponseSuccess: (object) {
                              print("Abhishek $object");
                              setState(() {});
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/like.svg",
                                color: quote.amILiked != null
                                    ? themeColor
                                    : blackGray,
                              ),
                              getSizedBox(w: 5),
                              Text(
                                  NumberFormat.compactCurrency(
                                    decimalDigits: 0,
                                    symbol:
                                        '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  ).format(quote.likersCount),
                                  style: GoogleFonts.nunitoSans(
                                    fontWeight: quote.amILiked != null
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    fontSize: ScreenUtil().setSp(12),
                                    color: quote.amILiked != null
                                        ? themeColor
                                        : blackGray,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            AppIcons.messageIcon,
                            color: colorGrey,
                            height: 18,
                            width: 19,
                          ),
                          getSizedBox(w: 3),
                          Text(
                              NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol:
                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                              ).format(quote.commentorsCount),
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                fontSize: ScreenUtil().setSp(12),
                                color: blackGray,
                              )),
                          getSizedBox(w: 15),
                          SvgPicture.asset(
                            "assets/svg/line.svg",
                          ),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return CommentsForMuddaBazz(
                                      commentId: quote.sId!,
                                    );
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
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
                            backgroundColor: Colors.black,
                          ),
                          getSizedBox(w: 5),
                          Text(convertToAgo(DateTime.parse(quote.createdAt!)),
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: ScreenUtil().setSp(12),
                                  color: blackGray)),
                        ],
                      )
                    ],
                  ),
                ),
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
        ));
  }
}
