import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/const/const.dart';

import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/size_config.dart';

import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/SearchModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/home_screen/controller/search_controller_new.dart Ass search';
import 'package:mudda/ui/screens/mudda/view/mudda_details_screen.dart';
import 'package:mudda/ui/shared/ReadMoreText.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../leader_board/view/leader_board_screen.dart';

class MuddasSearch extends GetView {
  MuddasSearch({Key? key}) : super(key: key);
  SearchController? searchController;
  MuddaNewsController? muddaNewsController;
  ScrollController muddaScrollController = ScrollController();
  int page = 1;
  @override
  Widget build(BuildContext context) {
    searchController = Get.find<SearchController>();
    muddaNewsController = Get.find<MuddaNewsController>();
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 5;
    final double itemHeight = itemWidth + ScreenUtil().setSp(2);
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        Api.get.call(context,
            method: "global/search",
            param: {
              "search": searchController!.search,
              "page": page.toString(),
              "user_id": AppPreference().getString(PreferencesKey.userId)
            },
            isLoading: false, onResponseSuccess: (Map object) {
              var result = SearchModel.fromJson(object);
              searchController!.muddaPath.value = result.path!;
              searchController!.userProfilePath.value = result.userpath!;
              if (result.mudda!.isNotEmpty) {
                searchController!.muddaList.addAll(result.mudda!);
              } else {
                page = page > 1 ? page - 1 : page;
              }
            });
      }
    });
    return Obx(
          () => ListView.builder(
          shrinkWrap: true,
          controller: muddaScrollController,
          padding: EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
          itemCount: searchController!.muddaList.length > 5
              ? 5
              : searchController!.muddaList.length,
          itemBuilder: (followersContext, index) {
            String status = "Under Approval";
            String created = "";
            MuddaPost muddaPost = searchController!.muddaList.elementAt(index);
            if (AppPreference().getString(PreferencesKey.userId) !=
                muddaPost.leaders!.elementAt(0).acceptUserDetail!.sId) {
              created =
              "Created By - ${muddaPost.leaders!.elementAt(0).acceptUserDetail!.fullname}";
            } else {
              created = "Created By - You";
            }
            if (muddaPost.initialScope!.toLowerCase() == "district") {
              if (muddaPost.leadersCount! >= 10) {
                status = "Approved";
              } else {
                status = "Under Approval";
              }
            } else if (muddaPost.initialScope!.toLowerCase() == "state") {
              if (muddaPost.leadersCount! >= 15 && muddaPost.uniqueCity! >= 3) {
                status = "Approved";
              } else {
                status = "Under Approval";
              }
            } else if (muddaPost.initialScope!.toLowerCase() == "country") {
              if (muddaPost.leadersCount! >= 20 &&
                  muddaPost.uniqueState! >= 3) {
                status = "Approved";
              } else {
                status = "Under Approval";
              }
            } else if (muddaPost.initialScope!.toLowerCase() == "world") {
              if (muddaPost.leadersCount! >= 25 &&
                  muddaPost.uniqueCountry! >= 5) {
                status = "Approved";
              } else {
                status = "Under Approval";
              }
            }
            return InkWell(
              onTap: () {
                if (muddaPost.isVerify == 1) {
                  muddaNewsController!.muddaPost.value = muddaPost;
                  Get.toNamed(RouteConstants.muddaDetailsScreen);
                } else if (muddaPost.isVerify == 0 &&
                    AppPreference().getString(PreferencesKey.userId) ==
                        muddaPost.leaders!.elementAt(0).acceptUserDetail!.sId) {
                  muddaNewsController!.tabController.index = 2;
                  Get.offAllNamed(RouteConstants.homeScreen);
                } else {
                  muddaNewsController!.tabController.index = 2;
                  muddaNewsController!.isFromOtherProfile.value = true;
                  muddaNewsController!
                      .fetchUnapproveMudda(context, muddaPost.sId!);
                  Get.offAllNamed(RouteConstants.homeScreen);
                }
                // Map<String, String>? parameters = {
                //   "muddaId":muddaPost.sId!
                // };
                // Get.toNamed(RouteConstants.shareMuddaScreen,parameters: parameters);
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(ScreenUtil().setSp(8)),
                        child: SizedBox(
                          height: ScreenUtil().setSp(70),
                          width: ScreenUtil().setSp(70),
                          child: CachedNetworkImage(
                            imageUrl:
                            "${searchController!.muddaPath.value}${muddaPost.thumbnail}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(10),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(muddaPost.title!,
                                style: GoogleFonts.nunitoSans(
                                    fontSize: ScreenUtil().setSp(12),
                                    fontWeight: FontWeight.w700,
                                    color: black)),
                            SizedBox(
                              height: ScreenUtil().setSp(10),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(status,
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: ScreenUtil().setSp(12),
                                              fontWeight: FontWeight.w400,
                                              color: buttonYellow)),
                                      Text(created,
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: ScreenUtil().setSp(12),
                                              fontWeight: FontWeight.w400,
                                              color: buttonBlue)),
                                    ],
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setSp(15),
                                ),
                                Text(
                                  NumberFormat.compactCurrency(
                                    decimalDigits: 0,
                                    symbol:
                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  ).format(muddaPost.support),
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: ScreenUtil().setSp(12),
                                      fontWeight: FontWeight.w400,
                                      color: black),
                                ),
                                Image.asset(
                                  AppIcons.handIcon,
                                  height: 20,
                                  width: 20,
                                ),
                                Spacer(),
                                Text(
                                  "${muddaPost.support != 0 ? ((muddaPost.support! * 100) / muddaPost.totalVote!).toStringAsFixed(2) : 0}%",
                                  style: size09_M_bold(textColor: Colors.red),
                                ),
                                const Icon(
                                  Icons.arrow_downward_outlined,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: ScreenUtil().setSp(18),
                                )
                              ],
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setSp(8),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(muddaPost.hashtags!.join(','),
                            style: size10_M_normal(textColor: colorDarkBlack)),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(10),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: colorDarkBlack),
                          ),
                          SizedBox(
                            width: ScreenUtil().setSp(5),
                          ),
                          Text(
                              "${muddaPost.city ?? ""}, ${muddaPost.state ?? ""}, ${muddaPost.country ?? ""}",
                              style:
                              size12_M_normal(textColor: colorDarkBlack)),
                        ],
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(10),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: colorDarkBlack),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(5),
                      ),
                      Text(convertToAgo(DateTime.parse(muddaPost.createdAt!)),
                          style: size10_M_normal(textColor: colorDarkBlack)),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setSp(4),
                  ),
                  Container(
                    height: ScreenUtil().setSp(1),
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            );
          }),
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

class ProfileListWidget extends StatelessWidget {
  const ProfileListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                height: 50.w,
                width: 50.w,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colorWhite, width: 1),
                      image: const DecorationImage(
                          image: NetworkImage(
                              "https://4bgowik9viu406fbr2hsu10z-wpengine.netdna-ssl.com/wp-content/uploads/2020/03/Portrait_5-1.jpg"))),
                )),
            Hs(width: 10.w),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Abdul Rehman Khan Sahab",
                        style: size12_M_regular300(textColor: colorDarkBlack),
                      ),
                      Text(
                        "Follow  ",
                        style: size14_M_normal(textColor: colorA0A0A0),
                      ),
                    ],
                  ),
                  Vs(height: 5.h),
                  Row(
                    children: [
                      Text(
                        "Activist, Social worker / Punjab, India",
                        style: size10_M_regular300(textColor: color606060),
                      ),
                    ],
                  ),
                  Vs(height: 5.h),
                ],
              ),
            ),
          ],
        ),
        Vs(height: 10.h),
        Row(
          children: [
            Container(
              height: 1.h,
              width: 250,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}

class MuddasListWidget extends StatelessWidget {
  MuddasListWidget({this.name});

  String? name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteConstants.muddaDetailsScreen);
      },
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 80.h,
                    width: 80.w,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://assets.entrepreneur.com/content/3x2/2000/20180717194808-GettyImages-805012084.jpeg?auto=webp&quality=95&crop=16:9&width=675",
                          fit: BoxFit.cover,
                        )),
                  ),
                  Container(
                    height: 20.h,
                    width: 30.w,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: colorWhite),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(
                      Icons.play_arrow_outlined,
                      color: colorWhite,
                      size: 20,
                    ),
                  )
                ],
              ),
              Hs(width: 10.w),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "$name",
                      style: size14_M_bold(textColor: color606060),
                    ),
                    Vs(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "1.3B  ",
                          style: size14_M_normal(textColor: colorDarkBlack),
                        ),
                        SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: Image.asset(AppIcons.shakeHandIcon)),
                        Hs(width: 20.w),
                        Column(
                          children: [
                            Container(
                              height: 20.h,
                              width: 20.w,
                              child: const Icon(
                                Icons.arrow_upward_outlined,
                                size: 15,
                                color: colorWhite,
                              ),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: color26C123),
                            ),
                            Vs(height: 2.h),
                            Text(
                              "1.2%",
                              style: size10_M_semibold(textColor: color26C123),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Vs(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("#Political, #Social, #Educational",
                  style: size10_M_normal(textColor: colorDarkBlack)),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: colorDarkBlack),
                  ),
                  Hs(width: 5.w),
                  Text("Lucknow, UP, India",
                      style: size10_M_normal(textColor: colorDarkBlack)),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: colorDarkBlack),
                  ),
                  Hs(width: 5.w),
                  Text("2 days ago",
                      style: size10_M_normal(textColor: colorDarkBlack)),
                ],
              ),
            ],
          ),
          Vs(height: 10.h),
          Row(
            children: [
              Container(
                height: 1.h,
                width: 250,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}