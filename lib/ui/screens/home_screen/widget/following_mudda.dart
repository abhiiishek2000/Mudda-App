import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import '../../../shared/Hot_Mudda_Ad.dart';
import '../../../shared/report_post_dialog_box.dart';
import 'component/hot_mudda_post.dart';
import 'component/loading_view.dart';

class FollowingMudda extends GetView {
  FollowingMudda({
    Key? key,
  }) : super(key: key);

  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  ScrollController muddaScrollController = ScrollController();
  int page = 1;

  @override
  Widget build(BuildContext context) {
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        _getMuddaPost(context);
      }
    });
    return Obx(() => RefreshIndicator(
          onRefresh: () {
            muddaNewsController.followingMuddaPostList.clear();
            page = 1;
            return _getMuddaPost(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setSp(16),
                    bottom: ScreenUtil().setSp(12)),
                child: Text(
                  "Following",
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(14),
                      color: blackGray),
                ),
              ),
              muddaNewsController.followingMuddaPostList.isEmpty
                  ? Expanded(
                      child: Center(
                      child: Text('You haven\'t followed any Mudda as yet.'),
                    ))
                  : Expanded(
                      child: muddaNewsController.isFollowingMuddaLoading.value
                          ? ListView.separated(
                              shrinkWrap: true,
                              itemCount: 4,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 24);
                              },
                              itemBuilder: (context, index) {
                                return HotMuddaLoadingView();
                              })
                          : ListView.builder(
                              shrinkWrap: true,
                              controller: muddaScrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setSp(50)),
                              itemCount: muddaNewsController
                                  .followingMuddaPostList.length,
                              itemBuilder: (followersContext, index) {
                                MuddaPost muddaPost = muddaNewsController
                                    .followingMuddaPostList[index];

                                int muddaCreator = muddaPost.leaders!
                                    .where((element) =>
                                        element.joinerType == 'creator')
                                    .length;
                                int muddaLeader = muddaPost.leaders!
                                    .where((element) =>
                                        element.joinerType == 'leader')
                                    .length;
                                int muddaInitialLeader = muddaPost.leaders!
                                    .where((element) =>
                                        element.joinerType == 'initial_leader')
                                    .length;
                                int muddaOpposition = muddaPost.leaders!
                                    .where((element) =>
                                        element.joinerType == 'opposition')
                                    .length;
                                if (index != 0 && index == 2) {
                                  return Column(
                                    children: [
                                      const HotMuddaAD(),
                                      // SizedBox(height:ScreenUtil().setSp(16)),
                                      HotMuddaPost(
                                          muddaPost: muddaPost,
                                          index: index,
                                          muddaCreator: muddaCreator,
                                          muddaInitialLeader:
                                              muddaInitialLeader,
                                          muddaLeader: muddaLeader,
                                          muddaOpposition: muddaOpposition)
                                    ],
                                  );
                                } else if (index != 0 && (index - 2) % 5 == 0) {
                                  return Column(
                                    children: [
                                      const HotMuddaAD(),
                                      // SizedBox(height:ScreenUtil().setSp(16)),
                                      HotMuddaPost(
                                        muddaPost: muddaPost,
                                        index: index,
                                        muddaCreator: muddaCreator,
                                        muddaInitialLeader: muddaInitialLeader,
                                        muddaLeader: muddaLeader,
                                        muddaOpposition: muddaOpposition,
                                      )
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      HotMuddaPost(
                                          muddaPost: muddaPost,
                                          index: index,
                                          muddaCreator: muddaCreator,
                                          muddaInitialLeader:
                                              muddaInitialLeader,
                                          muddaLeader: muddaLeader,
                                          muddaOpposition: muddaOpposition),

                                      /*index % 5 == 4
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                'To help you serve better...\n',
                                            style: size14_M_normal(
                                              textColor: color606060,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Choose',
                                                style: size14_M_normal(
                                                  textColor: color606060,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' Categories ',
                                                style: size14_M_bold(
                                                  textColor: color202020,
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'of your Choice',
                                                style: size14_M_normal(
                                                  textColor: color606060,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Obx(
                                          () => Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    ScreenUtil().setWidth(20)),
                                            child: GroupButton(
                                              textPadding: EdgeInsets.only(
                                                  left: ScreenUtil().setSp(8),
                                                  right: ScreenUtil().setSp(8)),
                                              runSpacing: ScreenUtil().setSp(9),
                                              groupingType: GroupingType.wrap,
                                              spacing: ScreenUtil().setSp(5),
                                              crossGroupAlignment:
                                                  CrossGroupAlignment.start,
                                              buttonHeight:
                                                  ScreenUtil().setSp(24),
                                              isRadio: false,
                                              direction: Axis.horizontal,
                                              selectedButtons:
                                                  muddaNewsController
                                                      .selectedCategory,
                                              onSelected: (index, ageSelected) {
                                                if (ageSelected &&
                                                    !muddaNewsController
                                                        .selectedCategory
                                                        .contains(index)) {
                                                  muddaNewsController
                                                      .selectedCategory
                                                      .add(index);
                                                } else if (!ageSelected &&
                                                    muddaNewsController
                                                        .selectedCategory
                                                        .contains(index)) {
                                                  muddaNewsController
                                                      .selectedCategory
                                                      .remove(index);
                                                }
                                              },
                                              buttons: muddaNewsController
                                                  .categoryList.value,
                                              selectedTextStyle:
                                                  GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                color: Colors.white,
                                              ),
                                              unselectedTextStyle:
                                                  GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                color: lightGray,
                                              ),
                                              selectedColor: darkGray,
                                              unselectedColor:
                                                  Colors.transparent,
                                              selectedBorderColor: lightGray,
                                              unselectedBorderColor: lightGray,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil().radius(15)),
                                              selectedShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.transparent)
                                              ],
                                              unselectedShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.transparent)
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                List<String> hashtags = [];
                                                List<String> location = [];
                                                List<String> customLocation =
                                                    [];
                                                List<String> locationValues =
                                                    [];
                                                List<String>
                                                    customLocationValues = [];
                                                List<String> gender = [];
                                                List<String> age = [];
                                                for (int index
                                                    in muddaNewsController
                                                        .selectedLocation) {
                                                  location.add(
                                                      muddaNewsController
                                                          .apiLocationList
                                                          .elementAt(index));
                                                  if (index == 0) {
                                                    locationValues.add(
                                                        AppPreference()
                                                            .getString(
                                                                PreferencesKey
                                                                    .city));
                                                  } else if (index == 1) {
                                                    locationValues.add(
                                                        AppPreference()
                                                            .getString(
                                                                PreferencesKey
                                                                    .state));
                                                  } else if (index == 2) {
                                                    locationValues.add(
                                                        AppPreference()
                                                            .getString(
                                                                PreferencesKey
                                                                    .country));
                                                  } else {
                                                    locationValues.add("");
                                                  }
                                                }
                                                for (int index
                                                    in muddaNewsController
                                                        .selectedCategory) {
                                                  hashtags.add(
                                                      muddaNewsController
                                                          .categoryList
                                                          .elementAt(index));
                                                }
                                                for (int index
                                                    in muddaNewsController
                                                        .selectedGender) {
                                                  gender.add(muddaNewsController
                                                      .genderList
                                                      .elementAt(index)
                                                      .toLowerCase());
                                                }
                                                for (int index
                                                    in muddaNewsController
                                                        .selectedAge) {
                                                  age.add(muddaNewsController
                                                      .ageList
                                                      .elementAt(index));
                                                }
                                                if (muddaNewsController
                                                    .selectDistrict
                                                    .value
                                                    .isNotEmpty) {
                                                  customLocation.add(
                                                      muddaNewsController
                                                          .apiLocationList
                                                          .elementAt(0));
                                                  customLocationValues.add(
                                                      muddaNewsController
                                                          .selectDistrict
                                                          .value);
                                                }
                                                if (muddaNewsController
                                                    .selectState
                                                    .value
                                                    .isNotEmpty) {
                                                  customLocation.add(
                                                      muddaNewsController
                                                          .apiLocationList
                                                          .elementAt(1));
                                                  customLocationValues.add(
                                                      muddaNewsController
                                                          .selectState.value);
                                                }
                                                if (muddaNewsController
                                                    .selectCountry
                                                    .value
                                                    .isNotEmpty) {
                                                  customLocation.add(
                                                      muddaNewsController
                                                          .apiLocationList
                                                          .elementAt(2));
                                                  customLocationValues.add(
                                                      muddaNewsController
                                                          .selectCountry.value);
                                                }
                                                Map<String, dynamic> map = {
                                                  "user_id": AppPreference()
                                                      .getString(PreferencesKey
                                                          .userId),
                                                };
                                                if (hashtags.isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "hashtags",
                                                      () =>
                                                          jsonEncode(hashtags));
                                                }
                                                if (location.isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "location_types",
                                                      () =>
                                                          jsonEncode(location));
                                                }
                                                if (locationValues.isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "location_types_values",
                                                      () => jsonEncode(
                                                          locationValues));
                                                }
                                                if (customLocation.isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "custom_location_types",
                                                      () => jsonEncode(
                                                          customLocation));
                                                }
                                                if (customLocationValues
                                                    .isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "custom_location_types_values",
                                                      () => jsonEncode(
                                                          customLocationValues));
                                                }
                                                if (gender.isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "gender_types",
                                                      () => jsonEncode(gender));
                                                }
                                                if (age.isNotEmpty) {
                                                  map.putIfAbsent("age_types",
                                                      () => jsonEncode(age));
                                                }
                                                Api.get.call(context,
                                                    method: "mudda/index",
                                                    param: map,
                                                    isLoading: true,
                                                    onResponseSuccess:
                                                        (Map object) {
                                                  var result =
                                                      MuddaPostModel.fromJson(
                                                          object);
                                                  if (result.data!.isNotEmpty) {
                                                    muddaNewsController
                                                        .muddaProfilePath
                                                        .value = result.path!;
                                                    muddaNewsController
                                                            .muddaUserProfilePath
                                                            .value =
                                                        result.userpath!;
                                                    muddaNewsController
                                                        .muddaPostList
                                                        .clear();
                                                    muddaNewsController
                                                        .muddaPostList
                                                        .addAll(result.data!);
                                                    Get.back();
                                                  } else {
                                                    showDialog<void>(
                                                      context: Get.context!,
                                                      barrierDismissible: false,
                                                      // user must tap button!
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                              result.message!,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: const Text(
                                                                  'OK'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                });
                                              },
                                              child: Stack(
                                                alignment: Alignment.centerLeft,
                                                children: [
                                                  Container(
                                                    width:
                                                        ScreenUtil().setSp(70),
                                                    height:
                                                        ScreenUtil().setSp(25),
                                                    margin: EdgeInsets.only(
                                                        right: ScreenUtil()
                                                            .setSp(17),
                                                        top: ScreenUtil()
                                                            .setSp(2.5),
                                                        bottom: ScreenUtil()
                                                            .setSp(2.5)),
                                                    decoration: BoxDecoration(
                                                      color: colorWhite,
                                                      border: Border.all(
                                                          color: color606060),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              ScreenUtil()
                                                                  .setSp(8)),
                                                    ),
                                                    child: Center(
                                                      child: Text("Apply",
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
                                                                      black)),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 1,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: ScreenUtil()
                                                          .setSp(30),
                                                      width: ScreenUtil()
                                                          .setSp(30),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              2),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: colorWhite,
                                                          border: Border.all(
                                                              color:
                                                                  color606060)),
                                                      child: const Icon(
                                                        Icons
                                                            .chevron_right_rounded,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  )
                                : SizedBox(),*/
                                    ],
                                  );
                                }
                                // return muddaPost.isVerify == 0 || muddaPost.isVerify == 3
                                //     ? Container(
                                //         margin: EdgeInsets.only(
                                //             left: ScreenUtil().setSp(5),
                                //             right: ScreenUtil().setSp(5),
                                //             bottom: ScreenUtil().setSp(32)),
                                //         padding: EdgeInsets.symmetric(
                                //             horizontal: ScreenUtil().setSp(10),
                                //             vertical: ScreenUtil().setSp(12)),
                                //         decoration: BoxDecoration(
                                //           color: colorWhite,
                                //           borderRadius: BorderRadius.circular(
                                //               ScreenUtil().setSp(8)),
                                //           boxShadow: [
                                //             BoxShadow(
                                //               color: colorBlack.withOpacity(0.25),
                                //               offset: const Offset(
                                //                 0.0,
                                //                 4.0,
                                //               ),
                                //               blurRadius: 4,
                                //               spreadRadius: 0.8,
                                //             ), //BoxShadow//BoxShadow
                                //           ],
                                //         ),
                                //         child: Column(
                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                //           children: [
                                //             Row(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 Stack(
                                //                   alignment: Alignment.center,
                                //                   children: [
                                //                     GestureDetector(
                                //                       onTap: () {
                                //                         muddaGalleryDialog(
                                //                             context,
                                //                             muddaPost.gallery!,
                                //                             muddaNewsController
                                //                                 .muddaProfilePath.value,
                                //                             0);
                                //                       },
                                //                       child: ClipRRect(
                                //                         borderRadius:
                                //                             BorderRadius.circular(
                                //                                 ScreenUtil().setSp(8)),
                                //                         child: SizedBox(
                                //                           height: ScreenUtil().setSp(80),
                                //                           width: ScreenUtil().setSp(80),
                                //                           child: CachedNetworkImage(
                                //                             imageUrl:
                                //                                 "${muddaNewsController.muddaProfilePath.value}${muddaPost.thumbnail}",
                                //                             fit: BoxFit.cover,
                                //                           ),
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ],
                                //                 ),
                                //                 SizedBox(
                                //                   width: ScreenUtil().setSp(8),
                                //                 ),
                                //                 Expanded(
                                //                   child: Column(
                                //                     crossAxisAlignment:
                                //                         CrossAxisAlignment.start,
                                //                     children: [
                                //                       Text(
                                //                         muddaPost.title!,
                                //                         style: GoogleFonts.nunitoSans(
                                //                             fontSize:
                                //                                 ScreenUtil().setSp(14),
                                //                             fontWeight: FontWeight.w700,
                                //                             color: black),
                                //                       ),
                                //                       SizedBox(
                                //                         height: ScreenUtil().setSp(5),
                                //                       ),
                                //                       Row(
                                //                         mainAxisAlignment:
                                //                             MainAxisAlignment
                                //                                 .spaceBetween,
                                //                         children: [
                                //                           Expanded(
                                //                             child: Wrap(
                                //                               children: [
                                //                                 Text(
                                //                                     muddaPost.initialScope!
                                //                                                 .toLowerCase() ==
                                //                                             "district"
                                //                                         ? muddaPost.city!
                                //                                         : muddaPost.initialScope!
                                //                                                     .toLowerCase() ==
                                //                                                 "state"
                                //                                             ? muddaPost
                                //                                                 .state!
                                //                                             : muddaPost.initialScope!
                                //                                                         .toLowerCase() ==
                                //                                                     "country"
                                //                                                 ? muddaPost
                                //                                                     .country!
                                //                                                 : muddaPost
                                //                                                     .initialScope!,
                                //                                     style: GoogleFonts.nunitoSans(
                                //                                         fontSize:
                                //                                             ScreenUtil()
                                //                                                 .setSp(
                                //                                                     12),
                                //                                         fontWeight:
                                //                                             FontWeight
                                //                                                 .w700,
                                //                                         color: black)),
                                //                               ],
                                //                             ),
                                //                           ),
                                //                           // Column(
                                //                           //   children: [
                                //                           //     RichText(
                                //                           //       text: TextSpan(
                                //                           //         text: 'Joined by ',
                                //                           //         style: size14_M_normal(
                                //                           //           textColor:
                                //                           //               color202020,
                                //                           //         ),
                                //                           //         children: <TextSpan>[
                                //                           //           TextSpan(
                                //                           //             text: '5/11',
                                //                           //             style:
                                //                           //                 size14_M_bold(
                                //                           //               textColor:
                                //                           //                   color202020,
                                //                           //             ),
                                //                           //           ),
                                //                           //         ],
                                //                           //       ),
                                //                           //     ),
                                //                           //     RichText(
                                //                           //       text: TextSpan(
                                //                           //         text: 'From ',
                                //                           //         style: size14_M_normal(
                                //                           //           textColor:
                                //                           //               color202020,
                                //                           //         ),
                                //                           //         children: <TextSpan>[
                                //                           //           TextSpan(
                                //                           //             text: '0 district',
                                //                           //             style:
                                //                           //                 size14_M_bold(
                                //                           //               textColor:
                                //                           //                   color202020,
                                //                           //             ),
                                //                           //           ),
                                //                           //         ],
                                //                           //       ),
                                //                           //     ),
                                //                           //   ],
                                //                           // ),
                                //                           Column(
                                //                             children: [
                                //                               Text.rich(
                                //                                 TextSpan(
                                //                                   children: <TextSpan>[
                                //                                     TextSpan(
                                //                                       text: "Joined by",
                                //                                       style: GoogleFonts.nunitoSans(
                                //                                           fontWeight:
                                //                                               FontWeight
                                //                                                   .w400,
                                //                                           color: black,
                                //                                           fontSize:
                                //                                               ScreenUtil()
                                //                                                   .setSp(
                                //                                                       12)),
                                //                                     ),
                                //                                     TextSpan(
                                //                                         text:
                                //                                             " ${NumberFormat.compactCurrency(
                                //                                           decimalDigits:
                                //                                               0,
                                //                                           symbol:
                                //                                               '', // if you want to add currency symbol then pass that in this else leave it empty.
                                //                                         ).format(muddaPost.joinersCount! + 1 ?? 0)} / ${muddaPost.initialScope!.toLowerCase() == "district" ? "11" : muddaPost.initialScope!.toLowerCase() == "state" ? "15" : muddaPost.initialScope!.toLowerCase() == "country" ? "20" : "25"}",
                                //                                         style: GoogleFonts.nunitoSans(
                                //                                             fontWeight:
                                //                                                 FontWeight
                                //                                                     .w700,
                                //                                             fontSize:
                                //                                                 ScreenUtil()
                                //                                                     .setSp(
                                //                                                         12),
                                //                                             color:
                                //                                                 black)),
                                //                                   ],
                                //                                 ),
                                //                               ),
                                //                               muddaPost.initialScope!
                                //                                           .toLowerCase() !=
                                //                                       "district"
                                //                                   ? Text.rich(TextSpan(
                                //                                       children: <
                                //                                           TextSpan>[
                                //                                           TextSpan(
                                //                                               text:
                                //                                                   "From",
                                //                                               style: GoogleFonts.nunitoSans(
                                //                                                   fontWeight:
                                //                                                       FontWeight
                                //                                                           .w400,
                                //                                                   color:
                                //                                                       black,
                                //                                                   fontSize:
                                //                                                       ScreenUtil().setSp(12))),
                                //                                           TextSpan(
                                //                                               text:
                                //                                                   " ${muddaPost.initialScope == "country" ? muddaPost.uniqueState! : muddaPost.initialScope == "state" ? muddaPost.uniqueCity! : muddaPost.uniqueCountry!}/${muddaPost.initialScope == "country" ? "3 states" : muddaPost.initialScope == "state" ? "3 districts" : "5 countries"}",
                                //                                               style: GoogleFonts.nunitoSans(
                                //                                                   fontWeight:
                                //                                                       FontWeight
                                //                                                           .w700,
                                //                                                   fontSize:
                                //                                                       ScreenUtil().setSp(
                                //                                                           12),
                                //                                                   color:
                                //                                                       black)),
                                //                                         ]))
                                //                                   : Text.rich(
                                //                                       TextSpan(children: [
                                //                                       TextSpan(
                                //                                           text: "From",
                                //                                           style: GoogleFonts.nunitoSans(
                                //                                               fontWeight:
                                //                                                   FontWeight
                                //                                                       .w400,
                                //                                               color:
                                //                                                   black,
                                //                                               fontSize: ScreenUtil()
                                //                                                   .setSp(
                                //                                                       12))),
                                //                                       TextSpan(
                                //                                           text:
                                //                                               " 0 district",
                                //                                           style: GoogleFonts.nunitoSans(
                                //                                               fontWeight:
                                //                                                   FontWeight
                                //                                                       .w700,
                                //                                               fontSize: ScreenUtil()
                                //                                                   .setSp(
                                //                                                       12),
                                //                                               color:
                                //                                                   black))
                                //                                     ])),
                                //                             ],
                                //                           ),
                                //                           SizedBox(
                                //                             width: ScreenUtil().setSp(16),
                                //                           ),
                                //                           GestureDetector(
                                //                             onTap: (){
                                //                               Share.share(
                                //                                 '${Const.shareUrl}mudda/${muddaPost.sId!}',
                                //                               );
                                //                             },
                                //                             child: Image.asset(AppIcons.shareIcon,
                                //                                 height: 20, width: 20),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //             const Vs(height: 10),
                                //             Row(
                                //               mainAxisAlignment: MainAxisAlignment.end,
                                //               children: [
                                //                 InkWell(
                                //                   onTap: () {
                                //                     if (AppPreference().getBool(
                                //                         PreferencesKey.isGuest)) {
                                //                       Get.toNamed(
                                //                           RouteConstants.userProfileEdit);
                                //                     } else {
                                //                       Api.post.call(
                                //                         context,
                                //                         method: "mudda/reaction-on-mudda",
                                //                         param: {
                                //                           "user_id": AppPreference()
                                //                               .getString(
                                //                                   PreferencesKey.userId),
                                //                           "joining_content_id":
                                //                               muddaPost.sId,
                                //                           "action_type": "follow",
                                //                         },
                                //                         onResponseSuccess: (object) {
                                //                           muddaPost.afterMe =
                                //                               object['data'] != null
                                //                                   ? AfterMe.fromJson(
                                //                                       object['data'])
                                //                                   : null;
                                //                           muddaPost.amIfollowing =
                                //                               muddaPost.amIfollowing == 1
                                //                                   ? 0
                                //                                   : 1;
                                //                           muddaNewsController
                                //                                   .followingMuddaPostList[
                                //                               index] = muddaPost;
                                //                           muddaNewsController
                                //                               .muddaActionIndex
                                //                               .value = index;
                                //                         },
                                //                       );
                                //                     }
                                //                   },
                                //                   child: Row(
                                //                     children: [
                                //                       const Hs(width: 10),
                                //                       Container(
                                //                         padding: const EdgeInsets.all(2),
                                //                         decoration: const BoxDecoration(
                                //                             shape: BoxShape.circle,
                                //                             color: colorDarkBlack),
                                //                       ),
                                //                       const Hs(width: 5),
                                //                       Text(
                                //                           muddaPost.amIfollowing == 0
                                //                               ? "Follow"
                                //                               : "Following",
                                //                           style: size12_M_normal(
                                //                               textColor: colorDarkBlack)),
                                //                     ],
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //             const Vs(height: 20),
                                //             SizedBox(
                                //               height: ScreenUtil().setSp(65),
                                //               child: Row(
                                //                 children: [
                                //                   Expanded(
                                //                     child: GridView.count(
                                //                       crossAxisCount: 5,
                                //                       shrinkWrap: true,
                                //                       physics:
                                //                           const NeverScrollableScrollPhysics(),
                                //                       padding: EdgeInsets.only(
                                //                           left: ScreenUtil().setSp(2.5),
                                //                           right: ScreenUtil().setSp(2.5)),
                                //                       children: List.generate(
                                //                           muddaPost.leaders != null
                                //                               ? /*muddaPost.leaders!.length >= 5
                                //                                   ? 5
                                //                                   :*/
                                //                               muddaPost.leaders!.length
                                //                               : 0, (index) {
                                //                         String path =
                                //                             "${muddaNewsController.muddaUserProfilePath.value}${muddaPost.leaders![index].acceptUserDetail!.profile ?? ""}";
                                //                         return GestureDetector(
                                //                           onTap: () {
                                //                             if (muddaPost.leaders![index]
                                //                                     .userIdentity ==
                                //                                 1) {
                                //                               muddaNewsController
                                //                                       .acceptUserDetail
                                //                                       .value =
                                //                                   muddaPost
                                //                                       .leaders![index]
                                //                                       .acceptUserDetail!;
                                //                               if (muddaPost
                                //                                       .leaders![index]
                                //                                       .acceptUserDetail!
                                //                                       .sId ==
                                //                                   AppPreference()
                                //                                       .getString(
                                //                                           PreferencesKey
                                //                                               .userId)) {
                                //                                 Get.toNamed(RouteConstants
                                //                                     .profileScreen);
                                //                               } else {
                                //                                 Map<String, String>?
                                //                                     parameters = {
                                //                                   "userDetail":
                                //                                       jsonEncode(muddaPost
                                //                                           .leaders![index]
                                //                                           .acceptUserDetail!)
                                //                                 };
                                //                                 Get.toNamed(
                                //                                     RouteConstants
                                //                                         .otherUserProfileScreen,
                                //                                     parameters:
                                //                                         parameters);
                                //                               }
                                //                             } else {
                                //                               anynymousDialogBox(context);
                                //                             }
                                //                           },
                                //                           child: Column(
                                //                             mainAxisSize:
                                //                                 MainAxisSize.min,
                                //                             children: [
                                //                               muddaPost.leaders![index]
                                //                                           .userIdentity ==
                                //                                       0
                                //                                   ? Container(
                                //                                       height: ScreenUtil()
                                //                                           .setSp(40),
                                //                                       width: ScreenUtil()
                                //                                           .setSp(40),
                                //                                       decoration:
                                //                                           BoxDecoration(
                                //                                         border:
                                //                                             Border.all(
                                //                                           color: darkGray,
                                //                                         ),
                                //                                         shape: BoxShape
                                //                                             .circle,
                                //                                       ),
                                //                                       child: Center(
                                //                                         child: Text("A",
                                //                                             style: GoogleFonts.nunitoSans(
                                //                                                 fontWeight:
                                //                                                     FontWeight
                                //                                                         .w400,
                                //                                                 fontSize: ScreenUtil()
                                //                                                     .setSp(
                                //                                                         20),
                                //                                                 color:
                                //                                                     black)),
                                //                                       ),
                                //                                     )
                                //                                   : muddaPost
                                //                                               .leaders![
                                //                                                   index]
                                //                                               .acceptUserDetail!
                                //                                               .profile !=
                                //                                           null
                                //                                       ? CachedNetworkImage(
                                //                                           imageUrl: path,
                                //                                           imageBuilder:
                                //                                               (context,
                                //                                                       imageProvider) =>
                                //                                                   Container(
                                //                                             width: ScreenUtil()
                                //                                                 .setSp(
                                //                                                     40),
                                //                                             height:
                                //                                                 ScreenUtil()
                                //                                                     .setSp(
                                //                                                         40),
                                //                                             decoration:
                                //                                                 BoxDecoration(
                                //                                               color:
                                //                                                   colorWhite,
                                //                                               border:
                                //                                                   Border
                                //                                                       .all(
                                //                                                 width: ScreenUtil()
                                //                                                     .setSp(
                                //                                                         1),
                                //                                                 color: muddaPost.leaders![index].joinerType! ==
                                //                                                         "creator"
                                //                                                     ? buttonBlue
                                //                                                     : muddaPost.leaders![index].joinerType! == "opposition"
                                //                                                         ? buttonYellow
                                //                                                         : white,
                                //                                               ),
                                //                                               borderRadius:
                                //                                                   BorderRadius.all(
                                //                                                       Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
                                //                                                       ),
                                //                                               image: DecorationImage(
                                //                                                   image:
                                //                                                       imageProvider,
                                //                                                   fit: BoxFit
                                //                                                       .cover),
                                //                                             ),
                                //                                           ),
                                //                                           placeholder: (context,
                                //                                                   url) =>
                                //                                               CircleAvatar(
                                //                                             backgroundColor:
                                //                                                 lightGray,
                                //                                             radius:
                                //                                                 ScreenUtil()
                                //                                                     .setSp(
                                //                                                         20),
                                //                                           ),
                                //                                           errorWidget: (context,
                                //                                                   url,
                                //                                                   error) =>
                                //                                               CircleAvatar(
                                //                                             backgroundColor:
                                //                                                 lightGray,
                                //                                             radius:
                                //                                                 ScreenUtil()
                                //                                                     .setSp(
                                //                                                         20),
                                //                                           ),
                                //                                         )
                                //                                       : Container(
                                //                                           height:
                                //                                               ScreenUtil()
                                //                                                   .setSp(
                                //                                                       40),
                                //                                           width:
                                //                                               ScreenUtil()
                                //                                                   .setSp(
                                //                                                       40),
                                //                                           decoration:
                                //                                               BoxDecoration(
                                //                                             border: Border
                                //                                                 .all(
                                //                                               color:
                                //                                                   darkGray,
                                //                                             ),
                                //                                             shape: BoxShape
                                //                                                 .circle,
                                //                                           ),
                                //                                           child: Center(
                                //                                             child: Text(
                                //                                                 muddaPost
                                //                                                     .leaders![
                                //                                                         index]
                                //                                                     .acceptUserDetail!
                                //                                                     .fullname![
                                //                                                         0]
                                //                                                     .toUpperCase(),
                                //                                                 style: GoogleFonts.nunitoSans(
                                //                                                     fontWeight: FontWeight
                                //                                                         .w400,
                                //                                                     fontSize: ScreenUtil().setSp(
                                //                                                         20),
                                //                                                     color:
                                //                                                         black)),
                                //                                           ),
                                //                                         ),
                                //                               Vs(height: 5.h),
                                //                               Text(
                                //                                 muddaPost.leaders![index]
                                //                                             .userIdentity ==
                                //                                         1
                                //                                     ? "${muddaPost.leaders![index].acceptUserDetail!.fullname}"
                                //                                     : "Anynymous",
                                //                                 style: size10_M_regular300(
                                //                                     letterSpacing: 0.0,
                                //                                     textColor:
                                //                                         colorDarkBlack),
                                //                                 textAlign:
                                //                                     TextAlign.center,
                                //                               ),
                                //                             ],
                                //                           ),
                                //                         );
                                //                       }),
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //             Container(
                                //               width: double.infinity,
                                //               height: 1,
                                //               color: colorF2F2F2,
                                //               margin: const EdgeInsets.only(
                                //                   top: 10, bottom: 5),
                                //             ),
                                //             Text(
                                //               "Description:",
                                //               style:
                                //                   size14_M_bold(textColor: color606060),
                                //             ),
                                //             Text(
                                //               muddaPost.muddaDescription!,
                                //               style: GoogleFonts.nunitoSans(
                                //                   fontSize: ScreenUtil().setSp(12),
                                //                   fontWeight: FontWeight.w400,
                                //                   color: black),
                                //             ),
                                //             const Vs(height: 8),
                                //             Text(
                                //               "Photo / Video:",
                                //               style:
                                //                   size14_M_bold(textColor: color606060),
                                //             ),
                                //             Container(
                                //               width: double.infinity,
                                //               height: 1,
                                //               color: colorF2F2F2,
                                //               margin: const EdgeInsets.only(
                                //                   bottom: 8, top: 2),
                                //             ),
                                //             muddaPost.gallery == null
                                //                 ? SizedBox()
                                //                 : Container(
                                //                     height: 100,
                                //                     child: ListView.builder(
                                //                       shrinkWrap: true,
                                //                       itemCount:
                                //                           muddaPost.gallery!.length,
                                //                       scrollDirection: Axis.horizontal,
                                //                       itemBuilder: (_, imageIndex) {
                                //                         return Container(
                                //                           width: 100,
                                //                           height: 100,
                                //                           decoration: BoxDecoration(
                                //                             color: colorAppBackground,
                                //                             borderRadius: BorderRadius
                                //                                 .only(
                                //                                     topLeft: Radius
                                //                                         .circular(
                                //                                             ScreenUtil()
                                //                                                 .setSp(
                                //                                                     8)),
                                //                                     bottomLeft: Radius
                                //                                         .circular(
                                //                                             ScreenUtil()
                                //                                                 .setSp(
                                //                                                     8))),
                                //                           ),
                                //                           child: CachedNetworkImage(
                                //                             // imageUrl: "${muddaPost.gallery![imageIndex].path}${muddaPost.gallery![imageIndex].file}",
                                //                             imageUrl: "${muddaNewsController.muddaProfilePath.value}${muddaPost.gallery![imageIndex].file}",
                                //                             fit: BoxFit.cover,
                                //                           ),
                                //                         );
                                //                       },
                                //                     ),
                                //                   ),
                                //             Container(
                                //               width: double.infinity,
                                //               height: 1,
                                //               color: colorF2F2F2,
                                //               margin: const EdgeInsets.only(
                                //                   top: 8, bottom: 5),
                                //             ),
                                //             Row(
                                //               children: [
                                //                 Expanded(
                                //                   child: Text(
                                //                       muddaPost.hashtags!.join(','),
                                //                       style: size10_M_normal(
                                //                           textColor: colorDarkBlack)),
                                //                 ),
                                //                 const Hs(width: 10),
                                //                 Row(
                                //                   children: [
                                //                     Container(
                                //                       padding: const EdgeInsets.all(2),
                                //                       decoration: const BoxDecoration(
                                //                           shape: BoxShape.circle,
                                //                           color: colorDarkBlack),
                                //                     ),
                                //                     const Hs(width: 5),
                                //                     Text(
                                //                         "${muddaPost.city ?? ""}, ${muddaPost.state ?? ""}, ${muddaPost.country ?? ""}",
                                //                         style: size12_M_normal(
                                //                             textColor: colorDarkBlack)),
                                //                   ],
                                //                 ),
                                //                 const Hs(width: 10),
                                //                 Container(
                                //                   padding: const EdgeInsets.all(2),
                                //                   decoration: const BoxDecoration(
                                //                       shape: BoxShape.circle,
                                //                       color: colorDarkBlack),
                                //                 ),
                                //                 const Hs(width: 5),
                                //                 Text(
                                //                     convertToAgo(DateTime.parse(
                                //                         muddaPost.createdAt!)),
                                //                     style: size10_M_normal(
                                //                         textColor: colorDarkBlack)),
                                //               ],
                                //             ),
                                //           ],
                                //         ),
                                //       )
                                //     : GestureDetector(
                                //         onTap: () {
                                //           muddaNewsController.muddaPost.value = muddaPost;
                                //           muddaNewsController.muddaActionIndex.value =
                                //               index;
                                //           Get.toNamed(RouteConstants.muddaDetailsScreen);
                                //         },
                                //         child: Container(
                                //           margin: EdgeInsets.only(
                                //               left: ScreenUtil().setSp(5),
                                //               right: ScreenUtil().setSp(5),
                                //               bottom: ScreenUtil().setSp(32)),
                                //           padding: EdgeInsets.symmetric(
                                //               horizontal: ScreenUtil().setSp(10),
                                //               vertical: ScreenUtil().setSp(12)),
                                //           decoration: BoxDecoration(
                                //             color: colorWhite,
                                //             borderRadius: BorderRadius.circular(
                                //                 ScreenUtil().setSp(8)),
                                //             boxShadow: [
                                //               BoxShadow(
                                //                 color: colorBlack.withOpacity(0.25),
                                //                 offset: const Offset(
                                //                   0.0,
                                //                   4.0,
                                //                 ),
                                //                 blurRadius: 4,
                                //                 spreadRadius: 0.8,
                                //               ), //BoxShadow//BoxShadow
                                //             ],
                                //           ),
                                //           child: Column(
                                //             children: [
                                //               Row(
                                //                 crossAxisAlignment:
                                //                     CrossAxisAlignment.start,
                                //                 children: [
                                //                   Stack(
                                //                     alignment: Alignment.center,
                                //                     children: [
                                //                       GestureDetector(
                                //                         onTap: () {
                                //                           muddaGalleryDialog(
                                //                               context,
                                //                               muddaPost.gallery!,
                                //                               muddaNewsController
                                //                                   .muddaProfilePath.value,
                                //                               0);
                                //                         },
                                //                         child: ClipRRect(
                                //                           borderRadius:
                                //                               BorderRadius.circular(
                                //                                   ScreenUtil().setSp(8)),
                                //                           child: SizedBox(
                                //                             height:
                                //                                 ScreenUtil().setSp(80),
                                //                             width: ScreenUtil().setSp(80),
                                //                             child: CachedNetworkImage(
                                //                               imageUrl:
                                //                                   "${muddaNewsController.muddaProfilePath.value}${muddaPost.thumbnail}",
                                //                               fit: BoxFit.cover,
                                //                             ),
                                //                           ),
                                //                         ),
                                //                       ),
                                //                       /*Container(
                                //               padding: EdgeInsets.symmetric(horizontal: 4.w),
                                //               decoration: BoxDecoration(
                                //                   border: Border.all(color: colorWhite),
                                //                   borderRadius: BorderRadius.circular(5)),
                                //               child: const Icon(
                                //                 Icons.play_arrow_outlined,
                                //                 color: colorWhite,
                                //               ),
                                //             )*/
                                //                     ],
                                //                   ),
                                //                   SizedBox(
                                //                     width: ScreenUtil().setSp(8),
                                //                   ),
                                //                   Expanded(
                                //                     child: Column(
                                //                       crossAxisAlignment:
                                //                           CrossAxisAlignment.start,
                                //                       children: [
                                //                         Text(muddaPost.title!,
                                //                             style: GoogleFonts.nunitoSans(
                                //                                 fontSize: ScreenUtil()
                                //                                     .setSp(14),
                                //                                 fontWeight:
                                //                                     FontWeight.w700,
                                //                                 color: black)),
                                //                         Row(
                                //                           mainAxisAlignment:
                                //                               MainAxisAlignment
                                //                                   .spaceBetween,
                                //                           children: [
                                //                             Expanded(
                                //                               child: Wrap(
                                //                                 children: [
                                //                                   Text(
                                //                                       muddaPost.initialScope!
                                //                                                   .toLowerCase() ==
                                //                                               "district"
                                //                                           ? muddaPost
                                //                                               .city!
                                //                                           : muddaPost
                                //                                                       .initialScope!
                                //                                                       .toLowerCase() ==
                                //                                                   "state"
                                //                                               ? muddaPost
                                //                                                   .state!
                                //                                               : muddaPost.initialScope!.toLowerCase() ==
                                //                                                       "country"
                                //                                                   ? muddaPost
                                //                                                       .country!
                                //                                                   : muddaPost
                                //                                                       .initialScope!,
                                //                                       style: GoogleFonts.nunitoSans(
                                //                                           fontSize:
                                //                                               ScreenUtil()
                                //                                                   .setSp(
                                //                                                       12),
                                //                                           fontWeight:
                                //                                               FontWeight
                                //                                                   .w700,
                                //                                           color: black)),
                                //                                 ],
                                //                               ),
                                //                             ),
                                //                             SizedBox(
                                //                               width:
                                //                                   ScreenUtil().setSp(10),
                                //                             ),
                                //                             Row(
                                //                               children: [
                                //                                 Text(
                                //                                     "${muddaPost.support != 0 ? ((muddaPost.support! * 100) / muddaPost.totalVote!).toStringAsFixed(2) : 0}% / ${NumberFormat.compactCurrency(
                                //                                       decimalDigits: 0,
                                //                                       symbol:
                                //                                           '', // if you want to add currency symbol then pass that in this else leave it empty.
                                //                                     ).format(muddaPost.support)}",
                                //                                     style: size12_M_bold(
                                //                                             textColor:
                                //                                                 color0060FF)
                                //                                         .copyWith(
                                //                                             height: 1.8)),
                                //                                 const Hs(
                                //                                   width: 10,
                                //                                 ),
                                //                                 Image.asset(
                                //                                   AppIcons.bluehandsheck,
                                //                                   height: 20,
                                //                                   width: 20,
                                //                                 ),
                                //                                 InkWell(
                                //                                   onTap: () {
                                //                                     if (AppPreference()
                                //                                         .getBool(
                                //                                             PreferencesKey
                                //                                                 .isGuest)) {
                                //                                       Get.toNamed(
                                //                                           RouteConstants
                                //                                               .userProfileEdit);
                                //                                     } else {
                                //                                       Api.post.call(
                                //                                         context,
                                //                                         method:
                                //                                             "mudda/reaction-on-mudda",
                                //                                         param: {
                                //                                           "user_id": AppPreference()
                                //                                               .getString(
                                //                                                   PreferencesKey
                                //                                                       .userId),
                                //                                           "joining_content_id":
                                //                                               muddaPost
                                //                                                   .sId,
                                //                                           "action_type":
                                //                                               "follow",
                                //                                         },
                                //                                         onResponseSuccess:
                                //                                             (object) {
                                //                                           muddaPost
                                //                                               .afterMe = object[
                                //                                                       'data'] !=
                                //                                                   null
                                //                                               ? AfterMe.fromJson(
                                //                                                   object[
                                //                                                       'data'])
                                //                                               : null;
                                //                                           muddaPost
                                //                                                   .amIfollowing =
                                //                                               muddaPost.amIfollowing ==
                                //                                                       1
                                //                                                   ? 0
                                //                                                   : 1;
                                //                                           muddaNewsController
                                //                                                       .followingMuddaPostList[
                                //                                                   index] =
                                //                                               muddaPost;
                                //                                           muddaNewsController
                                //                                               .muddaActionIndex
                                //                                               .value = index;
                                //                                         },
                                //                                       );
                                //                                     }
                                //                                   },
                                //                                   child: Row(
                                //                                     children: [
                                //                                       const Hs(width: 10),
                                //                                       Container(
                                //                                         padding:
                                //                                             const EdgeInsets
                                //                                                 .all(2),
                                //                                         decoration: const BoxDecoration(
                                //                                             shape: BoxShape
                                //                                                 .circle,
                                //                                             color:
                                //                                                 colorDarkBlack),
                                //                                       ),
                                //                                       const Hs(width: 5),
                                //                                       Text(
                                //                                           muddaPost.amIfollowing ==
                                //                                                   0
                                //                                               ? "Follow"
                                //                                               : "Following",
                                //                                           style: size12_M_normal(
                                //                                               textColor:
                                //                                                   colorDarkBlack)),
                                //                                     ],
                                //                                   ),
                                //                                 )
                                //                               ],
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //               const Vs(height: 10),
                                //               SizedBox(
                                //                 height: ScreenUtil().setSp(65),
                                //                 child: Row(
                                //                   children: [
                                //                     Expanded(
                                //                       child: GridView.count(
                                //                         crossAxisCount: 4,
                                //                         shrinkWrap: true,
                                //                         physics:
                                //                             const NeverScrollableScrollPhysics(),
                                //                         padding: EdgeInsets.only(
                                //                             left: ScreenUtil().setSp(2.5),
                                //                             right:
                                //                                 ScreenUtil().setSp(2.5)),
                                //                         children: List.generate(
                                //                             muddaPost.leaders != null
                                //                                 ? muddaPost.leaders!
                                //                                             .length >=
                                //                                         4
                                //                                     ? 4
                                //                                     : muddaPost
                                //                                         .leaders!.length
                                //                                 : 0, (index) {
                                //                           String path =
                                //                               "${muddaNewsController.muddaUserProfilePath.value}${muddaPost.leaders![index].acceptUserDetail!.profile ?? ""}";
                                //                           return GestureDetector(
                                //                             onTap: () {
                                //                               if (muddaPost
                                //                                       .leaders![index]
                                //                                       .userIdentity ==
                                //                                   1) {
                                //                                 muddaNewsController
                                //                                         .acceptUserDetail
                                //                                         .value =
                                //                                     muddaPost
                                //                                         .leaders![index]
                                //                                         .acceptUserDetail!;
                                //                                 if (muddaPost
                                //                                         .leaders![index]
                                //                                         .acceptUserDetail!
                                //                                         .sId ==
                                //                                     AppPreference()
                                //                                         .getString(
                                //                                             PreferencesKey
                                //                                                 .userId)) {
                                //                                   Get.toNamed(
                                //                                       RouteConstants
                                //                                           .profileScreen);
                                //                                 } else {
                                //                                   Map<String, String>?
                                //                                       parameters = {
                                //                                     "userDetail":
                                //                                         jsonEncode(muddaPost
                                //                                             .leaders![
                                //                                                 index]
                                //                                             .acceptUserDetail!)
                                //                                   };
                                //                                   Get.toNamed(
                                //                                       RouteConstants
                                //                                           .otherUserProfileScreen,
                                //                                       parameters:
                                //                                           parameters);
                                //                                 }
                                //                               } else {
                                //                                 anynymousDialogBox(
                                //                                     context);
                                //                               }
                                //                             },
                                //                             child: Column(
                                //                               mainAxisSize:
                                //                                   MainAxisSize.min,
                                //                               children: [
                                //                                 muddaPost.leaders![index]
                                //                                             .userIdentity ==
                                //                                         0
                                //                                     ? Container(
                                //                                         height:
                                //                                             ScreenUtil()
                                //                                                 .setSp(
                                //                                                     40),
                                //                                         width:
                                //                                             ScreenUtil()
                                //                                                 .setSp(
                                //                                                     40),
                                //                                         decoration:
                                //                                             BoxDecoration(
                                //                                           border:
                                //                                               Border.all(
                                //                                             color:
                                //                                                 darkGray,
                                //                                           ),
                                //                                           shape: BoxShape
                                //                                               .circle,
                                //                                         ),
                                //                                         child: Center(
                                //                                           child: Text("A",
                                //                                               style: GoogleFonts.nunitoSans(
                                //                                                   fontWeight:
                                //                                                       FontWeight
                                //                                                           .w400,
                                //                                                   fontSize:
                                //                                                       ScreenUtil().setSp(
                                //                                                           20),
                                //                                                   color:
                                //                                                       black)),
                                //                                         ),
                                //                                       )
                                //                                     : muddaPost
                                //                                                 .leaders![
                                //                                                     index]
                                //                                                 .acceptUserDetail!
                                //                                                 .profile !=
                                //                                             null
                                //                                         ? CachedNetworkImage(
                                //                                             imageUrl:
                                //                                                 path,
                                //                                             imageBuilder:
                                //                                                 (context,
                                //                                                         imageProvider) =>
                                //                                                     Container(
                                //                                               width: ScreenUtil()
                                //                                                   .setSp(
                                //                                                       40),
                                //                                               height: ScreenUtil()
                                //                                                   .setSp(
                                //                                                       40),
                                //                                               decoration:
                                //                                                   BoxDecoration(
                                //                                                 color:
                                //                                                     colorWhite,
                                //                                                 border:
                                //                                                     Border
                                //                                                         .all(
                                //                                                   width: ScreenUtil()
                                //                                                       .setSp(1),
                                //                                                   color: muddaPost.leaders![index].joinerType! ==
                                //                                                           "creator"
                                //                                                       ? buttonBlue
                                //                                                       : muddaPost.leaders![index].joinerType! == "opposition"
                                //                                                           ? buttonYellow
                                //                                                           : white,
                                //                                                 ),
                                //                                                 borderRadius:
                                //                                                     BorderRadius.all(
                                //                                                         Radius.circular(ScreenUtil().setSp(20)) //                 <--- border radius here
                                //                                                         ),
                                //                                                 image: DecorationImage(
                                //                                                     image:
                                //                                                         imageProvider,
                                //                                                     fit: BoxFit
                                //                                                         .cover),
                                //                                               ),
                                //                                             ),
                                //                                             placeholder: (context,
                                //                                                     url) =>
                                //                                                 CircleAvatar(
                                //                                               backgroundColor:
                                //                                                   lightGray,
                                //                                               radius: ScreenUtil()
                                //                                                   .setSp(
                                //                                                       20),
                                //                                             ),
                                //                                             errorWidget: (context,
                                //                                                     url,
                                //                                                     error) =>
                                //                                                 CircleAvatar(
                                //                                               backgroundColor:
                                //                                                   lightGray,
                                //                                               radius: ScreenUtil()
                                //                                                   .setSp(
                                //                                                       20),
                                //                                             ),
                                //                                           )
                                //                                         : Container(
                                //                                             height:
                                //                                                 ScreenUtil()
                                //                                                     .setSp(
                                //                                                         40),
                                //                                             width: ScreenUtil()
                                //                                                 .setSp(
                                //                                                     40),
                                //                                             decoration:
                                //                                                 BoxDecoration(
                                //                                               border:
                                //                                                   Border
                                //                                                       .all(
                                //                                                 color:
                                //                                                     darkGray,
                                //                                               ),
                                //                                               shape: BoxShape
                                //                                                   .circle,
                                //                                             ),
                                //                                             child: Center(
                                //                                               child: Text(
                                //                                                   muddaPost
                                //                                                       .leaders![
                                //                                                           index]
                                //                                                       .acceptUserDetail!
                                //                                                       .fullname![
                                //                                                           0]
                                //                                                       .toUpperCase(),
                                //                                                   style: GoogleFonts.nunitoSans(
                                //                                                       fontWeight:
                                //                                                           FontWeight.w400,
                                //                                                       fontSize: ScreenUtil().setSp(20),
                                //                                                       color: black)),
                                //                                             ),
                                //                                           ),
                                //                                 Vs(height: 5.h),
                                //                                 Text(
                                //                                   muddaPost
                                //                                               .leaders![
                                //                                                   index]
                                //                                               .userIdentity ==
                                //                                           1
                                //                                       ? "${muddaPost.leaders![index].acceptUserDetail!.fullname}"
                                //                                       : "Anynymous",
                                //                                   style: size10_M_regular300(
                                //                                       letterSpacing: 0.0,
                                //                                       textColor:
                                //                                           colorDarkBlack),
                                //                                   textAlign:
                                //                                       TextAlign.center,
                                //                                 ),
                                //                               ],
                                //                             ),
                                //                           );
                                //                         }),
                                //                       ),
                                //                     ),
                                //                     Visibility(
                                //                       visible: muddaPost.leaders != null
                                //                           ? muddaPost.leaders!.length > 4
                                //                           : false,
                                //                       child: InkWell(
                                //                         onTap: () {
                                //                           if (muddaPost
                                //                                       .leaders![0]
                                //                                       .acceptUserDetail!
                                //                                       .sId ==
                                //                                   AppPreference()
                                //                                       .getString(
                                //                                           PreferencesKey
                                //                                               .userId) ||
                                //                               muddaPost
                                //                                       .leaders![0]
                                //                                       .acceptUserDetail!
                                //                                       .sId ==
                                //                                   AppPreference().getString(
                                //                                       PreferencesKey
                                //                                           .orgUserId)) {
                                //                             muddaNewsController.muddaPost
                                //                                 .value = muddaPost;
                                //                             muddaNewsController
                                //                                 .leaderBoardIndex
                                //                                 .value = 0;
                                //                             Get.toNamed(RouteConstants
                                //                                 .leaderBoardApproval);
                                //                           } else {
                                //                             Get.toNamed(
                                //                                 RouteConstants
                                //                                     .leaderBoard,
                                //                                 arguments: muddaPost);
                                //                           }
                                //                         },
                                //                         child: Row(
                                //                           children: [
                                //                             Icon(Icons.add, size: 15.sp),
                                //                             Column(
                                //                               mainAxisAlignment:
                                //                                   MainAxisAlignment
                                //                                       .center,
                                //                               children: [
                                //                                 Text(
                                //                                   muddaPost.leaders !=
                                //                                           null
                                //                                       ? "${muddaPost.leadersCount! - 4}"
                                //                                       : "",
                                //                                   style: size12_M_normal(
                                //                                       textColor:
                                //                                           colorDarkBlack),
                                //                                 ),
                                //                                 Vs(
                                //                                   height: 10.h,
                                //                                 ),
                                //                                 Image.asset(
                                //                                   AppIcons.nextLongArrow,
                                //                                   height: 8.h,
                                //                                 ),
                                //                               ],
                                //                             )
                                //                           ],
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ],
                                //                 ),
                                //               ),
                                //               const Vs(height: 10),
                                //               Container(
                                //                 width: double.infinity,
                                //                 height: 1,
                                //                 color: colorF2F2F2,
                                //               ),
                                //               Obx(
                                //                 () => Row(
                                //                   crossAxisAlignment:
                                //                       CrossAxisAlignment.center,
                                //                   children: [
                                //                     Expanded(
                                //                       child: Stack(
                                //                         children: [
                                //                           Visibility(
                                //                             visible: muddaNewsController
                                //                                     .muddaAction.value ||
                                //                                 index !=
                                //                                     muddaNewsController
                                //                                         .muddaActionIndex
                                //                                         .value,
                                //                             child: muddaPost.mySupport==null
                                //                                 ? Row(
                                //                                     mainAxisAlignment:
                                //                                         MainAxisAlignment
                                //                                             .center,
                                //                                     children: [
                                //                                       InkWell(
                                //                                         onTap: () {
                                //                                           if (AppPreference()
                                //                                               .getBool(
                                //                                                   PreferencesKey
                                //                                                       .isGuest)) {
                                //                                             Get.toNamed(
                                //                                                 RouteConstants
                                //                                                     .userProfileEdit);
                                //                                           } else {
                                //                                             Api.post.call(
                                //                                               context,
                                //                                               method:
                                //                                                   "mudda/support",
                                //                                               param: {
                                //                                                 "muddaId":
                                //                                                     muddaPost
                                //                                                         .sId,
                                //                                                 "support": true,
                                //                                               },
                                //                                               onResponseSuccess:
                                //                                                   (object) {
                                //                                                 muddaPost
                                //                                                     .afterMe = object['data'] !=
                                //                                                         null
                                //                                                     ? AfterMe.fromJson(
                                //                                                         object['data'])
                                //                                                     : null;
                                //                                                 if (muddaPost.mySupport ==
                                //                                                     true) {
                                //                                                   muddaPost.mySupport =
                                //                                                   null;
                                //                                                   muddaPost
                                //                                                       .support =
                                //                                                       muddaPost.support! -
                                //                                                           1;
                                //                                                   muddaPost.totalVote! -
                                //                                                       1;
                                //
                                //                                                 } else {
                                //                                                   muddaPost
                                //                                                       .support =
                                //                                                       muddaPost.support! +
                                //                                                           1;
                                //                                                   muddaPost.totalVote! +
                                //                                                       1;
                                //
                                //                                                   muddaPost.mySupport =
                                //                                                   true;
                                //                                                 }
                                //
                                //                                                 muddaNewsController
                                //                                                         .followingMuddaPostList[index] =
                                //                                                     muddaPost;
                                //                                                 muddaNewsController
                                //                                                     .muddaActionIndex
                                //                                                     .value = index;
                                //                                               },
                                //                                             );
                                //                                           }
                                //                                         },
                                //                                         child: Stack(
                                //                                           alignment: Alignment
                                //                                               .centerLeft,
                                //                                           children: [
                                //                                             Container(
                                //                                               height: 30,
                                //                                               width: 100,
                                //                                               margin: EdgeInsets
                                //                                                   .only(
                                //                                                       left:
                                //                                                           25),
                                //                                               alignment:
                                //                                                   Alignment
                                //                                                       .center,
                                //                                               decoration:
                                //                                                   BoxDecoration(
                                //                                                 color: Colors
                                //                                                     .white,
                                //                                                 border: Border.all(
                                //                                                     color:
                                //                                                         colorA0A0A0),
                                //                                                 borderRadius:
                                //                                                     BorderRadius.circular(
                                //                                                         10),
                                //                                               ),
                                //                                               child: Text(
                                //                                                 "Support",
                                //                                                 style: size12_M_regular300(
                                //                                                     textColor:
                                //                                                         colorDarkBlack),
                                //                                               ),
                                //                                             ),
                                //                                             Container(
                                //                                               height: 40,
                                //                                               width: 40,
                                //                                               alignment:
                                //                                                   Alignment
                                //                                                       .center,
                                //                                               child: SizedBox(
                                //                                                   height:
                                //                                                       20,
                                //                                                   width:
                                //                                                       20,
                                //                                                   child: Image.asset(
                                //                                                       AppIcons.shakeHandIcon)),
                                //                                               decoration:
                                //                                                   BoxDecoration(
                                //                                                 color: Colors
                                //                                                     .white,
                                //                                                 shape: BoxShape
                                //                                                     .circle,
                                //                                                 border: Border.all(
                                //                                                     color:
                                //                                                         colorA0A0A0),
                                //                                               ),
                                //                                             ),
                                //                                           ],
                                //                                         ),
                                //                                       ),
                                //                                       Hs(width: 10),
                                //                                       InkWell(
                                //                                         onTap: () {
                                //                                           if (AppPreference()
                                //                                               .getBool(
                                //                                                   PreferencesKey
                                //                                                       .isGuest)) {
                                //                                             Get.toNamed(
                                //                                                 RouteConstants
                                //                                                     .userProfileEdit);
                                //                                           } else {
                                //                                             Api.post.call(
                                //                                               context,
                                //                                               method:
                                //                                                   "mudda/support",
                                //                                               param: {
                                //                                                 "muddaId": muddaPost.sId,
                                //                                                 "support": false,
                                //                                               },
                                //                                               onResponseSuccess: (object) {
                                //                                                 muddaPost
                                //                                                     .afterMe = object['data'] !=
                                //                                                         null
                                //                                                     ? AfterMe.fromJson(
                                //                                                         object['data'])
                                //                                                     : null;
                                //                                                 if (muddaPost.mySupport ==
                                //                                                     false) {
                                //                                                   muddaPost.mySupport =
                                //                                                   null;
                                //                                                   muddaPost.totalVote! -
                                //                                                       1;
                                //                                                 } else {
                                //
                                //                                                   muddaPost.totalVote! +
                                //                                                       1;
                                //
                                //                                                   muddaPost.mySupport =
                                //                                                   false;
                                //                                                 }
                                //                                                 muddaNewsController
                                //                                                         .followingMuddaPostList[index] =
                                //                                                     muddaPost;
                                //                                                 muddaNewsController
                                //                                                     .muddaActionIndex
                                //                                                     .value = index;
                                //                                               },
                                //                                             );
                                //                                           }
                                //                                         },
                                //                                         child: Stack(
                                //                                           alignment: Alignment
                                //                                               .centerLeft,
                                //                                           children: [
                                //                                             Container(
                                //                                               height: 30,
                                //                                               width: 100,
                                //                                               margin: EdgeInsets
                                //                                                   .only(
                                //                                                       left:
                                //                                                           25),
                                //                                               alignment:
                                //                                                   Alignment
                                //                                                       .center,
                                //                                               padding: const EdgeInsets
                                //                                                       .only(
                                //                                                   left:
                                //                                                       10),
                                //                                               decoration:
                                //                                                   BoxDecoration(
                                //                                                 color: Colors
                                //                                                     .white,
                                //                                                 border: Border.all(
                                //                                                     color:
                                //                                                         colorA0A0A0),
                                //                                                 borderRadius:
                                //                                                     BorderRadius.circular(
                                //                                                         10),
                                //                                               ),
                                //                                               child: Text(
                                //                                                 "Not Support",
                                //                                                 style: size12_M_regular300(
                                //                                                     textColor:
                                //                                                         colorDarkBlack),
                                //                                               ),
                                //                                             ),
                                //                                             Container(
                                //                                               height: 40,
                                //                                               width: 40,
                                //                                               alignment:
                                //                                                   Alignment
                                //                                                       .center,
                                //                                               child: SizedBox(
                                //                                                   height:
                                //                                                       15,
                                //                                                   width:
                                //                                                       15,
                                //                                                   child: Image.asset(
                                //                                                       AppIcons.dislike)),
                                //                                               decoration:
                                //                                                   BoxDecoration(
                                //                                                 color: Colors
                                //                                                     .white,
                                //                                                 shape: BoxShape
                                //                                                     .circle,
                                //                                                 border: Border.all(
                                //                                                     color:
                                //                                                         colorA0A0A0),
                                //                                               ),
                                //                                             ),
                                //                                           ],
                                //                                         ),
                                //                                       ),
                                //                                     ],
                                //                                   )
                                //                                 : Row(
                                //                                     children: [
                                //                                       InkWell(
                                //                                         onTap: () {
                                //                                           if (AppPreference()
                                //                                               .getBool(
                                //                                                   PreferencesKey
                                //                                                       .isGuest)) {
                                //                                             Get.toNamed(
                                //                                                 RouteConstants
                                //                                                     .userProfileEdit);
                                //                                           } else {
                                //                                             Api.post.call(
                                //                                               context,
                                //                                               method:
                                //                                                   "mudda/support",
                                //                                               param: {
                                //                                                 "muddaId":
                                //                                                 muddaPost
                                //                                                     .sId,
                                //                                                 "support": true,
                                //                                               },
                                //                                               onResponseSuccess:
                                //                                                   (object) {
                                //                                                 print(
                                //                                                     object);
                                //                                                 muddaPost
                                //                                                     .afterMe = object['data'] !=
                                //                                                         null
                                //                                                     ? AfterMe.fromJson(
                                //                                                         object['data'])
                                //                                                     : null;
                                //                                                 if (muddaPost.mySupport ==
                                //                                                     true) {
                                //                                                   muddaPost.mySupport =
                                //                                                   null;
                                //                                                   muddaPost
                                //                                                       .support =
                                //                                                       muddaPost.support! -
                                //                                                           1;
                                //                                                   muddaPost.totalVote! -
                                //                                                       1;
                                //
                                //                                                 } else {
                                //                                                   muddaPost
                                //                                                       .support =
                                //                                                       muddaPost.support! +
                                //                                                           1;
                                //                                                   muddaPost.totalVote! +
                                //                                                       1;
                                //                                                   muddaPost.mySupport =
                                //                                                   true;
                                //                                                 }
                                //                                                 muddaNewsController
                                //                                                         .followingMuddaPostList[index] =
                                //                                                     muddaPost;
                                //                                                 muddaNewsController
                                //                                                     .muddaActionIndex
                                //                                                     .value = index;
                                //                                               },
                                //                                             );
                                //                                           }
                                //                                         },
                                //                                         child: Container(
                                //                                           height: 40,
                                //                                           width: 40,
                                //                                           alignment:
                                //                                               Alignment
                                //                                                   .center,
                                //                                           child: SizedBox(
                                //                                               height: 20,
                                //                                               width: 20,
                                //                                               child: Image.asset(
                                //                                                   AppIcons
                                //                                                       .shakeHandIcon,
                                //                                                   color: muddaPost.mySupport ==
                                //                                                           true
                                //                                                       ? Colors.white
                                //                                                       : blackGray)),
                                //                                           decoration:
                                //                                               BoxDecoration(
                                //                                             color: muddaPost.mySupport !=
                                //                                                     true
                                //                                                 ? Colors
                                //                                                     .white
                                //                                                 : blackGray,
                                //                                             shape: BoxShape
                                //                                                 .circle,
                                //                                             border: Border
                                //                                                 .all(
                                //                                                     color:
                                //                                                         blackGray),
                                //                                           ),
                                //                                         ),
                                //                                       ),
                                //                                       Hs(width: 18),
                                //                                       InkWell(
                                //                                         onTap: () {
                                //                                           if (AppPreference()
                                //                                               .getBool(
                                //                                                   PreferencesKey
                                //                                                       .isGuest)) {
                                //                                             Get.toNamed(
                                //                                                 RouteConstants
                                //                                                     .userProfileEdit);
                                //                                           } else {
                                //                                             Api.post.call(
                                //                                               context,
                                //                                               method: "mudda/support",
                                //                                               param: {
                                //                                                 "muddaId": muddaPost.sId,
                                //                                                 "support": false,
                                //                                               },
                                //                                               onResponseSuccess:
                                //                                                   (object) {
                                //                                                 muddaPost
                                //                                                     .afterMe = object['data'] !=
                                //                                                         null
                                //                                                     ? AfterMe.fromJson(
                                //                                                         object['data'])
                                //                                                     : null;
                                //
                                //                                                 if (muddaPost.mySupport ==
                                //                                                     false) {
                                //                                                   muddaPost.mySupport =
                                //                                                   null;
                                //                                                   muddaPost.totalVote! -
                                //                                                       1;
                                //                                                 } else {
                                //
                                //                                                   muddaPost.totalVote! +
                                //                                                       1;
                                //
                                //                                                   muddaPost.mySupport =
                                //                                                   false;
                                //                                                 }
                                //                                                 muddaNewsController
                                //                                                         .followingMuddaPostList[index] =
                                //                                                     muddaPost;
                                //                                                 muddaNewsController
                                //                                                     .muddaActionIndex
                                //                                                     .value = index;
                                //                                               },
                                //                                             );
                                //                                           }
                                //                                         },
                                //                                         child: Container(
                                //                                           height: 40,
                                //                                           width: 40,
                                //                                           alignment:
                                //                                               Alignment
                                //                                                   .center,
                                //                                           child: SizedBox(
                                //                                               height: 15,
                                //                                               width: 15,
                                //                                               child: Image.asset(
                                //                                                   AppIcons
                                //                                                       .dislike,
                                //                                                   color: muddaPost.mySupport ==
                                //                                                           false
                                //                                                       ? Colors.white
                                //                                                       : blackGray)),
                                //                                           decoration:
                                //                                               BoxDecoration(
                                //                                             color: muddaPost
                                //                                                         .mySupport !=
                                //                                                 false
                                //                                                 ? Colors
                                //                                                     .white
                                //                                                 : blackGray,
                                //                                             shape: BoxShape
                                //                                                 .circle,
                                //                                             border: Border
                                //                                                 .all(
                                //                                                     color:
                                //                                                         blackGray),
                                //                                           ),
                                //                                         ),
                                //                                       ),
                                //                                       Hs(width: 17),
                                //                                       muddaPost.afterMe !=
                                //                                               null
                                //                                           ? Column(
                                //                                               crossAxisAlignment:
                                //                                                   CrossAxisAlignment
                                //                                                       .start,
                                //                                               children: [
                                //                                                 Text(
                                //                                                     "Recent Updates:",
                                //                                                     style: GoogleFonts.nunitoSans(
                                //                                                         fontWeight: FontWeight.w400,
                                //                                                         fontSize: ScreenUtil().setSp(12),
                                //                                                         color: black)),
                                //                                                 Text(
                                //                                                     "${NumberFormat.compactCurrency(
                                //                                                       decimalDigits:
                                //                                                           0,
                                //                                                       symbol:
                                //                                                           '', // if you want to add currency symbol then pass that in this else leave it empty.
                                //                                                     ).format(muddaPost.support! - muddaPost.afterMe!.totalSupport!)} New supports\n${muddaPost.totalFavourPost! > 0 ? NumberFormat.compactCurrency(
                                //                                                         decimalDigits: 0,
                                //                                                         symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
                                //                                                       ).format((100 * muddaPost.afterMe!.totalFavourPost!) / muddaPost.totalFavourPost!) : '0'}% Up,${NumberFormat.compactCurrency(
                                //                                                       decimalDigits:
                                //                                                           0,
                                //                                                       symbol:
                                //                                                           '', // if you want to add currency symbol then pass that in this else leave it empty.
                                //                                                     ).format(muddaPost.totalPost! - muddaPost.afterMe!.totalPost!)} new posts\n${NumberFormat.compactCurrency(
                                //                                                       decimalDigits:
                                //                                                           0,
                                //                                                       symbol:
                                //                                                           '', // if you want to add currency symbol then pass that in this else leave it empty.
                                //                                                     ).format(muddaPost.leadersCount! - muddaPost.afterMe!.totalLeaderJoin!)} New Leaders Joined.",
                                //                                                     style: GoogleFonts.nunitoSans(
                                //                                                         fontWeight: FontWeight.w700,
                                //                                                         fontSize: ScreenUtil().setSp(10),
                                //                                                         color: buttonBlue)),
                                //                                               ],
                                //                                             )
                                //                                           : Container()
                                //                                     ],
                                //                                   ),
                                //                           ),
                                //                           Visibility(
                                //                             visible: muddaNewsController
                                //                                     .muddaDescripation
                                //                                     .value &&
                                //                                 index ==
                                //                                     muddaNewsController
                                //                                         .muddaActionIndex
                                //                                         .value,
                                //                             child: muddaPost.muddaDescription!.isNotEmpty &&
                                //                                     muddaPost.muddaDescription!.length >
                                //                                         3
                                //                                 ? ReadMoreText(
                                //                                     'Description: ${muddaPost.muddaDescription}',
                                //                                     trimLines: 3,
                                //                                     trimMode:
                                //                                         TrimMode.Line,
                                //                                     style: GoogleFonts
                                //                                         .nunitoSans(
                                //                                             fontSize:
                                //                                                 ScreenUtil()
                                //                                                     .setSp(
                                //                                                         12),
                                //                                             fontWeight:
                                //                                                 FontWeight
                                //                                                     .w400,
                                //                                             color: black),
                                //                                   )
                                //                                 : muddaPost
                                //                                         .muddaDescription!
                                //                                         .isNotEmpty
                                //                                     ? Text("Description: ${muddaPost.muddaDescription}",
                                //                                         style: GoogleFonts.nunitoSans(
                                //                                             fontSize: ScreenUtil()
                                //                                                 .setSp(
                                //                                                     12),
                                //                                             fontWeight:
                                //                                                 FontWeight
                                //                                                     .w400,
                                //                                             color: black))
                                //                                     : Text("Description:",
                                //                                         style: GoogleFonts.nunitoSans(
                                //                                             fontSize: ScreenUtil().setSp(12),
                                //                                             fontWeight: FontWeight.w400,
                                //                                             color: black)),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                     ),
                                //                     Column(
                                //                       children: [
                                //                         InkWell(
                                //                           onTap: () {
                                //                             muddaPost.muddaDescripation =
                                //                                 true;
                                //                             muddaPost.muddaAction = false;
                                //                             muddaNewsController
                                //                                 .muddaAction
                                //                                 .value = false;
                                //                             muddaNewsController
                                //                                 .muddaDescripation
                                //                                 .value = true;
                                //                             muddaNewsController
                                //                                 .muddaActionIndex
                                //                                 .value = index;
                                //                           },
                                //                           child: muddaNewsController
                                //                                       .muddaDescripation
                                //                                       .value &&
                                //                                   index ==
                                //                                       muddaNewsController
                                //                                           .muddaActionIndex
                                //                                           .value
                                //                               ? Container(
                                //                                   decoration:
                                //                                       const BoxDecoration(
                                //                                     color: blackGray,
                                //                                     borderRadius: BorderRadius.only(
                                //                                         topRight: Radius
                                //                                             .circular(0),
                                //                                         bottomRight:
                                //                                             Radius
                                //                                                 .circular(
                                //                                                     0),
                                //                                         topLeft: Radius
                                //                                             .circular(8),
                                //                                         bottomLeft: Radius
                                //                                             .circular(8)),
                                //                                   ),
                                //                                   padding:
                                //                                       const EdgeInsets
                                //                                               .only(
                                //                                           top: 12,
                                //                                           bottom: 12,
                                //                                           left: 5,
                                //                                           right: 5),
                                //                                   child: SvgPicture.asset(
                                //                                       "assets/svg/description.svg",
                                //                                       color: white),
                                //                                 )
                                //                               : Container(
                                //                                   decoration:
                                //                                       const BoxDecoration(
                                //                                     color: gray,
                                //                                     borderRadius: BorderRadius.only(
                                //                                         topRight: Radius
                                //                                             .circular(0),
                                //                                         bottomRight:
                                //                                             Radius
                                //                                                 .circular(
                                //                                                     0),
                                //                                         topLeft: Radius
                                //                                             .circular(8),
                                //                                         bottomLeft: Radius
                                //                                             .circular(8)),
                                //                                   ),
                                //                                   padding:
                                //                                       const EdgeInsets
                                //                                               .only(
                                //                                           top: 12,
                                //                                           bottom: 12,
                                //                                           left: 5,
                                //                                           right: 5),
                                //                                   child: SvgPicture.asset(
                                //                                       "assets/svg/description.svg",
                                //                                       color: blackGray),
                                //                                 ),
                                //                         ),
                                //                         InkWell(
                                //                           onTap: () {
                                //                             muddaPost.muddaAction = true;
                                //                             muddaPost.muddaDescripation =
                                //                                 false;
                                //                             muddaNewsController
                                //                                 .muddaDescripation
                                //                                 .value = false;
                                //                             muddaNewsController
                                //                                 .muddaAction.value = true;
                                //                             muddaNewsController
                                //                                 .muddaActionIndex
                                //                                 .value = index;
                                //                           },
                                //                           child: muddaNewsController
                                //                                       .muddaAction
                                //                                       .value ||
                                //                                   index !=
                                //                                       muddaNewsController
                                //                                           .muddaActionIndex
                                //                                           .value
                                //                               ? Container(
                                //                                   decoration:
                                //                                       const BoxDecoration(
                                //                                     color: blackGray,
                                //                                     borderRadius: BorderRadius.only(
                                //                                         topRight: Radius
                                //                                             .circular(0),
                                //                                         bottomRight:
                                //                                             Radius
                                //                                                 .circular(
                                //                                                     0),
                                //                                         topLeft: Radius
                                //                                             .circular(8),
                                //                                         bottomLeft: Radius
                                //                                             .circular(8)),
                                //                                   ),
                                //                                   padding:
                                //                                       const EdgeInsets
                                //                                               .only(
                                //                                           top: 12,
                                //                                           bottom: 12,
                                //                                           left: 5,
                                //                                           right: 5),
                                //                                   child: SvgPicture.asset(
                                //                                       "assets/svg/action.svg",
                                //                                       color: white),
                                //                                 )
                                //                               : Container(
                                //                                   decoration:
                                //                                       const BoxDecoration(
                                //                                     color: gray,
                                //                                     borderRadius: BorderRadius.only(
                                //                                         topRight: Radius
                                //                                             .circular(0),
                                //                                         bottomRight:
                                //                                             Radius
                                //                                                 .circular(
                                //                                                     0),
                                //                                         topLeft: Radius
                                //                                             .circular(8),
                                //                                         bottomLeft: Radius
                                //                                             .circular(8)),
                                //                                   ),
                                //                                   padding:
                                //                                       const EdgeInsets
                                //                                               .only(
                                //                                           top: 12,
                                //                                           bottom: 12,
                                //                                           left: 5,
                                //                                           right: 5),
                                //                                   child: SvgPicture.asset(
                                //                                       "assets/svg/action.svg",
                                //                                       color: blackGray),
                                //                                 ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ],
                                //                 ),
                                //               ),
                                //               Container(
                                //                 width: double.infinity,
                                //                 height: 1,
                                //                 color: colorF2F2F2,
                                //               ),
                                //               const Vs(
                                //                 height: 4,
                                //               ),
                                //               Row(
                                //                 children: [
                                //                   Expanded(
                                //                     child: Text(
                                //                         muddaPost.hashtags!.join(','),
                                //                         style: size10_M_normal(
                                //                             textColor: colorDarkBlack)),
                                //                   ),
                                //                   const Hs(width: 10),
                                //                   Row(
                                //                     children: [
                                //                       Container(
                                //                         padding: const EdgeInsets.all(2),
                                //                         decoration: const BoxDecoration(
                                //                             shape: BoxShape.circle,
                                //                             color: colorDarkBlack),
                                //                       ),
                                //                       const Hs(width: 5),
                                //                       Text(
                                //                           "${muddaPost.city ?? ""}, ${muddaPost.state ?? ""}, ${muddaPost.country ?? ""}",
                                //                           style: size12_M_normal(
                                //                               textColor: colorDarkBlack)),
                                //                     ],
                                //                   ),
                                //                   const Hs(width: 10),
                                //                   Container(
                                //                     padding: const EdgeInsets.all(2),
                                //                     decoration: const BoxDecoration(
                                //                         shape: BoxShape.circle,
                                //                         color: colorDarkBlack),
                                //                   ),
                                //                   const Hs(width: 5),
                                //                   Text(
                                //                       convertToAgo(DateTime.parse(
                                //                           muddaPost.createdAt!)),
                                //                       style: size10_M_normal(
                                //                           textColor: colorDarkBlack)),
                                //                 ],
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       );
                              }),
                    ),
            ],
          ),
        ));
  }

  anynymousDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.5),
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Container(
              height: ScreenUtil().setSp(97),
              width: ScreenUtil().screenWidth - ScreenUtil().setSp(50),
              decoration: const BoxDecoration(color: Colors.white),
              child: Material(
                child: commonPostText(
                  text: "Anonymous user profiles can be visited or contacted.",
                  onPressed: () {
                    Get.back();
                  },
                  color: Colors.black,
                  size: 12,
                ),
              ),
            ),
          ),
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
    Api.get.call(context,
        method: "mudda/my-engagement",
        param: {
          "page": page.toString(),
          "filterType": "follow",
          "user_id": AppPreference().getString(PreferencesKey.userId)
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = MuddaPostModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        muddaNewsController.muddaProfilePath.value = result.path!;
        muddaNewsController.muddaUserProfilePath.value = result.userpath!;
        muddaNewsController.followingMuddaPostList.clear();
        muddaNewsController.followingMuddaPostList.addAll(result.data!);
      } else {
        page = page > 1 ? page - 1 : page;
      }
    });
  }
}
